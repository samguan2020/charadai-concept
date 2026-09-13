# PROTOTYPE - NOT FOR PRODUCTION
# Minimal SayMotion REST API client for the CharadAI concept prototype.
# API shape per github.com/DeepMotion/SayMotion-REST-API. This is a
# throwaway client-side integration for local prototype testing only -
# a production build must never ship API secrets inside a game client;
# it needs a server-side relay. See game-concept.md Technical Risks.
#
# Credentials are read from a local, gitignored .env file at
# prototypes/charadai-concept/.env - never hardcode credentials here.
extends Node
class_name SayMotionClient

signal generation_progress(status_text: String)

var _base_url: String = ""
var _client_id: String = ""
var _client_secret: String = ""
var _session_cookie: String = ""
var _model_id: String = ""

var _http: HTTPRequest


func _ready() -> void:
	_http = HTTPRequest.new()
	add_child(_http)
	var env := _load_env()
	_client_id = env.get("SAYMOTION_CLIENT_ID", "")
	_client_secret = env.get("SAYMOTION_CLIENT_SECRET", "")
	_base_url = env.get("SAYMOTION_API_URL", "").trim_suffix("/")


func _load_env() -> Dictionary:
	var env := {}
	var file := FileAccess.open("res://.env", FileAccess.READ)
	if file == null:
		push_error("Could not open res://.env - create prototypes/charadai-concept/.env (see README.md)")
		return env
	while not file.eof_reached():
		var line := file.get_line().strip_edges()
		if line.is_empty() or line.begins_with("#"):
			continue
		var parts := line.split("=", false, 1)
		if parts.size() == 2:
			env[parts[0].strip_edges()] = parts[1].strip_edges()
	file.close()
	return env


func has_credentials() -> bool:
	return _client_id != "" and _client_secret != "" and _base_url != ""


func is_authenticated() -> bool:
	return _session_cookie != ""


func authenticate() -> bool:
	var auth_header := "Authorization: Basic " + Marshalls.utf8_to_base64(_client_id + ":" + _client_secret)
	var err := _http.request(_base_url + "/account/v1/auth", [auth_header], HTTPClient.METHOD_GET)
	if err != OK:
		push_error("Auth request failed to send: %d" % err)
		return false
	var result: Array = await _http.request_completed
	var response_code: int = result[1]
	var headers: PackedStringArray = result[2]
	if response_code != 200:
		push_error("Auth failed with HTTP %d" % response_code)
		return false
	_session_cookie = _extract_cookie(headers, "dmsess")
	return _session_cookie != ""


func _extract_cookie(headers: PackedStringArray, cookie_name: String) -> String:
	for header in headers:
		if header.to_lower().begins_with("set-cookie:"):
			var value_part := header.substr(header.find(":") + 1).strip_edges()
			var first_segment := value_part.split(";")[0].strip_edges()
			if first_segment.begins_with(cookie_name + "="):
				return first_segment
	return ""


# The API requires a "model" param naming a character model ID the account
# owns (confirmed against the official SDK - job submission 500s with
# "model not found" if omitted). Lazily fetches and caches the account's
# first available model on first use.
func _ensure_model_id() -> bool:
	if _model_id != "":
		return true
	var headers := ["Cookie: " + _session_cookie]
	var err := _http.request(_base_url + "/character/v1/listModels?stockModel=all", headers, HTTPClient.METHOD_GET)
	if err != OK:
		push_error("List character models failed to send: %d" % err)
		return false
	var result: Array = await _http.request_completed
	var response_code: int = result[1]
	var response_body: PackedByteArray = result[3]
	if response_code != 200:
		push_error("List character models failed with HTTP %d: %s" % [response_code, response_body.get_string_from_utf8()])
		return false
	var parsed = JSON.parse_string(response_body.get_string_from_utf8())
	var models: Array = []
	if parsed is Array:
		models = parsed
	elif parsed is Dictionary and parsed.has("list"):
		models = parsed["list"]
	if models.is_empty():
		push_error("No character models available on this SayMotion account")
		return false
	_model_id = models[0].get("id", models[0].get("Id", ""))
	return _model_id != ""


func submit_job(prompt: String) -> String:
	if not await _ensure_model_id():
		return ""
	var body := JSON.stringify({
		"params": [
			'prompt="%s"' % prompt,
			"model=%s" % _model_id,
			"numVariant=1",
		]
	})
	var headers := ["Content-Type: application/json", "Cookie: " + _session_cookie]
	var err := _http.request(_base_url + "/job/v1/process/text2motion", headers, HTTPClient.METHOD_POST, body)
	if err != OK:
		push_error("Job submit failed to send: %d" % err)
		return ""
	var result: Array = await _http.request_completed
	var response_code: int = result[1]
	var response_body: PackedByteArray = result[3]
	if response_code != 200:
		push_error("Job submit failed with HTTP %d: %s" % [response_code, response_body.get_string_from_utf8()])
		return ""
	var parsed = JSON.parse_string(response_body.get_string_from_utf8())
	if parsed == null or not parsed.has("rid"):
		push_error("Unexpected job submit response: %s" % response_body.get_string_from_utf8())
		return ""
	# rid is an opaque string like "u5op75geKRgmDXVRfQAB21-text2motion",
	# NOT a number - confirmed against the live API. Never cast with int().
	return str(parsed["rid"])


# Polls until SUCCESS/FAILURE or max_wait_seconds elapses. Returns
# "SUCCESS", "FAILURE", or "TIMEOUT".
func poll_until_done(rid: String, max_wait_seconds: float = 90.0) -> String:
	var elapsed := 0.0
	while elapsed < max_wait_seconds:
		var headers := ["Cookie: " + _session_cookie]
		var err := _http.request(_base_url + "/job/v1/status/%s" % rid, headers, HTTPClient.METHOD_GET)
		if err != OK:
			push_error("Status poll failed to send: %d" % err)
			return "FAILURE"
		var result: Array = await _http.request_completed
		var response_body: PackedByteArray = result[3]
		var parsed = JSON.parse_string(response_body.get_string_from_utf8())
		if parsed != null and parsed.has("status") and parsed["status"].size() > 0:
			var status: String = parsed["status"][0].get("status", "")
			generation_progress.emit(status)
			if status == "SUCCESS" or status == "FAILURE":
				return status
		await get_tree().create_timer(2.0).timeout
		elapsed += 2.0
	return "TIMEOUT"


func get_download_url(rid: String) -> String:
	var headers := ["Cookie: " + _session_cookie]
	var err := _http.request(_base_url + "/job/v1/download/%s?variant_id=1" % rid, headers, HTTPClient.METHOD_GET)
	if err != OK:
		push_error("Download link fetch failed to send: %d" % err)
		return ""
	var result: Array = await _http.request_completed
	var response_body: PackedByteArray = result[3]
	var parsed = JSON.parse_string(response_body.get_string_from_utf8())
	if parsed == null or not parsed.has("links"):
		push_error("Unexpected download response: %s" % response_body.get_string_from_utf8())
		return ""
	for link in parsed["links"]:
		for url_entry in link.get("urls", []):
			for file_entry in url_entry.get("files", []):
				if file_entry.has("glb"):
					return file_entry["glb"]
	return ""


func download_to_file(url: String, save_path: String) -> bool:
	var download_http := HTTPRequest.new()
	add_child(download_http)
	download_http.download_file = save_path
	var err := download_http.request(url)
	if err != OK:
		push_error("File download failed to send: %d" % err)
		download_http.queue_free()
		return false
	var result: Array = await download_http.request_completed
	var response_code: int = result[1]
	download_http.queue_free()
	return response_code == 200
