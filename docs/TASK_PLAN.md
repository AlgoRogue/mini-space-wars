# Mini Space Wars Implementation Task Plan

## 1. Document Information

| Field | Value |
|---|---|
| Document Name | Mini Space Wars Implementation Task Plan |
| Product / Project Name | Mini Space Wars |
| Version | v1.0 |
| Date | June 22, 2026 |
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

- [ ] Create the planned folder structure:
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
- [ ] Add short README or notes files where needed to explain folder purpose.
- [ ] Configure Godot input action for move up.
- [ ] Configure Godot input action for move down.
- [ ] Configure Godot input action for move left.
- [ ] Configure Godot input action for move right.
- [ ] Configure Godot input action for fire.
- [ ] Confirm that the project opens correctly in Godot 4.x.
- [ ] Confirm that the repository remains clean after project setup files are saved.

Completion check:

- [ ] Folder structure exists.
- [ ] Input actions are configured.
- [ ] Project opens in Godot 4.x without setup errors.

## 5. Milestone 2: Player Vertical Slice

Goal: Create the first playable vertical slice with player movement, firing, and visible projectiles.

Tasks:

- [ ] Create the `Player` scene.
- [ ] Create the `Player` script.
- [ ] Add the first pixel art player ship sprite.
- [ ] Implement WASD movement.
- [ ] Implement slightly accelerated movement.
- [ ] Clamp the player ship inside the visible gameplay bounds.
- [ ] Create the `Weapon` script for the basic player weapon.
- [ ] Create the `PlayerProjectile` scene.
- [ ] Create the `PlayerProjectile` script.
- [ ] Implement hold-to-fire behavior with Space.
- [ ] Spawn visible player projectiles from the player ship.
- [ ] Move player projectiles upward.
- [ ] Remove player projectiles after they leave the play area.
- [ ] Add simple debug logs for firing if useful during development.

Completion check:

- [ ] Player ship is visible.
- [ ] Player moves with WASD.
- [ ] Player cannot leave the play area.
- [ ] Holding Space creates visible upward-moving projectiles.
- [ ] Projectiles are removed after leaving the play area.

## 6. Milestone 3: Enemy and Collision

Goal: Add the enemy, projectile collision, player damage, lives, and temporary invulnerability.

Tasks:

- [ ] Create the `Enemy` scene.
- [ ] Create the `Enemy` script.
- [ ] Add the first pixel art enemy ship sprite.
- [ ] Implement enemy downward movement.
- [ ] Implement slight horizontal oscillation.
- [ ] Create the `EnemyWeapon` script.
- [ ] Create the `EnemyProjectile` scene.
- [ ] Create the `EnemyProjectile` script.
- [ ] Implement fixed-interval enemy firing.
- [ ] Move enemy projectiles downward.
- [ ] Remove enemy projectiles after they leave the play area.
- [ ] Implement `Area2D`-based hit detection for projectiles and ships.
- [ ] Implement player projectile hitting enemy.
- [ ] Destroy enemy in one hit from player projectile.
- [ ] Remove player projectile after enemy hit.
- [ ] Implement enemy projectile damaging player.
- [ ] Implement enemy ship contact damaging player.
- [ ] Add player life tracking with 3 lives.
- [ ] Add 1.5-second temporary invulnerability after player damage.
- [ ] Prevent repeated instant damage during invulnerability.
- [ ] Emit or log player damaged events.
- [ ] Emit or log player dead events.
- [ ] Emit or log enemy destroyed events.

Completion check:

- [ ] Enemy is visible and moves downward with slight horizontal oscillation.
- [ ] Enemy fires downward projectiles.
- [ ] Player projectiles destroy enemies in one hit.
- [ ] Enemy projectiles reduce player lives.
- [ ] Enemy ship contact reduces player lives.
- [ ] Temporary invulnerability prevents repeated instant damage.
- [ ] Player death can be detected when lives reach 0.

## 7. Milestone 4: Wave System

Goal: Implement the 3 fixed enemy waves using Godot Resource-based wave data.

Tasks:

- [ ] Create the wave data Resource script.
- [ ] Create the Wave 1 Resource file.
- [ ] Create the Wave 2 Resource file.
- [ ] Create the Wave 3 Resource file.
- [ ] Configure wave number data.
- [ ] Configure enemy count data.
- [ ] Configure enemy fire interval data.
- [ ] Configure spawn area limit data.
- [ ] Set Wave 1 to 3 enemies.
- [ ] Set Wave 2 to 5 enemies.
- [ ] Set Wave 3 to 7 enemies.
- [ ] Configure enemy fire interval to increase difficulty from wave to wave.
- [ ] Create the `WaveManager` script.
- [ ] Load the 3 fixed wave resources.
- [ ] Spawn enemies for the current wave.
- [ ] Spawn enemies at random positions within configured spawn area limits.
- [ ] Track enemy destroyed events.
- [ ] Start the next wave immediately after the current wave is cleared.
- [ ] Emit an all-waves-cleared event after Wave 3 is completed.
- [ ] Add simple debug logs for wave started.
- [ ] Add simple debug logs for enemy destroyed.
- [ ] Add simple debug logs for all waves cleared.

