# Mini Space Wars Implementation Task Plan

## 1. Document Information

| Field | Value |
|---|---|
| Document Name | Mini Space Wars Implementation Task Plan |
| Product / Project Name | Mini Space Wars |
| Version | v1.3 |
| Date | June 23, 2026 |
| Product Owner / Developer | Oguzhan FIDE |
| Support | ChatGPT / Codex |
| Document Status | Approved |

## 2. Implementation Strategy

The implementation will be organized around milestones. Each milestone should produce a working and testable part of the game.

The project should prioritize a small playable vertical slice before adding full game flow and release details.

The first playable target is:

- Player movement
- Player firing
- Visible player projectiles

After this first target works, the project will add enemies, collision, waves, UI, game states, feedback, testing, and release preparation in sequence.

## 3. Milestone List

The implementation will be divided into 7 milestones:

1. Project Setup and Folder Structure
2. Player Vertical Slice
3. Enemy and Collision
4. Wave System
5. UI and Game States
6. Feedback, Assets, and Balance
7. Testing and Release Preparation

Each milestone should be completed and manually checked before moving to the next milestone.

## 4. Milestone 1: Project Setup and Folder Structure

Goal: Prepare the Godot project structure and basic project settings required for implementation.

Tasks:

- [x] `M1-T01` — Create the planned folder structure:
  - `res://assets/audio/`
  - `res://assets/sprites/`
  - `res://scenes/enemies/`
  - `res://scenes/player/`
  - `res://scenes/projectiles/`
  - `res://scenes/ui/`
  - `res://scripts/enemies/`
  - `res://scripts/player/`
  - `res://scripts/projectiles/`
  - `res://scripts/ui/`
- [x] `M1-T02` — Add short README or notes files where needed to explain folder purpose.
- [x] `M1-T03` — Configure Godot input action for move up.
- [x] `M1-T04` — Configure Godot input action for move down.
- [x] `M1-T05` — Configure Godot input action for move left.
- [x] `M1-T06` — Configure Godot input action for move right.
- [x] `M1-T07` — Configure Godot input action for fire.
- [x] `M1-T08` — Confirm that the project opens correctly in Godot 4.x.
- [x] `M1-T09` — Confirm that the repository remains clean after project setup files are saved.

Completion check:

- [x] Folder structure exists.
- [x] Input actions are configured.
- [x] Project opens in Godot 4.x without setup errors.

## 5. Milestone 2: Player Vertical Slice

Goal: Create the first playable vertical slice with player movement, firing, and visible projectiles.

Tasks:

- [x] `M2-T01` — Create the `Player` scene.
- [x] `M2-T02` — Create the `Player` script.
- [x] `M2-T03` — Add the first pixel art player ship sprite.
- [x] `M2-T04` — Implement WASD movement.
- [x] `M2-T05` — Implement slightly accelerated movement.
- [x] `M2-T06` — Clamp the player ship inside the visible gameplay bounds.
- [x] `M2-T07` — Create the `Weapon` script for the basic player weapon.
- [x] `M2-T08` — Create the `PlayerProjectile` scene.
- [x] `M2-T09` — Create the `PlayerProjectile` script.
- [x] `M2-T10` — Implement hold-to-fire behavior with Space.
- [x] `M2-T11` — Spawn visible player projectiles from the player ship.
- [x] `M2-T12` — Move player projectiles upward.
- [x] `M2-T13` — Remove player projectiles after they leave the play area.
- [x] `M2-T14` — Add simple debug logs for firing if useful during development.
- [x] `M2-T15` — Configure gameplay viewport size.

Completion check:

- [x] Player ship is visible.
- [x] Player moves with WASD.
- [x] Player cannot leave the play area.
- [x] Holding Space creates visible upward-moving projectiles.
- [x] Projectiles are removed after leaving the play area.

## 6. Milestone 3: Enemy and Collision

Goal: Add the enemy, projectile collision, player damage, lives, and temporary invulnerability.

Tasks:

