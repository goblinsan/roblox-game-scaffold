-- packages/ui/src/Panel.luau
-- Issue #14: Base Panel component (styled container Frame) with theme tokens.
-- Adds a UICorner and UIPadding automatically so child components are inset
-- from the edges without the caller having to create them manually.

local Theme = require(script.Parent.Theme)

local Panel = {}

--- Create a styled Frame container.
--- @param options table? – Optional overrides:
---   size         UDim2           Frame size (default UDim2.fromOffset(200, 150))
---   position     UDim2           Frame position (default UDim2.fromOffset(0, 0))
---   color        Color3          Background colour (default Theme.Colors.Surface)
---   cornerRadius UDim            Corner radius (default Theme.CornerRadius.Medium)
---   padding      UDim            Uniform inner padding (default Theme.Padding.Medium)
---   parent       Instance?       Optional parent; set last to avoid layout thrash
--- Returns the Frame Instance.
function Panel.new(options)
    options = options or {}

    local panel = Instance.new("Frame")
    panel.Size = options.size or UDim2.fromOffset(200, 150)
    panel.Position = options.position or UDim2.fromOffset(0, 0)
    panel.BackgroundColor3 = options.color or Theme.Colors.Surface
    panel.BorderSizePixel = 0

    local corner = Instance.new("UICorner")
    corner.CornerRadius = options.cornerRadius or Theme.CornerRadius.Medium
    corner.Parent = panel

    local padding = Instance.new("UIPadding")
    local pad = options.padding or Theme.Padding.Medium
    padding.PaddingTop = pad
    padding.PaddingBottom = pad
    padding.PaddingLeft = pad
    padding.PaddingRight = pad
    padding.Parent = panel

    if options.parent then
        panel.Parent = options.parent
    end

    return panel
end

return Panel
