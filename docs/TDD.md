# Mini Space Wars TDD

## 1. Document Information

| Field | Value |
|---|---|
| Document Name | Mini Space Wars TDD |
| Product / Project Name | Mini Space Wars |
| Version | v1.0 |
| Date | June 21, 2026 |
| Product Owner / Developer | Oguzhan FIDE |
| Support | ChatGPT / Codex |
| Document Status | Approved |

## 2. Technical Overview

Mini Space Wars will be developed with Godot 4.x using GDScript.

The game targets desktop platforms and uses a simple scene-based architecture suitable for a small MVP. The technical design should prioritize clarity, learnability, and completion over heavy abstraction.

The project should keep the number of scenes and scripts small. Shared systems may be introduced only when they reduce duplicated logic or make the game flow easier to understand.

## 3. Target Platform and Build

The MVP targets desktop platforms.

The planned desktop export targets are:

- Windows
- macOS

The release goal is to prepare a playable desktop export for each supported platform and publish the build files through GitHub Releases.

Installer packages are not required for the MVP.

## 4. Project Folder Structure

The project will use a medium-detail folder structure to keep gameplay code, scenes, and assets organized without adding unnecessary complexity.

Planned folder structure:

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

Documents remain in the `docs/` folder.

## 5. Scene Architecture

The game will use one main scene to manage the overall game flow. Start, gameplay, and result states will be handled inside the main scene through UI state changes instead of separate screen scenes.

Reusable gameplay objects will be implemented as separate scenes so they can be instantiated when needed.

Planned scene responsibilities:

| Scene | Responsibility |
|---|---|
| Main | Owns the game flow, wave progression, UI state, and high-level reset logic |
| Player | Represents the player ship and handles player movement, firing requests, damage state, and lives |
| Enemy | Represents the single enemy type, including movement, firing behavior, and destruction |
| PlayerProjectile | Represents a projectile fired by the player |
| EnemyProjectile | Represents a projectile fired by enemies |
| HUD | Displays player lives and current wave |
| ResultPanel | Displays win or loss result and allows starting a new game |

## 6. Main Scene Responsibilities

The `Main` scene owns the high-level game flow and current game state.

The game state will be tracked in `Main` with a simple enum-like state value. Planned states are:

- `START`
- `PLAYING`
- `WIN`
- `GAME_OVER`

`Main` is responsible for:

- Showing the correct UI state
- Starting a new game
- Resetting player, enemies, projectiles, and wave state
- Receiving win and loss events
- Switching to the result state
- Coordinating between gameplay objects and UI

Wave spawning and wave completion tracking will be handled by a lightweight `WaveManager` script. The `WaveManager` should remain small and focused on:

- Storing references to the 3 fixed wave definitions
- Spawning enemies for the current wave
- Tracking when the current wave is cleared
- Requesting the next wave when needed
- Notifying `Main` when all waves are completed

The `WaveManager` should not own UI state, player lives, result screens, or global game state.

## 7. Player Technical Design

The `Player` scene represents the player ship.

The `Player` script is responsible for:

- Reading player movement input
- Applying slightly accelerated movement
- Keeping the player inside the gameplay bounds
- Reading fire input
- Sending fire input to the `Weapon`
- Tracking the player's current lives
- Applying damage from enemy projectiles and enemy ship contact
- Managing the 1.5-second temporary invulnerability period
- Emitting events when the player takes damage
- Emitting an event when the player runs out of lives

The player movement should use acceleration and deceleration values, while still keeping the ship responsive.

The `Player` should expose events that allow `Main` and `HUD` to react without owning player-specific logic.

## 8. Weapon and Projectile Technical Design

The player weapon will use a lightweight `Weapon` script.

The `Weapon` script is responsible for:

- Tracking the fire cooldown
- Checking whether the weapon can fire
- Spawning player projectiles
- Supporting hold-to-fire behavior from the player's fire input

The `Weapon` script supports only one basic weapon in the MVP. It must not include weapon upgrades, alternate firing modes, ammo systems, or multiple weapon types.

`PlayerProjectile` is responsible for:

- Moving upward at a fixed speed
- Detecting collision with enemies
- Destroying the enemy on hit
- Removing itself after a hit or after leaving the play area

`EnemyProjectile` is responsible for:

- Moving downward at a fixed speed
- Detecting collision with the player
- Requesting player damage on hit
- Removing itself after a hit or after leaving the play area

## 9. Enemy Technical Design

The `Enemy` scene represents the single enemy type in the MVP.

