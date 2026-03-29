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
    
    local Branding = New("Frame", {
        Name = "Branding",
        BackgroundTransparency = 1,
        AutomaticSize = "XY",
    }, {
        New("UIListLayout", {
            FillDirection = "Horizontal",
            VerticalAlignment = "Center",
            Padding = UDim.new(0, 2),
        }),
        New("TextLabel", {
            Text = "INTI",
            TextSize = 13,
            FontFace = Font.new(Creator.Font, Enum.FontWeight.Bold),
            BackgroundTransparency = 1,
            AutomaticSize = "XY",
            TextColor3 = Color3.fromHex("#FFD700"),
        }),
        New("TextLabel", {
            Text = "HUB",
            TextSize = 13,
            FontFace = Font.new(Creator.Font, Enum.FontWeight.Bold),
            BackgroundTransparency = 1,
            AutomaticSize = "XY",
            TextColor3 = Color3.fromHex("#000000"),
        }),
    })

    local DragHandle = New("ImageLabel", {
        Size = UDim2.new(0, 18, 0, 18),
        BackgroundTransparency = 1,
        Image = "rbxassetid://138450125867375", -- Move/Drag arrows icon
        ImageColor3 = Color3.fromHex("#FFD700"),
    })

    local Separator = New("Frame", {
        Size = UDim2.new(0, 1, 0, 16),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 0.8,
        BorderSizePixel = 0,
    })

    local Container = New("Frame", {
        Size = UDim2.new(0, 150, 0, 40),
        Position = UDim2.new(0.5, 0, 1, -60), -- Bottom position like StatusBar
        AnchorPoint = Vector2.new(0.5, 1),
        Parent = Window.Parent,
        BackgroundTransparency = 1,
        Active = true,
        Visible = false,
    }, {
        New("UIScale", { Name = "UIScale", Scale = 1 })
    })

    local Button = New("Frame", {
        Name = "Bar",
        AutomaticSize = "X",
        Size = UDim2.new(0, 100, 0, 32),
        Parent = Container,
        BackgroundColor3 = Color3.fromHex("#0F0D00"),
        BackgroundTransparency = 0.35,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
    }, {
        New("UICorner", { CornerRadius = UDim.new(0, 8) }),
        New("UIStroke", {
            Thickness = 1.2,
            Color = Color3.fromHex("#FFD700"),
            Transparency = 0.5,
        }),
        New("UIPadding", {
            PaddingLeft = UDim.new(0, 12),
            PaddingRight = UDim.new(0, 12),
        }),
        New("UIListLayout", {
            Padding = UDim.new(0, 10),
            FillDirection = "Horizontal",
            VerticalAlignment = "Center",
            HorizontalAlignment = "Center",
        }),
        DragHandle,
        Separator,
        Branding,
        New("TextButton", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = "",
            ZIndex = 10,
            Name = "OpenTrigger",
        })
    })

    local DragModule = Creator.Drag(Container)

    Creator.AddSignal(Button.OpenTrigger.MouseButton1Click, function()
        Window:Open()
    end)

    function OpenButtonMain:Visible(v)
        Container.Visible = v
    end
    
    function OpenButtonMain:SetScale(scale)
        Container.UIScale.Scale = scale
    end

    function OpenButtonMain:SetIcon()
        -- Disabled for Noble Deluxe
    end
    
    function OpenButtonMain:Edit(Config)
        if Config.Scale then
            OpenButtonMain:SetScale(Config.Scale)
        end
    end

    OpenButtonMain.Button = Button
    return OpenButtonMain
end

return OpenButtonModule