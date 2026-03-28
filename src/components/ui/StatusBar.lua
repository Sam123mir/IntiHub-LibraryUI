-- /* src/components/ui/StatusBar.lua */

local cloneref = (cloneref or clonereference or function(instance)
	return instance
end)

local RunService = cloneref(game:GetService("RunService"))
local Players = cloneref(game:GetService("Players"))
local Stats = cloneref(game:GetService("Stats"))

local Creator = require("../../modules/Creator")
local New = Creator.New
local Tween = Creator.Tween

local StatusBar = {}

function StatusBar.New(Config)
	local IntiHub = Config.IntiHub
	local Window = Config.Window

	local UI = New("Frame", {
		Name = "StatusBar",
		Size = UDim2.new(0, 0, 0, 45),
		Position = UDim2.new(0.5, 0, 0, 10),
		AnchorPoint = Vector2.new(0.5, 0),
		BackgroundColor3 = Color3.fromHex("#0F0D00"),
		BackgroundTransparency = 0.2,
		AutomaticSize = "X",
		Visible = true,
		Parent = IntiHub.ScreenGui,
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(0, 10),
		}),
		New("UIStroke", {
			Thickness = 1.5,
			ThemeTag = {
				Color = "Accent",
			},
			Transparency = 0.5,
		}),
		New("UIListLayout", {
			FillDirection = "Horizontal",
			Padding = UDim.new(0, 25),
			VerticalAlignment = "Center",
			SortOrder = "LayoutOrder",
		}),
		New("UIPadding", {
			PaddingLeft = UDim.new(0, 20),
			PaddingRight = UDim.new(0, 20),
		}),
	})

	local function CreateStat(Icon, Label, Value, LayoutOrder)
		local Section = New("Frame", {
			Size = UDim2.new(0, 0, 1, 0),
			AutomaticSize = "X",
			BackgroundTransparency = 1,
			LayoutOrder = LayoutOrder,
		}, {
			New("UIListLayout", {
				FillDirection = "Horizontal",
				Padding = UDim.new(0, 10),
				VerticalAlignment = "Center",
			}),
			New("Frame", {
				Size = UDim2.new(0, 30, 0, 30),
				BackgroundColor3 = Color3.fromHex("#1A1A1A"),
				ThemeTag = {
					BackgroundColor3 = "Accent",
				},
			}, {
				New("UICorner", { CornerRadius = UDim.new(0, 6) }),
				New("ImageLabel", {
					Image = Creator.Icon(Icon) and Creator.Icon(Icon)[1] or "",
					ImageRectOffset = Creator.Icon(Icon) and Creator.Icon(Icon)[2].ImageRectPosition or Vector2.new(0, 0),
					ImageRectSize = Creator.Icon(Icon) and Creator.Icon(Icon)[2].ImageRectSize or Vector2.new(0, 0),
					Size = UDim2.new(0, 20, 0, 20),
					Position = UDim2.new(0.5, 0, 0.5, 0),
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundTransparency = 1,
					ImageColor3 = Color3.fromHex("#000000"),
				}),
			}),
			New("Frame", {
				Size = UDim2.new(0, 0, 0, 0),
				AutomaticSize = "XY",
				BackgroundTransparency = 1,
			}, {
				New("UIListLayout", { FillDirection = "Vertical", Padding = UDim.new(0, 2) }),
				New("TextLabel", {
					Text = Label:upper(),
					TextSize = 11,
					FontFace = Font.new(Creator.Font, Enum.FontWeight.Bold),
					TextColor3 = Color3.fromHex("#FFC300"),
					ThemeTag = { TextColor3 = "Accent" },
					TextTransparency = 0.4,
					AutomaticSize = "XY",
					BackgroundTransparency = 1,
				}),
				Value,
			}),
		})
		Section.Parent = UI
		return Value
	end

	-- Logo Section
	local LogoIcon = Window.Icon or "rbxassetid://0"
	if typeof(LogoIcon) == "string" and string.find(LogoIcon, "http") then
		LogoIcon = Creator.GetAsset(LogoIcon, Window.Folder, "icon", "StatusBarLogo")
	end

	local LogoSection = New("Frame", {
		Size = UDim2.new(0, 0, 1, 0),
		AutomaticSize = "X",
		BackgroundTransparency = 1,
		LayoutOrder = 1,
	}, {
		New("UIListLayout", {
			FillDirection = "Horizontal",
			Padding = UDim.new(0, 10),
			VerticalAlignment = "Center",
		}),
		New("Frame", {
			Size = UDim2.new(0, 30, 0, 30),
			BackgroundColor3 = Color3.fromHex("#FFC300"),
			ThemeTag = {
				BackgroundColor3 = "Accent",
			},
		}, {
			New("UICorner", { CornerRadius = UDim.new(0, 4) }),
			New("ImageLabel", {
				Image = LogoIcon,
				Size = UDim2.new(0, 22, 0, 22),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				ImageColor3 = Color3.new(0, 0, 0),
			}),
		}),
		New("TextLabel", {
			Text = Window.Title or "INTIHUB",
			TextSize = 16,
			FontFace = Font.new(Creator.Font, Enum.FontWeight.Bold),
			TextColor3 = Color3.fromHex("#FFC300"),
			ThemeTag = {
				TextColor3 = "Accent",
			},
			AutomaticSize = "XY",
			BackgroundTransparency = 1,
		}),
	})
	LogoSection.Parent = UI

	-- Divider
	 New("Frame", {
		Size = UDim2.new(0, 1, 0, 25),
		BackgroundColor3 = Color3.new(1, 1, 1),
		BackgroundTransparency = 0.8,
		Parent = UI,
		LayoutOrder = 2,
	})

	-- Game Section
	local ProductName = "Unknown Game"
	pcall(function()
		ProductName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
	end)

	local GameText = New("TextLabel", {
		Text = ProductName,
		TextSize = 14,
		FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
		TextColor3 = Color3.new(1, 1, 1),
		AutomaticSize = "XY",
		BackgroundTransparency = 1,
	})
	CreateStat("solar:gamepad-minimalistic-bold", "GAME", GameText, 3)

	-- Session Section
	local SessionText = New("TextLabel", {
		Text = Players.LocalPlayer.DisplayName,
		TextSize = 14,
		FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
		TextColor3 = Color3.new(1, 1, 1),
		AutomaticSize = "XY",
		BackgroundTransparency = 1,
	})
	CreateStat("solar:user-bold", "SESSION", SessionText, 4)

	local PingText = New("TextLabel", {
		Text = "0 ms",
		TextSize = 14,
		FontFace = Font.new(Creator.Font, Enum.FontWeight.Bold),
		TextColor3 = Color3.fromHex("#FFC300"),
		ThemeTag = { TextColor3 = "Accent" },
		AutomaticSize = "XY",
		BackgroundTransparency = 1,
	})
	CreateStat("solar:transmission-bold", "PING", PingText, 5)

	local RamText = New("TextLabel", {
		Text = "0 MB",
		TextSize = 14,
		FontFace = Font.new(Creator.Font, Enum.FontWeight.Bold),
		TextColor3 = Color3.fromHex("#FFC300"),
		ThemeTag = { TextColor3 = "Accent" },
		AutomaticSize = "XY",
		BackgroundTransparency = 1,
	})
	CreateStat("solar:cpu-bold", "RAM", RamText, 6)

	local FpsText = New("TextLabel", {
		Text = "0 FPS",
		TextSize = 14,
		FontFace = Font.new(Creator.Font, Enum.FontWeight.Bold),
		TextColor3 = Color3.fromHex("#FFC300"),
		ThemeTag = { TextColor3 = "Accent" },
		AutomaticSize = "XY",
		BackgroundTransparency = 1,
	})
	CreateStat("solar:chart-2-bold", "FPS", FpsText, 7)

	local TimeText = New("TextLabel", {
		Text = "00:00:00",
		TextSize = 14,
		FontFace = Font.new(Creator.Font, Enum.FontWeight.Bold),
		TextColor3 = Color3.fromHex("#FFC300"),
		ThemeTag = { TextColor3 = "Accent" },
		AutomaticSize = "XY",
		BackgroundTransparency = 1,
	})
	CreateStat("solar:alarm-clock-bold", "TIME", TimeText, 8)

	-- Update Logic
	local lastUpdate = tick()
	local frameCount = 0
	local fps = 0

	local Connection = RunService.RenderStepped:Connect(function()
		frameCount = frameCount + 1
		local now = tick()
		if now - lastUpdate >= 1 then
			fps = frameCount
			frameCount = 0
			lastUpdate = now

			FpsText.Text = tostring(fps) .. " FPS"
			TimeText.Text = os.date("%H:%M:%S")
			
			local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
			PingText.Text = tostring(ping) .. " ms"
			
			local ram = math.floor(Stats:GetTotalMemoryUsageMb())
			if ram > 1024 then
				RamText.Text = string.format("%.1f GB", ram / 1024)
			else
				RamText.Text = tostring(ram) .. " MB"
			end
		end
	end)

	UI.Position = UDim2.new(0.5, 0, 1, -60)
	
	Creator.Drag(UI)

	local StatusBarInstance = {}

	function StatusBarInstance:Destroy()
		Connection:Disconnect()
		UI:Destroy()
	end

	function StatusBarInstance:Visible(v)
		UI.Visible = v
	end

	return StatusBarInstance
end

return StatusBar
