-- packages/core/src/init.luau
-- Entry point for the Core scaffold package.
-- Each system is exposed as a named field so consumers can do:
--   local Core = require(game.ReplicatedStorage.Core)
--   local round = Core.RoundManager.new()

local Core = {}

Core.PlayerService = require(script.PlayerService)
Core.DataStore = require(script.DataStore)
Core.RemoteRegistry = require(script.RemoteRegistry)
Core.RoundManager = require(script.RoundManager)
Core.Config = require(script.Config)

return Core
