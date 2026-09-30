# CharadAI — Concept Prototype

**PROTOTYPE — NOT FOR PRODUCTION.** Throwaway code. Do not import into `src/`.

## Question this tests

If a director types a free-text motion description and SayMotion generates
it live via the real API, does the reveal moment land as funny/engaging
enough that a group wants another round?

Secondary technical question: does a `.glb` file returned by the SayMotion
API load and play back correctly on a runtime-imported skeleton in Godot 4.6?

See `production/session-state/active.md` for the full hypothesis and scope,
and `design/gdd/game-concept.md` for the full game concept this is testing.

## Showcase

Read the case study: **[samguan2020.github.io/charadai-concept](https://samguan2020.github.io/charadai-concept/)**

<video src="docs/demo.mp4" controls width="700">
  Demo video — see <a href="docs/demo.mp4">docs/demo.mp4</a>.
</video>

Built with [Claude Code Game Studios](https://github.com/Donchitos/Claude-Code-Game-Studios)
to answer a real integration question with a live third-party API, not just
prototype plumbing:

- **Live third-party API integration**: [`scripts/saymotion_client.gd`](scripts/saymotion_client.gd)
  drives DeepMotion's [SayMotion](https://www.saymotion.ai) text-to-motion API
  end to end at runtime — Basic-auth handshake, async job submission, status
  polling with a timeout, and streaming the resulting `.glb` back into a live
  Godot scene.
- **Runtime asset pipeline, not a pre-baked import**: motion clips are
  generated from a player's free-text prompt, downloaded, and loaded into a
  running `Skeleton3D` via `GLTFDocument.append_from_file()` — the character's
  motion doesn't exist until the API generates it, mid-session.
- **Fails visibly, never silently**: every network/API failure surfaces
  in-UI with the exact error, and a manual `.glb`-upload button stays
  available as a fallback — a live demo can't hard-stop on an API hiccup.

## Required setup: `.env` (never commit this file)

Create `prototypes/charadai-concept/.env` (already covered by the repo's
`.gitignore` — it will never be committed) with:

```
SAYMOTION_CLIENT_ID=<your client id>
SAYMOTION_CLIENT_SECRET=<your client secret>
SAYMOTION_API_URL=https://api-saymotion.deepmotion.com:443
```

`scripts/saymotion_client.gd` reads these at runtime from `res://.env`. This
only works when running via the Godot editor (Play button) — an exported
build would need a different, non-client-embedded credential strategy (see
`design/gdd/game-concept.md` Technical Risks — this is a known prototype-only
simplification, not how the real MVP should ship credentials).

## How to run

1. Open Godot **4.6** and "Import" this folder (`prototypes/charadai-concept/`).
2. Create the `.env` file above.
3. Press F5 (or the Play button) to run `scenes/main.tscn`.

## Live generation flow

1. Gather 3+ testers around one screen.
2. Run through the game's states: **SECRET_WORD** → **PROMPT_ENTRY**
   (director types their description in the on-screen `LineEdit`) →
   **GENERATING**.
3. On entering **GENERATING**, `main.gd` automatically drives
   `SayMotionClient`: authenticate → submit the text2motion job → poll
   status every 2s (up to 90s) → fetch the `.glb` download URL → download it
   to `user://` → load it into `CharacterSlot` via `GLTFDocument` and
   auto-play the first animation, advancing to **REVEAL**.
4. If any step fails (bad credentials, API error, timeout), the status
   label reports what failed and the **"Load Animation File (.glb)"**
   button stays available as a manual fallback — download a `.glb` by hand
   from [saymotion.ai](https://www.saymotion.ai) and load it that way so a
   playtest session isn't blocked by an API hiccup.
5. Continue through **GUESSING** (verbal guessing works fine for a local
   test — the timer is just pacing) and **RESULTS**, where the group can
   vote "Funniest Fail."
6. Hit "Play Another Round" and repeat with a fresh secret word.

## What to watch for (the real technical unknowns)

- Does authentication succeed (`GET /account/v1/auth` returning a `dmsess`
  session cookie), or does the auth header/cookie parsing need fixing?
- Does the job submission (`POST /job/v1/process/text2motion`) accept a
  minimal `{"params": ["prompt=...", "numVariant=1"]}` body, or does the API
  require additional params (`model`, `requestedAnimationDuration`, etc.)
  we haven't set? Check the exact error response if it 400s.
- How long does polling actually take end-to-end in practice, versus the
  ~15-25s figure from DeepMotion's public docs?
- Does the download response actually contain a `"glb"` file entry, or only
  `"fbx"`? (`get_download_url()` currently only looks for `"glb"`.)
- Does the `.glb` import via `GLTFDocument.append_from_file()` /
  `generate_scene()` actually succeed, or does it error?
- Does the generated character appear at a reasonable scale/position
  relative to the camera and floor, or does it need manual offset/scale
  correction?
- Does `AnimationPlayer.play()` on the first animation in the loaded scene
  actually play the motion, or is the animation named/structured differently
  than expected?

If any of these fail, that's exactly the kind of finding this prototype
exists to surface — report the exact error text back so the approach can be
adjusted before writing any production code.

## What's deliberately cut

- No networking / multiplayer — this is a single shared screen, verbal
  guessing, local test only
- No accounts, no persistent scoring across sessions
- No art polish, no audio, no character skins
- Only 8 hardcoded secret words
- No server-side credential relay — the API secret is read client-side from
  a local `.env` file, which is fine for a local prototype but must not
  ship this way in production (see Technical Risks in the game concept doc)
