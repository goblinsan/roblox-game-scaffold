-- packages/ui/src/Theme.luau
-- Issue #14: Design-token table for base UI components.
-- Centralises colors, fonts, sizes and corner radii so components stay visually
-- consistent and games can swap themes by overriding this module's values.

local Theme = {}

--- Color palette.
Theme.Colors = {
    Background = Color3.fromRGB(30, 30, 40),
    Surface = Color3.fromRGB(45, 45, 60),
    Primary = Color3.fromRGB(80, 140, 255),
    Text = Color3.fromRGB(240, 240, 245),
    TextMuted = Color3.fromRGB(160, 160, 175),
    Border = Color3.fromRGB(60, 60, 80),
    Hover = Color3.fromRGB(100, 160, 255),
    Pressed = Color3.fromRGB(60, 110, 220),
    Disabled = Color3.fromRGB(80, 80, 100),
}

--- Font faces used across components.
Theme.Font = {
    Default = Enum.Font.GothamMedium,
    Heading = Enum.Font.GothamBold,
    Mono = Enum.Font.Code,
}

--- Font size scale in pixels.
Theme.TextSize = {
    Small = 12,
    Default = 14,
    Large = 18,
    Heading = 22,
}

--- Corner radius tokens.
Theme.CornerRadius = {
    Small = UDim.new(0, 4),
    Medium = UDim.new(0, 8),
    Large = UDim.new(0, 12),
}

--- Uniform padding tokens.
Theme.Padding = {
    Small = UDim.new(0, 4),
    Medium = UDim.new(0, 8),
    Large = UDim.new(0, 16),
}

return Theme
