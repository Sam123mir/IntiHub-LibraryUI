--[[
    IntiHub Universal Loader (Noble Deluxe)
    Carga siempre la versión más actualizada de tu script.
]]

local function InitializeLoader()
    local HttpService = game:GetService("HttpService")
    local title = "IntiHub | Loader"
    
    local function Notify(msg)
        print("[" .. title .. "] " .. msg)
        -- Si ya tienes la UI cargada, puedes usar IntiHub:Notify aquí
    end

    local function Fetch(url)
        local success, result = pcall(function()
            return game:HttpGet(url .. "?v=" .. tick())
        end)
        return success, result
    end

    Notify("Verificando actualizaciones...")

    -- URL de tu script principal (donde los usuarios verán tu HUD/UI)
    local MainScriptURL = "https://raw.githubusercontent.com/Sam123mir/IntiHub-LibraryUI/main/main.client.lua"

    local success, content = Fetch(MainScriptURL)
    
    if success and content then
        local exec, err = loadstring(content)
        if exec then
            Notify("Carga completa. Iniciando...")
            task.spawn(exec)
        else
            Notify("Error de Compilación: " .. tostring(err))
        end
    else
        Notify("Error de Conexión: No se pudo obtener el script.")
    end
end

InitializeLoader()
