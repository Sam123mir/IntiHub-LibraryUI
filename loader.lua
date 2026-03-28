--[[
    IntiHub Universal Loader (Noble Deluxe v2.0)
    Carga siempre la versión más actualizada de tu script.
]]

local function InitializeLoader()
    local HttpService = game:GetService("HttpService")
    local title = "IntiHub | Noble Deluxe"
    
    local function Notify(msg)
        print("[" .. title .. "] " .. msg)
    end

    local function Fetch(url)
        local success, result = pcall(function()
            return game:HttpGet(url .. "?v=" .. tick())
        end)
        return success, result
    end

    Notify("Verificando la versión Noble Deluxe...")

    -- URL de tu script principal
    local MainScriptURL = "https://raw.githubusercontent.com/Sam123mir/IntiHub-LibraryUI/main/main.client.lua"

    local success, content = Fetch(MainScriptURL)
    
    if success and content then
        local exec, err = loadstring(content)
        if exec then
            Notify("Carga completa. Iniciando Dashboard Ejecutivo...")
            task.spawn(exec)
        else
            Notify("Error de Compilación: " .. tostring(err))
        end
    else
        Notify("Error de Conexión: No se pudo obtener el script v2.0.")
    end
end

InitializeLoader()
