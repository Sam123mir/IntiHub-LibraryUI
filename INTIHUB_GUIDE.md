# Guía de Implementación de IntiHub Premium

¡Bienvenido a **IntiHub**, la librería de UI más avanzada y estética para Roblox! Esta guía te enseñará cómo implementar todos los componentes disponibles para crear scripts profesionales con un estilo **Noble Black & Gold**.

## 🚀 Inicio Rápido

Para empezar, carga la librería usando el script compilado oficial:

```lua
local function LoadIntiHub()
    local success, response = pcall(function()
        -- URL de Producción Estable
        return game:HttpGet("https://raw.githubusercontent.com/Sam123mir/IntiHub-LibraryUI/main/dist/main.lua?v=" .. tick())
    end)
    
    if success and response then
        local loader, err = loadstring(response)
        if loader then
            return loader()
        else
            warn("IntiHub Loader Error: " .. tostring(err))
        end
    else
        warn("IntiHub Network Error: No se pudo descargar la librería.")
    end
end

local IntiHub = LoadIntiHub()

-- Crear la ventana principal estilo Noble
local Window = IntiHub:CreateWindow({
    Title = "IntiHub Premium",
    Subtitle = "The Gold Standard",
    ConfigFolder = "MiConfig",
    Theme = "Dark" -- Noble Black & Gold por defecto
})
```

---

## ✨ Compatibilidad con IA (API Aliases)

Para facilitar la creación de scripts mediante Inteligencia Artificial, IntiHub ahora soporta alias universales. Puedes usar indistintamente los siguientes métodos:

- **Ventanas:** `CreateWindow()`
- **Pestañas:** `Tab()` o `CreateTab()`
- **Secciones:** `Section()` o `CreateSection()`
- **Elementos:** `Button()` o `CreateButton()`, `Toggle()` o `CreateToggle()`, etc.

*Nota: La sintaxis corta (sin `Create`) es la recomendada para un código más limpio.*

---

### 1. Animación de Borde Rotativo (Glow)
La ventana principal ahora cuenta con **dos capas de animación dorada** que rotan en sentidos opuestos, creando un efecto de brillo dinámico y elegante.

### 2. StatusBar Persistente & Draggable
El widget de estado (`FPS`, `Ping`, `RAM`, `Time`) permanece visible incluso al minimizar la ventana. 
- **Nuevo Icono**: Reloj detallado (`alarm-clock-bold`).
- **Movilidad**: Arrástralo a cualquier parte de la pantalla.

### 3. OpenButton Enriquecido
El botón de reapertura ahora tiene una altura de **75px**, con iconos y texto escalados para una mejor legibilidad y presencia.

---

## 📂 Organización: Tabs y Sections

```lua
local Tab = Window:Tab({
    Title = "Inicio",
    Icon = "home",
    IconShape = "Squircle" -- Los fondos ahora son siempre Dorados
})

local Section = Tab:Section({
    Title = "Módulos de Combate",
    Icon = "swords"
})
```

---

## 🛠️ Componentes de Interacción

- **Buttons**: `Section:Button({ Title, Description, Callback })`
- **Toggles**: `Section:Toggle({ Title, Default, Callback })`
- **Sliders**: `Section:Slider({ Title, Min, Max, Default, Callback })`
- **Dropdowns**: `Section:Dropdown({ Title, Options, Callback })`
- **Inputs**: `Section:Input({ Title, Placeholder, Callback })`

---

## 🔔 Sistema de Notificaciones
```lua
IntiHub:Notify({
    Title = "Sistema Iniciado",
    Content = "Noble Black & Gold cargado con éxito.",
    Duration = 5
})
```

---
*Desarrollado con ❤️ por el Equipo de IntiHub.*
