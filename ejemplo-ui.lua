local IntiHub

-- */ IntiHub Loader /* --
do
    local success, result = pcall(function()
        local code = game:HttpGet("https://raw.githubusercontent.com/Sam123mir/IntiHub-LibraryUI/main/dist/main.lua?v=" .. tick())
        local func, err = loadstring(code)
        if not func then error("Failed to compile IntiHub: " .. tostring(err)) end
        return func()
    end)

    if not success then
        warn("[IntiHub Example Error]: " .. tostring(result))
        return
    end
    IntiHub = result
end

-- */ Window Configuration /* --
local Window = IntiHub:CreateWindow({
    Title = "INTIHUB - Noble Deluxe",
    SubTitle = "v2.1.2",
    Folder = "IntiHub_Demo",
    Icon = "lucide:layout-dashboard",
    HideSearchBar = false,
    NewElements = true,
    OpenButton = {
        Enabled = true,
        Draggable = true,
    },
})

-- */ Dashboard Tab (Grid Layout Showcase) /* --
do
    local DashTab = Window:Tab({
        Title = "Dashboard",
        Icon = "lucide:home",
    })

    local MainGroup = DashTab:Group({ Title = "LAYOUT SECTIONS SIDE-BY-SIDE" })

    local Section1 = MainGroup:Section({
        Title = "Modules Status",
        Desc = "Real-time system overview",
        Box = true,
        Opened = true,
    })
    Section1:Toggle({ Title = "Combat System", Default = true })
    Section1:Toggle({ Title = "Movement Suite", Default = false })
    Section1:Button({ Title = "Emergency STOP", Color = Color3.fromHex("#FF4B30") })

    local Section2 = MainGroup:Section({
        Title = "Quick Settings",
        Desc = "Personalize your experience",
        Box = true,
        Opened = true,
    })
    Section2:Slider({
        Title = "WalkSpeed",
        Min = 16,
        Max = 200,
        Default = 50,
        IsTooltip = true,
    })
    Section2:Dropdown({
        Title = "Visual Theme",
        Values = {"Noble Gold", "Phantom Dark", "Crimson Red"},
        Default = "Noble Gold",
    })

    DashTab:Divider()

    DashTab:Paragraph({
        Title = "Noble Deluxe v2.1",
        Content = "This UI demonstrates the power of the Noble Deluxe framework, featuring side-by-side sections and draggable components."
    })
end

-- */ Components Tab /* --
do
    local CompTab = Window:Tab({
        Title = "All Components",
        Icon = "lucide:component",
    })

    local InteractionSection = CompTab:Section({ Title = "Interactive Elements" })
    
    InteractionSection:Button({
        Title = "Standard Button",
        Callback = function()
            IntiHub:Notify({ Title = "Action", Content = "Button clicked!" })
        end
    })

    InteractionSection:Toggle({
        Title = "Switch Toggle",
        Desc = "A modern toggle switch",
        Callback = function(v) print("Toggle:", v) end
    })

    InteractionSection:Input({
        Title = "Text Input",
        Desc = "Type something here...",
        Callback = function(v) print("Input:", v) end
    })

    local SelectionSection = CompTab:Section({ Title = "Selection & Sliders" })

    SelectionSection:Slider({
        Title = "Precision Slider",
        Icons = { From = "lucide:minus", To = "lucide:plus" },
        Value = { Min = 0, Max = 100, Default = 75 },
        IsTooltip = true,
    })

    SelectionSection:Dropdown({
        Title = "Multi-Option Menu",
        Values = {"Option A", "Option B", "Option C", "Option D"},
        Default = "Option A",
        Callback = function(v) print("Selected:", v) end
    })

    SelectionSection:Colorpicker({
        Title = "Accent Color",
        Default = Color3.fromHex("#FFD700"),
        Callback = function(color) print("Color Chosen:", color) end
    })

    SelectionSection:Keybind({
        Title = "Menu Keybind",
        Default = Enum.KeyCode.RightControl,
        Callback = function() print("Keybind Pressed!") end
    })
end

-- */ Utility Tab /* --
do
    local UtilTab = Window:Tab({
        Title = "Utilities",
        Icon = "lucide:wrench",
    })

    UtilTab:Label({ Text = "Notification Testing" })
    UtilTab:Button({
        Title = "Send Success Notification",
        Callback = function()
            IntiHub:Notify({
                Title = "Success",
                Content = "Operation completed successfully.",
                Duration = 5,
            })
        end
    })

    UtilTab:Divider()
    
    UtilTab:Code({
        Title = "Loadstring Generator",
        Code = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/Sam123mir/IntiHub-LibraryUI/main/main.lua"))()',
    })

    UtilTab:Button({
        Title = "Destroy UI",
        Color = Color3.fromHex("#EF4F1D"),
        Callback = function() Window:Destroy() end
    })
end

IntiHub:Notify({
    Title = "IntiHub Loaded",
    Content = "The UI demonstration is ready. Enjoy the Noble Deluxe experience!",
    Duration = 8
})
