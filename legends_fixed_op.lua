--[[
    LEGENDS OF SPEED OP SCRIPT v4.0 (Noble Deluxe Edition)
    - Autofarm Optmizado (Remotes & Touch)
    - Interfaz Executive IntiHub
    - Perfiles de Color Noble Black & Gold
]]

local function LoadIntiHub()
    local success, response = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/Sam123mir/IntiHub-LibraryUI/main/dist/main.lua?v=" .. tick())
    end)
    
    if success and response then
        local loader, err = loadstring(response)
        if loader then
            return loader()
        else
            warn("[IntiHub] Error de Compilación: " .. tostring(err))
        end
    else
        warn("[IntiHub] Error de Red: No se pudo descargar la librería.")
    end
end

local IntiHub = LoadIntiHub()
if not IntiHub then return end

-- ================================================================
-- VARIABLES & SERVICIOS
-- ================================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Root = Character:WaitForChild("HumanoidRootPart")

local Flags = {
    AutoOrbs = false,
    AutoHoops = false,
    AutoGems = false,
    AutoRebirth = false,
    WalkSpeed = 16,
    JumpPower = 50,
    SelectedZone = "Playa"
}

local Zones = {
    ["Playa"] = Vector3.new(-100, 5, 200),
    ["Ciudad"] = Vector3.new(500, 5, -300),
    ["Desierto"] = Vector3.new(2000, 5, 1500)
}

-- ================================================================
-- INTERFAZ
-- ================================================================
local Window = IntiHub:CreateWindow({
    Title = "Legends of Speed",
    Subtitle = "Noble Executive Edition v4.0",
    ConfigFolder = "LegendsSpeedInti",
    Theme = "Dark"
})

-- Notificación de Inicio
IntiHub:Notify({
    Title = "Sistema Cargado",
    Content = "Bienvenido, " .. LocalPlayer.DisplayName .. ". Disfruta del Farm Noble.",
    Duration = 5
})

-- 🟢 TAB: FARMING
local FarmTab = Window:CreateTab({
    Title = "Autofarm",
    Icon = "zap",
    IconShape = "Squircle"
})

local MainSection = FarmTab:CreateSection({
    Title = "Módulos de Recolección",
    Icon = "package-search"
})

MainSection:CreateParagraph({
    Title = "Información del Farm",
    Content = "Activa los módulos para recolectar orbes y gemas automáticamente usando remotos seguros."
})

MainSection:CreateToggle({
    Title = "Auto Orbes",
    Description = "Recolecta orbes de forma remota sin moverte.",
    Default = false,
    Callback = function(v)
        Flags.AutoOrbs = v
    end
})

MainSection:CreateToggle({
    Title = "Auto Aros (Speed)",
    Description = "Pasa por los aros de velocidad automáticamente.",
    Default = false,
    Callback = function(v)
        Flags.AutoHoops = v
    end
})

MainSection:CreateToggle({
    Title = "Auto Gemas",
    Description = "Recolección rápida de gemas por zona.",
    Default = false,
    Callback = function(v)
        Flags.AutoGems = v
    end
})

local RebirthSection = FarmTab:CreateSection({
    Title = "Gestión de Progreso",
    Icon = "refresh-cw"
})

RebirthSection:CreateToggle({
    Title = "Auto Rebirth",
    Description = "Realiza rebirth cuando alcances el nivel máximo.",
    Default = false,
    Callback = function(v)
        Flags.AutoRebirth = v
    end
})

-- 🟢 TAB: JUGADOR
local PlayerTab = Window:CreateTab({
    Title = "Personaje",
    Icon = "user",
    IconShape = "Squircle"
})

local StatsSection = PlayerTab:CreateSection({
    Title = "Atributos Físicos",
    Icon = "activity"
})

StatsSection:CreateSlider({
    Title = "Velocidad al Caminar",
    Min = 16,
    Max = 500,
    Default = 16,
    Callback = function(v)
        Flags.WalkSpeed = v
        if Character:FindFirstChildOfClass("Humanoid") then
            Character.Humanoid.WalkSpeed = v
        end
    end
})

StatsSection:CreateSlider({
    Title = "Poder de Salto",
    Min = 50,
    Max = 500,
    Default = 50,
    Callback = function(v)
        Flags.JumpPower = v
        if Character:FindFirstChildOfClass("Humanoid") then
            Character.Humanoid.JumpPower = v
        end
    end
})

-- 🟢 TAB: TELEPORTS
local TPTab = Window:CreateTab({
    Title = "Mapas",
    Icon = "map-pin",
    IconShape = "Squircle"
})

local WorldSection = TPTab:CreateSection({
    Title = "Selección de Mundo",
    Icon = "globe"
})

WorldSection:CreateDropdown({
    Title = "Zona de Farm",
    Options = {"Playa", "Ciudad", "Desierto", "Magma", "Cielo"},
    Default = "Playa",
    Callback = function(v)
        Flags.SelectedZone = v
        IntiHub:Notify({
            Title = "Zona Cambiada",
            Content = "Ahora farmeando en: " .. v,
            Duration = 3
        })
    end
})

WorldSection:CreateButton({
    Title = "Teletransportarse Ahora",
    Description = "Viaja instantáneamente a la zona seleccionada.",
    Callback = function()
        local pos = Zones[Flags.SelectedZone] or Vector3.new(0, 100, 0)
        Root.CFrame = CFrame.new(pos)
    end
})

-- ================================================================
-- BUCLES DE LÓGICA (TASKS)
-- ================================================================

-- Loop Auto Orbs
task.spawn(function()
    while task.wait(0.1) do
        if Flags.AutoOrbs then
            pcall(function()
                -- Ejemplo de remoto (Ajustar según el juego real)
                game:GetService("ReplicatedStorage").collectOrb:FireServer("Orange Orb", Flags.SelectedZone)
            end)
        end
    end
end)

-- Loop Auto Gems
task.spawn(function()
    while task.wait(0.5) do
        if Flags.AutoGems then
            pcall(function()
                -- Lógica simulada de gemas
                game:GetService("ReplicatedStorage").collectGem:FireServer("Gema", Flags.SelectedZone)
            end)
        end
    end
end)

-- Mantener WalkSpeed
RunService.Stepped:Connect(function()
    if Character and Character:FindFirstChildOfClass("Humanoid") then
        Character.Humanoid.WalkSpeed = Flags.WalkSpeed
        Character.Humanoid.JumpPower = Flags.JumpPower
    end
end)

print("[Legends of Speed] Script cargado con IntiHub Noble Deluxe.")
