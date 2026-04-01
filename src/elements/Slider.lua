local cloneref = (cloneref or clonereference or function(instance) return instance end)

local UserInputService = cloneref(game:GetService("UserInputService"))
local RunService = cloneref(game:GetService("RunService"))

local Creator = require("../modules/Creator")
local New = Creator.New
local Tween = Creator.Tween

local Color3 = Color3
local UDim = UDim
local UDim2 = UDim2
local Vector2 = Vector2
local Font = Font
local Enum = Enum

local Color3 = Color3
local UDim = UDim
local UDim2 = UDim2
local Vector2 = Vector2
local Font = Font
local Enum = Enum

local Element = {}

function Element:New(Config)
    local Slider = {
        __type = "Slider",
        Title = Config.Title or "Slider",
        Desc = Config.Desc or nil,
        Locked = Config.Locked or nil,
        LockedTitle = Config.LockedTitle,
        Value = Config.Value or {Min = 0, Max = 100, Default = 50},
        Icons = Config.Icons or nil,
        IsTooltip = Config.IsTooltip or false,
        IsTextbox = Config.IsTextbox,
        Step = Config.Step or 1,
        Callback = Config.Callback or function() end,
        UIElements = {},
        IsFocusing = false,
        
        Width = Config.Width or 130,
        TextBoxWidth = 40,
        ThumbSize = 14,
        IconSize = 22,
        
        IsHolding = false,
    }

    if Slider.IsTextbox == nil then 
        Slider.IsTextbox = true 
    end
    
    local moveconnection
    local releaseconnection
    local Value = Slider.Value.Default or Slider.Value.Min or 0
    
    local LastValue = Value
    local delta = math.clamp((Value - (Slider.Value.Min or 0)) / ((Slider.Value.Max or 100) - (Slider.Value.Min or 0)), 0, 1)
    
    local IsFloat = Slider.Step % 1 ~= 0
    
    local function FormatValue(val)
        if IsFloat then
            return tonumber(string.format("%.2f", val))
        end
        return math.floor(val + 0.5)
    end
    
    local function CalculateValue(rawValue)
        return math.floor(rawValue / Slider.Step + 0.5) * Slider.Step
    end
    
    local IconFrom, IconTo
    if Slider.Icons then
        if Slider.Icons.From then
            IconFrom = Creator.Image(Slider.Icons.From, "SliderFrom", 0, Config.Window.Folder, "Slider", true)
            IconFrom.Size = UDim2.new(0, Slider.IconSize, 0, Slider.IconSize)
            IconFrom.ImageColor3 = Color3.fromHex("#FFD700")
        end
        if Slider.Icons.To then
            IconTo = Creator.Image(Slider.Icons.To, "SliderTo", 0, Config.Window.Folder, "Slider", true)
            IconTo.Size = UDim2.new(0, Slider.IconSize, 0, Slider.IconSize)
            IconTo.ImageColor3 = Color3.fromHex("#FFD700")
        end
    end

    local ValueLabel
    if Slider.IsTextbox then
        ValueLabel = New("TextBox", {
            Text = FormatValue(Value),
            TextSize = 12,
            FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
            TextColor3 = Color3.new(1, 1, 1),
            BackgroundTransparency = 0.9,
            BackgroundColor3 = Color3.new(1, 1, 1),
            Size = UDim2.new(0, Slider.TextBoxWidth, 0, 22),
            ThemeTag = { BorderColor3 = "Accent" },
        }, {
            New("UICorner", { CornerRadius = UDim.new(0, 4) }),
            New("UIStroke", { Thickness = 1, Color = Color3.fromHex("#FFD700"), Transparency = 0.8 }),
        })
    end

    Slider.SliderFrame = require("../components/window/Element")({
        Title = Slider.Title,
        Desc = Slider.Desc,
        Parent = Config.Parent,
        Hover = true,
        Tab = Config.Tab,
        Index = Config.Index,
        Window = Config.Window,
        ElementTable = Slider,
        ParentConfig = Config,
    })

    local SliderBarContainer = New("Frame", {
        Size = UDim2.new(0, Slider.Width, 0, 24),
        BackgroundTransparency = 1,
        LayoutOrder = 10,
        Parent = Slider.SliderFrame.UIElements.Main.UIElements.Container.TitleFrame.TitleFrame, -- Nested in Element's title frame for right-alignment
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, 0, 0.5, 0),
    }, {
        New("UIListLayout", {
            FillDirection = "Horizontal",
            VerticalAlignment = "Center",
            Padding = UDim.new(0, 8),
            HorizontalAlignment = "Right",
        }),
        IconFrom,
        Creator.NewRoundFrame(99, "Squircle", {
            Name = "SliderBack",
            Size = UDim2.new(1, (IconFrom and -30 or 0) + (IconTo and -30 or 0) + (Slider.IsTextbox and -Slider.TextBoxWidth - 10 or 0), 0, 4),
            ImageTransparency = 0.9,
            ThemeTag = { ImageColor3 = "Text" },
        }, {
            Creator.NewRoundFrame(99, "Squircle", {
                Name = "Fill",
                Size = UDim2.new(delta, 0, 1, 0),
                ThemeTag = { ImageColor3 = "Slider" },
            }, {
                Creator.NewRoundFrame(99, "Squircle", {
                    Name = "Thumb",
                    Size = UDim2.new(0, Slider.ThumbSize, 0, Slider.ThumbSize),
                    Position = UDim2.new(1, 0, 0.5, 0),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    ThemeTag = { ImageColor3 = "SliderThumb" },
                }, {
                    New("UIStroke", { Thickness = 1.5, Color = Color3.fromHex("#FFD700") }),
                })
            })
        }),
        IconTo,
        ValueLabel,
    })

    local SliderBack = SliderBarContainer.SliderBack
    
    local function UpdateSlider(input)
        local inputPosition = input.Position.X
        local rawDelta = math.clamp((inputPosition - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1)
        local newValue = CalculateValue(Slider.Value.Min + rawDelta * (Slider.Value.Max - Slider.Value.Min))
        newValue = math.clamp(newValue, Slider.Value.Min, Slider.Value.Max)
        
        if newValue ~= LastValue then
            LastValue = newValue
            Slider.Value.Default = newValue
            local visualDelta = (newValue - Slider.Value.Min) / (Slider.Value.Max - Slider.Value.Min)
            Tween(SliderBack.Fill, 0.1, {Size = UDim2.new(visualDelta, 0, 1, 0)}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
            if ValueLabel then ValueLabel.Text = tostring(FormatValue(newValue)) end
            Creator.SafeCallback(Slider.Callback, newValue)
        end
    end

    function Slider:Set(val)
        val = math.clamp(CalculateValue(val), Slider.Value.Min, Slider.Value.Max)
        local visualDelta = (val - Slider.Value.Min) / (Slider.Value.Max - Slider.Value.Min)
        LastValue = val
        Slider.Value.Default = val
        Tween(SliderBack.Fill, 0.2, {Size = UDim2.new(visualDelta, 0, 1, 0)}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
        if ValueLabel then ValueLabel.Text = tostring(FormatValue(val)) end
        Creator.SafeCallback(Slider.Callback, val)
    end

    Creator.AddSignal(SliderBack.InputBegan, function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not Slider.Locked then
            Slider.IsHolding = true
            UpdateSlider(input)
            
            moveconnection = UserInputService.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                    UpdateSlider(input)
                end
            end)
            
            releaseconnection = UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    Slider.IsHolding = false
                    if moveconnection then moveconnection:Disconnect() end
                    if releaseconnection then releaseconnection:Disconnect() end
                end
            end)
        end
    end)

    if ValueLabel then
        Creator.AddSignal(ValueLabel.FocusLost, function()
            local val = tonumber(ValueLabel.Text)
            if val then
                Slider:Set(val)
            else
                ValueLabel.Text = tostring(FormatValue(LastValue))
            end
        end)
    end

    return Slider.__type, Slider
end

return Element