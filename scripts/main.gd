# PROTOTYPE - NOT FOR PRODUCTION
# Question: Does typing a prompt, then watching a SayMotion-generated
# animation reveal on a Godot character, produce a moment a group of
# testers finds funny/engaging enough to ask for another round?
# Date: 2026-08-27

extends Node3D

enum State { SECRET_WORD, PROMPT_ENTRY, GENERATING, REVEAL, GUESSING, RESULTS }

const SECRET_WORDS := [
	"a startled kangaroo",
	"a robot doing the dishes",
	"a ghost sneaking past a guard",
	"a penguin trying to fly",
	"a superhero landing pose gone wrong",
	"someone slipping on ice",
	"a cat knocking something off a table",
	"a dramatic villain reveal",
]

const GUESSING_DURATION := 30.0

var current_state: State = State.SECRET_WORD
var current_word: String = ""
var current_prompt: String = ""
var generating_timer: float = 0.0
var guessing_timer: float = 0.0
var funniest_fail_votes: int = 0
var loaded_character: Node = null
var saymotion_client: SayMotionClient
var _generation_active: bool = false

@onready var state_label: Label = $UI/StateLabel
@onready var secret_word_label: Label = $UI/SecretWordLabel
@onready var prompt_input: LineEdit = $UI/PromptInput
@onready var countdown_label: Label = $UI/CountdownLabel
@onready var generating_message_label: Label = $UI/GeneratingMessageLabel
@onready var load_animation_button: Button = $UI/LoadAnimationButton
@onready var file_dialog: FileDialog = $UI/FileDialog
@onready var next_button: Button = $UI/NextButton
@onready var answer_label: Label = $UI/AnswerLabel
@onready var funniest_fail_button: Button = $UI/FunniestFailButton
@onready var restart_button: Button = $UI/RestartButton
@onready var character_slot: Node3D = $CharacterSlot


func _ready() -> void:
	randomize()
	saymotion_client = SayMotionClient.new()
	add_child(saymotion_client)
	load_animation_button.pressed.connect(_on_load_animation_pressed)
	file_dialog.file_selected.connect(_on_glb_file_selected)
	next_button.pressed.connect(_on_next_pressed)
	funniest_fail_button.pressed.connect(_on_funniest_fail_pressed)
	restart_button.pressed.connect(_on_restart_pressed)
	_enter_state(State.SECRET_WORD)


func _process(delta: float) -> void:
	match current_state:
		State.GENERATING:
			generating_timer += delta
			countdown_label.text = "Elapsed: %ds" % int(generating_timer)
		State.GUESSING:
			guessing_timer -= delta
			countdown_label.text = "Guess! %ds left" % max(int(guessing_timer), 0)
			if guessing_timer <= 0.0:
				_enter_state(State.RESULTS)


func _enter_state(new_state: State) -> void:
	current_state = new_state
	state_label.text = "STATE: %s" % State.keys()[new_state]

	secret_word_label.visible = false
	prompt_input.visible = false
	countdown_label.visible = false
	generating_message_label.visible = false
	load_animation_button.visible = false
	next_button.visible = false
	answer_label.visible = false
	funniest_fail_button.visible = false
	restart_button.visible = false

	match new_state:
		State.SECRET_WORD:
			current_word = SECRET_WORDS[randi() % SECRET_WORDS.size()]
			secret_word_label.text = "DIRECTOR SECRET WORD:\n%s\n\n(don't say it out loud!)" % current_word
			secret_word_label.visible = true
			next_button.text = "Director has seen it -> continue"
			next_button.visible = true
		State.PROMPT_ENTRY:
			prompt_input.text = ""
			prompt_input.placeholder_text = "Type a motion description without saying the word..."
			prompt_input.visible = true
			next_button.text = "Submit -> start generating"
			next_button.visible = true
		State.GENERATING:
			current_prompt = prompt_input.text
			generating_timer = 0.0
			countdown_label.visible = true
			generating_message_label.visible = true
			load_animation_button.visible = true
			generating_message_label.text = "Starting live SayMotion generation..."
			_run_generation_flow(current_prompt)
			# "Load Animation File" stays available as a manual fallback in
			# case the live API call fails or times out.
		State.REVEAL:
			next_button.text = "Start guessing timer"
			next_button.visible = true
		State.GUESSING:
			guessing_timer = GUESSING_DURATION
			countdown_label.visible = true
			next_button.text = "Reveal answer now"
			next_button.visible = true
		State.RESULTS:
			_update_answer_label()
			answer_label.visible = true
			funniest_fail_button.visible = true
			restart_button.visible = true


