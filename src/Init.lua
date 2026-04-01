local IntiHub = {
	Window = nil,
	Theme = nil,
	Creator = require("./modules/Creator"),
	LocalizationModule = require("./modules/Localization"),
	NotificationModule = require("./components/Notification"),
	Themes = nil,
	Transparent = false,

	TransparencyValue = 0.15,

	UIScale = 1,

	ConfigManager = nil,
	Version = "0.0.0",

	Services = require("./utils/services/Init"),

	OnThemeChangeFunction = nil,

	cloneref = nil,
	UIScaleObj = nil,
	StatusBar = nil,
}

local cloneref = (cloneref or clonereference or function(instance)
	return instance
end)

IntiHub.cloneref = cloneref

local HttpService = cloneref(game:GetService("HttpService"))
local Players = cloneref(game:GetService("Players"))
local CoreGui = cloneref(game:GetService("CoreGui"))
local RunService = cloneref(game:GetService("RunService"))

local LocalPlayer = Players.LocalPlayer or nil

local Package = HttpService:JSONDecode(require("../build/package"))
if Package then
	IntiHub.Version = Package.version
end

local KeySystem = require("./components/KeySystem")

local Creator = IntiHub.Creator

local New = Creator.New

--local Tween = Creator.Tween
--local ServicesModule = IntiHub.Services

local Acrylic = require("./utils/Acrylic/Init")

local ProtectGui = protectgui or (syn and syn.protect_gui) or function() end

local GUIParent = gethui and gethui() or (CoreGui or LocalPlayer:WaitForChild("PlayerGui"))

local UIScaleObj = New("UIScale", {
	Scale = IntiHub.UIScale,
})

IntiHub.UIScaleObj = UIScaleObj

IntiHub.ScreenGui = New("ScreenGui", {
	Name = "IntiHub",
	Parent = GUIParent,
	IgnoreGuiInset = true,
	ScreenInsets = "None",
	DisplayOrder = 100,
}, {

	New("Folder", {
		Name = "Window",
	}),
	-- New("Folder", {
	--     Name = "Notifications"
	-- }),
	-- New("Folder", {
	--     Name = "Dropdowns"
	-- }),
	New("Folder", {
		Name = "KeySystem",
	}),
	New("Folder", {
		Name = "Popups",
	}),
	New("Folder", {
		Name = "ToolTips",
	}),
})

IntiHub.NotificationGui = New("ScreenGui", {
	Name = "IntiHub/Notifications",
	Parent = GUIParent,
	IgnoreGuiInset = true,
	DisplayOrder = 1001,
})
IntiHub.DropdownGui = New("ScreenGui", {
	Name = "IntiHub/Dropdowns",
	Parent = GUIParent,
	IgnoreGuiInset = true,
	DisplayOrder = 1000,
})
IntiHub.TooltipGui = New("ScreenGui", {
	Name = "IntiHub/Tooltips",
	Parent = GUIParent,
	IgnoreGuiInset = true,
})
ProtectGui(IntiHub.ScreenGui)
ProtectGui(IntiHub.NotificationGui)
ProtectGui(IntiHub.DropdownGui)
ProtectGui(IntiHub.TooltipGui)

Creator.Init(IntiHub)

function IntiHub:SetParent(parent)
	if IntiHub.ScreenGui then
		IntiHub.ScreenGui.Parent = parent
	end
	if IntiHub.NotificationGui then
		IntiHub.NotificationGui.Parent = parent
	end
	if IntiHub.DropdownGui then
		IntiHub.DropdownGui.Parent = parent
	end
	if IntiHub.TooltipGui then
		IntiHub.TooltipGui.Parent = parent
	end
end
math.clamp(IntiHub.TransparencyValue, 0, 1)

local Holder = IntiHub.NotificationModule.Init(IntiHub.NotificationGui)

function IntiHub:Notify(Config)
	Config.Holder = Holder.Frame
	Config.Window = IntiHub.Window
	--Config.IntiHub = IntiHub
	return IntiHub.NotificationModule.New(Config)
end

function IntiHub:SetNotificationLower(Val)
	Holder.SetLower(Val)
end

function IntiHub:SetFont(FontId)
	Creator.UpdateFont(FontId)
end

function IntiHub:OnThemeChange(func)
	IntiHub.OnThemeChangeFunction = func
end

function IntiHub:AddTheme(LTheme)
	IntiHub.Themes[LTheme.Name] = LTheme
	return LTheme
end

function IntiHub:SetTheme(Value)
	if IntiHub.Themes[Value] then
		IntiHub.Theme = IntiHub.Themes[Value]
		Creator.SetTheme(IntiHub.Themes[Value])

		if IntiHub.OnThemeChangeFunction then
			IntiHub.OnThemeChangeFunction(Value)
		end

		return IntiHub.Themes[Value]
	end
	return nil
end

function IntiHub:GetThemes()
	return IntiHub.Themes
end
function IntiHub:GetCurrentTheme()
	return IntiHub.Theme.Name
end
function IntiHub:GetTransparency()
	return IntiHub.Transparent or false
end
function IntiHub:GetWindowSize()
	return IntiHub.Window.UIElements.Main.Size
end
function IntiHub:Localization(LocalizationConfig)
	return IntiHub.LocalizationModule:New(LocalizationConfig, Creator)
end

function IntiHub:SetLanguage(Value)
	if Creator.Localization then
		return Creator.SetLanguage(Value)
	end
	return false
end

