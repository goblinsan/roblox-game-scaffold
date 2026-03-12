# packages/ui

Lightweight owned UI primitives and theme tokens for Roblox games.  
Avoids framework lock-in while keeping development fast.

## Modules

| Module | Issue | Description |
|---|---|---|
| `Signal` | [#12](https://github.com/goblinsan/roblox-game-scaffold/issues/12) | Minimal owned signal primitive (fire/connect/disconnect) |
| `Observable` | [#12](https://github.com/goblinsan/roblox-game-scaffold/issues/12) | Reactive value wrapper – notifies subscribers on change |
| `Trove` | [#13](https://github.com/goblinsan/roblox-game-scaffold/issues/13) | Lifecycle cleanup – collects connections, instances, functions |
| `Theme` | [#14](https://github.com/goblinsan/roblox-game-scaffold/issues/14) | Design tokens: colors, fonts, sizes, corner radii, padding |
| `Label` | [#14](https://github.com/goblinsan/roblox-game-scaffold/issues/14) | Styled TextLabel component |
| `Button` | [#14](https://github.com/goblinsan/roblox-game-scaffold/issues/14) | Styled TextButton with hover/press tinting |
| `Panel` | [#14](https://github.com/goblinsan/roblox-game-scaffold/issues/14) | Styled Frame container with corner radius and padding |
| `TableUtil` | [#15](https://github.com/goblinsan/roblox-game-scaffold/issues/15) | Table helpers: copy, deepCopy, contains, filter, map, reduce, count |
| `MathUtil` | [#15](https://github.com/goblinsan/roblox-game-scaffold/issues/15) | Math helpers: clamp, lerp, remap, round, approxEqual |

## Usage

```lua
-- Once published to the Wally registry add to your game's wally.toml:
-- UI = "goblinsan/ui@^0.1.0"

local UI = require(game.ReplicatedStorage.UI)

-- Signal: lightweight event primitive
local signal = UI.Signal.new()
local disconnect = signal:connect(function(value)
    print("received:", value)
end)
signal:fire(42)   -- prints "received: 42"
disconnect()      -- unsubscribe

-- Observable: reactive value wrapper
local health = UI.Observable.new(100)
local unsub = health:subscribe(function(new, prev)
    print("health changed from", prev, "to", new)
end)
health:set(80)    -- prints "health changed from 100 to 80"
unsub()           -- unsubscribe

-- Trove: deterministic lifecycle cleanup
local trove = UI.Trove.new()
trove:connect(game.Players.PlayerAdded, function(p) print(p.Name) end)
trove:add(function() print("cleaned up") end)
trove:clean()     -- disconnects all, calls all functions

-- Theme: design tokens
print(UI.Theme.Colors.Primary)           -- Color3
print(UI.Theme.TextSize.Default)         -- 14
print(UI.Theme.CornerRadius.Medium)      -- UDim

-- Label: styled TextLabel
local label = UI.Label.new({ text = "Hello", parent = screenGui })

-- Button: styled TextButton with tinting
local result = UI.Button.new({
    text = "Play",
    onClick = function() print("clicked") end,
    parent = screenGui,
})
-- result.button    → TextButton instance
-- result.disconnect() → cleans up hover/press connections

-- Panel: styled Frame container
local panel = UI.Panel.new({ size = UDim2.fromOffset(300, 200), parent = screenGui })

-- TableUtil: common table helpers
local doubled = UI.TableUtil.map({ 1, 2, 3 }, function(v) return v * 2 end)
local evens   = UI.TableUtil.filter({ 1, 2, 3, 4 }, function(v) return v % 2 == 0 end)

-- MathUtil: common math helpers
local clamped = UI.MathUtil.clamp(150, 0, 100)  -- 100
local mid     = UI.MathUtil.lerp(0, 10, 0.5)    -- 5
```

## Development

This package lives at `packages/ui/` in the monorepo root.  
Changes here are picked up by the root `default.project.json` scaffold project via the `UI` path alias.
