# AGENTS.md

## 1. Project Overview

Mini Space Wars is a small-scope, single-player, 2D vertical space shooter built with Godot 4.x and GDScript.

The primary project goal is to complete and publish a small but fully playable MVP while keeping the codebase clear, learnable, and maintainable.

Agents must prioritize:

1. Correctness
2. Scope control
3. Clarity
4. Testability
5. Completion

Agents must not optimize for feature count, abstraction depth, or architectural sophistication.

---

## 2. Source of Truth

Agents must read the relevant project documents before making changes.

Source priority:

1. `docs/PRD.md`
2. `docs/GDD.md`
3. `docs/TDD.md`
4. `docs/TASK_PLAN.md`
5. Current task prompt
6. Existing code and scene structure

Interpretation rules:

- The PRD defines product scope and completion criteria.
- The GDD defines player-facing gameplay behavior.
- The TDD defines technical responsibilities and architecture.
- The Task Plan defines implementation order and milestone boundaries.
- The current task prompt may narrow a task, but must not silently override approved documents.
- Existing implementation is not automatically correct if it conflicts with approved documentation.

If documents conflict:

- Do not invent a resolution.
- Stop before making the conflicting design decision.
- Report the conflict clearly.
- Propose the smallest reasonable resolution.
- Continue only with work that is not affected by the conflict.

---

## 3. Scope Rules

Implement only the currently assigned task.

Agents must:

- Stay within the active milestone.
- Avoid implementing later milestone features early.
- Avoid speculative systems for possible future features.
- Avoid adding features not listed in the approved MVP.
- Prefer the smallest implementation that satisfies the documented requirement.
- Preserve approved out-of-scope boundaries.

The following are out of scope for the MVP unless explicitly approved:

- Boss encounters
- Multiplayer
- Online systems
- Mobile support
- Controller support
- Save systems
- Persistent scoreboards
- Shops, inventory, or progression
- Multiple player ships
- Multiple weapon types
- Multiple enemy types
- Power-ups
- Story or mission selection
- Cutscenes
- Advanced effects
- Background music systems
- AI or machine-learning features

Do not add “future-proofing” abstractions for these features.

---

## 4. Task Identification

Every implementation task has a permanent Task ID using this format:

```text
M<number>-T<two-digit-number>
```

Task ID rules:

- Task IDs must match `docs/TASK_PLAN.md`.
- Every implementation prompt must contain exactly one primary Task ID.
- The agent must repeat the Task ID in the end-of-task report.
- New tasks must be added to `docs/TASK_PLAN.md` before implementation.
- A Task ID must never be reused for another task.
- The agent must not switch to another Task ID without explicit instruction.
- When Git work is requested, branch and commit names must include the Task ID.
- Subtask IDs may use the `M1-T01-S01` format only when genuinely necessary.

---

## 5. Technology Constraints

Use:

- Godot 4.x
- GDScript
- Godot scenes and resources
- `Area2D`-based collision detection
- Godot signals for cross-scene communication
- Godot Resource files only for wave data

Target platforms:

- Windows
- macOS

Do not introduce:

- C#
- GDExtension
- External runtime dependencies
- Third-party plugins
- External frameworks
- Network services
- Additional package managers

Any new dependency requires explicit user approval.

---

## 6. Architecture Rules

Follow the responsibilities defined in the TDD.

### Main

`Main` owns:

- High-level game state
- Start, playing, win, and game-over transitions
- UI visibility
- New-game and restart coordination
- High-level cleanup and reset
- Receiving win and loss events

`Main` must not absorb detailed player, enemy, projectile, or weapon logic.

### Player

`Player` owns:

- Movement input
- Accelerated movement
- Gameplay-bound clamping
- Fire input forwarding
- Lives
- Damage handling
- Temporary invulnerability
- Player damage and death signals

### Weapon

`Weapon` owns:

- Fire cooldown
- Fire availability
- Hold-to-fire behavior
- Player projectile spawning

### Enemy

`Enemy` owns:

- Downward movement
- Horizontal oscillation
- Receiving projectile hits
- Destruction
- Enemy destruction signal
- Player contact interaction

### EnemyWeapon

`EnemyWeapon` owns:

- Fire interval
- Enemy projectile spawning
- Downward firing
- Per-wave fire interval configuration

### Projectiles

Projectiles own:

- Movement
- Collision response
- Removal after collision
- Removal after leaving the gameplay area

### WaveManager

`WaveManager` owns:

- Loading the three fixed wave resources
- Starting waves
- Spawning enemies
- Tracking remaining enemies
- Starting the next wave
- Emitting wave and completion signals

`WaveManager` must not own:

