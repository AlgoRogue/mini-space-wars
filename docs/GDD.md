# Mini Space Wars GDD

## 1. Document Information

| Field | Value |
|---|---|
| Document Name | Mini Space Wars GDD |
| Product / Project Name | Mini Space Wars |
| Version | v1.0 |
| Date | June 21, 2026 |
| Product Owner / Developer | Oguzhan FIDE |
| Support | ChatGPT / Codex |
| Document Status | Approved |

## 2. Game Overview

Mini Space Wars is a classic arcade-style 2D vertical space shooter. The player controls a single spaceship, avoids enemy projectiles and enemy ship contact, and shoots incoming enemies across a short sequence of fixed waves.

The main objective is to clear all 3 enemy waves without losing all lives. The game session ends with a win when all enemies in the 3 waves are destroyed, or with a loss when the player's life count reaches 0.

## 3. Core Gameplay Loop

The core gameplay loop is:

1. Move the player ship within the play area.
2. Position the ship to line up shots with incoming enemies.
3. Fire the basic weapon forward.
4. Avoid enemy projectiles and enemy ship contact.
5. Destroy all enemies in the current wave.
6. Advance to the next wave.
7. Repeat until all 3 waves are cleared or the player loses all lives.

The player weapon always fires forward from the player ship. The player does not aim with the mouse or change firing direction.

## 4. Player Controls

The player controls the ship using the keyboard.

| Action | Input |
|---|---|
| Move Up | W |
| Move Down | S |
| Move Left | A |
| Move Right | D |
| Fire Basic Weapon | Space |

The player ship moves within the play area and cannot leave the visible gameplay bounds. The basic weapon fires forward when the player presses Space.

## 5. Player Ship

The player controls one spaceship throughout the game. The ship uses slightly accelerated movement: when a movement key is pressed, the ship quickly accelerates toward the intended direction, and when the key is released, it slows down quickly. The movement should still feel responsive and easy to control.

The player ship starts each game with 3 lives. When hit by an enemy projectile or touching an enemy ship, the player loses 1 life.

After taking damage, the player receives a short temporary invulnerability period. During this period, enemy projectiles and enemy ship contact do not remove extra lives. The purpose of this rule is to prevent the player from losing multiple lives instantly from overlapping hits.

If the player's life count reaches 0, the game ends with a loss state.

## 6. Basic Weapon

The player has one basic weapon. The weapon fires forward from the player ship.

The player can hold Space to fire repeatedly at a fixed firing interval. The weapon does not require separate button presses for each shot.

Player projectiles travel upward across the play area. When a player projectile hits an enemy, the enemy is destroyed in one hit.

The MVP does not include alternate weapons, weapon upgrades, charge shots, spread shots, or power-ups.

## 7. Enemy Design

The MVP includes one enemy type.

Enemies enter from the top of the play area and move downward. While moving downward, they also use a slight horizontal oscillation to make their movement less static. This movement should remain simple and predictable enough for a short MVP game.

Enemies fire projectiles downward at fixed intervals. Enemy projectiles can damage the player ship.

Each enemy is destroyed in one hit from a player projectile. The MVP does not include enemy health variation, enemy upgrades, elite enemies, or multiple enemy types.

## 8. Wave Design

The game includes 3 fixed enemy waves.

| Wave | Enemy Count |
|---|---:|
| Wave 1 | 3 |
| Wave 2 | 5 |
| Wave 3 | 7 |

Each wave starts after all enemies in the previous wave have been destroyed. There is no intentional pause between waves; the next wave begins immediately after the current wave is cleared.

The wave structure should create a simple difficulty ramp by increasing the number of enemies in each wave. The MVP does not include random waves, endless waves, branching levels, or procedural wave generation.

## 9. Damage and Lives

The player starts each game with 3 lives.

The player loses 1 life when hit by an enemy projectile. The player also loses 1 life when the player ship touches an enemy ship.

After taking damage, the player receives 1.5 seconds of temporary invulnerability. During this period, enemy projectiles and enemy ship contact do not remove additional lives.

If the player's life count reaches 0, the game ends with a loss state.

Enemy projectiles and enemy ship contact are the only damage sources in the MVP.

## 10. Win and Loss Conditions

The player wins when all enemies in all 3 waves have been destroyed. When this happens, the game shows a simple "You Win" result.

