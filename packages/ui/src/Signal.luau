-- packages/ui/src/Signal.luau
-- Issue #12: Minimal owned signal primitive.
-- Lightweight alternative to BindableEvent – no Instance overhead, no memory
-- leaks from forgotten :Destroy() calls.  Handlers are fired via task.spawn so
-- each listener runs independently without blocking the fire call.

local Signal = {}
Signal.__index = Signal

--- Create a new Signal.
function Signal.new()
    local self = setmetatable({}, Signal)
    self._handlers = {}
    self._nextId = 0
    return self
end

--- Connect a handler to the signal.
--- Returns a disconnect function that removes only this handler.
function Signal:connect(handler)
    self._nextId += 1
    local id = self._nextId
    self._handlers[id] = handler
    return function()
        self._handlers[id] = nil
    end
end

--- Fire the signal, calling all connected handlers with the given arguments.
--- Each handler is spawned independently via task.spawn.
function Signal:fire(...)
    for _, handler in self._handlers do
        task.spawn(handler, ...)
    end
end

--- Disconnect all handlers and render the signal inert.
function Signal:destroy()
    self._handlers = {}
end

return Signal
