--[[
    IntiUI - Script de Prueba Completo
    Este script carga la versión de producción desde GitHub y ejecuta TODOS los componentes
    y características de la UI para verificar su correcto funcionamiento.
]]

local IntiHub

-- Cargar la librería desde GitHub
local success, result = pcall(function()
    local code = game:HttpGet("https://raw.githubusercontent.com/Sam123mir/IntiHub-LibraryUI/main/dist/main.lua?v=" .. tick())
    local func, err = loadstring(code)
    if not func then error("Error al compilar la librería: " .. tostring(err)) end
    return func()
end)

if not success or not result then
    warn("[IntiUI Test Error]: No se pudo cargar la librería. Detalle: " .. tostring(result))
    return
end

IntiHub = result

-- Crear la Ventana Principal con el nuevo tema Oceanic por defecto
local Window = IntiHub:CreateWindow({
    Title = "IntiHub | Dashboard de Pruebas",
    Author = "by Sammir_Inti",
    Version = "2.3.0",
    Folder = "IntiUI_Test",
    Icon = "lucide:layout",
    Theme = "Oceanic", -- Iniciamos con el nuevo tema Oceanic
    NewElements = true,
    Resizable = true,
    Acrylic = true,
    HideSearchBar = false,
    OpenButton = {
        Title = "Abrir IntiHub",
        CornerRadius = UDim.new(1, 0),
        StrokeThickness = 2,
        Enabled = true,
        Draggable = true,
        OnlyMobile = false,
        Scale = 0.5,
        Color = ColorSequence.new(
            Color3.fromHex("#00F2FE"),
            Color3.fromHex("#4FACFE")
        ),
    }
})

-- Tag de versión en la topbar
Window:Tag({
    Title = "Producción",
    Icon = "shield-check",
    Color = Color3.fromHex("#00F2FE"),
    Border = true,
})

-- ========================================================
-- TAB 1: DASHBOARD & CONFIGURACIÓN
-- ========================================================
do
    local DashTab = Window:Tab({
        Title = "Dashboard",
        Icon = "layout-grid",
    })

    local InfoSection = DashTab:Section({
        Title = "Estado del Sistema",
        Desc = "Prueba de texto, notificaciones y cambio de temas en vivo.",
        Box = true,
        Opened = true,
    })

    InfoSection:Paragraph({
        Title = "Servidor Activo",
        Content = "El sistema se ha conectado exitosamente al canal de producción. Usa los controles inferiores para probar los temas."
    })

    -- Notificaciones
    InfoSection:Button({
        Title = "Probar Notificación Premium",
        Desc = "Lanza una notificación flotante con el tema actual.",
        Icon = "bell",
        Callback = function()
            IntiHub:Notify({
                Title = "IntiUI Premium",
                Content = "La notificación se ha desplegado correctamente.",
                Icon = "check-circle",
                Duration = 5
            })
        end
    })

    -- Cambiar tema en tiempo real
    InfoSection:Dropdown({
        Title = "Selector de Temas",
        Desc = "Cambia el diseño estético de toda la interfaz al instante.",
        Options = {"Oceanic", "Dark", "Light", "Amber", "Midnight", "CottonCandy", "Mellowsi", "Rainbow"},
        Default = "Oceanic",
        Callback = function(theme)
            IntiHub:SetTheme(theme)
            IntiHub:Notify({
                Title = "Tema Cambiado",
                Content = "Ahora estás usando el tema: " .. theme,
                Icon = "palette",
                Duration = 3
            })
        end
    })
end

