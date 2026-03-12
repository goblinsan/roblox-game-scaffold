-- packages/ui/src/init.luau
-- Entry point for the UI scaffold package.
-- All sub-modules are exposed as named fields so consumers can do:
--   local UI = require(game.ReplicatedStorage.UI)
--   local obs = UI.Observable.new(0)

local UI = {}

-- Issue #12: Reactive state primitives
UI.Signal = require(script.Signal)
UI.Observable = require(script.Observable)

-- Issue #13: Lifecycle cleanup utility
UI.Trove = require(script.Trove)

-- Issue #14: Theme tokens + base components
UI.Theme = require(script.Theme)
UI.Label = require(script.Label)
UI.Button = require(script.Button)
UI.Panel = require(script.Panel)

-- Issue #15: Shared utility helpers
UI.TableUtil = require(script.TableUtil)
UI.MathUtil = require(script.MathUtil)

return UI
