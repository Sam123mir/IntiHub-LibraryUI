local Creator = require("../../modules/Creator")
local New = Creator.New
local Tween = Creator.Tween

local Color3 = Color3
local UDim = UDim
local UDim2 = UDim2
local Font = Font
local Enum = Enum

local MinimizedBar = {
    Window = nil,
    Bar = nil,
    Version = "2.0.0", -- Default version
}

function MinimizedBar.New(Window)
    local Self = {
        Window = Window,
        Dragging = false,
    }

    local DragHandle = New("ImageLabel", {
        Name = "DragHandle",
        Size = UDim2.new(0, 24, 0, 24),
        BackgroundTransparency = 1,
        Image = Creator.Icon("grip-vertical")[1],
        ImageRectOffset = Creator.Icon("grip-vertical")[2].ImageRectPosition,
        ImageRectSize = Creator.Icon("grip-vertical")[2].ImageRectSize,
        ImageColor3 = Color3.fromHex("#FFD700"),
    })

    local Title = New("TextLabel", {
        Name = "Title",
        Text = "INTIHUB - v" .. (Window.Version or "2.0.0"),
        TextSize = 14,
        FontFace = Font.new(Creator.Font, Enum.FontWeight.Bold),
        TextColor3 = Color3.fromHex("#FFD700"),
        BackgroundTransparency = 1,
        AutomaticSize = "X",
        Size = UDim2.new(0, 0, 1, 0),
    })

    local Separator = New("Frame", {
        Name = "Separator",
        Size = UDim2.new(0, 1, 0, 18),
        BackgroundColor3 = Color3.fromHex("#FFD700"),
        BackgroundTransparency = 0.6,
    })

    local BarFrame = New("Frame", {
        Name = "IntiHubMinimizedBar",
        Size = UDim2.new(0, 0, 0, 36),
        Position = UDim2.new(0.5, 0, 0.05, 0), -- Top-center default
        AnchorPoint = Vector2.new(0.5, 0),
        BackgroundColor3 = Color3.fromHex("#0A0A0A"),
        Active = true,
        Visible = false,
        Parent = Window.Parent,
        AutomaticSize = "X",
    }, {
        New("UICorner", { CornerRadius = UDim.new(0, 8) }),
        New("UIStroke", {
            Thickness = 1.5,
            Color = Color3.fromHex("#FFD700"),
            Transparency = 0.3,
        }),
        New("UIListLayout", {
            FillDirection = "Horizontal",
            VerticalAlignment = "Center",
            Padding = UDim.new(0, 12),
            HorizontalAlignment = "Center",
        }),
        New("UIPadding", {
            PaddingLeft = UDim.new(0, 12),
            PaddingRight = UDim.new(0, 16),
        }),
        DragHandle,
        Separator,
        Title,
    })

    Self.Bar = BarFrame

    -- Custom Drag logic for the handle
    local DragModule = Creator.Drag(BarFrame, {DragHandle}, function(dragging)
        Self.Dragging = dragging
        if not dragging then
            -- Optional: Save position or snap
        end
    end)

    -- Interaction: Click Title to Restore
    local ClickButton = New("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        Parent = Title,
        ZIndex = 10,
    })

    Creator.AddSignal(ClickButton.MouseButton1Click, function()
        if not Self.Dragging then
            Window:Open()
        end
    end)

    function Self:Visible(Value)
        if Value then
            BarFrame.Visible = true
            Tween(BarFrame, 0.4, { BackgroundTransparency = 0 }, Enum.EasingStyle.Quint):Play()
        else
            local T = Tween(BarFrame, 0.3, { BackgroundTransparency = 1 }, Enum.EasingStyle.Quint)
            T.Completed:Connect(function() BarFrame.Visible = false end)
            T:Play()
        end
    end

    return Self
end

return MinimizedBar
