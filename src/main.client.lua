-- IntiHub Noble Deluxe Bootstrap
local IntiHub = require("./Init")
local Loading = require("./components/ui/Loading")
local App = require("./App")

-- Start Premium Loading Experience
local loader = Loading.new({
    IntiHub = IntiHub,
    InitialMessage = "Verificando Versión Noble Deluxe..."
})

task.wait(1.2) -- Aesthetic pause

-- Load Modules
loader:Update("Cargando Motor Gráfico (DarkLua)...")
task.wait(0.6)

loader:Update("Sincronizando con IntiHub API...")
task.wait(0.8)

-- Initialize Application
local success, result = pcall(function()
    return App(IntiHub, loader)
end)

if success then
    loader:Update("Iniciando Dashboard Ejecutivo...")
    task.wait(1)
    
    local Window = result
    if Window and Window.Open then
        Window:Open()
    end
    
    loader:Destroy()
else
    loader:Update("Error en el arranque: " .. tostring(result))
    warn("[IntiHub Critical Error]: " .. tostring(result))
    -- Don't destroy loader so user can see the error
end
