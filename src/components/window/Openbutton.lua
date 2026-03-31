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
            Padding = UDim.new(0, 6),
        }),
        New("ImageLabel", {
            Name = "Logo",
            Size = UDim2.new(0, 20, 0, 20),
            BackgroundTransparency = 1,
            Image = Creator.GetAsset("https://raw.githubusercontent.com/Sam123mir/IntiHub-LibraryUI/main/docs/logo.png", "IntiHub", "Image", "Logo"),
        }),
        New("Frame", {
            Name = "TextGroup",
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
                TextColor3 = Color3.fromHex("#FFFFFF"),
            }),
            New("TextLabel", {
                Text = " - v2.1.2",
                TextSize = 12,
                FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
                BackgroundTransparency = 1,
                AutomaticSize = "XY",
                TextColor3 = Color3.fromHex("#FFFFFF"),
                TextTransparency = 0.4,
            }),
        }),
        New("TextButton", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = "",
            ZIndex = 10,
            Name = "OpenTrigger",
        })
    })

    local DragHandle = New("ImageLabel", {
        Size = UDim2.new(0, 18, 0, 18),
        BackgroundTransparency = 1,
        Image = "rbxassetid://138450125867375", -- Move/Drag arrows icon
        ImageColor3 = Color3.fromHex("#FFD700"),
        Active = true,
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
        Size = UDim2.new(0, 120, 0, 32),
        Parent = Container,
        BackgroundColor3 = Color3.fromHex("#0A0A0A"),
        BackgroundTransparency = 0.1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
    }, {
        New("UICorner", { CornerRadius = UDim.new(0, 8) }),
        New("UIStroke", {
            Thickness = 2,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            Color = Color3.fromHex("#FFD700"),
        }, {
            New("UIGradient", {
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromHex("#FFD700")),
                    ColorSequenceKeypoint.new(0.5, Color3.fromHex("#4D4300")),
                    ColorSequenceKeypoint.new(1, Color3.fromHex("#FFD700")),
                }),
                Rotation = 0,
                Name = "GlowTrail"
            })
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
    })

    -- Animate Glow Trail
    task.spawn(function()
        local Gradient = Button:FindFirstChild("UIStroke") and Button.UIStroke:FindFirstChild("GlowTrail")
        if Gradient then
            while true do
                for i = 0, 360, 2 do
                    Gradient.Rotation = i
                    task.wait(0.02)
                    if not Button.Parent then break end
                end
                if not Button.Parent then break end
            end
        end
    end)

    local DragModule = Creator.Drag(Container, {DragHandle})

    Creator.AddSignal(Branding.OpenTrigger.MouseButton1Click, function()
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