-- ========================================================
-- TAB 2: CONTROLES E INTERRUPTORES
-- ========================================================
do
    local ControlTab = Window:Tab({
        Title = "Controles",
        Icon = "sliders",
    })

    local MainControls = ControlTab:Section({
        Title = "Interruptores y Deslizadores",
        Box = true,
        Opened = true,
    })

    -- Toggles (Estilo standard y Checkbox)
    MainControls:Toggle({
        Title = "Auto-Farm System",
        Desc = "Prueba de Toggle estándar con animación.",
        Value = false,
        Callback = function(state)
            print("Auto-Farm Toggle:", state)
        end
    })

    MainControls:Toggle({
        Title = "Silenciar Alertas",
        Desc = "Prueba de Toggle estilo Checkbox.",
        Type = "Checkbox",
        Value = true,
        Callback = function(state)
            print("Checkbox Toggle:", state)
        end
    })

    -- Sliders (Prueba de paso, tooltip y textbox con rango corregido)
    MainControls:Slider({
        Title = "Velocidad de Caminado (WalkSpeed)",
        Desc = "Ajusta con precisión los valores mediante la barra o el cuadro numérico.",
        Min = 16,
        Max = 120,
        Default = 16,
        IsTooltip = true,
        Callback = function(value)
            print("WalkSpeed modificado:", value)
        end
    })

    -- Slider bloqueado para verificar el estado de restricción
    MainControls:Slider({
        Title = "Ajuste Restringido (Bloqueado)",
        Min = 0,
        Max = 100,
        Default = 50,
        Locked = true,
        LockedTitle = "Este control está deshabilitado.",
        Callback = function() end
    })
end

-- ========================================================
-- TAB 3: ENTRADAS Y MENÚS DESPLEGABLES (DENTRO DE LA CARPETA EXTRAS)
-- ========================================================
do
    local ExtrasFolder = Window:CreateFolder({
        Title = "Extras",
        Icon = "folder",
        Opened = true,
    })

    local InputTab = ExtrasFolder:Tab({
        Title = "Interacción",
        Icon = "text-cursor-input",
    })

    local InputsSection = InputTab:Section({
        Title = "Formularios e Inputs",
        Box = true,
        Opened = true,
    })

    -- Inputs estándar y Área de texto
    InputsSection:Input({
        Title = "Código de Activación",
        Placeholder = "Ingresa tu clave de 16 dígitos...",
        Callback = function(text)
            print("Texto ingresado:", text)
        end
    })

    InputsSection:Input({
        Title = "Mensaje Ejecutivo (Textarea)",
        Type = "Textarea",
        Placeholder = "Escribe un mensaje largo aquí...",
        Callback = function(text)
            print("Textarea ingresado:", text)
        end
    })

    -- Dropdowns avanzados y multi-selección
    InputsSection:Dropdown({
        Title = "Selección Múltiple",
        Values = {"Opción A", "Opción B", "Opción C", "Opción D"},
        Multi = true,
        Value = {"Opción A"},
        Callback = function(selectedList)
            local items = {}
            for _, v in ipairs(selectedList) do
                table.insert(items, v)
            end
            print("Multi-Dropdown seleccionado:", table.concat(items, ", "))
        end
    })

    InputsSection:Dropdown({
        Title = "Dropdown Avanzado (Con Iconos)",
        Values = {
            { Title = "Crear Archivo", Desc = "Genera un nuevo archivo", Icon = "file-plus" },
            { Title = "Copiar Enlace", Desc = "Guarda el link de descarga", Icon = "copy" },
            { Title = "Eliminar Datos", Desc = "Borra permanentemente", Icon = "trash" }
        },
        Value = "Crear Archivo",
        Callback = function(option)
            print("Dropdown Avanzado seleccionado:", option.Title)
        end
    })

    -- Asignación de teclas
    InputsSection:Keybind({
        Title = "Tecla de Cierre (Toggle UI)",
        Default = Enum.KeyCode.RightControl,
        Callback = function()
            print("¡Tecla de Toggle UI presionada!")
        end
    })

-- ========================================================
-- TAB 4: MANTENIMIENTO (DENTRO DE LA CARPETA EXTRAS)
-- ========================================================
    local UtilTab = ExtrasFolder:Tab({
        Title = "Mantenimiento",
        Icon = "settings",
    })

    local ActionsSection = UtilTab:Section({
        Title = "Controles del Ciclo de Vida",
        Box = true,
        Opened = true,
    })

    ActionsSection:Button({
        Title = "Minimizar Interfaz",
        Icon = "minus",
        Callback = function()
            Window:Close()
        end
    })

    ActionsSection:Button({
        Title = "Destruir UI por Completo",
        Color = Color3.fromHex("#FF4B30"),
        Icon = "trash",
        Callback = function()
            Window:Destroy()
        end
    })
end

-- Mensaje de bienvenida al completarse la carga
IntiHub:Notify({
    Title = "Carga Exitosa",
    Content = "El entorno de pruebas premium está listo para ejecutarse.",
    Icon = "shield-check",
    Duration = 6
})