- UI state
- Player lives
- Result screens
- Global game state

### UI

`HUD` only displays lives and wave information.

`ResultPanel` only displays the result and emits restart requests.

Do not merge responsibilities merely to reduce file count.

---

## 7. Scene and File Rules

Use the approved project structure:

```text
res://
  assets/
    audio/
    sprites/
  docs/
  scenes/
    enemies/
    player/
    projectiles/
    ui/
  scripts/
    enemies/
    player/
    projectiles/
    ui/
```

Rules:

- Place scenes in their matching `scenes/` subfolder.
- Place scripts in their matching `scripts/` subfolder.
- Place PNG sprite assets in `assets/sprites/`.
- Place WAV sound assets in `assets/audio/`.
- Keep project documents in `docs/`.
- Use descriptive English file names.
- Use `snake_case` for script and resource file names.
- Use `PascalCase` for named scenes and GDScript classes when applicable.
- Do not reorganize folders outside the assigned task.
- Do not rename existing files without a concrete requirement.

---

## 8. GDScript Standards

Code must be written for readability by a learner.

Required conventions:

- Use typed variables, parameters, and return values where practical.
- Use `snake_case` for variables, functions, and signals.
- Use `PascalCase` for class names.
- Use `UPPER_SNAKE_CASE` for constants.
- Keep functions small and focused.
- Prefer explicit code over clever or compressed code.
- Use early returns when they improve readability.
- Avoid deeply nested conditionals.
- Avoid duplicated gameplay logic.
- Use exported variables for documented tuning values.
- Use signals only for meaningful cross-scene events.
- Keep internal behavior as direct method calls.

Comments should explain:

- Non-obvious intent
- Important constraints
- Why a workaround exists

Comments must not restate obvious code.

Do not:

- Add unused code
- Leave commented-out implementations
- Add speculative TODO comments
- Suppress errors silently
- Use magic numbers when the value represents a named gameplay rule
- Build generalized frameworks for a single MVP use case

---

## 9. Gameplay Rules That Must Be Preserved

Agents must preserve these approved behaviors:

- Player movement uses W, A, S, and D.
- Player movement uses responsive acceleration and deceleration.
- The player cannot leave the visible gameplay bounds.
- Holding Space repeatedly fires the basic weapon.
- Player projectiles move upward.
- Enemies enter from the top and move downward.
- Enemies use slight horizontal oscillation.
- Enemies fire downward at fixed intervals.
- Player projectiles destroy enemies in one hit.
- The player starts with 3 lives.
- Enemy projectiles and enemy contact each remove 1 life.
- Player invulnerability lasts 1.5 seconds after valid damage.
- Invulnerability prevents repeated instant damage.
- The game contains exactly 3 fixed waves.
- Wave enemy counts are 3, 5, and 7.
- The next wave starts immediately after the current wave is cleared.
- Completing Wave 3 produces a win.
- Reaching 0 lives produces a game-over result.
- Restart begins a clean game from Wave 1.
- The HUD displays remaining lives and current wave.

Do not alter balance values that are already approved unless the active task is a balance task.

---

## 10. Signals and Communication

Use the documented signal names unless implementation reveals a concrete technical issue:

- `game_started`
- `player_damaged`
- `player_dead`
- `projectile_hit_enemy`
- `enemy_destroyed`
- `wave_started`
- `all_waves_cleared`
- `restart_requested`

Rules:

- Signals must use English `snake_case`.
- Signal payloads should contain only information receivers need.
- Avoid global event buses.
- Avoid autoload singletons unless explicitly approved.
- Avoid signals for private behavior inside one script.
- Prevent duplicate signal connections.
- Disconnect or clean up dynamic connections when necessary.

---

## 11. State and Reset Rules

High-level states:

- `START`
- `PLAYING`
- `WIN`
- `GAME_OVER`

Gameplay input, waves, and active gameplay behavior must run only when appropriate for the current state.

`Main.reset_game()` must produce a clean new run by:

1. Clearing enemies
2. Clearing player projectiles
3. Clearing enemy projectiles
4. Resetting player position
5. Resetting player lives to 3
6. Clearing invulnerability
7. Resetting wave progress
8. Showing the HUD
9. Setting state to `PLAYING`
10. Starting Wave 1

Prefer manual reset as documented. Do not replace it with full scene reload unless manual reset is demonstrated to be unreliable and the user approves the change.

---

## 12. Task Execution Workflow

For every task:

1. Read `AGENTS.md`.
2. Read the current task prompt.
3. Read the relevant approved documents.
4. Inspect the current repository state.
5. Identify the smallest set of files that must change.
6. Implement only the assigned behavior.
7. Run all available relevant checks.
8. Review the diff for unintended changes.
9. Report results clearly.
10. Stop after the assigned task.