The `Enemy` script is responsible for:

- Moving downward
- Applying slight horizontal oscillation
- Detecting hits from player projectiles
- Destroying itself when hit
- Emitting a destroyed event when removed by player damage
- Handling contact with the player ship

Enemy firing will be handled by a lightweight `EnemyWeapon` script.

The `EnemyWeapon` script is responsible for:

- Tracking the enemy fire interval
- Spawning enemy projectiles
- Firing downward at fixed intervals
- Allowing the fire interval to be adjusted per wave

The `Enemy` emits a destroyed event when it is destroyed. `WaveManager` listens to enemy destroyed events to track wave progress.

The MVP includes only one enemy type. The enemy system should not include enemy variants, enemy health scaling, elite enemies, or complex AI behaviors.

## 10. WaveManager Technical Design

`WaveManager` is responsible for fixed wave progression.

Wave definitions will be stored as Godot Resource files. Each wave resource should define only the data needed for the MVP wave behavior.

Planned wave resource data:

- Wave number
- Enemy count
- Enemy fire interval
- Spawn area limits

`WaveManager` is responsible for:

- Loading the 3 fixed wave resources
- Starting Wave 1 when gameplay begins
- Spawning the required number of enemies for the current wave
- Choosing random enemy spawn positions within the configured spawn area limits
- Listening to enemy destroyed events
- Tracking remaining enemies in the current wave
- Starting the next wave immediately after the current wave is cleared
- Emitting an all-waves-cleared event after Wave 3 is completed

Random spawn must remain constrained by each wave's configured spawn area limits. The system should not generate random wave structures, random enemy types, or endless waves.

## 11. Collision and Damage Flow

The game will use `Area2D`-based hit detection for projectiles, enemies, and player damage interactions.

Planned logical collision groups:

- Player
- Enemy
- PlayerProjectile
- EnemyProjectile

Damage flow:

1. `PlayerProjectile` detects contact with an `Enemy`.
2. `PlayerProjectile` requests the enemy to be destroyed.
3. The enemy emits a destroyed event.
4. `WaveManager` receives the destroyed event and updates wave progress.
5. `PlayerProjectile` removes itself.

Player damage flow from enemy projectile:

1. `EnemyProjectile` detects contact with the `Player`.
2. `EnemyProjectile` requests player damage.
3. `Player` checks whether temporary invulnerability is active.
4. If invulnerability is inactive, `Player` loses 1 life and emits a damage event.
5. `EnemyProjectile` removes itself.

Player damage flow from enemy ship contact:

1. `Player` or `Enemy` detects contact between the player ship and an enemy ship.
2. `Player` checks whether temporary invulnerability is active.
3. If invulnerability is inactive, `Player` loses 1 life and emits a damage event.
4. The enemy ship remains active unless destroyed by a player projectile.

Exact collision layer and mask numbers will be decided during implementation.

## 12. UI Technical Design

The game uses UI state changes inside the `Main` scene instead of switching between separate screen scenes.

`HUD` and `ResultPanel` will be implemented as reusable UI scenes.

`HUD` is responsible for:

- Displaying the player's current lives
- Displaying the current wave number
- Updating when player lives change
- Updating when the current wave changes

`ResultPanel` is responsible for:

- Displaying the win or loss result text
- Showing a new game option after the game ends
- Emitting a restart request event when the player chooses to start a new game

The start screen remains part of the `Main` scene UI state. It displays the game title, start prompt, and controls hint.

`Main` is responsible for showing and hiding the start UI, HUD, and result UI based on the current game state.

## 13. Signals and Events

The project will use Godot signals for key communication between scenes. Signal names should use English `snake_case`.

Planned signals:

| Signal | Emitted By | Used By | Purpose |
|---|---|---|---|
| `game_started` | Main | Main / UI | Indicates that a new game has started |
| `player_damaged` | Player | HUD / Main | Updates lives display and feedback |
| `player_dead` | Player | Main | Triggers the game over state |
| `projectile_hit_enemy` | PlayerProjectile | Enemy / optional debugging | Indicates that a player projectile hit an enemy |
| `enemy_destroyed` | Enemy | WaveManager | Updates current wave progress |
| `wave_started` | WaveManager | HUD / Main | Updates current wave display |
| `all_waves_cleared` | WaveManager | Main | Triggers the win state |
| `restart_requested` | ResultPanel | Main | Starts a new game from the result screen |

