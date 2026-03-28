local OpenButtonModule = {}

local Creator = require("../../modules/Creator")
local New = Creator.New
local Tween = Creator.Tween

local cloneref = (cloneref or clonereference or function(instance) return instance end)
local UserInputService = cloneref(game:GetService("UserInputService"))

function OpenButtonModule.New(Window)
    local OpenButtonMain = {
        Button = nil
    }
    
    local Title = New("TextLabel", {
        Text = "INTIHUB",
        TextSize = 13,
        FontFace = Font.new(Creator.Font, Enum.FontWeight.Bold),
        BackgroundTransparency = 1,
        AutomaticSize = "XY",
        ThemeTag = {
            TextColor3 = "Accent",
        },
        LayoutOrder = 1,
    })

    local LiveTag = New("Frame", {
        Size = UDim2.new(0,45,0,20),
        BackgroundColor3 = Color3.new(1,1,1),
        BackgroundTransparency = .92,
        LayoutOrder = 2,
    }, {
        New("UICorner", { CornerRadius = UDim.new(1,0) }),
        New("Frame", {
            Name = "Dot",
            Size = UDim2.new(0,6,0,6),
            Position = UDim2.new(0,8,0.5,0),
            AnchorPoint = Vector2.new(0,0.5),
            BackgroundColor3 = Color3.fromHex("#FFD700"),
        }, {
            New("UICorner", { CornerRadius = UDim.new(1,0) })
        }),
        New("TextLabel", {
            Text = "LIVE",
            TextSize = 10,
            FontFace = Font.new(Creator.Font, Enum.FontWeight.Bold),
            TextColor3 = Color3.new(1,1,1),
            TextTransparency = .4,
            Position = UDim2.new(0,18,0.5,0),
            AnchorPoint = Vector2.new(0,0.5),
            BackgroundTransparency = 1,
        })
    })

    local Container = New("Frame", {
        Size = UDim2.new(0,200,0,40),
        Position = UDim2.new(0.5,0,0,50),
        AnchorPoint = Vector2.new(0.5,0.5),
        Parent = Window.Parent,
        BackgroundTransparency = 1,
        Active = true,
        Visible = false,
    })

    local UIScale = New("UIScale", { Scale = 1 })

    local Button = New("Frame", {
        Size = UDim2.new(0, 160, 0, 32),
        AutomaticSize = "None",
        Parent = Container,
        BackgroundColor3 = Color3.fromHex("#0F0D00"),
        BackgroundTransparency = .4,
    }, {
        UIScale,
	    New("UICorner", { CornerRadius = UDim.new(0,10) }),
        New("UIStroke", {
            Thickness = 1.5,
            Color = Color3.fromHex("#FFD700"),
            Transparency = .5,
            Name = "Stroke"
        }),
        
        New("UIPadding", {
            PaddingLeft = UDim.new(0,15),
            PaddingRight = UDim.new(0,15),
        }),
        
        New("UIListLayout", {
            Padding = UDim.new(0, 12),
            FillDirection = "Horizontal",
            VerticalAlignment = "Center",
            HorizontalAlignment = "Center",
            SortOrder = "LayoutOrder",
        }),

        Title,
        LiveTag,

        New("TextButton", {
            Size = UDim2.new(1,0,1,0),
            BackgroundTransparency = 1,
            Text = "",
            ZIndex = 11,
            Name = "ClickButton"
        })
    })

    local DragModule = Creator.Drag(Container)

    Creator.AddSignal(Button.ClickButton.MouseButton1Click, function()
        Window:Open()
    end)

    -- Pulsing animation for LightDot
    task.spawn(function()
        while true do
            local dot = LiveTag:FindFirstChild("Dot")
            if dot then
                Tween(dot, 0.8, {BackgroundTransparency = 0.5}, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut):Play()
                task.wait(0.8)
                Tween(dot, 0.8, {BackgroundTransparency = 0}, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut):Play()
                task.wait(0.8)
            else
                break
            end
        end
    end)
    
    function OpenButtonMain:Visible(v)
        Container.Visible = v
    end
    
    function OpenButtonMain:SetScale(scale)
        UIScale.Scale = scale
    end

    function OpenButtonMain:SetIcon()
        -- Disabled for Noble Deluxe
    end
    
    function OpenButtonMain:Edit(OpenButtonConfig)
        if OpenButtonConfig.Title then
            Title.Text = OpenButtonConfig.Title:upper()
        end
        if OpenButtonConfig.Scale then
            OpenButtonMain:SetScale(OpenButtonConfig.Scale)
        end
    end

    OpenButtonMain.Button = Button
    return OpenButtonMain
end

return OpenButtonModule