- [x] `M3-T01` — Create the `Enemy` scene.
- [x] `M3-T02` — Create the `Enemy` script.
- [x] `M3-T03` — Add the first pixel art enemy ship sprite.
- [x] `M3-T04` — Implement enemy downward movement.
- [x] `M3-T05` — Implement slight horizontal oscillation.
- [x] `M3-T06` — Create the `EnemyWeapon` script.
- [x] `M3-T07` — Create the `EnemyProjectile` scene.
- [x] `M3-T08` — Create the `EnemyProjectile` script.
- [x] `M3-T09` — Implement fixed-interval enemy firing.
- [x] `M3-T10` — Move enemy projectiles downward.
- [x] `M3-T11` — Remove enemy projectiles after they leave the play area.
- [x] `M3-T12` — Implement `Area2D`-based hit detection for projectiles and ships.
- [x] `M3-T13` — Implement player projectile hitting enemy.
- [x] `M3-T14` — Destroy enemy in one hit from player projectile.
- [x] `M3-T15` — Remove player projectile after enemy hit.
- [x] `M3-T16` — Implement enemy projectile damaging player.
- [x] `M3-T17` — Implement enemy ship contact damaging player.
- [x] `M3-T18` — Add player life tracking with 3 lives.
- [x] `M3-T19` — Add 1.5-second temporary invulnerability after player damage.
- [x] `M3-T20` — Prevent repeated instant damage during invulnerability.
- [x] `M3-T21` — Emit or log player damaged events.
- [x] `M3-T22` — Emit or log player dead events.
- [x] `M3-T23` — Emit or log enemy destroyed events.

Completion check:

- [x] Enemy is visible and moves downward with slight horizontal oscillation.
- [x] Enemy fires downward projectiles.
- [x] Player projectiles destroy enemies in one hit.
- [x] Enemy projectiles reduce player lives.
- [x] Enemy ship contact reduces player lives.
- [x] Temporary invulnerability prevents repeated instant damage.
- [x] Player death can be detected when lives reach 0.

## 7. Milestone 4: Wave System

Goal: Implement the 3 fixed enemy waves using Godot Resource-based wave data.

Tasks:

- [x] `M4-T01` — Create the wave data Resource script.
- [x] `M4-T02` — Create the Wave 1 Resource file.
- [x] `M4-T03` — Create the Wave 2 Resource file.
- [x] `M4-T04` — Create the Wave 3 Resource file.
- [x] `M4-T05` — Configure wave number data.
- [x] `M4-T06` — Configure enemy count data.
- [x] `M4-T07` — Configure enemy fire interval data.
- [x] `M4-T08` — Configure spawn area limit data.
- [x] `M4-T09` — Set Wave 1 to 3 enemies.
- [x] `M4-T10` — Set Wave 2 to 5 enemies.
- [x] `M4-T11` — Set Wave 3 to 7 enemies.
- [x] `M4-T12` — Configure enemy fire interval to increase difficulty from wave to wave.
- [x] `M4-T13` — Create the `WaveManager` script.
- [x] `M4-T14` — Load the 3 fixed wave resources.
- [x] `M4-T15` — Spawn enemies for the current wave.
- [x] `M4-T16` — Spawn enemies at random positions within configured spawn area limits.
- [x] `M4-T17` — Track enemy destroyed events.
- [x] `M4-T18` — Start the next wave immediately after the current wave is cleared.
- [x] `M4-T19` — Emit an all-waves-cleared event after Wave 3 is completed.
- [x] `M4-T20` — Add simple debug logs for wave started.
- [x] `M4-T21` — Add simple debug logs for enemy destroyed.
- [x] `M4-T22` — Add simple debug logs for all waves cleared.
- [x] `M4-T23` — Fix wave transition physics flush and enemy ship contact damage.

Completion check:

- [x] Wave 1 starts with 3 enemies.
- [x] Wave 2 starts after Wave 1 is cleared.
- [x] Wave 3 starts after Wave 2 is cleared.
- [x] Wave 3 completion emits all-waves-cleared.
- [x] Enemy fire interval changes by wave.
- [x] Spawn positions stay inside configured spawn area limits.

## 8. Milestone 5: UI and Game States

Goal: Implement the full game flow with start, gameplay, win, game over, HUD, and restart behavior.

