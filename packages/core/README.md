# packages/core

Reusable core scaffold systems shared across all games in this monorepo.

## Systems

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

-- PlayerService: react to player lifecycle events
local disconnect = Core.PlayerService.onPlayerAdded(function(player)
    print(player.Name, "joined")
end)
disconnect() -- unsubscribe

-- DataStore: safe read/write with automatic retries
local store = Core.DataStore.new("PlayerData", { fallback = {} })
local data = store:get(tostring(player.UserId))
store:set(tostring(player.UserId), { coins = 100 })

-- RemoteRegistry: create and retrieve remotes by name (server)
local event = Core.RemoteRegistry.registerEvent("GiveCoin")
event.OnServerEvent:Connect(function(player) end)
-- ... on client:
local event = Core.RemoteRegistry.get("GiveCoin")
event:FireServer()

-- RoundManager: guarded state machine
local round = Core.RoundManager.new()
round:onStateChanged(function(new, prev)
    print(prev, "→", new)
end)
round:start()      -- waiting → starting
round:beginRound() -- starting → inRound
round:endRound()   -- inRound  → ending
round:reset()      -- ending   → waiting

-- Config: scaffold defaults + game overrides
local cfg = Core.Config.new(
    { round = { duration = 60, minPlayers = 2 } }, -- defaults
    { round = { duration = 120 } }                  -- game overrides
)
print(cfg:get("round.duration"))    -- 120
print(cfg:get("round.minPlayers"))  -- 2
cfg:set("round.duration", 90)
```

## Development

This package lives at `packages/core/` in the monorepo root.  
Changes here are picked up by the root `default.project.json` scaffold project via the `Core` path alias.
