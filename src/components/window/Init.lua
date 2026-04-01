-- /* src/components/Window/Init.lua */

local cloneref = (cloneref or clonereference or function(instance)
	return instance
end)

local UserInputService = cloneref(game:GetService("UserInputService"))
local RunService = cloneref(game:GetService("RunService"))
local Players = cloneref(game:GetService("Players"))

local CurrentCamera = workspace.CurrentCamera

local Acrylic = require("../../utils/Acrylic/Init")

local Creator = require("../../modules/Creator")
local New = Creator.New
local Tween = Creator.Tween

--local UIComponents = require("../Components/UI.lua")
local CreateLabel = require("../ui/Label").New
local CreateButton = require("../ui/Button").New
local CreateScrollSlider = require("../ui/ScrollSlider").New
local Tag = require("../ui/Tag")

local MinimizedBar = require("./MinimizedBar")
local Search = require("../search/Init")

local Color3 = Color3
local UDim = UDim
local UDim2 = UDim2
local Vector2 = Vector2
local Font = Font
local Enum = Enum
local math = math

local ConfigManager = require("../../config/Init")

local Notified = false

return function(Config)
	local Window = {
		Title = Config.Title or "UI Library",
		Author = Config.Author,
		Icon = Config.Icon or "https://raw.githubusercontent.com/Sam123mir/IntiHub-LibraryUI/main/docs/logo.png",
		IconSize = Config.IconSize or 22,
		IconThemed = Config.IconThemed,
		IconRadius = Config.IconRadius or 0,
		Folder = Config.Folder or "IntiHub",
		Resizable = Config.Resizable ~= false,
		Background = Config.Background,
		BackgroundImageTransparency = Config.BackgroundImageTransparency or 0,
		ShadowTransparency = Config.ShadowTransparency or 0.6,
		User = Config.User or {},
		Footer = Config.Footer or {},
		Topbar = Config.Topbar or { Height = 52, ButtonsType = "Default" }, -- Default or Mac

		Size = Config.Size,

		MinSize = Config.MinSize or Vector2.new(560, 350),
		MaxSize = Config.MaxSize or Vector2.new(850, 560),

		TopBarButtonIconSize = Config.TopBarButtonIconSize,

		ToggleKey = Config.ToggleKey,
		ElementsRadius = Config.ElementsRadius,
		Radius = Config.Radius or 14,
		Transparent = Config.Transparent or false,
		HideSearchBar = Config.HideSearchBar or false, -- Default to shown if not specified, matching user request
		ScrollBarEnabled = Config.ScrollBarEnabled or false,
		SideBarWidth = Config.SideBarWidth or 200,
		Acrylic = Config.Acrylic or false,
		NewElements = Config.NewElements or false,
		IgnoreAlerts = Config.IgnoreAlerts or false,
		HidePanelBackground = Config.HidePanelBackground or false,
		AutoScale = Config.AutoScale ~= false,
		OpenButton = Config.OpenButton,
		DragFrameSize = 160,

		Position = UDim2.new(0.5, 0, 0.5, 0),
		UICorner = nil, -- Window.Radius (16)
		UIPadding = 14,
		UIElements = {},
		CanDropdown = true,
		Closed = false,
		Parent = Config.Parent,
		Destroyed = false,
		IsFullscreen = false,
		CanResize = Config.Resizable ~= false,
		IsOpenButtonEnabled = true,

		CurrentConfig = nil,
		ConfigManager = nil,
		AcrylicPaint = nil,
		CurrentTab = nil,
		TabModule = nil,

		OnOpenCallback = nil,
		OnCloseCallback = nil,
		OnDestroyCallback = nil,

		IsPC = false,

		Gap = 5,

		TopBarButtons = {},
		AllElements = {},

		ElementConfig = {},

		PendingFlags = {},

		IsToggleDragging = false,
	}

	Window.UICorner = Window.Radius

	Window.TopBarButtonIconSize = Window.TopBarButtonIconSize or (Window.Topbar.ButtonsType == "Mac" and 11 or 16)

	Window.ElementConfig = {
		UIPadding = (Window.NewElements and 10 or 13),
		UICorner = Window.ElementsRadius or (Window.NewElements and 23 or 12),
	}

	local WindowSize = Window.Size or UDim2.new(0, 780, 0, 500) -- Increased default size for Dashboard
	Window.Size = UDim2.new(
		WindowSize.X.Scale,
		math.clamp(WindowSize.X.Offset, Window.MinSize.X, 1200),
		WindowSize.Y.Scale,
		math.clamp(WindowSize.Y.Offset, Window.MinSize.Y, 800)
	)

	if Window.Topbar == {} then
		Window.Topbar = { Height = 52, ButtonsType = "Default" }
	end

	if not RunService:IsStudio() and Window.Folder and writefile then
		pcall(function()
			if not isfolder("IntiHub_Data/" .. Window.Folder) then
				makefolder("IntiHub_Data/" .. Window.Folder)
			end
			if not isfolder("IntiHub_Data/" .. Window.Folder .. "/assets") then
				makefolder("IntiHub_Data/" .. Window.Folder .. "/assets")
			end
		end)
	end

	local function GetUserThumb(Anonymous)
		local success, result = pcall(function()
			return Players:GetUserThumbnailAsync(
				Anonymous and 1 or Players.LocalPlayer.UserId,
				Enum.ThumbnailType.HeadShot,
				Enum.ThumbnailSize.Size420x420
			)
		end)
        return success and result or "rbxassetid://0"
	end
	Window.User.Enabled = true -- 🟢 Force Executive User Panel for Noble Deluxe
    Window.SideBarWidth = Window.SideBarWidth or 200

	local UICorner = New("UICorner", {
		CornerRadius = UDim.new(0, Window.UICorner),
	})

	if Window.Folder then
		Window.ConfigManager = ConfigManager:Init(Window)
	end

	if Window.Acrylic then
		local AcrylicPaint, BlurModule = Acrylic.AcrylicPaint({ UseAcrylic = Window.Acrylic })

		Window.AcrylicPaint = AcrylicPaint
	end

	local ResizeHandle = New("Frame", {
		Size = UDim2.new(0, 32, 0, 32),
		Position = UDim2.new(1, 0, 1, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		ZIndex = 99,
		Active = true,
	}, {
		New("ImageLabel", {
			Size = UDim2.new(0, 48 * 2, 0, 48 * 2),
			BackgroundTransparency = 1,
			Image = "rbxassetid://120997033468887",
			Position = UDim2.new(0.5, -16, 0.5, -16),
			AnchorPoint = Vector2.new(0.5, 0.5),
			ImageTransparency = 1, -- .8; .35
		}),
	})
	local FullScreenIcon = Creator.NewRoundFrame(Window.UICorner, "Squircle", {
		Size = UDim2.new(1, 0, 1, 0),
		ImageTransparency = 1, -- .65
		ImageColor3 = Color3.new(0, 0, 0),
		ZIndex = 98,
		Active = false, -- true
	}, {
		New("ImageLabel", {
			Size = UDim2.new(0, 70, 0, 70),
			Image = Creator.Icon("expand")[1],
			ImageRectOffset = Creator.Icon("expand")[2].ImageRectPosition,
			ImageRectSize = Creator.Icon("expand")[2].ImageRectSize,
			BackgroundTransparency = 1,
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			ImageTransparency = 1,
		}),
	})

	local FullScreenBlur = Creator.NewRoundFrame(Window.UICorner, "Squircle", {
		Size = UDim2.new(1, 0, 1, 0),
		ImageTransparency = 1, -- .65
		ImageColor3 = Color3.new(0, 0, 0),
		ZIndex = 999,
		Active = false, -- true
	})

	-- local TabHighlight = Creator.NewRoundFrame(Window.UICorner-(Window.UIPadding/2), "Squircle", {
	--     Size = UDim2.new(1,0,0,0),
	--     ImageTransparency = .95,
	--     ThemeTag = {
	--         ImageColor3 = "Text",
	--     }
	-- })

	Window.UIElements.SideBar = New("ScrollingFrame", {
		Size = UDim2.new(
			1,
			Window.ScrollBarEnabled and -3 - (Window.UIPadding / 2) or 0,
			1,
			-6 -- Reclaimed search bar space
		),
		Position = UDim2.new(0, 0, 1, 0),
		AnchorPoint = Vector2.new(0, 1),
		BackgroundTransparency = 1,
		ScrollBarThickness = 0,
		ElasticBehavior = "Never",
		CanvasSize = UDim2.new(0, 0, 0, 0),
		AutomaticCanvasSize = "Y",
		ScrollingDirection = "Y",
		ClipsDescendants = true,
		VerticalScrollBarPosition = "Left",
	}, {
		New("Frame", {
			BackgroundTransparency = 1,
			AutomaticSize = "Y",
			Size = UDim2.new(1, 0, 0, 0),
			Name = "Frame",
		}, {
			New("UIPadding", {
				--PaddingTop = UDim.new(0,Window.UIPadding/2),
				--PaddingLeft = UDim.new(0,4+(Window.UIPadding/2)),
				--PaddingRight = UDim.new(0,4+(Window.UIPadding/2)),
				PaddingBottom = UDim.new(0, Window.UIPadding / 2),
			}),
			New("TextLabel", { -- Sidebar Title
				Text = "MODULE CONTROL",
				TextSize = 10,
				FontFace = Font.new(Creator.Font, Enum.FontWeight.Bold),
				TextColor3 = Color3.fromHex("#FFD700"),
				TextTransparency = 0.4,
				BackgroundTransparency = 1,
				LayoutOrder = -1,
				Size = UDim2.new(1, 0, 0, 20),
				TextXAlignment = "Left",
			}),
			New("UIListLayout", {
				SortOrder = "LayoutOrder",
				Padding = UDim.new(0, Window.Gap),
			}),
		}),
		New("UIPadding", {
			--PaddingTop = UDim.new(0,4),
			PaddingLeft = UDim.new(0, Window.UIPadding / 2),
			PaddingRight = UDim.new(0, Window.UIPadding / 2),
			--PaddingBottom = UDim.new(0,Window.UIPadding),
		}),
		--TabHighlight
	})

	Window.UIElements.SideBarContainer = New("Frame", {
		Size = UDim2.new(
			0,
			Window.SideBarWidth,
			1,
			-Window.Topbar.Height
		),
		Position = UDim2.new(0, 0, 0, Window.Topbar.Height),
		BackgroundTransparency = 1,
		Visible = true,
	}, {
		New("Frame", {
			Name = "Content",
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0, 0, 1, 0),
			AnchorPoint = Vector2.new(0, 1),
		}),
		Window.UIElements.SideBar,
        New("Frame", { -- Sidebar Glow/Separator
            Size = UDim2.new(0, 1, 1, -20),
            Position = UDim2.new(1, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundColor3 = Color3.fromHex("#FFD700"),
            BackgroundTransparency = .92,
            BorderSizePixel = 0,
        })
	})

	if Window.ScrollBarEnabled then
		CreateScrollSlider(Window.UIElements.SideBar, Window.UIElements.SideBarContainer.Content, Window, 3)
	end

	Window.UIElements.MainBar = New("Frame", {
		Size = UDim2.new(1, -Window.SideBarWidth, 1, -Window.Topbar.Height),
		Position = UDim2.new(0, Window.SideBarWidth, 0, Window.Topbar.Height),
		BackgroundTransparency = 1,
	}, {
		Creator.NewRoundFrame(Window.UICorner - (Window.UIPadding / 2), "Squircle", {
			Size = UDim2.new(1, 0, 1, 0),
			ThemeTag = {
				ImageColor3 = "PanelBackground",
				ImageTransparency = "PanelBackgroundTransparency",
			},
			ZIndex = 3,
			Name = "Background",
			Visible = not Window.HidePanelBackground,
		}, {
            New("UIStroke", {
                Thickness = 1,
                Color = Color3.fromHex("#FFD700"),
                Transparency = .9,
            })
        }),
		New("UIPadding", {
			PaddingLeft = UDim.new(0, Window.UIPadding),
			PaddingRight = UDim.new(0, Window.UIPadding),
			PaddingBottom = UDim.new(0, Window.UIPadding),
            PaddingTop = UDim.new(0, Window.UIPadding),
		}),
	})

    -- Right Panel Helpers
    local function CreateMiniStat(Label, ValueName)
        return New("Frame", {
            Size = UDim2.new(0.3, 0, 1, 0),
            BackgroundColor3 = Color3.new(1,1,1),
            BackgroundTransparency = .97,
        }, {
            New("UICorner", { CornerRadius = UDim.new(0, 6) }),
            New("TextLabel", {
                Text = Label,
                TextSize = 9,
                TextColor3 = Color3.fromHex("#FFD700"),
                Position = UDim2.new(0.5, 0, 0.3, 0),
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundTransparency = 1,
            }),
            New("TextLabel", {
                Name = ValueName,
                Text = "...",
                TextSize = 12,
                TextColor3 = Color3.new(1,1,1),
                Position = UDim2.new(0.5, 0, 0.7, 0),
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundTransparency = 1,
                FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
            })
        })
    end

    -- Right Panel (Executive User Sidebar)
    local RightPanelContent = New("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
    }, {
        New("UIListLayout", {
            Padding = UDim.new(0, 20),
            HorizontalAlignment = "Center",
            VerticalAlignment = "Top", -- Top-aligned as requested
            SortOrder = "LayoutOrder",
        }),
        New("UIPadding", {
            PaddingLeft = UDim.new(0, 12),
            PaddingRight = UDim.new(0, 12),
            PaddingBottom = UDim.new(0, 12),
            PaddingTop = UDim.new(0, 12),
        }),

        -- 🟢 Executive User Header
        New("Frame", {
            Size = UDim2.new(1, 0, 0, 130),
            BackgroundTransparency = 1,
            LayoutOrder = 1,
        }, {
            New("UIListLayout", {
                Padding = UDim.new(0, 10),
                HorizontalAlignment = "Center",
            }),
            -- Avatar Frame
            New("Frame", {
                Size = UDim2.new(0, 85, 0, 85),
                BackgroundColor3 = Color3.fromHex("#1A1A1A"),
            }, {
                New("UICorner", { CornerRadius = UDim.new(0, 15) }),
                New("UIStroke", { Thickness = 2, Color = Color3.fromHex("#FFD700"), Transparency = .5 }),
                New("ImageLabel", {
                    Name = "Avatar",
                    Size = UDim2.new(1, -10, 1, -10),
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Image = GetUserThumb(false),
                    BackgroundTransparency = 1,
                }, {
                    New("UICorner", { CornerRadius = UDim.new(1, 0) })
                })
            }),
            New("Frame", {
                Name = "NamesContainer",
                Size = UDim2.new(1, 0, 0, 45),
                BackgroundTransparency = 1,
            }, {
                New("UIListLayout", { HorizontalAlignment = "Center", Padding = UDim.new(0, 2), VerticalAlignment = "Center" }),
                New("TextLabel", {
                    Text = Players.LocalPlayer.DisplayName,
                    TextSize = 14,
                    FontFace = Font.new(Creator.Font, Enum.FontWeight.Bold),
                    TextColor3 = Color3.new(1, 1, 1),
                    BackgroundTransparency = 1,
                    AutomaticSize = "XY",
                }),
                New("TextLabel", {
                    Text = "@" .. Players.LocalPlayer.Name,
                    TextSize = 12,
                    TextColor3 = Color3.new(1, 1, 1),
                    TextTransparency = .5,
                    BackgroundTransparency = 1,
                    AutomaticSize = "XY",
                })
            })
        }),

        -- 🟢 Separator
        New("Frame", {
            Size = UDim2.new(0.9, 0, 0, 1),
            BackgroundColor3 = Color3.fromHex("#FFD700"),
            BackgroundTransparency = 0.8,
            LayoutOrder = 2,
        }),

        -- 🟢 Game Statistics
        New("Frame", {
            Size = UDim2.new(1, 0, 0, 80),
            BackgroundTransparency = 1,
            LayoutOrder = 3,
        }, {
            New("UIListLayout", { Padding = UDim.new(0, 8), HorizontalAlignment = "Center" }),
            New("TextLabel", {
                Text = "GAME INFORMATION",
                TextSize = 10,
                FontFace = Font.new(Creator.Font, Enum.FontWeight.Bold),
                TextColor3 = Color3.fromHex("#FFD700"),
                TextTransparency = .4,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 20),
            }),
            
            -- Game Name Display
            New("Frame", {
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = Color3.new(1,1,1),
                BackgroundTransparency = .95,
                AutomaticSize = "Y", -- Allow expanding for long names
            }, {
                New("UICorner", { CornerRadius = UDim.new(0, 8) }),
                New("UIStroke", { Thickness = 1.5, Color = Color3.fromHex("#FFD700"), Transparency = .8 }),
                New("UIPadding", { PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), PaddingTop = UDim.new(0, 5), PaddingBottom = UDim.new(0, 5) }),
                New("TextLabel", {
                    Name = "GameName",
                    Text = "Loading...",
                    TextSize = 12,
                    TextColor3 = Color3.new(1,1,1),
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = "Y",
                    BackgroundTransparency = 1,
                    TextWrapped = true,
                })
            })
        }),

         -- 🟢 Executor Status (Consolidated)
        New("Frame", {
            Size = UDim2.new(1, 0, 0, 50),
            BackgroundColor3 = Color3.fromHex("#FFD700"),
            BackgroundTransparency = .92,
            LayoutOrder = 4,
        }, {
            New("UICorner", { CornerRadius = UDim.new(0, 10) }),
            New("UIStroke", { Thickness = 1.5, Color = Color3.fromHex("#FFD700"), Transparency = .6 }),
            New("ImageLabel", {
                Size = UDim2.new(0, 22, 0, 22),
                Position = UDim2.new(0, 12, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                Image = Creator.Icon("zap")[1],
                ImageRectOffset = Creator.Icon("zap")[2].ImageRectPosition,
                ImageRectSize = Creator.Icon("zap")[2].ImageRectSize,
                ThemeTag = { ImageColor3 = "Accent" },
            }),
            New("Frame", {
                Size = UDim2.new(1, -20, 0, 45),
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 2),
            }, {
                New("UIListLayout", {
                    FillDirection = "Horizontal",
                    Padding = UDim.new(0, 10),
                    VerticalAlignment = "Center",
                }),
                New("ImageLabel", {
                    Name = "Avatar",
                    Size = UDim2.new(0, 32, 0, 32),
                    BackgroundTransparency = 1,
                    Image = "rbxthumb://type=AvatarHeadShot&id=" .. (Players.LocalPlayer and Players.LocalPlayer.UserId or 0) .. "&w=150&h=150",
                }, { New("UICorner", { CornerRadius = UDim.new(1, 0) }) }),
                New("Frame", {
                    Size = UDim2.new(1, -42, 1, 0),
                    BackgroundTransparency = 1,
                }, {
                    New("UIListLayout", { VerticalAlignment = "Center", Padding = UDim.new(0, 2) }),
                    New("TextLabel", {
                        Text = "@" .. (Players.LocalPlayer and Players.LocalPlayer.Name or "Guest"),
                        TextSize = 11,
                        TextColor3 = Color3.fromHex("#FFC300"),
                        ThemeTag = { TextColor3 = "Accent" },
                        TextTransparency = 0.5,
                        AutomaticSize = "XY",
                        BackgroundTransparency = 1,
                    }),
                    New("TextLabel", {
                        Text = (typeof(identifyexecutor) == "function" and identifyexecutor() or "Xeno"),
                        TextSize = 13,
                        TextColor3 = Color3.new(1, 1, 1),
                        FontFace = Font.new(Creator.Font, Enum.FontWeight.Bold),
                        AutomaticSize = "XY",
                        BackgroundTransparency = 1,
                    })
                })
            })
        })
    })

    Window.UIElements.RightPanel = New("Frame", {
        Size = UDim2.new(0, 230, 0, 0),
        AutomaticSize = "Y",
        Position = UDim2.new(1, 15, 0, 0),
        BackgroundTransparency = 1,
        Visible = true,
        ZIndex = 0, -- Slide behind main window
    }, {
        New("CanvasGroup", {
            Size = UDim2.new(1, 0, 1, 0),
            AutomaticSize = "Y",
            BackgroundTransparency = 1,
            Name = "Group"
        }, {
            Creator.NewRoundFrame(Window.UICorner - (Window.UIPadding / 2), "Squircle", {
                Name = "Squircle",
                Size = UDim2.new(1, 0, 1, 0),
                ThemeTag = {
                    ImageColor3 = "Background",
                    ImageTransparency = "BackgroundTransparency",
                },
                ZIndex = 3,
            }, {
                New("UIStroke", {
                    Thickness = 2,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    Color = Color3.fromHex("#FFD700"),
                }, {
                    New("UIGradient", {
                        Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0, Color3.fromHex("#FFD700")),
                            ColorSequenceKeypoint.new(0.5, Color3.fromHex("#4D4300")),
                            ColorSequenceKeypoint.new(1, Color3.fromHex("#FFD700")),
                        }),
                        Rotation = 0,
                        Name = "GlowTrail"
                    })
                })
            }),
            RightPanelContent
        })
    })

    -- Animate Glow Trail
    task.spawn(function()
        while task.wait(0.02) do
            if Window.Destroyed or not Window.UIElements.RightPanel then break end
            local Group = Window.UIElements.RightPanel:FindFirstChild("Group")
            local Squircle = Group and Group:FindFirstChild("Squircle")
            local Stroke = Squircle and Squircle:FindFirstChildOfClass("UIStroke")
            local Gradient = Stroke and Stroke:FindFirstChild("GlowTrail")
            
            if Gradient then
                Gradient.Rotation = (Gradient.Rotation + 2) % 360
            else
                break -- Exit if elements are missing
            end
        end
    end)

    function Window:ToggleRightPanel()
        local Panel = Window.UIElements.RightPanel
        local Button = Window.TopBarButtons["SidebarToggle"]
        local Visible = not Panel.Visible
        
        if Visible then
            Panel.Visible = true
            if Button then 
                Tween(Button.Icon, 0.3, { Rotation = 0 }):Play()
                Button.Icon.Image = Creator.Icon("chevron-left")[1]
            end
            Tween(Panel, 0.5, { Position = UDim2.new(1, 15, 0, 0) }, Enum.EasingStyle.Back, Enum.EasingDirection.Out):Play()
        else
            if Button then 
                Tween(Button.Icon, 0.3, { Rotation = 180 }):Play()
                Button.Icon.Image = Creator.Icon("chevron-right")[1]
            end
            local tween = Tween(Panel, 0.4, { Position = UDim2.new(1, -210, 0, 0) }, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
            tween.Completed:Connect(function()
                if not Visible then Panel.Visible = false end
            end)
            tween:Play()
        end
    end

    -- Breadcrumbs / Content Header Removed

	local Blur = New("ImageLabel", { -- Shadow
		Image = "rbxassetid://8992230677",
		ThemeTag = {
			ImageColor3 = "WindowShadow",
			--ImageTransparency = "WindowShadowTransparency",
		},
		ImageTransparency = 1, -- .7
		Size = UDim2.new(1, 100, 1, 100),
		Position = UDim2.new(0, -100 / 2, 0, -100 / 2),
		ScaleType = "Slice",
		SliceCenter = Rect.new(99, 99, 99, 99),
		BackgroundTransparency = 1,
		ZIndex = -999999999999999,
		Name = "Blur",
	})

	if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
		Window.IsPC = false
	elseif UserInputService.KeyboardEnabled then
		Window.IsPC = true
	else
		Window.IsPC = nil
	end

	--Window.IsPC = true

	-- local OpenButtonContainer = nil
	-- local OpenButton = nil
	-- local OpenButtonIcon = nil

		-- UserIcon logic removed for Noble Deluxe (clean sidebar)

	local Outline1
	local Outline2

	local IsVideoBG = false
	local BGImage = nil

	local BGVideo = typeof(Window.Background) == "string" and string.match(Window.Background, "^video:(.+)") or nil
	local BGImageUrl = typeof(Window.Background) == "string"
			and not BGVideo
			and string.match(Window.Background, "^https?://.+")
		or nil

	local function GetImageExtension(url)
		local ext = url:match("%.(%w+)$") or url:match("%.(%w+)%?")
		if ext then
			ext = ext:lower()
			if ext == "jpg" or ext == "jpeg" or ext == "png" or ext == "webp" then
				return "." .. ext
			end
		end
		return ".png"
	end

	if typeof(Window.Background) == "string" and BGVideo then
		IsVideoBG = true

		if string.find(BGVideo, "http") then
			local videoPath = Window.Folder .. "/assets/." .. Creator.SanitizeFilename(BGVideo) .. ".webm"
			if not isfile(videoPath) then
				local success, result = pcall(function()
					-- local response = Creator.Request({
					-- 	Url = BGVideo,
					-- 	Method = "GET",
					-- 	Headers = { ["User-Agent"] = "Roblox/Exploit" },
					-- })
					local response = game.HttpGet and game:HttpGet(BGVideo)
					pcall(function()
						writefile(videoPath, response.Body)
					end)
				end)
				if not success then
					warn("[ IntiHub.Window.Background ] Failed to download video: " .. tostring(result))
					return
				end
			end

			local success, customAsset = pcall(function()
				return getcustomasset(videoPath)
			end)
			if not success then
				warn("[ IntiHub.Window.Background ] Failed to load custom asset: " .. tostring(customAsset))
				return
			end
			warn("[ IntiHub.Window.Background ] VideoFrame may not work with custom video")
			BGVideo = customAsset
		end

		BGImage = New("VideoFrame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			Video = BGVideo,
			Looped = true,
			Volume = 0,
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, Window.UICorner),
			}),
		})
		BGImage:Play()
	elseif BGImageUrl then
		local imagePath = Window.Folder
			.. "/assets/."
			.. Creator.SanitizeFilename(BGImageUrl)
			.. GetImageExtension(BGImageUrl)
		if isfile and not isfile(imagePath) then
			local success, result = pcall(function()
				-- local response = Creator.Request({
				-- 	Url = BGImageUrl,
				-- 	Method = "GET",
				-- 	Headers = { ["User-Agent"] = "Roblox/Exploit" },
				-- })
				local response = game.HttpGet and game:HttpGet(BGImageUrl)
				pcall(function()
					writefile(imagePath, response.Body)
				end)
			end)
			if not success then
				warn("[ Window.Background ] Failed to download image: " .. tostring(result))
				return
			end
		end

		local success, customAsset = pcall(function()
			local assetSuccess, assetResult = pcall(function()
				return getcustomasset(imagePath)
			end)
			if assetSuccess then
				return assetResult
			end
			return Window.Background
		end)
		if not success then
			warn("[ Window.Background ] Failed to load custom asset: " .. tostring(customAsset))
			return
		end

		BGImage = New("ImageLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			Image = customAsset,
			ImageTransparency = 0,
			ScaleType = "Crop",
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, Window.UICorner),
			}),
		})
	elseif Window.Background then
		BGImage = New("ImageLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			Image = typeof(Window.Background) == "string" and Window.Background or "",
			ImageTransparency = 1,
			ScaleType = "Crop",
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, Window.UICorner),
			}),
		})
	end

	local BottomDragFrame = Creator.NewRoundFrame(99, "Squircle", {
		ImageTransparency = 0.8,
		ImageColor3 = Color3.new(1, 1, 1),
		Size = UDim2.new(0, 0, 0, 4), -- 200
		Position = UDim2.new(0.5, 0, 1, 4),
		AnchorPoint = Vector2.new(0.5, 0),
	}, {
		New("TextButton", {
			Size = UDim2.new(1, 12, 1, 12),
			BackgroundTransparency = 1,
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Active = true,
			ZIndex = 99,
			Name = "Frame",
		}),
	})

	function createAuthor(text)
		return New("TextLabel", {
			Text = text,
			FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
			BackgroundTransparency = 1,
			TextTransparency = 0.35,
			AutomaticSize = "XY",
			Parent = Window.UIElements.Main and Window.UIElements.Main.Main.Topbar.Left.Title,
			TextXAlignment = "Left",
			TextSize = 13,
			LayoutOrder = 2,
			ThemeTag = {
				TextColor3 = "WindowTopbarAuthor",
			},
			Name = "Author",
		})
	end

	local WindowAuthor
	local WindowIcon

	if Window.Author then
		WindowAuthor = createAuthor(Window.Author)
	end

	local WindowTitle = New("TextLabel", {
		Text = Window.Title,
		FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
		BackgroundTransparency = 1,
		AutomaticSize = "XY",
		Name = "Title",
		TextXAlignment = "Left",
		TextSize = 16,
		ThemeTag = {
			TextColor3 = "WindowTopbarTitle",
		},
	})

	Window.UIElements.Main = New("Frame", {
		Size = Window.Size,
		Position = Window.Position,
		BackgroundTransparency = 1,
		Parent = Config.Parent,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Active = true,
	}, {
		Config.IntiHub.UIScaleObj,
		Window.AcrylicPaint and Window.AcrylicPaint.Frame or nil,
		Blur,
		Creator.NewRoundFrame(Window.UICorner, "Squircle", {
			ImageTransparency = 1, -- Window.Transparent and 0.25 or 0
			Size = UDim2.new(1, 0, 1, -240),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Name = "Background",
			ThemeTag = {
				ImageColor3 = "WindowBackground",
				ImageTransparency = "WindowBackgroundTransparency",
			},
			--ZIndex = -9999,
		}, {
			BGImage,
			BottomDragFrame,
			ResizeHandle,
			-- New("UIScale", {
			--     Scale = 0.95,
			-- }),
		}),
		New("UIStroke", {
			Thickness = 2,
			ApplyStrokeMode = "Border",
			ThemeTag = {
				Color = "Accent",
			},
		}, {
			New("UIGradient", {
				Name = "AnimatedGradient1",
				Rotation = 0,
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0.0, Color3.fromHex("#FFC300")), -- Inti Gold
					ColorSequenceKeypoint.new(0.5, Color3.fromHex("#000000")), -- Black
					ColorSequenceKeypoint.new(1.0, Color3.fromHex("#FFC300")), -- Inti Gold
				}),
			})
		}),
		New("Frame", {
			Name = "AnimationOverlay",
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, Window.UICorner),
			}),
			New("UIStroke", {
				Thickness = 3,
				ApplyStrokeMode = "Border",
				Transparency = 0.5,
				ThemeTag = {
					Color = "Accent",
				},
			}, {
				New("UIGradient", {
					Name = "AnimatedGradient2",
					Rotation = 0,
					Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0.0, Color3.fromHex("#000000")), -- Black
						ColorSequenceKeypoint.new(0.5, Color3.fromHex("#FFC300")), -- Inti Gold
						ColorSequenceKeypoint.new(1.0, Color3.fromHex("#000000")), -- Black
					}),
				})
			})
		}),
		UICorner,
		FullScreenIcon,
		FullScreenBlur,
		New("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Name = "Main",
			--GroupTransparency = 1,
			Visible = false,
			ZIndex = 97,
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, Window.UICorner),
			}),
			Window.UIElements.SideBarContainer,
			Window.UIElements.MainBar,
            Window.UIElements.RightPanel,

			-- UserIcon removed from Main.Main

			Outline2,
			New("Frame", { -- Topbar
				Size = UDim2.new(1, 0, 0, Window.Topbar.Height),
				BackgroundTransparency = 1,
				BackgroundColor3 = Color3.fromRGB(50, 50, 50),
				Name = "Topbar",
			}, {
				Outline1,
				--[[New("Frame", { -- Outline
                    Size = UDim2.new(1,Window.UIPadding*2, 0, 1),
                    Position = UDim2.new(0,-Window.UIPadding, 1,Window.UIPadding-2),
                    BackgroundTransparency = 0.9,
                    BackgroundColor3 = Color3.fromHex(Config.Theme.Outline),
                }),]]
				New("Frame", { -- Topbar Left Side
					AutomaticSize = "X",
					Size = UDim2.new(0, 0, 1, 0),
					BackgroundTransparency = 1,
					Name = "Left",
				}, {
					New("UIListLayout", {
						Padding = UDim.new(0, Window.UIPadding + 4),
						SortOrder = "LayoutOrder",
						FillDirection = "Horizontal",
						VerticalAlignment = "Center",
					}),
					New("Frame", { -- Logo Container
                        AutomaticSize = "XY",
                        BackgroundTransparency = 1,
                        LayoutOrder = 1,
                    }, {
                        New("UIListLayout", {
                            Padding = UDim.new(0, 8),
                            FillDirection = "Horizontal",
                            VerticalAlignment = "Center",
                        }),
                        -- Logo
                        New("TextLabel", {
                            Text = "<font color='#FFD700'><b>INTIHUB</b></font>",
                            TextSize = 16,
                            FontFace = Font.new(Creator.Font, Enum.FontWeight.Bold),
                            TextColor3 = Color3.fromHex("#FFD700"),
                            BackgroundTransparency = 1,
                            AutomaticSize = "XY",
                            LayoutOrder = 1,
                            RichText = true,
                            Name = "BrandingLogo",
                        }),
                        -- Separator
                        New("Frame", {
                            Size = UDim2.new(0, 1, 0, 20),
                            BackgroundColor3 = Color3.new(1, 1, 1),
                            BackgroundTransparency = .8,
                            BorderSizePixel = 0,
                            LayoutOrder = 2,
                        }),
                    }),
					New("Frame", {
						AutomaticSize = "XY",
						BackgroundTransparency = 1,
						Name = "Title",
						Size = UDim2.new(0, 0, 1, 0),
						LayoutOrder = 2,
					}, {
						New("UIListLayout", {
							Padding = UDim.new(0, 0),
							SortOrder = "LayoutOrder",
							FillDirection = "Vertical",
							VerticalAlignment = "Center",
						}),
						WindowTitle,
						WindowAuthor,
					}),
					New("UIPadding", {
						PaddingLeft = UDim.new(0, 12),
					}),
				}),
				New("ScrollingFrame", { -- Topbar Center Size
					Name = "Center",
					BackgroundTransparency = 1,
					AutomaticSize = "Y",
					ScrollBarThickness = 0,
					ScrollingDirection = "X",
					AutomaticCanvasSize = "X",
					CanvasSize = UDim2.new(0, 0, 0, 0),
					Size = UDim2.new(0, 0, 1, 0),
					AnchorPoint = Vector2.new(0, 0.5),
					Position = UDim2.new(0, 0, 0.5, 0),
					Visible = false,
				}, {
					New("UIListLayout", {
						FillDirection = "Horizontal",
						VerticalAlignment = "Center",
						HorizontalAlignment = "Left", -- Balanced left-center
						Padding = UDim.new(0, 15),
					}),
				}),
				New("Frame", { -- Topbar Right Side -- Window.UIElements.Main.Main.Topbar.Right
					AutomaticSize = "XY",
					BackgroundTransparency = 1,
					Position = UDim2.new(1, 0, 0.5, 0),
					AnchorPoint = Vector2.new(1, 0.5),
					Name = "Right",
				}, {
					New("UIListLayout", {
						Padding = UDim.new(0, Window.Topbar.ButtonsType == "Default" and 9 or 0),
						FillDirection = "Horizontal",
						SortOrder = "LayoutOrder",
					}),
				}),
				New("UIPadding", {
					PaddingTop = UDim.new(0, Window.UIPadding),
					PaddingLeft = UDim.new(
						0,
						Window.Topbar.ButtonsType == "Default" and Window.UIPadding or Window.UIPadding - 2
					),
					PaddingRight = UDim.new(0, 8),
					PaddingBottom = UDim.new(0, Window.UIPadding),
				}),
			}),
		}),
	})


	Creator.AddSignal(Window.UIElements.Main.Main.Topbar.Left:GetPropertyChangedSignal("AbsoluteSize"), function()
		local IntiScale = (Config.IntiHub and Config.IntiHub.UIScale) or 1
		local LeftWidth = Window.UIElements.Main.Main.Topbar.Left.AbsoluteSize.X / IntiScale
		local RightWidth = Window.UIElements.Main.Main.Topbar.Right.UIListLayout.AbsoluteContentSize.X / IntiScale

		Window.UIElements.Main.Main.Topbar.Center.Position = UDim2.new(0, LeftWidth + (Window.UIPadding / IntiScale), 0.5, 0)
		Window.UIElements.Main.Main.Topbar.Center.Size = UDim2.new(1, -LeftWidth - RightWidth - ((Window.UIPadding * 2) / IntiScale), 1, 0)
	end)

    Window.UIElements.RightPanel.Parent = Window.UIElements.Main -- Parented to root Main for grouped movement
    Window.UIElements.TabScrollAdjustment = 5

	-- Parent Right logic is now fixed to Right container

	function Window:CreateTopbarButton(Name, Icon, Callback, LayoutOrder, IconThemed, Color, IconSize)
		local IconFrame = Creator.Image(
			Icon,
			Icon,
			0,
			Window.Folder,
			"WindowTopbarIcon",
			Window.Topbar.ButtonsType == "Default" and true or false,
			IconThemed,
			"WindowTopbarButtonIcon"
		)
		IconFrame.Size = Window.Topbar.ButtonsType == "Default"
				and UDim2.new(0, IconSize or Window.TopBarButtonIconSize, 0, IconSize or Window.TopBarButtonIconSize)
			or UDim2.new(0, 0, 0, 0)
		IconFrame.AnchorPoint = Vector2.new(0.5, 0.5)
		IconFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
		IconFrame.ImageLabel.ImageTransparency = Window.Topbar.ButtonsType == "Default" and 0 or 1

		if Window.Topbar.ButtonsType ~= "Default" then
			IconFrame.ImageLabel.ImageColor3 = Creator.GetTextColorForHSB(Color)
		end

		local Button = Creator.NewRoundFrame(
			Window.Topbar.ButtonsType == "Default" and Window.UICorner - (Window.UIPadding / 2) or 999,
			"Squircle",
			{
				Size = Window.Topbar.ButtonsType == "Default"
						and UDim2.new(0, Window.Topbar.Height - 16, 0, Window.Topbar.Height - 16)
					or UDim2.new(0, 14, 0, 14),
				LayoutOrder = LayoutOrder or 999,
				--Parent = Window.Topbar.ButtonsType == "Default" and Window.UIElements.Main.Main.Topbar.Right or nil,
				--Active = true,
				ZIndex = 9999,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				ImageColor3 = Window.Topbar.ButtonsType ~= "Default" and (Color or Color3.fromHex("#ff3030")) or nil,
				ThemeTag = Window.Topbar.ButtonsType == "Default" and {
					ImageColor3 = "Text",
				} or nil,
				ImageTransparency = Window.Topbar.ButtonsType == "Default" and 1 or 0, -- .93
			},
			{
				Creator.NewRoundFrame(
					Window.Topbar.ButtonsType == "Default" and Window.UICorner - (Window.UIPadding / 2) or 999,
					"Glass-1",
					{
						Size = UDim2.new(1, 0, 1, 0),
						ThemeTag = {
							ImageColor3 = "Outline",
						},
						ImageTransparency = Window.Topbar.ButtonsType == "Default" and 1 or 0.5, -- .75
						Name = "Outline",
					}
				),
				IconFrame,
				New("UIScale", {
					Scale = 1,
				}),
			},
			true
		)

		local ButtonContainer = New("Frame", {
			Size = Window.Topbar.ButtonsType ~= "Default" and UDim2.new(0, 24, 0, 24)
				or UDim2.new(0, Window.Topbar.Height - 16, 0, Window.Topbar.Height - 16),
			BackgroundTransparency = 1,
			Parent = Window.UIElements.Main.Main.Topbar.Right,
			LayoutOrder = LayoutOrder or 999,
		}, {
			Button,
		})

		-- shhh

		Window.TopBarButtons[100 - LayoutOrder] = {
			Name = Name,
			Object = Button,
		}

		Creator.AddSignal(Button.MouseButton1Click, function()
			if Callback then
				Callback()
			end
		end)
		Creator.AddSignal(Button.MouseEnter, function()
			if Window.Topbar.ButtonsType == "Default" then
				Tween(Button, 0.15, { ImageTransparency = 0.93 }):Play()
				Tween(Button.Outline, 0.15, { ImageTransparency = 0.75 }):Play()
				--Tween(IconFrame.ImageLabel, .15, {ImageTransparency = 0}):Play()
			else
				--Tween(Button, .1, {Size = UDim2.new(0,14+8,0,14+8)}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
				Tween(
					IconFrame.ImageLabel,
					0.1,
					{ ImageTransparency = 0 },
					Enum.EasingStyle.Quint,
					Enum.EasingDirection.Out
				):Play()
				Tween(IconFrame, 0.1, {
					Size = UDim2.new(
						0,
						IconSize or Window.TopBarButtonIconSize,
						0,
						IconSize or Window.TopBarButtonIconSize
					),
				}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
			end
		end)

		Creator.AddSignal(Button.MouseButton1Down, function()
			Tween(Button.UIScale, 0.2, { Scale = 0.9 }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
		end)

		Creator.AddSignal(Button.MouseLeave, function()
			if Window.Topbar.ButtonsType == "Default" then
				Tween(Button, 0.1, { ImageTransparency = 1 }):Play()
				Tween(Button.Outline, 0.1, { ImageTransparency = 1 }):Play()
				--Tween(IconFrame.ImageLabel, .1, {ImageTransparency = .2}):Play()
			else
				--Tween(Button, .1, {Size = UDim2.new(0,14,0,14)}, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut):Play()
				Tween(
					IconFrame.ImageLabel,
					0.1,
					{ ImageTransparency = 1 },
					Enum.EasingStyle.Quint,
					Enum.EasingDirection.Out
				):Play()
				Tween(
					IconFrame,
					0.1,
					{ Size = UDim2.new(0, 0, 0, 0) },
					Enum.EasingStyle.Quint,
					Enum.EasingDirection.Out
				):Play()
			end
		end)

		Creator.AddSignal(Button.InputEnded, function()
			Tween(Button.UIScale, 0.2, { Scale = 1 }, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut):Play()
		end)

		return Button
	end

	function Window.Topbar:Button(ButtonConfig: {
		Name: string,
		Icon: string,
		Callback: any,
		LayoutOrder: number,
		IconThemed: boolean,
		Color: Color3,
		IconSize: number,
	})
		return Window:CreateTopbarButton(
			ButtonConfig.Name,
			ButtonConfig.Icon,
			ButtonConfig.Callback,
			ButtonConfig.LayoutOrder or 0,
			ButtonConfig.IconThemed,
			ButtonConfig.Color,
			ButtonConfig.IconSize
		)
	end

	-- local Dragged = false

	Window:CreateTopbarButton("SidebarToggle", "layout-panel-right", function()
		Window:ToggleRightPanel()
	end, 1000, true, Color3.fromHex("#FFD700"))

    Window:CreateTopbarButton("SearchToggle", "search", function()
        if Window.Search then
            Window.Search:Toggle()
        end
    end, 999, true, Color3.fromHex("#FFD700"))

	local WindowDragModule = Creator.Drag(
		Window.UIElements.Main,
		{ Window.UIElements.Main.Main.Topbar, BottomDragFrame.Frame },
		function(dragging, frame) -- On drag
			if not Window.Closed then
				if dragging and frame == BottomDragFrame.Frame then
					Tween(BottomDragFrame, 0.1, { ImageTransparency = 0.35 }):Play()
				else
					Tween(BottomDragFrame, 0.2, { ImageTransparency = 0.8 }):Play()
				end
				Window.Position = Window.UIElements.Main.Position
				Window.Dragging = dragging
			end
		end
	)

	if not IsVideoBG and Window.Background and typeof(Window.Background) == "table" then
		local BackgroundGradient = New("UIGradient")
		for key, value in next, Window.Background do
			BackgroundGradient[key] = value
		end

		Window.UIElements.BackgroundGradient = Creator.NewRoundFrame(Window.UICorner, "Squircle", {
			Size = UDim2.new(1, 0, 1, 0),
			Parent = Window.UIElements.Main.Background,
			ImageTransparency = Window.Transparent and Config.IntiHub.TransparencyValue or 0,
		}, {
			BackgroundGradient,
		})
	end

	-- local blur = require("../Blur")

	-- blur.new(Window.UIElements.Main.Background, {
	--     Corner = Window.UICorner
	-- })

	--Creator.Blur(Window.UIElements.Main.Background)
	-- local OpenButtonDragModule
		-- local OpenButtonDragModule

	-- if not Window.IsPC then
	--     OpenButtonDragModule = Creator.Drag(OpenButtonContainer)
	-- end

	Window.OpenButtonMain = require("./Openbutton").New(Window)

	Window.OpenButtonMain:SetIcon(Window.Icon)

	function Window:SetToggleKey(keycode)
		Window.ToggleKey = keycode
	end

	function Window:SetTitle(text)
		Window.Title = text
		WindowTitle.Text = text
	end

	function Window:SetAuthor(v)
		Window.Author = v
		Window.UIElements.Main.Main.Topbar.Left.Author.Text = v
		return Window
	end

	function Window:SetSize(size)
		if typeof(size) == "UDim2" then
			Window.Size = size

			Tween(Window.UIElements.Main, 0.08, { Size = size }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
		end
	end

	function Window:SetBackgroundImage(id)
		Window.UIElements.Main.Background.ImageLabel.Image = id
	end
	function Window:SetBackgroundImageTransparency(v)
		if BGImage and BGImage:IsA("ImageLabel") then
			BGImage.ImageTransparency = math.floor(v * 10 + 0.5) / 10
		end
		Window.BackgroundImageTransparency = math.floor(v * 10 + 0.5) / 10
	end

	function Window:SetBackgroundTransparency(v)
		local rounded = math.floor(tonumber(v) * 10 + 0.5) / 10
		Config.IntiHub.TransparencyValue = rounded
		Window:ToggleTransparency(rounded > 0)
	end

	local CurrentPos
	local CurrentSize
	local iconCopy = Creator.Icon("minimize")
	local iconSquare = Creator.Icon("maximize")

	local FullscreenButton = Window:CreateTopbarButton(
		"Fullscreen",
		Window.Topbar.ButtonsType == "Mac" and "rbxassetid://127426072704909" or "maximize",
		function()
			Window:ToggleFullscreen()
		end,
		(Window.Topbar.ButtonsType == "Default" and 998 or 999),
		true,
		Color3.fromHex("#60C762"),
		Window.Topbar.ButtonsType == "Mac" and 9 or nil
	)

	function Window:ToggleFullscreen()
		local isFullscreen = Window.IsFullscreen
		-- Creator.SetDraggable(isFullscreen)
		WindowDragModule:Set(isFullscreen)

		if not isFullscreen then
			CurrentPos = Window.UIElements.Main.Position
			CurrentSize = Window.UIElements.Main.Size

			Window.CanResize = false
		else
			if Window.Resizable then
				Window.CanResize = true
			end
		end

		Tween(
			Window.UIElements.Main,
			0.45,
			{ Size = isFullscreen and CurrentSize or UDim2.new(1, -20, 1, -20 - 52) },
			Enum.EasingStyle.Quint,
			Enum.EasingDirection.Out
		):Play()

		Tween(
			Window.UIElements.Main,
			0.45,
			{ Position = isFullscreen and CurrentPos or UDim2.new(0.5, 0, 0.5, 52 / 2) },
			Enum.EasingStyle.Quint,
			Enum.EasingDirection.Out
		):Play()
		-- delay(0, function()
		-- end)

		Window.IsFullscreen = not isFullscreen
	end

	Window:CreateTopbarButton("Minimize", "minus", function()
		Window:Close()
		-- task.spawn(function()
		--     task.wait(.3)
		--     if not Window.IsPC and Window.IsOpenButtonEnabled then
		--         -- OpenButtonContainer.Visible = true
		--         --Window.OpenButtonMain:Visible(true)
		--     end
		-- end)

		-- local NotifiedText = Window.IsPC and "Press " .. Window.ToggleKey.Name .. " to open the Window" or "Click the Button to open the Window"

		-- if not Window.IsOpenButtonEnabled then
		--     Notified = true
		-- end
		-- if not Notified then
		--     Notified = not Notified
		--     Config.IntiHub:Notify({
		--         Title = "Minimize",
		--         Content = "You've closed the Window. " .. NotifiedText,
		--         Icon = "eye-off",
		--         Duration = 5,
		--     })
		-- end
	end, (Window.Topbar.ButtonsType == "Default" and 997 or 998), nil, Color3.fromHex("#F4C948"))

	function Window:OnOpen(func)
		Window.OnOpenCallback = func
	end
	function Window:OnClose(func)
		Window.OnCloseCallback = func
	end
	function Window:OnDestroy(func)
		Window.OnDestroyCallback = func
	end

    -- 🟢 Initialize Search & Minimized Bar
    Window.MinimizedBar = MinimizedBar.New(Window)
    if not Window.HideSearchBar then
        Window.Search = Search.Init(Window)
    end

	if Config.IntiHub.UseAcrylic then
		Window.AcrylicPaint.AddParent(Window.UIElements.Main)
	end

	function Window:SetIconSize(Size)
		local NewSize
		if typeof(Size) == "number" then
			NewSize = UDim2.new(0, Size, 0, Size)
			Window.IconSize = Size
		elseif typeof(Size) == "UDim2" then
			NewSize = Size
			Window.IconSize = Size.X.Offset
		end

		if WindowIcon then
			WindowIcon.Size = NewSize
		end
	end

	function Window:Open()
        Window.UIElements.Main.Visible = true
        if Window.MinimizedBar then Window.MinimizedBar:Visible(false) end
		task.spawn(function()
			if Window.OnOpenCallback then
				task.spawn(function()
					Creator.SafeCallback(Window.OnOpenCallback)
				end)
			end

			task.wait(0.06)
			Window.Closed = false

			Tween(Window.UIElements.Main.Background, 0.2, {
				ImageTransparency = Window.Transparent and Config.IntiHub.TransparencyValue or 0,
			}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()

			if Window.UIElements.BackgroundGradient then
				Tween(Window.UIElements.BackgroundGradient, 0.2, {
					ImageTransparency = 0,
				}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
			end

			Tween(Window.UIElements.Main.Background, 0.4, {
				Size = UDim2.new(1, 0, 1, 0),
			}, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out):Play()

			if BGImage then
				if BGImage:IsA("VideoFrame") then
					BGImage.Visible = true
				else
					Tween(BGImage, 0.2, {
						ImageTransparency = Window.BackgroundImageTransparency,
					}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
				end
			end

			if Window.OpenButtonMain and Window.IsOpenButtonEnabled then
				Window.OpenButtonMain:Visible(false)
			end

			--Tween(Window.UIElements.Main.Background.UIScale, 0.2, {Scale = 1}, Enum.EasingStyle.Back, Enum.EasingDirection.Out):Play()
			Tween(
				Blur,
				0.25,
				{ ImageTransparency = Window.ShadowTransparency },
				Enum.EasingStyle.Quint,
				Enum.EasingDirection.Out
			):Play()
			if UIStroke then
				Tween(UIStroke, 0.25, { Transparency = 0.8 }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
			end

			task.spawn(function()
				task.wait(0.3)
				Tween(
					BottomDragFrame,
					0.45,
					{ Size = UDim2.new(0, Window.DragFrameSize, 0, 4), ImageTransparency = 0.8 },
					Enum.EasingStyle.Exponential,
					Enum.EasingDirection.Out
				):Play()
				WindowDragModule:Set(true)
				task.wait(0.45)
				if Window.Resizable then
					Tween(
						ResizeHandle.ImageLabel,
						0.45,
						{ ImageTransparency = 0.8 },
						Enum.EasingStyle.Exponential,
						Enum.EasingDirection.Out
					):Play()
					Window.CanResize = true
				end
			end)

			Window.CanDropdown = true
            Window.UIElements.Main:WaitForChild("Main").Visible = true
            Config.IntiHub:ToggleAcrylic(true)
		end)
	end
	function Window:Close()
		local Close = {}

		if Window.OnCloseCallback then
			task.spawn(function()
				Creator.SafeCallback(Window.OnCloseCallback)
			end)
		end

		Config.IntiHub:ToggleAcrylic(false)

		Window.UIElements.Main:WaitForChild("Main").Visible = false

		Window.CanDropdown = false
		Window.Closed = true

		Tween(Window.UIElements.Main.Background, 0.32, {
			ImageTransparency = 1,
		}, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut):Play()
		if Window.UIElements.BackgroundGradient then
			Tween(Window.UIElements.BackgroundGradient, 0.32, {
				ImageTransparency = 1,
			}, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut):Play()
		end

		Tween(Window.UIElements.Main.Background, 0.4, {
			Size = UDim2.new(1, 0, 1, -240),
		}, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut):Play()

		--Tween(Window.UIElements.Main.Background.UIScale, 0.19, {Scale = .95}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
		if BGImage then
			if BGImage:IsA("VideoFrame") then
				BGImage.Visible = false
			else
				Tween(BGImage, 0.3, {
					ImageTransparency = 1,
				}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
			end
		end
		Tween(Blur, 0.25, { ImageTransparency = 1 }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
		if UIStroke then
			Tween(UIStroke, 0.25, { Transparency = 1 }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
		end

		Tween(
			BottomDragFrame,
			0.3,
			{ Size = UDim2.new(0, 0, 0, 4), ImageTransparency = 1 },
			Enum.EasingStyle.Exponential,
			Enum.EasingDirection.InOut
		):Play()
		Tween(
			ResizeHandle.ImageLabel,
			0.3,
			{ ImageTransparency = 1 },
			Enum.EasingStyle.Exponential,
			Enum.EasingDirection.Out
		):Play()
		WindowDragModule:Set(false)
		Window.CanResize = false

		task.spawn(function()
			task.wait(0.4)
			Window.UIElements.Main.Visible = false

			if Window.OpenButtonMain and not Window.Destroyed and Window.IsOpenButtonEnabled then
				-- Window.OpenButtonMain:Visible(true) -- Replaced by MinimizedBar
			end
            if Window.MinimizedBar then Window.MinimizedBar:Visible(true) end
		end)

		function Close:Destroy()
			task.spawn(function()
				if Window.OnDestroyCallback then
					task.spawn(function()
						Creator.SafeCallback(Window.OnDestroyCallback)
					end)
				end
				if Window.AcrylicPaint and Window.AcrylicPaint.Model then
					Window.AcrylicPaint.Model:Destroy()
				end
				Window.Destroyed = true
				task.wait(0.4)
				Config.IntiHub.ScreenGui:Destroy()
				Config.IntiHub.NotificationGui:Destroy()
				Config.IntiHub.DropdownGui:Destroy()
				Config.IntiHub.TooltipGui:Destroy()

				Creator.DisconnectAll()

				return
			end)
		end

		return Close
	end
	function Window:Destroy()
		return Window:Close():Destroy()
	end
	function Window:Toggle()
		if Window.Closed then
			Window:Open()
		else
			Window:Close()
		end
	end

	function Window:ToggleTransparency(Value)
		-- Config.Transparent = Value
		Window.Transparent = Value
		Config.IntiHub.Transparent = Value

		Window.UIElements.Main.Background.ImageTransparency = Value and Config.IntiHub.TransparencyValue or 0
		-- Window.UIElements.Main.Background.ImageLabel.ImageTransparency = Value and Config.IntiHub.TransparencyValue or 0
		--Window.UIElements.MainBar.Background.ImageTransparency = Value and 0.97 or 0.95
	end

	function Window:LockAll()
		for _, element in next, Window.AllElements do
			if element.Lock then
				element:Lock()
			end
		end
	end
	function Window:UnlockAll()
		for _, element in next, Window.AllElements do
			if element.Unlock then
				element:Unlock()
			end
		end
	end
	function Window:GetLocked()
		local LockedElements = {}

		for _, element in next, Window.AllElements do
			if element.Locked then
				table.insert(LockedElements, element)
			end
		end

		return LockedElements
	end
	function Window:GetUnlocked()
		local UnlockedElements = {}

		for _, element in next, Window.AllElements do
			if element.Locked == false then
				table.insert(UnlockedElements, element)
			end
		end

		return UnlockedElements
	end

	function Window:GetUIScale(v)
		return Config.IntiHub.UIScale
	end

	function Window:SetUIScale(v)
		Config.IntiHub.UIScale = v
		Tween(Config.IntiHub.UIScaleObj, 0.2, { Scale = v }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
		return Window
	end

	function Window:SetToTheCenter()
		Tween(
			Window.UIElements.Main,
			0.45,
			{ Position = UDim2.new(0.5, 0, 0.5, 0) },
			Enum.EasingStyle.Quint,
			Enum.EasingDirection.Out
		):Play()
		return Window
	end

	function Window:SetCurrentConfig(ConfigModule)
		Window.CurrentConfig = ConfigModule
	end

	do
		local Margin = 40
		local ViewportSize = CurrentCamera.ViewportSize
		local WindowSize = Window.UIElements.Main.AbsoluteSize

		if not Window.IsFullscreen and Window.AutoScale then
			local AvailableWidth = ViewportSize.X - (Margin * 2)
			local AvailableHeight = ViewportSize.Y - (Margin * 2)

			local ScaleX = AvailableWidth / WindowSize.X
			local ScaleY = AvailableHeight / WindowSize.Y

			local RequiredScale = math.min(ScaleX, ScaleY)

			local MinScale = 0.3
			local MaxScale = 1.0

			local FinalScale = math.clamp(RequiredScale, MinScale, MaxScale)

			local CurrentScale = Window:GetUIScale() or 1
			local Tolerance = 0.05

			if math.abs(FinalScale - CurrentScale) > Tolerance then
				Window:SetUIScale(FinalScale)
			end
		end
	end

	-- OpenButton click is handled within the Openbutton module

	Creator.AddSignal(UserInputService.InputBegan, function(input, isProcessed)
		if isProcessed then
			return
		end

		if Window.ToggleKey then
			if input.KeyCode == Window.ToggleKey then
				Window:Toggle()
			end
		end
	end)

	task.spawn(function()
		--task.wait(1.38583)
		Window:Open()
	end)

	function Window:EditOpenButton(OpenButtonConfig)
		return Window.OpenButtonMain:Edit(OpenButtonConfig)
	end

	if Window.OpenButton and typeof(Window.OpenButton) == "table" then
		Window:EditOpenButton(Window.OpenButton)
	end

	local TabModuleMain = require("./Tab")
	local SectionModule = require("./Section")
	local TabModule = TabModuleMain.Init(Window, Config.IntiHub, Config.IntiHub.TooltipGui)
	TabModule:OnChange(function(t)
		Window.CurrentTab = t
	end)

	Window.TabModule = TabModule

	function Window:Tab(TabConfig)
		TabConfig.Parent = Window.UIElements.SideBar.Frame
		return TabModule.New(TabConfig, Config.IntiHub.UIScale)
	end

	function Window:SelectTab(Tab)
		TabModule:SelectTab(Tab)
	end

	function Window:Section(SectionConfig)
		return SectionModule.New(
			SectionConfig,
			Window.UIElements.SideBar.Frame,
			Window.Folder,
			Config.IntiHub.UIScale,
			Window
		)
	end

	function Window:IsResizable(v)
		Window.Resizable = v
		Window.CanResize = v
	end

	function Window:SetPanelBackground(v)
		if typeof(v) == "boolean" then
			Window.HidePanelBackground = v

			Window.UIElements.MainBar.Background.Visible = v

			if TabModule then
				for _, Container in next, TabModule.Containers do
					Container.ScrollingFrame.UIPadding.PaddingTop = UDim.new(0, Window.HidePanelBackground and 20 or 10)
					Container.ScrollingFrame.UIPadding.PaddingLeft =
						UDim.new(0, Window.HidePanelBackground and 20 or 10)
					Container.ScrollingFrame.UIPadding.PaddingRight =
						UDim.new(0, Window.HidePanelBackground and 20 or 10)
					Container.ScrollingFrame.UIPadding.PaddingBottom =
						UDim.new(0, Window.HidePanelBackground and 20 or 10)
				end
			end
		end
	end

	function Window:Divider()
		local Divider = New("Frame", {
			Size = UDim2.new(1, 0, 0, 1),
			Position = UDim2.new(0.5, 0, 0, 0),
			AnchorPoint = Vector2.new(0.5, 0),
			BackgroundTransparency = 0.9,
			ThemeTag = {
				BackgroundColor3 = "Text",
			},
		})
		local MainDivider = New("Frame", {
			Parent = Window.UIElements.SideBar.Frame,
			--AutomaticSize = "Y",
			Size = UDim2.new(1, -7, 0, 5),
			BackgroundTransparency = 1,
		}, {
			Divider,
		})

		return MainDivider
	end

	local DialogModule = require("./Dialog").Init(Window, Config.IntiHub, nil)
	function Window:Dialog(DialogConfig)
		local DialogTable = {
			Title = DialogConfig.Title or "Dialog",
			Width = DialogConfig.Width or 320,
			Content = DialogConfig.Content,
			Buttons = DialogConfig.Buttons or {},

			TextPadding = 14,
		}
		local Dialog = DialogModule.Create(false)

		Dialog.UIElements.Main.Size = UDim2.new(0, DialogTable.Width, 0, 0)

		local DialogTopColFrame = New("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			AutomaticSize = "Y",
			BackgroundTransparency = 1,
			Parent = Dialog.UIElements.Main,
		}, {
			New("UIListLayout", {
				FillDirection = "Vertical",
				--HorizontalAlignment = "Center",
				Padding = UDim.new(0, Dialog.UIPadding),
			}),
		})

		local DialogTopRowFrame = New("Frame", {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = "Y",
			BackgroundTransparency = 1,
			Parent = DialogTopColFrame,
		}, {
			New("UIListLayout", {
				FillDirection = "Horizontal",
				Padding = UDim.new(0, Dialog.UIPadding),
				VerticalAlignment = "Center",
			}),
			New("UIPadding", {
				PaddingTop = UDim.new(0, DialogTable.TextPadding / 2),
				PaddingLeft = UDim.new(0, DialogTable.TextPadding / 2),
				PaddingRight = UDim.new(0, DialogTable.TextPadding / 2),
			}),
		})

		local Icon
		if DialogConfig.Icon then
			Icon = Creator.Image(
				DialogConfig.Icon,
				DialogTable.Title .. ":" .. DialogConfig.Icon,
				0,
				Window,
				"Dialog",
				true,
				DialogConfig.IconThemed
			)
			Icon.Size = UDim2.new(0, 22, 0, 22)
			Icon.Parent = DialogTopRowFrame
		end

		Dialog.UIElements.UIListLayout = New("UIListLayout", {
			Padding = UDim.new(0, 12),
			FillDirection = "Vertical",
			HorizontalAlignment = "Left",
			VerticalFlex = "SpaceBetween",
			Parent = Dialog.UIElements.Main,
		})

		New("UISizeConstraint", {
			MinSize = Vector2.new(180, 20),
			MaxSize = Vector2.new(400, math.huge),
			Parent = Dialog.UIElements.Main,
		})

		Dialog.UIElements.Title = New("TextLabel", {
			Text = DialogTable.Title,
			TextSize = 20,
			FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
			TextXAlignment = "Left",
			TextWrapped = true,
			RichText = true,
			Size = UDim2.new(1, Icon and -26 - Dialog.UIPadding or 0, 0, 0),
			AutomaticSize = "Y",
			ThemeTag = {
				TextColor3 = "Text",
			},
			BackgroundTransparency = 1,
			Parent = DialogTopRowFrame,
		})
		if DialogTable.Content then
			local Content = New("TextLabel", {
				Text = DialogTable.Content,
				TextSize = 18,
				TextTransparency = 0.4,
				TextWrapped = true,
				RichText = true,
				FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
				TextXAlignment = "Left",
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = "Y",
				LayoutOrder = 2,
				ThemeTag = {
					TextColor3 = "Text",
				},
				BackgroundTransparency = 1,
				Parent = DialogTopColFrame,
			}, {
				New("UIPadding", {
					PaddingLeft = UDim.new(0, DialogTable.TextPadding / 2),
					PaddingRight = UDim.new(0, DialogTable.TextPadding / 2),
					PaddingBottom = UDim.new(0, DialogTable.TextPadding / 2),
				}),
			})
		end

		local ButtonsLayout = New("UIListLayout", {
			Padding = UDim.new(0, 6),
			FillDirection = "Horizontal",
			HorizontalAlignment = "Center",
			HorizontalFlex = "Fill",
		})

		local ButtonsContent = New("Frame", {
			Size = UDim2.new(1, 0, 0, 40),
			AutomaticSize = "None",
			BackgroundTransparency = 1,
			Parent = Dialog.UIElements.Main,
			LayoutOrder = 4,
		}, {
			ButtonsLayout,
			-- New("UIPadding", {
			--     PaddingTop = UDim.new(0, DialogTable.TextPadding/2),
			--     PaddingLeft = UDim.new(0, DialogTable.TextPadding/2),
			--     PaddingRight = UDim.new(0, DialogTable.TextPadding/2),
			--     PaddingBottom = UDim.new(0, DialogTable.TextPadding/2),
			-- })
		})

		local Buttons = {}

		for _, Button in next, DialogTable.Buttons do
			local ButtonFrame =
				CreateButton(Button.Title, Button.Icon, Button.Callback, Button.Variant, ButtonsContent, Dialog, true)
			table.insert(Buttons, ButtonFrame)
			ButtonFrame.Size = UDim2.new(1, 0, 1, 0)
		end

		local function CheckButtonsOverflow()
			ButtonsLayout.FillDirection = Enum.FillDirection.Horizontal
			ButtonsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
			ButtonsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
			ButtonsContent.AutomaticSize = Enum.AutomaticSize.None

			for _, button in ipairs(Buttons) do
				button.Size = UDim2.new(0, 0, 1, 0)
				button.AutomaticSize = Enum.AutomaticSize.X
			end

			wait()

			local totalWidth = ButtonsLayout.AbsoluteContentSize.X / Config.IntiHub.UIScale
			local parentWidth = ButtonsContent.AbsoluteSize.X / Config.IntiHub.UIScale

			if totalWidth > parentWidth then
				ButtonsLayout.FillDirection = Enum.FillDirection.Vertical
				ButtonsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
				ButtonsLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
				ButtonsContent.AutomaticSize = Enum.AutomaticSize.Y

				for _, button in ipairs(Buttons) do
					button.Size = UDim2.new(1, 0, 0, 40)
					button.AutomaticSize = Enum.AutomaticSize.None
				end
			else
				local availableSpace = parentWidth - totalWidth
				if availableSpace > 0 then
					local smallestButton = nil
					local smallestWidth = math.huge

					for _, button in ipairs(Buttons) do
						local buttonWidth = button.AbsoluteSize.X / Config.IntiHub.UIScale
						if buttonWidth < smallestWidth then
							smallestWidth = buttonWidth
							smallestButton = button
						end
					end

					if smallestButton then
						smallestButton.Size = UDim2.new(0, smallestWidth + availableSpace, 1, 0)
						smallestButton.AutomaticSize = Enum.AutomaticSize.None
					end
				end
			end
		end

		-- Creator.AddSignal(Dialog.UIElements.Main:GetPropertyChangedSignal("AbsoluteSize"), CheckButtonsOverflow)
		-- CheckButtonsOverflow()

		-- wait()
		Dialog:Open()

		return Dialog
	end

	local ClickedClose = false

	Window:CreateTopbarButton("Close", "x", function()
		if not ClickedClose then
			if not Window.IgnoreAlerts then
				ClickedClose = true
				Window:SetToTheCenter()
				Window:Dialog({
					--Icon = "trash-2",
					Title = "Close Window",
					Content = "Do you want to close this window? You will not be able to open it again.",
					Buttons = {
						{
							Title = "Cancel",
							--Icon = "chevron-left",
							Callback = function()
								ClickedClose = false
							end,
							Variant = "Secondary",
						},
						{
							Title = "Close Window",
							--Icon = "chevron-down",
							Callback = function()
								ClickedClose = false
								Window:Destroy()
							end,
							Variant = "Primary",
						},
					},
				})
			else
				Window:Destroy()
			end
		end
	end, (Window.Topbar.ButtonsType == "Default" and 999 or 997), nil, Color3.fromHex("#F4695F"))

	function Window:Tag(TagConfig)
		if Window.UIElements.Main.Main.Topbar.Center.Visible == false then
			Window.UIElements.Main.Main.Topbar.Center.Visible = true
		end
		TagConfig.Window = Window
        TagConfig.LayoutOrder = TagConfig.LayoutOrder or 0
		return Tag:New(TagConfig, Window.UIElements.Main.Main.Topbar.Center)
	end

	local function startResizing(input)
		if Window.CanResize then
			isResizing = true
			FullScreenIcon.Active = true
			initialSize = Window.UIElements.Main.Size
			initialInputPosition = input.Position
			--Tween(FullScreenIcon, 0.12, {ImageTransparency = .65}):Play()
			--Tween(FullScreenIcon.ImageLabel, 0.12, {ImageTransparency = 0}):Play()
			Tween(ResizeHandle.ImageLabel, 0.1, { ImageTransparency = 0.35 }):Play()

			Creator.AddSignal(input.Changed, function()
				if input.UserInputState == Enum.UserInputState.End then
					isResizing = false
					FullScreenIcon.Active = false
					--Tween(FullScreenIcon, 0.2, {ImageTransparency = 1}):Play()
					--Tween(FullScreenIcon.ImageLabel, 0.17, {ImageTransparency = 1}):Play()
					Tween(ResizeHandle.ImageLabel, 0.17, { ImageTransparency = 0.8 }):Play()
				end
			end)
		end
	end

	Creator.AddSignal(ResizeHandle.InputBegan, function(input)
		if
			input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch
		then
			if Window.CanResize then
				startResizing(input)
			end
		end
	end)

	Creator.AddSignal(UserInputService.InputChanged, function(input)
		if
			input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch
		then
			if isResizing and Window.CanResize then
				local delta = input.Position - initialInputPosition
				local newSize = UDim2.new(0, initialSize.X.Offset + delta.X * 2, 0, initialSize.Y.Offset + delta.Y * 2)

				newSize = UDim2.new(
					newSize.X.Scale,
					math.clamp(newSize.X.Offset, Window.MinSize.X, Window.MaxSize.X),
					newSize.Y.Scale,
					math.clamp(newSize.Y.Offset, Window.MinSize.Y, Window.MaxSize.Y)
				)

				Tween(Window.UIElements.Main, 0.08, {
					Size = newSize,
				}, Enum.EasingStyle.Quad, Enum.EasingDirection.Out):Play()

				Window.Size = newSize
			end
		end
	end)

	Creator.AddSignal(ResizeHandle.MouseEnter, function()
		if not isResizing then
			Tween(ResizeHandle.ImageLabel, 0.1, { ImageTransparency = 0.35 }):Play()
		end
	end)
	Creator.AddSignal(ResizeHandle.MouseLeave, function()
		if not isResizing then
			Tween(ResizeHandle.ImageLabel, 0.17, { ImageTransparency = 0.8 }):Play()
		end
	end)

	-- / Double click /

	local LastUpTime = 0
	local DoubleClickWindow = 0.4
	local InitialPosition = nil
	local ClickCount = 0

	function onDoubleClick()
		Window:SetToTheCenter()
	end

	Creator.AddSignal(BottomDragFrame.Frame.MouseButton1Up, function()
		local currentTime = tick()
		local currentPosition = Window.Position

		ClickCount = ClickCount + 1

		if ClickCount == 1 then
			LastUpTime = currentTime
			InitialPosition = currentPosition

			task.spawn(function()
				task.wait(DoubleClickWindow)
				if ClickCount == 1 then
					ClickCount = 0
					InitialPosition = nil
				end
			end)
		elseif ClickCount == 2 then
			if currentTime - LastUpTime <= DoubleClickWindow and currentPosition == InitialPosition then
				onDoubleClick()
			end

			ClickCount = 0
			InitialPosition = nil
			LastUpTime = 0
		else
			ClickCount = 1
			LastUpTime = currentTime
			InitialPosition = currentPosition
		end
	end)

	-- / Search Bar /

	if not Window.HideSearchBar then
		local SearchBar = require("../search/Init")
		local IsOpen = false

		-- Search Bar in TopBar Center
		local SearchBarTrigger = CreateLabel("Search...", "search", Window.UIElements.Main.Main.Topbar.Center, true)
        SearchBarTrigger.Size = UDim2.new(0, 150, 0, 30)
        SearchBarTrigger.LayoutOrder = 5 -- After version and language
        
        -- 🟢 Language Selection System
        local CurrentLang = "EN"
        local LangTrigger = CreateLabel("EN", "globe", Window.UIElements.Main.Main.Topbar.Center, true)
        LangTrigger.Size = UDim2.new(0, 50, 0, 30)
        LangTrigger.LayoutOrder = 2 -- After version

        local LangDropdown = New("Frame", {
            Size = UDim2.new(0, 100, 0, 0), -- Wider dropdown
            Position = UDim2.new(0.5, 0, 1, 8),
            AnchorPoint = Vector2.new(0.5, 0),
            BackgroundTransparency = 1,
            ClipsDescendants = true,
            Parent = LangTrigger,
            ZIndex = 10000,
        }, {
            Creator.NewRoundFrame(8, "Glass-1", {
                Size = UDim2.new(1, 0, 1, 0),
                ThemeTag = { ImageColor3 = "PanelBackground" },
                ImageTransparency = 0.05,
            }, {
                New("UIStroke", { Thickness = 1.5, Color = Color3.fromHex("#FFD700"), Transparency = 0.7 })
            }),
            New("UIListLayout", {
                Padding = UDim.new(0, 4),
                SortOrder = "LayoutOrder",
            }),
            New("UIPadding", {
                PaddingTop = UDim.new(0, 6),
                PaddingBottom = UDim.new(0, 6),
                PaddingLeft = UDim.new(0, 6),
                PaddingRight = UDim.new(0, 6),
            }),
        })

        local function CreateLangItem(lang)
            local item = New("TextButton", {
                Size = UDim2.new(1, 0, 0, 30),
                BackgroundTransparency = 1,
                Text = lang,
                TextSize = 13,
                FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
                TextColor3 = Color3.new(1, 1, 1),
                TextTransparency = 0.4,
                Parent = LangDropdown,
            }, {
                New("UICorner", { CornerRadius = UDim.new(0, 6) }),
            })

            Creator.AddSignal(item.MouseEnter, function()
                Tween(item, 0.2, { TextTransparency = 0, BackgroundTransparency = 0.95 }):Play()
            end)
            Creator.AddSignal(item.MouseLeave, function()
                Tween(item, 0.2, { TextTransparency = 0.4, BackgroundTransparency = 1 }):Play()
            end)

            Creator.AddSignal(item.MouseButton1Click, function()
                LangTrigger.Text = lang
                Tween(LangDropdown, 0.2, { Size = UDim2.new(0, 100, 0, 0) }):Play()
            end)
        end

        CreateLangItem("EN")
        CreateLangItem("ES")
        CreateLangItem("PT")

        Creator.AddSignal(LangTrigger.MouseButton1Click, function()
            local targetSize = LangDropdown.Size.Y.Offset == 0 and 110 or 0
            Tween(LangDropdown, 0.25, { Size = UDim2.new(0, 100, 0, targetSize) }, Enum.EasingStyle.Quint):Play()
        end)

        Window.UIElements.Main.Main.Topbar.Center.Visible = true

		Creator.AddSignal(SearchBarTrigger.MouseButton1Click, function()
			if IsOpen then
				return
			end

			SearchBar.new(Window.TabModule, Window.UIElements.Main, function()
				-- OnClose
				IsOpen = false
				if Window.Resizable then
					Window.CanResize = true
				end

				Tween(FullScreenBlur, 0.1, { ImageTransparency = 1 }):Play()
				FullScreenBlur.Active = false
			end)
			Tween(FullScreenBlur, 0.1, { ImageTransparency = 0.65 }):Play()
			FullScreenBlur.Active = true

			IsOpen = true
			Window.CanResize = false
		end)
	end

	-- / TopBar Edit /

	function Window:DisableTopbarButtons(btns)
		for _, b in next, btns do
			for _, i in next, Window.TopBarButtons do
				if i.Name == b then
					i.Object.Visible = false
				end
			end
		end
	end

	-- / Live Stats Update /
    
    local Stats = cloneref(game:GetService("Stats"))
    local MarketplaceService = cloneref(game:GetService("MarketplaceService"))
    
    task.spawn(function()
        local GameNameLabel = RightPanelContent:FindFirstChild("GameName", true)
        local FPSLabel = RightPanelContent:FindFirstChild("FPSValue", true)
        local PingLabel = RightPanelContent:FindFirstChild("PingValue", true)
        local RamLabel = RightPanelContent:FindFirstChild("RamValue", true)

        while task.wait(5) do -- Only update Game Name every 5s
            pcall(function()
                local success, info = pcall(function() return MarketplaceService:GetProductInfo(game.PlaceId) end)
                if success and info and info.Name then
                    GameNameLabel.Text = info.Name
                else
                    GameNameLabel.Text = game.Name or "Unknown"
                end
            end)
        end
    end)


    if Window.OpenButtonMain and Window.OpenButtonMain.Button then
        task.spawn(function()
            local glow = Window.OpenButtonMain.Button:FindFirstChild("Glow", true)
            while task.wait(1.5) do
                if glow then
                    Tween(glow, 0.75, { ImageTransparency = 0.4 }):Play()
                    task.wait(0.75)
                    Tween(glow, 0.75, { ImageTransparency = 0.8 }):Play()
                end
            end
        end)
    end

	-- setmetatable(Window, {
	--     __newindex = function(t, key, value)
	--         rawset(t, key, value)

	--         local bind = bindings[key]
	--         if bind then
	--             bind(value)
	--         end
	--     end
	-- })

	task.spawn(function()
		local gradient1 = Window.UIElements.Main:FindFirstChild("AnimatedGradient1", true)
		local overlay = Window.UIElements.Main:FindFirstChild("AnimationOverlay", true)
		local gradient2 = overlay and overlay:FindFirstChild("AnimatedGradient2", true)
		
		local rot = 0
		local conn
		conn = RunService.RenderStepped:Connect(function(dt)
			if Window.Destroyed or not Window.UIElements.Main then 
				if conn then conn:Disconnect() end
				return 
			end
			rot = rot + (dt * 60)
			if gradient1 then gradient1.Rotation = rot % 360 end
			if gradient2 then gradient2.Rotation = (360 - rot) % 360 end
		end)
	end)

	return Window
end