Signals should be used for state changes and cross-scene communication. Simple internal behavior should remain inside the responsible script instead of being converted into signals unnecessarily.

## 14. Data and Resources

The project will use Godot Resource files only for wave data.

Each wave resource should contain:

- Wave number
- Enemy count
- Enemy fire interval
- Spawn area limits

Player, enemy, weapon, and projectile tuning values should be exposed as script export variables on their related scenes or scripts.

Examples of export variables include:

- Player acceleration
- Player deceleration
- Player maximum speed
- Player invulnerability duration
- Player weapon fire cooldown
- Projectile speed
- Enemy movement speed
- Enemy horizontal oscillation amount
- Enemy fire interval fallback value

The MVP should not use a centralized gameplay config system unless the implementation becomes difficult to maintain without it.

## 15. State Management

`Main` will manage the high-level game state.

Planned game states:

- `START`
- `PLAYING`
- `WIN`
- `GAME_OVER`

State responsibilities:

| State | Active UI | Gameplay Active | Description |
|---|---|---:|---|
| `START` | Start UI | No | Shows title, start prompt, and controls hint |
| `PLAYING` | HUD | Yes | Runs player control, enemies, projectiles, and waves |
| `WIN` | ResultPanel | No | Shows the win result after all waves are cleared |
| `GAME_OVER` | ResultPanel | No | Shows the loss result after player lives reach 0 |

Win and game over remain separate states to keep result handling explicit.

Pause, loading, settings, and menu sub-states are not included in the MVP.

## 16. Reset and Restart Flow

Starting a new game and restarting after a result use the same reset flow.

When a new game starts, `Main` should:

1. Clear existing enemies.
2. Clear existing player projectiles.
3. Clear existing enemy projectiles.
4. Reset the player position.
5. Reset the player's lives to 3.
6. Reset temporary invulnerability state.
7. Reset wave progress.
8. Show the HUD.
9. Set the game state to `PLAYING`.
10. Start Wave 1 through `WaveManager`.

After a win or loss, `ResultPanel` emits `restart_requested`. `Main` receives this signal and calls `reset_game()`.

The MVP should avoid full scene reload for restart unless manual reset becomes unreliable.

## 17. Asset Pipeline

Pixel art sprites should be exported as PNG files.

Planned sprite asset location:

```text
res://assets/sprites/
```

Simple sound effects should be stored as WAV files.

Planned audio asset location:

```text
res://assets/audio/
```

Godot import settings should preserve pixel art readability. Sprite filtering should be disabled where needed to avoid blurry pixel art.

The MVP should include only the assets required by the approved GDD content list.

## 18. Testing and Debugging Approach

The MVP will use a manual testing approach.

A manual test checklist should verify the following areas:

- Game starts from the start screen
- Player moves with WASD
- Player cannot leave the play area
- Player can hold Space to fire repeatedly
- Player projectiles destroy enemies
- Enemies move downward with slight horizontal oscillation
- Enemies fire downward at fixed intervals
- Enemy projectiles damage the player
- Enemy ship contact damages the player
- Temporary invulnerability prevents repeated instant damage
- Waves progress from Wave 1 to Wave 3
- Win state appears after all 3 waves are cleared
- Game over state appears when player lives reach 0
- Restart clears gameplay objects and starts a new game
- HUD updates lives and current wave correctly

Simple debug logs may be used during development for important events such as:

- Wave started
- Enemy destroyed
- Player damaged
- Player dead
- All waves cleared
- Game restarted

Debug logs should support development and troubleshooting, but they should not be required for normal gameplay.

## 19. Export and Release Technical Notes

The MVP will use manual export through the Godot editor.

Planned export targets:

- Windows playable desktop export
- macOS playable desktop export

Each GitHub Release should include:

- Playable build files for the supported desktop platforms
- A short release note describing the build contents and known limitations

Installer packages, automated CI export, store publishing, and code signing are not required for the MVP.

## 20. Technical Completion Criteria

The TDD is considered complete when the technical design is clear enough to create an implementation task plan.

Completion requires that the following areas are defined:

- Target Godot version and platform targets
- Project folder structure
- Scene architecture
- Main scene responsibilities
- Player technical behavior
- Weapon and projectile responsibilities
- Enemy technical behavior
- WaveManager design
- Collision and damage flow
- UI technical design
- Signals and events
- Data and Resource usage
- State management
- Reset and restart flow
- Asset pipeline
- Testing and debugging approach
- Export and release notes

After the TDD is approved, the next project step will be the Task Plan.
