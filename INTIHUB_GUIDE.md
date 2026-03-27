# Guía de Implementación de IntiHub Premium

¡Bienvenido a **IntiHub**, la librería de UI más avanzada y estética para Roblox! Esta guía te enseñará cómo implementar todos los componentes disponibles para crear scripts profesionales con un estilo **Black & Gold**.

## 🚀 Inicio Rápido

Para empezar, carga la librería usando `loadstring`:

```lua
local IntiHub = loadstring(game:HttpGet("https://raw.githubusercontent.com/Sam123mir/IntiHub-LibraryUI/main/dist/main.lua"))()

-- Crear la ventana principal
local Window = IntiHub:CreateWindow({
    Title = "Mi Script Premium",
    Subtitle = "IntiHub Edition",
    ConfigFolder = "MiConfig", -- Carpeta donde se guardarán las configs
    Theme = "Dark"
})
```

---

## 📂 Pestañas y Secciones

Las pestañas (Tabs) organizan tu script, y las secciones (Sections) agrupan elementos dentro de las pestañas.

```lua
local Tab = Window:Tab({
    Title = "Inicio",
    Icon = "home" -- Usa nombres de Lucide Icons
})

local Section = Tab:Section({
    Title = "Configuraciones",
    Icon = "settings"
})
```

---

## 🛠️ Componentes de Interacción

### 1. Botón (Button)
Ideal para acciones instantáneas.
```lua
Section:Button({
    Title = "Ejecutar",
    Description = "Haz clic para iniciar el proceso",
    Callback = function()
        print("Botón presionado")
    end
})
```

### 2. Interruptor (Toggle)
Para activar o desactivar funciones.
```lua
Section:Toggle({
    Title = "Autofarm",
    Description = "Activa el farmeo automático",
    Default = false,
    Callback = function(Value)
        print("Estado:", Value)
    end
})
```

### 3. Campo de Entrada (Input)
Para que el usuario escriba texto o números.
```lua
Section:Input({
    Title = "Nombre de Usuario",
    Placeholder = "Escribe aquí...",
    Callback = function(Value)
        print("Texto ingresado:", Value)
    end
})
```

### 4. Deslizador (Slider)
Para valores numéricos con un rango.
```lua
Section:Slider({
    Title = "Velocidad",
    Default = 16,
    Min = 16,
    Max = 500,
    Callback = function(Value)
        print("Velocidad ajustada a:", Value)
    end
})
```

### 5. Menú Desplegable (Dropdown)
Para elegir entre múltiples opciones.
```lua
Section:Dropdown({
    Title = "Seleccionar Arma",
    Options = {"Espada", "Arco", "Hechizo"},
    Default = "Espada",
    Callback = function(Value)
        print("Seleccionaste:", Value)
    end
})
```

---

## 🔔 Notificaciones y Popups

### Notificaciones (Notifies)
Pequeños avisos en la esquina de la pantalla.
```lua
IntiHub:Notify({
    Title = "Éxito",
    Content = "Script cargado correctamente",
    Duration = 5
})
```

---

## ✨ Widgets de Estado (StatusBar)
IntiHub incluye un widget de estado automático que muestra:
- **FPS**: Fotogramas por segundo.
- **Ping**: Latencia de red.
- **RAM**: Uso de memoria.
- **Hora**: Reloj en tiempo real.

Este widget es **arrastrable** (puedes moverlo con el ratón) y aparecerá automáticamente al crear tu ventana.

---

## 🎨 Personalización Estética
IntiHub utiliza un sistema de temas dinámico. El tema por defecto es **Black & Gold**, diseñado por **Sammir_Inti** para una apariencia ultra-premium.

- **Bordes Dorados**: Los iconos de las secciones ahora tienen un borde cuadrado redondeado automático.
- **Transparencia**: El fondo de la ventana tiene un tinte dorado elegante y traslúcido.

---
*Desarrollado con ❤️ para la comunidad de Sammir_Inti.*
