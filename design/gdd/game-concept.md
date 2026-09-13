# Game Concept: CharadAI

*Created: 2026-08-27*
*Status: Draft*

---

## Elevator Pitch

> It's Charades where you type the clue instead of acting it out — SayMotion
> brings your description to life on a 3D character in about 20 seconds, and
> everyone else races to guess what chaos it just performed.
>
> Test: Can someone who has never heard of this game understand what they'd
> be doing in 10 seconds? Yes — "type a clue, watch an AI act it out badly,
> guess what it is."

---

## Core Identity

| Aspect | Detail |
| ---- | ---- |
| **Genre** | Party / Social Deduction (generative-AI twist) |
| **Platform** | Web / Browser (primary target) |
| **Target Audience** | Casual social/party gamers, friend groups, streamers |
| **Player Count** | Multiplayer, 3-8 players — shared "TV" screen + phones as controllers (Jackbox-style) |
| **Session Length** | 30-60 minutes |
| **Monetization** | None at MVP; possible future prompt-pack DLC (Jackbox-style) |
| **Estimated Scope** | Medium (5-6 months, solo/small team) |
| **Comparable Titles** | Jackbox Party Pack (Charades, Fibbage), Gartic Phone, Skribbl.io |

---

## Core Fantasy

You're a director who can conjure any performance just by describing it — no
acting skill, no camera, no talent required. And when your "actor" (the AI)
misunderstands you spectacularly, that's not a failure — it's the best part
of the show.

---

## Unique Hook

It's like Charades, AND ALSO you never have to perform. An AI generates the
physical performance from your words in real time, so the comedy comes from
watching AI creatively misinterpret human language — not from anyone's acting
ability. This removes the single biggest barrier to entry in performance
party games (fear of embarrassment) while keeping the mechanic that makes
Charades great (racing to decode a physical clue).

---

## Player Experience Analysis (MDA Framework)

### Target Aesthetics (What the player FEELS)

| Aesthetic | Priority | How We Deliver It |
| ---- | ---- | ---- |
| **Sensation** (sensory pleasure) | 3 | Juicy reveal animation, dramatic sound sting on the "generating → reveal" transition |
| **Fantasy** (make-believe, role-playing) | 4 | The "director who commands a performer with words" fantasy |
| **Narrative** (drama, story arc) | N/A | Not a narrative game |
| **Challenge** (obstacle course, mastery) | 5 | Mild — learning to phrase prompts well is a real, learnable skill |
| **Fellowship** (social connection) | 1 (primary) | Entire design is a shared-screen social ritual — the reveal is a group moment |
| **Discovery** (exploration, secrets) | 2 | Discovering how the AI "thinks" and what phrasing breaks it in funny ways |
| **Expression** (self-expression, creativity) | 2 | Free-text prompt writing is a creative act |
| **Submission** (relaxation, comfort zone) | N/A | Chaotic-comedic energy, not a relaxation game |

### Key Dynamics (Emergent player behaviors)
- Players will develop an emergent "meta" for phrasing prompts to either maximize guessability or maximize chaos/comedy, depending on what they're going for that round.
- Players will narrate and heckle during the 15-25s generation wait, turning dead time into its own bit.
- Players will screenshot or clip the funniest reveals and share them outside the game — free viral distribution.

### Core Mechanics (Systems we build)

1. **Prompt-to-Motion Generation** — the director types a free-text motion description; SayMotion generates a 3D character animation in ~15-25 seconds.
2. **Timed Guess & Score Round** — after the reveal, guessers submit answers within a short window; asymmetric scoring rewards both the director (based on how many guessed correctly) and fast/correct guessers.
3. **Funniest-Fail Voting** — after every reveal, players vote for the funniest result regardless of correctness, decoupling "fun" from "correct guess" so chaotic AI misfires are always rewarded.

---

## Player Motivation Profile

### Primary Psychological Needs Served

| Need | How This Game Satisfies It | Strength |
| ---- | ---- | ---- |
| **Autonomy** (freedom, meaningful choice) | Totally free-form text input — no fixed moveset, no menu of pre-approved clues | Core |
| **Competence** (mastery, skill growth) | Players learn to "speak AI" — phrasing that reliably produces guessable or hilarious results | Supporting |
| **Relatedness** (connection, belonging) | The entire loop is built around a shared-screen group reaction to each reveal | Core |

