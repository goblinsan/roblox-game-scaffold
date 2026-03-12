-- packages/core/src/DataStore.luau
-- Issue #7: DataStore wrapper with retries, timeout, and fallback.
-- Wraps Roblox DataStore calls with a safe retry strategy and typed payload
-- helpers so callers never need to write raw pcall/retry boilerplate.

local DataStoreService = game:GetService("DataStoreService")

local DEFAULT_MAX_RETRIES = 3
local DEFAULT_RETRY_DELAY = 1 -- seconds between retry attempts

local DataStore = {}
DataStore.__index = DataStore

--- Create a new DataStore wrapper.
--- @param name string        – The DataStore name passed to GetDataStore.
--- @param options table?     – Optional settings:
---   maxRetries  number  (default 3)   – How many times to retry a failed call.
---   retryDelay  number  (default 1)   – Seconds to wait between retries.
---   fallback    any     (default nil) – Value returned when a get fails or the
---                                       key does not exist in the store.
function DataStore.new(name, options)
    options = options or {}
    local self = setmetatable({}, DataStore)
    self._store = DataStoreService:GetDataStore(name)
    self._maxRetries = options.maxRetries or DEFAULT_MAX_RETRIES
    self._retryDelay = options.retryDelay or DEFAULT_RETRY_DELAY
    self._fallback = options.fallback
    return self
end

--- Internal helper: call fn up to maxRetries times, waiting retryDelay seconds
--- between each attempt.  Returns (true, result) on success or (false, err) on
--- exhaustion.
function DataStore:_retry(fn)
    local attempts = 0
    local success, result
    repeat
        attempts += 1
        success, result = pcall(fn)
        if not success and attempts < self._maxRetries then
            task.wait(self._retryDelay)
        end
    until success or attempts >= self._maxRetries
    if not success then
        warn("[DataStore] Failed after " .. attempts .. " attempt(s): " .. tostring(result))
        return false, result
    end
    return true, result
end

--- Read a key from the DataStore.
--- Returns the stored value on success, or the configured fallback on failure /
--- when the key does not exist.
function DataStore:get(key)
    local ok, value = self:_retry(function()
        return self._store:GetAsync(key)
    end)
    if ok then
        if value ~= nil then
            return value
        end
        return self._fallback
    end
    return self._fallback
end

--- Write a value to the DataStore.
--- Returns true on success, false on failure.
function DataStore:set(key, value)
    local ok = self:_retry(function()
        self._store:SetAsync(key, value)
    end)
    return ok
end

--- Update a key in the DataStore using a transform function.
--- transformFn receives the current value and must return the new value.
--- Returns true on success, false on failure.
function DataStore:update(key, transformFn)
    local ok = self:_retry(function()
        self._store:UpdateAsync(key, transformFn)
    end)
    return ok
end

return DataStore
