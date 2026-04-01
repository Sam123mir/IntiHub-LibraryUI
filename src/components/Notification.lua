local Creator = require("../modules/Creator")
local New = Creator.New
local Tween = Creator.Tween

local NotificationModule = {
    Size = UDim2.new(0, 320, 1, -156),
    SizeLower = UDim2.new(0, 320, 1, -56),
    UICorner = 12,
    UIPadding = 16,
    Holder = nil,
    NotificationIndex = 0,
    Notifications = {}
}

function NotificationModule.Init(Parent)
    local NotModule = {
        Lower = false
    }
    
    function NotModule.SetLower(val)
        NotModule.Lower = val
        if NotModule.Frame then
            NotModule.Frame.Size = val and NotificationModule.SizeLower or NotificationModule.Size
        end
    end
    
    NotModule.Frame = New("Frame", {
        Name = "NotificationHolder",
        Position = UDim2.new(1, -20, 0, 56),
        AnchorPoint = Vector2.new(1, 0),
        Size = NotificationModule.Size,
        Parent = Parent,
        BackgroundTransparency = 1,
    }, {
        New("UIListLayout", {
            HorizontalAlignment = "Right",
            SortOrder = "LayoutOrder",
            VerticalAlignment = "Bottom",
            Padding = UDim.new(0, 10),
        }),
        New("UIPadding", {
            PaddingBottom = UDim.new(0, 20),
            PaddingRight = UDim.new(0, 0),
        })
    })
    return NotModule
end