### Player Type Appeal (Bartle Taxonomy)

- [x] **Achievers** — Not a design target; no progression/collection systems
- [x] **Explorers** — Secondary: discovering how the AI misinterprets specific phrasings
- [x] **Socializers** — Primary: the whole game is a vehicle for shared laughter
- [ ] **Killers/Competitors** — Not served; explicitly no ranked/competitive mode (see Anti-Pillars)

### Flow State Design

- **Onboarding curve**: First round is an untimed, unscored "practice" prompt so the group sees the full generate→reveal→guess loop once before anything counts.
- **Difficulty scaling**: Prompt-word difficulty escalates round to round (easy → absurd), mirroring Jackbox's late-round chaos escalation.
- **Feedback clarity**: Live scoreboard after every reveal; the "funniest fail" vote gives positive feedback even to players who technically "lost" the round.
- **Recovery from failure**: Failure IS comedy, not punishment. No elimination — the next round starts immediately.

---

## Core Loop

### Moment-to-Moment (30 seconds)
The director types a description of a secret word/phrase without saying it
directly (Charades rules). The room watches a shared "Generating…" screen
for 15-25 seconds — filled with comedic loading copy and a countdown, which
turns the AI's real generation latency into built-in suspense rather than
dead air. The animation reveals on a shared screen; guessers have a short
window to submit answers. This is intrinsically satisfying because nobody's
own performance is being judged — the AI takes the credit or the blame,
which removes the self-consciousness that normal Charades carries, and the
high-chaos AI fidelity means even "wrong" reveals are funny, not wasted.

### Short-Term (5-15 minutes)
One "round" = one prompt, one reveal, guessing, and scoring — about 1-2
minutes including the generation wait. A "hand" is everyone taking one turn
as director. The pull toward "one more round" comes from wanting to see how
a different director's word choice reinterprets the same prompt category,
and wanting your own turn to try to break the AI in a funny way.

### Session-Level (30-120 minutes)
A full session is 2-3 hands (everyone directs 2-3 times) across escalating
prompt-difficulty tiers, ending on the "absurd" tier for a chaotic finale
round. Natural stopping point: end of a hand. Reason to come back: every
generated animation is a shareable clip, so the group wants to relive and
share the funniest reveal from the session afterward.

### Long-Term Progression
No stat progression or grind — party games shouldn't have either. Instead:
unlockable prompt-category packs (movies, animals, professions, "surreal"
tier), an "AI Hall of Fame" — a collected gallery of the group's funniest
generated misinterpretations — and cheap cosmetic character skins that reuse
the same generated motion data on a different model.

### Retention Hooks
- **Curiosity**: What will the AI do with THIS phrasing?
- **Investment**: The group's growing "AI Hall of Fame" of funniest clips.
- **Social**: This is fundamentally a group-hangout game — friends being in the room (physically or on a call) is the point.
- **Mastery**: Learning to phrase prompts that reliably land, or reliably cause chaos on purpose.

---

## Game Pillars

### Pillar 1: AI Is the Performer, Not You
No player is ever judged for their own physical or verbal performance — the
AI does the "acting," so nobody has to feel embarrassed.

*Design test*: Any feature that requires a player to physically or vocally
perform (e.g., webcam charades) gets cut — it compromises the entire
emotional safety net the game is built on.

### Pillar 2: Chaos Is Content
A weird, wrong, or unpredictable AI-generated animation is not a bug — it's
the punchline.

*Design test*: If a feature would make AI output more "correct" or
predictable at the cost of being funny or surprising, we choose funny.

### Pillar 3: Every Reveal Is a Shareable Moment
The generated clip is our entire marketing engine — it should always be easy
to capture and share.

*Design test*: Any UX/technical decision defaults toward "this could be
posted online within 10 seconds of happening."

### Pillar 4: Nobody Waits Bored
Real generation latency (15-25s) is a fact of the tech — it must be designed
around, not hidden or apologized for.

