-- packages/core/src/RoundManager.luau
-- Issue #9: Round state machine (waiting → starting → inRound → ending → waiting).
-- Provides lifecycle hooks and guarded transitions so game-specific modes can
-- react to round events without reimplementing the state machine.

local RoundManager = {}
RoundManager.__index = RoundManager

--- Valid round states.
RoundManager.State = {
    Waiting = "waiting",
    Starting = "starting",
    InRound = "inRound",
    Ending = "ending",
}

-- Allowed forward transitions from each state.
local VALID_TRANSITIONS = {
    [RoundManager.State.Waiting] = { RoundManager.State.Starting },
    [RoundManager.State.Starting] = { RoundManager.State.InRound },
    [RoundManager.State.InRound] = { RoundManager.State.Ending },
    [RoundManager.State.Ending] = { RoundManager.State.Waiting },
}

--- Create a new RoundManager instance starting in the Waiting state.
function RoundManager.new()
    local self = setmetatable({}, RoundManager)
    self._state = RoundManager.State.Waiting
    self._handlers = {}
    return self
end

--- Return the current round state string.
function RoundManager:getState()
    return self._state
end

--- Register a callback invoked whenever the state changes.
--- The callback receives (newState, previousState).
--- Returns a disconnect function that removes the callback.
function RoundManager:onStateChanged(handler)
    table.insert(self._handlers, handler)
    return function()
        for i, h in self._handlers do
            if h == handler then
                table.remove(self._handlers, i)
                break
            end
        end
    end
end

--- Attempt to transition to newState.
--- The transition is rejected (with a warning) if it is not in the allowed set
--- for the current state.
--- Returns true if the transition succeeded, false otherwise.
function RoundManager:transition(newState)
    local allowed = VALID_TRANSITIONS[self._state]
    if not allowed then
        warn("[RoundManager] No transitions defined from state: " .. self._state)
        return false
    end
    local isValid = false
    for _, s in allowed do
        if s == newState then
            isValid = true
            break
        end
    end
    if not isValid then
        warn("[RoundManager] Invalid transition: " .. self._state .. " → " .. newState)
        return false
    end
    local prev = self._state
    self._state = newState
    for _, handler in self._handlers do
        task.spawn(handler, newState, prev)
    end
    return true
end

--- Convenience: transition from Waiting → Starting.
function RoundManager:start()
    return self:transition(RoundManager.State.Starting)
end

--- Convenience: transition from Starting → InRound.
function RoundManager:beginRound()
    return self:transition(RoundManager.State.InRound)
end

--- Convenience: transition from InRound → Ending.
function RoundManager:endRound()
    return self:transition(RoundManager.State.Ending)
end

--- Convenience: transition from Ending → Waiting (reset for the next round).
function RoundManager:reset()
    return self:transition(RoundManager.State.Waiting)
end

return RoundManager
