-- packages/ui/src/Button.luau
-- Issue #14: Base Button component with hover/press tinting using theme tokens.
-- Returns a result table { button, disconnect } so the caller can parent the
-- TextButton and later disconnect internal event connections via Trove or manually.

local Theme = require(script.Parent.Theme)

local Button = {}

--- Create a styled TextButton.
--- @param options table? – Optional overrides:
---   text        string          Button label (default "Button")
---   textSize    number          Font size (default Theme.TextSize.Default)
---   font        Enum.Font       Font face (default Theme.Font.Default)
---   size        UDim2           Button size (default UDim2.fromOffset(120, 36))
---   onClick     function?       Callback fired on Activated
---   parent      Instance?       Optional parent; set last to avoid layout thrash
--- Returns { button: TextButton, disconnect: () -> () }
function Button.new(options)
    options = options or {}

    local button = Instance.new("TextButton")
    button.Text = options.text or "Button"
    button.TextSize = options.textSize or Theme.TextSize.Default
    button.Font = options.font or Theme.Font.Default
    button.TextColor3 = Theme.Colors.Text
    button.BackgroundColor3 = Theme.Colors.Primary
    button.AutoButtonColor = false
    button.Size = options.size or UDim2.fromOffset(120, 36)
    button.BorderSizePixel = 0

    local corner = Instance.new("UICorner")
    corner.CornerRadius = Theme.CornerRadius.Medium
    corner.Parent = button

    -- Hover / press tinting
    local connections = {}

    connections[#connections + 1] = button.MouseEnter:Connect(function()
        button.BackgroundColor3 = Theme.Colors.Hover
    end)
    connections[#connections + 1] = button.MouseLeave:Connect(function()
        button.BackgroundColor3 = Theme.Colors.Primary
    end)
    connections[#connections + 1] = button.MouseButton1Down:Connect(function()
        button.BackgroundColor3 = Theme.Colors.Pressed
    end)
    connections[#connections + 1] = button.MouseButton1Up:Connect(function()
        button.BackgroundColor3 = Theme.Colors.Primary
    end)

    if options.onClick then
        connections[#connections + 1] = button.Activated:Connect(options.onClick)
    end

    if options.parent then
        button.Parent = options.parent
    end

    local function disconnect()
        for _, c in connections do
            c:Disconnect()
        end
    end

    return { button = button, disconnect = disconnect }
end

return Button