*Design test*: Every wait period must have something to look at, read, or
react to. Dead air during generation kills party games.

### Anti-Pillars (What This Game Is NOT)

- **NOT a webcam/physical-performance game**: Would compromise Pillar 1 (AI Is the Performer, Not You) and reintroduce the exact embarrassment barrier we're designed to remove.
- **NOT chasing photorealistic/cinematic animation quality**: Would compromise Pillar 2 (Chaos Is Content) and burn MVP budget and SayMotion credits we don't have to spend on fidelity nobody's asking for.
- **NOT a ranked/competitive ladder**: Would compromise the low-stakes social-fellowship feel and add scope the MVP can't afford.
- **NOT a single-player game**: The entire value proposition is the shared-screen group reveal moment (Pillars 3 and 4) — solo play is a fundamentally different game.

---

## Inspiration and References

| Reference | What We Take From It | What We Do Differently | Why It Matters |
| ---- | ---- | ---- | ---- |
| Jackbox Party Pack (Charades, Fibbage) | Asymmetric scoring, shared-screen + phone-as-controller UX, escalating round absurdity | We remove the physical/verbal performance requirement entirely — an AI performs instead of a human | Validates this genre has a large paying audience and a proven, low-friction UX pattern |
| Gartic Phone | User-generated content = infinite replayability at zero art cost; "interpretation drift" as a comedy engine | We collapse the "telephone chain" into a single AI-mediated hop, and add live synchronous group guessing instead of an async chain reveal | Validates that watching interpretation mutate/degrade is inherently funny and shareable |
| Skribbl.io | Free, zero-install, room-code browser multiplayer architecture | We swap drawing for AI-generated 3D motion | Validates browser-based real-time party games can reach huge free audiences with minimal friction |

**Non-game inspirations**: *Whose Line Is It Anyway?* (improv comedy that
treats failure and weirdness as the entertainment itself, not something to
avoid); text-to-image AI meme culture (AI misunderstanding prompts is
already a proven, widely shared internet comedy genre — we're applying the
same energy to motion instead of images).

---

## Target Player Profile

| Attribute | Detail |
| ---- | ---- |
| **Age range** | 16-35 |
| **Gaming experience** | Casual |
| **Time availability** | 30-60 minute social sessions — game nights, weekend hangouts |
| **Platform preference** | Browser on a shared screen, phone as controller |
| **Current games they play** | Jackbox Party Pack, Gartic Phone, Among Us, Skribbl.io |
| **What they're looking for** | Low-stakes shared laughter with friends; something to fill "game night" with zero rules-teaching overhead |
| **What would turn them away** | Needing to install anything, needing to be good at drawing/singing/acting, long onboarding, competitive pressure |

---

## Technical Considerations

