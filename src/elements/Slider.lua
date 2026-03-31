local cloneref = (cloneref or clonereference or function(instance) return instance end)


local UserInputService = cloneref(game:GetService("UserInputService"))
local RunService = cloneref(game:GetService("RunService"))

local Creator = require("../modules/Creator")
local New = Creator.New
local Tween = Creator.Tween


local Element = {}

-- local IsSliderHolding = false -- 🟢 Removed global state (was shared across all sliders)

function Element:New(Config)
    local Slider = {
        __type = "Slider",
        Title = Config.Title or nil,
        Desc = Config.Desc or nil,
        Locked = Config.Locked or nil,
        LockedTitle = Config.LockedTitle,
        Value = Config.Value or {},
        Icons = Config.Icons or nil,
        IsTooltip = Config.IsTooltip or false,
        IsTextbox = Config.IsTextbox,
        Step = Config.Step or 1,
        Callback = Config.Callback or function() end,
        UIElements = {},
        IsFocusing = false,
        
        Width = Config.Width or 130,
        TextBoxWidth = Config.Window.NewElements and 40 or 30,
        ThumbSize = 13,
        IconSize = 26,
        
        IsHolding = false, -- 🟢 Per-instance dragging state
    }
    if Slider.Icons == {} then
        Slider.Icons = {
            From = "sfsymbols:sunMinFill",
            To = "sfsymbols:sunMaxFill",
        }
    end
    if Slider.IsTextbox == nil and Slider.Title == nil then Slider.IsTextbox = false else Slider.IsTextbox = Slider.IsTextbox ~= false end
    
    local isTouch
    local moveconnection
    local releaseconnection
    local Value = Slider.Value.Default or Slider.Value.Min or 0
    
    local LastValue = Value
    local delta = (Value - (Slider.Value.Min or 0)) / ((Slider.Value.Max or 100) - (Slider.Value.Min or 0))
    
    local CanCallback = true
    local IsFloat = Slider.Step % 1 ~= 0
    
    local function FormatValue(val)
        if IsFloat then
            return tonumber(string.format("%.2f", val))
        end
        return math.floor(val + 0.5)
    end
    
    local function CalculateValue(rawValue)
        if IsFloat then
            return math.floor(rawValue / Slider.Step + 0.5) * Slider.Step
        else
            return math.floor(rawValue / Slider.Step + 0.5) * Slider.Step
        end
    end
    
    local IconFrom, IconTo
    local TotalSliderWidth = 32
    if Slider.Icons then
        if Slider.Icons.From then
            IconFrom = Creator.Image(
                Slider.Icons.From, 
                Slider.Icons.From, 
                0, 
                Config.Window.Folder,
                "SliderIconFrom",
                true,
                true,
                "SliderIconFrom"
            )
            IconFrom.Size = UDim2.new(0,Slider.IconSize,0,Slider.IconSize)
            TotalSliderWidth = TotalSliderWidth + Slider.IconSize - 2
        end
        if Slider.Icons.To then
            IconTo = Creator.Image(
                Slider.Icons.To, 
                Slider.Icons.To, 
                0, 
                Config.Window.Folder,
                "SliderIconTo",
                true,
                true,
                "SliderIconTo"
            )
            IconTo.Size = UDim2.new(0,Slider.IconSize,0,Slider.IconSize)
            TotalSliderWidth = TotalSliderWidth + Slider.IconSize - 2
        end
    end
    local TitleLabel, ValueLabel
    if Slider.Title then
        TitleLabel = New("TextLabel", {
            Text = Slider.Title,
            TextSize = 13,
            FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
            TextXAlignment = "Left",
            BackgroundTransparency = 1,
            AutomaticSize = "Y",
            Size = UDim2.new(1, 0, 0, 0),
            ThemeTag = {
                TextColor3 = "Text",
            },
        })
        ValueLabel = New("TextLabel", {
            Text = FormatValue(Value),
            TextSize = 13,
            FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
            TextXAlignment = "Right",
            BackgroundTransparency = 1,
            AutomaticSize = "Y",
            Size = UDim2.new(1, 0, 0, 0),
            ThemeTag = {
                TextColor3 = "Text",
            },
            TextTransparency = 0.4,
        })
    end

    Slider.SliderFrame = require("../components/window/Element")({
        Title = nil, -- Handle title internally for the new design
        Desc = Slider.Desc,
        Parent = Config.Parent,
        Hover = false,
        Tab = Config.Tab,
        Index = Config.Index,
        Window = Config.Window,
        ElementTable = Slider,
        ParentConfig = Config,
    })

    Slider.UIElements.MainContainer = New("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = "Y",
        BackgroundTransparency = 1,
        Parent = Slider.SliderFrame.UIElements.Main,
    }, {
        New("UIListLayout", {
            Padding = UDim.new(0, 8),
            SortOrder = "LayoutOrder",
        }),
        New("UIPadding", {
            PaddingLeft = UDim.new(0, 14),
            PaddingRight = UDim.new(0, 14),
            PaddingTop = UDim.new(0, 12),
            PaddingBottom = UDim.new(0, 12),
        }),
        TitleLabel and New("Frame", {
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = "Y",
            BackgroundTransparency = 1,
            LayoutOrder = 1,
        }, {
            TitleLabel,
            ValueLabel,
        }) or nil,
        New("Frame", {
            Size = UDim2.new(1, 0, 0, 24),
            BackgroundTransparency = 1,
            LayoutOrder = 2,
            Name = "SliderBarContainer"
        }, {
            New("UIListLayout", {
                FillDirection = "Horizontal",
                VerticalAlignment = "Center",
                Padding = UDim.new(0, 10),
            }),
            IconFrom,
            Creator.NewRoundFrame(99, "Squircle", {
                Name = "SliderBack",
                Size = UDim2.new(1, (IconFrom and -34 or 0) + (IconTo and -34 or 0), 0, 4),
                ImageTransparency = .95,
                ThemeTag = { ImageColor3 = "Text" },
            }, {
                Creator.NewRoundFrame(99, "Squircle", {
                    Name = "Fill",
                    Size = UDim2.new(delta, 0, 1, 0),
                    ThemeTag = { ImageColor3 = "Slider" },
                }, {
                    Creator.NewRoundFrame(99, "Squircle", {
                        Name = "Thumb",
                        Size = UDim2.new(0, 16, 0, 16),
                        Position = UDim2.new(1, 0, 0.5, 0),
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        ThemeTag = { ImageColor3 = "SliderThumb" },
                    }, {
                        Creator.NewRoundFrame(99, "Glass-1", {
                            Size = UDim2.new(1, 0, 1, 0),
                            ImageTransparency = 0.6,
                            Name = "Highlight",
                        })
                    })
                })
            }),
            IconTo,
        })
    })

    local Tooltip
    if Slider.IsTooltip then
        Tooltip = require("../components/ui/Tooltip").New(Value, Slider.UIElements.MainContainer.SliderBarContainer.SliderBack.Fill.Thumb, true, "Secondary", "Small", false)
        Tooltip.Container.AnchorPoint = Vector2.new(0.5, 1)
        Tooltip.Container.Position = UDim2.new(0.5, 0, 0, -8)
    end

    local SliderBack = Slider.UIElements.MainContainer.SliderBarContainer.SliderBack
    
    local function UpdateSlider(input)
        local inputPosition = input.Position.X
        local delta = math.clamp((inputPosition - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1)
        local newValue = CalculateValue(Slider.Value.Min + delta * (Slider.Value.Max - Slider.Value.Min))
        newValue = math.clamp(newValue, Slider.Value.Min, Slider.Value.Max)
        
        if newValue ~= LastValue then
            LastValue = newValue
            Slider.Value.Default = newValue
            Tween(SliderBack.Fill, 0.1, {Size = UDim2.new(delta, 0, 1, 0)}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
            if ValueLabel then ValueLabel.Text = FormatValue(newValue) end
            if Tooltip then Tooltip.TitleFrame.Text = FormatValue(newValue) end
            Creator.SafeCallback(Slider.Callback, newValue)
        end
    end

    function Slider:Lock()
        Slider.Locked = true
        CanCallback = false
        return Slider.SliderFrame:Lock(Slider.LockedTitle)
    end

    function Slider:Unlock()
        Slider.Locked = false
        CanCallback = true
        return Slider.SliderFrame:Unlock()
    end

    if Slider.Locked then
        Slider:Lock()
    end

    Creator.AddSignal(SliderBack.InputBegan, function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not Slider.Locked then
            Slider.IsHolding = true
            Config.Tab.UIElements.ContainerFrame.ScrollingEnabled = false
            UpdateSlider(input)
            
            if Tooltip then Tooltip:Open() end
            
            moveconnection = UserInputService.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                    UpdateSlider(input)
                end
            end)
            
            releaseconnection = UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    Slider.IsHolding = false
                    Config.Tab.UIElements.ContainerFrame.ScrollingEnabled = true
                    if moveconnection then moveconnection:Disconnect() end
                    if releaseconnection then releaseconnection:Disconnect() end
                    if Tooltip then Tooltip:Close() end
                end
            end)
        end
    end)

    function Slider:Set(val)
        val = math.clamp(CalculateValue(val), Slider.Value.Min, Slider.Value.Max)
        local delta = (val - Slider.Value.Min) / (Slider.Value.Max - Slider.Value.Min)
        LastValue = val
        Slider.Value.Default = val
        Tween(SliderBack.Fill, 0.2, {Size = UDim2.new(delta, 0, 1, 0)}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
        if ValueLabel then ValueLabel.Text = FormatValue(val) end
        Creator.SafeCallback(Slider.Callback, val)
    end

    function Slider:SetMax(newMax)
        Slider.Value.Max = newMax
        Slider:Set(LastValue)
    end

    function Slider:SetMin(newMin)
        Slider.Value.Min = newMin
        Slider:Set(LastValue)
    end

    return Slider.__type, Slider
end


return Element