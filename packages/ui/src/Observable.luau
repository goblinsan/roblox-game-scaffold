-- packages/ui/src/Observable.luau
-- Issue #12: Reactive value wrapper.
-- Wraps a single value and notifies subscribers only when the value changes.
-- Handlers receive (newValue, previousValue) so they can diff if needed.
-- Pairs naturally with Trove for subscription cleanup.

local Observable = {}
Observable.__index = Observable

--- Create a new Observable with an initial value.
--- @param initial any – The starting value (may be nil).
function Observable.new(initial)
    local self = setmetatable({}, Observable)
    self._value = initial
    self._handlers = {}
    self._nextId = 0
    return self
end

--- Return the current value without triggering any notifications.
function Observable:get()
    return self._value
end

--- Set a new value.  Notifies subscribers only when the value differs from the
--- current one (strict equality check).
--- @param newValue any – The replacement value.
function Observable:set(newValue)
    if newValue == self._value then
        return
    end
    local prev = self._value
    self._value = newValue
    for _, handler in self._handlers do
        task.spawn(handler, newValue, prev)
    end
end

--- Subscribe to value changes.
--- The handler is called with (newValue, previousValue) whenever the value
--- changes.  Returns a disconnect function that cancels this subscription.
--- @param handler function – Called as handler(newValue, previousValue).
function Observable:subscribe(handler)
    self._nextId += 1
    local id = self._nextId
    self._handlers[id] = handler
    return function()
        self._handlers[id] = nil
    end
end

--- Disconnect all subscribers and render the observable inert.
function Observable:destroy()
    self._handlers = {}
end

return Observable
