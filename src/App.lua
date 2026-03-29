-- User Application Code (Recovered from main.client.lua)
return function(IntiHub, Loading)
    Loading:Update("Inicializando Interfaz...")
    task.wait(0.5)

    -- */  Window  /* --
    local Window = IntiHub:CreateWindow({
        Title = "Noble Deluxe",
        Author = "by IntiHub Team",
        Folder = "intihub_noble",
        Icon = "rbxassetid://120997033468887",
        Resizable = true,
        MinSize = Vector2.new(650, 450),
        MaxSize = Vector2.new(1000, 700),
        Transparent = true,
        Acrylic = true,
        OpenButton = {
            Title = "INTIHUB",
            Enabled = true,
            Draggable = true,
        },
        Topbar = {
            Height = 52,
            ButtonsType = "Default",
        },
    })

    Loading:Update("Cargando Etiquetas...")
    task.wait(0.3)
    -- */  Tags / Version  /* --
    Window:Tag({
        Title = "v2.1.2",
        Icon = "github",
        Color = Color3.fromHex("#FFD700"),
        Border = true,
    })

    -- */  Overview Tab  /* --
    Loading:Update("Cargando Overview...")
    local OverviewTab = Window:Tab({ Title = "Overview", Icon = "home" })
    
    OverviewTab:Section({ Title = "Bienvenido" }):Paragraph({ 
        Title = "Noble Deluxe v2.1", 
        Content = "Esta es la interfaz definitiva de IntiHub. Diseñada para ofrecer la mejor experiencia visual y funcional en cualquier executor." 
    })

    OverviewTab:Section({ Title = "Información del Sistema" }):Paragraph({ 
        Title = "Estado: Operativo", 
        Content = "Todos los módulos cargados satisfactoriamente. El panel de estadísticas fue reintegrado al widget inferior." 
    })

    -- */  Toggle Tab  /* --
    Loading:Update("Preparando Módulos...")
    local ToggleTab = Window:Tab({ Title = "Toggle", Icon = "check-square" })
    local ToggleSec = ToggleTab:Section({ Title = "Módulos de Automatización" })

    ToggleSec:Toggle({ 
        Title = "Enable Auto-Farm", 
        Desc = "Comienza la recolección automática de recursos.",
        Default = true, 
        Callback = function(v) print("Auto-Farm:", v) end 
    })

    ToggleSec:Toggle({ 
        Title = "Anti-AFK System", 
        Desc = "Previene la desconexión por inactividad.",
        Default = false, 
        Callback = function(v) print("Anti-AFK:", v) end 
    })

    -- */  Button Tab  /* --
    local ButtonTab = Window:Tab({ Title = "Button", Icon = "mouse-pointer" })
    ButtonTab:Section({ Title = "Acciones Rápidas" }):Button({
        Title = "Re-ejecutar Scripts",
        Desc = "Refresca y vuelve a cargar los scripts locales.",
        Callback = function() IntiHub:Notify({ Title = "Sistema", Content = "Scripts recargados.", Duration = 2 }) end
    })

    -- */  Input Tab  /* --
    local InputTab = Window:Tab({ Title = "Input", Icon = "type" })
    InputTab:Section({ Title = "Configuración" }):Input({
        Title = "Discord Webhook",
        Placeholder = "Enter URL here...",
        Callback = function(v) print("Webhook set to:", v) end
    })

    -- */  Slider Tab  /* --
    local SliderTab = Window:Tab({ Title = "Slider", Icon = "sliders" })
    local PerfSec = SliderTab:Section({ Title = "Rendimiento" })
    
    PerfSec:Slider({ 
        Title = "Límite de FPS", 
        Min = 30, Max = 240, Default = 60, 
        Callback = function(v) print("FPS:", v) end 
    })

    PerfSec:Slider({ 
        Title = "WalkSpeed Modifier", 
        Min = 16, Max = 100, Default = 16, 
        Callback = function(v) print("Speed:", v) end 
    })

    -- */  Dropdown Tab  /* --
    local DropdownTab = Window:Tab({ Title = "Dropdown", Icon = "list" })
    local SelectorSec = DropdownTab:Section({ Title = "Selectores" })

    SelectorSec:Dropdown({ 
        Title = "Seleccionar Servidor", 
        Options = {"Automático", "North America", "Europe", "South America", "Asia"}, 
        Default = "Automático",
        Callback = function(v) print("Server:", v) end 
    })

    SelectorSec:Dropdown({ 
        Title = "Scripts Disponibles", 
        Multi = true,
        Options = {"Arsenal", "Doors", "BloxFruits", "Piggy", "Adopt Me", "Murder Mystery 2"}, 
        Default = {"Arsenal", "Doors"},
        Callback = function(v) print("Scripts selected:", table.concat(v, ", ")) end 
    })

    Loading:Update("Finalizando...")
    task.wait(0.4)
    
    Window:SelectTab(1)
    IntiHub:Notify({ Title = "Sistema", Content = "Noble Deluxe listo para usar.", Duration = 4 })
    
    return Window
end
