-- packages/ui/src/MathUtil.luau
-- Issue #15: Common math helpers shared across both proof games.
-- Pure functions with no Roblox API dependencies.

local MathUtil = {}

--- Clamp value to the range [min, max] (inclusive on both ends).
function MathUtil.clamp(value, min, max)
    if value < min then
        return min
    elseif value > max then
        return max
    end
    return value
end

--- Linear interpolation: returns a + (b - a) * t.
--- t = 0 returns a, t = 1 returns b, values outside [0,1] extrapolate.
function MathUtil.lerp(a, b, t)
    return a + (b - a) * t
end

--- Re-map value from the input range [inMin, inMax] to [outMin, outMax].
--- Does not clamp the result; use MathUtil.clamp if that is needed.
function MathUtil.remap(value, inMin, inMax, outMin, outMax)
    local t = (value - inMin) / (inMax - inMin)
    return outMin + (outMax - outMin) * t
end

--- Round value to the nearest integer (0.5 rounds up).
function MathUtil.round(value)
    return math.floor(value + 0.5)
end

--- Return true when value is within epsilon of target.
--- epsilon defaults to 1e-6 when not provided.
function MathUtil.approxEqual(value, target, epsilon)
    epsilon = epsilon or 1e-6
    return math.abs(value - target) <= epsilon
end

return MathUtil