| Consideration | Assessment |
| ---- | ---- |
| **Recommended Engine** | Godot — free, exports cleanly to Web (HTML5/WebAssembly), matches the low-budget MVP goal and the Web/Browser platform target |
| **Key Technical Challenges** | (1) SayMotion API access is currently limited to verified partners — must be resolved before any prototyping; (2) real-time retargeting of DeepMotion's FBX/BVH output onto a Godot Skeleton3D/AnimationPlayer is unproven; (3) lightweight multiplayer room/lobby netcode (browser-based, needs a relay server); (4) UX architecture for a 15-25s async generation wait shared consistently across all clients in a room |
| **Art Style** | 3D stylized / low-poly |
| **Art Pipeline Complexity** | Low (asset-store base rig + simple reskins) |
| **Audio Needs** | Moderate (comedic stings, loading-screen music, UI feedback) |
| **Networking** | Client-server — needs a lightweight relay/room server (comparable pattern to the studio's existing Tower of Doom project) |
| **Content Volume** | ~100-150 curated prompt words across 3 difficulty tiers for MVP; effectively unlimited via free-text "director's choice" |
| **Procedural Systems** | All animation content is procedurally generated at runtime via the SayMotion API — zero hand-animated content |

---

## Risks and Open Questions

### Design Risks
- Core loop may feel repetitive after several rounds if AI outputs feel samey — needs prompt-category variety and rotation.
- High-chaos AI fidelity could frustrate players who want to actually be understood — may need an optional fidelity/difficulty toggle post-MVP.

### Technical Risks
- SayMotion API access is currently limited to verified partners — blocks all prototyping until resolved.
- Retargeting DeepMotion's output onto a Godot skeleton in real time is unproven and needs a dedicated spike.
- The 15-25s generation latency requires an async job-polling architecture (not simple request/response), and all clients in a room must see the same reveal at the same time — adds real multiplayer sync complexity.

### Market Risks
- Party/social-deduction is a genre with strong, well-funded incumbents (Jackbox) — the generative-AI angle must feel genuinely novel, not like "a worse Jackbox."
- The entire core loop depends on a paid third-party API (SayMotion) — ongoing per-session operating cost, plus vendor risk if pricing or access policy changes.

### Scope Risks
- Multiplayer netcode/lobby infrastructure can easily balloon past "MVP" if not deliberately capped (consider starting same-network/local-relay only).
- Curating prompt-word lists that are simultaneously guessable AND funny is real design-iteration work, easy to underestimate.

### Open Questions
- Does SayMotion API partner access get approved, and what does real turnaround/cost look like at MVP usage volume? → Resolve by applying for partner API access as the very first action item.
- Does DeepMotion's rigged output retarget cleanly onto a stock Godot humanoid skeleton? → Resolve via a `/prototype` spike before writing full GDDs.
- What guess-window length and scoring formula keep pacing snappy despite the 15-25s generation wait? → Resolve via internal playtesting once a prototype exists.

---

## MVP Definition

**Core hypothesis**: Watching an AI generate a chaotic physical
interpretation of a friend's text prompt, then racing to guess what it was,
is fun enough on its own — without polish, content volume, or monetization
— to make a group want to play multiple rounds in one sitting.

**Required for MVP**:
1. Single browser "room" with room-code join — host/TV screen + phone-as-controller per player, no accounts
2. One rigged 3D character wired to the SayMotion API (prompt in → animation FBX/GLB out → played back in Godot)
3. Core round loop: secret word assignment → director types clue → generation wait screen → reveal → timed guessing → scoring → next director
4. "Funniest fail" vote after each reveal
5. ~100 curated prompt words across 3 difficulty tiers

**Explicitly NOT in MVP** (defer to later):
- Cosmetic character skins/unlocks
- Prompt-pack DLC / monetization
- Clip export or social-sharing pipeline
- Spectator/streamer mode
- Native mobile app (web-responsive only)
- Ranked/competitive ladder

### Scope Tiers (if budget/time shrinks)

| Tier | Content | Features | Timeline |
| ---- | ---- | ---- | ---- |
| **MVP** | ~100 prompts, 1 character | Core loop only, same-network/local multiplayer | 6-8 weeks |
| **Vertical Slice** | Same content, polished UX | + funniest-fail highlight reel, basic hosted relay server | 10-12 weeks |
| **Alpha** | 300+ prompts, 3 character skins | + clip export/sharing, difficulty toggle | ~4 months |
| **Full Vision** | Prompt-pack DLC, seasonal content | + spectator mode, streamer overlay, casual leaderboard | 5-6 months |

---

## Next Steps

- [ ] Get concept approval from creative-director
- [ ] Fill in CLAUDE.md technology stack based on engine choice (`/setup-engine`)
- [ ] Create game pillars document (`/design-review` to validate)
- [ ] **Prototype core idea** (`/prototype [core-mechanic]`) — before writing GDDs, validate the concept is worth designing. Priority spike: confirm SayMotion API partner access and Godot retargeting pipeline.
- [ ] If prototype PROCEEDS: Decompose concept into systems (`/map-systems`)
- [ ] Design each system (`/design-system [system-name]`) — use prototype learnings in Tuning Knobs and Formulas sections
- [ ] Build vertical slice in Pre-Production (`/vertical-slice`) — validate full game loop before committing to Production
- [ ] Validate core loop with playtest (`/playtest-report`)
- [ ] Plan first milestone (`/sprint-plan new`)