Completion check:

- [ ] Wave 1 starts with 3 enemies.
- [ ] Wave 2 starts after Wave 1 is cleared.
- [ ] Wave 3 starts after Wave 2 is cleared.
- [ ] Wave 3 completion emits all-waves-cleared.
- [ ] Enemy fire interval changes by wave.
- [ ] Spawn positions stay inside configured spawn area limits.

## 8. Milestone 5: UI and Game States

Goal: Implement the full game flow with start, gameplay, win, game over, HUD, and restart behavior.

Tasks:

- [ ] Implement the `START` game state.
- [ ] Implement the `PLAYING` game state.
- [ ] Implement the `WIN` game state.
- [ ] Implement the `GAME_OVER` game state.
- [ ] Add start UI inside the `Main` scene.
- [ ] Display the game title on the start screen.
- [ ] Display a start prompt on the start screen.
- [ ] Display a controls hint on the start screen.
- [ ] Create the `HUD` scene.
- [ ] Display player lives in the HUD.
- [ ] Display current wave number in the HUD.
- [ ] Update HUD when player lives change.
- [ ] Update HUD when the current wave changes.
- [ ] Create the `ResultPanel` scene.
- [ ] Show "You Win" when all waves are cleared.
- [ ] Show "Game Over" when player lives reach 0.
- [ ] Add a new game option to the result screen.
- [ ] Emit `restart_requested` from `ResultPanel`.
- [ ] Implement `Main.reset_game()`.
- [ ] Clear enemies and projectiles during reset.
- [ ] Reset player position, lives, and invulnerability during reset.
- [ ] Reset wave progress during reset.
- [ ] Start Wave 1 after reset.
- [ ] Show and hide UI elements based on the current game state.

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

- [ ] Finalize the MVP pixel art player ship sprite.
- [ ] Finalize the MVP pixel art enemy ship sprite.
- [ ] Finalize the MVP pixel art player projectile sprite.
- [ ] Finalize the MVP pixel art enemy projectile sprite.
- [ ] Finalize the basic enemy destruction effect.
- [ ] Finalize the simple dark space background.
- [ ] Add player projectile visual feedback.
- [ ] Add enemy projectile visual feedback.
- [ ] Add enemy destruction visual feedback.
- [ ] Add player damage blink feedback.
- [ ] Add visible temporary invulnerability feedback.
- [ ] Add 8-bit/chiptune-style player fire sound.
- [ ] Add 8-bit/chiptune-style enemy destruction sound.
- [ ] Tune player acceleration.
- [ ] Tune player deceleration.
- [ ] Tune player maximum speed.
- [ ] Tune weapon fire cooldown.
- [ ] Tune projectile speeds.
- [ ] Tune enemy movement speed.
- [ ] Tune enemy horizontal oscillation amount.
- [ ] Tune enemy fire intervals per wave.
- [ ] Run manual playtests for average session length.
- [ ] Run manual playtests for medium difficulty.
- [ ] Run manual playtests for damage feedback clarity.
- [ ] Run manual playtests for wave difficulty progression.

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

- [ ] Verify that the game starts from the start screen.
- [ ] Verify that the player moves with WASD.
- [ ] Verify that the player cannot leave the play area.
- [ ] Verify that the player can hold Space to fire repeatedly.
- [ ] Verify that player projectiles destroy enemies.
- [ ] Verify that enemies move downward with slight horizontal oscillation.
- [ ] Verify that enemies fire downward at fixed intervals.
- [ ] Verify that enemy projectiles damage the player.
- [ ] Verify that enemy ship contact damages the player.
- [ ] Verify that temporary invulnerability prevents repeated instant damage.
- [ ] Verify that waves progress from Wave 1 to Wave 3.
- [ ] Verify that the win state appears after all 3 waves are cleared.
- [ ] Verify that the game over state appears when player lives reach 0.
- [ ] Verify that restart clears gameplay objects and starts a new game.
- [ ] Verify that HUD updates lives and current wave correctly.
- [ ] Fix blocking bugs found during manual testing.
- [ ] Confirm the game opens correctly in Godot 4.x.
- [ ] Create a Windows playable desktop export.
- [ ] Create a macOS playable desktop export.
- [ ] Verify exported builds can be launched.
- [ ] Prepare a short GitHub Release note.
- [ ] Publish build files through GitHub Releases.
- [ ] Confirm release assets are downloadable.

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
- [ ] Task not completed yet
- [x] Task completed
```

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
