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

	-- Logo Section
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
		}, {
			New("UICorner", { CornerRadius = UDim.new(0, 4) }),
			New("TextLabel", {
				Text = "/",
				TextSize = 18,
				FontFace = Font.new(Creator.Font, Enum.FontWeight.Bold),
				TextColor3 = Color3.new(0, 0, 0),
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
			}),
		}),
		New("TextLabel", {
			Text = "INTIHUB",
			TextSize = 18,
			FontFace = Font.new(Creator.Font, Enum.FontWeight.Bold),
			TextColor3 = Color3.fromHex("#FFC300"),
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

	-- Session Section
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
			}, {
				New("UICorner", { CornerRadius = UDim.new(0, 6) }),
				New("ImageLabel", {
					Image = Creator.Icon(Icon)[1],
					ImageRectOffset = Creator.Icon(Icon)[2].ImageRectPosition,
					ImageRectSize = Creator.Icon(Icon)[2].ImageRectSize,
					Size = UDim2.new(0, 16, 0, 16),
					Position = UDim2.new(0.5, 0, 0.5, 0),
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundTransparency = 1,
					ImageColor3 = Color3.fromHex("#FFC300"),
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

	local SessionText = New("TextLabel", {
		Text = Players.LocalPlayer.DisplayName .. " — " .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name,
		TextSize = 14,
		FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
		TextColor3 = Color3.new(1, 1, 1),
		AutomaticSize = "XY",
		BackgroundTransparency = 1,
	})
	CreateStat("user", "SESSION", SessionText, 3)

	local PingText = New("TextLabel", {
		Text = "0 ms",
		TextSize = 14,
		FontFace = Font.new(Creator.Font, Enum.FontWeight.Bold),
		TextColor3 = Color3.fromHex("#FFC300"),
		AutomaticSize = "XY",
		BackgroundTransparency = 1,
	})
	CreateStat("gauge", "PING", PingText, 4)

	local RamText = New("TextLabel", {
		Text = "0 MB",
		TextSize = 14,
		FontFace = Font.new(Creator.Font, Enum.FontWeight.Bold),
		TextColor3 = Color3.fromHex("#FFC300"),
		AutomaticSize = "XY",
		BackgroundTransparency = 1,
	})
	CreateStat("cpu", "RAM", RamText, 5)

	local FpsText = New("TextLabel", {
		Text = "0 FPS",
		TextSize = 14,
		FontFace = Font.new(Creator.Font, Enum.FontWeight.Bold),
		TextColor3 = Color3.fromHex("#FFC300"),
		AutomaticSize = "XY",
		BackgroundTransparency = 1,
	})
	CreateStat("bar-chart-2", "FPS", FpsText, 6)

	local TimeText = New("TextLabel", {
		Text = "00:00:00",
		TextSize = 14,
		FontFace = Font.new(Creator.Font, Enum.FontWeight.Bold),
		TextColor3 = Color3.fromHex("#FFC300"),
		AutomaticSize = "XY",
		BackgroundTransparency = 1,
	})
	CreateStat("clock", "TIME", TimeText, 7)

	-- Update Logic
	local lastUpdate = tick()
	local frameCount = 0
	local fps = 0

	local Connection = RunService.RenderStepped:Connect(function()
		frameCount += 1
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
