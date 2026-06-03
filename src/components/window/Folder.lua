local Creator = require("../../modules/Creator")
local New = Creator.New
local Tween = Creator.Tween

local Folder = {}
Folder.__index = Folder

function Folder.New(Config, Window, TabModule, UIScale)
	local self = setmetatable({
		Window = Window,
		TabModule = TabModule,
		UIScale = UIScale,
		Title = Config.Title or "Folder",
		Icon = Config.Icon or "folder",
		IconColor = Config.IconColor,
		IconThemed = Config.IconThemed,
		Locked = Config.Locked or false,
		Opened = Config.Opened or false,
		Tabs = {},
		UICorner = Window.UICorner - (Window.UIPadding / 2),
	}, Folder)

	-- Register folder in Window.Folders
	table.insert(Window.Folders, self)
	Window:UpdateSidebarSeparator()

	-- Layout order: folders are placed after standalone tabs
	local folderLayoutOrder = 1000 + #Window.Folders

	-- Create Folder Main Frame
	local MainFrame = New("Frame", {
		Name = self.Title .. "FolderContainer",
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = "Y",
		BackgroundTransparency = 1,
		LayoutOrder = folderLayoutOrder,
		Parent = Window.UIElements.SideBar.Frame,
	}, {
		New("UIListLayout", {
			SortOrder = "LayoutOrder",
			Padding = UDim.new(0, Window.Gap or 6),
		})
	})

	self.MainFrame = MainFrame

	-- Create the Folder Header Button
	local HeaderButton = Creator.NewRoundFrame(self.UICorner, "Squircle", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -7, 0, 32), -- same height/width style as Tab
		Parent = MainFrame,
		LayoutOrder = 1,
		ThemeTag = {
			ImageColor3 = "TabBackground",
		},
		ImageTransparency = 1,
	}, {
		Creator.NewRoundFrame(self.UICorner, "Squircle", {
			Size = UDim2.new(1, 0, 1, 0),
			ThemeTag = {
				ImageColor3 = "Text",
			},
			ImageTransparency = 1,
			Name = "Frame",
		}, {
			New("UIListLayout", {
				SortOrder = "LayoutOrder",
				Padding = UDim.new(0, 8),
				FillDirection = "Horizontal",
				VerticalAlignment = "Center",
			}),
			New("UIPadding", {
				PaddingTop = UDim.new(0, 4),
				PaddingLeft = UDim.new(0, 8),
				PaddingRight = UDim.new(0, 8),
				PaddingBottom = UDim.new(0, 4),
			}),
		})
	}, true)

	self.HeaderButton = HeaderButton

	-- Create folder Icon
	local FolderIcon = Creator.Image(
		self.Icon,
		self.Icon .. ":" .. self.Title,
		0,
		Window.Folder,
		"FolderIcon",
		self.IconColor and false or true,
		self.IconThemed,
		"TabIcon"
	)
	FolderIcon.Size = UDim2.new(0, 16, 0, 16)
	if self.IconColor then
		FolderIcon.ImageLabel.ImageColor3 = self.IconColor
	end
	FolderIcon.Parent = HeaderButton.Frame
	FolderIcon.ImageLabel.ImageTransparency = self.Locked and 0.7 or 0.4
	FolderIcon.LayoutOrder = 1
	self.FolderIcon = FolderIcon

	-- Folder Title Text
	local TitleLabel = New("TextLabel", {
		Text = self.Title,
		ThemeTag = {
			TextColor3 = "TabTitle",
		},
		TextTransparency = self.Locked and 0.7 or 0.4,
		TextSize = 14,
		Size = UDim2.new(1, -40, 1, 0),
		FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
		TextWrapped = true,
		RichText = true,
		TextXAlignment = "Left",
		BackgroundTransparency = 1,
		LayoutOrder = 2,
	})
	TitleLabel.Parent = HeaderButton.Frame
	self.TitleLabel = TitleLabel

	-- Chevron Icon on the right to indicate expand/collapse
	local Chevron = New("Frame", {
		Size = UDim2.new(0, 14, 0, 14),
		BackgroundTransparency = 1,
		LayoutOrder = 3,
	}, {
		New("ImageLabel", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Image = Creator.Icon("chevron-down")[1],
			ImageRectSize = Creator.Icon("chevron-down")[2].ImageRectSize,
			ImageRectOffset = Creator.Icon("chevron-down")[2].ImageRectPosition,
			ThemeTag = {
				ImageColor3 = "Icon",
			},
			ImageTransparency = 0.5,
		})
	})
	Chevron.Parent = HeaderButton.Frame
	self.Chevron = Chevron

	-- Create the Sub-Frame containing the tabs inside this folder
	local TabsFrame = New("Frame", {
		Name = "Tabs",
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = "Y",
		BackgroundTransparency = 1,
		Visible = self.Opened,
		Parent = MainFrame,
		LayoutOrder = 2,
	}, {
		New("UIListLayout", {
			SortOrder = "LayoutOrder",
			Padding = UDim.new(0, Window.Gap or 6),
		}),
		New("UIPadding", {
			PaddingLeft = UDim.new(0, 12), -- Indentation
			PaddingTop = UDim.new(0, 4),
			PaddingBottom = UDim.new(0, 4),
		}),
	})
	self.TabsFrame = TabsFrame

	-- Hover effects
	Creator.AddSignal(HeaderButton.MouseEnter, function()
		if not self.Locked then
			Creator.SetThemeTag(HeaderButton.Frame, {
				ImageTransparency = "TabBackgroundHoverTransparency",
				ImageColor3 = "TabBackgroundHover",
			}, 0.1)
		end
	end)

	Creator.AddSignal(HeaderButton.MouseLeave, function()
		if not self.Locked then
			Creator.SetThemeTag(HeaderButton.Frame, {
				ImageTransparency = 1,
			}, 0.1)
		end
	end)

	-- Toggle Folder Open/Close on click
	Creator.AddSignal(HeaderButton.MouseButton1Click, function()
		if not self.Locked then
			self:Toggle()
		end
	end)

	if self.Opened then
		local ImageLabel = Chevron:FindFirstChildWhichIsA("ImageLabel", true)
		if ImageLabel then
			ImageLabel.Rotation = 180
		end
	end

	return self
end

function Folder:Toggle()
	self.Opened = not self.Opened
	self.TabsFrame.Visible = self.Opened
	local ImageLabel = self.Chevron:FindFirstChildWhichIsA("ImageLabel", true)
	if ImageLabel then
		Tween(ImageLabel, 0.2, { Rotation = self.Opened and 180 or 0 }):Play()
	end
end

function Folder:Tab(TabConfig)
	TabConfig.Parent = self.TabsFrame
	local tab = self.TabModule.New(TabConfig, self.UIScale)
	table.insert(self.Tabs, tab)
	return tab
end

return Folder
