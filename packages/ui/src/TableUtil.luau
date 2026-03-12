-- packages/ui/src/TableUtil.luau
-- Issue #15: Common table helpers shared across both proof games.
-- Pure functions – no Roblox API dependencies so this module is also safe to
-- use in server-side scripts.

local TableUtil = {}

--- Return a shallow copy of t.
function TableUtil.copy(t)
    local result = {}
    for k, v in t do
        result[k] = v
    end
    return result
end

--- Deep-copy t, recursing into nested tables.
--- Non-table values are copied by value (strings, numbers, booleans, etc.).
function TableUtil.deepCopy(t)
    local result = {}
    for k, v in t do
        if type(v) == "table" then
            result[k] = TableUtil.deepCopy(v)
        else
            result[k] = v
        end
    end
    return result
end

--- Return true if the array portion of t contains value (strict equality).
function TableUtil.contains(t, value)
    for _, v in t do
        if v == value then
            return true
        end
    end
    return false
end

--- Return a new array of elements from t for which predicate(v) is true.
function TableUtil.filter(t, predicate)
    local result = {}
    for _, v in t do
        if predicate(v) then
            result[#result + 1] = v
        end
    end
    return result
end

--- Apply fn to every element of t and return a new array of the results.
--- Array indices are preserved (gaps are not collapsed).
function TableUtil.map(t, fn)
    local result = {}
    for i, v in t do
        result[i] = fn(v)
    end
    return result
end

--- Reduce t to a single accumulated value starting from initial.
--- fn is called as fn(accumulator, value) for each element in order.
function TableUtil.reduce(t, fn, initial)
    local acc = initial
    for _, v in t do
        acc = fn(acc, v)
    end
    return acc
end

--- Return the number of key-value pairs in a dictionary (works for any table).
--- For plain arrays prefer the # operator; this is for mixed / dictionary tables.
function TableUtil.count(t)
    local n = 0
    for _ in t do
        n += 1
    end
    return n
end

return TableUtil