Tasks:

- [x] `M5-T01` — Implement the `START` game state.
- [x] `M5-T02` — Implement the `PLAYING` game state.
- [x] `M5-T03` — Implement the `WIN` game state.
- [x] `M5-T04` — Implement the `GAME_OVER` game state.
- [x] `M5-T05` — Add start UI inside the `Main` scene.
- [x] `M5-T06` — Display the game title on the start screen.
- [x] `M5-T07` — Display a start prompt on the start screen.
- [x] `M5-T08` — Display a controls hint on the start screen.
- [x] `M5-T09` — Create the `HUD` scene.
- [x] `M5-T10` — Display player lives in the HUD.
- [x] `M5-T11` — Display current wave number in the HUD.
- [x] `M5-T12` — Update HUD when player lives change.
- [x] `M5-T13` — Update HUD when the current wave changes.
- [x] `M5-T14` — Create the `ResultPanel` scene.
- [x] `M5-T15` — Show "You Win" when all waves are cleared.
- [x] `M5-T16` — Show "Game Over" when player lives reach 0.
- [x] `M5-T17` — Add a new game option to the result screen.
- [x] `M5-T18` — Emit `restart_requested` from `ResultPanel`.
- [ ] `M5-T19` — Implement `Main.reset_game()`.
- [ ] `M5-T20` — Clear enemies and projectiles during reset.
- [ ] `M5-T21` — Reset player position, lives, and invulnerability during reset.
- [ ] `M5-T22` — Reset wave progress during reset.
- [ ] `M5-T23` — Start Wave 1 after reset.
- [ ] `M5-T24` — Show and hide UI elements based on the current game state.
- [x] `M5-T25` — Remove escaped enemies from wave tracking to prevent wave softlock.

Completion check:

- [ ] Game starts from the start screen.
- [ ] HUD appears during gameplay.
- [ ] HUD updates lives and current wave.
- [ ] Win result appears after all waves are cleared.
- [ ] Game Over result appears when player lives reach 0.
- [ ] Restart starts a clean new game from Wave 1.

## 9. Milestone 6: Feedback, Assets, and Balance

Goal: Add MVP-level visual/audio feedback, finalize required MVP assets, and tune the game for the approved difficulty and session length.

Tasks:

- [ ] `M6-T01` — Finalize the MVP pixel art player ship sprite.
- [ ] `M6-T02` — Finalize the MVP pixel art enemy ship sprite.
- [ ] `M6-T03` — Finalize the MVP pixel art player projectile sprite.
- [ ] `M6-T04` — Finalize the MVP pixel art enemy projectile sprite.
- [ ] `M6-T05` — Finalize the basic enemy destruction effect.
- [ ] `M6-T06` — Finalize the simple dark space background.
- [ ] `M6-T07` — Add player projectile visual feedback.
- [ ] `M6-T08` — Add enemy projectile visual feedback.
- [ ] `M6-T09` — Add enemy destruction visual feedback.
- [ ] `M6-T10` — Add player damage blink feedback.
- [ ] `M6-T11` — Add visible temporary invulnerability feedback.
- [ ] `M6-T12` — Add 8-bit/chiptune-style player fire sound.
- [ ] `M6-T13` — Add 8-bit/chiptune-style enemy destruction sound.
- [ ] `M6-T14` — Tune player acceleration.
- [ ] `M6-T15` — Tune player deceleration.
- [ ] `M6-T16` — Tune player maximum speed.
- [ ] `M6-T17` — Tune weapon fire cooldown.
- [ ] `M6-T18` — Tune projectile speeds.
- [ ] `M6-T19` — Tune enemy movement speed.
- [ ] `M6-T20` — Tune enemy horizontal oscillation amount.
- [ ] `M6-T21` — Tune enemy fire intervals per wave.
- [ ] `M6-T22` — Run manual playtests for average session length.
- [ ] `M6-T23` — Run manual playtests for medium difficulty.
- [ ] `M6-T24` — Run manual playtests for damage feedback clarity.
- [ ] `M6-T25` — Run manual playtests for wave difficulty progression.

Completion check:

