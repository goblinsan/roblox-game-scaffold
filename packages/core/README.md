# packages/core

Reusable core scaffold systems shared across all games in this monorepo.

## Planned systems

| Module | Issue | Description |
|---|---|---|
| `PlayerService` | [#6](https://github.com/goblinsan/roblox-game-scaffold/issues/6) | Player join/leave/respawn lifecycle hooks |
| `DataStore` | [#7](https://github.com/goblinsan/roblox-game-scaffold/issues/7) | DataStore wrapper with retries, timeout, and fallback |
| `RemoteRegistry` | [#8](https://github.com/goblinsan/roblox-game-scaffold/issues/8) | Centralised RemoteEvent/RemoteFunction registration |
| `RoundManager` | [#9](https://github.com/goblinsan/roblox-game-scaffold/issues/9) | Round state machine (waiting → starting → in-round → ending) |
| `Config` | [#10](https://github.com/goblinsan/roblox-game-scaffold/issues/10) | Configuration layering (scaffold defaults + per-game overrides) |

## Usage

```lua
-- Once published to the Wally registry add to your game's wally.toml:
-- Core = "goblinsan/core@^0.1.0"

local Core = require(game.ReplicatedStorage.Packages.Core)
```

## Development

This package lives at `packages/core/` in the monorepo root.  
Changes here are picked up by the root `default.project.json` scaffold project via the `Core` path alias.
