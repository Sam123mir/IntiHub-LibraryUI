local DeluxeUI = {
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

local IntiHub = DeluxeUI -- Backward compatibility alias

DeluxeUI.cloneref = cloneref

local cloneref = (cloneref or clonereference or function(instance)
	return instance
end)

local HttpService = cloneref(game:GetService("HttpService"))
local Players = cloneref(game:GetService("Players"))
local CoreGui = cloneref(game:GetService("CoreGui"))
local RunService = cloneref(game:GetService("RunService"))

local LocalPlayer = Players.LocalPlayer or nil

local Package = HttpService:JSONDecode(require("../build/package"))
if Package then
	DeluxeUI.Version = Package.version
end

local KeySystem = require("./components/KeySystem")

local Creator = DeluxeUI.Creator

local New = Creator.New

local Acrylic = require("./utils/Acrylic/Init")

local ProtectGui = protectgui or (syn and syn.protect_gui) or function() end

local GUIParent = gethui and gethui() or (CoreGui or LocalPlayer:WaitForChild("PlayerGui"))

local UIScaleObj = New("UIScale", {
	Scale = DeluxeUI.UIScale,
})

DeluxeUI.UIScaleObj = UIScaleObj

DeluxeUI.ScreenGui = New("ScreenGui", {
	Name = "DeluxeUI",
	Parent = GUIParent,
	IgnoreGuiInset = true,
	ScreenInsets = "None",
	DisplayOrder = 100,
}, {
	New("Folder", {
		Name = "Window",
	}),
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

DeluxeUI.NotificationGui = New("ScreenGui", {
	Name = "DeluxeUI/Notifications",
	Parent = GUIParent,
	IgnoreGuiInset = true,
	DisplayOrder = 2001,
})
DeluxeUI.DropdownGui = New("Folder", {
	Name = "Dropdowns",
	Parent = DeluxeUI.ScreenGui,
})
DeluxeUI.TooltipGui = New("ScreenGui", {
	Name = "DeluxeUI/Tooltips",
	Parent = GUIParent,
	IgnoreGuiInset = true,
})
ProtectGui(DeluxeUI.ScreenGui)
ProtectGui(DeluxeUI.NotificationGui)
ProtectGui(DeluxeUI.TooltipGui)

Creator.Init(DeluxeUI)

function DeluxeUI:SetParent(parent)
	if DeluxeUI.ScreenGui then
		DeluxeUI.ScreenGui.Parent = parent
	end
	if DeluxeUI.NotificationGui then
		DeluxeUI.NotificationGui.Parent = parent
	end
	if DeluxeUI.TooltipGui then
		DeluxeUI.TooltipGui.Parent = parent
	end
end
math.clamp(DeluxeUI.TransparencyValue, 0, 1)

local Holder = DeluxeUI.NotificationModule.Init(DeluxeUI.NotificationGui)

function DeluxeUI:Notify(Config)
	Config.Holder = Holder.Frame
	Config.Window = DeluxeUI.Window
	return DeluxeUI.NotificationModule.New(Config)
end

function DeluxeUI:SetNotificationLower(Val)
	Holder.SetLower(Val)
end

function DeluxeUI:SetFont(FontId)
	Creator.UpdateFont(FontId)
end

function DeluxeUI:OnThemeChange(func)
	DeluxeUI.OnThemeChangeFunction = func
end

function DeluxeUI:AddTheme(LTheme)
	DeluxeUI.Themes[LTheme.Name] = LTheme
	return LTheme
end

function DeluxeUI:SetTheme(Value)
	if DeluxeUI.Themes[Value] then
		DeluxeUI.Theme = DeluxeUI.Themes[Value]
		Creator.SetTheme(DeluxeUI.Themes[Value])

		if DeluxeUI.OnThemeChangeFunction then
			DeluxeUI.OnThemeChangeFunction(Value)
		end

		return DeluxeUI.Themes[Value]
	end
	return nil
end

function DeluxeUI:GetThemes()
	return DeluxeUI.Themes
end
function DeluxeUI:GetCurrentTheme()
	return DeluxeUI.Theme.Name
end
function DeluxeUI:GetTransparency()
	return DeluxeUI.Transparent or false
end
function DeluxeUI:GetWindowSize()
	return DeluxeUI.Window.UIElements.Main.Size
end
function DeluxeUI:Localization(LocalizationConfig)
	return DeluxeUI.LocalizationModule:New(LocalizationConfig, Creator)
end

function DeluxeUI:SetLanguage(Value)
	if Creator.Localization then
		return Creator.SetLanguage(Value)
	end
	return false
end

function DeluxeUI:ToggleAcrylic(Value)
	if DeluxeUI.Window and DeluxeUI.Window.AcrylicPaint and DeluxeUI.Window.AcrylicPaint.Model then
		DeluxeUI.Window.Acrylic = Value
		DeluxeUI.Window.AcrylicPaint.Model.Transparency = Value and 0.98 or 1
		if Value and typeof(Acrylic) == "table" and Acrylic.Enable then
			Acrylic.Enable()
		elseif not Value and typeof(Acrylic) == "table" and Acrylic.Disable then
			Acrylic.Disable()
		end
	end
end

function DeluxeUI:Gradient(stops, props)
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

function DeluxeUI:Popup(PopupConfig)
	PopupConfig.IntiHub = DeluxeUI
	return require("./components/popup/Init").new(PopupConfig)
end

DeluxeUI.Themes = require("./themes/Init")(DeluxeUI)

Creator.Themes = DeluxeUI.Themes

DeluxeUI:SetTheme("Oceanic")
DeluxeUI:SetLanguage(Creator.Language)

function DeluxeUI:CreateWindow(Config)
	local CreateWindow = require("./components/window/Init")

	if not RunService:IsStudio() and writefile then
		pcall(function()
			if not isfolder("DeluxeUI_Data") then
				makefolder("DeluxeUI_Data")
			end
			local targetFolder = "DeluxeUI_Data/" .. (Config.Folder or Config.Title or "Default")
			if not isfolder(targetFolder) then
				makefolder(targetFolder)
			end
		end)
	end

	Config.IntiHub = DeluxeUI
	Config.Parent = DeluxeUI.ScreenGui.Window

	if DeluxeUI.Window then
		warn("You cannot create more than one window")
		return
	end

	local CanLoadWindow = true

	local Theme = DeluxeUI.Themes[Config.Theme or "Oceanic"]

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
						local serviceData = DeluxeUI.Services[i.Type]
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

	DeluxeUI.Transparent = Config.Transparent
	DeluxeUI.Window = Window

	DeluxeUI.StatusBar = require("./components/ui/StatusBar").New({
		IntiHub = DeluxeUI,
		Window = Window,
	})

	Window:OnDestroy(function()
		if DeluxeUI.StatusBar then
			DeluxeUI.StatusBar:Destroy()
			DeluxeUI.StatusBar = nil
		end
	end)

	if DeluxeUI.StatusBar then
		DeluxeUI.StatusBar:Visible(true)
	end

	if Config.Acrylic then
		Acrylic.init()
	end

	return Window
end

return DeluxeUI
