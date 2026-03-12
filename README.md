# roblox-game-scaffold

Rojo-based Roblox monorepo scaffold with reusable core systems and proof games.  
Game modules are reusable and versioned from day one using **Rojo** + **Wally**.

## Repository layout

```
.
├── packages/
│   ├── core/          # Reusable core systems (player, datastore, remotes, rounds, config)
│   └── ui/            # UI primitives and theme tokens
├── games/
│   ├── game-01/       # Obby with checkpoint persistence
│   └── game-02/       # Round-based minigame (tag / colour-sort)
├── default.project.json   # Rojo scaffold development project
├── wally.toml             # Root Wally manifest (shared dev deps)
└── aftman.toml            # Pinned tool versions (rojo, wally)
```

## Prerequisites

Install [aftman](https://github.com/LPGhatguy/aftman) then run:

```bash
aftman install   # installs rojo + wally at the versions in aftman.toml
```

## Working on a game

```bash
cd games/game-01
wally install                              # install Wally dependencies
rojo serve default.project.json           # live-sync with Roblox Studio
# or
rojo build default.project.json --output game-01.rbxlx
```

## Lockfile policy

`wally.lock` files are committed alongside every `wally.toml`.  
Dependency bumps are made in a dedicated commit so the lockfile diff is easy to review.  
CI runs `wally install` to verify lockfiles are consistent.

## CI

GitHub Actions runs a smoke test on every PR:

- `wally install` for each game
- `rojo build` for each game and the scaffold root

See [`.github/workflows/ci.yml`](.github/workflows/ci.yml).