- [ ] Required MVP sprites are present.
- [ ] Required MVP sound effects are present.
- [ ] Player damage and invulnerability are visibly understandable.
- [ ] Enemy destruction is visibly understandable.
- [ ] Game can be completed in approximately 2-4 minutes.
- [ ] Difficulty feels medium based on manual playtesting.

## 10. Milestone 7: Testing and Release Preparation

Goal: Verify the MVP, prepare desktop exports, and publish the release through GitHub Releases.

Tasks:

- [ ] `M7-T01` — Verify that the game starts from the start screen.
- [ ] `M7-T02` — Verify that the player moves with WASD.
- [ ] `M7-T03` — Verify that the player cannot leave the play area.
- [ ] `M7-T04` — Verify that the player can hold Space to fire repeatedly.
- [ ] `M7-T05` — Verify that player projectiles destroy enemies.
- [ ] `M7-T06` — Verify that enemies move downward with slight horizontal oscillation.
- [ ] `M7-T07` — Verify that enemies fire downward at fixed intervals.
- [ ] `M7-T08` — Verify that enemy projectiles damage the player.
- [ ] `M7-T09` — Verify that enemy ship contact damages the player.
- [ ] `M7-T10` — Verify that temporary invulnerability prevents repeated instant damage.
- [ ] `M7-T11` — Verify that waves progress from Wave 1 to Wave 3.
- [ ] `M7-T12` — Verify that the win state appears after all 3 waves are cleared.
- [ ] `M7-T13` — Verify that the game over state appears when player lives reach 0.
- [ ] `M7-T14` — Verify that restart clears gameplay objects and starts a new game.
- [ ] `M7-T15` — Verify that HUD updates lives and current wave correctly.
- [ ] `M7-T16` — Fix blocking bugs found during manual testing.
- [ ] `M7-T17` — Confirm the game opens correctly in Godot 4.x.
- [ ] `M7-T18` — Create a Windows playable desktop export.
- [ ] `M7-T19` — Create a macOS playable desktop export.
- [ ] `M7-T20` — Verify exported builds can be launched.
- [ ] `M7-T21` — Prepare a short GitHub Release note.
- [ ] `M7-T22` — Publish build files through GitHub Releases.
- [ ] `M7-T23` — Confirm release assets are downloadable.

Completion check:

- [ ] Manual test checklist passes.
- [ ] Windows export is prepared.
- [ ] macOS export is prepared.
- [ ] Release note is prepared.
- [ ] GitHub Release includes downloadable build files.

## 11. Task Tracking Rules

Tasks should be tracked with the following statuses:

- To Do
- In Progress
- Done

Milestone task lists should use checkboxes so implementation progress can be tracked directly inside the document or copied into a project board.

Checkbox format:

```markdown
- [ ] `M<milestone-number>-T<two-digit-task-number>` — Task not completed yet
- [x] `M<milestone-number>-T<two-digit-task-number>` — Task completed
```

Task ID format:

```text
M<milestone-number>-T<two-digit-task-number>
```

Task ID rules:

- Every implementation task must have a permanent Task ID.
- Task IDs must match the milestone that contains the task.
- Task numbering restarts at `T01` inside each milestone.
- Task IDs must be unique across the full task plan.
- Task IDs must not be reused for different tasks.
- Task IDs must remain stable after assignment.
- Completion check items must not receive Task IDs.
- New implementation tasks must be added to this document before they are implemented.
- When Git work is requested, branch and commit names should include the relevant Task ID.
- Subtask IDs may use the `M1-T01-S01` format only when a task genuinely needs tracked subtasks.

Only one milestone should be actively worked on at a time unless a later task is clearly independent and does not create rework.

## 12. Implementation Completion Criteria

The Implementation Task Plan is considered complete when all MVP work is divided into milestones and checkbox-based tasks.

Completion requires that:

- The implementation strategy is defined.
- The milestone list is defined.
- Each milestone has a clear goal.
- Each milestone has checkbox-based tasks.
- Each milestone has completion checks.
- Task tracking rules are defined.
- The next implementation step is clear.

After this task plan is approved, the next project step will be Milestone 1 implementation.
