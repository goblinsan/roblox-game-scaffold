-- packages/core/src/PlayerService.luau
-- Issue #6: Player lifecycle service (join/leave/respawn hooks).
-- Exposes subscribe APIs so downstream game logic can react to player events
-- without directly coupling to Players service connections.

local Players = game:GetService("Players")

local PlayerService = {}

--- Subscribe to players joining the game.
--- The handler is also called immediately for any players already in the server.
--- Returns a disconnect function that cancels the subscription.
function PlayerService.onPlayerAdded(handler)
    local connection = Players.PlayerAdded:Connect(handler)
    for _, player in Players:GetPlayers() do
        task.spawn(handler, player)
    end
    return function()
        connection:Disconnect()
    end
end

--- Subscribe to players leaving the game.
--- Returns a disconnect function that cancels the subscription.
function PlayerService.onPlayerRemoving(handler)
    local connection = Players.PlayerRemoving:Connect(handler)
    return function()
        connection:Disconnect()
    end
end

--- Subscribe to a specific player's character being added (spawn or respawn).
--- If the player already has a loaded character the handler is called immediately.
--- Returns a disconnect function that cancels the subscription.
function PlayerService.onCharacterAdded(player, handler)
    local connection = player.CharacterAdded:Connect(handler)
    if player.Character then
        task.spawn(handler, player.Character)
    end
    return function()
        connection:Disconnect()
    end
end

return PlayerService
