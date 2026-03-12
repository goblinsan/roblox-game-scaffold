-- packages/ui/src/Trove.luau
-- Issue #13: Lifecycle cleanup utility.
-- Collects RBXScriptConnections, Instances, functions, and objects that expose
-- a :destroy() / :Destroy() method so everything can be cleaned up in one call.
-- Items are cleaned in reverse order of insertion (LIFO) which mirrors typical
-- teardown patterns.

local Trove = {}
Trove.__index = Trove

--- Create a new Trove.
function Trove.new()
    local self = setmetatable({}, Trove)
    self._items = {}
    return self
end

--- Add an item to the trove for deferred cleanup.
--- Accepted types:
---   • RBXScriptConnection  – disconnected via :Disconnect()
---   • Instance             – destroyed via :Destroy()
---   • function             – called with no arguments
---   • table with a :destroy() or :Destroy() method
--- Returns the item unchanged so the call can be chained.
function Trove:add(item)
    table.insert(self._items, item)
    return item
end

--- Connect a signal and add the resulting connection to the trove.
--- Equivalent to:  trove:add(signal:Connect(handler))
--- Returns the RBXScriptConnection.
function Trove:connect(signal, handler)
    return self:add(signal:Connect(handler))
end

--- Clean up all tracked items in reverse order of insertion.
--- After this call the trove is empty and may be reused.
function Trove:clean()
    for i = #self._items, 1, -1 do
        local item = self._items[i]
        local t = typeof(item)
        if t == "RBXScriptConnection" then
            item:Disconnect()
        elseif t == "Instance" then
            item:Destroy()
        elseif t == "function" then
            item()
        elseif type(item) == "table" then
            if type(item.destroy) == "function" then
                item:destroy()
            elseif type(item.Destroy) == "function" then
                item:Destroy()
            end
        end
    end
    self._items = {}
end

--- Alias for clean() so that Troves satisfy the :destroy() contract and can be
--- nested inside other Troves or lifecycle managers.
function Trove:destroy()
    self:clean()
end

return Trove
