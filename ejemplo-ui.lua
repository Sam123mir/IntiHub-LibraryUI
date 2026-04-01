local IntiHub

-- */ IntiHub Loader /* --
do
    local success, result = pcall(function()
        -- Note: Pointing to main branch for the demo
        local code = game:HttpGet("https://raw.githubusercontent.com/Sam123mir/IntiHub-LibraryUI/main/dist/main.lua?v=" .. tick())
        local func, err = loadstring(code)
        if not func then error("Failed to compile IntiHub: " .. tostring(err)) end
        return func()
    end)

    if not success or not result then
        warn("[IntiHub Demo Error]: Library loading failed. Trying local recovery...")
        -- Fallback to local src/Init for development testing if HttpGet fails in studio
        local ok, local_res = pcall(function() return require(game:GetService("ReplicatedStorage"):WaitForChild("IntiHub"):WaitForChild("Init")) end)
        if ok then result = local_res else return end
    end
    IntiHub = result
end

-- */ Window Configuration /* --
local Window = IntiHub:CreateWindow({
    Title = "INTIHUB | Noble Deluxe Edition",
    Author = "by Sammir_Inti",
    Version = "2.2.0",
    Folder = "IntiHub_Noble",
    Icon = "lucide:crown",
    HideSearchBar = false, -- 🟢 Explicitly show the search bar
    NewElements = true,
    Resizable = true,
    Acrylic = true,
})

-- */ Dashboard Tab /* --
do
    local DashTab = Window:Tab({
        Title = "Dashboard",
        Icon = "layout-grid",
    })

    local OverviewSection = DashTab:Section({
        Title = "System Overview",
        Desc = "Monitor and control core modules",
        Box = true,
        Opened = true,
    })

    OverviewSection:Button({
        Title = "Initialize All Modules",
        Icon = "zap",
        Callback = function()
            IntiHub:Notify({
                Title = "System Core",
                Content = "All modules have been synchronized.",
                Icon = "check-circle",
                Duration = 5
            })
        end
    })

    OverviewSection:Toggle({
        Title = "Auto-Farm System",
        Desc = "Efficient resource collection",
        Callback = function(v) print("Auto-Farm:", v) end
    })

    local SettingSection = DashTab:Section({
        Title = "Interface Settings",
        Box = true,
        Opened = true,
    })

    SettingSection:Slider({
        Title = "UI Transparency",
        Value = { Min = 0, Max = 100, Default = 50 },
        IsTooltip = true,
        Callback = function(v) Window:ToggleTransparency(v/100) end
    })

    SettingSection:Dropdown({
        Title = "Accent Palette",
        Options = {"Noble Gold", "Royal Azure", "Emerald Executive"},
        Default = "Noble Gold",
    })
end

-- */ Visual Components Tab /* --
do
    local CompTab = Window:Tab({
        Title = "Noble Components",
        Icon = "component",
    })

    local InputSection = CompTab:Section({ Title = "User Interaction", Box = true, Opened = true })

    InputSection:Input({
        Title = "Security Key",
        Desc = "Enter your authorization code",
        Callback = function(v) print("Key entered:", v) end
    })

    InputSection:Keybind({
        Title = "Toggle UI Key",
        Default = Enum.KeyCode.Insert,
        Callback = function() print("UI Toggle Triggered") end
    })

    local SliderSection = CompTab:Section({ Title = "Slider Range", Opened = true })
    
    SliderSection:Slider({
        Title = "Sensitivity",
        Min = 1, Max = 10, Default = 5,
        Callback = function(v) print("Sensitivity:", v) end
    })
end

-- */ Notification & Utilities /* --
do
    local UtilTab = Window:Tab({
        Title = "Tools",
        Icon = "lucide:settings",
    })

    UtilTab:Button({
        Title = "Test Premium Notification",
        Color = Color3.fromHex("#FFD700"),
        Callback = function()
            IntiHub:Notify({
                Title = "Noble Deluxe",
                Content = "Premium notification system is active.",
                Icon = "lucide:star",
                Duration = 10
            })
        end
    })

    UtilTab:Button({
        Title = "Force Minimize",
        Icon = "lucide:minimize-2",
        Callback = function() Window:Close() end
    })

    UtilTab:Divider()

    UtilTab:Button({
        Title = "Destruction Protocol",
        Color = Color3.fromHex("#FF4B30"),
        Callback = function() Window:Destroy() end
    })
end

-- */ Final Message /* --
IntiHub:Notify({
    Title = "IntiHub Noble",
    Content = "Initialization complete. Welcome, Executive.",
    Icon = "lucide:shield-check",
    Duration = 8
})
