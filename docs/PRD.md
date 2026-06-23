# Mini Space Wars PRD

## 1. Document Information

| Field | Value |
|---|---|
| Document Name | Mini Space Wars PRD |
| Product / Project Name | Mini Space Wars |
| Version | v1.2 |
| Date | June 21, 2026 |
| Product Owner / Developer | Oguzhan FIDE |
| Support | ChatGPT / Codex |
| Document Status | Approved |

## 2. Product Summary

Mini Space Wars is a small-scope, single-player, 2D vertical space shooter to be developed with Godot. The player controls a single spaceship with the keyboard and tries to destroy incoming enemy waves. The MVP is centered around clearing a fixed number of enemy waves within a short play session. A boss encounter is not included in the first release scope and will be considered as a future idea.

## 3. Project Purpose

The purpose of Mini Space Wars is to complete a small-scope 2D game from idea stage to a publishable release while experiencing the end-to-end game development process.

The project will include PRD, GDD, TDD, task planning, development, testing, and publishing steps. Learning Godot and GDScript will be handled together with the goal of producing a completable MVP.

The publishing goal is to prepare the game as a desktop executable build and make it shareable through GitHub Releases.

## 4. Target User

The primary target users of Mini Space Wars are new game developers learning Godot and GDScript. The project is designed as an example of how a small-scope 2D game can be completed from idea stage to a publishable release.

The game aims to provide an experience that can be quickly understood by a player familiar with simple arcade shooters. The difficulty level is defined as medium: the player should be able to understand the basic controls quickly, but should need to move carefully and avoid enemy attacks to complete all waves.

## 5. MVP Scope

The Mini Space Wars MVP is limited to a short, completable, and publishable 2D vertical space shooter. The MVP includes the following features:

- Single-player gameplay experience
- Desktop-playable game
- One player spaceship controlled with the keyboard
- Firing with one basic weapon
- 2D play area that creates a vertical scrolling shooter feel
- One enemy type
- 3 fixed enemy waves
- Player life system
- Shooting and destroying enemies
- Player taking damage from enemy projectiles and enemy ship contact
- Wave completion and game end states
- Simple start, gameplay, and result screens
- Simple start and gameplay background music
- Desktop build shareable through GitHub Releases

## 6. Out of Scope

The following features are not included in the Mini Space Wars MVP scope:

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

## 7. Functional Requirements

- FR-01: The player must be able to start the game from the start screen.
- FR-02: The player ship must be movable within the play area using the keyboard.
- FR-03: The player ship must not be able to leave the play area.
- FR-04: The player must be able to fire using one basic weapon.
- FR-05: When a player projectile hits an enemy, the enemy must be destroyed.
- FR-06: The game must include a total of 3 fixed enemy waves.
- FR-07: Each enemy wave must start after all enemies in the previous wave have been destroyed.
- FR-08: The game must include only 1 enemy type.
- FR-09: Enemies must enter from the top of the play area and move downward.
- FR-10: Enemies must fire projectiles that can damage the player.
- FR-11: When the player ship is hit by an enemy projectile or touches an enemy ship, the player must lose 1 life.
- FR-12: The player must start the game with 3 lives.
- FR-13: When the player's life count reaches 0, the game must end as a loss.
- FR-14: When the player destroys all enemies in all 3 enemy waves, the game must end as a win.
- FR-15: When the game ends, the win or loss result must be shown to the player.
- FR-16: After the game ends, the player must be able to start a new game.
- FR-17: The game must be able to be prepared as a desktop executable build.

## 8. Success and Completion Criteria

The Mini Space Wars MVP is considered complete when the following criteria are met:

- The game can be started from the start screen.
- The player ship can be controlled with the keyboard and cannot leave the play area.
- The player can shoot and destroy enemies using one basic weapon.
- The game runs 3 fixed enemy waves in sequence.
- Each new wave starts after all enemies in the previous wave have been destroyed.
- Enemies move downward from the top of the play area and fire projectiles at the player.
- The player starts with 3 lives.
- The player loses life when hit by an enemy projectile or touching an enemy ship.
- A loss state is shown when the player's life count reaches 0.
- A win state is shown when the player destroys all enemies in all 3 waves.
- A new game can be started after the game ends.
- An average play session can be completed in approximately 2-4 minutes.
- The game is prepared as an executable desktop build.
- The build is made downloadable through GitHub Releases.
