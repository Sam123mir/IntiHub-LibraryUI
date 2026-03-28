local OpenButton = {}

local Creator = require("../../modules/Creator")
local New = Creator.New
local Tween = Creator.Tween


local cloneref = (cloneref or clonereference or function(instance) return instance end)


local UserInputService = cloneref(game:GetService("UserInputService"))


function OpenButton.New(Window)
    local OpenButtonMain = {
        Button = nil
    }
    
    local Icon
    
    
    
    -- Icon = New("ImageLabel", {
    --     Image = "",
    --     Size = UDim2.new(0,22,0,22),
    --     Position = UDim2.new(0.5,0,0.5,0),
    --     LayoutOrder = -1,
    --     AnchorPoint = Vector2.new(0.5,0.5),
    --     BackgroundTransparency = 1,
    --     Name = "Icon"
    -- })

    local Title = New("TextLabel", {
        Text = Window.Title:upper(),
        TextSize = 14,
        FontFace = Font.new(Creator.Font, Enum.FontWeight.Bold),
        BackgroundTransparency = 1,
        AutomaticSize = "XY",
        ThemeTag = {
            TextColor3 = "Accent",
        },
    })

    local Drag = New("Frame", {
        Size = UDim2.new(0,30,0,30),
        BackgroundTransparency = 1, 
        Name = "Drag",
    }, {
        New("ImageLabel", {
            Image = Creator.Icon("move")[1],
            ImageRectOffset = Creator.Icon("move")[2].ImageRectPosition,
            ImageRectSize = Creator.Icon("move")[2].ImageRectSize,
            Size = UDim2.new(0,14,0,14),
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5,0,0.5,0),
            AnchorPoint = Vector2.new(0.5,0.5),
            ThemeTag = {
                ImageColor3 = "Icon",
            },
            ImageTransparency = .5,
        })
    })

    local Divider = New("Frame", {
        Size = UDim2.new(0,1,0,18),
        BackgroundColor3 = Color3.fromHex("#FFD700"),
        BackgroundTransparency = .8,
        BorderSizePixel = 0,
    })

    local LiveTag = New("Frame", {
        Size = UDim2.new(0,45,0,20),
        BackgroundColor3 = Color3.new(1,1,1),
        BackgroundTransparency = .92,
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
        Size = UDim2.new(0,0,0,32),
        AutomaticSize = "X",
        Parent = Container,
        BackgroundColor3 = Color3.fromHex("#0A0A0A"),
        BackgroundTransparency = .1,
    }, {
        UIScale,
	    New("UICorner", { CornerRadius = UDim.new(0,6) }),
        New("UIStroke", {
            Thickness = 1,
            Color = Color3.fromHex("#FFD700"),
            Transparency = .7,
            Name = "Stroke"
        }),
        
        New("UIPadding", {
            PaddingLeft = UDim.new(0,10),
            PaddingRight = UDim.new(0,10),
        }),
        
        New("UIListLayout", {
            Padding = UDim.new(0, 10),
            FillDirection = "Horizontal",
            VerticalAlignment = "Center",
            SortOrder = "LayoutOrder",
        }),

        Drag,
        Divider,
        Title,
        LiveTag,

        New("TextButton", {
            Size = UDim2.new(1,0,1,0),
            BackgroundTransparency = 1,
            Text = "",
            ZIndex = 10,
        })
    })

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
    
    OpenButtonMain.Button = Button

    function OpenButtonMain:SetIcon(newIcon)
        if Icon then
            Icon:Destroy()
        end
        if newIcon then
            Icon = Creator.Image(
                newIcon,
                Window.Title,
                0,
                Window.Folder,
                "OpenButton",
                true,
                Window.IconThemed
            )
            Icon.Size = UDim2.new(0, 16, 0, 16)
            Icon.LayoutOrder = -1 -- Ensure it's before Divider
            Icon.Parent = Button
        end
    end
    
    if Window.Icon then
        OpenButtonMain:SetIcon(Window.Icon)
    end

    Creator.AddSignal(Button:GetPropertyChangedSignal("AbsoluteSize"), function()
        Container.Size = UDim2.new(
            0, Button.AbsoluteSize.X,
            0, Button.AbsoluteSize.Y
        )
    end)
    
    Creator.AddSignal(Button.TextButton.MouseEnter, function()
        Tween(Button, .2, {BackgroundTransparency = 0}):Play()
    end)
    Creator.AddSignal(Button.TextButton.MouseLeave, function()
        Tween(Button, .2, {BackgroundTransparency = .1}):Play()
    end)
    
    local DragModule = Creator.Drag(Container)
    
    function OpenButtonMain:Visible(v)
        Container.Visible = v
    end
    
    function OpenButtonMain:SetScale(scale)
        UIScale.Scale = scale
    end
    
    function OpenButtonMain:Edit(OpenButtonConfig)
        local OpenButtonModule = {
            Title = OpenButtonConfig.Title,
            Icon = OpenButtonConfig.Icon,
            Enabled = OpenButtonConfig.Enabled,
            Position = OpenButtonConfig.Position,
            OnlyIcon = OpenButtonConfig.OnlyIcon or false,
            Draggable = OpenButtonConfig.Draggable or nil,
            OnlyMobile = OpenButtonConfig.OnlyMobile,
            CornerRadius = OpenButtonConfig.CornerRadius or UDim.new(0, 6),
            StrokeThickness = OpenButtonConfig.StrokeThickness or 1,
            Scale = OpenButtonConfig.Scale or 1,
            Color = OpenButtonConfig.Color 
                or ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromHex("#FFD700")),
                    ColorSequenceKeypoint.new(1, Color3.fromHex("#FFD700")),
                }),
        }
        
        if OpenButtonModule.Enabled == false then
            Window.IsOpenButtonEnabled = false
        end
        
        if OpenButtonModule.Draggable == false and Drag and Divider then
            Drag.Visible = OpenButtonModule.Draggable
            if DragModule then
                DragModule:Set(OpenButtonModule.Draggable)
            end
        end
        
        if OpenButtonModule.Position and Container then
            Container.Position = OpenButtonModule.Position
        end
        
        if OpenButtonModule.OnlyIcon == true then
            Title.Visible = false
            Divider.Visible = false
            LiveTag.Visible = false
        else
            Title.Visible = true
            Divider.Visible = true
            LiveTag.Visible = true
        end
        
        if OpenButtonModule.Title then
            Title.Text = OpenButtonModule.Title:upper()
        end
        
        if OpenButtonModule.Icon then
            OpenButtonMain:SetIcon(OpenButtonModule.Icon)
        end

        local stroke = Button:FindFirstChild("Stroke")
        if stroke then
            stroke.Thickness = OpenButtonModule.StrokeThickness
            -- Handle Color if needed, but we use gold by default
        end

        Button.UICorner.CornerRadius = OpenButtonModule.CornerRadius
        OpenButtonMain:SetScale(OpenButtonModule.Scale)
    end


    return OpenButtonMain
end



return OpenButton