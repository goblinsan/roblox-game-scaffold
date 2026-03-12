# packages/ui

Lightweight owned UI primitives and theme tokens for Roblox games.  
Avoids framework lock-in while keeping development fast.

## Planned components

| Module | Issue | Description |
|---|---|---|
| `Observable` / `Signal` | [#12](https://github.com/goblinsan/roblox-game-scaffold/issues/12) | Minimal reactive state primitive |
| `Trove` lifecycle | [#13](https://github.com/goblinsan/roblox-game-scaffold/issues/13) | Deterministic connection/instance cleanup |
| Base components | [#14](https://github.com/goblinsan/roblox-game-scaffold/issues/14) | Label, Button, Panel with theme tokens |
| Shared utilities | [#15](https://github.com/goblinsan/roblox-game-scaffold/issues/15) | Table/math/signal helpers |

## Usage

```lua
-- Once published to the Wally registry add to your game's wally.toml:
-- UI = "goblinsan/ui@^0.1.0"

local UI = require(game.ReplicatedStorage.Packages.UI)
```

## Development

This package lives at `packages/ui/` in the monorepo root.  
Changes here are picked up by the root `default.project.json` scaffold project via the `UI` path alias.