function IntiHub:ToggleAcrylic(Value)
	if IntiHub.Window and IntiHub.Window.AcrylicPaint and IntiHub.Window.AcrylicPaint.Model then
		IntiHub.Window.Acrylic = Value
		IntiHub.Window.AcrylicPaint.Model.Transparency = Value and 0.98 or 1
		if Value and typeof(Acrylic) == "table" and Acrylic.Enable then
			Acrylic.Enable()
		elseif not Value and typeof(Acrylic) == "table" and Acrylic.Disable then
			Acrylic.Disable()
		end
	end
end

function IntiHub:Gradient(stops, props)
	local colorSequence = {}
	local transparencySequence = {}

	for posStr, stop in next, stops do
		local position = tonumber(posStr)
		if position then
			position = math.clamp(position / 100, 0, 1)

			local color = stop.Color
			if typeof(color) == "string" and string.sub(color, 1, 1) == "#" then
				color = Color3.fromHex(color)
			end

			local transparency = stop.Transparency or 0

			table.insert(colorSequence, ColorSequenceKeypoint.new(position, color))
			table.insert(transparencySequence, NumberSequenceKeypoint.new(position, transparency))
		end
	end

	table.sort(colorSequence, function(a, b)
		return a.Time < b.Time
	end)
	table.sort(transparencySequence, function(a, b)
		return a.Time < b.Time
	end)

	if #colorSequence < 2 then
		table.insert(colorSequence, ColorSequenceKeypoint.new(1, colorSequence[1].Value))
		table.insert(transparencySequence, NumberSequenceKeypoint.new(1, transparencySequence[1].Value))
	end

	local gradientData = {
		Color = ColorSequence.new(colorSequence),
		Transparency = NumberSequence.new(transparencySequence),
	}

	if props then
		for k, v in pairs(props) do
			gradientData[k] = v
		end
	end

	return gradientData
end

function IntiHub:Popup(PopupConfig)
	PopupConfig.IntiHub = IntiHub
	return require("./components/popup/Init").new(PopupConfig)
end

IntiHub.Themes = require("./themes/Init")(IntiHub)

Creator.Themes = IntiHub.Themes

IntiHub:SetTheme("Dark")
IntiHub:SetLanguage(Creator.Language)

function IntiHub:CreateWindow(Config)
	local CreateWindow = require("./components/window/Init")

	if not RunService:IsStudio() and writefile then
		pcall(function()
			if not isfolder("IntiHub_Data") then
				makefolder("IntiHub_Data")
			end
			local targetFolder = "IntiHub_Data/" .. (Config.Folder or Config.Title or "Default")
			if not isfolder(targetFolder) then
				makefolder(targetFolder)
			end
		end)
	end

	Config.IntiHub = IntiHub
	Config.Parent = IntiHub.ScreenGui.Window

	if IntiHub.Window then
		warn("You cannot create more than one window")
		return
	end

	local CanLoadWindow = true

	local Theme = IntiHub.Themes[Config.Theme or "Dark"]

	--IntiHub.Theme = Theme
	Creator.SetTheme(Theme)

	local hwid = gethwid or function()
		return Players.LocalPlayer.UserId
	end

	local Filename = hwid()

	if Config.KeySystem then
		CanLoadWindow = false

		local function loadKeysystem()
			KeySystem.new(Config, Filename, function(c)
				CanLoadWindow = c
			end)
		end

		local keyPath = (Config.Folder or "Temp") .. "/" .. Filename .. ".key"

		if Config.KeySystem.KeyValidator then
			if Config.KeySystem.SaveKey and isfile(keyPath) then
				local readSuccess, savedKey = pcall(function()
					return readfile(keyPath)
				end)

				if readSuccess then
					local isValid = Config.KeySystem.KeyValidator(savedKey)

					if isValid then
						CanLoadWindow = true
					else
						loadKeysystem()
					end
				else
					loadKeysystem()
				end
			else
				loadKeysystem()
			end
		elseif not Config.KeySystem.API then
			if Config.KeySystem.SaveKey and isfile(keyPath) then
				local readSuccess, savedKey = pcall(function()
					return readfile(keyPath)
				end)

				if readSuccess then
					local isKey = (type(Config.KeySystem.Key) == "table") and table.find(Config.KeySystem.Key, savedKey)
						or tostring(Config.KeySystem.Key) == tostring(savedKey)

					if isKey then
						CanLoadWindow = true
					else
						loadKeysystem()
					end
				else
					loadKeysystem()
				end
			else
				loadKeysystem()
			end
		else
			if isfile(keyPath) then
				local readSuccess, fileKey = pcall(function()
					return readfile(keyPath)
				end)

				if readSuccess then
					local isSuccess = false

					for _, i in next, Config.KeySystem.API do
						local serviceData = IntiHub.Services[i.Type]
						if serviceData then
							local args = {}
							for _, argName in next, serviceData.Args do
								table.insert(args, i[argName])
							end

							local service = serviceData.New(table.unpack(args))
							local success = service.Verify(fileKey)
							if success then
								isSuccess = true
								break
							end
						end
					end

					CanLoadWindow = isSuccess
					if not isSuccess then
						loadKeysystem()
					end
				else
					loadKeysystem()
				end
			else
				loadKeysystem()
			end
		end

		repeat
			task.wait()
		until CanLoadWindow
	end

	local Window = CreateWindow(Config)

	IntiHub.Transparent = Config.Transparent
	IntiHub.Window = Window

	IntiHub.StatusBar = require("./components/ui/StatusBar").New({
		IntiHub = IntiHub,
		Window = Window,
	})

	Window:OnDestroy(function()
		if IntiHub.StatusBar then
			IntiHub.StatusBar:Destroy()
			IntiHub.StatusBar = nil
		end
	end)

	if IntiHub.StatusBar then
		IntiHub.StatusBar:Visible(true)
	end

	if Config.Acrylic then
		Acrylic.init()
	end

	return Window
end

return IntiHub
