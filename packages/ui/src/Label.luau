-- packages/ui/src/Label.luau
-- Issue #14: Base Label component using theme tokens.
-- Creates a styled TextLabel with sensible defaults drawn from Theme.
-- The returned Instance can be parented and customised by the caller.

local Theme = require(script.Parent.Theme)

local Label = {}

--- Create a styled TextLabel.
--- @param options table? – Optional overrides:
---   text        string          Label text (default "")
---   textSize    number          Font size in pixels (default Theme.TextSize.Default)
---   font        Enum.Font       Font face (default Theme.Font.Default)
---   color       Color3          Text colour (default Theme.Colors.Text)
---   parent      Instance?       Optional parent; set last to avoid layout thrash
--- Returns the TextLabel Instance.
function Label.new(options)
    options = options or {}
    local label = Instance.new("TextLabel")
    label.Text = options.text or ""
    label.TextSize = options.textSize or Theme.TextSize.Default
    label.Font = options.font or Theme.Font.Default
    label.TextColor3 = options.color or Theme.Colors.Text
    label.BackgroundTransparency = 1
    label.AutomaticSize = Enum.AutomaticSize.XY
    label.Size = UDim2.fromOffset(0, 0)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Center
    if options.parent then
        label.Parent = options.parent
    end
    return label
end

return Label
