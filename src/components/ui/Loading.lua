local Loading = {}
Loading.__index = Loading

local Creator = require("../../modules/Creator")
local New = Creator.New
local Tween = Creator.Tween

function Loading.new(Config)
    local self = setmetatable({}, Loading)
    
    local IntiHub = Config.IntiHub
    local Parent = Config.Parent or IntiHub.ScreenGui
    
    self.Main = New("CanvasGroup", {
        Name = "LoadingScreen",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Parent = Parent,
        ZIndex = 100000,
        GroupTransparency = 1,
    }, {
        New("Frame", {
            Name = "Background",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundColor3 = Color3.fromRGB(15, 15, 15),
            BackgroundTransparency = 0.2,
        }, {
             New("UIGradient", {
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 15, 15)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 25))
                }),
                Rotation = 45,
            })
        }),
        
        New("Frame", {
            Name = "Content",
            Size = UDim2.new(0, 350, 0, 200),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 0, 0.45, 0),
            BackgroundTransparency = 1,
        }, {
            New("UIListLayout", {
                FillDirection = "Vertical",
                HorizontalAlignment = "Center",
                VerticalAlignment = "Center",
                Padding = UDim.new(0, 20),
            }),
            
            -- Logo / Brand
            New("TextLabel", {
                Name = "Title",
                Text = "INTIHUB",
                Size = UDim2.new(1, 0, 0, 40),
                Font = Enum.Font.GothamBold,
                TextSize = 32,
                TextColor3 = Color3.fromRGB(255, 215, 0), -- Gold
                BackgroundTransparency = 1,
            }, {
                New("UIGradient", {
                    Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 215, 0)),
                        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 200)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 140, 0))
                    })
                })
            }),
            
            -- Animated Loader
            New("Frame", {
                Name = "LoaderTrack",
                Size = UDim2.new(0, 200, 0, 4),
                BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                BorderSizePixel = 0,
            }, {
                New("UICorner", { CornerRadius = UDim.new(1, 0) }),
                New("Frame", {
                    Name = "Progress",
                    Size = UDim2.new(0.3, 0, 1, 0),
                    BackgroundColor3 = Color3.fromRGB(255, 215, 0),
                    BorderSizePixel = 0,
                }, {
                    New("UICorner", { CornerRadius = UDim.new(1, 0) }),
                })
            }),
            
            -- Status Message
            New("TextLabel", {
                Name = "Status",
                Text = Config.InitialMessage or "Cargando componentes...",
                Size = UDim2.new(1, 0, 0, 20),
                Font = Enum.Font.GothamMedium,
                TextSize = 14,
                TextColor3 = Color3.fromRGB(200, 200, 200),
                BackgroundTransparency = 1,
                TextTransparency = 0.2,
            })
        })
    })

    -- Animate progress bar infinitely
    task.spawn(function()
        local progress = self.Main.Content.LoaderTrack.Progress
        while self.Main and self.Main.Parent do
            progress.Position = UDim2.new(-0.3, 0, 0, 0)
            Tween(progress, 1.5, { Position = UDim2.new(1, 0, 0, 0) }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut):Play()
            task.wait(1.5)
        end
    end)

    -- Show animation
    Tween(self.Main, 0.5, { GroupTransparency = 0 }):Play()
    
    return self
end

function Loading:Update(message)
    if self.Main then
        local statusLabel = self.Main.Content.Status
        Tween(statusLabel, 0.2, { TextTransparency = 1 }):Play()
        task.wait(0.2)
        statusLabel.Text = message
        Tween(statusLabel, 0.2, { TextTransparency = 0.2 }):Play()
    end
end

function Loading:Destroy()
    if self.Main then
        local t = Tween(self.Main, 0.5, { GroupTransparency = 1, Position = UDim2.new(0, 0, 0.05, 0) })
        t.Completed:Connect(function()
            self.Main:Destroy()
            self.Main = nil
        end)
        t:Play()
    end
end

return Loading
