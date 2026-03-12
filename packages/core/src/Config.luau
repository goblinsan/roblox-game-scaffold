-- packages/core/src/Config.luau
-- Issue #10: Configuration layering (scaffold defaults + game overrides).
-- Games supply their own override table that is deep-merged on top of the
-- scaffold defaults so per-game customisation never requires forking internals.

local Config = {}
Config.__index = Config

--- Deep-merge table b on top of table a.
--- Nested tables are merged recursively; scalar values in b override a.
local function deepMerge(a, b)
    local result = {}
    for k, v in a do
        if type(v) == "table" and type(b[k]) == "table" then
            result[k] = deepMerge(v, b[k])
        else
            if b[k] ~= nil then
                result[k] = b[k]
            else
                result[k] = v
            end
        end
    end
    for k, v in b do
        if result[k] == nil then
            result[k] = v
        end
    end
    return result
end

--- Split a dot-separated key path into a list of parts.
local function splitPath(keyPath)
    local parts = {}
    for part in keyPath:gmatch("[^%.]+") do
        table.insert(parts, part)
    end
    return parts
end

--- Create a new Config instance.
--- @param defaults  table   – Scaffold-level default key/value pairs (may be nested).
--- @param overrides table?  – Game-level overrides deep-merged on top of defaults.
function Config.new(defaults, overrides)
    local self = setmetatable({}, Config)
    self._data = deepMerge(defaults or {}, overrides or {})
    return self
end

--- Read a value by dot-separated key path (e.g. "round.duration").
--- Returns nil if any segment of the path does not exist.
function Config:get(keyPath)
    local parts = splitPath(keyPath)
    local current = self._data
    for _, part in parts do
        if type(current) ~= "table" then
            return nil
        end
        current = current[part]
    end
    return current
end

--- Write a value at a dot-separated key path, creating intermediate tables as
--- needed (e.g. Config:set("round.duration", 120)).
function Config:set(keyPath, value)
    local parts = splitPath(keyPath)
    local current = self._data
    for i = 1, #parts - 1 do
        local part = parts[i]
        if type(current[part]) ~= "table" then
            current[part] = {}
        end
        current = current[part]
    end
    current[parts[#parts]] = value
end

return Config
