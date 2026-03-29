-- User Application Code (Recovered from main.client.lua)
return function(IntiHub, Loading)
    Loading:Update("Inicializando Interfaz...")
    task.wait(0.5)

    -- */  Window  /* --
    local Window = IntiHub:CreateWindow({
        Title = "IntiHub | Noble Deluxe",
        Folder = "intihub",
        Icon = "solar:folder-2-bold-duotone",
        NewElements = true,
        HideSearchBar = false,
        OpenButton = {
            Title = "Open IntiHub UI",
            Enabled = true,
            Draggable = true,
            Scale = 0.5,
        },
        Topbar = {
            Height = 44,
            ButtonsType = "Mac",
        },
    })

    Loading:Update("Cargando Etiquetas...")
    task.wait(0.3)
    -- */  Tags  /* --
    Window:Tag({
        Title = "v2.1.0",
        Icon = "github",
        Color = Color3.fromHex("#FFD700"),
        Border = true,
    })

    -- */  Overview Tab  /* --
    Loading:Update("Cargando Overview...")
    local OverviewTab = Window:Tab({
        Title = "Overview",
        Icon = "home",
    })

    local ExampleGroup = OverviewTab:Section({
        Title = "Group's Example",
    })

    ExampleGroup:Button({
        Title = "Button 1",
        Callback = function() print("Button 1 Clicked") end,
    })

    ExampleGroup:Button({
        Title = "Button 2",
        Callback = function() print("Button 2 Clicked") end,
    })

    local ElementsGroup = OverviewTab:Section({
        Title = "Elements",
    })

    ElementsGroup:Button({
        Title = "Button 1",
        Callback = function() print("Button 1 Clicked") end,
    })

    ElementsGroup:Toggle({
        Title = "Toggle 2",
        Default = true,
        Callback = function(v) print("Toggle 2:", v) end,
    })

    ElementsGroup:Colorpicker({
        Title = "Colorpicker 3",
        Default = Color3.fromHex("#00FF7F"),
        Callback = function(v) print("Colorpicker 3:", v) end,
    })

    local Section1 = OverviewTab:Section({
        Title = "Section 1",
        Description = "Section exampleeee",
    })

    Section1:Button({
        Title = "Button 1",
    })

    Section1:Toggle({
        Title = "Toggle 2",
    })

    local Section2 = OverviewTab:Section({
        Title = "Section 2",
    })

    Section2:Button({
        Title = "Button 1",
    })

    Section2:Button({
        Title = "Button 2",
    })

    -- */  Testing Tabs  /* --
    Loading:Update("Preparando Componentes...")
    
    local ToggleTab = Window:Tab({ Title = "Toggle", Icon = "check-square" })
    ToggleTab:Section({ Title = "Toggles" }):Toggle({ Title = "Example Toggle" })

    local ButtonTab = Window:Tab({ Title = "Button", Icon = "mouse-pointer" })
    ButtonTab:Section({ Title = "Buttons" }):Button({ Title = "Example Button" })

    local InputTab = Window:Tab({ Title = "Input", Icon = "type" })
    InputTab:Section({ Title = "Inputs" }):Input({ Title = "Example Input", Placeholder = "Type here..." })

    local SliderTab = Window:Tab({ Title = "Slider", Icon = "sliders" })
    SliderTab:Section({ Title = "Sliders" }):Slider({ Title = "Example Slider", Step = 1, Min = 0, Max = 100, Default = 50 })

    local DropdownTab = Window:Tab({ Title = "Dropdown", Icon = "list" })
    DropdownTab:Section({ Title = "Dropdowns" }):Dropdown({ Title = "Example Dropdown", Multi = false, Options = {"Option 1", "Option 2", "Option 3"}, Default = 1 })

    Loading:Update("Finalizando...")
    task.wait(0.4)
    
    return Window
end