func _update_answer_label() -> void:
	answer_label.text = "The word was: %s\nPrompt used: \"%s\"\nFunniest-fail votes: %d" % [
		current_word, current_prompt, funniest_fail_votes
	]


func _on_next_pressed() -> void:
	match current_state:
		State.SECRET_WORD:
			_enter_state(State.PROMPT_ENTRY)
		State.PROMPT_ENTRY:
			_enter_state(State.GENERATING)
		State.REVEAL:
			_enter_state(State.GUESSING)
		State.GUESSING:
			_enter_state(State.RESULTS)


func _on_load_animation_pressed() -> void:
	file_dialog.popup_centered()


func _on_glb_file_selected(path: String) -> void:
	_load_glb_from_path(path)


# Live SayMotion API flow: auth (if needed) -> submit job -> poll -> download
# -> load. Any failure leaves the "Load Animation File" manual button as a
# fallback rather than blocking the round.
func _run_generation_flow(prompt: String) -> void:
	if _generation_active:
		return
	_generation_active = true

	if not saymotion_client.has_credentials():
		generating_message_label.text = "No .env credentials found - use manual Load Animation File button"
		_generation_active = false
		return

	if not saymotion_client.is_authenticated():
		generating_message_label.text = "Authenticating with SayMotion..."
		var auth_ok: bool = await saymotion_client.authenticate()
		if not auth_ok:
			generating_message_label.text = "Auth FAILED - check .env credentials, or use manual Load button"
			_generation_active = false
			return

	generating_message_label.text = "Submitting generation job..."
	var rid: String = await saymotion_client.submit_job(prompt)
	if rid == "":
		generating_message_label.text = "Job submit FAILED - see console, or use manual Load button"
		_generation_active = false
		return

	generating_message_label.text = "Generating (rid %s)..." % rid
	var status: String = await saymotion_client.poll_until_done(rid, 90.0)
	if status != "SUCCESS":
		generating_message_label.text = "Generation %s - use manual Load Animation button as fallback" % status
		_generation_active = false
		return

	generating_message_label.text = "Fetching download link..."
	var download_url: String = await saymotion_client.get_download_url(rid)
	if download_url == "":
		generating_message_label.text = "No .glb download URL found - use manual Load button"
		_generation_active = false
		return

	var save_path := "user://saymotion_%s.glb" % rid.replace("/", "_")
	generating_message_label.text = "Downloading animation..."
	var ok: bool = await saymotion_client.download_to_file(download_url, save_path)
	_generation_active = false
	if not ok:
		generating_message_label.text = "Download FAILED - use manual Load button"
		return

	_load_glb_from_path(ProjectSettings.globalize_path(save_path))


func _load_glb_from_path(path: String) -> void:
	_clear_character()

	var gltf_document := GLTFDocument.new()
	var gltf_state := GLTFState.new()
	var err := gltf_document.append_from_file(path, gltf_state)
	if err != OK:
		countdown_label.text = "FAILED to load GLB (error %d) - check the file and try again" % err
		return

	var scene := gltf_document.generate_scene(gltf_state)
	if scene == null:
		countdown_label.text = "GLB loaded but scene generation failed"
		return

	character_slot.add_child(scene)
	loaded_character = scene
	_play_first_animation(scene)
	_enter_state(State.REVEAL)


func _play_first_animation(root: Node) -> void:
	var anim_player := _find_animation_player(root)
	if anim_player == null:
		push_warning("No AnimationPlayer found in loaded GLB scene")
		return
	var anim_list := anim_player.get_animation_list()
	if anim_list.size() > 0:
		anim_player.play(anim_list[0])


func _find_animation_player(node: Node) -> AnimationPlayer:
	if node is AnimationPlayer:
		return node
	for child in node.get_children():
		var found := _find_animation_player(child)
		if found != null:
			return found
	return null


func _clear_character() -> void:
	if loaded_character != null:
		loaded_character.queue_free()
		loaded_character = null


func _on_funniest_fail_pressed() -> void:
	funniest_fail_votes += 1
	_update_answer_label()


func _on_restart_pressed() -> void:
	_clear_character()
	funniest_fail_votes = 0
	_enter_state(State.SECRET_WORD)