Before editing, state internally:

- Task goal
- Relevant requirements
- Expected files
- Validation method

Do not ask for confirmation when the task is clear.

Ask for clarification only when:

- Approved documents materially conflict
- A required asset or file is missing
- The task requires an undocumented product or architecture decision
- Continuing would likely create rework

When possible, continue with unaffected parts of the task while reporting the blocker.

---

## 13. Validation and Testing

The project currently uses manual testing as its approved testing approach.

Agents must:

- Run Godot project validation when the environment supports it.
- Check for script parse errors.
- Check for missing resource paths.
- Check for broken scene references.
- Check that input actions exist when required.
- Perform task-specific manual verification when interactive Godot access is available.
- Clearly distinguish executed checks from recommended checks.

Never claim a test passed unless it was actually run.

If Godot cannot be launched:

- Perform static inspection.
- Report that runtime verification was not performed.
- Provide exact manual test steps for the user.

### Godot CLI Validation

For relevant tasks, agents must run Godot CLI validation instead of relying only on static inspection.

Minimum validation command:

```bash
godot --headless --path . --import
```

Rules:

- Run Godot CLI validation after changes to `project.godot`, scenes, scripts, resources, or project settings.
- Use `--headless` by default for automated validation checks.
- Report the exact command, exit code, and important output in the task report.
- Do not infer runtime validation results from static checks.
- If the `godot` command is not accessible through the system `PATH`, report it clearly as an environment problem.

Task reports must include:

- Checks actually run
- Results
- Checks not run
- Reason they were not run
- Remaining risks

Debug logs may be added temporarily when useful, but must not become required for normal gameplay.

---

## 14. Definition of Done

A task is complete only when:

- The assigned requirement is implemented.
- The implementation follows the approved architecture.
- No unrelated feature was added.
- No known parse or reference error remains.
- Relevant validation was performed where possible.
- Manual verification steps are documented when needed.
- Temporary debug artifacts are removed unless explicitly useful.
- Changed files are listed.
- Known limitations are reported.
- The agent stops without starting the next task.

A milestone is complete only when every listed completion check in `TASK_PLAN.md` has been verified.

---

## 15. Git Rules

Unless the task prompt explicitly instructs otherwise:

- Do not create commits.
- Do not push changes.
- Do not merge branches.
- Do not delete branches.
- Do not rewrite Git history.
- Do not modify remote configuration.
- Do not discard unrelated user changes.
- Do not use destructive Git commands.

Before editing:

- Inspect repository status.
- Preserve unrelated modified or untracked files.

After editing:

- Report the changed files.
- Report whether unrelated changes were already present.
- Suggest a concise commit message, but do not commit automatically.

Recommended commit format:

```text
<type>: <short imperative summary>
```

Examples:

```text
chore: configure project input actions
feat: add player movement
fix: prevent repeated damage during invulnerability
docs: update milestone progress
```

---

## 16. Documentation Rules

Update documentation only when:

- The active task explicitly requires it.
- An approved implementation detail must be recorded.
- A completed checkbox in `TASK_PLAN.md` has actually been verified.
- The implementation reveals an approved document is inaccurate.

Do not silently change approved scope or design documents to match an implementation shortcut.

When implementation and documentation differ:

- Prefer the approved documentation.
- Report the mismatch.
- Change the implementation unless a document revision is explicitly approved.

Do not mark a task or milestone complete based only on code presence. Its completion checks must be verified.

---

## 16. Prohibited Actions

Agents must not:

- Expand MVP scope
- Implement future AI features
- Add multiple enemy or weapon types
- Add save, online, or progression systems
- Introduce plugins or dependencies without approval
- Perform broad refactors during a focused task
- Rewrite working systems without a task requirement
- Change gameplay rules silently
- Guess missing product decisions
- Hide failing checks
- Claim unexecuted tests passed
- Delete user work
- Commit or push without explicit instruction
- Continue into the next task automatically

---

## 17. Required Final Report

After each implementation task, respond with:

### Summary

A brief description of what was implemented.

### Changed Files

List every created, modified, renamed, or deleted file.

### Validation

List checks actually run and their results.

### Manual Test

Provide short, exact steps the user can perform in Godot.

### Limitations or Risks

Report unresolved issues, assumptions, or checks that could not be completed.

### Suggested Commit

Provide one concise commit message.

### Next Step

Name the next task from the approved Task Plan, but do not implement it.

---

## 18. Guiding Principle

Build the smallest correct version of the currently assigned feature.

A clear, working, finished MVP is more valuable than a flexible but unfinished architecture.