function NotificationModule.New(Config)
    local Notification = {
        Title = Config.Title or "Notification",
        Content = Config.Content or nil,
        Icon = Config.Icon or "bell",
        IconThemed = Config.IconThemed,
        Background = Config.Background,
        BackgroundImageTransparency = Config.BackgroundImageTransparency,
        Duration = Config.Duration or 5,
        Buttons = Config.Buttons or {},
        CanClose = Config.CanClose ~= false,
        Closed = false,
    }
    
    NotificationModule.NotificationIndex = NotificationModule.NotificationIndex + 1
    NotificationModule.Notifications[NotificationModule.NotificationIndex] = Notification
    
    local Icon = Creator.Image(
        Notification.Icon,
        Notification.Title .. ":" .. (Notification.Icon or "bell"),
        0,
        Config.Window and Config.Window.Folder or "IntiHub",
        "Notification",
        Notification.IconThemed
    )
    Icon.Size = UDim2.new(0, 22, 0, 22)
    Icon.Position = UDim2.new(0, NotificationModule.UIPadding, 0, NotificationModule.UIPadding)
    local TargetIcon = Icon:FindFirstChildWhichIsA("ImageLabel", true)
    if TargetIcon then
        TargetIcon.ImageColor3 = Color3.fromHex("#FFD700") -- Executive Gold
    end

    local CloseButton
    if Notification.CanClose then
        CloseButton = New("ImageButton", {
            Image = Creator.Icon("x")[1],
            ImageRectSize = Creator.Icon("x")[2].ImageRectSize,
            ImageRectOffset = Creator.Icon("x")[2].ImageRectPosition,
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 14, 0, 14),
            Position = UDim2.new(1, -NotificationModule.UIPadding, 0, NotificationModule.UIPadding),
            AnchorPoint = Vector2.new(1, 0),
            ImageColor3 = Color3.fromHex("#FFD700"),
            ImageTransparency = 0.5,
        }, {
            New("TextButton", {
                Size = UDim2.new(1, 10, 1, 10),
                BackgroundTransparency = 1,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(0.5, 0, 0.5, 0),
                Text = "",
            })
        })
    end
    
    local DurationBar = New("Frame", {
        Name = "DurationBar",
        Size = UDim2.new(1, 0, 0, 2),
        Position = UDim2.new(0, 0, 1, 0),
        AnchorPoint = Vector2.new(0, 1),
        BackgroundColor3 = Color3.fromHex("#FFD700"),
        BorderSizePixel = 0,
        ZIndex = 5,
    })
    
    local TextContainer = New("Frame", {
        Size = UDim2.new(1, -22 - (NotificationModule.UIPadding * 2), 0, 0),
        Position = UDim2.new(0, 22 + (NotificationModule.UIPadding * 1.5), 0, 0),
        BackgroundTransparency = 1,
        AutomaticSize = "Y",
    }, {
        New("UIPadding", {
            PaddingTop = UDim.new(0, NotificationModule.UIPadding),
            PaddingBottom = UDim.new(0, NotificationModule.UIPadding),
            PaddingRight = UDim.new(0, NotificationModule.UIPadding),
        }),
        New("UIListLayout", {
            Padding = UDim.new(0, 4),
            SortOrder = "LayoutOrder",
        }),
        New("TextLabel", {
            Name = "Title",
            AutomaticSize = "Y",
            Size = UDim2.new(1, 0, 0, 0),
            TextWrapped = true,
            TextXAlignment = "Left",
            RichText = true,
            BackgroundTransparency = 1,
            TextSize = 14,
            TextColor3 = Color3.fromHex("#FFD700"),
            Text = "<b>" .. Notification.Title .. "</b>",
            FontFace = Font.new(Creator.Font, Enum.FontWeight.Bold),
            LayoutOrder = 1,
        }),
        Notification.Content and New("TextLabel", {
            Name = "Content",
            AutomaticSize = "Y",
            Size = UDim2.new(1, 0, 0, 0),
            TextWrapped = true,
            TextXAlignment = "Left",
            RichText = true,
            BackgroundTransparency = 1,
            TextSize = 13,
            TextColor3 = Color3.new(1, 1, 1),
            TextTransparency = 0.3,
            Text = Notification.Content,
            FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
            LayoutOrder = 2,
        }) or nil,
    })
    
    local Main = New("Frame", {
        Name = "NotificationFrame",
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(1.5, 0, 0, 0),
        BackgroundTransparency = 0,
        BackgroundColor3 = Color3.fromHex("#0F0F0F"),
        AutomaticSize = "Y",
        ClipsDescendants = true,
    }, {
        New("UICorner", { CornerRadius = UDim.new(0, NotificationModule.UICorner) }),
        New("UIStroke", {
            Thickness = 1.5,
            Color = Color3.fromHex("#FFD700"),
            Transparency = 0.6,
        }),
        DurationBar,
        TextContainer,
        Icon,
        CloseButton,
    })

    local MainContainer = New("Frame", {
        Name = "Container",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        Parent = Config.Holder,
        ClipsDescendants = true,
    }, {
        Main
    })
    
    function Notification:Close()
        if not Notification.Closed then
            Notification.Closed = true
            Tween(Main, 0.4, { Position = UDim2.new(1.5, 0, 0, 0) }, Enum.EasingStyle.Quint, Enum.EasingDirection.In):Play()
            task.wait(0.1)
            local T = Tween(MainContainer, 0.3, { Size = UDim2.new(1, 0, 0, 0) }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
            T.Completed:Connect(function() MainContainer:Destroy() end)
            T:Play()
        end
    end
    
    task.spawn(function()
        task.wait()
        Tween(MainContainer, 0.5, { Size = UDim2.new(1, 0, 0, Main.AbsoluteSize.Y + 10) }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
        Tween(Main, 0.5, { Position = UDim2.new(0, 0, 0, 0) }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
        
        if Notification.Duration then
            DurationBar.Size = UDim2.new(1, 0, 0, 2)
            Tween(DurationBar, Notification.Duration, { Size = UDim2.new(0, 0, 0, 2) }, Enum.EasingStyle.Linear):Play()
            task.wait(Notification.Duration)
            Notification:Close()
        end
    end)
    
    if CloseButton then
        Creator.AddSignal(CloseButton.TextButton.MouseButton1Click, function()
            Notification:Close()
        end)
    end
    
    return Notification
end

return NotificationModule