The player loses when the player's life count reaches 0. When this happens, the game shows a "Game Over" result with an option to start a new game.

After either a win or a loss, the player can start a new game from the result screen.

## 11. Screens and Game Flow

The game includes three main screen states: start screen, gameplay screen, and result screen.

### Start Screen

The start screen shows the game title, a prompt to start the game, and a brief controls hint.

### Gameplay Screen

The gameplay screen shows the active play area and a minimal HUD. The HUD displays the player's remaining lives and the current wave number.

### Result Screen

The result screen shows either a "You Win" result or a "Game Over" result. After the result is shown, the player can start a new game.

### Game Flow

1. The game opens on the start screen.
2. The player starts the game.
3. The gameplay screen begins with Wave 1.
4. The player clears waves or loses all lives.
5. The result screen is shown.
6. The player can start a new game from the result screen.

## 12. Game Feel and Feedback

The MVP uses simple visual and audio feedback to make core actions understandable.

Visual feedback includes:

- Visible player projectiles and enemy projectiles
- A simple enemy destruction effect when an enemy is destroyed
- A brief player damage blink when the player loses a life
- A visible indication of the temporary invulnerability period after player damage

Audio feedback includes:

- A simple sound when the player fires the basic weapon
- A simple sound when an enemy is destroyed

The MVP does not include screen shake, advanced particle effects, complex animations, voice-over, or a full music system.

## 13. Difficulty and Balance

The game targets a medium difficulty level.

Difficulty increases across waves through two factors:

- The number of enemies increases from wave to wave.
- Enemy firing frequency increases slightly from wave to wave.

The balance target is that a new player should be able to win after a few attempts. The game should not be tuned so that most new players win immediately on the first attempt, but it should also not require long practice or memorization.

The expected average play session length remains approximately 2-4 minutes.

## 14. Art Direction

The game uses a simple pixel art visual style. The art should be readable, lightweight, and achievable within the MVP scope.

The visual theme uses a dark space background with brighter colors for the player ship, enemies, projectiles, and important gameplay feedback. This contrast should make moving objects easy to identify during gameplay.

The MVP art scope includes simple sprites for:

- Player ship
- Enemy ship
- Player projectile
- Enemy projectile
- Basic enemy destruction effect
- Simple background

The MVP does not require detailed animations, high-resolution illustrations, complex backgrounds, or cinematic visual assets.

## 15. Audio Direction

The MVP does not include background music.

The game uses simple 8-bit/chiptune-style sound effects for core gameplay feedback. The MVP audio scope includes:

- Player basic weapon fire sound
- Enemy destruction sound

The MVP does not include background music, ambient audio, voice-over, advanced sound mixing, or multiple sound variations for the same action.

## 16. MVP Content List

The MVP requires the following gameplay and presentation content:

- One player ship
- One basic player weapon
- Player projectiles
- One enemy type
- Enemy projectiles
- 3 fixed enemy waves
- Player life system with 3 lives
- Temporary invulnerability after player damage
- Start screen
- Gameplay screen
- Result screen with win and loss states
- Minimal HUD showing lives and current wave
- Simple pixel art sprites
- Dark space background
- Basic enemy destruction visual feedback
- Player damage blink feedback
- Simple 8-bit/chiptune-style fire sound
- Simple 8-bit/chiptune-style enemy destruction sound

## 17. Out of Scope

The following features are not included in the Mini Space Wars MVP:

- Boss encounter
- Multiplayer game mode
- Online features
- Mobile platform support
- Controller support
- Save system
- Scoreboard or persistent score saving
- Shop, inventory, or progression system
- Multiple player ships
- Multiple weapon types
- Multiple enemy types
- Power-ups or power-up system
- Story, mission, or level selection system
- Cutscenes
- Advanced visual effects
- Advanced sound and music system

## 18. Design Completion Criteria

The GDD is considered complete when the MVP gameplay decisions are clear enough to begin technical design and implementation planning.

Completion requires that the following areas are defined:

- Core gameplay loop
- Player controls
- Player ship behavior
- Basic weapon behavior
- Enemy behavior
- Wave structure
- Damage and lives rules
- Win and loss conditions
- Screen flow
- Feedback, art, and audio direction
- MVP content list
- Out-of-scope design items

After the GDD is approved, the next project document will be the TDD.
