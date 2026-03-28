--[[
    ___       __  _ __  __      __  
   /  _/___  / /_(_) / / /_  __/ /_ 
   / // __ \/ __/ / /_/ / / / / __ \
 _/ // / / / /_/ / __  / /_/ / /_/ /
/___/_/ /_/\__/_/_/ /_/\__,_/_.___/ 
                                    
    v1.7.0  |  2026-03-28  |  Roblox UI Library - Noble Deluxe v2.0
    
    To view the source code, see the `src/` folder on the official GitHub repository.
    
    Author: Sammir_Inti
    Github: https://github.com/Sam123mir/IntiHub-LibraryUI
    Discord: https://discord.gg/intihub
    License: MIT
]]


local a

a = {
    cache = {},
    load = function(b)
        if not a.cache[b] then
            a.cache[b] = {
                c = a[b](),
            }
        end

        return a.cache[b].c
    end,
}

do
    function a.a()
        local b = (cloneref or clonereference or function(b)
            return b
        end)
        local c = b(game:GetService'ReplicatedStorage':WaitForChild('GetIcons', 99999):InvokeServer())
        local d = function(d)
            if type(d) == 'string' then
                local e = d:find':'

                if e then
                    local f = d:sub(1, e - 1)
                    local g = d:sub(e + 1)

                    return f, g
                end
            end

            return nil, d
        end

        function c.AddIcons(e, f)
            if type(e) ~= 'string' or type(f) ~= 'table' then
                error'AddIcons: packName must be string, iconsData must be table'

                return
            end
            if not c.Icons[e] then
                c.Icons[e] = {
                    Icons = {},
                    Spritesheets = {},
                }
            end

            for g, h in pairs(f)do
                if type(h) == 'number' or (type(h) == 'string' and h:match'^rbxassetid://') then
                    local i = h

                    if type(h) == 'number' then
                        i = 'rbxassetid://' .. tostring(h)
                    end

                    c.Icons[e].Icons[g] = {
                        Image = i,
                        ImageRectSize = Vector2.new(0, 0),
                        ImageRectPosition = Vector2.new(0, 0),
                        Parts = nil,
                    }
                    c.Icons[e].Spritesheets[i] = i
                elseif type(h) == 'table' then
                    if h.Image and h.ImageRectSize and h.ImageRectPosition then
                        local i = h.Image

                        if type(i) == 'number' then
                            i = 'rbxassetid://' .. tostring(i)
                        end

                        c.Icons[e].Icons[g] = {
                            Image = i,
                            ImageRectSize = h.ImageRectSize,
                            ImageRectPosition = h.ImageRectPosition,
                            Parts = h.Parts,
                        }

                        if not c.Icons[e].Spritesheets[i] then
                            c.Icons[e].Spritesheets[i] = i
                        end
                    else
                        warn("AddIcons: Invalid spritesheet data format for icon '" .. g .. "'")
                    end
                else
                    warn("AddIcons: Unsupported data type for icon '" .. g .. "': " .. type(h))
                end
            end
        end
        function c.SetIconsType(e)
            c.IconsType = e
        end

        local e

        function c.Init(f, g)
            c.New = f
            c.IconThemeTag = g
            e = f

            return c
        end
        function c.Icon(f, g, h)
            h = h ~= false

            local i, j = d(f)
            local k = i or g or c.IconsType
            local l = j
            local m = c.Icons[k]

            if m and m.Icons and m.Icons[l] then
                return {
                    m.Spritesheets[tostring(m.Icons[l].Image)],
                    m.Icons[l],
                }
            elseif m and m[l] and string.find(m[l], 'rbxassetid://') then
                return h and {
                    m[l],
                    {
                        ImageRectSize = Vector2.new(0, 0),
                        ImageRectPosition = Vector2.new(0, 0),
                    },
                } or m[l]
            end

            return nil
        end
        function c.GetIcon(f, g)
            return c.Icon(f, g, false)
        end
        function c.Icon2(f, g, h)
            return c.Icon(f, g, true)
        end
        function c.Image(f)
            local g = {
                Icon = f.Icon or nil,
                Type = f.Type,
                Colors = f.Colors or {
                    (c.IconThemeTag or Color3.new(1, 1, 1)),
                    Color3.new(1, 1, 1),
                },
                Transparency = f.Transparency or {0, 0},
                Size = f.Size or UDim2.new(0, 24, 0, 24),
                IconFrame = nil,
            }
            local h = {}
            local i = {}

            for j, k in next, g.Colors do
                h[j] = {
                    ThemeTag = typeof(k) == 'string' and k,
                    Color = typeof(k) == 'Color3' and k,
                }
            end
            for j, k in next, g.Transparency do
                i[j] = {
                    ThemeTag = typeof(k) == 'string' and k,
                    Value = typeof(k) == 'number' and k,
                }
            end

            local j = c.Icon2(g.Icon, g.Type)
            local k = typeof(j) == 'string' and string.find(j, 'rbxassetid://')

            if c.New then
                local l = e or c.New
                local m = l('ImageLabel', {
                    Size = g.Size,
                    BackgroundTransparency = 1,
                    ImageColor3 = h[1].Color or nil,
                    ImageTransparency = i[1].Value or nil,
                    ThemeTag = h[1].ThemeTag and {
                        ImageColor3 = h[1].ThemeTag,
                        ImageTransparency = i[1].ThemeTag,
                    },
                    Image = k and j or j[1],
                    ImageRectSize = k and nil or j[2].ImageRectSize,
                    ImageRectOffset = k and nil or j[2].ImageRectPosition,
                })

                if not k and j[2].Parts then
                    for n, o in next, j[2].Parts do
                        local p = c.Icon(o, g.Type)

                        l('ImageLabel', {
                            Size = UDim2.new(1, 0, 1, 0),
                            BackgroundTransparency = 1,
                            ImageColor3 = h[1 + n].Color or nil,
                            ImageTransparency = i[1 + n].Value or nil,
                            ThemeTag = h[1 + n].ThemeTag and {
                                ImageColor3 = h[1 + n].ThemeTag,
                                ImageTransparency = i[1 + n].ThemeTag,
                            },
                            Image = p[1],
                            ImageRectSize = p[2].ImageRectSize,
                            ImageRectOffset = p[2].ImageRectPosition,
                            Parent = m,
                        })
                    end
                end

                g.IconFrame = m
            else
                local l = Instance.new'ImageLabel'

                l.Size = g.Size
                l.BackgroundTransparency = 1
                l.ImageColor3 = h[1].Color
                l.ImageTransparency = i[1].Value or nil
                l.Image = k and j or j[1]
                l.ImageRectSize = k and nil or j[2].ImageRectSize
                l.ImageRectOffset = k and nil or j[2].ImageRectPosition

                if not k and j[2].Parts then
                    for m, n in next, j[2].Parts do
                        local o = c.Icon(n, g.Type)
                        local p = Instance.New'ImageLabel'

                        p.Size = UDim2.new(1, 0, 1, 0)
                        p.BackgroundTransparency = 1
                        p.ImageColor3 = h[1 + m].Color
                        p.ImageTransparency = i[1 + m].Value or nil
                        p.Image = o[1]
                        p.ImageRectSize = o[2].ImageRectSize
                        p.ImageRectOffset = o[2].ImageRectPosition
                        p.Parent = l
                    end
                end

                g.IconFrame = l
            end

            return g
        end

        return c
    end
    function a.b()
        return {
            Primary = 'Icon',
            White = Color3.new(1, 1, 1),
            Black = Color3.new(0, 0, 0),
            Dialog = 'Accent',
            Background = 'Accent',
            BackgroundTransparency = 0,
            Hover = 'Text',
            PanelBackground = 'White',
            PanelBackgroundTransparency = 0.95,
            WindowBackground = 'Background',
            WindowBackgroundTransparency = 'BackgroundTransparency',
            WindowShadow = 'Black',
            WindowTopbarTitle = 'Text',
            WindowTopbarAuthor = 'Text',
            WindowTopbarIcon = 'Icon',
            WindowTopbarButtonIcon = 'Icon',
            WindowSearchBarBackground = 'Background',
            TabBackground = 'Hover',
            TabBackgroundHover = 'Hover',
            TabBackgroundHoverTransparency = 0.97,
            TabBackgroundActive = 'Hover',
            TabBackgroundActiveTransparency = 0.93,
            TabText = 'Text',
            TabTextTransparency = 0.3,
            TabTextTransparencyActive = 0,
            TabTitle = 'Text',
            TabIcon = 'Icon',
            TabIconTransparency = 0.4,
            TabIconTransparencyActive = 0.1,
            TabBorderTransparency = 1,
            TabBorderTransparencyActive = 0.75,
            TabBorder = 'White',
            ElementBackground = 'Text',
            ElementTitle = 'Text',
            ElementDesc = 'Text',
            ElementIcon = 'Icon',
            PopupBackground = 'Background',
            PopupBackgroundTransparency = 'BackgroundTransparency',
            PopupTitle = 'Text',
            PopupContent = 'Text',
            PopupIcon = 'Icon',
            DialogBackground = 'Background',
            DialogBackgroundTransparency = 'BackgroundTransparency',
            DialogTitle = 'Text',
            DialogContent = 'Text',
            DialogIcon = 'Icon',
            Toggle = 'Button',
            ToggleBar = 'White',
            Checkbox = 'Primary',
            CheckboxIcon = 'White',
            CheckboxBorder = 'White',
            CheckboxBorderTransparency = 0.75,
            SliderIcon = 'Icon',
            Slider = 'Primary',
            SliderThumb = 'White',
            SliderIconFrom = 'SliderIcon',
            SliderIconTo = 'SliderIcon',
            Tooltip = Color3.fromHex'4C4C4C',
            TooltipText = 'White',
            TooltipSecondary = 'Primary',
            TooltipSecondaryText = 'White',
            TabSectionIcon = 'Icon',
            SectionIcon = 'Icon',
            SectionExpandIcon = 'White',
            SectionExpandIconTransparency = 0.4,
            SectionBox = 'White',
            SectionBoxTransparency = 0.95,
            SectionBoxBorder = 'White',
            SectionBoxBorderTransparency = 0.75,
            SectionBoxBackground = 'White',
            SectionBoxBackgroundTransparency = 0.95,
            SearchBarBorder = 'White',
            SearchBarBorderTransparency = 0.75,
            Notification = 'Background',
            NotificationTitle = 'Text',
            NotificationTitleTransparency = 0,
            NotificationContent = 'Text',
            NotificationContentTransparency = 0.4,
            NotificationDuration = 'White',
            NotificationDurationTransparency = 0.95,
            NotificationBorder = 'White',
            NotificationBorderTransparency = 0.75,
            DropdownTabBorder = 'White',
            LabelBackground = 'White',
            LabelBackgroundTransparency = 0.95,
        }
    end
    function a.c()
        local b = (cloneref or clonereference or function(b)
            return b
        end)
        local c = b(game:GetService'RunService')
        local d = b(game:GetService'UserInputService')
        local e = b(game:GetService'TweenService')
        local f = b(game:GetService'LocalizationService')
        local g = b(game:GetService'HttpService')
        local h = c.Heartbeat
        local i = 
[[https://raw.githubusercontent.com/Footagesus/Icons/main/Main-v2.lua]]
        local j

        if c:IsStudio() or not writefile then
            j = a.load'a'
        else
            j = loadstring(game.HttpGetAsync and game:HttpGetAsync(i) or g:GetAsync(i))()
        end

        j.SetIconsType'lucide'

        local k
        local l = {
            Font = 'rbxassetid://12187365364',
            Localization = nil,
            CanDraggable = true,
            Theme = nil,
            Themes = nil,
            Icons = j,
            Signals = {},
            Objects = {},
            LocalizationObjects = {},
            FontObjects = {},
            Language = string.match(f.SystemLocaleId, '^[a-z]+'),
            Request = http_request or (syn and syn.request) or request,
            DefaultProperties = {
                ScreenGui = {
                    ResetOnSpawn = false,
                    ZIndexBehavior = 'Sibling',
                },
                CanvasGroup = {
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.new(1, 1, 1),
                },
                Frame = {
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.new(1, 1, 1),
                },
                TextLabel = {
                    BackgroundColor3 = Color3.new(1, 1, 1),
                    BorderSizePixel = 0,
                    Text = '',
                    RichText = true,
                    TextColor3 = Color3.new(1, 1, 1),
                    TextSize = 14,
                },
                TextButton = {
                    BackgroundColor3 = Color3.new(1, 1, 1),
                    BorderSizePixel = 0,
                    Text = '',
                    AutoButtonColor = false,
                    TextColor3 = Color3.new(1, 1, 1),
                    TextSize = 14,
                },
                TextBox = {
                    BackgroundColor3 = Color3.new(1, 1, 1),
                    BorderColor3 = Color3.new(0, 0, 0),
                    ClearTextOnFocus = false,
                    Text = '',
                    TextColor3 = Color3.new(0, 0, 0),
                    TextSize = 14,
                },
                ImageLabel = {
                    BackgroundTransparency = 1,
                    BackgroundColor3 = Color3.new(1, 1, 1),
                    BorderSizePixel = 0,
                },
                ImageButton = {
                    BackgroundColor3 = Color3.new(1, 1, 1),
                    BorderSizePixel = 0,
                    AutoButtonColor = false,
                },
                UIListLayout = {
                    SortOrder = 'LayoutOrder',
                },
                ScrollingFrame = {
                    ScrollBarImageTransparency = 1,
                    BorderSizePixel = 0,
                },
                VideoFrame = {BorderSizePixel = 0},
                UIStroke = {
                    Thickness = 1,
                    ApplyStrokeMode = 'Border',
                    Transparency = 0,
                },
            },
            Colors = {
                Red = '#e53935',
                Orange = '#f57c00',
                Green = '#43a047',
                Blue = '#039be5',
                White = '#ffffff',
                Grey = '#484848',
            },
            ThemeFallbacks = a.load'b',
            Shapes = {
                Square = 'rbxassetid://82909646051652',
                ['Square-Outline'] = 'rbxassetid://72946211851948',
                Squircle = 'rbxassetid://80999662900595',
                SquircleOutline = 'rbxassetid://117788349049947',
                ['Squircle-Outline'] = 'rbxassetid://117817408534198',
                SquircleOutline2 = 'rbxassetid://117817408534198',
                ['Shadow-sm'] = 'rbxassetid://84825982946844',
                ['Squircle-TL-TR'] = 'rbxassetid://73569156276236',
                ['Squircle-BL-BR'] = 'rbxassetid://93853842912264',
                ['Squircle-TL-TR-Outline'] = 'rbxassetid://136702870075563',
                ['Squircle-BL-BR-Outline'] = 'rbxassetid://75035847706564',
                ['Glass-0.7'] = 'rbxassetid://79047752995006',
                ['Glass-1'] = 'rbxassetid://97324581055162',
                ['Glass-1.4'] = 'rbxassetid://95071123641270',
            },
            ThemeChangeCallbacks = {},
        }

        function l.Init(m)
            k = m
        end
        function l.AddSignal(m, n)
            local o = m:Connect(n)

            table.insert(l.Signals, o)

            return o
        end
        function l.DisconnectAll()
            for m, n in next, l.Signals do
                local o = table.remove(l.Signals, m)

                o:Disconnect()
            end
        end
        function l.SafeCallback(m, ...)
            if not m then
                return
            end

            local n, o = pcall(m, ...)

            if not n then
                if k and k.Window and k.Window.Debug then
                    local p, q = o:find':%d+: '

                    warn('[ IntiHub: DEBUG Mode ] ' .. o)

                    return k:Notify{
                        Title = 'DEBUG Mode: Error',
                        Content = not q and o or o:sub(q + 1),
                        Duration = 8,
                    }
                end
            end
        end
        function l.Gradient(m, n)
            if k and k.Gradient then
                return k:Gradient(m, n)
            end

            local o = {}
            local p = {}

            for q, r in next, m do
                local s = tonumber(q)

                if s then
                    s = math.clamp(s / 100, 0, 1)

                    table.insert(o, ColorSequenceKeypoint.new(s, r.Color))
                    table.insert(p, NumberSequenceKeypoint.new(s, r.Transparency or 0))
                end
            end

            table.sort(o, function(q, r)
                return q.Time < r.Time
            end)
            table.sort(p, function(q, r)
                return q.Time < r.Time
            end)

            if #o < 2 then
                error'ColorSequence requires at least 2 keypoints'
            end

            local q = {
                Color = ColorSequence.new(o),
                Transparency = NumberSequence.new(p),
            }

            if n then
                for r, s in pairs(n)do
                    q[r] = s
                end
            end

            return q
        end
        function l.SetTheme(m)
            local n = l.Theme

            l.Theme = m

            l.UpdateTheme(nil, false)

            for o, p in next, l.ThemeChangeCallbacks do
                l.SafeCallback(p, m, n)
            end
        end
        function l.AddFontObject(m)
            table.insert(l.FontObjects, m)
            l.UpdateFont(l.Font)
        end
        function l.UpdateFont(m)
            l.Font = m

            for n, o in next, l.FontObjects do
                o.FontFace = Font.new(m, o.FontFace.Weight, o.FontFace.Style)
            end
        end
        function l.GetThemeProperty(m, n)
            local o = function(o, p)
                local q = p[o]

                if q == nil then
                    return nil
                end
                if typeof(q) == 'string' and string.sub(q, 1, 1) == '#' then
                    return Color3.fromHex(q)
                end
                if typeof(q) == 'Color3' then
                    return q
                end
                if typeof(q) == 'number' then
                    return q
                end
                if typeof(q) == 'table' and q.Color and q.Transparency then
                    return q
                end
                if typeof(q) == 'function' then
                    return q()
                end

                return q
            end
            local p = o(m, n)

            if p ~= nil then
                if typeof(p) == 'string' and string.sub(p, 1, 1) ~= '#' then
                    local q = l.GetThemeProperty(p, n)

                    if q ~= nil then
                        return q
                    end
                else
                    return p
                end
            end

            local q = l.ThemeFallbacks[m]

            if q ~= nil then
                if typeof(q) == 'string' and string.sub(q, 1, 1) ~= '#' then
                    return l.GetThemeProperty(q, n)
                else
                    return o(m, {[m] = q})
                end
            end

            p = o(m, l.Themes.Dark)

            if p ~= nil then
                if typeof(p) == 'string' and string.sub(p, 1, 1) ~= '#' then
                    local r = l.GetThemeProperty(p, l.Themes.Dark)

                    if r ~= nil then
                        return r
                    end
                else
                    return p
                end
            end
            if q ~= nil then
                if typeof(q) == 'string' and string.sub(q, 1, 1) ~= '#' then
                    return l.GetThemeProperty(q, l.Themes.Dark)
                else
                    return o(m, {[m] = q})
                end
            end

            return nil
        end
        function l.AddThemeObject(m, n)
            if l.Objects[m] then
                for o, p in pairs(n)do
                    l.Objects[m].Properties[o] = p
                end
            else
                l.Objects[m] = {
                    Object = m,
                    Properties = n,
                }
            end

            l.UpdateTheme(m, false)

            return m
        end
        function l.AddLangObject(m)
            local n = l.LocalizationObjects[m]

            if not n then
                return
            end

            local o = n.Object

            l.SetLangForObject(m)

            return o
        end
        function l.UpdateTheme(m, n, o, p, q, r)
            local s = function(s)
                for t, u in pairs(s.Properties or {})do
                    local v = l.GetThemeProperty(u, l.Theme)

                    if v ~= nil then
                        if typeof(v) == 'Color3' then
                            local w = s.Object:FindFirstChild'LibraryGradient'

                            if w then
                                w:Destroy()
                            end
                            if o then
                                l.Tween(s.Object, p or 0.2, {[t] = v}, q or Enum.EasingStyle.Quint, r or Enum.EasingDirection.Out):Play()
                            elseif n then
                                l.Tween(s.Object, 0.08, {[t] = v}):Play()
                            else
                                s.Object[t] = v
                            end
                        elseif typeof(v) == 'table' and v.Color and v.Transparency then
                            s.Object[t] = Color3.new(1, 1, 1)

                            local w = s.Object:FindFirstChild'LibraryGradient'

                            if not w then
                                w = Instance.new'UIGradient'
                                w.Name = 'LibraryGradient'
                                w.Parent = s.Object
                            end

                            w.Color = v.Color
                            w.Transparency = v.Transparency

                            for x, y in pairs(v)do
                                if x ~= 'Color' and x ~= 'Transparency' and w[x] ~= nil then
                                    w[x] = y
                                end
                            end
                        elseif typeof(v) == 'number' then
                            if o then
                                l.Tween(s.Object, p or 0.2, {[t] = v}, q or Enum.EasingStyle.Quint, r or Enum.EasingDirection.Out):Play()
                            elseif n then
                                l.Tween(s.Object, 0.08, {[t] = v}):Play()
                            else
                                s.Object[t] = v
                            end
                        end
                    else
                        local w = s.Object:FindFirstChild'LibraryGradient'

                        if w then
                            w:Destroy()
                        end
                    end
                end
            end

            if m then
                local t = l.Objects[m]

                if t then
                    s(t)
                end
            else
                for t, u in pairs(l.Objects)do
                    s(u)
                end
            end
        end
        function l.SetThemeTag(m, n, o, p, q)
            l.AddThemeObject(m, n)
            l.UpdateTheme(m, false, true, o, p, q)
        end
        function l.SetLangForObject(m)
            if l.Localization and l.Localization.Enabled then
                local n = l.LocalizationObjects[m]

                if not n then
                    return
                end

                local o = n.Object
                local p = n.TranslationId
                local q = l.Localization.Translations[l.Language]

                if q and q[p] then
                    o.Text = q[p]
                else
                    local r = l.Localization and l.Localization.Translations and l.Localization.Translations.en or nil

                    if r and r[p] then
                        o.Text = r[p]
                    else
                        o.Text = '[' .. p .. ']'
                    end
                end
            end
        end
        function l.ChangeTranslationKey(m, n, o)
            if l.Localization and l.Localization.Enabled then
                local p = string.match(o, '^' .. l.Localization.Prefix .. '(.+)')

                if p then
                    for q, r in ipairs(l.LocalizationObjects)do
                        if r.Object == n then
                            r.TranslationId = p

                            l.SetLangForObject(q)

                            return
                        end
                    end

                    table.insert(l.LocalizationObjects, {
                        TranslationId = p,
                        Object = n,
                    })
                    l.SetLangForObject(#l.LocalizationObjects)
                end
            end
        end
        function l.UpdateLang(m)
            if m then
                l.Language = m
            end

            for n = 1, #l.LocalizationObjects do
                local o = l.LocalizationObjects[n]

                if o.Object and o.Object.Parent ~= nil then
                    l.SetLangForObject(n)
                else
                    l.LocalizationObjects[n] = nil
                end
            end
        end
        function l.SetLanguage(m)
            l.Language = m

            l.UpdateLang()
        end
        function l.Icon(m, n)
            return j.Icon2(m, nil, n ~= false)
        end
        function l.AddIcons(m, n)
            return j.AddIcons(m, n)
        end
        function l.New(m, n, o)
            local p = Instance.new(m)

            for q, r in next, l.DefaultProperties[m] or {}do
                p[q] = r
            end
            for q, r in next, n or {}do
                if q ~= 'ThemeTag' then
                    p[q] = r
                end
                if l.Localization and l.Localization.Enabled and q == 'Text' then
                    local s = string.match(r, '^' .. l.Localization.Prefix .. '(.+)')

                    if s then
                        local t = #l.LocalizationObjects + 1

                        l.LocalizationObjects[t] = {
                            TranslationId = s,
                            Object = p,
                        }

                        l.SetLangForObject(t)
                    end
                end
            end
            for q, r in next, o or {}do
                r.Parent = p
            end

            if n and n.ThemeTag then
                l.AddThemeObject(p, n.ThemeTag)
            end
            if n and n.FontFace then
                l.AddFontObject(p)
            end

            return p
        end
        function l.Tween(m, n, o, ...)
            return e:Create(m, TweenInfo.new(n, ...), o)
        end
        function l.NewRoundFrame(m, n, o, p, q, r)
            local s = function(s)
                return l.Shapes[s]
            end
            local t = function(t)
                return not table.find({
                    'Shadow-sm',
                    'Glass-0.7',
                    'Glass-1',
                    'Glass-1.4',
                }, t) and Rect.new(256, 256, 256, 256) or Rect.new(512, 512, 512, 512)
            end
            local u = l.New(q and 'ImageButton' or 'ImageLabel', {
                Image = s(n),
                ScaleType = 'Slice',
                SliceCenter = t(n),
                SliceScale = 1,
                BackgroundTransparency = 1,
                ThemeTag = o.ThemeTag and o.ThemeTag,
            }, p)

            for v, w in pairs(o or {})do
                if v ~= 'ThemeTag' then
                    u[v] = w
                end
            end

            local v = function(v)
                local w = not table.find({
                    'Shadow-sm',
                    'Glass-0.7',
                    'Glass-1',
                    'Glass-1.4',
                }, n) and (v / (256)) or (v / 512)

                u.SliceScale = math.max(w, 0.0001)
            end
            local w = {}

            function w.SetRadius(x, y)
                v(y)
            end
            function w.SetType(x, y)
                n = y
                u.Image = s(y)
                u.SliceCenter = t(y)

                v(m)
            end
            function w.UpdateShape(x, y, z)
                if z then
                    n = z
                    u.Image = s(z)
                    u.SliceCenter = t(z)
                end
                if y then
                    m = y
                end

                v(m)
            end
            function w.GetRadius(x)
                return m
            end
            function w.GetType(x)
                return n
            end

            v(m)

            return u, r and w or nil
        end

        local m = l.New
        local n = l.Tween

        function l.SetDraggable(o)
            l.CanDraggable = o
        end
        function l.Drag(o, p, q)
            local r
            local s, t, u
            local v = {CanDraggable = true}

            if not p or typeof(p) ~= 'table' then
                p = {o}
            end

            local w = function(w)
                if not s or not v.CanDraggable then
                    return
                end

                local x = w.Position - t

                l.Tween(o, 0.02, {
                    Position = UDim2.new(u.X.Scale, u.X.Offset + x.X, u.Y.Scale, u.Y.Offset + x.Y),
                }):Play()
            end

            for x, y in pairs(p)do
                y.InputBegan:Connect(function(z)
                    if (z.UserInputType == Enum.UserInputType.MouseButton1 or z.UserInputType == Enum.UserInputType.Touch) and v.CanDraggable then
                        if r == nil then
                            r = y
                            s = true
                            t = z.Position
                            u = o.Position

                            if q and typeof(q) == 'function' then
                                q(true, r)
                            end

                            z.Changed:Connect(function()
                                if z.UserInputState == Enum.UserInputState.End then
                                    s = false
                                    r = nil

                                    if q and typeof(q) == 'function' then
                                        q(false, nil)
                                    end
                                end
                            end)
                        end
                    end
                end)
                y.InputChanged:Connect(function(z)
                    if s and r == y then
                        if z.UserInputType == Enum.UserInputType.MouseMovement or z.UserInputType == Enum.UserInputType.Touch then
                            w(z)
                        end
                    end
                end)
            end

            d.InputChanged:Connect(function(x)
                if s and r ~= nil then
                    if x.UserInputType == Enum.UserInputType.MouseMovement or x.UserInputType == Enum.UserInputType.Touch then
                        w(x)
                    end
                end
            end)

            function v.Set(x, y)
                v.CanDraggable = y
            end

            return v
        end

        j.Init(m, 'Icon')

        function l.SanitizeFilename(o)
            local p = o:match'([^/]+)$' or o

            p = p:gsub('%.[^%.]+$', '')
            p = p:gsub('[^%w%-_]', '_')

            if #p > 50 then
                p = p:sub(1, 50)
            end

            return p
        end
        function l.GetAsset(o, p, q, r)
            p = p or 'Temp'
            r = l.SanitizeFilename(r or 'Asset')
            q = q or 'Image'

            local s = 'IntiHub_Data/' .. p .. '/assets/.' .. q .. '-' .. r .. '.png'

            if not c:IsStudio() and isfile and isfile(s) then
                return getcustomasset(s)
            end
            if string.find(o, 'http') then
                local t, u = pcall(function()
                    local t = l.Request and l.Request{
                        Url = o,
                        Method = 'GET',
                    }.Body or ''

                    if not c:IsStudio() and writefile then
                        makefolder('IntiHub_Data/' .. p .. '/assets')
                        writefile(s, t)

                        return getcustomasset(s)
                    end
                end)

                if t and u then
                    return u
                end
            end

            return o
        end
        function l.Image(o, p, q, r, s, t, u, v)
            r = r or 'Temp'
            p = l.SanitizeFilename(p)

            local w = m('Frame', {
                Size = UDim2.new(0, 0, 0, 0),
                BackgroundTransparency = 1,
            }, {
                m('ImageLabel', {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    ScaleType = 'Crop',
                    ThemeTag = (l.Icon(o) or u) and {
                        ImageColor3 = t and (v or 'Icon') or nil,
                    } or nil,
                }, {
                    m('UICorner', {
                        CornerRadius = UDim.new(0, q),
                    }),
                }),
            })

            if l.Icon(o) then
                w.ImageLabel:Destroy()

                local x = j.Image{
                    Icon = o,
                    Size = UDim2.new(1, 0, 1, 0),
                    Colors = {
                        (t and (v or 'Icon') or false),
                        'Button',
                    },
                }.IconFrame

                x.Parent = w
            elseif string.find(o, 'http') then
                local x = 'IntiHub_Data/' .. r .. '/assets/.' .. s .. '-' .. p .. '.png'
                local y, z = pcall(function()
                    task.spawn(function()
                        local y = l.Request and l.Request{
                            Url = o,
                            Method = 'GET',
                        }.Body or {}

                        if not c:IsStudio() and writefile then
                            writefile(x, y)
                        end

                        local z, A = pcall(getcustomasset, x)

                        if z then
                            w.ImageLabel.Image = A
                        else
                            warn(string.format("[ IntiHub.Creator ] Failed to load custom asset '%s': %s", x, tostring(A)))
                            w:Destroy()

                            return
                        end
                    end)
                end)

                if not y then
                    warn("[ IntiHub.Creator ]  '" .. identifyexecutor() or 'Studio' .. "' doesnt support the URL Images. Error: " .. z)
                    w:Destroy()
                end
            elseif o == '' then
                w.Visible = false
            else
                w.ImageLabel.Image = o
            end

            return w
        end
        function l.Color3ToHSB(o)
            local p, q, r = o.R, o.G, o.B
            local s = math.max(p, q, r)
            local t = math.min(p, q, r)
            local u = s - t
            local v = 0

            if u ~= 0 then
                if s == p then
                    v = (q - r) / u % 6
                elseif s == q then
                    v = (r - p) / u + 2
                else
                    v = (p - q) / u + 4
                end

                v = v * 60
            else
                v = 0
            end

            local w = (s == 0) and 0 or (u / s)
            local x = s

            return {
                h = math.floor(v + 0.5),
                s = w,
                b = x,
            }
        end
        function l.GetPerceivedBrightness(o)
            local p = o.R
            local q = o.G
            local r = o.B

            return 0.299 * p + 0.587 * q + 0.114 * r
        end
        function l.GetTextColorForHSB(o, p)
            local q = l.Color3ToHSB(o)
            local r, s, t = q.h, q.s, q.b

            if l.GetPerceivedBrightness(o) > (p or 0.5) then
                return Color3.fromHSV(r / 360, 0, 0.05)
            else
                return Color3.fromHSV(r / 360, 0, 0.98)
            end
        end
        function l.GetAverageColor(o)
            local p, q, r = 0, 0, 0
            local s = o.Color.Keypoints

            for t, u in ipairs(s)do
                p = p + u.Value.R
                q = q + u.Value.G
                r = r + u.Value.B
            end

            local t = #s

            return Color3.new(p / t, q / t, r / t)
        end
        function l.GenerateUniqueID(o)
            return g:GenerateGUID(false)
        end
        function l.OnThemeChange(o, p)
            if typeof(p) ~= 'function' then
                return
            end

            local q = g:GenerateGUID(false)

            l.ThemeChangeCallbacks[q] = p

            return {
                Disconnect = function()
                    l.ThemeChangeCallbacks[q] = nil
                end,
            }
        end

        return l
    end
    function a.d()
        local b = {}

        function b.New(c, d, e)
            local f = {
                Enabled = d.Enabled or false,
                Translations = d.Translations or {},
                Prefix = d.Prefix or 'loc:',
                DefaultLanguage = d.DefaultLanguage or 'en',
            }

            e.Localization = f

            return f
        end

        return b
    end
    function a.e()
        local b = a.load'c'
        local c = b.New
        local d = b.Tween
        local e = {
            Size = UDim2.new(0, 300, 1, -156),
            SizeLower = UDim2.new(0, 300, 1, -56),
            UICorner = 18,
            UIPadding = 14,
            Holder = nil,
            NotificationIndex = 0,
            Notifications = {},
        }

        function e.Init(f)
            local g = {Lower = false}

            function g.SetLower(i)
                g.Lower = i
                g.Frame.Size = i and e.SizeLower or e.Size
            end

            g.Frame = c('Frame', {
                Position = UDim2.new(1, -29, 0, 56),
                AnchorPoint = Vector2.new(1, 0),
                Size = e.Size,
                Parent = f,
                BackgroundTransparency = 1,
            }, {
                c('UIListLayout', {
                    HorizontalAlignment = 'Center',
                    SortOrder = 'LayoutOrder',
                    VerticalAlignment = 'Bottom',
                    Padding = UDim.new(0, 8),
                }),
                c('UIPadding', {
                    PaddingBottom = UDim.new(0, 29),
                }),
            })

            return g
        end
        function e.New(f)
            local g = {
                Title = f.Title or 'Notification',
                Content = f.Content or nil,
                Icon = f.Icon or nil,
                IconThemed = f.IconThemed,
                Background = f.Background,
                BackgroundImageTransparency = f.BackgroundImageTransparency,
                Duration = f.Duration or 5,
                Buttons = f.Buttons or {},
                CanClose = f.CanClose ~= false,
                UIElements = {},
                Closed = false,
            }

            e.NotificationIndex = e.NotificationIndex + 1
            e.Notifications[e.NotificationIndex] = g

            local i

            if g.Icon then
                i = b.Image(g.Icon, g.Title .. ':' .. g.Icon, 0, f.Window, 'Notification', g.IconThemed)
                i.Size = UDim2.new(0, 26, 0, 26)
                i.Position = UDim2.new(0, e.UIPadding, 0, e.UIPadding)
            end

            local j

            if g.CanClose then
                j = c('ImageButton', {
                    Image = b.Icon'x'[1],
                    ImageRectSize = b.Icon'x'[2].ImageRectSize,
                    ImageRectOffset = b.Icon'x'[2].ImageRectPosition,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 16, 0, 16),
                    Position = UDim2.new(1, -e.UIPadding, 0, e.UIPadding),
                    AnchorPoint = Vector2.new(1, 0),
                    ThemeTag = {
                        ImageColor3 = 'Text',
                    },
                    ImageTransparency = 0.4,
                }, {
                    c('TextButton', {
                        Size = UDim2.new(1, 8, 1, 8),
                        BackgroundTransparency = 1,
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Position = UDim2.new(0.5, 0, 0.5, 0),
                        Text = '',
                    }),
                })
            end

            local k = b.NewRoundFrame(e.UICorner, 'Squircle', {
                Size = UDim2.new(0, 0, 1, 0),
                ThemeTag = {
                    ImageTransparency = 'NotificationDurationTransparency',
                    ImageColor3 = 'NotificationDuration',
                },
            })
            local l = c('Frame', {
                Size = UDim2.new(1, g.Icon and -28 - e.UIPadding or 0, 1, 0),
                Position = UDim2.new(1, 0, 0, 0),
                AnchorPoint = Vector2.new(1, 0),
                BackgroundTransparency = 1,
                AutomaticSize = 'Y',
            }, {
                c('UIPadding', {
                    PaddingTop = UDim.new(0, e.UIPadding),
                    PaddingLeft = UDim.new(0, e.UIPadding),
                    PaddingRight = UDim.new(0, e.UIPadding),
                    PaddingBottom = UDim.new(0, e.UIPadding),
                }),
                c('TextLabel', {
                    AutomaticSize = 'Y',
                    Size = UDim2.new(1, -30 - e.UIPadding, 0, 0),
                    TextWrapped = true,
                    TextXAlignment = 'Left',
                    RichText = true,
                    BackgroundTransparency = 1,
                    TextSize = 18,
                    ThemeTag = {
                        TextColor3 = 'NotificationTitle',
                        TextTransparency = 'NotificationTitleTransparency',
                    },
                    Text = g.Title,
                    FontFace = Font.new(b.Font, Enum.FontWeight.SemiBold),
                }),
                c('UIListLayout', {
                    Padding = UDim.new(0, e.UIPadding / 3),
                }),
            })

            if g.Content then
                c('TextLabel', {
                    AutomaticSize = 'Y',
                    Size = UDim2.new(1, 0, 0, 0),
                    TextWrapped = true,
                    TextXAlignment = 'Left',
                    RichText = true,
                    BackgroundTransparency = 1,
                    TextSize = 15,
                    ThemeTag = {
                        TextColor3 = 'NotificationContent',
                        TextTransparency = 'NotificationContentTransparency',
                    },
                    Text = g.Content,
                    FontFace = Font.new(b.Font, Enum.FontWeight.Medium),
                    Parent = l,
                })
            end

            local m = b.NewRoundFrame(e.UICorner, 'Squircle', {
                Size = UDim2.new(1, 0, 0, 0),
                Position = UDim2.new(2, 0, 1, 0),
                AnchorPoint = Vector2.new(0, 1),
                AutomaticSize = 'Y',
                ImageTransparency = 0.05,
                ThemeTag = {
                    ImageColor3 = 'Notification',
                },
            }, {
                b.NewRoundFrame(e.UICorner, 'Glass-1', {
                    Size = UDim2.new(1, 0, 1, 0),
                    ThemeTag = {
                        ImageColor3 = 'NotificationBorder',
                        ImageTransparency = 'NotificationBorderTransparency',
                    },
                }),
                c('Frame', {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Name = 'DurationFrame',
                }, {
                    c('Frame', {
                        Size = UDim2.new(1, 0, 1, 0),
                        BackgroundTransparency = 1,
                        ClipsDescendants = true,
                    }, {k}),
                }),
                c('ImageLabel', {
                    Name = 'Background',
                    Image = g.Background,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    ScaleType = 'Crop',
                    ImageTransparency = g.BackgroundImageTransparency,
                }, {
                    c('UICorner', {
                        CornerRadius = UDim.new(0, e.UICorner),
                    }),
                }),
                l,
                i,
                j,
            })
            local n = c('Frame', {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 0),
                Parent = f.Holder,
            }, {m})

            function g.Close(o)
                if not g.Closed then
                    g.Closed = true

                    d(n, 0.45, {
                        Size = UDim2.new(1, 0, 0, -8),
                    }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                    d(m, 0.55, {
                        Position = UDim2.new(2, 0, 1, 0),
                    }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                    task.wait(0.45)
                    n:Destroy()
                end
            end

            task.spawn(function()
                task.wait()
                d(n, 0.45, {
                    Size = UDim2.new(1, 0, 0, m.AbsoluteSize.Y),
                }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                d(m, 0.45, {
                    Position = UDim2.new(0, 0, 1, 0),
                }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()

                if g.Duration then
                    k.Size = UDim2.new(0, m.DurationFrame.AbsoluteSize.X, 1, 0)

                    d(m.DurationFrame.Frame, g.Duration, {
                        Size = UDim2.new(0, 0, 1, 0),
                    }, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut):Play()
                    task.wait(g.Duration)
                    g:Close()
                end
            end)

            if j then
                b.AddSignal(j.TextButton.MouseButton1Click, function()
                    g:Close()
                end)
            end

            return g
        end

        return e
    end
    function a.f()
        local b = 4294967296
        local c = b - 1
        local d = function(d, e)
            local f, g = 0, 1

            while d ~= 0 or e ~= 0 do
                local i, j = d % 2, e % 2
                local k = (i + j) % 2

                f = f + k * g
                d = math.floor(d / 2)
                e = math.floor(e / 2)
                g = g * 2
            end

            return f % b
        end

        local function e(f, g, i, ...)
            local j

            if g then
                f = f % b
                g = g % b
                j = d(f, g)

                if i then
                    j = e(j, i, ...)
                end

                return j
            elseif f then
                return f % b
            else
                return 0
            end
        end
        local function f(g, i, j, ...)
            local k

            if i then
                g = g % b
                i = i % b
                k = (g + i - d(g, i)) / 2

                if j then
                    k = f(k, j, ...)
                end

                return k
            elseif g then
                return g % b
            else
                return c
            end
        end

        local g = function(g)
            return c - g
        end
        local i = function(i, j)
            if j < 0 then
                return lshift(i, -j)
            end

            return math.floor(i % 4294967296 / 2 ^ j)
        end
        local j = function(j, k)
            if k > 31 or k < -31 then
                return 0
            end

            return i(j % b, k)
        end
        local k = function(k, l)
            if l < 0 then
                return j(k, -l)
            end

            return k * 2 ^ l % 4294967296
        end
        local l = function(l, m)
            l = l % b
            m = m % 32

            local n = f(l, 2 ^ m - 1)

            return j(l, m) + k(n, 32 - m)
        end
        local m = {
            0x428a2f98,
            0x71374491,
            0xb5c0fbcf,
            0xe9b5dba5,
            0x3956c25b,
            0x59f111f1,
            0x923f82a4,
            0xab1c5ed5,
            0xd807aa98,
            0x12835b01,
            0x243185be,
            0x550c7dc3,
            0x72be5d74,
            0x80deb1fe,
            0x9bdc06a7,
            0xc19bf174,
            0xe49b69c1,
            0xefbe4786,
            0xfc19dc6,
            0x240ca1cc,
            0x2de92c6f,
            0x4a7484aa,
            0x5cb0a9dc,
            0x76f988da,
            0x983e5152,
            0xa831c66d,
            0xb00327c8,
            0xbf597fc7,
            0xc6e00bf3,
            0xd5a79147,
            0x6ca6351,
            0x14292967,
            0x27b70a85,
            0x2e1b2138,
            0x4d2c6dfc,
            0x53380d13,
            0x650a7354,
            0x766a0abb,
            0x81c2c92e,
            0x92722c85,
            0xa2bfe8a1,
            0xa81a664b,
            0xc24b8b70,
            0xc76c51a3,
            0xd192e819,
            0xd6990624,
            0xf40e3585,
            0x106aa070,
            0x19a4c116,
            0x1e376c08,
            0x2748774c,
            0x34b0bcb5,
            0x391c0cb3,
            0x4ed8aa4a,
            0x5b9cca4f,
            0x682e6ff3,
            0x748f82ee,
            0x78a5636f,
            0x84c87814,
            0x8cc70208,
            0x90befffa,
            0xa4506ceb,
            0xbef9a3f7,
            0xc67178f2,
        }
        local n = function(n)
            return string.gsub(n, '.', function(o)
                return string.format('%02x', string.byte(o))
            end)
        end
        local o = function(o, p)
            local q = ''

            for r = 1, p do
                local s = o % 256

                q = string.char(s) .. q
                o = (o - s) / 256
            end

            return q
        end
        local p = function(p, q)
            local r = 0

            for s = q, q + 3 do
                r = r * 256 + string.byte(p, s)
            end

            return r
        end
        local q = function(q, r)
            local s = 64 - (r + 9) % 64

            r = o(8 * r, 8)
            q = q .. '\128' .. string.rep('\0', s) .. r

            assert(#q % 64 == 0)

            return q
        end
        local r = function(r)
            r[1] = 0x6a09e667
            r[2] = 0xbb67ae85
            r[3] = 0x3c6ef372
            r[4] = 0xa54ff53a
            r[5] = 0x510e527f
            r[6] = 0x9b05688c
            r[7] = 0x1f83d9ab
            r[8] = 0x5be0cd19

            return r
        end
        local s = function(s, t, u)
            local v = {}

            for w = 1, 16 do
                v[w] = p(s, t + (w - 1) * 4)
            end
            for w = 17, 64 do
                local x = v[w - 15]
                local y = e(l(x, 7), l(x, 18), j(x, 3))

                x = v[w - 2]
                v[w] = (v[w - 16] + y + v[w - 7] + e(l(x, 17), l(x, 19), j(x, 10))) % b
            end

            local w, x, y, z, A, B, C, D = u[1], u[2], u[3], u[4], u[5], u[6], u[7], u[8]

            for E = 1, 64 do
                local F = e(l(w, 2), l(w, 13), l(w, 22))
                local G = e(f(w, x), f(w, y), f(x, y))
                local H = (F + G) % b
                local I = e(l(A, 6), l(A, 11), l(A, 25))
                local J = e(f(A, B), f(g(A), C))
                local K = (D + I + J + m[E] + v[E]) % b

                D = C
                C = B
                B = A
                A = (z + K) % b
                z = y
                y = x
                x = w
                w = (K + H) % b
            end

            u[1] = (u[1] + w) % b
            u[2] = (u[2] + x) % b
            u[3] = (u[3] + y) % b
            u[4] = (u[4] + z) % b
            u[5] = (u[5] + A) % b
            u[6] = (u[6] + B) % b
            u[7] = (u[7] + C) % b
            u[8] = (u[8] + D) % b
        end
        local t = function(t)
            t = q(t, #t)

            local u = r{}

            for v = 1, #t, 64 do
                s(t, v, u)
            end

            return n(o(u[1], 4) .. o(u[2], 4) .. o(u[3], 4) .. o(u[4], 4) .. o(u[5], 4) .. o(u[6], 4) .. o(u[7], 4) .. o(u[8], 4))
        end
        local u
        local v = {
            ['\\'] = '\\',
            ['"'] = '"',
            ['\b'] = 'b',
            ['\f'] = 'f',
            ['\n'] = 'n',
            ['\r'] = 'r',
            ['\t'] = 't',
        }
        local w = {
            ['/'] = '/',
        }

        for x, y in pairs(v)do
            w[y] = x
        end

        local x = function(x)
            return '\\' .. (v[x] or string.format('u%04x', x:byte()))
        end
        local y = function(y)
            return 'null'
        end
        local z = function(z, A)
            local B = {}

            A = A or {}

            if A[z] then
                error'circular reference'
            end

            A[z] = true

            if rawget(z, 1) ~= nil or next(z) == nil then
                local C = 0

                for D in pairs(z)do
                    if type(D) ~= 'number' then
                        error'invalid table: mixed or invalid key types'
                    end

                    C = C + 1
                end

                if C ~= #z then
                    error'invalid table: sparse array'
                end

                for D, E in ipairs(z)do
                    table.insert(B, u(E, A))
                end

                A[z] = nil

                return '[' .. table.concat(B, ',') .. ']'
            else
                for C, D in pairs(z)do
                    if type(C) ~= 'string' then
                        error'invalid table: mixed or invalid key types'
                    end

                    table.insert(B, u(C, A) .. ':' .. u(D, A))
                end

                A[z] = nil

                return '{' .. table.concat(B, ',') .. '}'
            end
        end
        local A = function(A)
            return '"' .. A:gsub('[%z\1-\31\\"]', x) .. '"'
        end
        local B = function(B)
            if B ~= B or B <= -math.huge or B >= math.huge then
                error("unexpected number value '" .. tostring(B) .. "'")
            end

            return string.format('%.14g', B)
        end
        local C = {
            ['nil'] = y,
            table = z,
            string = A,
            number = B,
            boolean = tostring,
        }

        u = function(D, E)
            local F = type(D)
            local G = C[F]

            if G then
                return G(D, E)
            end

            error("unexpected type '" .. F .. "'")
        end

        local D = function(D)
            return u(D)
        end
        local E
        local F = function(...)
            local F = {}

            for G = 1, select('#', ...)do
                F[select(G, ...)] = true
            end

            return F
        end
        local G = F(' ', '\t', '\r', '\n')
        local H = F(' ', '\t', '\r', '\n', ']', '}', ',')
        local I = F('\\', '/', '"', 'b', 'f', 'n', 'r', 't', 'u')
        local J = F('true', 'false', 'null')
        local K = {
            ['true'] = true,
            ['false'] = false,
            null = nil,
        }
        local L = function(L, M, N, O)
            for P = M, #L do
                if N[L:sub(P, P)] ~= O then
                    return P
                end
            end

            return #L + 1
        end
        local M = function(M, N, O)
            local P = 1
            local Q = 1

            for R = 1, N - 1 do
                Q = Q + 1

                if M:sub(R, R) == '\n' then
                    P = P + 1
                    Q = 1
                end
            end

            error(string.format('%s at line %d col %d', O, P, Q))
        end
        local N = function(N)
            local O = math.floor

            if N <= 0x7f then
                return string.char(N)
            elseif N <= 0x7ff then
                return string.char(O(N / 64) + 192, N % 64 + 128)
            elseif N <= 0xffff then
                return string.char(O(N / 4096) + 224, O(N % 4096 / 64) + 128, N % 64 + 128)
            elseif N <= 0x10ffff then
                return string.char(O(N / 262144) + 240, O(N % 262144 / 4096) + 128, O(N % 4096 / 64) + 128, N % 64 + 128)
            end

            error(string.format("invalid unicode codepoint '%x'", N))
        end
        local O = function(O)
            local P = tonumber(O:sub(1, 4), 16)
            local Q = tonumber(O:sub(7, 10), 16)

            if Q then
                return N((P - 0xd800) * 0x400 + Q - 0xdc00 + 0x10000)
            else
                return N(P)
            end
        end
        local P = function(P, Q)
            local R = ''
            local S = Q + 1
            local T = S

            while S <= #P do
                local U = P:byte(S)

                if U < 32 then
                    M(P, S, 'control character in string')
                elseif U == 92 then
                    R = R .. P:sub(T, S - 1)
                    S = S + 1

                    local V = P:sub(S, S)

                    if V == 'u' then
                        local W = P:match('^[dD][89aAbB]%x%x\\u%x%x%x%x', S + 1) or P:match('^%x%x%x%x', S + 1) or M(P, S - 1, 'invalid unicode escape in string')

                        R = R .. O(W)
                        S = S + #W
                    else
                        if not I[V] then
                            M(P, S - 1, "invalid escape char '" .. V .. "' in string")
                        end

                        R = R .. w[V]
                    end

                    T = S + 1
                elseif U == 34 then
                    R = R .. P:sub(T, S - 1)

                    return R, S + 1
                end

                S = S + 1
            end

            M(P, Q, 'expected closing quote for string')
        end
        local Q = function(Q, R)
            local S = L(Q, R, H)
            local T = Q:sub(R, S - 1)
            local U = tonumber(T)

            if not U then
                M(Q, R, "invalid number '" .. T .. "'")
            end

            return U, S
        end
        local R = function(R, S)
            local T = L(R, S, H)
            local U = R:sub(S, T - 1)

            if not J[U] then
                M(R, S, "invalid literal '" .. U .. "'")
            end

            return K[U], T
        end
        local S = function(S, T)
            local U = {}
            local V = 1

            T = T + 1

            while 1 do
                local W

                T = L(S, T, G, true)

                if S:sub(T, T) == ']' then
                    T = T + 1

                    break
                end

                W, T = E(S, T)
                U[V] = W
                V = V + 1
                T = L(S, T, G, true)

                local X = S:sub(T, T)

                T = T + 1

                if X == ']' then
                    break
                end
                if X ~= ',' then
                    M(S, T, "expected ']' or ','")
                end
            end

            return U, T
        end
        local T = function(T, U)
            local V = {}

            U = U + 1

            while 1 do
                local W, X

                U = L(T, U, G, true)

                if T:sub(U, U) == '}' then
                    U = U + 1

                    break
                end
                if T:sub(U, U) ~= '"' then
                    M(T, U, 'expected string for key')
                end

                W, U = E(T, U)
                U = L(T, U, G, true)

                if T:sub(U, U) ~= ':' then
                    M(T, U, "expected ':' after key")
                end

                U = L(T, U + 1, G, true)
                X, U = E(T, U)
                V[W] = X
                U = L(T, U, G, true)

                local Y = T:sub(U, U)

                U = U + 1

                if Y == '}' then
                    break
                end
                if Y ~= ',' then
                    M(T, U, "expected '}' or ','")
                end
            end

            return V, U
        end
        local U = {
            ['"'] = P,
            ['0'] = Q,
            ['1'] = Q,
            ['2'] = Q,
            ['3'] = Q,
            ['4'] = Q,
            ['5'] = Q,
            ['6'] = Q,
            ['7'] = Q,
            ['8'] = Q,
            ['9'] = Q,
            ['-'] = Q,
            t = R,
            f = R,
            n = R,
            ['['] = S,
            ['{'] = T,
        }

        E = function(V, W)
            local X = V:sub(W, W)
            local Y = U[X]

            if Y then
                return Y(V, W)
            end

            M(V, W, "unexpected character '" .. X .. "'")
        end

        local V = function(V)
            if type(V) ~= 'string' then
                error('expected argument of type string, got ' .. type(V))
            end

            local W, X = E(V, L(V, 1, G, true))

            X = L(V, X, G, true)

            if X <= #V then
                M(V, X, 'trailing garbage')
            end

            return W
        end
        local W, X, Y = D, V, t
        local Z = {}
        local _ = (cloneref or clonereference or function(_)
            return _
        end)

        function Z.New(aa, ab)
            local ac = aa
            local ad = ab
            local ae = true
            local af = function(af) end

            repeat
                task.wait(1)
            until game:IsLoaded()

            local ag = false
            local ah, ai, aj, ak, al, am, an, ao, ap = setclipboard or toclipboard, request or http_request or syn_request, string.char, tostring, string.sub, os.time, math.random, math.floor, gethwid or function(
            )
                return _(game:GetService'Players').LocalPlayer.UserId
            end
            local aq, ar = '', 0
            local as = 'https://api.platoboost.app'
            local at = ai{
                Url = as .. '/public/connectivity',
                Method = 'GET',
            }

            if at.StatusCode ~= 200 and at.StatusCode ~= 429 then
                as = 'https://api.platoboost.net'
            end

            function cacheLink()
                if ar + (600) < am() then
                    local au = ai{
                        Url = as .. '/public/start',
                        Method = 'POST',
                        Body = W{
                            service = ac,
                            identifier = Y(ap()),
                        },
                        Headers = {
                            ['Content-Type'] = 'application/json',
                            ['User-Agent'] = 'Roblox/Exploit',
                        },
                    }

                    if au.StatusCode == 200 then
                        local av = X(au.Body)

                        if av.success == true then
                            aq = av.data.url
                            ar = am()

                            return true, aq
                        else
                            af(av.message)

                            return false, av.message
                        end
                    elseif au.StatusCode == 429 then
                        local av = 
[[you are being rate limited, please wait 20 seconds and try again.]]

                        af(av)

                        return false, av
                    end

                    local av = 'Failed to cache link.'

                    af(av)

                    return false, av
                else
                    return true, aq
                end
            end

            cacheLink()

            local au = function()
                local au = ''

                for av = 1, 16 do
                    au = au .. aj(ao(an() * (26)) + 97)
                end

                return au
            end

            for av = 1, 5 do
                local aw = au()

                task.wait(0.2)

                if au() == aw then
                    local ax = 'platoboost nonce error.'

                    af(ax)
                    error(ax)
                end
            end

            local av = function()
                local av, aw = cacheLink()

                if av then
                    ah(aw)
                end
            end
            local aw = function(aw)
                local ax = au()
                local ay = as .. '/public/redeem/' .. ak(ac)
                local az = {
                    identifier = Y(ap()),
                    key = aw,
                }

                if ae then
                    az.nonce = ax
                end

                local aA = ai{
                    Url = ay,
                    Method = 'POST',
                    Body = W(az),
                    Headers = {
                        ['Content-Type'] = 'application/json',
                    },
                }

                if aA.StatusCode == 200 then
                    local aB = X(aA.Body)

                    if aB.success == true then
                        if aB.data.valid == true then
                            if ae then
                                if aB.data.hash == Y('true' .. '-' .. ax .. '-' .. ad) then
                                    return true
                                else
                                    af'failed to verify integrity.'

                                    return false
                                end
                            else
                                return true
                            end
                        else
                            af'key is invalid.'

                            return false
                        end
                    else
                        if al(aB.message, 1, 27) == 'unique constraint violation' then
                            af
[[you already have an active key, please wait for it to expire before redeeming it.]]

                            return false
                        else
                            af(aB.message)

                            return false
                        end
                    end
                elseif aA.StatusCode == 429 then
                    af
[[you are being rate limited, please wait 20 seconds and try again.]]

                    return false
                else
                    af
[[server returned an invalid status code, please try again later.]]

                    return false
                end
            end
            local ax = function(ax)
                if ag == true then
                    return false, ('A request is already being sent, please slow down.')
                else
                    ag = true
                end

                local ay = au()
                local az = as .. '/public/whitelist/' .. ak(ac) .. '?identifier=' .. Y(ap()) .. '&key=' .. ax

                if ae then
                    az = az .. '&nonce=' .. ay
                end

                local aA = ai{
                    Url = az,
                    Method = 'GET',
                }

                ag = false

                if aA.StatusCode == 200 then
                    local aB = X(aA.Body)

                    if aB.success == true then
                        if aB.data.valid == true then
                            if ae then
                                if aB.data.hash == Y('true' .. '-' .. ay .. '-' .. ad) then
                                    return true, ''
                                else
                                    return false, ('failed to verify integrity.')
                                end
                            else
                                return true
                            end
                        else
                            if al(ax, 1, 4) == 'KEY_' then
                                return true, aw(ax)
                            else
                                return false, ('Key is invalid.')
                            end
                        end
                    else
                        return false, (aB.message)
                    end
                elseif aA.StatusCode == 429 then
                    return false, (
[[You are being rate limited, please wait 20 seconds and try again.]])
                else
                    return false, (
[[Server returned an invalid status code, please try again later.]])
                end
            end
            local ay = function(ay)
                local az = au()
                local aA = as .. '/public/flag/' .. ak(ac) .. '?name=' .. ay

                if ae then
                    aA = aA .. '&nonce=' .. az
                end

                local aB = ai{
                    Url = aA,
                    Method = 'GET',
                }

                if aB.StatusCode == 200 then
                    local aC = X(aB.Body)

                    if aC.success == true then
                        if ae then
                            if aC.data.hash == Y(ak(aC.data.value) .. '-' .. az .. '-' .. ad) then
                                return aC.data.value
                            else
                                af'failed to verify integrity.'

                                return nil
                            end
                        else
                            return aC.data.value
                        end
                    else
                        af(aC.message)

                        return nil
                    end
                else
                    return nil
                end
            end

            return {
                Verify = ax,
                GetFlag = ay,
                Copy = av,
            }
        end

        return Z
    end
    function a.g()
        local aa = (cloneref or clonereference or function(aa)
            return aa
        end)
        local ab = aa(game:GetService'HttpService')
        local ac = {}

        function ac.New(ad)
            local ae = gethwid or function()
                return aa(game:GetService'Players').LocalPlayer.UserId
            end
            local af, ag = request or http_request or syn_request, setclipboard or toclipboard

            function ValidateKey(ah)
                local ai = 'https://new.pandadevelopment.net/api/v1/keys/validate'
                local aj = {
                    ServiceID = ad,
                    HWID = tostring(ae()),
                    Key = tostring(ah),
                }
                local ak = ab:JSONEncode(aj)
                local al, am = pcall(function()
                    return af{
                        Url = ai,
                        Method = 'POST',
                        Headers = {
                            ['User-Agent'] = 'Roblox/Exploit',
                            ['Content-Type'] = 'application/json',
                        },
                        Body = ak,
                    }
                end)

                if al and am then
                    if am.Success then
                        local an, ao = pcall(function()
                            return ab:JSONDecode(am.Body)
                        end)

                        if an and ao then
                            if ao.Authenticated_Status and ao.Authenticated_Status == 'Success' then
                                return true, 'Authenticated'
                            else
                                local ap = ao.Note or 'Unknown reason'

                                return false, 'Authentication failed: ' .. ap
                            end
                        else
                            return false, 'JSON decode error'
                        end
                    else
                        warn(' HTTP request was not successful. Code: ' .. tostring(am.StatusCode) .. ' Message: ' .. am.StatusMessage)

                        return false, 'HTTP request failed: ' .. am.StatusMessage
                    end
                else
                    return false, 'Request pcall error'
                end
            end
            function GetKeyLink()
                return 'https://new.pandadevelopment.net/getkey/' .. tostring(ad) .. '?hwid=' .. tostring(ae())
            end
            function CopyLink()
                return ag(GetKeyLink())
            end

            return {
                Verify = ValidateKey,
                Copy = CopyLink,
            }
        end

        return ac
    end
    function a.h()
        local aa = {}

        function aa.New(ab, ac)
            local ad = 'https://sdkapi-public.luarmor.net/library.lua'
            local ae = loadstring(game.HttpGetAsync and game:HttpGetAsync(ad) or HttpService:GetAsync(ad))()
            local af = setclipboard or toclipboard

            ae.script_id = ab

            function ValidateKey(ag)
                local ah = ae.check_key(ag)

                if (ah.code == 'KEY_VALID') then
                    return true, 'Whitelisted!'
                elseif (ah.code == 'KEY_HWID_LOCKED') then
                    return false, 
[[Key linked to a different HWID. Please reset it using our bot]]
                elseif (ah.code == 'KEY_INCORRECT') then
                    return false, 'Key is wrong or deleted!'
                else
                    return false, 'Key check failed:' .. ah.message .. ' Code: ' .. ah.code
                end
            end
            function CopyLink()
                af(tostring(ac))
            end

            return {
                Verify = ValidateKey,
                Copy = CopyLink,
            }
        end

        return aa
    end
    function a.i()
        local aa = {}

        function aa.New(ab, ac, ad)
            JunkieProtected.API_KEY = ac
            JunkieProtected.PROVIDER = ad
            JunkieProtected.SERVICE_ID = ab

            local ae = function(ae)
                if not ae or ae == '' then
                    print'No key provided!'

                    return false, 'No key provided. Please get a key.'
                end

                local af = JunkieProtected.IsKeylessMode()

                if af and af.keyless_mode then
                    print'Keyless mode enabled. Starting script...'

                    return true, 'Keyless mode enabled. Starting script...'
                end

                local ag = JunkieProtected.ValidateKey{Key = ae}

                if ag == 'valid' then
                    print'Key is valid! Starting script...'
                    load()

                    if _G.JD_IsPremium then
                        print'Premium user detected!'
                    else
                        print'Standard user'
                    end

                    return true, 'Key is valid!'
                else
                    local ah = JunkieProtected.GetKeyLink()

                    print'Invalid key!'

                    return false, 'Invalid key. Get one from:' .. ah
                end
            end
            local af = function()
                local af = JunkieProtected.GetKeyLink()

                if setclipboard then
                    setclipboard(af)
                end
            end

            return {
                Verify = ae,
                Copy = af,
            }
        end

        return aa
    end
    function a.j()
        return {
            platoboost = {
                Name = 'Platoboost',
                Icon = 'rbxassetid://75920162824531',
                Args = {
                    'ServiceId',
                    'Secret',
                },
                New = a.load'f'.New,
            },
            pandadevelopment = {
                Name = 'Panda Development',
                Icon = 'panda',
                Args = {
                    'ServiceId',
                },
                New = a.load'g'.New,
            },
            luarmor = {
                Name = 'Luarmor',
                Icon = 'rbxassetid://130918283130165',
                Args = {
                    'ScriptId',
                    'Discord',
                },
                New = a.load'h'.New,
            },
            junkiedevelopment = {
                Name = 'Junkie Development',
                Icon = 'rbxassetid://106310347705078',
                Args = {
                    'ServiceId',
                    'ApiKey',
                    'Provider',
                },
                New = a.load'i'.New,
            },
        }
    end
    function a.k()
        return 
[[{
    "name": "IntiHub",
    "version": "1.7.0",
    "main": "./dist/main.lua",
    "repository": "https://github.com/Sam123mir/IntiHub-LibraryUI",
    "discord": "{{DISCORD_URL}}",
    "author": "Sammir_Inti",
    "description": "Roblox UI Library for scripts",
    "license": "MIT",
    "scripts": {
        "dev": "bash build/build.sh dev $INPUT_FILE",
        "build": "bash build/build.sh build $INPUT_FILE",
        "live": "python -m http.server 8642",
        "watch": "chokidar . -i 'node_modules' -i 'dist' -i 'build' -c 'npm run dev --'",
        "live-build": "concurrently \"npm run live\" \"npm run watch --\"",
        "example-live-build": "INPUT_FILE=main_example.lua npm run live-build",
        "updater": "python3 updater/main.py"
    },
    "keywords": [
        "ui-library",
        "ui-design",
        "script",
        "script-hub",
        "exploiting"
    ],
    "devDependencies": {
        "chokidar-cli": "^3.0.0",
        "concurrently": "^9.2.0"
    }
}
]]
    end
    function a.l()
        local aa = {}
        local ab = a.load'c'
        local ac = ab.New
        local ad = ab.Tween

        function aa.New(ae, af, ag, ah, ai, aj, ak, al)
            ah = ah or 'Primary'

            local am = al or (not ak and 14 or 99)
            local an

            if af and af ~= '' then
                an = ac('ImageLabel', {
                    Image = ab.Icon(af)[1],
                    ImageRectSize = ab.Icon(af)[2].ImageRectSize,
                    ImageRectOffset = ab.Icon(af)[2].ImageRectPosition,
                    Size = UDim2.new(0, 21, 0, 21),
                    BackgroundTransparency = 1,
                    ImageColor3 = ah == 'White' and Color3.new(0, 0, 0) or nil,
                    ImageTransparency = ah == 'White' and 0.4 or 0,
                    ThemeTag = {
                        ImageColor3 = ah ~= 'White' and 'Icon' or nil,
                    },
                })
            end

            local ao = ac('TextButton', {
                Size = UDim2.new(0, 0, 1, 0),
                AutomaticSize = 'X',
                Parent = ai,
                BackgroundTransparency = 1,
            }, {
                ab.NewRoundFrame(am, 'Squircle', {
                    ThemeTag = {
                        ImageColor3 = ah ~= 'White' and 'Button' or nil,
                    },
                    ImageColor3 = ah == 'White' and Color3.new(1, 1, 1) or nil,
                    Size = UDim2.new(1, 0, 1, 0),
                    Name = 'Squircle',
                    ImageTransparency = ah == 'Primary' and 0 or ah == 'White' and 0 or 1,
                }, {
                    ah == 'Primary' and ac('UIGradient', {
                        Rotation = 45,
                        Color = ColorSequence.new{
                            ColorSequenceKeypoint.new(0, Color3.fromHex'#FFC300'),
                            ColorSequenceKeypoint.new(1, Color3.fromHex'#FF8C00'),
                        },
                    }) or nil,
                }),
                ab.NewRoundFrame(am, 'Squircle', {
                    ImageColor3 = Color3.new(1, 1, 1),
                    Size = UDim2.new(1, 0, 1, 0),
                    Name = 'Special',
                    ImageTransparency = ah == 'Secondary' and 0.95 or 1,
                }),
                ab.NewRoundFrame(am, 'Shadow-sm', {
                    ImageColor3 = Color3.new(0, 0, 0),
                    Size = UDim2.new(1, 3, 1, 3),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    Name = 'Shadow',
                    ImageTransparency = 1,
                    Visible = not ak,
                }),
                ab.NewRoundFrame(am, not ak and 'Glass-1' or 'Glass-0.7', {
                    ThemeTag = {
                        ImageColor3 = 'White',
                    },
                    Size = UDim2.new(1, 0, 1, 0),
                    ImageTransparency = 0.6,
                    Name = 'Outline',
                }, {}),
                ab.NewRoundFrame(am, 'Squircle', {
                    Size = UDim2.new(1, 0, 1, 0),
                    Name = 'Frame',
                    ThemeTag = {
                        ImageColor3 = ah ~= 'White' and 'Text' or nil,
                    },
                    ImageColor3 = ah == 'White' and Color3.new(0, 0, 0) or nil,
                    ImageTransparency = 1,
                }, {
                    ac('UIPadding', {
                        PaddingLeft = UDim.new(0, 16),
                        PaddingRight = UDim.new(0, 16),
                    }),
                    ac('UIListLayout', {
                        FillDirection = 'Horizontal',
                        Padding = UDim.new(0, 8),
                        VerticalAlignment = 'Center',
                        HorizontalAlignment = 'Center',
                    }),
                    an,
                    ac('TextLabel', {
                        BackgroundTransparency = 1,
                        FontFace = Font.new(ab.Font, Enum.FontWeight.SemiBold),
                        Text = ae or 'Button',
                        ThemeTag = {
                            TextColor3 = (ah ~= 'Primary' and ah ~= 'White') and 'Text',
                        },
                        TextColor3 = ah == 'Primary' and Color3.new(1, 1, 1) or ah == 'White' and Color3.new(0, 0, 0) or nil,
                        AutomaticSize = 'XY',
                        TextSize = 18,
                    }),
                }),
            })

            ab.AddSignal(ao.MouseEnter, function()
                ad(ao.Frame, 0.047, {ImageTransparency = 0.95}):Play()
            end)
            ab.AddSignal(ao.MouseLeave, function()
                ad(ao.Frame, 0.047, {ImageTransparency = 1}):Play()
            end)
            ab.AddSignal(ao.MouseButton1Up, function()
                if aj then
                    aj:Close()()
                end
                if ag then
                    ab.SafeCallback(ag)
                end
            end)

            return ao
        end

        return aa
    end
    function a.m()
        local aa = {}
        local ab = a.load'c'
        local ac = ab.New
        local ad = ab.Tween

        function aa.New(ae, af, ag, ah, ai, aj, ak, al)
            ah = ah or 'Input'

            local am = ak or 10
            local an

            if af and af ~= '' then
                an = ac('ImageLabel', {
                    Image = ab.Icon(af)[1],
                    ImageRectSize = ab.Icon(af)[2].ImageRectSize,
                    ImageRectOffset = ab.Icon(af)[2].ImageRectPosition,
                    Size = UDim2.new(0, 21, 0, 21),
                    BackgroundTransparency = 1,
                    ThemeTag = {
                        ImageColor3 = 'Icon',
                    },
                })
            end

            local ao = ah ~= 'Input'
            local ap = ac('TextBox', {
                BackgroundTransparency = 1,
                TextSize = 17,
                FontFace = Font.new(ab.Font, Enum.FontWeight.Regular),
                Size = UDim2.new(1, an and -29 or 0, 1, 0),
                PlaceholderText = ae,
                ClearTextOnFocus = al or false,
                ClipsDescendants = true,
                TextWrapped = ao,
                MultiLine = ao,
                TextXAlignment = 'Left',
                TextYAlignment = ah == 'Input' and 'Center' or 'Top',
                ThemeTag = {
                    PlaceholderColor3 = 'PlaceholderText',
                    TextColor3 = 'Text',
                },
            })
            local aq = ac('Frame', {
                Size = UDim2.new(1, 0, 0, 42),
                Parent = ag,
                BackgroundTransparency = 1,
            }, {
                ac('Frame', {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                }, {
                    ab.NewRoundFrame(am, 'Squircle', {
                        ThemeTag = {
                            ImageColor3 = 'Accent',
                        },
                        Size = UDim2.new(1, 0, 1, 0),
                        ImageTransparency = 0.97,
                    }),
                    ab.NewRoundFrame(am, 'Glass-1', {
                        ThemeTag = {
                            ImageColor3 = 'Outline',
                        },
                        Size = UDim2.new(1, 0, 1, 0),
                        ImageTransparency = 0.75,
                    }, {}),
                    ab.NewRoundFrame(am, 'Squircle', {
                        Size = UDim2.new(1, 0, 1, 0),
                        Name = 'Frame',
                        ImageColor3 = Color3.new(1, 1, 1),
                        ImageTransparency = 0.95,
                    }, {
                        ac('UIPadding', {
                            PaddingTop = UDim.new(0, ah == 'Input' and 0 or 12),
                            PaddingLeft = UDim.new(0, 12),
                            PaddingRight = UDim.new(0, 12),
                            PaddingBottom = UDim.new(0, ah == 'Input' and 0 or 12),
                        }),
                        ac('UIListLayout', {
                            FillDirection = 'Horizontal',
                            Padding = UDim.new(0, 8),
                            VerticalAlignment = ah == 'Input' and 'Center' or 'Top',
                            HorizontalAlignment = 'Left',
                        }),
                        an,
                        ap,
                    }),
                }),
            })

            if aj then
                ab.AddSignal(ap:GetPropertyChangedSignal'Text', function()
                    if ai then
                        ab.SafeCallback(ai, ap.Text)
                    end
                end)
            else
                ab.AddSignal(ap.FocusLost, function()
                    if ai then
                        ab.SafeCallback(ai, ap.Text)
                    end
                end)
            end

            return aq
        end

        return aa
    end
    function a.n()
        local aa = a.load'c'
        local ab = aa.New
        local ac = aa.Tween
        local ad
        local ae
        local af = {
            Holder = nil,
            Parent = nil,
        }

        function af.Init(ag, ah, ai)
            ad = ag
            ae = ah
            af.Parent = ai

            return af
        end
        function af.Create(ag, ah)
            local ai = {
                UICorner = 28,
                UIPadding = 12,
                Window = ad,
                IntiHub = ae,
                UIElements = {},
            }

            if ag then
                ai.UIPadding = 0
            end
            if ag then
                ai.UICorner = 26
            end

            ah = ah or 'Dialog'

            if not ag then
                ai.UIElements.FullScreen = ab('Frame', {
                    ZIndex = 999,
                    BackgroundTransparency = 1,
                    BackgroundColor3 = Color3.fromHex'#000000',
                    Size = UDim2.new(1, 0, 1, 0),
                    Active = false,
                    Visible = false,
                    Parent = af.Parent or (ad and ad.UIElements and ad.UIElements.Main and ad.UIElements.Main.Main),
                }, {
                    ab('UICorner', {
                        CornerRadius = UDim.new(0, ad.UICorner),
                    }),
                })
            end

            ab('ImageLabel', {
                Image = 'rbxassetid://8992230677',
                ThemeTag = {
                    ImageColor3 = 'WindowShadow',
                },
                ImageTransparency = 1,
                Size = UDim2.new(1, 100, 1, 100),
                Position = UDim2.new(0, -50, 0, -50),
                ScaleType = 'Slice',
                SliceCenter = Rect.new(99, 99, 99, 99),
                BackgroundTransparency = 1,
                ZIndex = -999999999999999,
                Name = 'Blur',
            })

            ai.UIElements.Main = ab('Frame', {
                Size = UDim2.new(0, 280, 0, 0),
                ThemeTag = {
                    BackgroundColor3 = ah .. 'Background',
                },
                AutomaticSize = 'Y',
                BackgroundTransparency = 1,
                Visible = false,
                ZIndex = 99999,
            }, {
                ab('UIPadding', {
                    PaddingTop = UDim.new(0, ai.UIPadding),
                    PaddingLeft = UDim.new(0, ai.UIPadding),
                    PaddingRight = UDim.new(0, ai.UIPadding),
                    PaddingBottom = UDim.new(0, ai.UIPadding),
                }),
            })
            ai.UIElements.MainContainer = aa.NewRoundFrame(ai.UICorner, 'Squircle', {
                Visible = false,
                ImageTransparency = ag and 0.15 or 0,
                Parent = ag and af.Parent or ai.UIElements.FullScreen,
                Position = UDim2.new(0.5, 0, 0.5, 0),
                AnchorPoint = Vector2.new(0.5, 0.5),
                AutomaticSize = 'XY',
                ThemeTag = {
                    ImageColor3 = ah .. 'Background',
                    ImageTransparency = ah .. 'BackgroundTransparency',
                },
                ZIndex = 9999,
            }, {
                ai.UIElements.Main,
            })

            function ai.Open(aj)
                if not ag then
                    ai.UIElements.FullScreen.Visible = true
                    ai.UIElements.FullScreen.Active = true
                end

                task.spawn(function()
                    ai.UIElements.MainContainer.Visible = true

                    if not ag then
                        ac(ai.UIElements.FullScreen, 0.1, {BackgroundTransparency = 0.3}):Play()
                    end

                    ac(ai.UIElements.MainContainer, 0.1, {ImageTransparency = 0}):Play()
                    task.spawn(function()
                        task.wait(0.05)

                        ai.UIElements.Main.Visible = true
                    end)
                end)
            end
            function ai.Close(aj)
                if not ag then
                    ac(ai.UIElements.FullScreen, 0.1, {BackgroundTransparency = 1}):Play()

                    ai.UIElements.FullScreen.Active = false

                    task.spawn(function()
                        task.wait(0.1)

                        ai.UIElements.FullScreen.Visible = false
                    end)
                end

                ai.UIElements.Main.Visible = false

                ac(ai.UIElements.MainContainer, 0.1, {ImageTransparency = 1}):Play()
                task.spawn(function()
                    task.wait(0.1)

                    if not ag then
                        ai.UIElements.FullScreen:Destroy()
                    else
                        ai.UIElements.MainContainer:Destroy()
                    end
                end)

                return function() end
            end

            return ai
        end

        return af
    end
    function a.o()
        local aa = {}
        local ab = a.load'c'
        local ac = ab.New
        local ad = ab.Tween
        local ae = a.load'l'.New
        local af = a.load'm'.New

        function aa.new(ag, ah, ai, aj)
            local ak = a.load'n'.Init(nil, ag.IntiHub, ag.IntiHub.ScreenGui.KeySystem)
            local al = ak.Create(true)
            local am = {}
            local an
            local ao = (ag.KeySystem.Thumbnail and ag.KeySystem.Thumbnail.Width) or 200
            local ap = 430

            if ag.KeySystem.Thumbnail and ag.KeySystem.Thumbnail.Image then
                ap = 430 + (ao / 2)
            end

            al.UIElements.Main.AutomaticSize = 'Y'
            al.UIElements.Main.Size = UDim2.new(0, ap, 0, 0)

            local aq

            if ag.Icon then
                aq = ab.Image(ag.Icon, ag.Title .. ':' .. ag.Icon, 0, 'Temp', 'KeySystem', ag.IconThemed)
                aq.Size = UDim2.new(0, 24, 0, 24)
                aq.LayoutOrder = -1
            end

            local ar = ac('TextLabel', {
                AutomaticSize = 'XY',
                BackgroundTransparency = 1,
                Text = ag.KeySystem.Title or ag.Title,
                FontFace = Font.new(ab.Font, Enum.FontWeight.SemiBold),
                ThemeTag = {
                    TextColor3 = 'Text',
                },
                TextSize = 20,
            })
            local as = ac('TextLabel', {
                AutomaticSize = 'XY',
                BackgroundTransparency = 1,
                Text = 'Key System',
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, 0, 0.5, 0),
                TextTransparency = 1,
                FontFace = Font.new(ab.Font, Enum.FontWeight.Medium),
                ThemeTag = {
                    TextColor3 = 'Text',
                },
                TextSize = 16,
            })
            local at = ac('Frame', {
                BackgroundTransparency = 1,
                AutomaticSize = 'XY',
            }, {
                ac('UIListLayout', {
                    Padding = UDim.new(0, 14),
                    FillDirection = 'Horizontal',
                    VerticalAlignment = 'Center',
                }),
                aq,
                ar,
            })
            local au = ac('Frame', {
                AutomaticSize = 'Y',
                Size = UDim2.new(1, 0, 0, 0),
                BackgroundTransparency = 1,
            }, {at, as})
            local av = af('Enter Key', 'key', nil, 'Input', function(av)
                an = av
            end)
            local aw

            if ag.KeySystem.Note and ag.KeySystem.Note ~= '' then
                aw = ac('TextLabel', {
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = 'Y',
                    FontFace = Font.new(ab.Font, Enum.FontWeight.Medium),
                    TextXAlignment = 'Left',
                    Text = ag.KeySystem.Note,
                    TextSize = 18,
                    TextTransparency = 0.4,
                    ThemeTag = {
                        TextColor3 = 'Text',
                    },
                    BackgroundTransparency = 1,
                    RichText = true,
                    TextWrapped = true,
                })
            end

            local ax = ac('Frame', {
                Size = UDim2.new(1, 0, 0, 42),
                BackgroundTransparency = 1,
            }, {
                ac('Frame', {
                    BackgroundTransparency = 1,
                    AutomaticSize = 'X',
                    Size = UDim2.new(0, 0, 1, 0),
                }, {
                    ac('UIListLayout', {
                        Padding = UDim.new(0, 9),
                        FillDirection = 'Horizontal',
                    }),
                }),
            })
            local ay

            if ag.KeySystem.Thumbnail and ag.KeySystem.Thumbnail.Image then
                local az

                if ag.KeySystem.Thumbnail.Title then
                    az = ac('TextLabel', {
                        Text = ag.KeySystem.Thumbnail.Title,
                        ThemeTag = {
                            TextColor3 = 'Text',
                        },
                        TextSize = 18,
                        FontFace = Font.new(ab.Font, Enum.FontWeight.Medium),
                        BackgroundTransparency = 1,
                        AutomaticSize = 'XY',
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Position = UDim2.new(0.5, 0, 0.5, 0),
                    })
                end

                ay = ac('ImageLabel', {
                    Image = ag.KeySystem.Thumbnail.Image,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, ao, 1, -12),
                    Position = UDim2.new(0, 6, 0, 6),
                    Parent = al.UIElements.Main,
                    ScaleType = 'Crop',
                }, {
                    az,
                    ac('UICorner', {
                        CornerRadius = UDim.new(0, 20),
                    }),
                })
            end

            ac('Frame', {
                Size = UDim2.new(1, ay and -ao or 0, 1, 0),
                Position = UDim2.new(0, ay and ao or 0, 0, 0),
                BackgroundTransparency = 1,
                Parent = al.UIElements.Main,
            }, {
                ac('Frame', {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                }, {
                    ac('UIListLayout', {
                        Padding = UDim.new(0, 18),
                        FillDirection = 'Vertical',
                    }),
                    au,
                    aw,
                    av,
                    ax,
                    ac('UIPadding', {
                        PaddingTop = UDim.new(0, 16),
                        PaddingLeft = UDim.new(0, 16),
                        PaddingRight = UDim.new(0, 16),
                        PaddingBottom = UDim.new(0, 16),
                    }),
                }),
            })

            local az = ae('Exit', 'log-out', function()
                al:Close()()
            end, 'Tertiary', ax.Frame)

            if ay then
                az.Parent = ay
                az.Size = UDim2.new(0, 0, 0, 42)
                az.Position = UDim2.new(0, 10, 1, -10)
                az.AnchorPoint = Vector2.new(0, 1)
            end
            if ag.KeySystem.URL then
                ae('Get key', 'key', function()
                    setclipboard(ag.KeySystem.URL)
                end, 'Secondary', ax.Frame)
            end
            if ag.KeySystem.API then
                local aA = 240
                local aB = false
                local aC = ae('Get key', 'key', nil, 'Secondary', ax.Frame)
                local b = ab.NewRoundFrame(99, 'Squircle', {
                    Size = UDim2.new(0, 1, 1, 0),
                    ThemeTag = {
                        ImageColor3 = 'Text',
                    },
                    ImageTransparency = 0.9,
                })

                ac('Frame', {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 0, 1, 0),
                    AutomaticSize = 'X',
                    Parent = aC.Frame,
                }, {
                    b,
                    ac('UIPadding', {
                        PaddingLeft = UDim.new(0, 5),
                        PaddingRight = UDim.new(0, 5),
                    }),
                })

                local c = ab.Image('chevron-down', 'chevron-down', 0, 'Temp', 'KeySystem', true)

                c.Size = UDim2.new(1, 0, 1, 0)

                ac('Frame', {
                    Size = UDim2.new(0, 21, 0, 21),
                    Parent = aC.Frame,
                    BackgroundTransparency = 1,
                }, {c})

                local d = ab.NewRoundFrame(15, 'Squircle', {
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = 'Y',
                    ThemeTag = {
                        ImageColor3 = 'Background',
                    },
                }, {
                    ac('UIPadding', {
                        PaddingTop = UDim.new(0, 5),
                        PaddingLeft = UDim.new(0, 5),
                        PaddingRight = UDim.new(0, 5),
                        PaddingBottom = UDim.new(0, 5),
                    }),
                    ac('UIListLayout', {
                        FillDirection = 'Vertical',
                        Padding = UDim.new(0, 5),
                    }),
                })
                local e = ac('Frame', {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, aA, 0, 0),
                    ClipsDescendants = true,
                    AnchorPoint = Vector2.new(1, 0),
                    Parent = aC,
                    Position = UDim2.new(1, 0, 1, 15),
                }, {d})

                ac('TextLabel', {
                    Text = 'Select Service',
                    BackgroundTransparency = 1,
                    FontFace = Font.new(ab.Font, Enum.FontWeight.Medium),
                    ThemeTag = {
                        TextColor3 = 'Text',
                    },
                    TextTransparency = 0.2,
                    TextSize = 16,
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = 'Y',
                    TextWrapped = true,
                    TextXAlignment = 'Left',
                    Parent = d,
                }, {
                    ac('UIPadding', {
                        PaddingTop = UDim.new(0, 10),
                        PaddingLeft = UDim.new(0, 10),
                        PaddingRight = UDim.new(0, 10),
                        PaddingBottom = UDim.new(0, 10),
                    }),
                })

                for f, g in next, ag.KeySystem.API do
                    local i = ag.IntiHub.Services[g.Type]

                    if i then
                        local j = {}

                        for k, l in next, i.Args do
                            table.insert(j, g[l])
                        end

                        local k = i.New(table.unpack(j))

                        k.Type = g.Type

                        table.insert(am, k)

                        local l = ab.Image(g.Icon or i.Icon or Icons[g.Type] or 'user', g.Icon or i.Icon or Icons[g.Type] or 'user', 0, 'Temp', 'KeySystem', true)

                        l.Size = UDim2.new(0, 24, 0, 24)

                        local n = ab.NewRoundFrame(10, 'Squircle', {
                            Size = UDim2.new(1, 0, 0, 0),
                            ThemeTag = {
                                ImageColor3 = 'Text',
                            },
                            ImageTransparency = 1,
                            Parent = d,
                            AutomaticSize = 'Y',
                        }, {
                            ac('UIListLayout', {
                                FillDirection = 'Horizontal',
                                Padding = UDim.new(0, 10),
                                VerticalAlignment = 'Center',
                            }),
                            l,
                            ac('UIPadding', {
                                PaddingTop = UDim.new(0, 10),
                                PaddingLeft = UDim.new(0, 10),
                                PaddingRight = UDim.new(0, 10),
                                PaddingBottom = UDim.new(0, 10),
                            }),
                            ac('Frame', {
                                BackgroundTransparency = 1,
                                Size = UDim2.new(1, -34, 0, 0),
                                AutomaticSize = 'Y',
                            }, {
                                ac('UIListLayout', {
                                    FillDirection = 'Vertical',
                                    Padding = UDim.new(0, 5),
                                    HorizontalAlignment = 'Center',
                                }),
                                ac('TextLabel', {
                                    Text = g.Title or i.Name,
                                    BackgroundTransparency = 1,
                                    FontFace = Font.new(ab.Font, Enum.FontWeight.Medium),
                                    ThemeTag = {
                                        TextColor3 = 'Text',
                                    },
                                    TextTransparency = 0.05,
                                    TextSize = 18,
                                    Size = UDim2.new(1, 0, 0, 0),
                                    AutomaticSize = 'Y',
                                    TextWrapped = true,
                                    TextXAlignment = 'Left',
                                }),
                                ac('TextLabel', {
                                    Text = g.Desc or '',
                                    BackgroundTransparency = 1,
                                    FontFace = Font.new(ab.Font, Enum.FontWeight.Regular),
                                    ThemeTag = {
                                        TextColor3 = 'Text',
                                    },
                                    TextTransparency = 0.2,
                                    TextSize = 16,
                                    Size = UDim2.new(1, 0, 0, 0),
                                    AutomaticSize = 'Y',
                                    TextWrapped = true,
                                    Visible = g.Desc and true or false,
                                    TextXAlignment = 'Left',
                                }),
                            }),
                        }, true)

                        ab.AddSignal(n.MouseEnter, function()
                            ad(n, 0.08, {ImageTransparency = 0.95}):Play()
                        end)
                        ab.AddSignal(n.InputEnded, function()
                            ad(n, 0.08, {ImageTransparency = 1}):Play()
                        end)
                        ab.AddSignal(n.MouseButton1Click, function()
                            k.Copy()
                            ag.IntiHub:Notify{
                                Title = 'Key System',
                                Content = 'Key link copied to clipboard.',
                                Image = 'key',
                            }
                        end)
                    end
                end

                ab.AddSignal(aC.MouseButton1Click, function()
                    if not aB then
                        ad(e, 0.3, {
                            Size = UDim2.new(0, aA, 0, d.AbsoluteSize.Y + 1),
                        }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                        ad(c, 0.3, {Rotation = 180}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                    else
                        ad(e, 0.25, {
                            Size = UDim2.new(0, aA, 0, 0),
                        }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                        ad(c, 0.25, {Rotation = 0}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                    end

                    aB = not aB
                end)
            end

            local aA = function(aA)
                al:Close()()
                writefile((ag.Folder or 'Temp') .. '/' .. ah .. '.key', tostring(aA))
                task.wait(0.4)
                ai(true)
            end
            local aB = ae('Submit', 'arrow-right', function()
                local aB = tostring(an or 'empty')
                local aC = ag.Folder or ag.Title

                if ag.KeySystem.KeyValidator then
                    local b = ag.KeySystem.KeyValidator(aB)

                    if b then
                        if ag.KeySystem.SaveKey then
                            aA(aB)
                        else
                            al:Close()()
                            task.wait(0.4)
                            ai(true)
                        end
                    else
                        ag.IntiHub:Notify{
                            Title = 'Key System. Error',
                            Content = 'Invalid key.',
                            Icon = 'triangle-alert',
                        }
                    end
                elseif not ag.KeySystem.API then
                    local b = type(ag.KeySystem.Key) == 'table' and table.find(ag.KeySystem.Key, aB) or ag.KeySystem.Key == aB

                    if b then
                        if ag.KeySystem.SaveKey then
                            aA(aB)
                        else
                            al:Close()()
                            task.wait(0.4)
                            ai(true)
                        end
                    end
                else
                    local b, c

                    for d, e in next, am do
                        local f, g = e.Verify(aB)

                        if f then
                            b, c = true, g

                            break
                        end

                        c = g
                    end

                    if b then
                        aA(aB)
                    else
                        ag.IntiHub:Notify{
                            Title = 'Key System. Error',
                            Content = c,
                            Icon = 'triangle-alert',
                        }
                    end
                end
            end, 'Primary', ax)

            aB.AnchorPoint = Vector2.new(1, 0.5)
            aB.Position = UDim2.new(1, 0, 0.5, 0)

            al:Open()
        end

        return aa
    end
    function a.p()
        local aa = (cloneref or clonereference or function(aa)
            return aa
        end)
        local ab = function(ab, ac, ad, ae, af)
            return (ab - ac) * (af - ae) / (ad - ac) + ae
        end
        local ac = function(ac, ad)
            local ae = aa(game:GetService'Workspace').CurrentCamera:ScreenPointToRay(ac.X, ac.Y)

            return ae.Origin + ae.Direction * ad
        end
        local ad = function()
            local ad = aa(game:GetService'Workspace').CurrentCamera.ViewportSize.Y

            return ab(ad, 0, 2560, 8, 56)
        end

        return {ac, ad}
    end
    function a.q()
        local aa = (cloneref or clonereference or function(aa)
            return aa
        end)
        local ab = a.load'c'
        local ac = ab.New
        local ad, ae = unpack(a.load'p')
        local af = Instance.new('Folder', aa(game:GetService'Workspace').CurrentCamera)
        local ag = function()
            local ag = ac('Part', {
                Name = 'Body',
                Color = Color3.new(0, 0, 0),
                Material = Enum.Material.Glass,
                Size = Vector3.new(1, 1, 0),
                Anchored = true,
                CanCollide = false,
                Locked = true,
                CastShadow = false,
                Transparency = 0.98,
            }, {
                ac('SpecialMesh', {
                    MeshType = Enum.MeshType.Brick,
                    Offset = Vector3.new(0, 0, -1E-6),
                }),
            })

            return ag
        end
        local ah = function(ah)
            local ai = {}

            ah = ah or 0.001

            local aj = {
                topLeft = Vector2.new(),
                topRight = Vector2.new(),
                bottomRight = Vector2.new(),
            }
            local ak = ag()

            ak.Parent = af

            local al = function(al, am)
                aj.topLeft = am
                aj.topRight = am + Vector2.new(al.X, 0)
                aj.bottomRight = am + al
            end
            local am = function()
                local am = aa(game:GetService'Workspace').CurrentCamera

                if am then
                    am = am.CFrame
                end

                local an = am

                if not an then
                    an = CFrame.new()
                end

                local ao = an
                local ap = aj.topLeft
                local aq = aj.topRight
                local ar = aj.bottomRight
                local as = ad(ap, ah)
                local at = ad(aq, ah)
                local au = ad(ar, ah)
                local av = (at - as).Magnitude
                local aw = (at - au).Magnitude

                ak.CFrame = CFrame.fromMatrix((as + au) / 2, ao.XVector, ao.YVector, ao.ZVector)
                ak.Mesh.Scale = Vector3.new(av, aw, 0)
            end
            local an = function(an)
                local ao = ae()
                local ap = an.AbsoluteSize - Vector2.new(ao, ao)
                local aq = an.AbsolutePosition + Vector2.new(ao / 2, ao / 2)

                al(ap, aq)
                task.spawn(am)
            end
            local ao = function()
                local ao = aa(game:GetService'Workspace').CurrentCamera

                if not ao then
                    return
                end

                table.insert(ai, ao:GetPropertyChangedSignal'CFrame':Connect(am))
                table.insert(ai, ao:GetPropertyChangedSignal'ViewportSize':Connect(am))
                table.insert(ai, ao:GetPropertyChangedSignal'FieldOfView':Connect(am))
                task.spawn(am)
            end

            ak.Destroying:Connect(function()
                for ap, aq in ai do
                    pcall(function()
                        aq:Disconnect()
                    end)
                end
            end)
            ao()

            return an, ak
        end

        return function(ai)
            local aj = {}
            local ak, al = ah(ai)
            local am = ac('Frame', {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
            })

            ab.AddSignal(am:GetPropertyChangedSignal'AbsolutePosition', function(
            )
                ak(am)
            end)
            ab.AddSignal(am:GetPropertyChangedSignal'AbsoluteSize', function()
                ak(am)
            end)

            aj.AddParent = function(an)
                ab.AddSignal(an:GetPropertyChangedSignal'Visible', function() end)
            end
            aj.SetVisibility = function(an)
                al.Transparency = an and 0.98 or 1
            end
            aj.Frame = am
            aj.Model = al

            return aj
        end
    end
    function a.r()
        local aa = a.load'c'
        local ab = a.load'q'
        local ac = aa.New

        return function(ad)
            local ae = {}

            ae.Frame = ac('Frame', {
                Size = UDim2.fromScale(1, 1),
                BackgroundTransparency = 1,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BorderSizePixel = 0,
            }, {
                ac('UICorner', {
                    CornerRadius = UDim.new(0, 8),
                }),
                ac('Frame', {
                    BackgroundTransparency = 1,
                    Size = UDim2.fromScale(1, 1),
                    Name = 'Background',
                    ThemeTag = {
                        BackgroundColor3 = 'AcrylicMain',
                    },
                }, {
                    ac('UICorner', {
                        CornerRadius = UDim.new(0, 8),
                    }),
                }),
                ac('Frame', {
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 1,
                    Size = UDim2.fromScale(1, 1),
                }, {}),
                ac('ImageLabel', {
                    Image = 'rbxassetid://9968344105',
                    ImageTransparency = 0.98,
                    ScaleType = Enum.ScaleType.Tile,
                    TileSize = UDim2.new(0, 128, 0, 128),
                    Size = UDim2.fromScale(1, 1),
                    BackgroundTransparency = 1,
                }, {
                    ac('UICorner', {
                        CornerRadius = UDim.new(0, 8),
                    }),
                }),
                ac('ImageLabel', {
                    Image = 'rbxassetid://9968344227',
                    ImageTransparency = 0.9,
                    ScaleType = Enum.ScaleType.Tile,
                    TileSize = UDim2.new(0, 128, 0, 128),
                    Size = UDim2.fromScale(1, 1),
                    BackgroundTransparency = 1,
                    ThemeTag = {
                        ImageTransparency = 'AcrylicNoise',
                    },
                }, {
                    ac('UICorner', {
                        CornerRadius = UDim.new(0, 8),
                    }),
                }),
                ac('Frame', {
                    BackgroundTransparency = 1,
                    Size = UDim2.fromScale(1, 1),
                    ZIndex = 2,
                }, {}),
            })

            local af

            task.wait()

            if ad.UseAcrylic then
                af = ab()
                af.Frame.Parent = ae.Frame
                ae.Model = af.Model
                ae.AddParent = af.AddParent
                ae.SetVisibility = af.SetVisibility
            end

            return ae, af
        end
    end
    function a.s()
        local aa = (cloneref or clonereference or function(aa)
            return aa
        end)
        local ab = {
            AcrylicBlur = a.load'q',
            AcrylicPaint = a.load'r',
        }

        function ab.init()
            local ac = Instance.new'DepthOfFieldEffect'

            ac.FarIntensity = 0
            ac.InFocusRadius = 0.1
            ac.NearIntensity = 1

            local ad = {}

            function ab.Enable()
                for ae, af in pairs(ad)do
                    af.Enabled = false
                end

                ac.Parent = aa(game:GetService'Lighting')
            end
            function ab.Disable()
                for ae, af in pairs(ad)do
                    af.Enabled = af.enabled
                end

                ac.Parent = nil
            end

            local ae = function()
                local ae = function(ae)
                    if ae:IsA'DepthOfFieldEffect' then
                        ad[ae] = {
                            enabled = ae.Enabled,
                        }
                    end
                end

                for af, ag in pairs(aa(game:GetService'Lighting'):GetChildren())do
                    ae(ag)
                end

                if aa(game:GetService'Workspace').CurrentCamera then
                    for af, ag in pairs(aa(game:GetService'Workspace').CurrentCamera:GetChildren())do
                        ae(ag)
                    end
                end
            end

            ae()
            ab.Enable()
        end

        return ab
    end
    function a.t()
        local aa = {}
        local ab = a.load'c'
        local ac = ab.New
        local ad = ab.Tween

        function aa.new(ae)
            local af = {
                Title = ae.Title or 'Dialog',
                Content = ae.Content,
                Icon = ae.Icon,
                IconThemed = ae.IconThemed,
                Thumbnail = ae.Thumbnail,
                Buttons = ae.Buttons,
                IconSize = 22,
            }
            local ag = a.load'n'.Init(nil, ae.IntiHub.ScreenGui.Popups)
            local ah = ag.Create(true, 'Popup')
            local ai = 200
            local aj = 430

            if af.Thumbnail and af.Thumbnail.Image then
                aj = 430 + (ai / 2)
            end

            ah.UIElements.Main.AutomaticSize = 'Y'
            ah.UIElements.Main.Size = UDim2.new(0, aj, 0, 0)

            local ak

            if af.Icon then
                ak = ab.Image(af.Icon, af.Title .. ':' .. af.Icon, 0, ae.IntiHub.Window, 'Popup', true, ae.IconThemed, 'PopupIcon')
                ak.Size = UDim2.new(0, af.IconSize, 0, af.IconSize)
                ak.LayoutOrder = -1
            end

            local al = ac('TextLabel', {
                AutomaticSize = 'Y',
                BackgroundTransparency = 1,
                Text = af.Title,
                TextXAlignment = 'Left',
                FontFace = Font.new(ab.Font, Enum.FontWeight.SemiBold),
                ThemeTag = {
                    TextColor3 = 'PopupTitle',
                },
                TextSize = 20,
                TextWrapped = true,
                Size = UDim2.new(1, ak and -af.IconSize - 14 or 0, 0, 0),
            })
            local am = ac('Frame', {
                BackgroundTransparency = 1,
                AutomaticSize = 'XY',
            }, {
                ac('UIListLayout', {
                    Padding = UDim.new(0, 14),
                    FillDirection = 'Horizontal',
                    VerticalAlignment = 'Center',
                }),
                ak,
                al,
            })
            local an = ac('Frame', {
                AutomaticSize = 'Y',
                Size = UDim2.new(1, 0, 0, 0),
                BackgroundTransparency = 1,
            }, {am})
            local ao

            if af.Content and af.Content ~= '' then
                ao = ac('TextLabel', {
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = 'Y',
                    FontFace = Font.new(ab.Font, Enum.FontWeight.Medium),
                    TextXAlignment = 'Left',
                    Text = af.Content,
                    TextSize = 18,
                    TextTransparency = 0.2,
                    ThemeTag = {
                        TextColor3 = 'PopupContent',
                    },
                    BackgroundTransparency = 1,
                    RichText = true,
                    TextWrapped = true,
                })
            end

            local ap = ac('Frame', {
                Size = UDim2.new(1, 0, 0, 42),
                BackgroundTransparency = 1,
            }, {
                ac('UIListLayout', {
                    Padding = UDim.new(0, 9),
                    FillDirection = 'Horizontal',
                    HorizontalAlignment = 'Right',
                }),
            })
            local aq

            if af.Thumbnail and af.Thumbnail.Image then
                local ar

                if af.Thumbnail.Title then
                    ar = ac('TextLabel', {
                        Text = af.Thumbnail.Title,
                        ThemeTag = {
                            TextColor3 = 'Text',
                        },
                        TextSize = 18,
                        FontFace = Font.new(ab.Font, Enum.FontWeight.Medium),
                        BackgroundTransparency = 1,
                        AutomaticSize = 'XY',
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Position = UDim2.new(0.5, 0, 0.5, 0),
                    })
                end

                aq = ac('ImageLabel', {
                    Image = af.Thumbnail.Image,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, ai, 1, 0),
                    Parent = ah.UIElements.Main,
                    ScaleType = 'Crop',
                }, {
                    ar,
                    ac('UICorner', {
                        CornerRadius = UDim.new(0, 0),
                    }),
                })
            end

            ac('Frame', {
                Size = UDim2.new(1, aq and -ai or 0, 1, 0),
                Position = UDim2.new(0, aq and ai or 0, 0, 0),
                BackgroundTransparency = 1,
                Parent = ah.UIElements.Main,
            }, {
                ac('Frame', {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                }, {
                    ac('UIListLayout', {
                        Padding = UDim.new(0, 18),
                        FillDirection = 'Vertical',
                    }),
                    an,
                    ao,
                    ap,
                    ac('UIPadding', {
                        PaddingTop = UDim.new(0, 16),
                        PaddingLeft = UDim.new(0, 16),
                        PaddingRight = UDim.new(0, 16),
                        PaddingBottom = UDim.new(0, 16),
                    }),
                }),
            })

            local ar = a.load'l'.New

            for as, at in next, af.Buttons do
                ar(at.Title, at.Icon, at.Callback, at.Variant, ap, ah)
            end

            ah:Open()

            return af
        end

        return aa
    end
    function a.u()
        return function(aa)
            return {
                Dark = {
                    Name = 'Dark',
                    Accent = Color3.fromHex'#FFC300',
                    Dialog = Color3.fromHex'#0A0A0A',
                    Outline = Color3.fromHex'#FFC300',
                    Text = Color3.fromHex'#FFFFFF',
                    Placeholder = Color3.fromHex'#7a7a7a',
                    Background = Color3.fromHex'#000000',
                    BackgroundTransparency = 0.1,
                    Button = Color3.fromHex'#1A1A1A',
                    Icon = Color3.fromHex'#FFC300',
                    Toggle = Color3.fromHex'#FFC300',
                    Slider = Color3.fromHex'#FFC300',
                    Checkbox = Color3.fromHex'#FFC300',
                    PanelBackground = Color3.fromHex'#0A0A0A',
                    PanelBackgroundTransparency = 0.5,
                    SliderIcon = Color3.fromHex'#FFC300',
                    Primary = Color3.fromHex'#FFC300',
                    LabelBackground = Color3.fromHex'#000000',
                    LabelBackgroundTransparency = 0.8,
                },
                Light = {
                    Name = 'Light',
                    Accent = Color3.fromHex'#FFFFFF',
                    Dialog = Color3.fromHex'#f4f4f5',
                    Outline = Color3.fromHex'#ffffff',
                    Text = Color3.fromHex'#000000',
                    Placeholder = Color3.fromHex'#555555',
                    Background = Color3.fromHex'#e9e9e9',
                    Button = Color3.fromHex'#18181b',
                    Icon = Color3.fromHex'#52525b',
                    Toggle = Color3.fromHex'#33C759',
                    Slider = Color3.fromHex'#0091FF',
                    Checkbox = Color3.fromHex'#0091FF',
                    TabBackground = Color3.fromHex'#ffffff',
                    TabBackgroundHover = Color3.fromHex'#ffffff',
                    TabBackgroundHoverTransparency = 0.5,
                    TabBackgroundActive = Color3.fromHex'#ffffff',
                    TabBackgroundActiveTransparency = 0,
                    PanelBackground = Color3.fromHex'#FFFFFF',
                    PanelBackgroundTransparency = 0,
                    LabelBackground = Color3.fromHex'#ffffff',
                    LabelBackgroundTransparency = 0,
                },
                Rose = {
                    Name = 'Rose',
                    Accent = Color3.fromHex'#be185d',
                    Dialog = Color3.fromHex'#4c0519',
                    Text = Color3.fromHex'#fdf2f8',
                    Placeholder = Color3.fromHex'#d67aa6',
                    Background = Color3.fromHex'#1f0308',
                    Button = Color3.fromHex'#e95f74',
                    Icon = Color3.fromHex'#fb7185',
                },
                Plant = {
                    Name = 'Plant',
                    Accent = Color3.fromHex'#166534',
                    Dialog = Color3.fromHex'#052e16',
                    Text = Color3.fromHex'#f0fdf4',
                    Placeholder = Color3.fromHex'#4fbf7a',
                    Background = Color3.fromHex'#0a1b0f',
                    Button = Color3.fromHex'#16a34a',
                    Icon = Color3.fromHex'#4ade80',
                },
                Red = {
                    Name = 'Red',
                    Accent = Color3.fromHex'#991b1b',
                    Dialog = Color3.fromHex'#450a0a',
                    Text = Color3.fromHex'#fef2f2',
                    Placeholder = Color3.fromHex'#d95353',
                    Background = Color3.fromHex'#1c0606',
                    Button = Color3.fromHex'#dc2626',
                    Icon = Color3.fromHex'#ef4444',
                },
                Indigo = {
                    Name = 'Indigo',
                    Accent = Color3.fromHex'#3730a3',
                    Dialog = Color3.fromHex'#1e1b4b',
                    Text = Color3.fromHex'#f1f5f9',
                    Placeholder = Color3.fromHex'#7078d9',
                    Background = Color3.fromHex'#0f0a2e',
                    Button = Color3.fromHex'#4f46e5',
                    Icon = Color3.fromHex'#6366f1',
                },
                Sky = {
                    Name = 'Sky',
                    Accent = Color3.fromHex'#00d4ff',
                    Dialog = Color3.fromHex'#0a4d66',
                    Text = Color3.fromHex'#e6f7ff',
                    Placeholder = Color3.fromHex'#66b3cc',
                    Background = Color3.fromHex'#051a26',
                    Button = Color3.fromHex'#00a8cc',
                    Icon = Color3.fromHex'#2db8d9',
                    Toggle = Color3.fromHex'#00d9d9',
                    Slider = Color3.fromHex'#00d4ff',
                    Checkbox = Color3.fromHex'#00d4ff',
                    PanelBackground = Color3.fromHex'#0d3a47',
                    PanelBackgroundTransparency = 0.8,
                },
                Violet = {
                    Name = 'Violet',
                    Accent = Color3.fromHex'#6d28d9',
                    Dialog = Color3.fromHex'#3c1361',
                    Text = Color3.fromHex'#faf5ff',
                    Placeholder = Color3.fromHex'#8f7ee0',
                    Background = Color3.fromHex'#1e0a3e',
                    Button = Color3.fromHex'#7c3aed',
                    Icon = Color3.fromHex'#8b5cf6',
                },
                Amber = {
                    Name = 'Amber',
                    Accent = aa:Gradient({
                        ['0'] = {
                            Color = Color3.fromHex'#b45309',
                            Transparency = 0,
                        },
                        ['100'] = {
                            Color = Color3.fromHex'#d97706',
                            Transparency = 0,
                        },
                    }, {Rotation = 45}),
                    Dialog = aa:Gradient({
                        ['0'] = {
                            Color = Color3.fromHex'#451a03',
                            Transparency = 0,
                        },
                        ['100'] = {
                            Color = Color3.fromHex'#6b2e05',
                            Transparency = 0,
                        },
                    }, {Rotation = 90}),
                    Text = aa:Gradient({
                        ['0'] = {
                            Color = Color3.fromHex'#fffbeb',
                            Transparency = 0,
                        },
                        ['100'] = {
                            Color = Color3.fromHex'#fff7ed',
                            Transparency = 0,
                        },
                    }, {Rotation = 45}),
                    Placeholder = aa:Gradient({
                        ['0'] = {
                            Color = Color3.fromHex'#d1a326',
                            Transparency = 0,
                        },
                        ['100'] = {
                            Color = Color3.fromHex'#fbbf24',
                            Transparency = 0,
                        },
                    }, {Rotation = 45}),
                    Background = aa:Gradient({
                        ['0'] = {
                            Color = Color3.fromHex'#1c1003',
                            Transparency = 0,
                        },
                        ['100'] = {
                            Color = Color3.fromHex'#3f210d',
                            Transparency = 0,
                        },
                    }, {Rotation = 90}),
                    Button = aa:Gradient({
                        ['0'] = {
                            Color = Color3.fromHex'#d97706',
                            Transparency = 0,
                        },
                        ['100'] = {
                            Color = Color3.fromHex'#f59e0b',
                            Transparency = 0,
                        },
                    }, {Rotation = 45}),
                    Icon = Color3.fromHex'#f59e0b',
                    Toggle = aa:Gradient({
                        ['0'] = {
                            Color = Color3.fromHex'#d97706',
                            Transparency = 0,
                        },
                        ['100'] = {
                            Color = Color3.fromHex'#f59e0b',
                            Transparency = 0,
                        },
                    }, {Rotation = 45}),
                    Slider = Color3.fromHex'#d97706',
                    Checkbox = aa:Gradient({
                        ['0'] = {
                            Color = Color3.fromHex'#d97706',
                            Transparency = 0,
                        },
                        ['100'] = {
                            Color = Color3.fromHex'#fbbf24',
                            Transparency = 0,
                        },
                    }, {Rotation = 45}),
                    PanelBackground = Color3.fromHex'#FFFFFF',
                    PanelBackgroundTransparency = 0.95,
                },
                Emerald = {
                    Name = 'Emerald',
                    Accent = Color3.fromHex'#047857',
                    Dialog = Color3.fromHex'#022c22',
                    Text = Color3.fromHex'#ecfdf5',
                    Placeholder = Color3.fromHex'#3fbf8f',
                    Background = Color3.fromHex'#011411',
                    Button = Color3.fromHex'#059669',
                    Icon = Color3.fromHex'#10b981',
                },
                Midnight = {
                    Name = 'Midnight',
                    Accent = Color3.fromHex'#1e3a8a',
                    Dialog = Color3.fromHex'#0c1e42',
                    Text = Color3.fromHex'#dbeafe',
                    Placeholder = Color3.fromHex'#2f74d1',
                    Background = Color3.fromHex'#0a0f1e',
                    Button = Color3.fromHex'#2563eb',
                    Primary = Color3.fromHex'#2563eb',
                    Icon = Color3.fromHex'#5591f4',
                },
                Crimson = {
                    Name = 'Crimson',
                    Accent = Color3.fromHex'#b91c1c',
                    Dialog = Color3.fromHex'#450a0a',
                    Text = Color3.fromHex'#fef2f2',
                    Placeholder = Color3.fromHex'#6f757b',
                    Background = Color3.fromHex'#0c0404',
                    Button = Color3.fromHex'#991b1b',
                    Icon = Color3.fromHex'#dc2626',
                },
                MonokaiPro = {
                    Name = 'Monokai Pro',
                    Accent = Color3.fromHex'#fc9867',
                    Dialog = Color3.fromHex'#1e1e1e',
                    Text = Color3.fromHex'#fcfcfa',
                    Placeholder = Color3.fromHex'#6f6f6f',
                    Background = Color3.fromHex'#191622',
                    Button = Color3.fromHex'#ab9df2',
                    Icon = Color3.fromHex'#a9dc76',
                    Metadata = {PullRequest = 23},
                },
                CottonCandy = {
                    Name = 'Cotton Candy',
                    Accent = Color3.fromHex'#ec4899',
                    Dialog = Color3.fromHex'#2d1b3d',
                    Text = Color3.fromHex'#fdf2f8',
                    Placeholder = Color3.fromHex'#8a5fd3',
                    Background = Color3.fromHex'#1a0b2e',
                    Button = Color3.fromHex'#d946ef',
                    Slider = Color3.fromHex'#d946ef',
                    Icon = Color3.fromHex'#06b6d4',
                },
                Mellowsi = {
                    Name = 'Mellowsi',
                    Accent = Color3.fromHex'#342A1E',
                    Dialog = Color3.fromHex'#291C13',
                    Text = Color3.fromHex'#F5EBDD',
                    Placeholder = Color3.fromHex'#9C8A73',
                    Background = Color3.fromHex'#1C1002',
                    Button = Color3.fromHex'#342A1E',
                    Icon = Color3.fromHex'#C9B79C',
                    Toggle = Color3.fromHex'#a9873f',
                    Slider = Color3.fromHex'#C9A24D',
                    Checkbox = Color3.fromHex'#C9A24D',
                    Metadata = {PullRequest = 52},
                },
                Rainbow = {
                    Name = 'Rainbow',
                    Accent = aa:Gradient({
                        ['0'] = {
                            Color = Color3.fromHex'#00ff41',
                            Transparency = 0,
                        },
                        ['33'] = {
                            Color = Color3.fromHex'#00ffff',
                            Transparency = 0,
                        },
                        ['66'] = {
                            Color = Color3.fromHex'#0080ff',
                            Transparency = 0,
                        },
                        ['100'] = {
                            Color = Color3.fromHex'#8000ff',
                            Transparency = 0,
                        },
                    }, {Rotation = 45}),
                    Dialog = aa:Gradient({
                        ['0'] = {
                            Color = Color3.fromHex'#ff0080',
                            Transparency = 0,
                        },
                        ['25'] = {
                            Color = Color3.fromHex'#8000ff',
                            Transparency = 0,
                        },
                        ['50'] = {
                            Color = Color3.fromHex'#0080ff',
                            Transparency = 0,
                        },
                        ['75'] = {
                            Color = Color3.fromHex'#00ff80',
                            Transparency = 0,
                        },
                        ['100'] = {
                            Color = Color3.fromHex'#ff8000',
                            Transparency = 0,
                        },
                    }, {Rotation = 135}),
                    Text = Color3.fromHex'#ffffff',
                    Placeholder = Color3.fromHex'#00ff80',
                    Background = aa:Gradient({
                        ['0'] = {
                            Color = Color3.fromHex'#000000',
                            Transparency = 0,
                        },
                        ['100'] = {
                            Color = Color3.fromHex'#1A1A1A',
                            Transparency = 0,
                        },
                    }, {Rotation = 90}),
                    Button = aa:Gradient({
                        ['0'] = {
                            Color = Color3.fromHex'#FFC300',
                            Transparency = 0,
                        },
                        ['100'] = {
                            Color = Color3.fromHex'#FF8C00',
                            Transparency = 0,
                        },
                    }, {Rotation = 45}),
                    Icon = Color3.fromHex'#ffffff',
                },
            }
        end
    end
    function a.v()
        local aa = {}
        local ab = a.load'c'
        local ac = ab.New
        local ad = ab.Tween

        function aa.New(ae, af, ag, ah, ai)
            local aj = ai or 10
            local ak

            if af and af ~= '' then
                ak = ac('ImageLabel', {
                    Image = ab.Icon(af)[1],
                    ImageRectSize = ab.Icon(af)[2].ImageRectSize,
                    ImageRectOffset = ab.Icon(af)[2].ImageRectPosition,
                    Size = UDim2.new(0, 21, 0, 21),
                    BackgroundTransparency = 1,
                    ThemeTag = {
                        ImageColor3 = 'Icon',
                    },
                })
            end

            local al = ac('TextLabel', {
                BackgroundTransparency = 1,
                TextSize = 17,
                FontFace = Font.new(ab.Font, Enum.FontWeight.Regular),
                Size = UDim2.new(1, ak and -29 or 0, 1, 0),
                TextXAlignment = 'Left',
                ThemeTag = {
                    TextColor3 = ah and 'Placeholder' or 'Text',
                },
                Text = ae,
            })
            local am = ac('TextButton', {
                Size = UDim2.new(1, 0, 0, 42),
                Parent = ag,
                BackgroundTransparency = 1,
                Text = '',
            }, {
                ac('Frame', {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                }, {
                    ab.NewRoundFrame(aj, 'Squircle', {
                        ThemeTag = {
                            ImageColor3 = 'Accent',
                        },
                        Size = UDim2.new(1, 0, 1, 0),
                        ImageTransparency = 0.97,
                    }),
                    ab.NewRoundFrame(aj, 'Glass-1.4', {
                        ThemeTag = {
                            ImageColor3 = 'Outline',
                        },
                        Size = UDim2.new(1, 0, 1, 0),
                        ImageTransparency = 0.48,
                    }, {}),
                    ab.NewRoundFrame(aj, 'Squircle', {
                        Size = UDim2.new(1, 0, 1, 0),
                        Name = 'Frame',
                        ThemeTag = {
                            ImageColor3 = 'LabelBackground',
                            ImageTransparency = 'LabelBackgroundTransparency',
                        },
                    }, {
                        ac('UIPadding', {
                            PaddingLeft = UDim.new(0, 12),
                            PaddingRight = UDim.new(0, 12),
                        }),
                        ac('UIListLayout', {
                            FillDirection = 'Horizontal',
                            Padding = UDim.new(0, 8),
                            VerticalAlignment = 'Center',
                            HorizontalAlignment = 'Left',
                        }),
                        ak,
                        al,
                    }),
                }),
            })

            return am
        end

        return aa
    end
    function a.w()
        local aa = {}
        local ab = (cloneref or clonereference or function(ab)
            return ab
        end)
        local ac = ab(game:GetService'UserInputService')
        local ad = a.load'c'
        local ae = ad.New
        local af = ad.Tween

        function aa.New(ag, ah, ai, aj)
            local ak = ae('Frame', {
                Size = UDim2.new(0, aj, 1, 0),
                BackgroundTransparency = 1,
                Position = UDim2.new(1, 0, 0, 0),
                AnchorPoint = Vector2.new(1, 0),
                Parent = ah,
                ZIndex = 999,
                Active = true,
            })
            local al = ad.NewRoundFrame(aj / 2, 'Squircle', {
                Size = UDim2.new(1, 0, 0, 0),
                ImageTransparency = 0.85,
                ThemeTag = {
                    ImageColor3 = 'Text',
                },
                Parent = ak,
            })
            local am = ae('Frame', {
                Size = UDim2.new(1, 12, 1, 12),
                Position = UDim2.new(0.5, 0, 0.5, 0),
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundTransparency = 1,
                Active = true,
                ZIndex = 999,
                Parent = al,
            })
            local an = false
            local ao = 0
            local ap = function()
                local ap = ag
                local aq = ap.AbsoluteCanvasSize.Y
                local ar = ap.AbsoluteWindowSize.Y

                if aq <= ar then
                    al.Visible = false

                    return
                end

                local as = math.clamp(ar / aq, 0.1, 1)

                al.Size = UDim2.new(1, 0, as, 0)
                al.Visible = true
            end
            local aq = function()
                local aq = al.Position.Y.Scale
                local ar = ag.AbsoluteCanvasSize.Y
                local as = ag.AbsoluteWindowSize.Y
                local at = math.max(ar - as, 0)

                if at <= 0 then
                    return
                end

                local au = math.max(1 - al.Size.Y.Scale, 0)

                if au <= 0 then
                    return
                end

                local av = aq / au

                ag.CanvasPosition = Vector2.new(ag.CanvasPosition.X, av * at)
            end
            local ar = function()
                if an then
                    return
                end

                local ar = ag.CanvasPosition.Y
                local as = ag.AbsoluteCanvasSize.Y
                local at = ag.AbsoluteWindowSize.Y
                local au = math.max(as - at, 0)

                if au <= 0 then
                    al.Position = UDim2.new(0, 0, 0, 0)

                    return
                end

                local av = ar / au
                local aw = math.max(1 - al.Size.Y.Scale, 0)
                local ax = math.clamp(av * aw, 0, aw)

                al.Position = UDim2.new(0, 0, ax, 0)
            end

            ad.AddSignal(ak.InputBegan, function(as)
                if (as.UserInputType == Enum.UserInputType.MouseButton1 or as.UserInputType == Enum.UserInputType.Touch) then
                    local at = al.AbsolutePosition.Y
                    local au = at + al.AbsoluteSize.Y

                    if not (as.Position.Y >= at and as.Position.Y <= au) then
                        local av = ak.AbsolutePosition.Y
                        local aw = ak.AbsoluteSize.Y
                        local ax = al.AbsoluteSize.Y
                        local ay = as.Position.Y - av - ax / 2
                        local az = aw - ax
                        local aA = math.clamp(ay / az, 0, 1 - al.Size.Y.Scale)

                        al.Position = UDim2.new(0, 0, aA, 0)

                        aq()
                    end
                end
            end)
            ad.AddSignal(am.InputBegan, function(as)
                if as.UserInputType == Enum.UserInputType.MouseButton1 or as.UserInputType == Enum.UserInputType.Touch then
                    an = true
                    ao = as.Position.Y - al.AbsolutePosition.Y

                    local at
                    local au

                    at = ac.InputChanged:Connect(function(av)
                        if av.UserInputType == Enum.UserInputType.MouseMovement or av.UserInputType == Enum.UserInputType.Touch then
                            local aw = ak.AbsolutePosition.Y
                            local ax = ak.AbsoluteSize.Y
                            local ay = al.AbsoluteSize.Y
                            local az = av.Position.Y - aw - ao
                            local aA = ax - ay
                            local aB = math.clamp(az / aA, 0, 1 - al.Size.Y.Scale)

                            al.Position = UDim2.new(0, 0, aB, 0)

                            aq()
                        end
                    end)
                    au = ac.InputEnded:Connect(function(av)
                        if av.UserInputType == Enum.UserInputType.MouseButton1 or av.UserInputType == Enum.UserInputType.Touch then
                            an = false

                            if at then
                                at:Disconnect()
                            end
                            if au then
                                au:Disconnect()
                            end
                        end
                    end)
                end
            end)
            ad.AddSignal(ag:GetPropertyChangedSignal'AbsoluteWindowSize', function(
            )
                ap()
                ar()
            end)
            ad.AddSignal(ag:GetPropertyChangedSignal'AbsoluteCanvasSize', function(
            )
                ap()
                ar()
            end)
            ad.AddSignal(ag:GetPropertyChangedSignal'CanvasPosition', function()
                if not an then
                    ar()
                end
            end)
            ap()
            ar()

            return ak
        end

        return aa
    end
    function a.x()
        local aa = {}
        local ab = a.load'c'
        local ac = ab.New
        local ad = ab.Tween

        function aa.New(ae, af, ag)
            local ah = {
                Title = af.Title or 'Tag',
                Icon = af.Icon,
                Color = af.Color or Color3.fromHex'#315dff',
                Radius = af.Radius or 999,
                Border = af.Border or false,
                TagFrame = nil,
                Height = 26,
                Padding = 10,
                TextSize = 14,
                IconSize = 16,
            }
            local ai

            if ah.Icon then
                ai = ab.Image(ah.Icon, ah.Icon, 0, af.Window, 'Tag', false)
                ai.Size = UDim2.new(0, ah.IconSize, 0, ah.IconSize)
                ai.ImageLabel.ImageColor3 = typeof(ah.Color) == 'Color3' and ab.GetTextColorForHSB(ah.Color) or typeof(ah.Color) == 'string' and (ab.GetTextColorForHSB(ab.GetThemeProperty(ah.Color, ab.Theme)))
            end

            local aj = ac('TextLabel', {
                BackgroundTransparency = 1,
                AutomaticSize = 'XY',
                TextSize = ah.TextSize,
                FontFace = Font.new(ab.Font, Enum.FontWeight.SemiBold),
                Text = ah.Title,
                TextColor3 = typeof(ah.Color) == 'Color3' and ab.GetTextColorForHSB(ah.Color) or typeof(ah.Color) == 'string' and (ab.GetTextColorForHSB(ab.GetThemeProperty(ah.Color, ab.Theme))),
            })
            local ak

            if typeof(ah.Color) == 'table' then
                ak = ac'UIGradient'

                for al, am in next, ah.Color do
                    ak[al] = am
                end

                aj.TextColor3 = ab.GetTextColorForHSB(ab.GetAverageColor(ak))

                if ai then
                    ai.ImageLabel.ImageColor3 = ab.GetTextColorForHSB(ab.GetAverageColor(ak))
                end
            end

            local al = ab.NewRoundFrame(ah.Radius, 'Squircle', {
                AutomaticSize = 'X',
                Size = UDim2.new(0, 0, 0, ah.Height),
                Parent = ag,
                ImageColor3 = typeof(ah.Color) == 'Color3' and ah.Color or typeof(ah.Color) == 'table' and Color3.new(1, 1, 1) or nil,
                ThemeTag = typeof(ah.Color) == 'string' and {
                    ImageColor3 = ah.Color,
                },
            }, {
                ak,
                ab.NewRoundFrame(ah.Radius, 'Glass-1', {
                    Size = UDim2.new(1, 0, 1, 0),
                    ThemeTag = {
                        ImageColor3 = 'White',
                    },
                    ImageTransparency = 0.75,
                }),
                ac('Frame', {
                    Size = UDim2.new(0, 0, 1, 0),
                    AutomaticSize = 'X',
                    Name = 'Content',
                    BackgroundTransparency = 1,
                }, {
                    ai,
                    aj,
                    ac('UIPadding', {
                        PaddingLeft = UDim.new(0, ah.Padding),
                        PaddingRight = UDim.new(0, ah.Padding),
                    }),
                    ac('UIListLayout', {
                        FillDirection = 'Horizontal',
                        VerticalAlignment = 'Center',
                        Padding = UDim.new(0, ah.Padding / 1.5),
                    }),
                }),
            })

            function ah.SetTitle(am, an)
                ah.Title = an
                aj.Text = an

                return ah
            end
            function ah.SetColor(am, an)
                ah.Color = an

                if typeof(an) == 'table' then
                    local ao = ab.GetAverageColor(an)

                    ad(aj, 0.06, {
                        TextColor3 = ab.GetTextColorForHSB(ao),
                    }):Play()

                    local ap = al:FindFirstChildOfClass'UIGradient' or ac('UIGradient', {Parent = al})

                    for aq, ar in next, an do
                        ap[aq] = ar
                    end

                    ad(al, 0.06, {
                        ImageColor3 = Color3.new(1, 1, 1),
                    }):Play()
                else
                    if ak then
                        ak:Destroy()
                    end

                    ad(aj, 0.06, {
                        TextColor3 = ab.GetTextColorForHSB(an),
                    }):Play()

                    if ai then
                        ad(ai.ImageLabel, 0.06, {
                            ImageColor3 = ab.GetTextColorForHSB(an),
                        }):Play()
                    end

                    ad(al, 0.06, {ImageColor3 = an}):Play()
                end

                return ah
            end
            function ah.SetIcon(am, an)
                ah.Icon = an

                if an then
                    ai = ab.Image(an, an, 0, af.Window, 'Tag', false)
                    ai.Size = UDim2.new(0, ah.IconSize, 0, ah.IconSize)
                    ai.Parent = al

                    if typeof(ah.Color) == 'Color3' then
                        ai.ImageLabel.ImageColor3 = ab.GetTextColorForHSB(ah.Color)
                    elseif typeof(ah.Color) == 'table' then
                        ai.ImageLabel.ImageColor3 = ab.GetTextColorForHSB(ab.GetAverageColor(ak))
                    end
                else
                    if ai then
                        ai:Destroy()

                        ai = nil
                    end
                end

                return ah
            end
            function ah.Destroy(am)
                al:Destroy()

                return ah
            end

            ab:OnThemeChange(function(am, an)
                aj.TextColor3 = ab.GetTextColorForHSB(ab.GetThemeProperty(ah.Color, ab.Theme))
                ai.ImageLabel.ImageColor3 = ab.GetTextColorForHSB(ab.GetThemeProperty(ah.Color, ab.Theme))
            end)

            return ah
        end

        return aa
    end
    function a.y()
        local aa = (cloneref or clonereference or function(aa)
            return aa
        end)
        local ab = aa(game:GetService'RunService')
        local ac = aa(game:GetService'HttpService')
        local ad
        local ae

        ae = {
            Folder = nil,
            Path = nil,
            Configs = {},
            Parser = {
                Colorpicker = {
                    Save = function(af)
                        return {
                            __type = af.__type,
                            value = af.Default:ToHex(),
                            transparency = af.Transparency or nil,
                        }
                    end,
                    Load = function(af, ag)
                        if af and af.Update then
                            af:Update(Color3.fromHex(ag.value), ag.transparency or nil)
                        end
                    end,
                },
                Dropdown = {
                    Save = function(af)
                        return {
                            __type = af.__type,
                            value = af.Value,
                        }
                    end,
                    Load = function(af, ag)
                        if af and af.Select then
                            af:Select(ag.value)
                        end
                    end,
                },
                Input = {
                    Save = function(af)
                        return {
                            __type = af.__type,
                            value = af.Value,
                        }
                    end,
                    Load = function(af, ag)
                        if af and af.Set then
                            af:Set(ag.value)
                        end
                    end,
                },
                Keybind = {
                    Save = function(af)
                        return {
                            __type = af.__type,
                            value = af.Value,
                        }
                    end,
                    Load = function(af, ag)
                        if af and af.Set then
                            af:Set(ag.value)
                        end
                    end,
                },
                Slider = {
                    Save = function(af)
                        return {
                            __type = af.__type,
                            value = af.Value.Default,
                        }
                    end,
                    Load = function(af, ag)
                        if af and af.Set then
                            af:Set(tonumber(ag.value))
                        end
                    end,
                },
                Toggle = {
                    Save = function(af)
                        return {
                            __type = af.__type,
                            value = af.Value,
                        }
                    end,
                    Load = function(af, ag)
                        if af and af.Set then
                            af:Set(ag.value)
                        end
                    end,
                },
            },
        }

        function ae.Init(af, ag)
            if not ag.Folder then
                warn'[ IntiHub.ConfigManager ] Window.Folder is not specified.'

                return false
            end
            if ab:IsStudio() or not writefile then
                warn
[[[ IntiHub.ConfigManager ] The config system doesn't work in the studio.]]

                return false
            end

            ad = ag
            ae.Folder = ad.Folder
            ae.Path = 'IntiHub_Data/' .. tostring(ae.Folder) .. '/config/'

            if not isfolder(ae.Path) then
                makefolder(ae.Path)
            end

            local ah = ae:AllConfigs()

            for ai, aj in next, ah do
                if isfile and readfile and isfile(aj .. '.json') then
                    ae.Configs[aj] = readfile(aj .. '.json')
                end
            end

            return ae
        end
        function ae.SetPath(af, ag)
            if not ag then
                warn'[ IntiHub.ConfigManager ] Custom path is not specified.'

                return false
            end

            ae.Path = ag

            if not ag:match'/$' then
                ae.Path = ag .. '/'
            end
            if not isfolder(ae.Path) then
                makefolder(ae.Path)
            end

            return true
        end
        function ae.CreateConfig(af, ag, ah)
            local ai = {
                Path = ae.Path .. ag .. '.json',
                Elements = {},
                CustomData = {},
                AutoLoad = ah or false,
                Version = 1.2,
            }

            if not ag then
                return false, 'No config file is selected'
            end

            function ai.SetAsCurrent(aj)
                ad:SetCurrentConfig(ai)
            end
            function ai.Register(aj, ak, al)
                ai.Elements[ak] = al
            end
            function ai.Set(aj, ak, al)
                ai.CustomData[ak] = al
            end
            function ai.Get(aj, ak)
                return ai.CustomData[ak]
            end
            function ai.SetAutoLoad(aj, ak)
                ai.AutoLoad = ak
            end
            function ai.Save(aj)
                if ad.PendingFlags then
                    for ak, al in next, ad.PendingFlags do
                        ai:Register(ak, al)
                    end
                end

                local ak = {
                    __version = ai.Version,
                    __elements = {},
                    __autoload = ai.AutoLoad,
                    __custom = ai.CustomData,
                }

                for al, am in next, ai.Elements do
                    if ae.Parser[am.__type] then
                        ak.__elements[tostring(al)] = ae.Parser[am.__type].Save(am)
                    end
                end

                local al = ac:JSONEncode(ak)

                if writefile then
                    writefile(ai.Path, al)
                end

                return ak
            end
            function ai.Load(aj)
                if isfile and not isfile(ai.Path) then
                    return false, 'Config file does not exist'
                end

                local ak, al = pcall(function()
                    local ak = readfile or function()
                        warn
[[[ IntiHub.ConfigManager ] The config system doesn't work in the studio.]]

                        return nil
                    end

                    return ac:JSONDecode(ak(ai.Path))
                end)

                if not ak then
                    return false, 'Failed to parse config file'
                end
                if not al.__version then
                    local am = {
                        __version = ai.Version,
                        __elements = al,
                        __custom = {},
                    }

                    al = am
                end
                if ad.PendingFlags then
                    for am, an in next, ad.PendingFlags do
                        ai:Register(am, an)
                    end
                end

                for am, an in next, (al.__elements or {})do
                    if ai.Elements[am] and ae.Parser[an.__type] then
                        task.spawn(function()
                            ae.Parser[an.__type].Load(ai.Elements[am], an)
                        end)
                    end
                end

                ai.CustomData = al.__custom or {}

                return ai.CustomData
            end
            function ai.Delete(aj)
                if not delfile then
                    return false, 'delfile function is not available'
                end
                if not isfile(ai.Path) then
                    return false, 'Config file does not exist'
                end

                local ak, al = pcall(function()
                    delfile(ai.Path)
                end)

                if not ak then
                    return false, 'Failed to delete config file: ' .. tostring(al)
                end

                ae.Configs[ag] = nil

                if ad.CurrentConfig == ai then
                    ad.CurrentConfig = nil
                end

                return true, 'Config deleted successfully'
            end
            function ai.GetData(aj)
                return {
                    elements = ai.Elements,
                    custom = ai.CustomData,
                    autoload = ai.AutoLoad,
                }
            end

            if isfile(ai.Path) then
                local aj, ak = pcall(function()
                    return ac:JSONDecode(readfile(ai.Path))
                end)

                if aj and ak and ak.__autoload then
                    ai.AutoLoad = true

                    task.spawn(function()
                        task.wait(0.5)

                        local al, am = pcall(function()
                            return ai:Load()
                        end)

                        if al then
                            if ad.Debug then
                                print('[ IntiHub.ConfigManager ] AutoLoaded config: ' .. ag)
                            end
                        else
                            warn('[ IntiHub.ConfigManager ] Failed to AutoLoad config: ' .. ag .. ' - ' .. tostring(am))
                        end
                    end)
                end
            end

            ai:SetAsCurrent()

            ae.Configs[ag] = ai

            return ai
        end
        function ae.Config(af, ag, ah)
            return ae:CreateConfig(ag, ah)
        end
        function ae.GetAutoLoadConfigs(af)
            local ag = {}

            for ah, ai in pairs(ae.Configs)do
                if ai.AutoLoad then
                    table.insert(ag, ah)
                end
            end

            return ag
        end
        function ae.DeleteConfig(af, ag)
            if not delfile then
                return false, 'delfile function is not available'
            end

            local ah = ae.Path .. ag .. '.json'

            if not isfile(ah) then
                return false, 'Config file does not exist'
            end

            local ai, aj = pcall(function()
                delfile(ah)
            end)

            if not ai then
                return false, 'Failed to delete config file: ' .. tostring(aj)
            end

            ae.Configs[ag] = nil

            if ad.CurrentConfig and ad.CurrentConfig.Path == ah then
                ad.CurrentConfig = nil
            end

            return true, 'Config deleted successfully'
        end
        function ae.AllConfigs(af)
            if not listfiles then
                return {}
            end

            local ag = {}

            if not isfolder(ae.Path) then
                makefolder(ae.Path)

                return ag
            end

            for ah, ai in next, listfiles(ae.Path)do
                local aj = ai:match'([^\\/]+)%.json$'

                if aj then
                    table.insert(ag, aj)
                end
            end

            return ag
        end
        function ae.GetConfig(af, ag)
            return ae.Configs[ag]
        end

        return ae
    end
    function a.z()
        local aa = {}
        local ab = a.load'c'
        local ac = ab.New
        local ad = ab.Tween
        local ae = (cloneref or clonereference or function(ae)
            return ae
        end)

        ae(game:GetService'UserInputService')

        function aa.New(af)
            local ag = {Button = nil}
            local ah
            local ai = ac('TextLabel', {
                Text = af.Title:upper(),
                TextSize = 14,
                FontFace = Font.new(ab.Font, Enum.FontWeight.Bold),
                BackgroundTransparency = 1,
                AutomaticSize = 'XY',
                ThemeTag = {
                    TextColor3 = 'Accent',
                },
            })
            local aj = ac('Frame', {
                Size = UDim2.new(0, 30, 0, 30),
                BackgroundTransparency = 1,
                Name = 'Drag',
            }, {
                ac('ImageLabel', {
                    Image = ab.Icon'move'[1],
                    ImageRectOffset = ab.Icon'move'[2].ImageRectPosition,
                    ImageRectSize = ab.Icon'move'[2].ImageRectSize,
                    Size = UDim2.new(0, 14, 0, 14),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    ThemeTag = {
                        ImageColor3 = 'Icon',
                    },
                    ImageTransparency = 0.5,
                }),
            })
            local ak = ac('Frame', {
                Size = UDim2.new(0, 1, 0, 18),
                BackgroundColor3 = Color3.fromHex'#FFD700',
                BackgroundTransparency = 0.8,
                BorderSizePixel = 0,
            })
            local al = ac('Frame', {
                Size = UDim2.new(0, 45, 0, 20),
                BackgroundColor3 = Color3.new(1, 1, 1),
                BackgroundTransparency = 0.92,
            }, {
                ac('UICorner', {
                    CornerRadius = UDim.new(1, 0),
                }),
                ac('Frame', {
                    Name = 'Dot',
                    Size = UDim2.new(0, 6, 0, 6),
                    Position = UDim2.new(0, 8, 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundColor3 = Color3.fromHex'#FFD700',
                }, {
                    ac('UICorner', {
                        CornerRadius = UDim.new(1, 0),
                    }),
                }),
                ac('TextLabel', {
                    Text = 'LIVE',
                    TextSize = 10,
                    FontFace = Font.new(ab.Font, Enum.FontWeight.Bold),
                    TextColor3 = Color3.new(1, 1, 1),
                    TextTransparency = 0.4,
                    Position = UDim2.new(0, 18, 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundTransparency = 1,
                }),
            })
            local am = ac('Frame', {
                Size = UDim2.new(0, 200, 0, 40),
                Position = UDim2.new(0.5, 0, 0, 50),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Parent = af.Parent,
                BackgroundTransparency = 1,
                Active = true,
                Visible = false,
            })
            local an = ac('UIScale', {Scale = 1})
            local ao = ac('Frame', {
                Size = UDim2.new(0, 0, 0, 32),
                AutomaticSize = 'X',
                Parent = am,
                BackgroundColor3 = Color3.fromHex'#0A0A0A',
                BackgroundTransparency = 0.1,
            }, {
                an,
                ac('UICorner', {
                    CornerRadius = UDim.new(0, 6),
                }),
                ac('UIStroke', {
                    Thickness = 1,
                    Color = Color3.fromHex'#FFD700',
                    Transparency = 0.7,
                    Name = 'Stroke',
                }),
                ac('UIPadding', {
                    PaddingLeft = UDim.new(0, 10),
                    PaddingRight = UDim.new(0, 10),
                }),
                ac('UIListLayout', {
                    Padding = UDim.new(0, 10),
                    FillDirection = 'Horizontal',
                    VerticalAlignment = 'Center',
                    SortOrder = 'LayoutOrder',
                }),
                aj,
                ak,
                ai,
                al,
                ac('TextButton', {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = '',
                    ZIndex = 10,
                }),
            })

            task.spawn(function()
                while true do
                    local ap = al:FindFirstChild'Dot'

                    if ap then
                        ad(ap, 0.8, {BackgroundTransparency = 0.5}, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut):Play()
                        task.wait(0.8)
                        ad(ap, 0.8, {BackgroundTransparency = 0}, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut):Play()
                        task.wait(0.8)
                    else
                        break
                    end
                end
            end)

            ag.Button = ao

            function ag.SetIcon(ap, aq)
                if ah then
                    ah:Destroy()
                end
                if aq then
                    ah = ab.Image(aq, af.Title, 0, af.Folder, 'OpenButton', true, af.IconThemed)
                    ah.Size = UDim2.new(0, 16, 0, 16)
                    ah.LayoutOrder = -1
                    ah.Parent = ao
                end
            end

            if af.Icon then
                ag:SetIcon(af.Icon)
            end

            ab.AddSignal(ao:GetPropertyChangedSignal'AbsoluteSize', function()
                am.Size = UDim2.new(0, ao.AbsoluteSize.X, 0, ao.AbsoluteSize.Y)
            end)
            ab.AddSignal(ao.TextButton.MouseEnter, function()
                ad(ao, 0.2, {BackgroundTransparency = 0}):Play()
            end)
            ab.AddSignal(ao.TextButton.MouseLeave, function()
                ad(ao, 0.2, {BackgroundTransparency = 0.1}):Play()
            end)

            local ap = ab.Drag(am)

            function ag.Visible(aq, ar)
                am.Visible = ar
            end
            function ag.SetScale(aq, ar)
                an.Scale = ar
            end
            function ag.Edit(aq, ar)
                local as = {
                    Title = ar.Title,
                    Icon = ar.Icon,
                    Enabled = ar.Enabled,
                    Position = ar.Position,
                    OnlyIcon = ar.OnlyIcon or false,
                    Draggable = ar.Draggable or nil,
                    OnlyMobile = ar.OnlyMobile,
                    CornerRadius = ar.CornerRadius or UDim.new(0, 6),
                    StrokeThickness = ar.StrokeThickness or 1,
                    Scale = ar.Scale or 1,
                    Color = ar.Color or ColorSequence.new{
                        ColorSequenceKeypoint.new(0, Color3.fromHex'#FFD700'),
                        ColorSequenceKeypoint.new(1, Color3.fromHex'#FFD700'),
                    },
                }

                if as.Enabled == false then
                    af.IsOpenButtonEnabled = false
                end
                if as.Draggable == false and aj and ak then
                    aj.Visible = as.Draggable

                    if ap then
                        ap:Set(as.Draggable)
                    end
                end
                if as.Position and am then
                    am.Position = as.Position
                end
                if as.OnlyIcon == true then
                    ai.Visible = false
                    ak.Visible = false
                    al.Visible = false
                else
                    ai.Visible = true
                    ak.Visible = true
                    al.Visible = true
                end
                if as.Title then
                    ai.Text = as.Title:upper()
                end
                if as.Icon then
                    ag:SetIcon(as.Icon)
                end

                local at = ao:FindFirstChild'Stroke'

                if at then
                    at.Thickness = as.StrokeThickness
                end

                ao.UICorner.CornerRadius = as.CornerRadius

                ag:SetScale(as.Scale)
            end

            return ag
        end

        return aa
    end
    function a.A()
        local aa = {}
        local ab = a.load'c'
        local ac = ab.New
        local ad = ab.Tween

        function aa.New(ae, af, ag, ah, ai, aj)
            local ak = {
                Container = nil,
                TooltipSize = 16,
                TooltipArrowSizeX = ai == 'Small' and 16 or 24,
                TooltipArrowSizeY = ai == 'Small' and 6 or 9,
                PaddingX = ai == 'Small' and 12 or 14,
                PaddingY = ai == 'Small' and 7 or 9,
                Radius = 999,
                TitleFrame = nil,
            }

            ah = ah or ''
            aj = aj ~= false

            local al = ac('TextLabel', {
                AutomaticSize = 'XY',
                TextWrapped = aj,
                BackgroundTransparency = 1,
                FontFace = Font.new(ab.Font, Enum.FontWeight.Medium),
                Text = ae,
                TextSize = ai == 'Small' and 15 or 17,
                TextTransparency = 1,
                ThemeTag = {
                    TextColor3 = 'Tooltip' .. ah .. 'Text',
                },
            })

            ak.TitleFrame = al

            local am = ac('UIScale', {Scale = 0.9})
            local an = ac('Frame', {
                AnchorPoint = Vector2.new(0.5, 0),
                AutomaticSize = 'XY',
                BackgroundTransparency = 1,
                Parent = af,
                Visible = false,
            }, {
                ac('UISizeConstraint', {
                    MaxSize = Vector2.new(400, math.huge),
                }),
                ac('Frame', {
                    AutomaticSize = 'XY',
                    BackgroundTransparency = 1,
                    LayoutOrder = 99,
                    Visible = ag,
                    Name = 'Arrow',
                }, {
                    ac('ImageLabel', {
                        Size = UDim2.new(0, ak.TooltipArrowSizeX, 0, ak.TooltipArrowSizeY),
                        BackgroundTransparency = 1,
                        Image = 'rbxassetid://105854070513330',
                        ThemeTag = {
                            ImageColor3 = 'Tooltip' .. ah,
                        },
                    }, {}),
                }),
                ab.NewRoundFrame(ak.Radius, 'Squircle', {
                    AutomaticSize = 'XY',
                    ThemeTag = {
                        ImageColor3 = 'Tooltip' .. ah,
                    },
                    ImageTransparency = 1,
                    Name = 'Background',
                }, {
                    ac('Frame', {
                        AutomaticSize = 'XY',
                        BackgroundTransparency = 1,
                    }, {
                        ac('UICorner', {
                            CornerRadius = UDim.new(0, 16),
                        }),
                        ac('UIListLayout', {
                            Padding = UDim.new(0, 12),
                            FillDirection = 'Horizontal',
                            VerticalAlignment = 'Center',
                        }),
                        al,
                        ac('UIPadding', {
                            PaddingTop = UDim.new(0, ak.PaddingY),
                            PaddingLeft = UDim.new(0, ak.PaddingX),
                            PaddingRight = UDim.new(0, ak.PaddingX),
                            PaddingBottom = UDim.new(0, ak.PaddingY),
                        }),
                    }),
                }),
                am,
                ac('UIListLayout', {
                    Padding = UDim.new(0, 0),
                    FillDirection = 'Vertical',
                    VerticalAlignment = 'Center',
                    HorizontalAlignment = 'Center',
                }),
            })

            ak.Container = an

            function ak.Open(ao)
                an.Visible = true

                ad(an.Background, 0.2, {ImageTransparency = 0}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                ad(an.Arrow.ImageLabel, 0.2, {ImageTransparency = 0}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                ad(al, 0.2, {TextTransparency = 0}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                ad(am, 0.22, {Scale = 1}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
            end
            function ak.Close(ao, ap)
                ad(an.Background, 0.3, {ImageTransparency = 1}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                ad(an.Arrow.ImageLabel, 0.2, {ImageTransparency = 1}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                ad(al, 0.3, {TextTransparency = 1}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                ad(am, 0.35, {Scale = 0.9}, Enum.EasingStyle.Quint, Enum.EasingDirection.In):Play()

                ap = ap ~= false

                if ap then
                    task.wait(0.35)

                    an.Visible = false

                    an:Destroy()
                end
            end

            return ak
        end

        return aa
    end
    function a.B()
        local aa = a.load'c'
        local ab = aa.New
        local ac = aa.NewRoundFrame
        local ad = aa.Tween
        local ae = (cloneref or clonereference or function(ae)
            return ae
        end)

        ae(game:GetService'UserInputService')

        local af = function(af)
            local ag, ah, ai = af.R, af.G, af.B
            local aj = math.max(ag, ah, ai)
            local ak = math.min(ag, ah, ai)
            local al = aj - ak
            local am = 0

            if al ~= 0 then
                if aj == ag then
                    am = (ah - ai) / al % 6
                elseif aj == ah then
                    am = (ai - ag) / al + 2
                else
                    am = (ag - ah) / al + 4
                end

                am = am * 60
            else
                am = 0
            end

            local an = (aj == 0) and 0 or (al / aj)
            local ao = aj

            return {
                h = math.floor(am + 0.5),
                s = an,
                b = ao,
            }
        end
        local ag = function(ag)
            local ah = ag.R
            local ai = ag.G
            local aj = ag.B

            return 0.299 * ah + 0.587 * ai + 0.114 * aj
        end
        local ah = function(ah)
            local ai = af(ah)
            local aj, ak, al = ai.h, ai.s, ai.b

            if ag(ah) > 0.5 then
                return Color3.fromHSV(aj / 360, 0, 0.05)
            else
                return Color3.fromHSV(aj / 360, 0, 0.98)
            end
        end
        local ai = function(ai, aj)
            if type(aj) ~= 'number' or aj ~= math.floor(aj) then
                return nil, 1
            end

            local ak = #ai

            if ak == 0 or aj < 1 or aj > ak then
                return nil, 2
            end

            local al = function(al)
                if al == nil then
                    return true
                end

                local am = al.__type

                return am == 'Divider' or am == 'Space' or am == 'Section' or am == 'Code'
            end

            if al(ai[aj]) then
                return nil, 3
            end

            local am = function(am, an)
                if an == 1 then
                    return 'Squircle'
                end
                if am == 1 then
                    return 'Squircle-TL-TR'
                end
                if am == an then
                    return 'Squircle-BL-BR'
                end

                return 'Square'
            end
            local an = 1
            local ao = 0

            for ap = 1, ak do
                local aq = ai[ap]

                if al(aq) then
                    if aj >= an and aj <= ap - 1 then
                        local ar = aj - an + 1

                        return am(ar, ao)
                    end

                    an = ap + 1
                    ao = 0
                else
                    ao = ao + 1
                end
            end

            if aj >= an and aj <= ak then
                local ap = aj - an + 1

                return am(ap, ao)
            end

            return nil, 4
        end

        return function(aj)
            local ak = {
                Title = aj.Title,
                Desc = aj.Desc or nil,
                Hover = aj.Hover,
                Thumbnail = aj.Thumbnail,
                ThumbnailSize = aj.ThumbnailSize or 80,
                Image = aj.Image,
                IconThemed = aj.IconThemed or false,
                ImageSize = aj.ImageSize or 30,
                Color = aj.Color,
                Scalable = aj.Scalable,
                Parent = aj.Parent,
                Justify = aj.Justify or 'Between',
                UIPadding = aj.Window.ElementConfig.UIPadding,
                UICorner = aj.Window.ElementConfig.UICorner,
                Size = aj.Size or 'Default',
                UIElements = {},
                Index = aj.Index,
            }
            local al = ak.Size == 'Small' and -4 or ak.Size == 'Large' and 4 or 0
            local am = ak.Size == 'Small' and -4 or ak.Size == 'Large' and 4 or 0
            local an = ak.ImageSize
            local ao = ak.ThumbnailSize
            local ap = true
            local aq = 0
            local ar
            local as

            if ak.Thumbnail then
                ar = aa.Image(ak.Thumbnail, ak.Title, aj.Window.NewElements and ak.UICorner - 11 or (ak.UICorner - 4), aj.Window.Folder, 'Thumbnail', false, ak.IconThemed)
                ar.Size = UDim2.new(1, 0, 0, ao)
            end
            if ak.Image then
                as = aa.Image(ak.Image, ak.Title, aj.Window.NewElements and ak.UICorner - 11 or (ak.UICorner - 4), aj.Window.Folder, 'Image', ak.IconThemed, not ak.Color and true or false, 'ElementIcon')

                if typeof(ak.Color) == 'string' and not string.find(ak.Image, 'rbxthumb') then
                    as.ImageLabel.ImageColor3 = ah(Color3.fromHex(aa.Colors[ak.Color]))
                elseif typeof(ak.Color) == 'Color3' and not string.find(ak.Image, 'rbxthumb') then
                    as.ImageLabel.ImageColor3 = ah(ak.Color)
                end

                as.Size = UDim2.new(0, an, 0, an)
                aq = an
            end

            local at = function(at, au)
                local av = typeof(ak.Color) == 'string' and ah(Color3.fromHex(aa.Colors[ak.Color])) or typeof(ak.Color) == 'Color3' and ah(ak.Color)

                return ab('TextLabel', {
                    BackgroundTransparency = 1,
                    Text = at or '',
                    TextSize = au == 'Desc' and 15 or 17,
                    TextXAlignment = 'Left',
                    ThemeTag = {
                        TextColor3 = not ak.Color and ('Element' .. au) or nil,
                    },
                    TextColor3 = ak.Color and av or nil,
                    TextTransparency = au == 'Desc' and 0.3 or 0,
                    TextWrapped = true,
                    Size = UDim2.new(ak.Justify == 'Between' and 1 or 0, 0, 0, 0),
                    AutomaticSize = ak.Justify == 'Between' and 'Y' or 'XY',
                    FontFace = Font.new(aa.Font, au == 'Desc' and Enum.FontWeight.Medium or Enum.FontWeight.SemiBold),
                })
            end
            local au = at(ak.Title, 'Title')
            local av = at(ak.Desc, 'Desc')

            if not ak.Title or ak.Title == '' then
                av.Visible = false
            end
            if not ak.Desc or ak.Desc == '' then
                av.Visible = false
            end

            ak.UIElements.Title = au
            ak.UIElements.Desc = av
            ak.UIElements.Container = ab('Frame', {
                Size = UDim2.new(1, 0, 1, 0),
                AutomaticSize = 'Y',
                BackgroundTransparency = 1,
            }, {
                ab('UIListLayout', {
                    Padding = UDim.new(0, ak.UIPadding),
                    FillDirection = 'Vertical',
                    VerticalAlignment = 'Center',
                    HorizontalAlignment = ak.Justify == 'Between' and 'Left' or 'Center',
                }),
                ar,
                ab('Frame', {
                    Size = UDim2.new(ak.Justify == 'Between' and 1 or 0, ak.Justify == 'Between' and 
-aj.TextOffset or 0, 0, 0),
                    AutomaticSize = ak.Justify == 'Between' and 'Y' or 'XY',
                    BackgroundTransparency = 1,
                    Name = 'TitleFrame',
                }, {
                    ab('UIListLayout', {
                        Padding = UDim.new(0, ak.UIPadding),
                        FillDirection = 'Horizontal',
                        VerticalAlignment = aj.Window.NewElements and (ak.Justify == 'Between' and 'Top' or 'Center') or 'Center',
                        HorizontalAlignment = ak.Justify ~= 'Between' and ak.Justify or 'Center',
                    }),
                    as,
                    ab('Frame', {
                        BackgroundTransparency = 1,
                        AutomaticSize = ak.Justify == 'Between' and 'Y' or 'XY',
                        Size = UDim2.new(ak.Justify == 'Between' and 1 or 0, ak.Justify == 'Between' and (as and 
-aq - ak.UIPadding or -aq) or 0, 1, 0),
                        Name = 'TitleFrame',
                    }, {
                        ab('UIPadding', {
                            PaddingTop = UDim.new(0, (aj.Window.NewElements and ak.UIPadding / 2 or 0) + am),
                            PaddingLeft = UDim.new(0, (aj.Window.NewElements and ak.UIPadding / 2 or 0) + al),
                            PaddingRight = UDim.new(0, (aj.Window.NewElements and ak.UIPadding / 2 or 0) + al),
                            PaddingBottom = UDim.new(0, (aj.Window.NewElements and ak.UIPadding / 2 or 0) + am),
                        }),
                        ab('UIListLayout', {
                            Padding = UDim.new(0, 6),
                            FillDirection = 'Vertical',
                            VerticalAlignment = 'Center',
                            HorizontalAlignment = 'Left',
                        }),
                        au,
                        av,
                    }),
                }),
            })

            local aw = aa.Image('lock', 'lock', 0, aj.Window.Folder, 'Lock', false)

            aw.Size = UDim2.new(0, 20, 0, 20)
            aw.ImageLabel.ImageColor3 = Color3.new(1, 1, 1)
            aw.ImageLabel.ImageTransparency = 0.4

            local ax = ab('TextLabel', {
                Text = 'Locked',
                TextSize = 18,
                FontFace = Font.new(aa.Font, Enum.FontWeight.Medium),
                AutomaticSize = 'XY',
                BackgroundTransparency = 1,
                TextColor3 = Color3.new(1, 1, 1),
                TextTransparency = 0.05,
            })
            local ay = ab('Frame', {
                Size = UDim2.new(1, ak.UIPadding * 2, 1, ak.UIPadding * 2),
                BackgroundTransparency = 1,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(0.5, 0, 0.5, 0),
                ZIndex = 9999999,
            })
            local az, aA = ac(ak.UICorner, 'Squircle', {
                Size = UDim2.new(1, 0, 1, 0),
                ImageTransparency = 0.25,
                ImageColor3 = Color3.new(0, 0, 0),
                Visible = false,
                Active = false,
                Parent = ay,
            }, {
                ab('UIListLayout', {
                    FillDirection = 'Horizontal',
                    VerticalAlignment = 'Center',
                    HorizontalAlignment = 'Center',
                    Padding = UDim.new(0, 8),
                }),
                aw,
                ax,
            }, nil, true)
            local aB, aC = ac(ak.UICorner, 'Squircle-Outline', {
                Size = UDim2.new(1, 0, 1, 0),
                ImageTransparency = 1,
                Active = false,
                ThemeTag = {
                    ImageColor3 = 'Text',
                },
                Parent = ay,
            }, {
                ab('UIListLayout', {
                    FillDirection = 'Horizontal',
                    VerticalAlignment = 'Center',
                    HorizontalAlignment = 'Center',
                    Padding = UDim.new(0, 8),
                }),
            }, nil, true)
            local b, c = ac(ak.UICorner, 'Squircle', {
                Size = UDim2.new(1, 0, 1, 0),
                ImageTransparency = 1,
                Active = false,
                ThemeTag = {
                    ImageColor3 = 'Text',
                },
                Parent = ay,
            }, {
                ab('UIListLayout', {
                    FillDirection = 'Horizontal',
                    VerticalAlignment = 'Center',
                    HorizontalAlignment = 'Center',
                    Padding = UDim.new(0, 8),
                }),
            }, nil, true)
            local d, e = ac(ak.UICorner, 'Squircle-Outline', {
                Size = UDim2.new(1, 0, 1, 0),
                ImageTransparency = 1,
                Active = false,
                ThemeTag = {
                    ImageColor3 = 'Text',
                },
                Parent = ay,
            }, {
                ab('UIListLayout', {
                    FillDirection = 'Horizontal',
                    VerticalAlignment = 'Center',
                    HorizontalAlignment = 'Center',
                    Padding = UDim.new(0, 8),
                }),
                ab('UIGradient', {
                    Name = 'HoverGradient',
                    Color = ColorSequence.new{
                        ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
                        ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
                        ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1)),
                    },
                    Transparency = NumberSequence.new{
                        NumberSequenceKeypoint.new(0, 1),
                        NumberSequenceKeypoint.new(0.25, 0.9),
                        NumberSequenceKeypoint.new(0.5, 0.3),
                        NumberSequenceKeypoint.new(0.75, 0.9),
                        NumberSequenceKeypoint.new(1, 1),
                    },
                }),
            }, nil, true)
            local f, g = ac(ak.UICorner, 'Squircle', {
                Size = UDim2.new(1, 0, 1, 0),
                ImageTransparency = 1,
                Active = false,
                ThemeTag = {
                    ImageColor3 = 'Text',
                },
                Parent = ay,
            }, {
                ab('UIGradient', {
                    Name = 'HoverGradient',
                    Color = ColorSequence.new{
                        ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
                        ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
                        ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1)),
                    },
                    Transparency = NumberSequence.new{
                        NumberSequenceKeypoint.new(0, 1),
                        NumberSequenceKeypoint.new(0.25, 0.9),
                        NumberSequenceKeypoint.new(0.5, 0.3),
                        NumberSequenceKeypoint.new(0.75, 0.9),
                        NumberSequenceKeypoint.new(1, 1),
                    },
                }),
                ab('UIListLayout', {
                    FillDirection = 'Horizontal',
                    VerticalAlignment = 'Center',
                    HorizontalAlignment = 'Center',
                    Padding = UDim.new(0, 8),
                }),
            }, nil, true)
            local i, j = ac(ak.UICorner, 'Squircle', {
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = 'Y',
                ImageTransparency = ak.Color and 0.05 or 0.93,
                Parent = aj.Parent,
                ThemeTag = {
                    ImageColor3 = not ak.Color and 'ElementBackground' or nil,
                },
                ImageColor3 = ak.Color and (typeof(ak.Color) == 'string' and Color3.fromHex(aa.Colors[ak.Color]) or typeof(ak.Color) == 'Color3' and ak.Color) or nil,
            }, {
                ak.UIElements.Container,
                ay,
                ab('UIPadding', {
                    PaddingTop = UDim.new(0, ak.UIPadding),
                    PaddingLeft = UDim.new(0, ak.UIPadding),
                    PaddingRight = UDim.new(0, ak.UIPadding),
                    PaddingBottom = UDim.new(0, ak.UIPadding),
                }),
            }, true, true)

            ak.UIElements.Main = i
            ak.UIElements.Locked = az

            if ak.Hover then
                aa.AddSignal(i.MouseEnter, function()
                    if ap then
                        ad(i, 0.12, {
                            ImageTransparency = ak.Color and 0.15 or 0.9,
                        }):Play()
                        ad(f, 0.12, {ImageTransparency = 0.9}):Play()
                        ad(d, 0.12, {ImageTransparency = 0.8}):Play()
                        aa.AddSignal(i.MouseMoved, function(k, l)
                            f.HoverGradient.Offset = Vector2.new(((k - i.AbsolutePosition.X) / i.AbsoluteSize.X) - 0.5, 0)
                            d.HoverGradient.Offset = Vector2.new(((k - i.AbsolutePosition.X) / i.AbsoluteSize.X) - 0.5, 0)
                        end)
                    end
                end)
                aa.AddSignal(i.InputEnded, function()
                    if ap then
                        ad(i, 0.12, {
                            ImageTransparency = ak.Color and 0.05 or 0.93,
                        }):Play()
                        ad(f, 0.12, {ImageTransparency = 1}):Play()
                        ad(d, 0.12, {ImageTransparency = 1}):Play()
                    end
                end)
            end

            function ak.SetTitle(k, l)
                ak.Title = l
                au.Text = l
            end
            function ak.SetDesc(k, l)
                ak.Desc = l
                av.Text = l or ''

                if not l then
                    av.Visible = false
                elseif not av.Visible then
                    av.Visible = true
                end
            end
            function ak.Colorize(k, l, n)
                if ak.Color then
                    l[n] = typeof(ak.Color) == 'string' and ah(Color3.fromHex(aa.Colors[ak.Color])) or typeof(ak.Color) == 'Color3' and ah(ak.Color) or nil
                end
            end

            if aj.ElementTable then
                aa.AddSignal(au:GetPropertyChangedSignal'Text', function()
                    if ak.Title ~= au.Text then
                        ak:SetTitle(au.Text)

                        aj.ElementTable.Title = au.Text
                    end
                end)
                aa.AddSignal(av:GetPropertyChangedSignal'Text', function()
                    if ak.Desc ~= av.Text then
                        ak:SetDesc(av.Text)

                        aj.ElementTable.Desc = av.Text
                    end
                end)
            end

            function ak.SetThumbnail(k, l, n)
                ak.Thumbnail = l

                if n then
                    ak.ThumbnailSize = n
                    ao = n
                end
                if ar then
                    if l then
                        ar:Destroy()

                        ar = aa.Image(l, ak.Title, ak.UICorner - 3, aj.Window.Folder, 'Thumbnail', false, ak.IconThemed)
                        ar.Size = UDim2.new(1, 0, 0, ao)
                        ar.Parent = ak.UIElements.Container

                        local o = ak.UIElements.Container:FindFirstChild'UIListLayout'

                        if o then
                            ar.LayoutOrder = -1
                        end
                    else
                        ar.Visible = false
                    end
                else
                    if l then
                        ar = aa.Image(l, ak.Title, ak.UICorner - 3, aj.Window.Folder, 'Thumbnail', false, ak.IconThemed)
                        ar.Size = UDim2.new(1, 0, 0, ao)
                        ar.Parent = ak.UIElements.Container

                        local o = ak.UIElements.Container:FindFirstChild'UIListLayout'

                        if o then
                            ar.LayoutOrder = -1
                        end
                    end
                end
            end
            function ak.SetImage(k, l, n)
                ak.Image = l

                if n then
                    ak.ImageSize = n
                    an = n
                end
                if l then
                    local o = as.Parent

                    as:Destroy()

                    as = aa.Image(l, l, ak.UICorner - 3, aj.Window.Folder, 'Image', not ak.Color and true or false)

                    if typeof(ak.Color) == 'string' and not string.find(ak.Image, 'rbxthumb') then
                        as.ImageLabel.ImageColor3 = ah(Color3.fromHex(aa.Colors[ak.Color]))
                    elseif typeof(ak.Color) == 'Color3' and not string.find(ak.Image, 'rbxthumb') then
                        as.ImageLabel.ImageColor3 = ah(ak.Color)
                    end

                    as.Visible = true
                    as.Parent = o
                    as.LayoutOrder = -99
                    as.Size = UDim2.new(0, an, 0, an)
                    aq = ak.ImageSize + ak.UIPadding
                else
                    if as then
                        as.Visible = true
                    end

                    aq = 0
                end

                ak.UIElements.Container.TitleFrame.TitleFrame.Size = UDim2.new(1, 
-aq, 1, 0)
            end
            function ak.Destroy(k)
                i:Destroy()
            end
            function ak.Lock(k, l)
                ap = false
                az.Active = true
                az.Visible = true
                ax.Text = l or 'Locked'
            end
            function ak.Unlock(k)
                ap = true
                az.Active = false
                az.Visible = false
            end
            function ak.Highlight(k)
                local l = ab('UIGradient', {
                    Color = ColorSequence.new{
                        ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
                        ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
                        ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1)),
                    },
                    Transparency = NumberSequence.new{
                        NumberSequenceKeypoint.new(0, 1),
                        NumberSequenceKeypoint.new(0.1, 0.9),
                        NumberSequenceKeypoint.new(0.5, 0.3),
                        NumberSequenceKeypoint.new(0.9, 0.9),
                        NumberSequenceKeypoint.new(1, 1),
                    },
                    Rotation = 0,
                    Offset = Vector2.new(-1, 0),
                    Parent = aB,
                })
                local n = ab('UIGradient', {
                    Color = ColorSequence.new{
                        ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
                        ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
                        ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1)),
                    },
                    Transparency = NumberSequence.new{
                        NumberSequenceKeypoint.new(0, 1),
                        NumberSequenceKeypoint.new(0.15, 0.8),
                        NumberSequenceKeypoint.new(0.5, 0.1),
                        NumberSequenceKeypoint.new(0.85, 0.8),
                        NumberSequenceKeypoint.new(1, 1),
                    },
                    Rotation = 0,
                    Offset = Vector2.new(-1, 0),
                    Parent = b,
                })

                aB.ImageTransparency = 0.65
                b.ImageTransparency = 0.88

                ad(l, 0.75, {
                    Offset = Vector2.new(1, 0),
                }):Play()
                ad(n, 0.75, {
                    Offset = Vector2.new(1, 0),
                }):Play()
                task.spawn(function()
                    task.wait(0.75)

                    aB.ImageTransparency = 1
                    b.ImageTransparency = 1

                    l:Destroy()
                    n:Destroy()
                end)
            end
            function ak.UpdateShape(k)
                if aj.Window.NewElements then
                    local l

                    if aj.ParentConfig.ParentType == 'Group' then
                        l = 'Squircle'
                    else
                        l = ai(k.Elements, ak.Index)
                    end
                    if l and i then
                        j:SetType(l)
                        aA:SetType(l)
                        c:SetType(l)
                        aC:SetType(l .. '-Outline')
                        g:SetType(l)
                        e:SetType(l .. '-Outline')
                    end
                end
            end

            return ak
        end
    end
    function a.C()
        local aa = a.load'c'
        local ab = aa.New
        local ac = {}
        local ad = a.load'l'.New

        function ac.New(ae, af)
            af.Hover = false
            af.TextOffset = 0
            af.ParentConfig = af
            af.IsButtons = af.Buttons and #af.Buttons > 0 and true or false

            local ag = {
                __type = 'Paragraph',
                Title = af.Title or 'Paragraph',
                Desc = af.Desc or nil,
                Locked = af.Locked or false,
            }
            local ah = a.load'B'(af)

            ag.ParagraphFrame = ah

            if af.Buttons and #af.Buttons > 0 then
                local ai = ab('Frame', {
                    Size = UDim2.new(1, 0, 0, 38),
                    BackgroundTransparency = 1,
                    AutomaticSize = 'Y',
                    Parent = ah.UIElements.Container,
                }, {
                    ab('UIListLayout', {
                        Padding = UDim.new(0, 10),
                        FillDirection = 'Vertical',
                    }),
                })

                for aj, ak in next, af.Buttons do
                    local al = ad(ak.Title, ak.Icon, ak.Callback, 'White', ai, nil, nil, af.Window.NewElements and 999 or 10)

                    al.Size = UDim2.new(1, 0, 0, 38)
                end
            end

            return ag.__type, ag
        end

        return ac
    end
    function a.D()
        local aa = a.load'c'
        local ab = aa.New
        local ac = {}

        function ac.New(ad, ae)
            local af = {
                __type = 'Button',
                Title = ae.Title or 'Button',
                Desc = ae.Desc or nil,
                Icon = ae.Icon or 'mouse-pointer-click',
                IconThemed = ae.IconThemed or false,
                Color = ae.Color,
                Justify = ae.Justify or 'Between',
                IconAlign = ae.IconAlign or 'Right',
                Locked = ae.Locked or false,
                LockedTitle = ae.LockedTitle,
                Callback = ae.Callback or function() end,
                UIElements = {},
            }
            local ag = true

            af.ButtonFrame = a.load'B'{
                Title = af.Title,
                Desc = af.Desc,
                Parent = ae.Parent,
                Window = ae.Window,
                Color = af.Color,
                Justify = af.Justify,
                TextOffset = 20,
                Hover = true,
                Scalable = true,
                Tab = ae.Tab,
                Index = ae.Index,
                ElementTable = af,
                ParentConfig = ae,
                Size = ae.Size,
            }
            af.UIElements.ButtonIcon = aa.Image(af.Icon, af.Icon, 0, ae.Window.Folder, 'Button', not af.Color and true or nil, af.IconThemed)
            af.UIElements.ButtonIcon.Size = UDim2.new(0, 20, 0, 20)
            af.UIElements.ButtonIcon.Parent = af.Justify == 'Between' and af.ButtonFrame.UIElements.Main or af.ButtonFrame.UIElements.Container.TitleFrame
            af.UIElements.ButtonIcon.LayoutOrder = af.IconAlign == 'Left' and -99999 or 99999
            af.UIElements.ButtonIcon.AnchorPoint = Vector2.new(1, 0.5)
            af.UIElements.ButtonIcon.Position = UDim2.new(1, 0, 0.5, 0)

            af.ButtonFrame:Colorize(af.UIElements.ButtonIcon.ImageLabel, 'ImageColor3')

            function af.Lock(ah)
                af.Locked = true
                ag = false

                return af.ButtonFrame:Lock(af.LockedTitle)
            end
            function af.Unlock(ah)
                af.Locked = false
                ag = true

                return af.ButtonFrame:Unlock()
            end

            if af.Locked then
                af:Lock()
            end

            aa.AddSignal(af.ButtonFrame.UIElements.Main.MouseButton1Click, function(
            )
                if ag then
                    task.spawn(function()
                        aa.SafeCallback(af.Callback)
                    end)
                end
            end)

            return af.__type, af
        end

        return ac
    end
    function a.E()
        local aa = {}
        local ab = a.load'c'
        local ac = ab.New
        local ad = ab.Tween
        local ae = game:GetService'UserInputService'

        function aa.New(af, ag, ah, ai, aj, ak, al)
            local am = {}
            local an = 12
            local ao

            if ag and ag ~= '' then
                ao = ac('ImageLabel', {
                    Size = UDim2.new(0, 13, 0, 13),
                    BackgroundTransparency = 1,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    Image = ab.Icon(ag)[1],
                    ImageRectOffset = ab.Icon(ag)[2].ImageRectPosition,
                    ImageRectSize = ab.Icon(ag)[2].ImageRectSize,
                    ImageTransparency = 1,
                    ImageColor3 = Color3.new(0, 0, 0),
                })
            end

            local ap = ac('Frame', {
                Size = UDim2.new(0, 2, 0, 26),
                BackgroundTransparency = 1,
                Parent = ai,
            })
            local aq = ab.NewRoundFrame(an, 'Squircle', {
                ImageTransparency = 0.85,
                ThemeTag = {
                    ImageColor3 = 'Text',
                },
                Parent = ap,
                Size = UDim2.new(0, ak and (52) or (40.8), 0, 24),
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(0, 0, 0.5, 0),
            }, {
                ab.NewRoundFrame(an, 'Squircle', {
                    Size = UDim2.new(1, 0, 1, 0),
                    Name = 'Layer',
                    ThemeTag = {
                        ImageColor3 = 'Toggle',
                    },
                    ImageTransparency = 1,
                }),
                ab.NewRoundFrame(an, 'SquircleOutline', {
                    Size = UDim2.new(1, 0, 1, 0),
                    Name = 'Stroke',
                    ImageColor3 = Color3.new(1, 1, 1),
                    ImageTransparency = 1,
                }, {
                    ac('UIGradient', {
                        Rotation = 90,
                        Transparency = NumberSequence.new{
                            NumberSequenceKeypoint.new(0, 0),
                            NumberSequenceKeypoint.new(1, 1),
                        },
                    }),
                }),
                ab.NewRoundFrame(an, 'Squircle', {
                    Size = UDim2.new(0, ak and 30 or 20, 0, 20),
                    Position = UDim2.new(0, 2, 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5),
                    ImageTransparency = 1,
                    Name = 'Frame',
                }, {
                    ab.NewRoundFrame(an, 'Squircle', {
                        Size = UDim2.new(1, 0, 1, 0),
                        ImageTransparency = 0,
                        ThemeTag = {
                            ImageColor3 = 'ToggleBar',
                        },
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Position = UDim2.new(0.5, 0, 0.5, 0),
                        Name = 'Bar',
                    }, {
                        ab.NewRoundFrame(an, 'Glass-1', {
                            Size = UDim2.new(1, 0, 1, 0),
                            ImageColor3 = Color3.new(1, 1, 1),
                            Name = 'Highlight',
                            ImageTransparency = 0.4,
                        }, {}),
                        ao,
                        ac('UIScale', {Scale = 1}),
                    }),
                }),
            })
            local ar
            local as
            local at = ak and 30 or 20
            local au = aq.Size.X.Offset

            function am.Set(av, aw, ax, ay)
                if not ay then
                    if aw then
                        ad(aq.Frame, 0.15, {
                            Position = UDim2.new(0, au - at - 2, 0.5, 0),
                        }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                    else
                        ad(aq.Frame, 0.15, {
                            Position = UDim2.new(0, 2, 0.5, 0),
                        }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                    end
                else
                    if aw then
                        aq.Frame.Position = UDim2.new(0, au - at - 2, 0.5, 0)
                    else
                        aq.Frame.Position = UDim2.new(0, 2, 0.5, 0)
                    end
                end
                if aw then
                    ad(aq.Layer, 0.1, {ImageTransparency = 0}):Play()

                    if ao then
                        ad(ao, 0.1, {ImageTransparency = 0}):Play()
                    end
                else
                    ad(aq.Layer, 0.1, {ImageTransparency = 1}):Play()

                    if ao then
                        ad(ao, 0.1, {ImageTransparency = 1}):Play()
                    end
                end

                ax = ax ~= false

                task.spawn(function()
                    if aj and ax then
                        ab.SafeCallback(aj, aw)
                    end
                end)
            end
            function am.Animate(av, aw, ax)
                if not al.Window.IsToggleDragging then
                    al.Window.IsToggleDragging = true

                    local ay = aw.Position.X
                    local az = aw.Position.Y
                    local aA = aq.Frame.Position.X.Offset
                    local aB = false

                    ad(aq.Frame.Bar.UIScale, 0.28, {Scale = 1.5}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                    ad(aq.Frame.Bar, 0.28, {ImageTransparency = 0.85}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()

                    if ar then
                        ar:Disconnect()
                    end

                    ar = ae.InputChanged:Connect(function(aC)
                        if al.Window.IsToggleDragging and (aC.UserInputType == Enum.UserInputType.MouseMovement or aC.UserInputType == Enum.UserInputType.Touch) then
                            if aB then
                                return
                            end

                            local b = math.abs(aC.Position.X - ay)
                            local c = math.abs(aC.Position.Y - az)

                            if c > b and c > 10 then
                                aB = true
                                al.Window.IsToggleDragging = false

                                if ar then
                                    ar:Disconnect()

                                    ar = nil
                                end
                                if as then
                                    as:Disconnect()

                                    as = nil
                                end

                                ad(aq.Frame, 0.15, {
                                    Position = UDim2.new(0, aA, 0.5, 0),
                                }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                                ad(aq.Frame.Bar.UIScale, 0.23, {Scale = 1}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                                ad(aq.Frame.Bar, 0.23, {ImageTransparency = 0}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()

                                return
                            end

                            local d = aC.Position.X - ay
                            local e = math.max(2, math.min(aA + d, au - at - 2))
                            local f = (aq.Frame.Position.X.Offset - 2) / (au - at - 4)

                            ad(aq.Frame, 0.05, {
                                Position = UDim2.new(0, e, 0.5, 0),
                            }, Enum.EasingStyle.Linear, Enum.EasingDirection.Out):Play()
                        end
                    end)

                    if as then
                        as:Disconnect()
                    end

                    as = ae.InputEnded:Connect(function(aC)
                        if al.Window.IsToggleDragging and (aC.UserInputType == Enum.UserInputType.MouseButton1 or aC.UserInputType == Enum.UserInputType.Touch) then
                            al.Window.IsToggleDragging = false

                            if ar then
                                ar:Disconnect()

                                ar = nil
                            end
                            if as then
                                as:Disconnect()

                                as = nil
                            end
                            if aB then
                                return
                            end

                            local b = aq.Frame.Position.X.Offset
                            local c = math.abs(aC.Position.X - ay)

                            if c < 10 then
                                local d = not ax.Value

                                ax:Set(d, true, false)
                            else
                                local d = b + at / 2
                                local e = au / 2
                                local f = d > e

                                ax:Set(f, true, false)
                            end

                            ad(aq.Frame.Bar.UIScale, 0.23, {Scale = 1}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                            ad(aq.Frame.Bar, 0.23, {ImageTransparency = 0}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                        end
                    end)
                end
            end

            return ap, am
        end

        return aa
    end
    function a.F()
        local aa = {}
        local ab = a.load'c'
        local ac = ab.New
        local ad = ab.Tween

        function aa.New(ae, af, ag, ah, ai, aj)
            local ak = {}

            af = af or 'sfsymbols:checkmark'

            local al = 9
            local am = ab.Image(af, af, 0, (aj and aj.Window.Folder or 'Temp'), 'Checkbox', true, false, 'CheckboxIcon')

            am.Size = UDim2.new(1, -26 + ag, 1, -26 + ag)
            am.AnchorPoint = Vector2.new(0.5, 0.5)
            am.Position = UDim2.new(0.5, 0, 0.5, 0)

            local an = ab.NewRoundFrame(al, 'Squircle', {
                ImageTransparency = 0.85,
                ThemeTag = {
                    ImageColor3 = 'Text',
                },
                Parent = ah,
                Size = UDim2.new(0, 26, 0, 26),
            }, {
                ab.NewRoundFrame(al, 'Squircle', {
                    Size = UDim2.new(1, 0, 1, 0),
                    Name = 'Layer',
                    ThemeTag = {
                        ImageColor3 = 'Checkbox',
                    },
                    ImageTransparency = 1,
                }),
                ab.NewRoundFrame(al, 'Glass-1.4', {
                    Size = UDim2.new(1, 0, 1, 0),
                    Name = 'Stroke',
                    ThemeTag = {
                        ImageColor3 = 'CheckboxBorder',
                        ImageTransparency = 'CheckboxBorderTransparency',
                    },
                }, {}),
                am,
            })

            function ak.Set(ao, ap)
                if ap then
                    ad(an.Layer, 0.06, {ImageTransparency = 0}):Play()
                    ad(am.ImageLabel, 0.06, {ImageTransparency = 0}):Play()
                else
                    ad(an.Layer, 0.05, {ImageTransparency = 1}):Play()
                    ad(am.ImageLabel, 0.06, {ImageTransparency = 1}):Play()
                end

                task.spawn(function()
                    if ai then
                        ab.SafeCallback(ai, ap)
                    end
                end)
            end

            return an, ak
        end

        return aa
    end
    function a.G()
        local aa = a.load'c'
        local ab = aa.New
        local ac = aa.Tween
        local ad = a.load'E'.New
        local ae = a.load'F'.New
        local af = {}

        function af.New(ag, ah)
            local ai = {
                __type = 'Toggle',
                Title = ah.Title or 'Toggle',
                Desc = ah.Desc or nil,
                Locked = ah.Locked or false,
                LockedTitle = ah.LockedTitle,
                Value = ah.Value,
                Icon = ah.Icon or nil,
                IconSize = ah.IconSize or 23,
                Type = ah.Type or 'Toggle',
                Callback = ah.Callback or function() end,
                UIElements = {},
            }

            ai.ToggleFrame = a.load'B'{
                Title = ai.Title,
                Desc = ai.Desc,
                Window = ah.Window,
                Parent = ah.Parent,
                TextOffset = (52),
                Hover = false,
                Tab = ah.Tab,
                Index = ah.Index,
                ElementTable = ai,
                ParentConfig = ah,
            }

            local aj = true

            if ai.Value == nil then
                ai.Value = false
            end

            function ai.Lock(ak)
                ai.Locked = true
                aj = false

                return ai.ToggleFrame:Lock(ai.LockedTitle)
            end
            function ai.Unlock(ak)
                ai.Locked = false
                aj = true

                return ai.ToggleFrame:Unlock()
            end

            if ai.Locked then
                ai:Lock()
            end

            local ak = ai.Value
            local al, am

            if ai.Type == 'Toggle' then
                al, am = ad(ak, ai.Icon, ai.IconSize, ai.ToggleFrame.UIElements.Main, ai.Callback, ah.Window.NewElements, ah)
            elseif ai.Type == 'Checkbox' then
                al, am = ae(ak, ai.Icon, ai.IconSize, ai.ToggleFrame.UIElements.Main, ai.Callback, ah)
            else
                error('Unknown Toggle Type: ' .. tostring(ai.Type))
            end

            al.AnchorPoint = Vector2.new(1, ah.Window.NewElements and 0 or 0.5)
            al.Position = UDim2.new(1, 0, ah.Window.NewElements and 0 or 0.5, 0)

            function ai.Set(an, ao, ap, aq)
                if aj then
                    am:Set(ao, ap, aq or false)

                    ak = ao
                    ai.Value = ao
                end
            end

            ai:Set(ak, false, ah.Window.NewElements)

            if ah.Window.NewElements and am.Animate then
                aa.AddSignal(ai.ToggleFrame.UIElements.Main.InputBegan, function(
                    an
                )
                    if not ah.Window.IsToggleDragging and an.UserInputType == Enum.UserInputType.MouseButton1 or an.UserInputType == Enum.UserInputType.Touch then
                        am:Animate(an, ai)
                    end
                end)
            else
                aa.AddSignal(ai.ToggleFrame.UIElements.Main.MouseButton1Click, function(
                )
                    ai:Set(not ai.Value, nil, ah.Window.NewElements)
                end)
            end

            return ai.__type, ai
        end

        return af
    end
    function a.H()
        local aa = (cloneref or clonereference or function(aa)
            return aa
        end)
        local ac = aa(game:GetService'UserInputService')
        local ad = aa(game:GetService'RunService')
        local ae = a.load'c'
        local af = ae.New
        local ag = ae.Tween
        local ah = {}
        local ai = false

        function ah.New(aj, ak)
            local al = {
                __type = 'Slider',
                Title = ak.Title or nil,
                Desc = ak.Desc or nil,
                Locked = ak.Locked or nil,
                LockedTitle = ak.LockedTitle,
                Value = ak.Value or {},
                Icons = ak.Icons or nil,
                IsTooltip = ak.IsTooltip or false,
                IsTextbox = ak.IsTextbox,
                Step = ak.Step or 1,
                Callback = ak.Callback or function() end,
                UIElements = {},
                IsFocusing = false,
                Width = ak.Width or 130,
                TextBoxWidth = ak.Window.NewElements and 40 or 30,
                ThumbSize = 13,
                IconSize = 26,
            }

            if al.Icons == {} then
                al.Icons = {
                    From = 'sfsymbols:sunMinFill',
                    To = 'sfsymbols:sunMaxFill',
                }
            end
            if al.IsTextbox == nil and al.Title == nil then
                al.IsTextbox = false
            else
                al.IsTextbox = al.IsTextbox ~= false
            end

            local am
            local an
            local ao
            local ap = al.Value.Default or al.Value.Min or 0
            local aq = ap
            local ar = (ap - (al.Value.Min or 0)) / ((al.Value.Max or 100) - (al.Value.Min or 0))
            local as = true
            local at = al.Step % 1 ~= 0
            local au = function(au)
                if at then
                    return tonumber(string.format('%.2f', au))
                end

                return math.floor(au + 0.5)
            end
            local av = function(av)
                if at then
                    return math.floor(av / al.Step + 0.5) * al.Step
                else
                    return math.floor(av / al.Step + 0.5) * al.Step
                end
            end
            local aw, ax
            local ay = 32

            if al.Icons then
                if al.Icons.From then
                    aw = ae.Image(al.Icons.From, al.Icons.From, 0, ak.Window.Folder, 'SliderIconFrom', true, true, 'SliderIconFrom')
                    aw.Size = UDim2.new(0, al.IconSize, 0, al.IconSize)
                    ay = ay + al.IconSize - 2
                end
                if al.Icons.To then
                    ax = ae.Image(al.Icons.To, al.Icons.To, 0, ak.Window.Folder, 'SliderIconTo', true, true, 'SliderIconTo')
                    ax.Size = UDim2.new(0, al.IconSize, 0, al.IconSize)
                    ay = ay + al.IconSize - 2
                end
            end

            al.SliderFrame = a.load'B'{
                Title = al.Title,
                Desc = al.Desc,
                Parent = ak.Parent,
                TextOffset = al.Width,
                Hover = false,
                Tab = ak.Tab,
                Index = ak.Index,
                Window = ak.Window,
                ElementTable = al,
                ParentConfig = ak,
            }
            al.UIElements.SliderIcon = ae.NewRoundFrame(99, 'Squircle', {
                ImageTransparency = 0.95,
                Size = UDim2.new(1, not al.IsTextbox and -ay or (-al.TextBoxWidth - 8), 0, 4),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(0.5, 0, 0.5, 0),
                Name = 'Frame',
                ThemeTag = {
                    ImageColor3 = 'Text',
                },
            }, {
                ae.NewRoundFrame(99, 'Squircle', {
                    Name = 'Frame',
                    Size = UDim2.new(ar, 0, 1, 0),
                    ImageTransparency = 0.1,
                    ThemeTag = {
                        ImageColor3 = 'Slider',
                    },
                }, {
                    ae.NewRoundFrame(99, 'Squircle', {
                        Size = UDim2.new(0, ak.Window.NewElements and (al.ThumbSize * 2) or (al.ThumbSize + 2), 0, ak.Window.NewElements and (al.ThumbSize + 4) or (al.ThumbSize + 2)),
                        Position = UDim2.new(1, 0, 0.5, 0),
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        ThemeTag = {
                            ImageColor3 = 'SliderThumb',
                        },
                        Name = 'Thumb',
                    }, {
                        ae.NewRoundFrame(99, 'Glass-1', {
                            Size = UDim2.new(1, 0, 1, 0),
                            ImageColor3 = Color3.new(1, 1, 1),
                            Name = 'Highlight',
                            ImageTransparency = 0.6,
                        }, {}),
                    }),
                }),
            })
            al.UIElements.SliderContainer = af('Frame', {
                Size = UDim2.new(al.Title == nil and 1 or 0, al.Title == nil and 0 or al.Width, 0, 0),
                AutomaticSize = 'Y',
                Position = UDim2.new(1, al.IsTextbox and (ak.Window.NewElements and 
-16 or 0) or 0, 0.5, 0),
                AnchorPoint = Vector2.new(1, 0.5),
                BackgroundTransparency = 1,
                Parent = al.SliderFrame.UIElements.Main,
            }, {
                af('UIListLayout', {
                    Padding = UDim.new(0, al.Title ~= nil and 8 or 12),
                    FillDirection = 'Horizontal',
                    VerticalAlignment = 'Center',
                    HorizontalAlignment = al.Icons and (al.Icons.From and (al.Icons.To and 'Center' or 'Left') or al.Icons.To and 'Right') or 'Center',
                }),
                aw,
                al.UIElements.SliderIcon,
                ax,
                af('TextBox', {
                    Size = UDim2.new(0, al.TextBoxWidth, 0, 0),
                    TextXAlignment = 'Left',
                    Text = au(ap),
                    ThemeTag = {
                        TextColor3 = 'Text',
                    },
                    TextTransparency = 0.4,
                    AutomaticSize = 'Y',
                    TextSize = 15,
                    FontFace = Font.new(ae.Font, Enum.FontWeight.Medium),
                    BackgroundTransparency = 1,
                    LayoutOrder = -1,
                    Visible = al.IsTextbox,
                }),
            })

            local az

            if al.IsTooltip then
                az = a.load'A'.New(ap, al.UIElements.SliderIcon.Frame.Thumb, true, 'Secondary', 'Small', false)
                az.Container.AnchorPoint = Vector2.new(0.5, 1)
                az.Container.Position = UDim2.new(0.5, 0, 0, -8)
            end

            function al.Lock(aA)
                al.Locked = true
                as = false

                return al.SliderFrame:Lock(al.LockedTitle)
            end
            function al.Unlock(aA)
                al.Locked = false
                as = true

                return al.SliderFrame:Unlock()
            end

            if al.Locked then
                al:Lock()
            end

            local aA = ak.Tab.UIElements.ContainerFrame

            function al.Set(aB, aC, b)
                if as then
                    if not al.IsFocusing and not ai and (not b or (b.UserInputType == Enum.UserInputType.MouseButton1 or b.UserInputType == Enum.UserInputType.Touch)) then
                        if b then
                            am = (b.UserInputType == Enum.UserInputType.Touch)
                            aA.ScrollingEnabled = false
                            ai = true

                            local c = am and b.Position.X or ac:GetMouseLocation().X
                            local d = math.clamp((c - al.UIElements.SliderIcon.AbsolutePosition.X) / al.UIElements.SliderIcon.AbsoluteSize.X, 0, 1)

                            aC = av(al.Value.Min + d * (al.Value.Max - al.Value.Min))
                            aC = math.clamp(aC, al.Value.Min or 0, al.Value.Max or 100)

                            if aC ~= aq then
                                ag(al.UIElements.SliderIcon.Frame, 0.05, {
                                    Size = UDim2.new(d, 0, 1, 0),
                                }):Play()

                                al.UIElements.SliderContainer.TextBox.Text = au(aC)

                                if az then
                                    az.TitleFrame.Text = au(aC)
                                end

                                al.Value.Default = au(aC)
                                aq = aC

                                ae.SafeCallback(al.Callback, au(aC))
                            end

                            an = ad.RenderStepped:Connect(function()
                                local e = am and b.Position.X or ac:GetMouseLocation().X
                                local f = math.clamp((e - al.UIElements.SliderIcon.AbsolutePosition.X) / al.UIElements.SliderIcon.AbsoluteSize.X, 0, 1)

                                aC = av(al.Value.Min + f * (al.Value.Max - al.Value.Min))

                                if aC ~= aq then
                                    ag(al.UIElements.SliderIcon.Frame, 0.05, {
                                        Size = UDim2.new(f, 0, 1, 0),
                                    }):Play()

                                    al.UIElements.SliderContainer.TextBox.Text = au(aC)

                                    if az then
                                        az.TitleFrame.Text = au(aC)
                                    end

                                    al.Value.Default = au(aC)
                                    aq = aC

                                    ae.SafeCallback(al.Callback, au(aC))
                                end
                            end)
                            ao = ac.InputEnded:Connect(function(e)
                                if (e.UserInputType == Enum.UserInputType.MouseButton1 or e.UserInputType == Enum.UserInputType.Touch) and b == e then
                                    an:Disconnect()
                                    ao:Disconnect()

                                    ai = false
                                    aA.ScrollingEnabled = true

                                    if ak.Window.NewElements then
                                        ag(al.UIElements.SliderIcon.Frame.Thumb, 0.2, {
                                            ImageTransparency = 0,
                                            Size = UDim2.new(0, ak.Window.NewElements and (al.ThumbSize * 2) or (al.ThumbSize + 2), 0, ak.Window.NewElements and (al.ThumbSize + 4) or (al.ThumbSize + 2)),
                                        }, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut):Play()
                                    end
                                    if az then
                                        az:Close(false)
                                    end
                                end
                            end)
                        else
                            aC = math.clamp(aC, al.Value.Min or 0, al.Value.Max or 100)

                            local c = math.clamp((aC - (al.Value.Min or 0)) / ((al.Value.Max or 100) - (al.Value.Min or 0)), 0, 1)

                            aC = av(al.Value.Min + c * (al.Value.Max - al.Value.Min))

                            if aC ~= aq then
                                ag(al.UIElements.SliderIcon.Frame, 0.05, {
                                    Size = UDim2.new(c, 0, 1, 0),
                                }):Play()

                                al.UIElements.SliderContainer.TextBox.Text = au(aC)

                                if az then
                                    az.TitleFrame.Text = au(aC)
                                end

                                al.Value.Default = au(aC)
                                aq = aC

                                ae.SafeCallback(al.Callback, au(aC))
                            end
                        end
                    end
                end
            end
            function al.SetMax(aB, aC)
                al.Value.Max = aC

                local b = tonumber(al.Value.Default) or aq

                if b > aC then
                    al:Set(aC)
                else
                    local c = math.clamp((b - (al.Value.Min or 0)) / (aC - (al.Value.Min or 0)), 0, 1)

                    ag(al.UIElements.SliderIcon.Frame, 0.1, {
                        Size = UDim2.new(c, 0, 1, 0),
                    }):Play()
                end
            end
            function al.SetMin(aB, aC)
                al.Value.Min = aC

                local b = tonumber(al.Value.Default) or aq

                if b < aC then
                    al:Set(aC)
                else
                    local c = math.clamp((b - aC) / ((al.Value.Max or 100) - aC), 0, 1)

                    ag(al.UIElements.SliderIcon.Frame, 0.1, {
                        Size = UDim2.new(c, 0, 1, 0),
                    }):Play()
                end
            end

            ae.AddSignal(al.UIElements.SliderContainer.TextBox.FocusLost, function(
                aB
            )
                if aB then
                    local aC = tonumber(al.UIElements.SliderContainer.TextBox.Text)

                    if aC then
                        al:Set(aC)
                    else
                        al.UIElements.SliderContainer.TextBox.Text = au(aq)

                        if az then
                            az.TitleFrame.Text = au(aq)
                        end
                    end
                end
            end)
            ae.AddSignal(al.UIElements.SliderContainer.InputBegan, function(aB)
                if al.Locked or ai then
                    return
                end

                al:Set(ap, aB)

                if aB.UserInputType == Enum.UserInputType.MouseButton1 or aB.UserInputType == Enum.UserInputType.Touch then
                    if ak.Window.NewElements then
                        ag(al.UIElements.SliderIcon.Frame.Thumb, 0.24, {
                            ImageTransparency = 0.85,
                            Size = UDim2.new(0, (ak.Window.NewElements and (al.ThumbSize * 2) or (al.ThumbSize)) + 8, 0, al.ThumbSize + 8),
                        }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                    end
                    if az then
                        az:Open()
                    end
                end
            end)

            return al.__type, al
        end

        return ah
    end
    function a.I()
        local aa = (cloneref or clonereference or function(aa)
            return aa
        end)
        local ac = aa(game:GetService'UserInputService')
        local ad = a.load'c'
        local ae = ad.New
        local af = ad.Tween
        local ag = {
            UICorner = 6,
            UIPadding = 8,
        }
        local ah = a.load'v'.New

        function ag.New(ai, aj)
            local ak = function(ak)
                if typeof(ak) == 'EnumItem' then
                    return ak.Name
                elseif type(ak) == 'string' then
                    return ak
                else
                    return 'F'
                end
            end
            local al = {
                __type = 'Keybind',
                Title = aj.Title or 'Keybind',
                Desc = aj.Desc or nil,
                Locked = aj.Locked or false,
                LockedTitle = aj.LockedTitle,
                Value = ak(aj.Value) or 'F',
                Callback = aj.Callback or function() end,
                CanChange = aj.CanChange or true,
                Picking = false,
                UIElements = {},
            }
            local am = true

            al.KeybindFrame = a.load'B'{
                Title = al.Title,
                Desc = al.Desc,
                Parent = aj.Parent,
                TextOffset = 85,
                Hover = al.CanChange,
                Tab = aj.Tab,
                Index = aj.Index,
                Window = aj.Window,
                ElementTable = al,
                ParentConfig = aj,
            }
            al.UIElements.Keybind = ah(al.Value, nil, al.KeybindFrame.UIElements.Main, nil, aj.Window.NewElements and 12 or 10)
            al.UIElements.Keybind.Size = UDim2.new(0, 24 + al.UIElements.Keybind.Frame.Frame.TextLabel.TextBounds.X, 0, 42)
            al.UIElements.Keybind.AnchorPoint = Vector2.new(1, 0.5)
            al.UIElements.Keybind.Position = UDim2.new(1, 0, 0.5, 0)

            ae('UIScale', {
                Parent = al.UIElements.Keybind,
                Scale = 0.85,
            })
            ad.AddSignal(al.UIElements.Keybind.Frame.Frame.TextLabel:GetPropertyChangedSignal'TextBounds', function(
            )
                al.UIElements.Keybind.Size = UDim2.new(0, 24 + al.UIElements.Keybind.Frame.Frame.TextLabel.TextBounds.X, 0, 42)
            end)

            function al.Lock(an)
                al.Locked = true
                am = false

                return al.KeybindFrame:Lock(al.LockedTitle)
            end
            function al.Unlock(an)
                al.Locked = false
                am = true

                return al.KeybindFrame:Unlock()
            end
            function al.Set(an, ao)
                local ap = ak(ao)

                al.Value = ap
                al.UIElements.Keybind.Frame.Frame.TextLabel.Text = ap
            end

            if al.Locked then
                al:Lock()
            end

            ad.AddSignal(al.KeybindFrame.UIElements.Main.MouseButton1Click, function(
            )
                if am then
                    if al.CanChange then
                        al.Picking = true
                        al.UIElements.Keybind.Frame.Frame.TextLabel.Text = '...'

                        task.wait(0.2)

                        local an

                        an = ac.InputBegan:Connect(function(ao)
                            local ap

                            if ao.UserInputType == Enum.UserInputType.Keyboard then
                                ap = ao.KeyCode.Name
                            elseif ao.UserInputType == Enum.UserInputType.MouseButton1 then
                                ap = 'MouseLeft'
                            elseif ao.UserInputType == Enum.UserInputType.MouseButton2 then
                                ap = 'MouseRight'
                            end

                            local aq

                            aq = ac.InputEnded:Connect(function(ar)
                                if ar.KeyCode.Name == ap or ap == 'MouseLeft' and ar.UserInputType == Enum.UserInputType.MouseButton1 or ap == 'MouseRight' and ar.UserInputType == Enum.UserInputType.MouseButton2 then
                                    al.Picking = false
                                    al.UIElements.Keybind.Frame.Frame.TextLabel.Text = ap
                                    al.Value = ap

                                    an:Disconnect()
                                    aq:Disconnect()
                                end
                            end)
                        end)
                    end
                end
            end)
            ad.AddSignal(ac.InputBegan, function(an, ao)
                if ac:GetFocusedTextBox() then
                    return
                end
                if not am then
                    return
                end
                if an.UserInputType == Enum.UserInputType.Keyboard then
                    if an.KeyCode.Name == al.Value then
                        ad.SafeCallback(al.Callback, an.KeyCode.Name)
                    end
                elseif an.UserInputType == Enum.UserInputType.MouseButton1 and al.Value == 'MouseLeft' then
                    ad.SafeCallback(al.Callback, 'MouseLeft')
                elseif an.UserInputType == Enum.UserInputType.MouseButton2 and al.Value == 'MouseRight' then
                    ad.SafeCallback(al.Callback, 'MouseRight')
                end
            end)

            return al.__type, al
        end

        return ag
    end
    function a.J()
        local aa = a.load'c'
        local ac = aa.New
        local ad = aa.Tween
        local ae = {
            UICorner = 8,
            UIPadding = 8,
        }
        local af = a.load'l'.New
        local ag = a.load'm'.New

        function ae.New(ah, ai)
            local aj = {
                __type = 'Input',
                Title = ai.Title or 'Input',
                Desc = ai.Desc or nil,
                Type = ai.Type or 'Input',
                Locked = ai.Locked or false,
                LockedTitle = ai.LockedTitle,
                InputIcon = ai.InputIcon or false,
                Placeholder = ai.Placeholder or 'Enter Text...',
                Value = ai.Value or '',
                Callback = ai.Callback or function() end,
                ClearTextOnFocus = ai.ClearTextOnFocus or false,
                UIElements = {},
                Width = 150,
            }
            local ak = true

            aj.InputFrame = a.load'B'{
                Title = aj.Title,
                Desc = aj.Desc,
                Parent = ai.Parent,
                TextOffset = aj.Width,
                Hover = false,
                Tab = ai.Tab,
                Index = ai.Index,
                Window = ai.Window,
                ElementTable = aj,
                ParentConfig = ai,
            }

            local al = ag(aj.Placeholder, aj.InputIcon, aj.Type == 'Textarea' and aj.InputFrame.UIElements.Container or aj.InputFrame.UIElements.Main, aj.Type, function(
                al
            )
                aj:Set(al, true)
            end, nil, ai.Window.NewElements and 12 or 10, aj.ClearTextOnFocus)

            if aj.Type == 'Input' then
                al.Size = UDim2.new(0, aj.Width, 0, 36)
                al.Position = UDim2.new(1, 0, ai.Window.NewElements and 0 or 0.5, 0)
                al.AnchorPoint = Vector2.new(1, ai.Window.NewElements and 0 or 0.5)
            else
                al.Size = UDim2.new(1, 0, 0, 148)
            end

            ac('UIScale', {
                Parent = al,
                Scale = 1,
            })

            function aj.Lock(am)
                aj.Locked = true
                ak = false

                return aj.InputFrame:Lock(aj.LockedTitle)
            end
            function aj.Unlock(am)
                aj.Locked = false
                ak = true

                return aj.InputFrame:Unlock()
            end
            function aj.Set(am, an, ao)
                if ak then
                    aj.Value = an

                    aa.SafeCallback(aj.Callback, an)

                    if not ao then
                        al.Frame.Frame.TextBox.Text = an
                    end
                end
            end
            function aj.SetPlaceholder(am, an)
                al.Frame.Frame.TextBox.PlaceholderText = an
                aj.Placeholder = an
            end

            aj:Set(aj.Value)

            if aj.Locked then
                aj:Lock()
            end

            return aj.__type, aj
        end

        return ae
    end
    function a.K()
        local aa = a.load'c'
        local ac = aa.New
        local ae = {}

        function ae.New(af, ag)
            local ah = ac('Frame', {
                Size = ag.ParentType ~= 'Group' and UDim2.new(1, 0, 0, 1) or UDim2.new(0, 1, 1, 0),
                Position = UDim2.new(0.5, 0, 0.5, 0),
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundTransparency = 0.9,
                ThemeTag = {
                    BackgroundColor3 = 'Text',
                },
            })
            local ai = ac('Frame', {
                Parent = ag.Parent,
                Size = ag.ParentType ~= 'Group' and UDim2.new(1, -7, 0, 7) or UDim2.new(0, 7, 1, 
-7),
                BackgroundTransparency = 1,
            }, {ah})

            return 'Divider', {
                __type = 'Divider',
                ElementFrame = ai,
            }
        end

        return ae
    end
    function a.L()
        local aa = {}
        local ac = (cloneref or clonereference or function(ac)
            return ac
        end)
        local ae = ac(game:GetService'UserInputService')
        local af = ac(game:GetService'Players').LocalPlayer:GetMouse()
        local ag = ac(game:GetService'Workspace').CurrentCamera
        local ah = workspace.CurrentCamera
        local ai = a.load'm'.New
        local aj = a.load'c'
        local ak = aj.New
        local al = aj.Tween

        function aa.New(am, an, ao, ap, aq)
            local ar = {}

            if not an.Callback then
                aq = 'Menu'
            end

            an.UIElements.UIListLayout = ak('UIListLayout', {
                Padding = UDim.new(0, ao.MenuPadding / 1.5),
                FillDirection = 'Vertical',
                HorizontalAlignment = 'Center',
            })
            an.UIElements.Menu = aj.NewRoundFrame(ao.MenuCorner, 'Squircle', {
                ThemeTag = {
                    ImageColor3 = 'Background',
                },
                ImageTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                AnchorPoint = Vector2.new(1, 0),
                Position = UDim2.new(1, 0, 0, 0),
            }, {
                ak('UIPadding', {
                    PaddingTop = UDim.new(0, ao.MenuPadding),
                    PaddingLeft = UDim.new(0, ao.MenuPadding),
                    PaddingRight = UDim.new(0, ao.MenuPadding),
                    PaddingBottom = UDim.new(0, ao.MenuPadding),
                }),
                ak('UIListLayout', {
                    FillDirection = 'Vertical',
                    Padding = UDim.new(0, ao.MenuPadding),
                }),
                ak('Frame', {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, an.SearchBarEnabled and -ao.MenuPadding - ao.SearchBarHeight),
                    ClipsDescendants = true,
                    LayoutOrder = 999,
                }, {
                    ak('UICorner', {
                        CornerRadius = UDim.new(0, ao.MenuCorner - ao.MenuPadding),
                    }),
                    ak('ScrollingFrame', {
                        Size = UDim2.new(1, 0, 1, 0),
                        ScrollBarThickness = 0,
                        ScrollingDirection = 'Y',
                        AutomaticCanvasSize = 'Y',
                        CanvasSize = UDim2.new(0, 0, 0, 0),
                        BackgroundTransparency = 1,
                        ScrollBarImageTransparency = 1,
                    }, {
                        an.UIElements.UIListLayout,
                    }),
                }),
            })
            an.UIElements.MenuCanvas = ak('Frame', {
                Size = UDim2.new(0, an.MenuWidth, 0, 300),
                BackgroundTransparency = 1,
                Position = UDim2.new(-10, 0, -10, 0),
                Visible = false,
                Active = false,
                Parent = am.IntiHub.DropdownGui,
                AnchorPoint = Vector2.new(1, 0),
            }, {
                an.UIElements.Menu,
                ak('UISizeConstraint', {
                    MinSize = Vector2.new(170, 0),
                    MaxSize = Vector2.new(300, 400),
                }),
            })

            local as = function()
                an.UIElements.Menu.Frame.ScrollingFrame.CanvasSize = UDim2.fromOffset(0, an.UIElements.UIListLayout.AbsoluteContentSize.Y)
            end
            local at = function()
                local at = ah.ViewportSize.Y * 0.6
                local au = an.UIElements.UIListLayout.AbsoluteContentSize.Y
                local av = an.SearchBarEnabled and (ao.SearchBarHeight + (ao.MenuPadding * 3)) or (ao.MenuPadding * 2)
                local aw = au + av

                if aw > at then
                    an.UIElements.MenuCanvas.Size = UDim2.fromOffset(an.UIElements.MenuCanvas.AbsoluteSize.X, at)
                else
                    an.UIElements.MenuCanvas.Size = UDim2.fromOffset(an.UIElements.MenuCanvas.AbsoluteSize.X, aw)
                end
            end

            function UpdatePosition()
                local au = an.UIElements.Dropdown or an.DropdownFrame.UIElements.Main
                local av = an.UIElements.MenuCanvas
                local aw = ag.ViewportSize.Y - (au.AbsolutePosition.Y + au.AbsoluteSize.Y) - ao.MenuPadding - 54
                local ax = av.AbsoluteSize.Y + ao.MenuPadding
                local ay = -54

                if aw < ax then
                    ay = ax - aw - 54
                end

                av.Position = UDim2.new(0, au.AbsolutePosition.X + au.AbsoluteSize.X, 0, au.AbsolutePosition.Y + au.AbsoluteSize.Y - ay + (ao.MenuPadding * 2))
            end

            local au

            function ar.Display(av)
                local aw = an.Values
                local ax = ''

                if an.Multi then
                    local ay = {}

                    if typeof(an.Value) == 'table' then
                        for az, aA in ipairs(an.Value)do
                            local aB = typeof(aA) == 'table' and aA.Title or aA

                            ay[aB] = true
                        end
                    end

                    for az, aA in ipairs(aw)do
                        local aB = typeof(aA) == 'table' and aA.Title or aA

                        if ay[aB] then
                            ax = ax .. aB .. ', '
                        end
                    end

                    if #ax > 0 then
                        ax = ax:sub(1, #ax - 2)
                    end
                else
                    ax = typeof(an.Value) == 'table' and an.Value.Title or an.Value or ''
                end
                if an.UIElements.Dropdown then
                    an.UIElements.Dropdown.Frame.Frame.TextLabel.Text = (ax == '' and '--' or ax)
                end
            end

            local av = function(av)
                ar:Display()

                if an.Callback then
                    task.spawn(function()
                        aj.SafeCallback(an.Callback, an.Value)
                    end)
                else
                    task.spawn(function()
                        aj.SafeCallback(av)
                    end)
                end
            end

            function ar.LockValues(aw, ax)
                if not ax then
                    return
                end

                for ay, az in next, an.Tabs do
                    if az and az.UIElements and az.UIElements.TabItem then
                        local aA = az.Name
                        local aB = false

                        for aC, b in next, ax do
                            if aA == b then
                                aB = true

                                break
                            end
                        end

                        if aB then
                            al(az.UIElements.TabItem, 0.1, {ImageTransparency = 1}):Play()
                            al(az.UIElements.TabItem.Highlight, 0.1, {ImageTransparency = 1}):Play()
                            al(az.UIElements.TabItem.Frame.Title.TextLabel, 0.1, {TextTransparency = 0.6}):Play()

                            if az.UIElements.TabIcon then
                                al(az.UIElements.TabIcon.ImageLabel, 0.1, {ImageTransparency = 0.6}):Play()
                            end

                            az.UIElements.TabItem.Active = false
                            az.Locked = true
                        else
                            if az.Selected then
                                al(az.UIElements.TabItem, 0.1, {ImageTransparency = 0.95}):Play()
                                al(az.UIElements.TabItem.Highlight, 0.1, {ImageTransparency = 0.75}):Play()
                                al(az.UIElements.TabItem.Frame.Title.TextLabel, 0.1, {TextTransparency = 0}):Play()

                                if az.UIElements.TabIcon then
                                    al(az.UIElements.TabIcon.ImageLabel, 0.1, {ImageTransparency = 0}):Play()
                                end
                            else
                                al(az.UIElements.TabItem, 0.1, {ImageTransparency = 1}):Play()
                                al(az.UIElements.TabItem.Highlight, 0.1, {ImageTransparency = 1}):Play()
                                al(az.UIElements.TabItem.Frame.Title.TextLabel, 0.1, {
                                    TextTransparency = aq == 'Dropdown' and 0.4 or 0.05,
                                }):Play()

                                if az.UIElements.TabIcon then
                                    al(az.UIElements.TabIcon.ImageLabel, 0.1, {
                                        ImageTransparency = aq == 'Dropdown' and 0.2 or 0,
                                    }):Play()
                                end
                            end

                            az.UIElements.TabItem.Active = true
                            az.Locked = false
                        end
                    end
                end
            end
            function ar.Refresh(aw, ax)
                for ay, az in next, an.UIElements.Menu.Frame.ScrollingFrame:GetChildren()do
                    if not az:IsA'UIListLayout' then
                        az:Destroy()
                    end
                end

                an.Tabs = {}

                if an.SearchBarEnabled then
                    if not au then
                        au = ai('Search...', 'search', an.UIElements.Menu, nil, function(
                            ay
                        )
                            for az, aA in next, an.Tabs do
                                if string.find(string.lower(aA.Name), string.lower(ay), 1, true) then
                                    aA.UIElements.TabItem.Visible = true
                                else
                                    aA.UIElements.TabItem.Visible = false
                                end

                                at()
                                as()
                            end
                        end, true)
                        au.Size = UDim2.new(1, 0, 0, ao.SearchBarHeight)
                        au.Position = UDim2.new(0, 0, 0, 0)
                        au.Name = 'SearchBar'
                    end
                end

                for ay, az in next, ax do
                    if az.Type ~= 'Divider' then
                        local aA = {
                            Name = typeof(az) == 'table' and az.Title or az,
                            Desc = typeof(az) == 'table' and az.Desc or nil,
                            Icon = typeof(az) == 'table' and az.Icon or nil,
                            IconSize = typeof(az) == 'table' and az.IconSize or nil,
                            Original = az,
                            Selected = false,
                            Locked = typeof(az) == 'table' and az.Locked or false,
                            UIElements = {},
                        }
                        local aB

                        if aA.Icon then
                            aB = aj.Image(aA.Icon, aA.Icon, 0, am.Window.Folder, 'Dropdown', true)
                            aB.Size = UDim2.new(0, aA.IconSize or ao.TabIcon, 0, aA.IconSize or ao.TabIcon)
                            aB.ImageLabel.ImageTransparency = aq == 'Dropdown' and 0.2 or 0
                            aA.UIElements.TabIcon = aB
                        end

                        aA.UIElements.TabItem = aj.NewRoundFrame(ao.MenuCorner - ao.MenuPadding, 'Squircle', {
                            Size = UDim2.new(1, 0, 0, 36),
                            AutomaticSize = aA.Desc and 'Y',
                            ImageTransparency = 1,
                            Parent = an.UIElements.Menu.Frame.ScrollingFrame,
                            ImageColor3 = Color3.new(1, 1, 1),
                            Active = not aA.Locked,
                        }, {
                            aj.NewRoundFrame(ao.MenuCorner - ao.MenuPadding, 'Glass-1.4', {
                                Size = UDim2.new(1, 0, 1, 0),
                                ThemeTag = {
                                    ImageColor3 = 'DropdownTabBorder',
                                },
                                ImageTransparency = 1,
                                Name = 'Highlight',
                            }, {}),
                            ak('Frame', {
                                Size = UDim2.new(1, 0, 1, 0),
                                BackgroundTransparency = 1,
                            }, {
                                ak('UIListLayout', {
                                    Padding = UDim.new(0, ao.TabPadding),
                                    FillDirection = 'Horizontal',
                                    VerticalAlignment = 'Center',
                                }),
                                ak('UIPadding', {
                                    PaddingTop = UDim.new(0, ao.TabPadding),
                                    PaddingLeft = UDim.new(0, ao.TabPadding),
                                    PaddingRight = UDim.new(0, ao.TabPadding),
                                    PaddingBottom = UDim.new(0, ao.TabPadding),
                                }),
                                ak('UICorner', {
                                    CornerRadius = UDim.new(0, ao.MenuCorner - ao.MenuPadding),
                                }),
                                aB,
                                ak('Frame', {
                                    Size = UDim2.new(1, aB and -ao.TabPadding - ao.TabIcon or 0, 0, 0),
                                    BackgroundTransparency = 1,
                                    AutomaticSize = 'Y',
                                    Name = 'Title',
                                }, {
                                    ak('TextLabel', {
                                        Text = aA.Name,
                                        TextXAlignment = 'Left',
                                        FontFace = Font.new(aj.Font, Enum.FontWeight.Medium),
                                        ThemeTag = {
                                            TextColor3 = 'Text',
                                            BackgroundColor3 = 'Text',
                                        },
                                        TextSize = 15,
                                        BackgroundTransparency = 1,
                                        TextTransparency = aq == 'Dropdown' and 0.4 or 0.05,
                                        LayoutOrder = 999,
                                        AutomaticSize = 'Y',
                                        Size = UDim2.new(1, 0, 0, 0),
                                    }),
                                    ak('TextLabel', {
                                        Text = aA.Desc or '',
                                        TextXAlignment = 'Left',
                                        FontFace = Font.new(aj.Font, Enum.FontWeight.Regular),
                                        ThemeTag = {
                                            TextColor3 = 'Text',
                                            BackgroundColor3 = 'Text',
                                        },
                                        TextSize = 15,
                                        BackgroundTransparency = 1,
                                        TextTransparency = aq == 'Dropdown' and 0.6 or 0.35,
                                        LayoutOrder = 999,
                                        AutomaticSize = 'Y',
                                        TextWrapped = true,
                                        Size = UDim2.new(1, 0, 0, 0),
                                        Visible = aA.Desc and true or false,
                                        Name = 'Desc',
                                    }),
                                    ak('UIListLayout', {
                                        Padding = UDim.new(0, ao.TabPadding / 3),
                                        FillDirection = 'Vertical',
                                    }),
                                }),
                            }),
                        }, true)

                        if aA.Locked then
                            aA.UIElements.TabItem.Frame.Title.TextLabel.TextTransparency = 0.6

                            if aA.UIElements.TabIcon then
                                aA.UIElements.TabIcon.ImageLabel.ImageTransparency = 0.6
                            end
                        end
                        if an.Multi and typeof(an.Value) == 'string' then
                            for aC, b in next, an.Values do
                                if typeof(b) == 'table' then
                                    if b.Title == an.Value then
                                        an.Value = {b}
                                    end
                                else
                                    if b == an.Value then
                                        an.Value = {
                                            an.Value,
                                        }
                                    end
                                end
                            end
                        end
                        if an.Multi then
                            local aC = false

                            if typeof(an.Value) == 'table' then
                                for b, c in ipairs(an.Value)do
                                    local d = typeof(c) == 'table' and c.Title or c

                                    if d == aA.Name then
                                        aC = true

                                        break
                                    end
                                end
                            end

                            aA.Selected = aC
                        else
                            local aC = typeof(an.Value) == 'table' and an.Value.Title or an.Value

                            aA.Selected = aC == aA.Name
                        end
                        if aA.Selected and not aA.Locked then
                            aA.UIElements.TabItem.ImageTransparency = 0.95
                            aA.UIElements.TabItem.Highlight.ImageTransparency = 0.75
                            aA.UIElements.TabItem.Frame.Title.TextLabel.TextTransparency = 0

                            if aA.UIElements.TabIcon then
                                aA.UIElements.TabIcon.ImageLabel.ImageTransparency = 0
                            end
                        end

                        an.Tabs[ay] = aA

                        ar:Display()

                        if aq == 'Dropdown' then
                            aj.AddSignal(aA.UIElements.TabItem.MouseButton1Click, function(
                            )
                                if aA.Locked then
                                    return
                                end
                                if an.Multi then
                                    if not aA.Selected then
                                        aA.Selected = true

                                        al(aA.UIElements.TabItem, 0.1, {ImageTransparency = 0.95}):Play()
                                        al(aA.UIElements.TabItem.Highlight, 0.1, {ImageTransparency = 0.75}):Play()
                                        al(aA.UIElements.TabItem.Frame.Title.TextLabel, 0.1, {TextTransparency = 0}):Play()

                                        if aA.UIElements.TabIcon then
                                            al(aA.UIElements.TabIcon.ImageLabel, 0.1, {ImageTransparency = 0}):Play()
                                        end

                                        table.insert(an.Value, aA.Original)
                                    else
                                        if not an.AllowNone and #an.Value == 1 then
                                            return
                                        end

                                        aA.Selected = false

                                        al(aA.UIElements.TabItem, 0.1, {ImageTransparency = 1}):Play()
                                        al(aA.UIElements.TabItem.Highlight, 0.1, {ImageTransparency = 1}):Play()
                                        al(aA.UIElements.TabItem.Frame.Title.TextLabel, 0.1, {TextTransparency = 0.4}):Play()

                                        if aA.UIElements.TabIcon then
                                            al(aA.UIElements.TabIcon.ImageLabel, 0.1, {ImageTransparency = 0.2}):Play()
                                        end

                                        for aC, b in next, an.Value do
                                            if typeof(b) == 'table' and (b.Title == aA.Name) or (b == aA.Name) then
                                                table.remove(an.Value, aC)

                                                break
                                            end
                                        end
                                    end
                                else
                                    for aC, b in next, an.Tabs do
                                        al(b.UIElements.TabItem, 0.1, {ImageTransparency = 1}):Play()
                                        al(b.UIElements.TabItem.Highlight, 0.1, {ImageTransparency = 1}):Play()
                                        al(b.UIElements.TabItem.Frame.Title.TextLabel, 0.1, {TextTransparency = 0.4}):Play()

                                        if b.UIElements.TabIcon then
                                            al(b.UIElements.TabIcon.ImageLabel, 0.1, {ImageTransparency = 0.2}):Play()
                                        end

                                        b.Selected = false
                                    end

                                    aA.Selected = true

                                    al(aA.UIElements.TabItem, 0.1, {ImageTransparency = 0.95}):Play()
                                    al(aA.UIElements.TabItem.Highlight, 0.1, {ImageTransparency = 0.75}):Play()
                                    al(aA.UIElements.TabItem.Frame.Title.TextLabel, 0.1, {TextTransparency = 0}):Play()

                                    if aA.UIElements.TabIcon then
                                        al(aA.UIElements.TabIcon.ImageLabel, 0.1, {ImageTransparency = 0}):Play()
                                    end

                                    an.Value = aA.Original
                                end

                                av()
                            end)
                        elseif aq == 'Menu' then
                            if not aA.Locked then
                                aj.AddSignal(aA.UIElements.TabItem.MouseEnter, function(
                                )
                                    al(aA.UIElements.TabItem, 0.08, {ImageTransparency = 0.95}):Play()
                                end)
                                aj.AddSignal(aA.UIElements.TabItem.InputEnded, function(
                                )
                                    al(aA.UIElements.TabItem, 0.08, {ImageTransparency = 1}):Play()
                                end)
                            end

                            aj.AddSignal(aA.UIElements.TabItem.MouseButton1Click, function(
                            )
                                if aA.Locked then
                                    return
                                end

                                av(az.Callback or function() end)
                            end)
                        end

                        as()
                        at()
                    else
                        a.load'K':New{
                            Parent = an.UIElements.Menu.Frame.ScrollingFrame,
                        }
                    end
                end

                an.UIElements.MenuCanvas.Size = UDim2.new(0, an.MenuWidth + 6 + 6 + 5 + 5 + 18 + 6 + 6, an.UIElements.MenuCanvas.Size.Y.Scale, an.UIElements.MenuCanvas.Size.Y.Offset)

                av()

                an.Values = ax
            end

            ar:Refresh(an.Values)

            function ar.Select(aw, ax)
                if ax then
                    an.Value = ax
                else
                    if an.Multi then
                        an.Value = {}
                    else
                        an.Value = nil
                    end
                end

                ar:Refresh(an.Values)
            end

            at()
            as()

            function ar.Open(aw)
                if ap then
                    an.UIElements.Menu.Visible = true
                    an.UIElements.MenuCanvas.Visible = true
                    an.UIElements.MenuCanvas.Active = true
                    an.UIElements.Menu.Size = UDim2.new(1, 0, 0, 0)

                    al(an.UIElements.Menu, 0.1, {
                        Size = UDim2.new(1, 0, 1, 0),
                        ImageTransparency = 0.05,
                    }, Enum.EasingStyle.Quart, Enum.EasingDirection.Out):Play()
                    task.spawn(function()
                        task.wait(0.1)

                        an.Opened = true
                    end)
                    UpdatePosition()
                end
            end
            function ar.Close(aw)
                an.Opened = false

                al(an.UIElements.Menu, 0.25, {
                    Size = UDim2.new(1, 0, 0, 0),
                    ImageTransparency = 1,
                }, Enum.EasingStyle.Quart, Enum.EasingDirection.Out):Play()
                task.spawn(function()
                    task.wait(0.1)

                    an.UIElements.Menu.Visible = false
                end)
                task.spawn(function()
                    task.wait(0.25)

                    an.UIElements.MenuCanvas.Visible = false
                    an.UIElements.MenuCanvas.Active = false
                end)
            end

            aj.AddSignal((an.UIElements.Dropdown and an.UIElements.Dropdown.MouseButton1Click or an.DropdownFrame.UIElements.Main.MouseButton1Click), function(
            )
                ar:Open()
            end)
            aj.AddSignal(ae.InputBegan, function(aw)
                if aw.UserInputType == Enum.UserInputType.MouseButton1 or aw.UserInputType == Enum.UserInputType.Touch then
                    local ax = an.UIElements.MenuCanvas
                    local ay, az = ax.AbsolutePosition, ax.AbsoluteSize
                    local aA = an.UIElements.Dropdown or an.DropdownFrame.UIElements.Main
                    local aB = aA.AbsolutePosition
                    local aC = aA.AbsoluteSize
                    local b = af.X >= aB.X and af.X <= aB.X + aC.X and af.Y >= aB.Y and af.Y <= aB.Y + aC.Y
                    local c = af.X >= ay.X and af.X <= ay.X + az.X and af.Y >= ay.Y and af.Y <= ay.Y + az.Y

                    if am.Window.CanDropdown and an.Opened and not b and not c then
                        ar:Close()
                    end
                end
            end)
            aj.AddSignal(an.UIElements.Dropdown and an.UIElements.Dropdown:GetPropertyChangedSignal'AbsolutePosition' or an.DropdownFrame.UIElements.Main:GetPropertyChangedSignal'AbsolutePosition', UpdatePosition)

            return ar
        end

        return aa
    end
    function a.M()
        local aa = (cloneref or clonereference or function(aa)
            return aa
        end)

        aa(game:GetService'UserInputService')
        aa(game:GetService'Players').LocalPlayer:GetMouse()

        local ac = aa(game:GetService'Workspace').CurrentCamera
        local ae = a.load'c'
        local af = ae.New
        local ag = ae.Tween
        local ah = a.load'v'.New
        local ai = a.load'm'.New
        local aj = a.load'L'.New
        local ak = workspace.CurrentCamera
        local al = {
            UICorner = 10,
            UIPadding = 12,
            MenuCorner = 15,
            MenuPadding = 5,
            TabPadding = 10,
            SearchBarHeight = 39,
            TabIcon = 18,
        }

        function al.New(am, an)
            local ao = {
                __type = 'Dropdown',
                Title = an.Title or 'Dropdown',
                Desc = an.Desc or nil,
                Locked = an.Locked or false,
                LockedTitle = an.LockedTitle,
                Values = an.Values or {},
                MenuWidth = an.MenuWidth or 180,
                Value = an.Value,
                AllowNone = an.AllowNone,
                SearchBarEnabled = an.SearchBarEnabled or false,
                Multi = an.Multi,
                Callback = an.Callback or nil,
                UIElements = {},
                Opened = false,
                Tabs = {},
                Width = 150,
            }

            if ao.Multi and not ao.Value then
                ao.Value = {}
            end
            if ao.Values and typeof(ao.Value) == 'number' then
                ao.Value = ao.Values[ao.Value]
            end

            local ap = true

            ao.DropdownFrame = a.load'B'{
                Title = ao.Title,
                Desc = ao.Desc,
                Parent = an.Parent,
                TextOffset = ao.Callback and ao.Width or 20,
                Hover = not ao.Callback and true or false,
                Tab = an.Tab,
                Index = an.Index,
                Window = an.Window,
                ElementTable = ao,
                ParentConfig = an,
            }

            if ao.Callback then
                ao.UIElements.Dropdown = ah('', nil, ao.DropdownFrame.UIElements.Main, nil, an.Window.NewElements and 12 or 10)
                ao.UIElements.Dropdown.Frame.Frame.TextLabel.TextTruncate = 'AtEnd'
                ao.UIElements.Dropdown.Frame.Frame.TextLabel.Size = UDim2.new(1, ao.UIElements.Dropdown.Frame.Frame.TextLabel.Size.X.Offset - 18 - 12 - 12, 0, 0)
                ao.UIElements.Dropdown.Size = UDim2.new(0, ao.Width, 0, 36)
                ao.UIElements.Dropdown.Position = UDim2.new(1, 0, an.Window.NewElements and 0 or 0.5, 0)
                ao.UIElements.Dropdown.AnchorPoint = Vector2.new(1, an.Window.NewElements and 0 or 0.5)
            end

            ao.DropdownMenu = aj(an, ao, al, ap, 'Dropdown')
            ao.Display = ao.DropdownMenu.Display
            ao.Refresh = ao.DropdownMenu.Refresh
            ao.Select = ao.DropdownMenu.Select
            ao.Open = ao.DropdownMenu.Open
            ao.Close = ao.DropdownMenu.Close

            af('ImageLabel', {
                Image = ae.Icon'chevrons-up-down'[1],
                ImageRectOffset = ae.Icon'chevrons-up-down'[2].ImageRectPosition,
                ImageRectSize = ae.Icon'chevrons-up-down'[2].ImageRectSize,
                Size = UDim2.new(0, 18, 0, 18),
                Position = UDim2.new(1, ao.UIElements.Dropdown and -12 or 0, 0.5, 0),
                ThemeTag = {
                    ImageColor3 = 'Icon',
                },
                AnchorPoint = Vector2.new(1, 0.5),
                Parent = ao.UIElements.Dropdown and ao.UIElements.Dropdown.Frame or ao.DropdownFrame.UIElements.Main,
            })

            function ao.Lock(aq)
                ao.Locked = true
                ap = false

                return ao.DropdownFrame:Lock(ao.LockedTitle)
            end
            function ao.Unlock(aq)
                ao.Locked = false
                ap = true

                return ao.DropdownFrame:Unlock()
            end

            if ao.Locked then
                ao:Lock()
            end

            return ao.__type, ao
        end

        return al
    end
    function a.N()
        local aa = {}
        local ae = {
            lua = {
                'and',
                'break',
                'or',
                'else',
                'elseif',
                'if',
                'then',
                'until',
                'repeat',
                'while',
                'do',
                'for',
                'in',
                'end',
                'local',
                'return',
                'function',
                'export',
            },
            rbx = {
                'game',
                'workspace',
                'script',
                'math',
                'string',
                'table',
                'task',
                'wait',
                'select',
                'next',
                'Enum',
                'tick',
                'assert',
                'shared',
                'loadstring',
                'tonumber',
                'tostring',
                'type',
                'typeof',
                'unpack',
                'Instance',
                'CFrame',
                'Vector3',
                'Vector2',
                'Color3',
                'UDim',
                'UDim2',
                'Ray',
                'BrickColor',
                'OverlapParams',
                'RaycastParams',
                'Axes',
                'Random',
                'Region3',
                'Rect',
                'TweenInfo',
                'collectgarbage',
                'not',
                'utf8',
                'pcall',
                'xpcall',
                '_G',
                'setmetatable',
                'getmetatable',
                'os',
                'pairs',
                'ipairs',
            },
            operators = {
                '#',
                '+',
                '-',
                '*',
                '%',
                '/',
                '^',
                '=',
                '~',
                '=',
                '<',
                '>',
            },
        }
        local af = {
            numbers = Color3.fromHex'#FAB387',
            boolean = Color3.fromHex'#FAB387',
            operator = Color3.fromHex'#94E2D5',
            lua = Color3.fromHex'#CBA6F7',
            rbx = Color3.fromHex'#F38BA8',
            str = Color3.fromHex'#A6E3A1',
            comment = Color3.fromHex'#9399B2',
            null = Color3.fromHex'#F38BA8',
            call = Color3.fromHex'#89B4FA',
            self_call = Color3.fromHex'#89B4FA',
            local_property = Color3.fromHex'#CBA6F7',
        }
        local ah = function(ah)
            local aj = {}

            for ak, al in ipairs(ah)do
                aj[al] = true
            end

            return aj
        end
        local aj = ah(ae.lua)
        local ak = ah(ae.rbx)
        local al = ah(ae.operators)
        local am = function(am, an)
            local ao = am[an]

            if af[ao .. '_color'] then
                return af[ao .. '_color']
            end
            if tonumber(ao) then
                return af.numbers
            elseif ao == 'nil' then
                return af.null
            elseif ao:sub(1, 2) == '--' then
                return af.comment
            elseif al[ao] then
                return af.operator
            elseif aj[ao] then
                return af.lua
            elseif ak[ao] then
                return af.rbx
            elseif ao:sub(1, 1) == '"' or ao:sub(1, 1) == "'" then
                return af.str
            elseif ao == 'true' or ao == 'false' then
                return af.boolean
            end
            if am[an + 1] == '(' then
                if am[an - 1] == ':' then
                    return af.self_call
                end

                return af.call
            end
            if am[an - 1] == '.' then
                if am[an - 2] == 'Enum' then
                    return af.rbx
                end

                return af.local_property
            end
        end

        function aa.run(an)
            local ao = {}
            local ap = ''
            local aq = false
            local ar = false
            local as = false

            for at = 1, #an do
                local au = an:sub(at, at)

                if ar then
                    if au == '\n' and not as then
                        table.insert(ao, ap)
                        table.insert(ao, au)

                        ap = ''
                        ar = false
                    elseif an:sub(at - 1, at) == ']]' and as then
                        ap = ap .. ']'

                        table.insert(ao, ap)

                        ap = ''
                        ar = false
                        as = false
                    else
                        ap = ap .. au
                    end
                elseif aq then
                    if au == aq and an:sub(at - 1, at - 1) ~= '\\' or au == '\n' then
                        ap = ap .. au
                        aq = false
                    else
                        ap = ap .. au
                    end
                else
                    if an:sub(at, at + 1) == '--' then
                        table.insert(ao, ap)

                        ap = '-'
                        ar = true
                        as = an:sub(at + 2, at + 3) == '[['
                    elseif au == '"' or au == "'" then
                        table.insert(ao, ap)

                        ap = au
                        aq = au
                    elseif al[au] then
                        table.insert(ao, ap)
                        table.insert(ao, au)

                        ap = ''
                    elseif au:match'[%w_]' then
                        ap = ap .. au
                    else
                        table.insert(ao, ap)
                        table.insert(ao, au)

                        ap = ''
                    end
                end
            end

            table.insert(ao, ap)

            local at = {}

            for au, av in ipairs(ao)do
                local aw = am(ao, au)

                if aw then
                    local ax = string.format('<font color = "#%s">%s</font>', aw:ToHex(), av:gsub('<', '&lt;'):gsub('>', '&gt;'))

                    table.insert(at, ax)
                else
                    table.insert(at, av)
                end
            end

            return table.concat(at)
        end

        return aa
    end
    function a.O()
        local aa = {}
        local ae = a.load'c'
        local af = ae.New
        local ah = ae.Tween
        local aj = a.load'N'

        function aa.New(ak, al, am, an, ao)
            local ap = {
                Radius = 12,
                Padding = 10,
            }
            local aq = af('TextLabel', {
                Text = '',
                TextColor3 = Color3.fromHex'#CDD6F4',
                TextTransparency = 0,
                TextSize = 14,
                TextWrapped = false,
                LineHeight = 1.15,
                RichText = true,
                TextXAlignment = 'Left',
                Size = UDim2.new(0, 0, 0, 0),
                BackgroundTransparency = 1,
                AutomaticSize = 'XY',
            }, {
                af('UIPadding', {
                    PaddingTop = UDim.new(0, ap.Padding + 3),
                    PaddingLeft = UDim.new(0, ap.Padding + 3),
                    PaddingRight = UDim.new(0, ap.Padding + 3),
                    PaddingBottom = UDim.new(0, ap.Padding + 3),
                }),
            })

            aq.Font = 'Code'

            local ar = af('ScrollingFrame', {
                Size = UDim2.new(1, 0, 0, 0),
                BackgroundTransparency = 1,
                AutomaticCanvasSize = 'X',
                ScrollingDirection = 'X',
                ElasticBehavior = 'Never',
                CanvasSize = UDim2.new(0, 0, 0, 0),
                ScrollBarThickness = 0,
            }, {aq})
            local as = af('TextButton', {
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 30, 0, 30),
                Position = UDim2.new(1, -ap.Padding / 2, 0, ap.Padding / 2),
                AnchorPoint = Vector2.new(1, 0),
                Visible = an and true or false,
            }, {
                ae.NewRoundFrame(ap.Radius - 4, 'Squircle', {
                    ImageColor3 = Color3.fromHex'#ffffff',
                    ImageTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    Name = 'Button',
                }, {
                    af('UIScale', {Scale = 1}),
                    af('ImageLabel', {
                        Image = ae.Icon'copy'[1],
                        ImageRectSize = ae.Icon'copy'[2].ImageRectSize,
                        ImageRectOffset = ae.Icon'copy'[2].ImageRectPosition,
                        BackgroundTransparency = 1,
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Position = UDim2.new(0.5, 0, 0.5, 0),
                        Size = UDim2.new(0, 12, 0, 12),
                        ImageColor3 = Color3.fromHex'#ffffff',
                        ImageTransparency = 0.1,
                    }),
                }),
            })

            ae.AddSignal(as.MouseEnter, function()
                ah(as.Button, 0.05, {ImageTransparency = 0.95}):Play()
                ah(as.Button.UIScale, 0.05, {Scale = 0.9}):Play()
            end)
            ae.AddSignal(as.InputEnded, function()
                ah(as.Button, 0.08, {ImageTransparency = 1}):Play()
                ah(as.Button.UIScale, 0.08, {Scale = 1}):Play()
            end)

            local at = ae.NewRoundFrame(ap.Radius, 'Squircle', {
                ImageColor3 = Color3.fromHex'#212121',
                ImageTransparency = 0.035,
                Size = UDim2.new(1, 0, 0, 20 + (ap.Padding * 2)),
                AutomaticSize = 'Y',
                Parent = am,
            }, {
                ae.NewRoundFrame(ap.Radius, 'SquircleOutline', {
                    Size = UDim2.new(1, 0, 1, 0),
                    ImageColor3 = Color3.fromHex'#ffffff',
                    ImageTransparency = 0.955,
                }),
                af('Frame', {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = 'Y',
                }, {
                    ae.NewRoundFrame(ap.Radius, 'Squircle-TL-TR', {
                        ImageColor3 = Color3.fromHex'#ffffff',
                        ImageTransparency = 0.96,
                        Size = UDim2.new(1, 0, 0, 20 + (ap.Padding * 2)),
                        Visible = al and true or false,
                    }, {
                        af('ImageLabel', {
                            Size = UDim2.new(0, 18, 0, 18),
                            BackgroundTransparency = 1,
                            Image = 'rbxassetid://132464694294269',
                            ImageColor3 = Color3.fromHex'#ffffff',
                            ImageTransparency = 0.2,
                        }),
                        af('TextLabel', {
                            Text = al,
                            TextColor3 = Color3.fromHex'#ffffff',
                            TextTransparency = 0.2,
                            TextSize = 16,
                            AutomaticSize = 'Y',
                            FontFace = Font.new(ae.Font, Enum.FontWeight.Medium),
                            TextXAlignment = 'Left',
                            BackgroundTransparency = 1,
                            TextTruncate = 'AtEnd',
                            Size = UDim2.new(1, as and -20 - (ap.Padding * 2), 0, 0),
                        }),
                        af('UIPadding', {
                            PaddingLeft = UDim.new(0, ap.Padding + 3),
                            PaddingRight = UDim.new(0, ap.Padding + 3),
                        }),
                        af('UIListLayout', {
                            Padding = UDim.new(0, ap.Padding),
                            FillDirection = 'Horizontal',
                            VerticalAlignment = 'Center',
                        }),
                    }),
                    ar,
                    af('UIListLayout', {
                        Padding = UDim.new(0, 0),
                        FillDirection = 'Vertical',
                    }),
                }),
                as,
            })

            ap.CodeFrame = at

            ae.AddSignal(aq:GetPropertyChangedSignal'TextBounds', function()
                ar.Size = UDim2.new(1, 0, 0, (aq.TextBounds.Y / (ao or 1)) + ((ap.Padding + 3) * 2))
            end)

            function ap.Set(au)
                aq.Text = aj.run(au)
            end
            function ap.Destroy()
                at:Destroy()

                ap = nil
            end

            ap.Set(ak)
            ae.AddSignal(as.MouseButton1Click, function()
                if an then
                    an()

                    local au = ae.Icon'check'

                    as.Button.ImageLabel.Image = au[1]
                    as.Button.ImageLabel.ImageRectSize = au[2].ImageRectSize
                    as.Button.ImageLabel.ImageRectOffset = au[2].ImageRectPosition

                    task.wait(1)

                    local av = ae.Icon'copy'

                    as.Button.ImageLabel.Image = av[1]
                    as.Button.ImageLabel.ImageRectSize = av[2].ImageRectSize
                    as.Button.ImageLabel.ImageRectOffset = av[2].ImageRectPosition
                end
            end)

            return ap
        end

        return aa
    end
    function a.P()
        local aa = a.load'c'
        local ae = aa.New
        local af = a.load'O'
        local ah = {}

        function ah.New(aj, ak)
            local al = {
                __type = 'Code',
                Title = ak.Title,
                Code = ak.Code,
                OnCopy = ak.OnCopy,
            }
            local am = not al.Locked
            local an = af.New(al.Code, al.Title, ak.Parent, function()
                if am then
                    local an = al.Title or 'code'
                    local ao, ap = pcall(function()
                        toclipboard(al.Code)

                        if al.OnCopy then
                            al.OnCopy()
                        end
                    end)

                    if not ao then
                        ak.IntiHub:Notify{
                            Title = 'Error',
                            Content = 'The ' .. an .. ' is not copied. Error: ' .. ap,
                            Icon = 'x',
                            Duration = 5,
                        }
                    end
                end
            end, ak.IntiHub.UIScale, al)

            function al.SetCode(ao, ap)
                an.Set(ap)

                al.Code = ap
            end
            function al.Set(ao, ap)
                return al.SetCode(ap)
            end
            function al.Destroy(ao)
                an.Destroy()

                al = nil
            end

            al.ElementFrame = an.CodeFrame

            return al.__type, al
        end

        return ah
    end
    function a.Q()
        local aa = a.load'c'
        local ae = aa.New
        local af = aa.Tween
        local ah = (cloneref or clonereference or function(ah)
            return ah
        end)
        local aj = ah(game:GetService'UserInputService')

        ah(game:GetService'TouchInputService')

        local ak = ah(game:GetService'RunService')
        local al = ah(game:GetService'Players')
        local am = ak.RenderStepped
        local an = al.LocalPlayer
        local ao = an:GetMouse()
        local ap = a.load'l'.New
        local aq = a.load'm'.New
        local ar = {UICorner = 9}

        function ar.Colorpicker(as, at, au, av)
            local aw = {
                __type = 'Colorpicker',
                Title = at.Title,
                Desc = at.Desc,
                Default = at.Value or at.Default,
                Callback = at.Callback,
                Transparency = at.Transparency,
                UIElements = at.UIElements,
                TextPadding = 10,
            }

            function aw.SetHSVFromRGB(ax, ay)
                local az, aA, aB = Color3.toHSV(ay)

                aw.Hue = az
                aw.Sat = aA
                aw.Vib = aB
            end

            aw:SetHSVFromRGB(aw.Default)

            local ax = a.load'n'.Init(au)
            local ay = ax.Create()

            aw.ColorpickerFrame = ay
            ay.UIElements.Main.Size = UDim2.new(1, 0, 0, 0)

            local az, aA, aB = aw.Hue, aw.Sat, aw.Vib

            aw.UIElements.Title = ae('TextLabel', {
                Text = aw.Title,
                TextSize = 20,
                FontFace = Font.new(aa.Font, Enum.FontWeight.SemiBold),
                TextXAlignment = 'Left',
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = 'Y',
                ThemeTag = {
                    TextColor3 = 'Text',
                },
                BackgroundTransparency = 1,
                Parent = ay.UIElements.Main,
            }, {
                ae('UIPadding', {
                    PaddingTop = UDim.new(0, aw.TextPadding / 2),
                    PaddingLeft = UDim.new(0, aw.TextPadding / 2),
                    PaddingRight = UDim.new(0, aw.TextPadding / 2),
                    PaddingBottom = UDim.new(0, aw.TextPadding / 2),
                }),
            })

            local aC = ae('Frame', {
                Size = UDim2.new(0, 14, 0, 14),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(0.5, 0, 0, 0),
                Parent = HueDragHolder,
                BackgroundColor3 = aw.Default,
            }, {
                ae('UIStroke', {
                    Thickness = 2,
                    Transparency = 0.1,
                    ThemeTag = {
                        Color = 'Text',
                    },
                }),
                ae('UICorner', {
                    CornerRadius = UDim.new(1, 0),
                }),
            })

            aw.UIElements.SatVibMap = ae('ImageLabel', {
                Size = UDim2.fromOffset(160, 158),
                Position = UDim2.fromOffset(0, 40 + aw.TextPadding),
                Image = 'rbxassetid://4155801252',
                BackgroundColor3 = Color3.fromHSV(az, 1, 1),
                BackgroundTransparency = 0,
                Parent = ay.UIElements.Main,
            }, {
                ae('UICorner', {
                    CornerRadius = UDim.new(0, 8),
                }),
                aa.NewRoundFrame(8, 'SquircleOutline', {
                    ThemeTag = {
                        ImageColor3 = 'Outline',
                    },
                    Size = UDim2.new(1, 0, 1, 0),
                    ImageTransparency = 0.85,
                    ZIndex = 99999,
                }, {
                    ae('UIGradient', {
                        Rotation = 45,
                        Color = ColorSequence.new{
                            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
                            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
                        },
                        Transparency = NumberSequence.new{
                            NumberSequenceKeypoint.new(0, 0.1),
                            NumberSequenceKeypoint.new(0.5, 1),
                            NumberSequenceKeypoint.new(1, 0.1),
                        },
                    }),
                }),
                aC,
            })
            aw.UIElements.Inputs = ae('Frame', {
                AutomaticSize = 'XY',
                Size = UDim2.new(0, 0, 0, 0),
                Position = UDim2.fromOffset(aw.Transparency and 240 or 210, 40 + aw.TextPadding),
                BackgroundTransparency = 1,
                Parent = ay.UIElements.Main,
            }, {
                ae('UIListLayout', {
                    Padding = UDim.new(0, 4),
                    FillDirection = 'Vertical',
                }),
            })

            local b = ae('Frame', {
                BackgroundColor3 = aw.Default,
                Size = UDim2.fromScale(1, 1),
                BackgroundTransparency = aw.Transparency,
            }, {
                ae('UICorner', {
                    CornerRadius = UDim.new(0, 8),
                }),
            })

            ae('ImageLabel', {
                Image = 'http://www.roblox.com/asset/?id=14204231522',
                ImageTransparency = 0.45,
                ScaleType = Enum.ScaleType.Tile,
                TileSize = UDim2.fromOffset(40, 40),
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(85, 208 + aw.TextPadding),
                Size = UDim2.fromOffset(75, 24),
                Parent = ay.UIElements.Main,
            }, {
                ae('UICorner', {
                    CornerRadius = UDim.new(0, 8),
                }),
                aa.NewRoundFrame(8, 'SquircleOutline', {
                    ThemeTag = {
                        ImageColor3 = 'Outline',
                    },
                    Size = UDim2.new(1, 0, 1, 0),
                    ImageTransparency = 0.85,
                    ZIndex = 99999,
                }, {
                    ae('UIGradient', {
                        Rotation = 60,
                        Color = ColorSequence.new{
                            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
                            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
                        },
                        Transparency = NumberSequence.new{
                            NumberSequenceKeypoint.new(0, 0.1),
                            NumberSequenceKeypoint.new(0.5, 1),
                            NumberSequenceKeypoint.new(1, 0.1),
                        },
                    }),
                }),
                b,
            })

            local c = ae('Frame', {
                BackgroundColor3 = aw.Default,
                Size = UDim2.fromScale(1, 1),
                BackgroundTransparency = 0,
                ZIndex = 9,
            }, {
                ae('UICorner', {
                    CornerRadius = UDim.new(0, 8),
                }),
            })

            ae('ImageLabel', {
                Image = 'http://www.roblox.com/asset/?id=14204231522',
                ImageTransparency = 0.45,
                ScaleType = Enum.ScaleType.Tile,
                TileSize = UDim2.fromOffset(40, 40),
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(0, 208 + aw.TextPadding),
                Size = UDim2.fromOffset(75, 24),
                Parent = ay.UIElements.Main,
            }, {
                ae('UICorner', {
                    CornerRadius = UDim.new(0, 8),
                }),
                aa.NewRoundFrame(8, 'SquircleOutline', {
                    ThemeTag = {
                        ImageColor3 = 'Outline',
                    },
                    Size = UDim2.new(1, 0, 1, 0),
                    ImageTransparency = 0.85,
                    ZIndex = 99999,
                }, {
                    ae('UIGradient', {
                        Rotation = 60,
                        Color = ColorSequence.new{
                            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
                            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
                        },
                        Transparency = NumberSequence.new{
                            NumberSequenceKeypoint.new(0, 0.1),
                            NumberSequenceKeypoint.new(0.5, 1),
                            NumberSequenceKeypoint.new(1, 0.1),
                        },
                    }),
                }),
                c,
            })

            local d = {}

            for e = 0, 1, 0.1 do
                table.insert(d, ColorSequenceKeypoint.new(e, Color3.fromHSV(e, 1, 1)))
            end

            local e = ae('UIGradient', {
                Color = ColorSequence.new(d),
                Rotation = 90,
            })
            local f = ae('Frame', {
                Size = UDim2.new(1, 0, 1, 0),
                Position = UDim2.new(0, 0, 0, 0),
                BackgroundTransparency = 1,
            })
            local g = ae('Frame', {
                Size = UDim2.new(0, 14, 0, 14),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(0.5, 0, 0, 0),
                Parent = f,
                BackgroundColor3 = aw.Default,
            }, {
                ae('UIStroke', {
                    Thickness = 2,
                    Transparency = 0.1,
                    ThemeTag = {
                        Color = 'Text',
                    },
                }),
                ae('UICorner', {
                    CornerRadius = UDim.new(1, 0),
                }),
            })
            local i = ae('Frame', {
                Size = UDim2.fromOffset(6, 192),
                Position = UDim2.fromOffset(180, 40 + aw.TextPadding),
                Parent = ay.UIElements.Main,
            }, {
                ae('UICorner', {
                    CornerRadius = UDim.new(1, 0),
                }),
                e,
                f,
            })

            function CreateNewInput(j, k)
                local l = aq(j, nil, aw.UIElements.Inputs)

                ae('TextLabel', {
                    BackgroundTransparency = 1,
                    TextTransparency = 0.4,
                    TextSize = 17,
                    FontFace = Font.new(aa.Font, Enum.FontWeight.Regular),
                    AutomaticSize = 'XY',
                    ThemeTag = {
                        TextColor3 = 'Placeholder',
                    },
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, -12, 0.5, 0),
                    Parent = l.Frame,
                    Text = j,
                })
                ae('UIScale', {
                    Parent = l,
                    Scale = 0.85,
                })

                l.Frame.Frame.TextBox.Text = k
                l.Size = UDim2.new(0, 150, 0, 42)

                return l
            end

            local j = function(j)
                return {
                    R = math.floor(j.R * 255),
                    G = math.floor(j.G * 255),
                    B = math.floor(j.B * 255),
                }
            end
            local k = CreateNewInput('Hex', '#' .. aw.Default:ToHex())
            local l = CreateNewInput('Red', j(aw.Default).R)
            local n = CreateNewInput('Green', j(aw.Default).G)
            local o = CreateNewInput('Blue', j(aw.Default).B)
            local p

            if aw.Transparency then
                p = CreateNewInput('Alpha', ((1 - aw.Transparency) * 100) .. '%')
            end

            local q = ae('Frame', {
                Size = UDim2.new(1, 0, 0, 40),
                AutomaticSize = 'Y',
                Position = UDim2.new(0, 0, 0, 254 + aw.TextPadding),
                BackgroundTransparency = 1,
                Parent = ay.UIElements.Main,
                LayoutOrder = 4,
            }, {
                ae('UIListLayout', {
                    Padding = UDim.new(0, 6),
                    FillDirection = 'Horizontal',
                    HorizontalAlignment = 'Right',
                }),
            })
            local r = {
                {
                    Title = 'Cancel',
                    Variant = 'Secondary',
                    Callback = function() end,
                },
                {
                    Title = 'Apply',
                    Icon = 'chevron-right',
                    Variant = 'Primary',
                    Callback = function()
                        av(Color3.fromHSV(aw.Hue, aw.Sat, aw.Vib), aw.Transparency)
                    end,
                },
            }

            for s, t in next, r do
                local u = ap(t.Title, t.Icon, t.Callback, t.Variant, q, ay, false)

                u.Size = UDim2.new(0.5, -3, 0, 40)
                u.AutomaticSize = 'None'
            end

            local s, t, u

            if aw.Transparency then
                local v = ae('Frame', {
                    Size = UDim2.new(1, 0, 1, 0),
                    Position = UDim2.fromOffset(0, 0),
                    BackgroundTransparency = 1,
                })

                t = ae('ImageLabel', {
                    Size = UDim2.new(0, 14, 0, 14),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(0.5, 0, 0, 0),
                    ThemeTag = {
                        BackgroundColor3 = 'Text',
                    },
                    Parent = v,
                }, {
                    ae('UIStroke', {
                        Thickness = 2,
                        Transparency = 0.1,
                        ThemeTag = {
                            Color = 'Text',
                        },
                    }),
                    ae('UICorner', {
                        CornerRadius = UDim.new(1, 0),
                    }),
                })
                u = ae('Frame', {
                    Size = UDim2.fromScale(1, 1),
                }, {
                    ae('UIGradient', {
                        Transparency = NumberSequence.new{
                            NumberSequenceKeypoint.new(0, 0),
                            NumberSequenceKeypoint.new(1, 1),
                        },
                        Rotation = 270,
                    }),
                    ae('UICorner', {
                        CornerRadius = UDim.new(0, 6),
                    }),
                })
                s = ae('Frame', {
                    Size = UDim2.fromOffset(6, 192),
                    Position = UDim2.fromOffset(210, 40 + aw.TextPadding),
                    Parent = ay.UIElements.Main,
                    BackgroundTransparency = 1,
                }, {
                    ae('UICorner', {
                        CornerRadius = UDim.new(1, 0),
                    }),
                    ae('ImageLabel', {
                        Image = 'rbxassetid://14204231522',
                        ImageTransparency = 0.45,
                        ScaleType = Enum.ScaleType.Tile,
                        TileSize = UDim2.fromOffset(40, 40),
                        BackgroundTransparency = 1,
                        Size = UDim2.fromScale(1, 1),
                    }, {
                        ae('UICorner', {
                            CornerRadius = UDim.new(1, 0),
                        }),
                    }),
                    u,
                    v,
                })
            end

            function aw.Round(v, w, x)
                if x == 0 then
                    return math.floor(w)
                end

                w = tostring(w)

                return w:find'%.' and tonumber(w:sub(1, w:find'%.' + x)) or w
            end
            function aw.Update(v, w, x)
                if w then
                    az, aA, aB = Color3.toHSV(w)
                else
                    az, aA, aB = aw.Hue, aw.Sat, aw.Vib
                end

                aw.UIElements.SatVibMap.BackgroundColor3 = Color3.fromHSV(az, 1, 1)
                aC.Position = UDim2.new(aA, 0, 1 - aB, 0)
                aC.BackgroundColor3 = Color3.fromHSV(az, aA, aB)
                c.BackgroundColor3 = Color3.fromHSV(az, aA, aB)
                g.BackgroundColor3 = Color3.fromHSV(az, 1, 1)
                g.Position = UDim2.new(0.5, 0, az, 0)
                k.Frame.Frame.TextBox.Text = '#' .. Color3.fromHSV(az, aA, aB):ToHex()
                l.Frame.Frame.TextBox.Text = j(Color3.fromHSV(az, aA, aB)).R
                n.Frame.Frame.TextBox.Text = j(Color3.fromHSV(az, aA, aB)).G
                o.Frame.Frame.TextBox.Text = j(Color3.fromHSV(az, aA, aB)).B

                if x or aw.Transparency then
                    c.BackgroundTransparency = aw.Transparency or x
                    u.BackgroundColor3 = Color3.fromHSV(az, aA, aB)
                    t.BackgroundColor3 = Color3.fromHSV(az, aA, aB)
                    t.BackgroundTransparency = aw.Transparency or x
                    t.Position = UDim2.new(0.5, 0, 1 - aw.Transparency or x, 0)
                    p.Frame.Frame.TextBox.Text = aw:Round((1 - aw.Transparency or x) * 100, 0) .. '%'
                end
            end

            aw:Update(aw.Default, aw.Transparency)

            local v = function()
                local v = Color3.fromHSV(aw.Hue, aw.Sat, aw.Vib)

                return {
                    R = math.floor(v.r * 255),
                    G = math.floor(v.g * 255),
                    B = math.floor(v.b * 255),
                }
            end
            local w = function(w, x, y)
                return math.clamp(tonumber(w) or 0, x, y)
            end

            aa.AddSignal(k.Frame.Frame.TextBox.FocusLost, function(x)
                if x then
                    local y = k.Frame.Frame.TextBox.Text:gsub('#', '')
                    local z, A = pcall(Color3.fromHex, y)

                    if z and typeof(A) == 'Color3' then
                        aw.Hue, aw.Sat, aw.Vib = Color3.toHSV(A)

                        aw:Update()

                        aw.Default = A
                    end
                end
            end)

            local x = function(x, y)
                aa.AddSignal(x.Frame.Frame.TextBox.FocusLost, function(z)
                    if z then
                        local A = x.Frame.Frame.TextBox
                        local B = v()
                        local C = w(A.Text, 0, 255)

                        A.Text = tostring(C)
                        B[y] = C

                        local D = Color3.fromRGB(B.R, B.G, B.B)

                        aw.Hue, aw.Sat, aw.Vib = Color3.toHSV(D)

                        aw:Update()
                    end
                end)
            end

            x(l, 'R')
            x(n, 'G')
            x(o, 'B')

            if aw.Transparency then
                aa.AddSignal(p.Frame.Frame.TextBox.FocusLost, function(y)
                    if y then
                        local z = p.Frame.Frame.TextBox
                        local A = w(z.Text, 0, 100)

                        z.Text = tostring(A)
                        aw.Transparency = 1 - A * 0.01

                        aw:Update(nil, aw.Transparency)
                    end
                end)
            end

            local y = aw.UIElements.SatVibMap

            aa.AddSignal(y.InputBegan, function(z)
                if z.UserInputType == Enum.UserInputType.MouseButton1 or z.UserInputType == Enum.UserInputType.Touch then
                    while aj:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                        local A = y.AbsolutePosition.X
                        local B = A + y.AbsoluteSize.X
                        local C = math.clamp(ao.X, A, B)
                        local D = y.AbsolutePosition.Y
                        local E = D + y.AbsoluteSize.Y
                        local F = math.clamp(ao.Y, D, E)

                        aw.Sat = (C - A) / (B - A)
                        aw.Vib = 1 - ((F - D) / (E - D))

                        aw:Update()
                        am:Wait()
                    end
                end
            end)
            aa.AddSignal(i.InputBegan, function(z)
                if z.UserInputType == Enum.UserInputType.MouseButton1 or z.UserInputType == Enum.UserInputType.Touch then
                    while aj:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                        local A = i.AbsolutePosition.Y
                        local B = A + i.AbsoluteSize.Y
                        local C = math.clamp(ao.Y, A, B)

                        aw.Hue = ((C - A) / (B - A))

                        aw:Update()
                        am:Wait()
                    end
                end
            end)

            if aw.Transparency then
                aa.AddSignal(s.InputBegan, function(z)
                    if z.UserInputType == Enum.UserInputType.MouseButton1 or z.UserInputType == Enum.UserInputType.Touch then
                        while aj:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                            local A = s.AbsolutePosition.Y
                            local B = A + s.AbsoluteSize.Y
                            local C = math.clamp(ao.Y, A, B)

                            aw.Transparency = 1 - ((C - A) / (B - A))

                            aw:Update()
                            am:Wait()
                        end
                    end
                end)
            end

            return aw
        end
        function ar.New(as, at)
            local au = {
                __type = 'Colorpicker',
                Title = at.Title or 'Colorpicker',
                Desc = at.Desc or nil,
                Locked = at.Locked or false,
                LockedTitle = at.LockedTitle,
                Default = at.Default or Color3.new(1, 1, 1),
                Callback = at.Callback or function() end,
                UIScale = at.UIScale,
                Transparency = at.Transparency,
                UIElements = {},
            }
            local av = true

            au.ColorpickerFrame = a.load'B'{
                Title = au.Title,
                Desc = au.Desc,
                Parent = at.Parent,
                TextOffset = 40,
                Hover = false,
                Tab = at.Tab,
                Index = at.Index,
                Window = at.Window,
                ElementTable = au,
                ParentConfig = at,
            }
            au.UIElements.Colorpicker = aa.NewRoundFrame(ar.UICorner, 'Squircle', {
                ImageTransparency = 0,
                Active = true,
                ImageColor3 = au.Default,
                Parent = au.ColorpickerFrame.UIElements.Main,
                Size = UDim2.new(0, 26, 0, 26),
                AnchorPoint = Vector2.new(1, 0),
                Position = UDim2.new(1, 0, 0, 0),
                ZIndex = 2,
            }, nil, true)

            function au.Lock(aw)
                au.Locked = true
                av = false

                return au.ColorpickerFrame:Lock(au.LockedTitle)
            end
            function au.Unlock(aw)
                au.Locked = false
                av = true

                return au.ColorpickerFrame:Unlock()
            end

            if au.Locked then
                au:Lock()
            end

            function au.Update(aw, ax, ay)
                au.UIElements.Colorpicker.ImageTransparency = ay or 0
                au.UIElements.Colorpicker.ImageColor3 = ax
                au.Default = ax

                if ay then
                    au.Transparency = ay
                end
            end
            function au.Set(aw, ax, ay)
                return au:Update(ax, ay)
            end

            aa.AddSignal(au.UIElements.Colorpicker.MouseButton1Click, function()
                if av then
                    ar:Colorpicker(au, at.Window, function(aw, ax)
                        au:Update(aw, ax)

                        au.Default = aw
                        au.Transparency = ax

                        aa.SafeCallback(au.Callback, aw, ax)
                    end).ColorpickerFrame:Open()
                end
            end)

            return au.__type, au
        end

        return ar
    end
    function a.R()
        local aa = a.load'c'
        local ae = aa.New
        local af = aa.Tween
        local ah = {}

        function ah.New(aj, ak)
            local al = {
                __type = 'Section',
                Title = ak.Title or 'Section',
                Desc = ak.Desc,
                Icon = ak.Icon,
                IconThemed = ak.IconThemed,
                TextXAlignment = ak.TextXAlignment or 'Left',
                TextSize = ak.TextSize or 19,
                DescTextSize = ak.DescTextSize or 16,
                Box = ak.Box or false,
                BoxBorder = ak.BoxBorder or false,
                FontWeight = ak.FontWeight or Enum.FontWeight.SemiBold,
                DescFontWeight = ak.DescFontWeight or Enum.FontWeight.Medium,
                TextTransparency = ak.TextTransparency or 0.05,
                DescTextTransparency = ak.DescTextTransparency or 0.4,
                Opened = ak.Opened or false,
                UIElements = {},
                HeaderSize = 42,
                IconSize = 20,
                Padding = 10,
                Elements = {},
                Expandable = false,
            }
            local am

            function al.SetIcon(an, ao)
                al.Icon = ao or nil

                if am then
                    am:Destroy()
                end
                if ao then
                    am = aa.Image(ao, ao .. ':' .. al.Title, 0, ak.Window.Folder, al.__type, true, al.IconThemed, 'SectionIcon')
                    am.Size = UDim2.new(0, al.IconSize, 0, al.IconSize)
                end
            end

            local an = ae('Frame', {
                Size = UDim2.new(0, al.IconSize, 0, al.IconSize),
                BackgroundTransparency = 1,
                Visible = false,
            }, {
                ae('ImageLabel', {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Image = aa.Icon'chevron-down'[1],
                    ImageRectSize = aa.Icon'chevron-down'[2].ImageRectSize,
                    ImageRectOffset = aa.Icon'chevron-down'[2].ImageRectPosition,
                    ThemeTag = {
                        ImageTransparency = 'SectionExpandIconTransparency',
                        ImageColor3 = 'SectionExpandIcon',
                    },
                }),
            })

            if al.Icon then
                al:SetIcon(al.Icon)
            end

            local ao = ae('Frame', {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
            }, {
                ae('UIListLayout', {
                    FillDirection = 'Vertical',
                    HorizontalAlignment = al.TextXAlignment,
                    VerticalAlignment = 'Center',
                    Padding = UDim.new(0, 4),
                }),
            })
            local ap, aq
            local ar = function(ar, as)
                return ae('TextLabel', {
                    BackgroundTransparency = 1,
                    TextXAlignment = al.TextXAlignment,
                    AutomaticSize = 'Y',
                    TextSize = as == 'Title' and al.TextSize or al.DescTextSize,
                    TextTransparency = as == 'Title' and al.TextTransparency or al.DescTextTransparency,
                    ThemeTag = {
                        TextColor3 = 'Text',
                    },
                    FontFace = Font.new(aa.Font, as == 'Title' and al.FontWeight or al.DescFontWeight),
                    Text = ar,
                    Size = UDim2.new(1, 0, 0, 0),
                    TextWrapped = true,
                    Parent = ao,
                })
            end

            ap = ar(al.Title, 'Title')

            if al.Desc then
                aq = ar(al.Desc, 'Desc')
            end

            local as = function()
                local as = 0

                if am then
                    as = as - (al.IconSize + 8)
                end
                if an.Visible then
                    as = as - (al.IconSize + 8)
                end

                ao.Size = UDim2.new(1, as, 0, 0)
            end
            local at = aa.NewRoundFrame(ak.Window.ElementConfig.UICorner, 'Squircle', {
                Size = UDim2.new(1, 0, 0, 0),
                BackgroundTransparency = 1,
                Parent = ak.Parent,
                ClipsDescendants = true,
                AutomaticSize = 'Y',
                ThemeTag = {
                    ImageTransparency = al.Box and 'SectionBoxBackgroundTransparency' or nil,
                    ImageColor3 = 'SectionBoxBackground',
                },
                ImageTransparency = not al.Box and 1 or nil,
            }, {
                aa.NewRoundFrame(ak.Window.ElementConfig.UICorner, ak.Window.NewElements and 'Glass-1' or 'SquircleOutline', {
                    Size = UDim2.new(1, 0, 1, 0),
                    ThemeTag = {
                        ImageTransparency = 'SectionBoxBorderTransparency',
                        ImageColor3 = 'SectionBoxBorder',
                    },
                    Visible = al.Box and al.BoxBorder,
                    Name = 'Outline',
                }, {
                    ae('UIStroke', {
                        Thickness = 1.5,
                        Color = Color3.fromHex'#FFD700',
                        Transparency = 0.5,
                        ApplyStrokeMode = 'Border',
                    }, {
                        ae('UIGradient', {
                            Rotation = 45,
                            Color = ColorSequence.new{
                                ColorSequenceKeypoint.new(0, Color3.fromHex'#FFD700'),
                                ColorSequenceKeypoint.new(0.5, Color3.fromHex'#FFFACD'),
                                ColorSequenceKeypoint.new(1, Color3.fromHex'#FFD700'),
                            },
                        }),
                    }),
                }),
                ae('TextButton', {
                    Size = UDim2.new(1, 0, 0, al.Expandable and 0 or (not aq and al.HeaderSize or 0)),
                    BackgroundTransparency = 1,
                    AutomaticSize = (not al.Expandable or aq) and 'Y' or nil,
                    Text = '',
                    Name = 'Top',
                }, {
                    al.Box and ae('UIPadding', {
                        PaddingTop = UDim.new(0, ak.Window.ElementConfig.UIPadding + (ak.Window.NewElements and 4 or 0)),
                        PaddingLeft = UDim.new(0, ak.Window.ElementConfig.UIPadding + (ak.Window.NewElements and 4 or 0)),
                        PaddingRight = UDim.new(0, ak.Window.ElementConfig.UIPadding + (ak.Window.NewElements and 4 or 0)),
                        PaddingBottom = UDim.new(0, ak.Window.ElementConfig.UIPadding + (ak.Window.NewElements and 4 or 0)),
                    }) or nil,
                    am,
                    ao,
                    ae('UIListLayout', {
                        Padding = UDim.new(0, 8),
                        FillDirection = 'Horizontal',
                        VerticalAlignment = 'Center',
                        HorizontalAlignment = 'Left',
                    }),
                    an,
                }),
                ae('Frame', {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = 'Y',
                    Name = 'Content',
                    Visible = false,
                    Position = UDim2.new(0, 0, 0, al.HeaderSize),
                }, {
                    al.Box and ae('UIPadding', {
                        PaddingLeft = UDim.new(0, ak.Window.ElementConfig.UIPadding),
                        PaddingRight = UDim.new(0, ak.Window.ElementConfig.UIPadding),
                        PaddingBottom = UDim.new(0, ak.Window.ElementConfig.UIPadding),
                    }) or nil,
                    ae('UIListLayout', {
                        FillDirection = 'Vertical',
                        Padding = UDim.new(0, ak.Tab.Gap),
                        VerticalAlignment = 'Top',
                    }),
                }),
            })

            al.ElementFrame = at

            if aq then
                at.Top:GetPropertyChangedSignal'AbsoluteSize':Connect(function()
                    at.Content.Position = UDim2.new(0, 0, 0, at.Top.AbsoluteSize.Y / ak.UIScale)

                    if al.Opened then
                        al:Open(true)
                    else
                        al.Close(true)
                    end
                end)
            end

            local au = ak.ElementsModule

            au.Load(al, at.Content, au.Elements, ak.Window, ak.IntiHub, function(
            )
                if not al.Expandable then
                    al.Expandable = true
                    an.Visible = true

                    as()
                end
            end, au, ak.UIScale, ak.Tab)
            as()

            function al.SetTitle(av, aw)
                al.Title = aw
                ap.Text = aw
            end
            function al.SetDesc(av, aw)
                al.Desc = aw

                if not aq then
                    aq = ar(aw, 'Desc')
                end

                aq.Text = aw
            end
            function al.Destroy(av)
                for aw, ax in next, al.Elements do
                    ax:Destroy()
                end

                at:Destroy()
            end
            function al.Open(av, aw)
                if al.Expandable then
                    al.Opened = true

                    if aw then
                        at.Size = UDim2.new(at.Size.X.Scale, at.Size.X.Offset, 0, (at.Top.AbsoluteSize.Y) / ak.UIScale + (at.Content.AbsoluteSize.Y / ak.UIScale))
                        an.ImageLabel.Rotation = 180
                    else
                        af(at, 0.33, {
                            Size = UDim2.new(at.Size.X.Scale, at.Size.X.Offset, 0, (at.Top.AbsoluteSize.Y) / ak.UIScale + (at.Content.AbsoluteSize.Y / ak.UIScale)),
                        }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                        af(an.ImageLabel, 0.2, {Rotation = 180}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                    end
                end
            end
            function al.Close(av, aw)
                if al.Expandable then
                    al.Opened = false

                    if aw then
                        at.Size = UDim2.new(at.Size.X.Scale, at.Size.X.Offset, 0, (at.Top.AbsoluteSize.Y / ak.UIScale))
                        an.ImageLabel.Rotation = 0
                    else
                        af(at, 0.26, {
                            Size = UDim2.new(at.Size.X.Scale, at.Size.X.Offset, 0, (at.Top.AbsoluteSize.Y / ak.UIScale)),
                        }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                        af(an.ImageLabel, 0.2, {Rotation = 0}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                    end
                end
            end

            aa.AddSignal(at.Top.MouseButton1Click, function()
                if al.Expandable then
                    if al.Opened then
                        al:Close()
                    else
                        al:Open()
                    end
                end
            end)
            aa.AddSignal(at.Content.UIListLayout:GetPropertyChangedSignal'AbsoluteContentSize', function(
            )
                if al.Opened then
                    al:Open(true)
                end
            end)
            task.spawn(function()
                task.wait(0.02)

                if al.Expandable then
                    at.Size = UDim2.new(at.Size.X.Scale, at.Size.X.Offset, 0, at.Top.AbsoluteSize.Y / ak.UIScale)
                    at.AutomaticSize = 'None'
                    at.Top.Size = UDim2.new(1, 0, 0, (not aq and al.HeaderSize or 0))
                    at.Top.AutomaticSize = (not al.Expandable or aq) and 'Y' or 'None'
                    at.Content.Visible = true
                end
                if al.Opened then
                    al:Open()
                end
            end)

            return al.__type, al
        end

        return ah
    end
    function a.S()
        local aa = a.load'c'
        local ae = aa.New
        local af = {}

        function af.New(ah, aj)
            local ak = ae('Frame', {
                Parent = aj.Parent,
                Size = aj.ParentType ~= 'Group' and UDim2.new(1, -7, 0, 7 * (aj.Columns or 1)) or UDim2.new(0, 7 * (aj.Columns or 1), 0, 0),
                BackgroundTransparency = 1,
            })

            return 'Space', {
                __type = 'Space',
                ElementFrame = ak,
            }
        end

        return af
    end
    function a.T()
        local aa = a.load'c'
        local ae = aa.New
        local af = {}
        local ah = function(ah)
            if type(ah) == 'string' then
                local aj, ak = ah:match'(%d+):(%d+)'

                if aj and ak then
                    return tonumber(aj) / tonumber(ak)
                end
            elseif type(ah) == 'number' then
                return ah
            end

            return nil
        end

        function af.New(aj, ak)
            local al = {
                __type = 'Image',
                Image = ak.Image or '',
                AspectRatio = ak.AspectRatio or '16:9',
                Radius = ak.Radius or ak.Window.ElementConfig.UICorner,
            }
            local am = aa.Image(al.Image, al.Image, al.Radius, ak.Window.Folder, 'Image', false)

            if am and am.Parent then
                am.Parent = ak.Parent
                am.Size = UDim2.new(1, 0, 0, 0)
                am.BackgroundTransparency = 1

                local an = ah(al.AspectRatio)
                local ao

                if an then
                    ao = ae('UIAspectRatioConstraint', {
                        Parent = am,
                        AspectRatio = an,
                        AspectType = 'ScaleWithParentSize',
                        DominantAxis = 'Width',
                    })
                end

                function al.Destroy(ap)
                    am:Destroy()
                end
            end

            return al.__type, al
        end

        return af
    end
    function a.U()
        local aa = a.load'c'
        local ae = aa.New
        local af = {}

        function af.New(ah, aj)
            local ak = {
                __type = 'Group',
                Elements = {},
            }
            local al = ae('Frame', {
                Size = UDim2.new(1, 0, 0, 0),
                BackgroundTransparency = 1,
                AutomaticSize = 'Y',
                Parent = aj.Parent,
            }, {
                ae('UIListLayout', {
                    FillDirection = 'Horizontal',
                    HorizontalAlignment = 'Center',
                    Padding = UDim.new(0, aj.Tab and aj.Tab.Gap or (Window.NewElements and 1 or 6)),
                }),
            })
            local am = aj.ElementsModule

            am.Load(ak, al, am.Elements, aj.Window, aj.IntiHub, function(
                an,
                ao
            )
                local ap = aj.Tab and aj.Tab.Gap or (aj.Window.NewElements and 1 or 6)
                local aq = {}
                local ar = 0

                for as, at in next, ao do
                    if at.__type == 'Space' then
                        ar = ar + (at.ElementFrame.Size.X.Offset or 6)
                    elseif at.__type == 'Divider' then
                        ar = ar + (at.ElementFrame.Size.X.Offset or 1)
                    else
                        table.insert(aq, at)
                    end
                end

                local as = #aq

                if as == 0 then
                    return
                end

                local at = 1 / as
                local au = ap * (as - 1)
                local av = -(au + ar)
                local aw = math.floor(av / as)
                local ax = av - (aw * as)

                for ay, az in next, aq do
                    local aA = aw

                    if ay <= math.abs(ax) then
                        aA = aA - 1
                    end
                    if az.ElementFrame then
                        az.ElementFrame.Size = UDim2.new(at, aA, 1, 0)
                    end
                end
            end, am, aj.UIScale, aj.Tab)

            return ak.__type, ak
        end

        return af
    end
    function a.V()
        return {
            Elements = {
                Paragraph = a.load'C',
                Button = a.load'D',
                Toggle = a.load'G',
                Slider = a.load'H',
                Keybind = a.load'I',
                Input = a.load'J',
                Dropdown = a.load'M',
                Code = a.load'P',
                Colorpicker = a.load'Q',
                Section = a.load'R',
                Divider = a.load'K',
                Space = a.load'S',
                Image = a.load'T',
                Group = a.load'U',
            },
            Load = function(aa, ae, af, ah, aj, ak, al, am, an)
                for ao, ap in next, af do
                    aa[ao] = function(aq, ar)
                        ar = ar or {}
                        ar.Tab = an or aa
                        ar.ParentType = aa.__type
                        ar.ParentTable = aa
                        ar.Index = #aa.Elements + 1
                        ar.GlobalIndex = #ah.AllElements + 1
                        ar.Parent = ae
                        ar.Window = ah
                        ar.IntiHub = aj
                        ar.UIScale = am
                        ar.ElementsModule = al

                        local as, at = ap:New(ar)

                        if ar.Flag and typeof(ar.Flag) == 'string' then
                            if ah.CurrentConfig then
                                ah.CurrentConfig:Register(ar.Flag, at)

                                if ah.PendingConfigData and ah.PendingConfigData[ar.Flag] then
                                    local au = ah.PendingConfigData[ar.Flag]
                                    local av = ah.ConfigManager

                                    if av.Parser[au.__type] then
                                        task.defer(function()
                                            local aw, ax = pcall(function()
                                                av.Parser[au.__type].Load(at, au)
                                            end)

                                            if aw then
                                                ah.PendingConfigData[ar.Flag] = nil
                                            else
                                                warn("[ IntiHub ] Failed to apply pending config for '" .. ar.Flag .. "': " .. tostring(ax))
                                            end
                                        end)
                                    end
                                end
                            else
                                ah.PendingFlags = ah.PendingFlags or {}
                                ah.PendingFlags[ar.Flag] = at
                            end
                        end

                        local au

                        for av, aw in next, at do
                            if typeof(aw) == 'table' and av ~= 'ElementFrame' and av:match'Frame$' then
                                au = aw

                                break
                            end
                        end

                        if au then
                            at.ElementFrame = au.UIElements.Main

                            function at.SetTitle(av, aw)
                                return au.SetTitle and au:SetTitle(aw)
                            end
                            function at.SetDesc(av, aw)
                                return au.SetDesc and au:SetDesc(aw)
                            end
                            function at.SetImage(av, aw, ax)
                                return au.SetImage and au:SetImage(aw, ax)
                            end
                            function at.SetThumbnail(av, aw, ax)
                                return au.SetThumbnail and au:SetThumbnail(aw, ax)
                            end
                            function at.Highlight(av)
                                au:Highlight()
                            end
                            function at.Destroy(av)
                                au:Destroy()
                                table.remove(ah.AllElements, ar.GlobalIndex)
                                table.remove(aa.Elements, ar.Index)
                                table.remove(an.Elements, ar.Index)
                                aa:UpdateAllElementShapes(aa)
                            end
                        end

                        ah.AllElements[ar.Index] = at
                        aa.Elements[ar.Index] = at

                        if an then
                            an.Elements[ar.Index] = at
                        end
                        if ah.NewElements then
                            aa:UpdateAllElementShapes(aa)
                        end
                        if ak then
                            ak(at, aa.Elements)
                        end

                        return at
                    end
                end

                function aa.UpdateAllElementShapes(ao, ap)
                    for aq, ar in next, ap.Elements do
                        local as

                        for at, au in pairs(ar)do
                            if typeof(au) == 'table' and at:match'Frame$' then
                                as = au

                                break
                            end
                        end

                        if as then
                            as.Index = aq

                            if as.UpdateShape then
                                as.UpdateShape(ap)
                            end
                        end
                    end
                end
            end,
        }
    end
    function a.W()
        local aa = (cloneref or clonereference or function(aa)
            return aa
        end)
        local ae = game:GetService'Players'

        aa(game:GetService'UserInputService')

        local af = ae.LocalPlayer:GetMouse()
        local ah = a.load'c'
        local aj = ah.New
        local ak = a.load'A'.New
        local al = a.load'w'.New
        local am = {
            Tabs = {},
            Containers = {},
            SelectedTab = nil,
            TabCount = 0,
            ToolTipParent = nil,
            TabHighlight = nil,
            OnChangeFunc = function(am) end,
        }

        function am.Init(an, ao, ap, aq)
            Window = an
            IntiHub = ao
            am.ToolTipParent = ap
            am.TabHighlight = aq

            return am
        end
        function am.New(an, ao)
            local ap = {
                __type = 'Tab',
                Title = an.Title or 'Tab',
                Desc = an.Desc,
                Icon = an.Icon,
                IconColor = an.IconColor,
                IconShape = an.IconShape,
                IconThemed = an.IconThemed,
                Locked = an.Locked,
                ShowTabTitle = an.ShowTabTitle,
                TabTitleAlign = an.TabTitleAlign or 'Left',
                CustomEmptyPage = (an.CustomEmptyPage and next(an.CustomEmptyPage) ~= nil) and an.CustomEmptyPage or {
                    Icon = 'lucide:frown',
                    IconSize = 48,
                    Title = 'This tab is Empty',
                    Desc = nil,
                },
                Border = an.Border,
                Selected = false,
                Index = nil,
                Parent = an.Parent,
                UIElements = {},
                Elements = {},
                ContainerFrame = nil,
                UICorner = Window.UICorner - (Window.UIPadding / 2),
                Gap = Window.NewElements and 1 or 6,
                TabPaddingX = 4 + (Window.UIPadding / 2),
                TabPaddingY = 3 + (Window.UIPadding / 2),
                TitlePaddingY = 0,
            }

            if ap.IconShape then
                ap.TabPaddingX = 2 + (Window.UIPadding / 4)
                ap.TabPaddingY = 2 + (Window.UIPadding / 4)
                ap.TitlePaddingY = 2 + (Window.UIPadding / 4)
            end

            am.TabCount = am.TabCount + 1

            local aq = am.TabCount

            ap.Index = aq
            ap.UIElements.Main = ah.NewRoundFrame(ap.UICorner, 'Squircle', {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -7, 0, 0),
                AutomaticSize = 'Y',
                Parent = an.Parent,
                ThemeTag = {
                    ImageColor3 = 'TabBackground',
                },
                ImageTransparency = 1,
            }, {
                ah.NewRoundFrame(ap.UICorner, 'Glass-1.4', {
                    Size = UDim2.new(1, 0, 1, 0),
                    ThemeTag = {
                        ImageColor3 = 'TabBorder',
                    },
                    ImageTransparency = 1,
                    Name = 'Outline',
                }, {}),
                ah.NewRoundFrame(ap.UICorner, 'Squircle', {
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = 'Y',
                    ThemeTag = {
                        ImageColor3 = 'Text',
                    },
                    ImageTransparency = 1,
                    Name = 'Frame',
                }, {
                    aj('Frame', {
                        Size = UDim2.new(0, 2, 0, 14),
                        Position = UDim2.new(0, -6, 0.5, 0),
                        AnchorPoint = Vector2.new(0, 0.5),
                        BackgroundColor3 = Color3.fromHex'#FFD700',
                        BackgroundTransparency = 1,
                        Name = 'Indicator',
                    }, {
                        aj('UICorner', {
                            CornerRadius = UDim.new(1, 0),
                        }),
                    }),
                    aj('UIListLayout', {
                        SortOrder = 'LayoutOrder',
                        Padding = UDim.new(0, 2 + (Window.UIPadding / 2)),
                        FillDirection = 'Horizontal',
                        VerticalAlignment = 'Center',
                    }),
                    aj('TextLabel', {
                        Text = ap.Title,
                        ThemeTag = {
                            TextColor3 = 'TabTitle',
                        },
                        TextTransparency = not ap.Locked and 0.4 or 0.7,
                        TextSize = 15,
                        Size = UDim2.new(1, 0, 0, 0),
                        FontFace = Font.new(ah.Font, Enum.FontWeight.Medium),
                        TextWrapped = true,
                        RichText = true,
                        AutomaticSize = 'Y',
                        LayoutOrder = 2,
                        TextXAlignment = 'Left',
                        BackgroundTransparency = 1,
                    }, {
                        aj('UIPadding', {
                            PaddingTop = UDim.new(0, ap.TitlePaddingY),
                            PaddingBottom = UDim.new(0, ap.TitlePaddingY),
                        }),
                    }),
                    aj('UIPadding', {
                        PaddingTop = UDim.new(0, ap.TabPaddingY),
                        PaddingLeft = UDim.new(0, ap.TabPaddingX),
                        PaddingRight = UDim.new(0, ap.TabPaddingX),
                        PaddingBottom = UDim.new(0, ap.TabPaddingY),
                    }),
                }),
            }, true)

            local ar = 0
            local as
            local at

            if ap.Icon then
                as = ah.Image(ap.Icon, ap.Icon .. ':' .. ap.Title, 0, Window.Folder, ap.__type, ap.IconColor and false or true, ap.IconThemed, 'TabIcon')
                as.Size = UDim2.new(0, 16, 0, 16)

                if ap.IconColor then
                    as.ImageLabel.ImageColor3 = ap.IconColor
                end
                if not ap.IconShape and not ap.IconColor then
                    as.Parent = ap.UIElements.Main.Frame
                    ap.UIElements.Icon = as
                    as.ImageLabel.ImageTransparency = not ap.Locked and 0 or 0.7
                    ar = -18 - (Window.UIPadding / 2)
                    ap.UIElements.Main.Frame.TextLabel.Size = UDim2.new(1, ar, 0, 0)
                elseif ap.IconShape or ap.IconColor then
                    if not ap.IconShape then
                        ap.IconShape = 'Squircle'
                    end

                    ah.NewRoundFrame(ap.IconShape ~= 'Circle' and (ap.UICorner + 5 - (2 + (Window.UIPadding / 4))) or 9999, 'Squircle', {
                        Size = UDim2.new(0, 26, 0, 26),
                        ImageColor3 = ap.IconColor or nil,
                        ThemeTag = not ap.IconColor and {
                            ImageColor3 = 'Accent',
                        } or nil,
                        Parent = ap.UIElements.Main.Frame,
                    }, {
                        as,
                        ah.NewRoundFrame(ap.IconShape ~= 'Circle' and (ap.UICorner + 5 - (2 + (Window.UIPadding / 4))) or 9999, 'Glass-1.4', {
                            Size = UDim2.new(1, 0, 1, 0),
                            ThemeTag = {
                                ImageColor3 = 'White',
                            },
                            ImageTransparency = 0,
                            Name = 'Outline',
                        }, {}),
                    })

                    as.AnchorPoint = Vector2.new(0.5, 0.5)
                    as.Position = UDim2.new(0.5, 0, 0.5, 0)
                    as.ImageLabel.ImageTransparency = 0
                    as.ImageLabel.ImageColor3 = (not ap.IconColor or ah.GetTextColorForHSB(ap.IconColor, 0.68) == Color3.new(1, 1, 1)) and Color3.fromHex'#1A1605' or ah.GetTextColorForHSB(ap.IconColor, 0.68)
                    ar = -28 - (Window.UIPadding / 2)
                    ap.UIElements.Main.Frame.TextLabel.Size = UDim2.new(1, ar, 0, 0)
                end

                at = ah.Image(ap.Icon, ap.Icon .. ':' .. ap.Title, 0, Window.Folder, ap.__type, true, ap.IconThemed)
                at.Size = UDim2.new(0, 16, 0, 16)
                at.ImageLabel.ImageTransparency = not ap.Locked and 0 or 0.7
                ar = -30
            end

            ap.UIElements.ContainerFrame = aj('ScrollingFrame', {
                Size = UDim2.new(1, 0, 1, ap.ShowTabTitle and -((Window.UIPadding * 2.4) + 12) or 0),
                BackgroundTransparency = 1,
                ScrollBarThickness = 0,
                ElasticBehavior = 'Never',
                CanvasSize = UDim2.new(0, 0, 0, 0),
                AnchorPoint = Vector2.new(0, 1),
                Position = UDim2.new(0, 0, 1, 0),
                AutomaticCanvasSize = 'Y',
                ScrollingDirection = 'Y',
            }, {
                aj('UIPadding', {
                    PaddingTop = UDim.new(0, not Window.HidePanelBackground and 20 or 10),
                    PaddingLeft = UDim.new(0, not Window.HidePanelBackground and 20 or 10),
                    PaddingRight = UDim.new(0, not Window.HidePanelBackground and 20 or 10),
                    PaddingBottom = UDim.new(0, not Window.HidePanelBackground and 20 or 10),
                }),
                aj('UIListLayout', {
                    SortOrder = 'LayoutOrder',
                    Padding = UDim.new(0, ap.Gap),
                    HorizontalAlignment = 'Center',
                }),
            })
            ap.UIElements.ContainerFrameCanvas = aj('Frame', {
                Size = UDim2.new(1, 0, 1, -60),
                BackgroundTransparency = 1,
                Visible = false,
                Parent = Window.UIElements.MainBar,
                ZIndex = 5,
                Position = UDim2.new(0, 0, 0, 60),
            }, {
                aj('TextLabel', {
                    Text = 'ARCHIVE',
                    TextSize = 100,
                    FontFace = Font.new(ah.Font, Enum.FontWeight.Bold),
                    TextColor3 = Color3.fromHex'#FFD700',
                    TextTransparency = 0.98,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    ZIndex = 1,
                    Rotation = -15,
                }),
                ap.UIElements.ContainerFrame,
                aj('Frame', {
                    Size = UDim2.new(1, 0, 0, ((Window.UIPadding * 2.4) + 12)),
                    BackgroundTransparency = 1,
                    Visible = ap.ShowTabTitle or false,
                    Name = 'TabTitle',
                }, {
                    at,
                    aj('TextLabel', {
                        Text = ap.Title,
                        ThemeTag = {
                            TextColor3 = 'Text',
                        },
                        TextSize = 20,
                        TextTransparency = 0.1,
                        Size = UDim2.new(0, 0, 1, 0),
                        FontFace = Font.new(ah.Font, Enum.FontWeight.SemiBold),
                        RichText = true,
                        LayoutOrder = 2,
                        TextXAlignment = 'Left',
                        BackgroundTransparency = 1,
                        AutomaticSize = 'X',
                    }),
                    aj('UIPadding', {
                        PaddingTop = UDim.new(0, 20),
                        PaddingLeft = UDim.new(0, 20),
                        PaddingRight = UDim.new(0, 20),
                        PaddingBottom = UDim.new(0, 20),
                    }),
                    aj('UIListLayout', {
                        SortOrder = 'LayoutOrder',
                        Padding = UDim.new(0, 10),
                        FillDirection = 'Horizontal',
                        VerticalAlignment = 'Center',
                        HorizontalAlignment = ap.TabTitleAlign,
                    }),
                }),
                aj('Frame', {
                    Size = UDim2.new(1, 0, 0, 1),
                    BackgroundTransparency = 0.9,
                    ThemeTag = {
                        BackgroundColor3 = 'Text',
                    },
                    Position = UDim2.new(0, 0, 0, ((Window.UIPadding * 2.4) + 12)),
                    Visible = ap.ShowTabTitle or false,
                }),
            })
            am.Containers[aq] = ap.UIElements.ContainerFrameCanvas
            am.Tabs[aq] = ap
            ap.ContainerFrame = ap.UIElements.ContainerFrameCanvas

            ah.AddSignal(ap.UIElements.Main.MouseButton1Click, function()
                if not ap.Locked then
                    am:SelectTab(aq)
                end
            end)

            if Window.ScrollBarEnabled then
                al(ap.UIElements.ContainerFrame, ap.UIElements.ContainerFrameCanvas, Window, 3)
            end

            local au
            local av
            local aw
            local ax = false

            if ap.Desc then
                ah.AddSignal(ap.UIElements.Main.InputBegan, function()
                    ax = true
                    av = task.spawn(function()
                        task.wait(0.35)

                        if ax and not au then
                            au = ak(ap.Desc, am.ToolTipParent, true)
                            au.Container.AnchorPoint = Vector2.new(0.5, 0.5)

                            local ay = function()
                                if au then
                                    au.Container.Position = UDim2.new(0, af.X, 0, af.Y - 4)
                                end
                            end

                            ay()

                            aw = af.Move:Connect(ay)

                            au:Open()
                        end
                    end)
                end)
            end

            ah.AddSignal(ap.UIElements.Main.MouseEnter, function()
                if not ap.Locked then
                    ah.SetThemeTag(ap.UIElements.Main.Frame, {
                        ImageTransparency = 'TabBackgroundHoverTransparency',
                        ImageColor3 = 'TabBackgroundHover',
                    }, 0.1)
                end
            end)
            ah.AddSignal(ap.UIElements.Main.InputEnded, function()
                if ap.Desc then
                    ax = false

                    if av then
                        task.cancel(av)

                        av = nil
                    end
                    if aw then
                        aw:Disconnect()

                        aw = nil
                    end
                    if au then
                        au:Close()

                        au = nil
                    end
                end
                if not ap.Locked then
                    ah.SetThemeTag(ap.UIElements.Main.Frame, {
                        ImageTransparency = 'TabBorderTransparency',
                    }, 0.1)
                end
            end)

            function ap.ScrollToTheElement(ay, az)
                ap.UIElements.ContainerFrame.ScrollingEnabled = false

                ah.Tween(ap.UIElements.ContainerFrame, 0.45, {
                    CanvasPosition = Vector2.new(0, ap.Elements[az].ElementFrame.AbsolutePosition.Y - ap.UIElements.ContainerFrame.AbsolutePosition.Y - ap.UIElements.ContainerFrame.UIPadding.PaddingTop.Offset),
                }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                task.spawn(function()
                    task.wait(0.48)

                    if ap.Elements[az].Highlight then
                        ap.Elements[az]:Highlight()
                    end

                    ap.UIElements.ContainerFrame.ScrollingEnabled = true
                end)

                return ap
            end

            local ay = a.load'V'

            ay.Load(ap, ap.UIElements.ContainerFrame, ay.Elements, Window, IntiHub, nil, ay, ao)

            function ap.LockAll(az)
                for aA, aB in next, Window.AllElements do
                    if aB.Tab and aB.Tab.Index and aB.Tab.Index == ap.Index and aB.Lock then
                        aB:Lock()
                    end
                end
            end
            function ap.UnlockAll(az)
                for aA, aB in next, Window.AllElements do
                    if aB.Tab and aB.Tab.Index and aB.Tab.Index == ap.Index and aB.Unlock then
                        aB:Unlock()
                    end
                end
            end
            function ap.GetLocked(az)
                local aA = {}

                for aB, aC in next, Window.AllElements do
                    if aC.Tab and aC.Tab.Index and aC.Tab.Index == ap.Index and aC.Locked == true then
                        table.insert(aA, aC)
                    end
                end

                return aA
            end
            function ap.GetUnlocked(az)
                local aA = {}

                for aB, aC in next, Window.AllElements do
                    if aC.Tab and aC.Tab.Index and aC.Tab.Index == ap.Index and aC.Locked == false then
                        table.insert(aA, aC)
                    end
                end

                return aA
            end
            function ap.Select(az)
                return am:SelectTab(ap.Index)
            end

            task.spawn(function()
                local az

                if ap.CustomEmptyPage.Icon then
                    az = ah.Image(ap.CustomEmptyPage.Icon, ap.CustomEmptyPage.Icon, 0, 'Temp', 'EmptyPage', true)
                    az.Size = UDim2.fromOffset(ap.CustomEmptyPage.IconSize or 48, ap.CustomEmptyPage.IconSize or 48)
                end

                local aA = aj('Frame', {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, -Window.UIElements.Main.Main.Topbar.AbsoluteSize.Y),
                    Parent = ap.UIElements.ContainerFrame,
                }, {
                    aj('UIListLayout', {
                        Padding = UDim.new(0, 8),
                        SortOrder = 'LayoutOrder',
                        VerticalAlignment = 'Center',
                        HorizontalAlignment = 'Center',
                        FillDirection = 'Vertical',
                    }),
                    az,
                    ap.CustomEmptyPage.Title and aj('TextLabel', {
                        AutomaticSize = 'XY',
                        Text = ap.CustomEmptyPage.Title,
                        ThemeTag = {
                            TextColor3 = 'Text',
                        },
                        TextSize = 18,
                        TextTransparency = 0.5,
                        BackgroundTransparency = 1,
                        FontFace = Font.new(ah.Font, Enum.FontWeight.Medium),
                    }) or nil,
                    ap.CustomEmptyPage.Desc and aj('TextLabel', {
                        AutomaticSize = 'XY',
                        Text = ap.CustomEmptyPage.Desc,
                        ThemeTag = {
                            TextColor3 = 'Text',
                        },
                        TextSize = 15,
                        TextTransparency = 0.65,
                        BackgroundTransparency = 1,
                        FontFace = Font.new(ah.Font, Enum.FontWeight.Regular),
                    }) or nil,
                })
                local aB

                aB = ah.AddSignal(ap.UIElements.ContainerFrame.ChildAdded, function(
                )
                    aA.Visible = false

                    aB:Disconnect()
                end)
            end)

            return ap
        end
        function am.OnChange(an, ao)
            am.OnChangeFunc = ao
        end
        function am.SelectTab(an, ao)
            if not am.Tabs[ao].Locked then
                am.SelectedTab = ao

                for ap, aq in next, am.Tabs do
                    if not aq.Locked then
                        ah.SetThemeTag(aq.UIElements.Main, {
                            ImageTransparency = 'TabBorderTransparency',
                        }, 0.15)

                        if aq.Border then
                            ah.SetThemeTag(aq.UIElements.Main.Outline, {
                                ImageTransparency = 'TabBorderTransparency',
                            }, 0.15)
                        end

                        ah.SetThemeTag(aq.UIElements.Main.Frame.TextLabel, {
                            TextTransparency = 'TabTextTransparency',
                        }, 0.15)

                        if aq.UIElements.Icon and not aq.IconColor then
                            ah.SetThemeTag(aq.UIElements.Icon.ImageLabel, {
                                ImageTransparency = 'TabIconTransparency',
                            }, 0.15)
                        end

                        aq.Selected = false
                    end
                end

                ah.SetThemeTag(am.Tabs[ao].UIElements.Main, {
                    ImageTransparency = 'TabBackgroundActiveTransparency',
                }, 0.15)

                if am.Tabs[ao].Border then
                    ah.SetThemeTag(am.Tabs[ao].UIElements.Main.Outline, {
                        ImageTransparency = 'TabBorderTransparencyActive',
                    }, 0.15)
                end

                ah.SetThemeTag(am.Tabs[ao].UIElements.Main.Frame.TextLabel, {
                    TextTransparency = 'TabTextTransparencyActive',
                }, 0.15)

                if am.Tabs[ao].UIElements.Icon and not am.Tabs[ao].IconColor then
                    ah.SetThemeTag(am.Tabs[ao].UIElements.Icon.ImageLabel, {
                        ImageTransparency = 'TabIconTransparencyActive',
                    }, 0.15)
                end

                local ap = am.Tabs[ao].UIElements.Main.Frame

                if ap:FindFirstChild'Indicator' then
                    ah.Tween(ap.Indicator, 0.2, {BackgroundTransparency = 0}):Play()
                end

                for aq, ar in next, am.Tabs do
                    if ar.Index ~= ao then
                        local as = ar.UIElements.Main.Frame

                        if as:FindFirstChild'Indicator' then
                            ah.Tween(as.Indicator, 0.2, {BackgroundTransparency = 1}):Play()
                        end
                    end
                end

                am.Tabs[ao].Selected = true

                task.spawn(function()
                    for aq, ar in next, am.Containers do
                        ar.AnchorPoint = Vector2.new(0, 0.05)
                        ar.Visible = false
                    end

                    am.Containers[ao].Visible = true

                    if Window.UIElements.MainBar:FindFirstChild'ContentHeader' then
                        local aq = Window.UIElements.MainBar.ContentHeader

                        if aq:FindFirstChild'TextLabel' then
                            aq.TextLabel.Text = string.upper(am.Tabs[ao].Title) .. ' MODULE'
                        end
                    end

                    local aq = game:GetService'TweenService'
                    local ar = TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
                    local as = aq:Create(am.Containers[ao], ar, {
                        AnchorPoint = Vector2.new(0, 0),
                    })

                    as:Play()
                end)
                am.OnChangeFunc(ao)
            end
        end

        return am
    end
    function a.X()
        local aa = {}
        local ae = a.load'c'
        local af = ae.New
        local ah = ae.Tween
        local aj = a.load'W'

        function aa.New(ak, al, am, an, ao)
            local ap = {
                Title = ak.Title or 'Section',
                Icon = ak.Icon,
                IconThemed = ak.IconThemed,
                Opened = ak.Opened or false,
                HeaderSize = 42,
                IconSize = 18,
                Expandable = false,
            }
            local aq

            if ap.Icon then
                local ar = ae.Image(ap.Icon, ap.Icon, 0, am, 'Section', true, ap.IconThemed, 'TabSectionIcon')

                ar.Size = UDim2.new(0, ap.IconSize, 0, ap.IconSize)
                ar.ImageLabel.ImageTransparency = 0.25
                ar.Position = UDim2.new(0.5, 0, 0.5, 0)
                ar.AnchorPoint = Vector2.new(0.5, 0.5)
                aq = af('Frame', {
                    Size = UDim2.new(0, 30, 0, 30),
                    ThemeTag = {
                        BackgroundColor3 = 'Accent',
                    },
                    BackgroundTransparency = 0,
                }, {
                    af('UICorner', {
                        CornerRadius = UDim.new(0, 8),
                    }),
                    af('UIStroke', {
                        Thickness = 1.2,
                        Color = ak.IconColor or nil,
                        ThemeTag = not ak.IconColor and {
                            Color = 'Accent',
                        } or nil,
                    }),
                    ar,
                })
            end

            local ar = af('Frame', {
                Size = UDim2.new(0, ap.IconSize, 0, ap.IconSize),
                BackgroundTransparency = 1,
                Visible = false,
            }, {
                af('ImageLabel', {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Image = ae.Icon'chevron-down'[1],
                    ImageRectSize = ae.Icon'chevron-down'[2].ImageRectSize,
                    ImageRectOffset = ae.Icon'chevron-down'[2].ImageRectPosition,
                    ThemeTag = {
                        ImageColor3 = 'Icon',
                    },
                    ImageTransparency = 0.7,
                }),
            })
            local as = af('Frame', {
                Size = UDim2.new(1, 0, 0, ap.HeaderSize),
                BackgroundTransparency = 1,
                Parent = al,
                ClipsDescendants = true,
            }, {
                af('TextButton', {
                    Size = UDim2.new(1, 0, 0, ap.HeaderSize),
                    BackgroundTransparency = 1,
                    Text = '',
                }, {
                    aq,
                    af('TextLabel', {
                        Text = ap.Title,
                        TextXAlignment = 'Left',
                        Size = UDim2.new(1, aq and (-ap.IconSize - 10) * 2 or (-ap.IconSize - 10), 1, 0),
                        ThemeTag = {
                            TextColor3 = 'Text',
                        },
                        FontFace = Font.new(ae.Font, Enum.FontWeight.SemiBold),
                        TextSize = 14,
                        BackgroundTransparency = 1,
                        TextTransparency = 0.7,
                        TextWrapped = true,
                    }),
                    af('UIListLayout', {
                        FillDirection = 'Horizontal',
                        VerticalAlignment = 'Center',
                        Padding = UDim.new(0, 10),
                    }),
                    ar,
                    af('UIPadding', {
                        PaddingLeft = UDim.new(0, 11),
                        PaddingRight = UDim.new(0, 11),
                    }),
                }),
                af('Frame', {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = 'Y',
                    Name = 'Content',
                    Visible = true,
                    Position = UDim2.new(0, 0, 0, ap.HeaderSize),
                }, {
                    af('UIListLayout', {
                        FillDirection = 'Vertical',
                        Padding = UDim.new(0, ao.Gap),
                        VerticalAlignment = 'Bottom',
                    }),
                }),
            })

            function ap.Tab(at, au)
                if not ap.Expandable then
                    ap.Expandable = true
                    ar.Visible = true
                end

                au.Parent = as.Content

                return aj.New(au, an)
            end
            function ap.Open(at)
                if ap.Expandable then
                    ap.Opened = true

                    ah(as, 0.33, {
                        Size = UDim2.new(1, 0, 0, ap.HeaderSize + (as.Content.AbsoluteSize.Y / an)),
                    }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                    ah(ar.ImageLabel, 0.1, {Rotation = 180}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                end
            end
            function ap.Close(at)
                if ap.Expandable then
                    ap.Opened = false

                    ah(as, 0.26, {
                        Size = UDim2.new(1, 0, 0, ap.HeaderSize),
                    }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                    ah(ar.ImageLabel, 0.1, {Rotation = 0}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                end
            end

            ae.AddSignal(as.TextButton.MouseButton1Click, function()
                if ap.Expandable then
                    if ap.Opened then
                        ap:Close()
                    else
                        ap:Open()
                    end
                end
            end)
            ae.AddSignal(as.Content.UIListLayout:GetPropertyChangedSignal'AbsoluteContentSize', function(
            )
                if ap.Opened then
                    ap:Open()
                end
            end)

            if ap.Opened then
                task.spawn(function()
                    task.wait()
                    ap:Open()
                end)
            end

            return ap
        end

        return aa
    end
    function a.Y()
        return {
            Tab = 'table-of-contents',
            Paragraph = 'type',
            Button = 'square-mouse-pointer',
            Toggle = 'toggle-right',
            Slider = 'sliders-horizontal',
            Keybind = 'command',
            Input = 'text-cursor-input',
            Dropdown = 'chevrons-up-down',
            Code = 'terminal',
            Colorpicker = 'palette',
        }
    end
    function a.Z()
        local aa = (cloneref or clonereference or function(aa)
            return aa
        end)

        aa(game:GetService'UserInputService')

        local ae = {
            Margin = 8,
            Padding = 9,
        }
        local af = a.load'c'
        local ah = af.New
        local aj = af.Tween

        function ae.new(ak, al, am)
            local an = {
                IconSize = 18,
                Padding = 14,
                Radius = 22,
                Width = 400,
                MaxHeight = 380,
                Icons = a.load'Y',
            }
            local ao = ah('TextBox', {
                Text = '',
                PlaceholderText = 'Search...',
                ThemeTag = {
                    PlaceholderColor3 = 'Placeholder',
                    TextColor3 = 'Text',
                },
                Size = UDim2.new(1, -((an.IconSize * 2) + (an.Padding * 2)), 0, 0),
                AutomaticSize = 'Y',
                ClipsDescendants = true,
                ClearTextOnFocus = false,
                BackgroundTransparency = 1,
                TextXAlignment = 'Left',
                FontFace = Font.new(af.Font, Enum.FontWeight.Regular),
                TextSize = 18,
            })
            local ap = ah('ImageLabel', {
                Image = af.Icon'x'[1],
                ImageRectSize = af.Icon'x'[2].ImageRectSize,
                ImageRectOffset = af.Icon'x'[2].ImageRectPosition,
                BackgroundTransparency = 1,
                ThemeTag = {
                    ImageColor3 = 'Icon',
                },
                ImageTransparency = 0.1,
                Size = UDim2.new(0, an.IconSize, 0, an.IconSize),
            }, {
                ah('TextButton', {
                    Size = UDim2.new(1, 8, 1, 8),
                    BackgroundTransparency = 1,
                    Active = true,
                    ZIndex = 999999999,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    Text = '',
                }),
            })
            local aq = ah('ScrollingFrame', {
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticCanvasSize = 'Y',
                ScrollingDirection = 'Y',
                ElasticBehavior = 'Never',
                ScrollBarThickness = 0,
                CanvasSize = UDim2.new(0, 0, 0, 0),
                BackgroundTransparency = 1,
                Visible = false,
            }, {
                ah('UIListLayout', {
                    Padding = UDim.new(0, 0),
                    FillDirection = 'Vertical',
                }),
                ah('UIPadding', {
                    PaddingTop = UDim.new(0, an.Padding),
                    PaddingLeft = UDim.new(0, an.Padding),
                    PaddingRight = UDim.new(0, an.Padding),
                    PaddingBottom = UDim.new(0, an.Padding),
                }),
            })
            local ar = af.NewRoundFrame(an.Radius, 'Squircle', {
                Size = UDim2.new(1, 0, 1, 0),
                ThemeTag = {
                    ImageColor3 = 'WindowSearchBarBackground',
                },
                ImageTransparency = 0,
            }, {
                af.NewRoundFrame(an.Radius, 'Squircle', {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Visible = false,
                    ThemeTag = {
                        ImageColor3 = 'White',
                    },
                    ImageTransparency = 1,
                    Name = 'Frame',
                }, {
                    ah('Frame', {
                        Size = UDim2.new(1, 0, 0, 46),
                        BackgroundTransparency = 1,
                    }, {
                        ah('Frame', {
                            Size = UDim2.new(1, 0, 1, 0),
                            BackgroundTransparency = 1,
                        }, {
                            ah('ImageLabel', {
                                Image = af.Icon'search'[1],
                                ImageRectSize = af.Icon'search'[2].ImageRectSize,
                                ImageRectOffset = af.Icon'search'[2].ImageRectPosition,
                                BackgroundTransparency = 1,
                                ThemeTag = {
                                    ImageColor3 = 'Icon',
                                },
                                ImageTransparency = 0.1,
                                Size = UDim2.new(0, an.IconSize, 0, an.IconSize),
                            }),
                            ao,
                            ap,
                            ah('UIListLayout', {
                                Padding = UDim.new(0, an.Padding),
                                FillDirection = 'Horizontal',
                                VerticalAlignment = 'Center',
                            }),
                            ah('UIPadding', {
                                PaddingLeft = UDim.new(0, an.Padding),
                                PaddingRight = UDim.new(0, an.Padding),
                            }),
                        }),
                    }),
                    ah('Frame', {
                        BackgroundTransparency = 1,
                        AutomaticSize = 'Y',
                        Size = UDim2.new(1, 0, 0, 0),
                        Name = 'Results',
                    }, {
                        ah('Frame', {
                            Size = UDim2.new(1, 0, 0, 1),
                            ThemeTag = {
                                BackgroundColor3 = 'Outline',
                            },
                            BackgroundTransparency = 0.9,
                            Visible = false,
                        }),
                        aq,
                        ah('UISizeConstraint', {
                            MaxSize = Vector2.new(an.Width, an.MaxHeight),
                        }),
                    }),
                    ah('UIListLayout', {
                        Padding = UDim.new(0, 0),
                        FillDirection = 'Vertical',
                    }),
                }),
            })
            local as = ah('Frame', {
                Size = UDim2.new(0, an.Width, 0, 0),
                AutomaticSize = 'Y',
                Parent = al,
                BackgroundTransparency = 1,
                Position = UDim2.new(0.5, 0, 0.5, 0),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Visible = false,
                ZIndex = 99999999,
            }, {
                ah('UIScale', {Scale = 0.9}),
                ar,
                af.NewRoundFrame(an.Radius, 'Glass-0.7', {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    ThemeTag = {
                        ImageColor3 = 'SearchBarBorder',
                        ImageTransparency = 'SearchBarBorderTransparency',
                    },
                    Name = 'Outline',
                }),
            })
            local at = function(at, au, av, aw, ax, ay)
                local az = ah('TextButton', {
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = 'Y',
                    BackgroundTransparency = 1,
                    Parent = aw or nil,
                }, {
                    af.NewRoundFrame(an.Radius - 11, 'Squircle', {
                        Size = UDim2.new(1, 0, 0, 0),
                        Position = UDim2.new(0.5, 0, 0.5, 0),
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        ThemeTag = {
                            ImageColor3 = 'Text',
                        },
                        ImageTransparency = 1,
                        Name = 'Main',
                    }, {
                        af.NewRoundFrame(an.Radius - 11, 'Glass-1', {
                            Size = UDim2.new(1, 0, 1, 0),
                            Position = UDim2.new(0.5, 0, 0.5, 0),
                            AnchorPoint = Vector2.new(0.5, 0.5),
                            ThemeTag = {
                                ImageColor3 = 'White',
                            },
                            ImageTransparency = 1,
                            Name = 'Outline',
                        }, {
                            ah('UIPadding', {
                                PaddingTop = UDim.new(0, an.Padding - 2),
                                PaddingLeft = UDim.new(0, an.Padding),
                                PaddingRight = UDim.new(0, an.Padding),
                                PaddingBottom = UDim.new(0, an.Padding - 2),
                            }),
                            ah('ImageLabel', {
                                Image = af.Icon(av)[1],
                                ImageRectSize = af.Icon(av)[2].ImageRectSize,
                                ImageRectOffset = af.Icon(av)[2].ImageRectPosition,
                                BackgroundTransparency = 1,
                                ThemeTag = {
                                    ImageColor3 = 'Icon',
                                },
                                ImageTransparency = 0.1,
                                Size = UDim2.new(0, an.IconSize, 0, an.IconSize),
                            }),
                            ah('Frame', {
                                Size = UDim2.new(1, -an.IconSize - an.Padding, 0, 0),
                                BackgroundTransparency = 1,
                            }, {
                                ah('TextLabel', {
                                    Text = at,
                                    ThemeTag = {
                                        TextColor3 = 'Text',
                                    },
                                    TextSize = 17,
                                    BackgroundTransparency = 1,
                                    TextXAlignment = 'Left',
                                    FontFace = Font.new(af.Font, Enum.FontWeight.Medium),
                                    Size = UDim2.new(1, 0, 0, 0),
                                    TextTruncate = 'AtEnd',
                                    AutomaticSize = 'Y',
                                    Name = 'Title',
                                }),
                                ah('TextLabel', {
                                    Text = au or '',
                                    Visible = au and true or false,
                                    ThemeTag = {
                                        TextColor3 = 'Text',
                                    },
                                    TextSize = 15,
                                    TextTransparency = 0.3,
                                    BackgroundTransparency = 1,
                                    TextXAlignment = 'Left',
                                    FontFace = Font.new(af.Font, Enum.FontWeight.Medium),
                                    Size = UDim2.new(1, 0, 0, 0),
                                    TextTruncate = 'AtEnd',
                                    AutomaticSize = 'Y',
                                    Name = 'Desc',
                                }) or nil,
                                ah('UIListLayout', {
                                    Padding = UDim.new(0, 6),
                                    FillDirection = 'Vertical',
                                }),
                            }),
                            ah('UIListLayout', {
                                Padding = UDim.new(0, an.Padding),
                                FillDirection = 'Horizontal',
                            }),
                        }),
                    }, true),
                    ah('Frame', {
                        Name = 'ParentContainer',
                        Size = UDim2.new(1, -an.Padding, 0, 0),
                        AutomaticSize = 'Y',
                        BackgroundTransparency = 1,
                        Visible = ax,
                    }, {
                        af.NewRoundFrame(99, 'Squircle', {
                            Size = UDim2.new(0, 2, 1, 0),
                            BackgroundTransparency = 1,
                            ThemeTag = {
                                ImageColor3 = 'Text',
                            },
                            ImageTransparency = 0.9,
                        }),
                        ah('Frame', {
                            Size = UDim2.new(1, -an.Padding - 2, 0, 0),
                            Position = UDim2.new(0, an.Padding + 2, 0, 0),
                            BackgroundTransparency = 1,
                        }, {
                            ah('UIListLayout', {
                                Padding = UDim.new(0, 0),
                                FillDirection = 'Vertical',
                            }),
                        }),
                    }),
                    ah('UIListLayout', {
                        Padding = UDim.new(0, 0),
                        FillDirection = 'Vertical',
                        HorizontalAlignment = 'Right',
                    }),
                })

                az.Main.Size = UDim2.new(1, 0, 0, az.Main.Outline.Frame.Desc.Visible and (((an.Padding - 2) * 2) + az.Main.Outline.Frame.Title.TextBounds.Y + 6 + az.Main.Outline.Frame.Desc.TextBounds.Y) or (((an.Padding - 2) * 2) + az.Main.Outline.Frame.Title.TextBounds.Y))

                af.AddSignal(az.Main.MouseEnter, function()
                    aj(az.Main, 0.04, {ImageTransparency = 0.95}):Play()
                    aj(az.Main.Outline, 0.04, {ImageTransparency = 0.75}):Play()
                end)
                af.AddSignal(az.Main.InputEnded, function()
                    aj(az.Main, 0.08, {ImageTransparency = 1}):Play()
                    aj(az.Main.Outline, 0.08, {ImageTransparency = 1}):Play()
                end)
                af.AddSignal(az.Main.MouseButton1Click, function()
                    if ay then
                        ay()
                    end
                end)

                return az
            end
            local au = function(au, av)
                if not av or av == '' then
                    return false
                end
                if not au or au == '' then
                    return false
                end

                local aw = string.lower(au)
                local ax = string.lower(av)

                return string.find(aw, ax, 1, true) ~= nil
            end
            local av = function(av)
                if not av or av == '' then
                    return {}
                end

                local aw = {}

                for ax, ay in next, ak.Tabs do
                    local az = au(ay.Title or '', av)
                    local aA = {}

                    for aB, aC in next, ay.Elements do
                        if aC.__type ~= 'Section' then
                            local b = au(aC.Title or '', av)
                            local c = au(aC.Desc or '', av)

                            if b or c then
                                aA[aB] = {
                                    Title = aC.Title,
                                    Desc = aC.Desc,
                                    Original = aC,
                                    __type = aC.__type,
                                    Index = aB,
                                }
                            end
                        end
                    end

                    if az or next(aA) ~= nil then
                        aw[ax] = {
                            Tab = ay,
                            Title = ay.Title,
                            Icon = ay.Icon,
                            Elements = aA,
                        }
                    end
                end

                return aw
            end

            af.AddSignal(aq.UIListLayout:GetPropertyChangedSignal'AbsoluteContentSize', function(
            )
                aj(aq, 0.06, {
                    Size = UDim2.new(1, 0, 0, math.clamp(aq.UIListLayout.AbsoluteContentSize.Y + (an.Padding * 2), 0, an.MaxHeight)),
                }, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut):Play()
            end)

            function an.Open(aw)
                task.spawn(function()
                    ar.Frame.Visible = true
                    as.Visible = true

                    aj(as.UIScale, 0.12, {Scale = 1}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                end)
            end
            function an.Close(aw, ax)
                task.spawn(function()
                    am()

                    ar.Frame.Visible = false

                    aj(as.UIScale, 0.12, {Scale = 1}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                    task.wait(0.12)

                    as.Visible = false

                    if ax then
                        as:Destroy()
                    end
                end)
            end

            af.AddSignal(ap.TextButton.MouseButton1Click, function()
                an:Close(true)
            end)
            an:Open()

            function an.Search(aw, ax)
                ax = ax or ''

                local ay = av(ax)

                aq.Visible = true
                ar.Frame.Results.Frame.Visible = true

                for az, aA in next, aq:GetChildren()do
                    if aA.ClassName ~= 'UIListLayout' and aA.ClassName ~= 'UIPadding' then
                        aA:Destroy()
                    end
                end

                if ay and next(ay) ~= nil then
                    for az, aA in next, ay do
                        local aB = an.Icons.Tab
                        local aC = at(aA.Title, nil, aB, aq, true, function()
                            an:Close()
                            ak:SelectTab(az)
                        end)

                        if aA.Elements and next(aA.Elements) ~= nil then
                            for b, c in next, aA.Elements do
                                local d = an.Icons[c.__type]

                                at(c.Title, c.Desc, d, aC:FindFirstChild'ParentContainer' and aC.ParentContainer.Frame or nil, false, function(
                                )
                                    an:Close()
                                    ak:SelectTab(az)

                                    if aA.Tab.ScrollToTheElement then
                                        aA.Tab:ScrollToTheElement(c.Index)
                                    end
                                end)
                            end
                        end
                    end
                elseif ax ~= '' then
                    ah('TextLabel', {
                        Size = UDim2.new(1, 0, 0, 70),
                        Text = 'No results found',
                        TextSize = 16,
                        ThemeTag = {
                            TextColor3 = 'Text',
                        },
                        TextTransparency = 0.2,
                        BackgroundTransparency = 1,
                        FontFace = Font.new(af.Font, Enum.FontWeight.Medium),
                        Parent = aq,
                        Name = 'NotFound',
                    })
                else
                    aq.Visible = false
                    ar.Frame.Results.Frame.Visible = false
                end
            end

            af.AddSignal(ao:GetPropertyChangedSignal'Text', function()
                an:Search(ao.Text)
            end)

            return an
        end

        return ae
    end
    function a._()
        local aa = (cloneref or clonereference or function(aa)
            return aa
        end)
        local ae = aa(game:GetService'UserInputService')
        local af = aa(game:GetService'RunService')
        local ah = aa(game:GetService'Players')
        local aj = workspace.CurrentCamera
        local ak = a.load's'
        local al = a.load'c'
        local am = al.New
        local an = al.Tween
        local ao = a.load'v'.New
        local ap = a.load'l'.New
        local aq = a.load'w'.New
        local ar = a.load'x'
        local as = a.load'y'

        return function(at)
            local au = {
                Title = at.Title or 'UI Library',
                Author = at.Author,
                Icon = at.Icon,
                IconSize = at.IconSize or 22,
                IconThemed = at.IconThemed,
                IconRadius = at.IconRadius or 0,
                Folder = at.Folder,
                Resizable = at.Resizable ~= false,
                Background = at.Background,
                BackgroundImageTransparency = at.BackgroundImageTransparency or 0,
                ShadowTransparency = at.ShadowTransparency or 0.6,
                User = at.User or {},
                Footer = at.Footer or {},
                Topbar = at.Topbar or {
                    Height = 52,
                    ButtonsType = 'Default',
                },
                Size = at.Size,
                MinSize = at.MinSize or Vector2.new(560, 350),
                MaxSize = at.MaxSize or Vector2.new(850, 560),
                TopBarButtonIconSize = at.TopBarButtonIconSize,
                ToggleKey = at.ToggleKey,
                ElementsRadius = at.ElementsRadius,
                Radius = at.Radius or 14,
                Transparent = at.Transparent or false,
                HideSearchBar = at.HideSearchBar ~= false,
                ScrollBarEnabled = at.ScrollBarEnabled or false,
                SideBarWidth = at.SideBarWidth or 200,
                Acrylic = at.Acrylic or false,
                NewElements = at.NewElements or false,
                IgnoreAlerts = at.IgnoreAlerts or false,
                HidePanelBackground = at.HidePanelBackground or false,
                AutoScale = at.AutoScale ~= false,
                OpenButton = at.OpenButton,
                DragFrameSize = 160,
                Position = UDim2.new(0.5, 0, 0.5, 0),
                UICorner = nil,
                UIPadding = 14,
                UIElements = {},
                CanDropdown = true,
                Closed = false,
                Parent = at.Parent,
                Destroyed = false,
                IsFullscreen = false,
                CanResize = at.Resizable ~= false,
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

            au.UICorner = au.Radius
            au.TopBarButtonIconSize = au.TopBarButtonIconSize or (au.Topbar.ButtonsType == 'Mac' and 11 or 16)
            au.ElementConfig = {
                UIPadding = (au.NewElements and 10 or 13),
                UICorner = au.ElementsRadius or (au.NewElements and 23 or 12),
            }

            local av = au.Size or UDim2.new(0, 780, 0, 500)

            au.Size = UDim2.new(av.X.Scale, math.clamp(av.X.Offset, au.MinSize.X, 1200), av.Y.Scale, math.clamp(av.Y.Offset, au.MinSize.Y, 800))

            if au.Topbar == {} then
                au.Topbar = {
                    Height = 52,
                    ButtonsType = 'Default',
                }
            end
            if not af:IsStudio() and au.Folder and writefile then
                if not isfolder('IntiHub_Data/' .. au.Folder) then
                    makefolder('IntiHub_Data/' .. au.Folder)
                end
                if not isfolder('IntiHub_Data/' .. au.Folder .. '/assets') then
                    makefolder('IntiHub_Data/' .. au.Folder .. '/assets')
                end
            end

            local aw = am('UICorner', {
                CornerRadius = UDim.new(0, au.UICorner),
            })

            if au.Folder then
                au.ConfigManager = as:Init(au)
            end
            if au.Acrylic then
                local ax = ak.AcrylicPaint{
                    UseAcrylic = au.Acrylic,
                }

                au.AcrylicPaint = ax
            end

            local ax = am('Frame', {
                Size = UDim2.new(0, 32, 0, 32),
                Position = UDim2.new(1, 0, 1, 0),
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundTransparency = 1,
                ZIndex = 99,
                Active = true,
            }, {
                am('ImageLabel', {
                    Size = UDim2.new(0, 96, 0, 96),
                    BackgroundTransparency = 1,
                    Image = 'rbxassetid://120997033468887',
                    Position = UDim2.new(0.5, -16, 0.5, -16),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    ImageTransparency = 1,
                }),
            })
            local ay = al.NewRoundFrame(au.UICorner, 'Squircle', {
                Size = UDim2.new(1, 0, 1, 0),
                ImageTransparency = 1,
                ImageColor3 = Color3.new(0, 0, 0),
                ZIndex = 98,
                Active = false,
            }, {
                am('ImageLabel', {
                    Size = UDim2.new(0, 70, 0, 70),
                    Image = al.Icon'expand'[1],
                    ImageRectOffset = al.Icon'expand'[2].ImageRectPosition,
                    ImageRectSize = al.Icon'expand'[2].ImageRectSize,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    ImageTransparency = 1,
                }),
            })
            local az = al.NewRoundFrame(au.UICorner, 'Squircle', {
                Size = UDim2.new(1, 0, 1, 0),
                ImageTransparency = 1,
                ImageColor3 = Color3.new(0, 0, 0),
                ZIndex = 999,
                Active = false,
            })

            au.UIElements.SideBar = am('ScrollingFrame', {
                Size = UDim2.new(1, au.ScrollBarEnabled and -3 - (au.UIPadding / 2) or 0, 1, not au.HideSearchBar and 
-45 or 0),
                Position = UDim2.new(0, 0, 1, 0),
                AnchorPoint = Vector2.new(0, 1),
                BackgroundTransparency = 1,
                ScrollBarThickness = 0,
                ElasticBehavior = 'Never',
                CanvasSize = UDim2.new(0, 0, 0, 0),
                AutomaticCanvasSize = 'Y',
                ScrollingDirection = 'Y',
                ClipsDescendants = true,
                VerticalScrollBarPosition = 'Left',
            }, {
                am('Frame', {
                    BackgroundTransparency = 1,
                    AutomaticSize = 'Y',
                    Size = UDim2.new(1, 0, 0, 0),
                    Name = 'Frame',
                }, {
                    am('UIPadding', {
                        PaddingBottom = UDim.new(0, au.UIPadding / 2),
                    }),
                    am('UIListLayout', {
                        SortOrder = 'LayoutOrder',
                        Padding = UDim.new(0, au.Gap),
                    }),
                }),
                am('UIPadding', {
                    PaddingLeft = UDim.new(0, au.UIPadding / 2),
                    PaddingRight = UDim.new(0, au.UIPadding / 2),
                }),
            })
            au.UIElements.SideBarContainer = am('Frame', {
                Size = UDim2.new(0, au.SideBarWidth, 1, -au.Topbar.Height),
                Position = UDim2.new(0, 0, 0, au.Topbar.Height),
                BackgroundTransparency = 1,
                Visible = true,
            }, {
                am('Frame', {
                    Name = 'Content',
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Position = UDim2.new(0, 0, 1, 0),
                    AnchorPoint = Vector2.new(0, 1),
                }),
                au.UIElements.SideBar,
                am('Frame', {
                    Size = UDim2.new(0, 1, 1, -20),
                    Position = UDim2.new(1, 0, 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundColor3 = Color3.fromHex'#FFD700',
                    BackgroundTransparency = 0.92,
                    BorderSizePixel = 0,
                }),
            })

            if au.ScrollBarEnabled then
                aq(au.UIElements.SideBar, au.UIElements.SideBarContainer.Content, au, 3)
            end

            au.UIElements.MainBar = am('Frame', {
                Size = UDim2.new(1, -au.SideBarWidth - (au.User.Enabled and 200 or 0), 1, 
-au.Topbar.Height),
                Position = UDim2.new(0, au.SideBarWidth, 0, au.Topbar.Height),
                BackgroundTransparency = 1,
            }, {
                al.NewRoundFrame(au.UICorner - (au.UIPadding / 2), 'Squircle', {
                    Size = UDim2.new(1, 0, 1, 0),
                    ThemeTag = {
                        ImageColor3 = 'PanelBackground',
                        ImageTransparency = 'PanelBackgroundTransparency',
                    },
                    ZIndex = 3,
                    Name = 'Background',
                    Visible = not au.HidePanelBackground,
                }, {
                    am('UIStroke', {
                        Thickness = 1,
                        Color = Color3.fromHex'#FFD700',
                        Transparency = 0.9,
                    }),
                }),
                am('UIPadding', {
                    PaddingLeft = UDim.new(0, au.UIPadding),
                    PaddingRight = UDim.new(0, au.UIPadding),
                    PaddingBottom = UDim.new(0, au.UIPadding),
                    PaddingTop = UDim.new(0, au.UIPadding),
                }),
            })
            au.UIElements.RightPanel = am('Frame', {
                Size = UDim2.new(0, 200, 1, -au.Topbar.Height),
                Position = UDim2.new(1, 0, 0, au.Topbar.Height),
                AnchorPoint = Vector2.new(1, 0),
                BackgroundTransparency = 1,
                Visible = au.User.Enabled or true,
            }, {
                al.NewRoundFrame(au.UICorner - (au.UIPadding / 2), 'Squircle', {
                    Size = UDim2.new(1, 0, 1, 0),
                    ThemeTag = {
                        ImageColor3 = 'PanelBackground',
                        ImageTransparency = 'PanelBackgroundTransparency',
                    },
                    ZIndex = 3,
                }, {
                    am('UIStroke', {
                        Thickness = 1,
                        Color = Color3.fromHex'#FFD700',
                        Transparency = 0.9,
                    }),
                }),
                am('UIPadding', {
                    PaddingLeft = UDim.new(0, au.UIPadding),
                    PaddingRight = UDim.new(0, au.UIPadding),
                    PaddingBottom = UDim.new(0, au.UIPadding),
                    PaddingTop = UDim.new(0, au.UIPadding),
                }),
                am('UIListLayout', {
                    Padding = UDim.new(0, 15),
                    HorizontalAlignment = 'Center',
                }),
                am('Frame', {
                    Size = UDim2.new(1, 0, 0, 120),
                    BackgroundTransparency = 1,
                }, {
                    am('UIListLayout', {
                        Padding = UDim.new(0, 8),
                        HorizontalAlignment = 'Center',
                    }),
                    am('Frame', {
                        Size = UDim2.new(0, 80, 0, 80),
                        BackgroundColor3 = Color3.fromHex'#1A1A1A',
                    }, {
                        am('UICorner', {
                            CornerRadius = UDim.new(0, 12),
                        }),
                        am('UIStroke', {
                            Thickness = 1.5,
                            Color = Color3.fromHex'#FFD700',
                            Transparency = 0.6,
                        }),
                        am('ImageLabel', {
                            Name = 'Avatar',
                            Size = UDim2.new(1, -8, 1, -8),
                            Position = UDim2.new(0.5, 0, 0.5, 0),
                            AnchorPoint = Vector2.new(0.5, 0.5),
                            Image = 'rbxassetid://6033722245',
                            BackgroundTransparency = 1,
                        }, {
                            am('UICorner', {
                                CornerRadius = UDim.new(1, 0),
                            }),
                        }),
                    }),
                    am('TextLabel', {
                        Text = 'Executive User',
                        TextSize = 14,
                        FontFace = Font.new(al.Font, Enum.FontWeight.Bold),
                        TextColor3 = Color3.new(1, 1, 1),
                        BackgroundTransparency = 1,
                        AutomaticSize = 'XY',
                    }),
                }),
                am('Frame', {
                    Size = UDim2.new(1, 0, 0, 80),
                    BackgroundTransparency = 1,
                }, {
                    am('UIListLayout', {
                        Padding = UDim.new(0, 6),
                    }),
                    am('Frame', {
                        Size = UDim2.new(1, 0, 0, 32),
                        BackgroundColor3 = Color3.new(1, 1, 1),
                        BackgroundTransparency = 0.95,
                    }, {
                        am('UICorner', {
                            CornerRadius = UDim.new(0, 6),
                        }),
                        am('ImageLabel', {
                            Size = UDim2.new(0, 16, 0, 16),
                            Position = UDim2.new(0, 10, 0.5, 0),
                            AnchorPoint = Vector2.new(0, 0.5),
                            Image = al.Icon'at-sign'[1],
                            ImageRectOffset = al.Icon'at-sign'[2].ImageRectPosition,
                            ImageRectSize = al.Icon'at-sign'[2].ImageRectSize,
                            ThemeTag = {
                                ImageColor3 = 'Accent',
                            },
                        }),
                        am('TextLabel', {
                            Text = '@IntiDeveloper',
                            TextSize = 12,
                            TextColor3 = Color3.new(1, 1, 1),
                            TextTransparency = 0.4,
                            Position = UDim2.new(0, 32, 0.5, 0),
                            AnchorPoint = Vector2.new(0, 0.5),
                            BackgroundTransparency = 1,
                        }),
                    }),
                    am('Frame', {
                        Size = UDim2.new(1, 0, 0, 32),
                        BackgroundColor3 = Color3.new(1, 1, 1),
                        BackgroundTransparency = 0.95,
                    }, {
                        am('UICorner', {
                            CornerRadius = UDim.new(0, 6),
                        }),
                        am('ImageLabel', {
                            Size = UDim2.new(0, 16, 0, 16),
                            Position = UDim2.new(0, 10, 0.5, 0),
                            AnchorPoint = Vector2.new(0, 0.5),
                            Image = al.Icon'user'[1],
                            ImageRectOffset = al.Icon'user'[2].ImageRectPosition,
                            ImageRectSize = al.Icon'user'[2].ImageRectSize,
                            ThemeTag = {
                                ImageColor3 = 'Accent',
                            },
                        }),
                        am('TextLabel', {
                            Text = 'IntiHub_Admin',
                            TextSize = 12,
                            TextColor3 = Color3.new(1, 1, 1),
                            TextTransparency = 0.4,
                            Position = UDim2.new(0, 32, 0.5, 0),
                            AnchorPoint = Vector2.new(0, 0.5),
                            BackgroundTransparency = 1,
                        }),
                    }),
                }),
                am('Frame', {
                    Size = UDim2.new(1, 0, 0, 60),
                    BackgroundColor3 = Color3.fromHex'#FFD700',
                    BackgroundTransparency = 0.95,
                }, {
                    am('UICorner', {
                        CornerRadius = UDim.new(0, 8),
                    }),
                    am('UIStroke', {
                        Thickness = 1,
                        Color = Color3.fromHex'#FFD700',
                        Transparency = 0.8,
                    }),
                    am('ImageLabel', {
                        Size = UDim2.new(0, 24, 0, 24),
                        Position = UDim2.new(0, 12, 0.5, 0),
                        AnchorPoint = Vector2.new(0, 0.5),
                        Image = al.Icon'zap'[1],
                        ImageRectOffset = al.Icon'zap'[2].ImageRectPosition,
                        ImageRectSize = al.Icon'zap'[2].ImageRectSize,
                        ThemeTag = {
                            ImageColor3 = 'Accent',
                        },
                    }),
                    am('TextLabel', {
                        Text = 'CURRENT ENGINE',
                        TextSize = 10,
                        TextColor3 = Color3.new(1, 1, 1),
                        TextTransparency = 0.5,
                        Position = UDim2.new(0, 44, 0.35, 0),
                        AnchorPoint = Vector2.new(0, 0.5),
                        BackgroundTransparency = 1,
                    }),
                    am('TextLabel', {
                        Text = "Executor: <font color='#FFD700'>Arceus X</font>",
                        TextSize = 12,
                        TextColor3 = Color3.new(1, 1, 1),
                        Position = UDim2.new(0, 44, 0.65, 0),
                        AnchorPoint = Vector2.new(0, 0.5),
                        BackgroundTransparency = 1,
                        RichText = true,
                    }),
                }),
            })

            am('Frame', {
                Size = UDim2.new(1, 0, 0, 60),
                Parent = au.UIElements.MainBar,
                BackgroundTransparency = 1,
            }, {
                am('TextLabel', {
                    Text = 'MODULE CONTROL',
                    TextSize = 10,
                    FontFace = Font.new(al.Font, Enum.FontWeight.Bold),
                    TextColor3 = Color3.fromHex'#FFD700',
                    TextTransparency = 0.4,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 5),
                }),
                am('TextLabel', {
                    Text = 'Configuration Dashboard',
                    TextSize = 24,
                    FontFace = Font.new(al.Font, Enum.FontWeight.Bold),
                    TextColor3 = Color3.new(1, 1, 1),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 18),
                    AutomaticSize = 'XY',
                }),
            })

            au.UIElements.TabScrollAdjustment = 60

            local aA = am('ImageLabel', {
                Image = 'rbxassetid://8992230677',
                ThemeTag = {
                    ImageColor3 = 'WindowShadow',
                },
                ImageTransparency = 1,
                Size = UDim2.new(1, 100, 1, 100),
                Position = UDim2.new(0, -50, 0, -50),
                ScaleType = 'Slice',
                SliceCenter = Rect.new(99, 99, 99, 99),
                BackgroundTransparency = 1,
                ZIndex = -999999999999999,
                Name = 'Blur',
            })

            if ae.TouchEnabled and not ae.KeyboardEnabled then
                au.IsPC = false
            elseif ae.KeyboardEnabled then
                au.IsPC = true
            else
                au.IsPC = nil
            end

            local aB

            if au.User then
                local aC = function()
                    local aC = ah:GetUserThumbnailAsync(au.User.Anonymous and 1 or ah.LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)

                    return aC
                end

                aB = am('TextButton', {
                    Size = UDim2.new(0, au.UIElements.SideBarContainer.AbsoluteSize.X - (au.UIPadding / 2), 0, 42 + au.UIPadding),
                    Position = UDim2.new(0, au.UIPadding / 2, 1, -(au.UIPadding / 2)),
                    AnchorPoint = Vector2.new(0, 1),
                    BackgroundTransparency = 1,
                    Visible = au.User.Enabled or false,
                }, {
                    al.NewRoundFrame(au.UICorner - (au.UIPadding / 2), 'SquircleOutline', {
                        Size = UDim2.new(1, 0, 1, 0),
                        ThemeTag = {
                            ImageColor3 = 'Text',
                        },
                        ImageTransparency = 1,
                        Name = 'Outline',
                    }, {
                        am('UIGradient', {
                            Rotation = 78,
                            Color = ColorSequence.new{
                                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
                                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
                            },
                            Transparency = NumberSequence.new{
                                NumberSequenceKeypoint.new(0, 0.1),
                                NumberSequenceKeypoint.new(0.5, 1),
                                NumberSequenceKeypoint.new(1, 0.1),
                            },
                        }),
                    }),
                    al.NewRoundFrame(au.UICorner - (au.UIPadding / 2), 'Squircle', {
                        Size = UDim2.new(1, 0, 1, 0),
                        ThemeTag = {
                            ImageColor3 = 'Text',
                        },
                        ImageTransparency = 1,
                        Name = 'UserIcon',
                    }, {
                        am('ImageLabel', {
                            Image = aC(),
                            BackgroundTransparency = 1,
                            Size = UDim2.new(0, 42, 0, 42),
                            ThemeTag = {
                                BackgroundColor3 = 'Text',
                            },
                            BackgroundTransparency = 0.93,
                        }, {
                            am('UICorner', {
                                CornerRadius = UDim.new(1, 0),
                            }),
                        }),
                        am('Frame', {
                            AutomaticSize = 'XY',
                            BackgroundTransparency = 1,
                        }, {
                            am('TextLabel', {
                                Text = au.User.Anonymous and 'Anonymous' or ah.LocalPlayer.DisplayName,
                                TextSize = 17,
                                ThemeTag = {
                                    TextColor3 = 'Text',
                                },
                                FontFace = Font.new(al.Font, Enum.FontWeight.SemiBold),
                                AutomaticSize = 'Y',
                                BackgroundTransparency = 1,
                                Size = UDim2.new(1, -27, 0, 0),
                                TextTruncate = 'AtEnd',
                                TextXAlignment = 'Left',
                                Name = 'DisplayName',
                            }),
                            am('TextLabel', {
                                Text = au.User.Anonymous and 'anonymous' or ah.LocalPlayer.Name,
                                TextSize = 15,
                                TextTransparency = 0.6,
                                ThemeTag = {
                                    TextColor3 = 'Text',
                                },
                                FontFace = Font.new(al.Font, Enum.FontWeight.Medium),
                                AutomaticSize = 'Y',
                                BackgroundTransparency = 1,
                                Size = UDim2.new(1, -27, 0, 0),
                                TextTruncate = 'AtEnd',
                                TextXAlignment = 'Left',
                                Name = 'UserName',
                            }),
                            am('UIListLayout', {
                                Padding = UDim.new(0, 4),
                                HorizontalAlignment = 'Left',
                            }),
                        }),
                        am('UIListLayout', {
                            Padding = UDim.new(0, au.UIPadding),
                            FillDirection = 'Horizontal',
                            VerticalAlignment = 'Center',
                        }),
                        am('UIPadding', {
                            PaddingLeft = UDim.new(0, au.UIPadding / 2),
                            PaddingRight = UDim.new(0, au.UIPadding / 2),
                        }),
                    }),
                })

                function au.User.Enable(b)
                    au.User.Enabled = true

                    an(au.UIElements.SideBarContainer, 0.25, {
                        Size = UDim2.new(0, au.SideBarWidth, 1, -au.Topbar.Height - 42 - (au.UIPadding * 2)),
                    }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()

                    aB.Visible = true
                end
                function au.User.Disable(b)
                    au.User.Enabled = false

                    an(au.UIElements.SideBarContainer, 0.25, {
                        Size = UDim2.new(0, au.SideBarWidth, 1, -au.Topbar.Height),
                    }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()

                    aB.Visible = false
                end
                function au.User.SetAnonymous(b, c)
                    if c ~= false then
                        c = true
                    end

                    au.User.Anonymous = c
                    aB.UserIcon.ImageLabel.Image = aC()
                    aB.UserIcon.Frame.DisplayName.Text = c and 'Anonymous' or ah.LocalPlayer.DisplayName
                    aB.UserIcon.Frame.UserName.Text = c and 'anonymous' or ah.LocalPlayer.Name
                end

                if au.User.Enabled then
                    au.User:Enable()
                else
                    au.User:Disable()
                end
                if au.User.Callback then
                    al.AddSignal(aB.MouseButton1Click, function()
                        au.User.Callback()
                    end)
                    al.AddSignal(aB.MouseEnter, function()
                        an(aB.UserIcon, 0.04, {ImageTransparency = 0.95}):Play()
                        an(aB.Outline, 0.04, {ImageTransparency = 0.85}):Play()
                    end)
                    al.AddSignal(aB.InputEnded, function()
                        an(aB.UserIcon, 0.04, {ImageTransparency = 1}):Play()
                        an(aB.Outline, 0.04, {ImageTransparency = 1}):Play()
                    end)
                end
            end

            local aC
            local b
            local c = false
            local d
            local e = typeof(au.Background) == 'string' and string.match(au.Background, '^video:(.+)') or nil
            local f = typeof(au.Background) == 'string' and not e and string.match(au.Background, '^https?://.+') or nil
            local g = function(g)
                local i = g:match'%.(%w+)$' or g:match'%.(%w+)%?'

                if i then
                    i = i:lower()

                    if i == 'jpg' or i == 'jpeg' or i == 'png' or i == 'webp' then
                        return '.' .. i
                    end
                end

                return '.png'
            end

            if typeof(au.Background) == 'string' and e then
                c = true

                if string.find(e, 'http') then
                    local i = au.Folder .. '/assets/.' .. al.SanitizeFilename(e) .. '.webm'

                    if not isfile(i) then
                        local j, k = pcall(function()
                            local j = game.HttpGet and game:HttpGet(e)

                            writefile(i, j.Body)
                        end)

                        if not j then
                            warn('[ IntiHub.Window.Background ] Failed to download video: ' .. tostring(k))

                            return
                        end
                    end

                    local j, k = pcall(function()
                        return getcustomasset(i)
                    end)

                    if not j then
                        warn('[ IntiHub.Window.Background ] Failed to load custom asset: ' .. tostring(k))

                        return
                    end

                    warn
[[[ IntiHub.Window.Background ] VideoFrame may not work with custom video]]

                    e = k
                end

                d = am('VideoFrame', {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Video = e,
                    Looped = true,
                    Volume = 0,
                }, {
                    am('UICorner', {
                        CornerRadius = UDim.new(0, au.UICorner),
                    }),
                })

                d:Play()
            elseif f then
                local i = au.Folder .. '/assets/.' .. al.SanitizeFilename(f) .. g(f)

                if isfile and not isfile(i) then
                    local j, k = pcall(function()
                        local j = game.HttpGet and game:HttpGet(f)

                        writefile(i, j.Body)
                    end)

                    if not j then
                        warn('[ Window.Background ] Failed to download image: ' .. tostring(k))

                        return
                    end
                end

                local j, k = pcall(function()
                    return getcustomasset(i)
                end)

                if not j then
                    warn('[ Window.Background ] Failed to load custom asset: ' .. tostring(k))

                    return
                end

                d = am('ImageLabel', {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Image = k,
                    ImageTransparency = 0,
                    ScaleType = 'Crop',
                }, {
                    am('UICorner', {
                        CornerRadius = UDim.new(0, au.UICorner),
                    }),
                })
            elseif au.Background then
                d = am('ImageLabel', {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Image = typeof(au.Background) == 'string' and au.Background or '',
                    ImageTransparency = 1,
                    ScaleType = 'Crop',
                }, {
                    am('UICorner', {
                        CornerRadius = UDim.new(0, au.UICorner),
                    }),
                })
            end

            local i = al.NewRoundFrame(99, 'Squircle', {
                ImageTransparency = 0.8,
                ImageColor3 = Color3.new(1, 1, 1),
                Size = UDim2.new(0, 0, 0, 4),
                Position = UDim2.new(0.5, 0, 1, 4),
                AnchorPoint = Vector2.new(0.5, 0),
            }, {
                am('TextButton', {
                    Size = UDim2.new(1, 12, 1, 12),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Active = true,
                    ZIndex = 99,
                    Name = 'Frame',
                }),
            })

            function createAuthor(j)
                return am('TextLabel', {
                    Text = j,
                    FontFace = Font.new(al.Font, Enum.FontWeight.Medium),
                    BackgroundTransparency = 1,
                    TextTransparency = 0.35,
                    AutomaticSize = 'XY',
                    Parent = au.UIElements.Main and au.UIElements.Main.Main.Topbar.Left.Title,
                    TextXAlignment = 'Left',
                    TextSize = 13,
                    LayoutOrder = 2,
                    ThemeTag = {
                        TextColor3 = 'WindowTopbarAuthor',
                    },
                    Name = 'Author',
                })
            end

            local j
            local k

            if au.Author then
                j = createAuthor(au.Author)
            end

            local l = am('TextLabel', {
                Text = au.Title,
                FontFace = Font.new(al.Font, Enum.FontWeight.SemiBold),
                BackgroundTransparency = 1,
                AutomaticSize = 'XY',
                Name = 'Title',
                TextXAlignment = 'Left',
                TextSize = 16,
                ThemeTag = {
                    TextColor3 = 'WindowTopbarTitle',
                },
            })

            au.UIElements.Main = am('Frame', {
                Size = au.Size,
                Position = au.Position,
                BackgroundTransparency = 1,
                Parent = at.Parent,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Active = true,
            }, {
                at.IntiHub.UIScaleObj,
                au.AcrylicPaint and au.AcrylicPaint.Frame or nil,
                aA,
                al.NewRoundFrame(au.UICorner, 'Squircle', {
                    ImageTransparency = 1,
                    Size = UDim2.new(1, 0, 1, -240),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    Name = 'Background',
                    ThemeTag = {
                        ImageColor3 = 'WindowBackground',
                        ImageTransparency = 'WindowBackgroundTransparency',
                    },
                }, {d, i, ax}),
                am('UIStroke', {
                    Thickness = 2,
                    ApplyStrokeMode = 'Border',
                    ThemeTag = {
                        Color = 'Accent',
                    },
                }, {
                    am('UIGradient', {
                        Name = 'AnimatedGradient1',
                        Rotation = 0,
                        Color = ColorSequence.new{
                            ColorSequenceKeypoint.new(0, Color3.fromHex'#FFC300'),
                            ColorSequenceKeypoint.new(0.5, Color3.fromHex'#000000'),
                            ColorSequenceKeypoint.new(1, Color3.fromHex'#FFC300'),
                        },
                    }),
                }),
                am('Frame', {
                    Name = 'AnimationOverlay',
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                }, {
                    am('UICorner', {
                        CornerRadius = UDim.new(0, au.UICorner),
                    }),
                    am('UIStroke', {
                        Thickness = 3,
                        ApplyStrokeMode = 'Border',
                        Transparency = 0.5,
                        ThemeTag = {
                            Color = 'Accent',
                        },
                    }, {
                        am('UIGradient', {
                            Name = 'AnimatedGradient2',
                            Rotation = 0,
                            Color = ColorSequence.new{
                                ColorSequenceKeypoint.new(0, Color3.fromHex'#000000'),
                                ColorSequenceKeypoint.new(0.5, Color3.fromHex'#FFC300'),
                                ColorSequenceKeypoint.new(1, Color3.fromHex'#000000'),
                            },
                        }),
                    }),
                }),
                aw,
                ay,
                az,
                am('Frame', {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Name = 'Main',
                    Visible = false,
                    ZIndex = 97,
                }, {
                    am('UICorner', {
                        CornerRadius = UDim.new(0, au.UICorner),
                    }),
                    au.UIElements.SideBarContainer,
                    au.UIElements.MainBar,
                    aB,
                    b,
                    am('Frame', {
                        Size = UDim2.new(1, 0, 0, au.Topbar.Height),
                        BackgroundTransparency = 1,
                        BackgroundColor3 = Color3.fromRGB(50, 50, 50),
                        Name = 'Topbar',
                    }, {
                        aC,
                        am('Frame', {
                            AutomaticSize = 'X',
                            Size = UDim2.new(0, 0, 1, 0),
                            BackgroundTransparency = 1,
                            Name = 'Left',
                        }, {
                            am('UIListLayout', {
                                Padding = UDim.new(0, au.UIPadding + 4),
                                SortOrder = 'LayoutOrder',
                                FillDirection = 'Horizontal',
                                VerticalAlignment = 'Center',
                            }),
                            am('Frame', {
                                AutomaticSize = 'XY',
                                BackgroundTransparency = 1,
                                LayoutOrder = 1,
                            }, {
                                am('UIListLayout', {
                                    Padding = UDim.new(0, 8),
                                    FillDirection = 'Horizontal',
                                    VerticalAlignment = 'Center',
                                }),
                                am('TextLabel', {
                                    Text = "<font color='#FFD700'><b>INTIHUB</b></font>",
                                    TextSize = 16,
                                    FontFace = Font.new(al.Font, Enum.FontWeight.Bold),
                                    TextColor3 = Color3.fromHex'#FFD700',
                                    BackgroundTransparency = 1,
                                    AutomaticSize = 'XY',
                                    LayoutOrder = 1,
                                    RichText = true,
                                    Name = 'BrandingLogo',
                                }),
                                am('Frame', {
                                    Size = UDim2.new(0, 1, 0, 20),
                                    BackgroundColor3 = Color3.new(1, 1, 1),
                                    BackgroundTransparency = 0.8,
                                    BorderSizePixel = 0,
                                    LayoutOrder = 2,
                                }),
                            }),
                            am('Frame', {
                                AutomaticSize = 'XY',
                                BackgroundTransparency = 1,
                                Name = 'Title',
                                Size = UDim2.new(0, 0, 1, 0),
                                LayoutOrder = 2,
                            }, {
                                am('UIListLayout', {
                                    Padding = UDim.new(0, 0),
                                    SortOrder = 'LayoutOrder',
                                    FillDirection = 'Vertical',
                                    VerticalAlignment = 'Center',
                                }),
                                l,
                                j,
                            }),
                            am('UIPadding', {
                                PaddingLeft = UDim.new(0, 12),
                            }),
                        }),
                        am('ScrollingFrame', {
                            Name = 'Center',
                            BackgroundTransparency = 1,
                            AutomaticSize = 'Y',
                            ScrollBarThickness = 0,
                            ScrollingDirection = 'X',
                            AutomaticCanvasSize = 'X',
                            CanvasSize = UDim2.new(0, 0, 0, 0),
                            Size = UDim2.new(0, 0, 1, 0),
                            AnchorPoint = Vector2.new(0, 0.5),
                            Position = UDim2.new(0, 0, 0.5, 0),
                            Visible = false,
                        }, {
                            am('UIListLayout', {
                                FillDirection = 'Horizontal',
                                VerticalAlignment = 'Center',
                                HorizontalAlignment = 'Left',
                                Padding = UDim.new(0, au.UIPadding / 2),
                            }),
                        }),
                        am('Frame', {
                            AutomaticSize = 'XY',
                            BackgroundTransparency = 1,
                            Position = UDim2.new(1, 0, 0.5, 0),
                            AnchorPoint = Vector2.new(1, 0.5),
                            Name = 'Right',
                        }, {
                            am('UIListLayout', {
                                Padding = UDim.new(0, au.Topbar.ButtonsType == 'Default' and 9 or 0),
                                FillDirection = 'Horizontal',
                                SortOrder = 'LayoutOrder',
                            }),
                        }),
                        am('UIPadding', {
                            PaddingTop = UDim.new(0, au.UIPadding),
                            PaddingLeft = UDim.new(0, au.Topbar.ButtonsType == 'Default' and au.UIPadding or au.UIPadding - 2),
                            PaddingRight = UDim.new(0, 8),
                            PaddingBottom = UDim.new(0, au.UIPadding),
                        }),
                    }),
                }),
            })

            al.AddSignal(au.UIElements.Main.Main.Topbar.Left:GetPropertyChangedSignal'AbsoluteSize', function(
            )
                local n = 0
                local o = au.UIElements.Main.Main.Topbar.Right.UIListLayout.AbsoluteContentSize.X / at.IntiHub.UIScale

                n = au.UIElements.Main.Main.Topbar.Left.AbsoluteSize.X / at.IntiHub.UIScale
                n = au.UIElements.Main.Main.Topbar.Left.AbsoluteSize.X / at.IntiHub.UIScale
                au.UIElements.Main.Main.Topbar.Center.Position = UDim2.new(0, n + (au.UIPadding / at.IntiHub.UIScale), 0.5, 0)
                au.UIElements.Main.Main.Topbar.Center.Size = UDim2.new(1, -n - o - ((au.UIPadding * 2) / at.IntiHub.UIScale), 1, 0)
            end)

            function au.CreateTopbarButton(n, o, p, q, r, s, t, u)
                local v = al.Image(p, p, 0, au.Folder, 'WindowTopbarIcon', au.Topbar.ButtonsType == 'Default' and true or false, s, 'WindowTopbarButtonIcon')

                v.Size = au.Topbar.ButtonsType == 'Default' and UDim2.new(0, u or au.TopBarButtonIconSize, 0, u or au.TopBarButtonIconSize) or UDim2.new(0, 0, 0, 0)
                v.AnchorPoint = Vector2.new(0.5, 0.5)
                v.Position = UDim2.new(0.5, 0, 0.5, 0)
                v.ImageLabel.ImageTransparency = au.Topbar.ButtonsType == 'Default' and 0 or 1

                if au.Topbar.ButtonsType ~= 'Default' then
                    v.ImageLabel.ImageColor3 = al.GetTextColorForHSB(t)
                end

                local w = al.NewRoundFrame(au.Topbar.ButtonsType == 'Default' and au.UICorner - (au.UIPadding / 2) or 999, 'Squircle', {
                    Size = au.Topbar.ButtonsType == 'Default' and UDim2.new(0, au.Topbar.Height - 16, 0, au.Topbar.Height - 16) or UDim2.new(0, 14, 0, 14),
                    LayoutOrder = r or 999,
                    ZIndex = 9999,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    ImageColor3 = au.Topbar.ButtonsType ~= 'Default' and (t or Color3.fromHex'#ff3030') or nil,
                    ThemeTag = au.Topbar.ButtonsType == 'Default' and {
                        ImageColor3 = 'Text',
                    } or nil,
                    ImageTransparency = au.Topbar.ButtonsType == 'Default' and 1 or 0,
                }, {
                    al.NewRoundFrame(au.Topbar.ButtonsType == 'Default' and au.UICorner - (au.UIPadding / 2) or 999, 'Glass-1', {
                        Size = UDim2.new(1, 0, 1, 0),
                        ThemeTag = {
                            ImageColor3 = 'Outline',
                        },
                        ImageTransparency = au.Topbar.ButtonsType == 'Default' and 1 or 0.5,
                        Name = 'Outline',
                    }),
                    v,
                    am('UIScale', {Scale = 1}),
                }, true)

                am('Frame', {
                    Size = au.Topbar.ButtonsType ~= 'Default' and UDim2.new(0, 24, 0, 24) or UDim2.new(0, au.Topbar.Height - 16, 0, au.Topbar.Height - 16),
                    BackgroundTransparency = 1,
                    Parent = au.UIElements.Main.Main.Topbar.Right,
                    LayoutOrder = r or 999,
                }, {w})

                au.TopBarButtons[100 - r] = {
                    Name = o,
                    Object = w,
                }

                al.AddSignal(w.MouseButton1Click, function()
                    if q then
                        q()
                    end
                end)
                al.AddSignal(w.MouseEnter, function()
                    if au.Topbar.ButtonsType == 'Default' then
                        an(w, 0.15, {ImageTransparency = 0.93}):Play()
                        an(w.Outline, 0.15, {ImageTransparency = 0.75}):Play()
                    else
                        an(v.ImageLabel, 0.1, {ImageTransparency = 0}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                        an(v, 0.1, {
                            Size = UDim2.new(0, u or au.TopBarButtonIconSize, 0, u or au.TopBarButtonIconSize),
                        }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                    end
                end)
                al.AddSignal(w.MouseButton1Down, function()
                    an(w.UIScale, 0.2, {Scale = 0.9}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                end)
                al.AddSignal(w.MouseLeave, function()
                    if au.Topbar.ButtonsType == 'Default' then
                        an(w, 0.1, {ImageTransparency = 1}):Play()
                        an(w.Outline, 0.1, {ImageTransparency = 1}):Play()
                    else
                        an(v.ImageLabel, 0.1, {ImageTransparency = 1}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                        an(v, 0.1, {
                            Size = UDim2.new(0, 0, 0, 0),
                        }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                    end
                end)
                al.AddSignal(w.InputEnded, function()
                    an(w.UIScale, 0.2, {Scale = 1}, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut):Play()
                end)

                return w
            end
            function au.Topbar.Button(n, o)
                return au:CreateTopbarButton(o.Name, o.Icon, o.Callback, o.LayoutOrder or 0, o.IconThemed, o.Color, o.IconSize)
            end

            local n = al.Drag(au.UIElements.Main, {
                au.UIElements.Main.Main.Topbar,
                i.Frame,
            }, function(n, o)
                if not au.Closed then
                    if n and o == i.Frame then
                        an(i, 0.1, {ImageTransparency = 0.35}):Play()
                    else
                        an(i, 0.2, {ImageTransparency = 0.8}):Play()
                    end

                    au.Position = au.UIElements.Main.Position
                    au.Dragging = n
                end
            end)

            if not c and au.Background and typeof(au.Background) == 'table' then
                local o = am'UIGradient'

                for p, q in next, au.Background do
                    o[p] = q
                end

                au.UIElements.BackgroundGradient = al.NewRoundFrame(au.UICorner, 'Squircle', {
                    Size = UDim2.new(1, 0, 1, 0),
                    Parent = au.UIElements.Main.Background,
                    ImageTransparency = au.Transparent and at.IntiHub.TransparencyValue or 0,
                }, {o})
            end

            au.OpenButtonMain = a.load'z'.New(au)

            task.spawn(function()
                if au.Icon then
                    local o = am('Frame', {
                        Size = UDim2.new(0, 22, 0, 22),
                        LayoutOrder = 1,
                        BackgroundTransparency = 1,
                        Parent = au.UIElements.Main.Main.Topbar.Left,
                    })
                    local p = au.Icon

                    if string.find(tostring(p), 'http') then
                        p = al.GetAsset(p, au.Folder, 'icon', 'Logo')
                    end

                    local q = al.Image(p, 'WindowIcon', au.IconRadius, au.Folder, 'icon', au.IconThemed, 'Text')

                    q.Parent = o
                    q.Size = UDim2.new(0, au.IconSize, 0, au.IconSize)
                    q.Position = UDim2.new(0.5, 0, 0.5, 0)
                    q.AnchorPoint = Vector2.new(0.5, 0.5)

                    au.OpenButtonMain:SetIcon(au.Icon)
                else
                    au.OpenButtonMain:SetIcon(au.Icon)
                end
            end)

            function au.SetToggleKey(o, p)
                au.ToggleKey = p
            end
            function au.SetTitle(o, p)
                au.Title = p
                l.Text = p
            end
            function au.SetAuthor(o, p)
                au.Author = p

                if not j then
                    j = createAuthor(au.Author)
                end

                j.Text = p
            end
            function au.SetSize(o, p)
                if typeof(p) == 'UDim2' then
                    au.Size = p

                    an(au.UIElements.Main, 0.08, {Size = p}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                end
            end
            function au.SetBackgroundImage(o, p)
                au.UIElements.Main.Background.ImageLabel.Image = p
            end
            function au.SetBackgroundImageTransparency(o, p)
                if d and d:IsA'ImageLabel' then
                    d.ImageTransparency = math.floor(p * 10 + 0.5) / 10
                end

                au.BackgroundImageTransparency = math.floor(p * 10 + 0.5) / 10
            end
            function au.SetBackgroundTransparency(o, p)
                local q = math.floor(tonumber(p) * 10 + 0.5) / 10

                at.IntiHub.TransparencyValue = q

                au:ToggleTransparency(q > 0)
            end

            local o
            local p

            al.Icon'minimize'
            al.Icon'maximize'
            au:CreateTopbarButton('Fullscreen', au.Topbar.ButtonsType == 'Mac' and 'rbxassetid://127426072704909' or 'maximize', function(
            )
                au:ToggleFullscreen()
            end, (au.Topbar.ButtonsType == 'Default' and 998 or 999), true, Color3.fromHex'#60C762', au.Topbar.ButtonsType == 'Mac' and 9 or nil)

            function au.ToggleFullscreen(q)
                local r = au.IsFullscreen

                n:Set(r)

                if not r then
                    o = au.UIElements.Main.Position
                    p = au.UIElements.Main.Size
                    au.CanResize = false
                else
                    if au.Resizable then
                        au.CanResize = true
                    end
                end

                an(au.UIElements.Main, 0.45, {
                    Size = r and p or UDim2.new(1, -20, 1, -72),
                }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                an(au.UIElements.Main, 0.45, {
                    Position = r and o or UDim2.new(0.5, 0, 0.5, 26),
                }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()

                au.IsFullscreen = not r
            end

            au:CreateTopbarButton('Minimize', 'minus', function()
                au:Close()
            end, (au.Topbar.ButtonsType == 'Default' and 997 or 998), nil, Color3.fromHex'#F4C948')

            function au.OnOpen(q, r)
                au.OnOpenCallback = r
            end
            function au.OnClose(q, r)
                au.OnCloseCallback = r
            end
            function au.OnDestroy(q, r)
                au.OnDestroyCallback = r
            end

            if at.IntiHub.UseAcrylic then
                au.AcrylicPaint.AddParent(au.UIElements.Main)
            end

            function au.SetIconSize(q, r)
                local s

                if typeof(r) == 'number' then
                    s = UDim2.new(0, r, 0, r)
                    au.IconSize = r
                elseif typeof(r) == 'UDim2' then
                    s = r
                    au.IconSize = r.X.Offset
                end
                if k then
                    k.Size = s
                end
            end
            function au.Open(q)
                task.spawn(function()
                    if au.OnOpenCallback then
                        task.spawn(function()
                            al.SafeCallback(au.OnOpenCallback)
                        end)
                    end

                    task.wait(0.06)

                    au.Closed = false

                    an(au.UIElements.Main.Background, 0.2, {
                        ImageTransparency = au.Transparent and at.IntiHub.TransparencyValue or 0,
                    }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()

                    if au.UIElements.BackgroundGradient then
                        an(au.UIElements.BackgroundGradient, 0.2, {ImageTransparency = 0}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                    end

                    an(au.UIElements.Main.Background, 0.4, {
                        Size = UDim2.new(1, 0, 1, 0),
                    }, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out):Play()

                    if d then
                        if d:IsA'VideoFrame' then
                            d.Visible = true
                        else
                            an(d, 0.2, {
                                ImageTransparency = au.BackgroundImageTransparency,
                            }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                        end
                    end
                    if au.OpenButtonMain and au.IsOpenButtonEnabled then
                        au.OpenButtonMain:Visible(false)
                    end

                    an(aA, 0.25, {
                        ImageTransparency = au.ShadowTransparency,
                    }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()

                    if UIStroke then
                        an(UIStroke, 0.25, {Transparency = 0.8}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                    end

                    task.spawn(function()
                        task.wait(0.3)
                        an(i, 0.45, {
                            Size = UDim2.new(0, au.DragFrameSize, 0, 4),
                            ImageTransparency = 0.8,
                        }, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out):Play()
                        n:Set(true)
                        task.wait(0.45)

                        if au.Resizable then
                            an(ax.ImageLabel, 0.45, {ImageTransparency = 0.8}, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out):Play()

                            au.CanResize = true
                        end
                    end)

                    au.CanDropdown = true
                    au.UIElements.Main.Visible = true

                    task.spawn(function()
                        task.wait(0.05)

                        au.UIElements.Main:WaitForChild'Main'.Visible = true

                        at.IntiHub:ToggleAcrylic(true)
                    end)
                end)
            end
            function au.Close(q)
                local r = {}

                if au.OnCloseCallback then
                    task.spawn(function()
                        al.SafeCallback(au.OnCloseCallback)
                    end)
                end

                at.IntiHub:ToggleAcrylic(false)

                au.UIElements.Main:WaitForChild'Main'.Visible = false
                au.CanDropdown = false
                au.Closed = true

                an(au.UIElements.Main.Background, 0.32, {ImageTransparency = 1}, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut):Play()

                if au.UIElements.BackgroundGradient then
                    an(au.UIElements.BackgroundGradient, 0.32, {ImageTransparency = 1}, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut):Play()
                end

                an(au.UIElements.Main.Background, 0.4, {
                    Size = UDim2.new(1, 0, 1, -240),
                }, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut):Play()

                if d then
                    if d:IsA'VideoFrame' then
                        d.Visible = false
                    else
                        an(d, 0.3, {ImageTransparency = 1}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                    end
                end

                an(aA, 0.25, {ImageTransparency = 1}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()

                if UIStroke then
                    an(UIStroke, 0.25, {Transparency = 1}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                end

                an(i, 0.3, {
                    Size = UDim2.new(0, 0, 0, 4),
                    ImageTransparency = 1,
                }, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut):Play()
                an(ax.ImageLabel, 0.3, {ImageTransparency = 1}, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out):Play()
                n:Set(false)

                au.CanResize = false

                task.spawn(function()
                    task.wait(0.4)

                    au.UIElements.Main.Visible = false

                    if au.OpenButtonMain and not au.Destroyed and not au.IsPC and au.IsOpenButtonEnabled then
                        au.OpenButtonMain:Visible(true)
                    end
                end)

                function r.Destroy(s)
                    task.spawn(function()
                        if au.OnDestroyCallback then
                            task.spawn(function()
                                al.SafeCallback(au.OnDestroyCallback)
                            end)
                        end
                        if au.AcrylicPaint and au.AcrylicPaint.Model then
                            au.AcrylicPaint.Model:Destroy()
                        end

                        au.Destroyed = true

                        task.wait(0.4)
                        at.IntiHub.ScreenGui:Destroy()
                        at.IntiHub.NotificationGui:Destroy()
                        at.IntiHub.DropdownGui:Destroy()
                        at.IntiHub.TooltipGui:Destroy()
                        al.DisconnectAll()

                        return
                    end)
                end

                return r
            end
            function au.Destroy(q)
                return au:Close():Destroy()
            end
            function au.Toggle(q)
                if au.Closed then
                    au:Open()
                else
                    au:Close()
                end
            end
            function au.ToggleTransparency(q, r)
                au.Transparent = r
                at.IntiHub.Transparent = r
                au.UIElements.Main.Background.ImageTransparency = r and at.IntiHub.TransparencyValue or 0
            end
            function au.LockAll(q)
                for r, s in next, au.AllElements do
                    if s.Lock then
                        s:Lock()
                    end
                end
            end
            function au.UnlockAll(q)
                for r, s in next, au.AllElements do
                    if s.Unlock then
                        s:Unlock()
                    end
                end
            end
            function au.GetLocked(q)
                local r = {}

                for s, t in next, au.AllElements do
                    if t.Locked then
                        table.insert(r, t)
                    end
                end

                return r
            end
            function au.GetUnlocked(q)
                local r = {}

                for s, t in next, au.AllElements do
                    if t.Locked == false then
                        table.insert(r, t)
                    end
                end

                return r
            end
            function au.GetUIScale(q, r)
                return at.IntiHub.UIScale
            end
            function au.SetUIScale(q, r)
                at.IntiHub.UIScale = r

                an(at.IntiHub.UIScaleObj, 0.2, {Scale = r}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()

                return au
            end
            function au.SetToTheCenter(q)
                an(au.UIElements.Main, 0.45, {
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()

                return au
            end
            function au.SetCurrentConfig(q, r)
                au.CurrentConfig = r
            end

            do
                local q = 40
                local r = aj.ViewportSize
                local s = au.UIElements.Main.AbsoluteSize

                if not au.IsFullscreen and au.AutoScale then
                    local t = r.X - (q * 2)
                    local u = r.Y - (q * 2)
                    local v = t / s.X
                    local w = u / s.Y
                    local x = math.min(v, w)
                    local y = 0.3
                    local z = 1
                    local A = math.clamp(x, y, z)
                    local B = au:GetUIScale() or 1
                    local C = 0.05

                    if math.abs(A - B) > C then
                        au:SetUIScale(A)
                    end
                end
            end

            if au.OpenButtonMain and au.OpenButtonMain.Button then
                al.AddSignal(au.OpenButtonMain.Button.TextButton.MouseButton1Click, function(
                )
                    au:Open()
                end)
            end

            al.AddSignal(ae.InputBegan, function(q, r)
                if r then
                    return
                end
                if au.ToggleKey then
                    if q.KeyCode == au.ToggleKey then
                        au:Toggle()
                    end
                end
            end)
            task.spawn(function()
                au:Open()
            end)

            function au.EditOpenButton(q, r)
                return au.OpenButtonMain:Edit(r)
            end

            if au.OpenButton and typeof(au.OpenButton) == 'table' then
                au:EditOpenButton(au.OpenButton)
            end

            local q = a.load'W'
            local r = a.load'X'
            local s = q.Init(au, at.IntiHub, at.IntiHub.TooltipGui)

            s:OnChange(function(t)
                au.CurrentTab = t
            end)

            au.TabModule = s

            function au.Tab(t, u)
                u.Parent = au.UIElements.SideBar.Frame

                return s.New(u, at.IntiHub.UIScale)
            end
            function au.SelectTab(t, u)
                s:SelectTab(u)
            end
            function au.Section(t, u)
                return r.New(u, au.UIElements.SideBar.Frame, au.Folder, at.IntiHub.UIScale, au)
            end
            function au.IsResizable(t, u)
                au.Resizable = u
                au.CanResize = u
            end
            function au.SetPanelBackground(t, u)
                if typeof(u) == 'boolean' then
                    au.HidePanelBackground = u
                    au.UIElements.MainBar.Background.Visible = u

                    if s then
                        for v, w in next, s.Containers do
                            w.ScrollingFrame.UIPadding.PaddingTop = UDim.new(0, au.HidePanelBackground and 20 or 10)
                            w.ScrollingFrame.UIPadding.PaddingLeft = UDim.new(0, au.HidePanelBackground and 20 or 10)
                            w.ScrollingFrame.UIPadding.PaddingRight = UDim.new(0, au.HidePanelBackground and 20 or 10)
                            w.ScrollingFrame.UIPadding.PaddingBottom = UDim.new(0, au.HidePanelBackground and 20 or 10)
                        end
                    end
                end
            end
            function au.Divider(t)
                local u = am('Frame', {
                    Size = UDim2.new(1, 0, 0, 1),
                    Position = UDim2.new(0.5, 0, 0, 0),
                    AnchorPoint = Vector2.new(0.5, 0),
                    BackgroundTransparency = 0.9,
                    ThemeTag = {
                        BackgroundColor3 = 'Text',
                    },
                })
                local v = am('Frame', {
                    Parent = au.UIElements.SideBar.Frame,
                    Size = UDim2.new(1, -7, 0, 5),
                    BackgroundTransparency = 1,
                }, {u})

                return v
            end

            local t = a.load'n'.Init(au, at.IntiHub, nil)

            function au.Dialog(u, v)
                local w = {
                    Title = v.Title or 'Dialog',
                    Width = v.Width or 320,
                    Content = v.Content,
                    Buttons = v.Buttons or {},
                    TextPadding = 14,
                }
                local x = t.Create(false)

                x.UIElements.Main.Size = UDim2.new(0, w.Width, 0, 0)

                local y = am('Frame', {
                    Size = UDim2.new(1, 0, 1, 0),
                    AutomaticSize = 'Y',
                    BackgroundTransparency = 1,
                    Parent = x.UIElements.Main,
                }, {
                    am('UIListLayout', {
                        FillDirection = 'Vertical',
                        Padding = UDim.new(0, x.UIPadding),
                    }),
                })
                local z = am('Frame', {
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = 'Y',
                    BackgroundTransparency = 1,
                    Parent = y,
                }, {
                    am('UIListLayout', {
                        FillDirection = 'Horizontal',
                        Padding = UDim.new(0, x.UIPadding),
                        VerticalAlignment = 'Center',
                    }),
                    am('UIPadding', {
                        PaddingTop = UDim.new(0, w.TextPadding / 2),
                        PaddingLeft = UDim.new(0, w.TextPadding / 2),
                        PaddingRight = UDim.new(0, w.TextPadding / 2),
                    }),
                })
                local A

                if v.Icon then
                    A = al.Image(v.Icon, w.Title .. ':' .. v.Icon, 0, au, 'Dialog', true, v.IconThemed)
                    A.Size = UDim2.new(0, 22, 0, 22)
                    A.Parent = z
                end

                x.UIElements.UIListLayout = am('UIListLayout', {
                    Padding = UDim.new(0, 12),
                    FillDirection = 'Vertical',
                    HorizontalAlignment = 'Left',
                    VerticalFlex = 'SpaceBetween',
                    Parent = x.UIElements.Main,
                })

                am('UISizeConstraint', {
                    MinSize = Vector2.new(180, 20),
                    MaxSize = Vector2.new(400, math.huge),
                    Parent = x.UIElements.Main,
                })

                x.UIElements.Title = am('TextLabel', {
                    Text = w.Title,
                    TextSize = 20,
                    FontFace = Font.new(al.Font, Enum.FontWeight.SemiBold),
                    TextXAlignment = 'Left',
                    TextWrapped = true,
                    RichText = true,
                    Size = UDim2.new(1, A and -26 - x.UIPadding or 0, 0, 0),
                    AutomaticSize = 'Y',
                    ThemeTag = {
                        TextColor3 = 'Text',
                    },
                    BackgroundTransparency = 1,
                    Parent = z,
                })

                if w.Content then
                    am('TextLabel', {
                        Text = w.Content,
                        TextSize = 18,
                        TextTransparency = 0.4,
                        TextWrapped = true,
                        RichText = true,
                        FontFace = Font.new(al.Font, Enum.FontWeight.Medium),
                        TextXAlignment = 'Left',
                        Size = UDim2.new(1, 0, 0, 0),
                        AutomaticSize = 'Y',
                        LayoutOrder = 2,
                        ThemeTag = {
                            TextColor3 = 'Text',
                        },
                        BackgroundTransparency = 1,
                        Parent = y,
                    }, {
                        am('UIPadding', {
                            PaddingLeft = UDim.new(0, w.TextPadding / 2),
                            PaddingRight = UDim.new(0, w.TextPadding / 2),
                            PaddingBottom = UDim.new(0, w.TextPadding / 2),
                        }),
                    })
                end

                local B = am('UIListLayout', {
                    Padding = UDim.new(0, 6),
                    FillDirection = 'Horizontal',
                    HorizontalAlignment = 'Center',
                    HorizontalFlex = 'Fill',
                })
                local C = am('Frame', {
                    Size = UDim2.new(1, 0, 0, 40),
                    AutomaticSize = 'None',
                    BackgroundTransparency = 1,
                    Parent = x.UIElements.Main,
                    LayoutOrder = 4,
                }, {B})
                local D = {}

                for E, F in next, w.Buttons do
                    local G = ap(F.Title, F.Icon, F.Callback, F.Variant, C, x, true)

                    table.insert(D, G)

                    G.Size = UDim2.new(1, 0, 1, 0)
                end

                x:Open()

                return x
            end

            local u = false

            au:CreateTopbarButton('Close', 'x', function()
                if not u then
                    if not au.IgnoreAlerts then
                        u = true

                        au:SetToTheCenter()
                        au:Dialog{
                            Title = 'Close Window',
                            Content = 
[[Do you want to close this window? You will not be able to open it again.]],
                            Buttons = {
                                {
                                    Title = 'Cancel',
                                    Callback = function()
                                        u = false
                                    end,
                                    Variant = 'Secondary',
                                },
                                {
                                    Title = 'Close Window',
                                    Callback = function()
                                        u = false

                                        au:Destroy()
                                    end,
                                    Variant = 'Primary',
                                },
                            },
                        }
                    else
                        au:Destroy()
                    end
                end
            end, (au.Topbar.ButtonsType == 'Default' and 999 or 997), nil, Color3.fromHex'#F4695F')

            function au.Tag(v, w)
                if au.UIElements.Main.Main.Topbar.Center.Visible == false then
                    au.UIElements.Main.Main.Topbar.Center.Visible = true
                end

                w.Window = au

                return ar:New(w, au.UIElements.Main.Main.Topbar.Center)
            end

            local v = function(v)
                if au.CanResize then
                    isResizing = true
                    ay.Active = true
                    initialSize = au.UIElements.Main.Size
                    initialInputPosition = v.Position

                    an(ax.ImageLabel, 0.1, {ImageTransparency = 0.35}):Play()
                    al.AddSignal(v.Changed, function()
                        if v.UserInputState == Enum.UserInputState.End then
                            isResizing = false
                            ay.Active = false

                            an(ax.ImageLabel, 0.17, {ImageTransparency = 0.8}):Play()
                        end
                    end)
                end
            end

            al.AddSignal(ax.InputBegan, function(w)
                if w.UserInputType == Enum.UserInputType.MouseButton1 or w.UserInputType == Enum.UserInputType.Touch then
                    if au.CanResize then
                        v(w)
                    end
                end
            end)
            al.AddSignal(ae.InputChanged, function(w)
                if w.UserInputType == Enum.UserInputType.MouseMovement or w.UserInputType == Enum.UserInputType.Touch then
                    if isResizing and au.CanResize then
                        local x = w.Position - initialInputPosition
                        local y = UDim2.new(0, initialSize.X.Offset + x.X * 2, 0, initialSize.Y.Offset + x.Y * 2)

                        y = UDim2.new(y.X.Scale, math.clamp(y.X.Offset, au.MinSize.X, au.MaxSize.X), y.Y.Scale, math.clamp(y.Y.Offset, au.MinSize.Y, au.MaxSize.Y))

                        an(au.UIElements.Main, 0.08, {Size = y}, Enum.EasingStyle.Quad, Enum.EasingDirection.Out):Play()

                        au.Size = y
                    end
                end
            end)
            al.AddSignal(ax.MouseEnter, function()
                if not isResizing then
                    an(ax.ImageLabel, 0.1, {ImageTransparency = 0.35}):Play()
                end
            end)
            al.AddSignal(ax.MouseLeave, function()
                if not isResizing then
                    an(ax.ImageLabel, 0.17, {ImageTransparency = 0.8}):Play()
                end
            end)

            local w = 0
            local x = 0.4
            local y
            local z = 0

            function onDoubleClick()
                au:SetToTheCenter()
            end

            al.AddSignal(i.Frame.MouseButton1Up, function()
                local A = tick()
                local B = au.Position

                z = z + 1

                if z == 1 then
                    w = A
                    y = B

                    task.spawn(function()
                        task.wait(x)

                        if z == 1 then
                            z = 0
                            y = nil
                        end
                    end)
                elseif z == 2 then
                    if A - w <= x and B == y then
                        onDoubleClick()
                    end

                    z = 0
                    y = nil
                    w = 0
                else
                    z = 1
                    w = A
                    y = B
                end
            end)

            if not au.HideSearchBar then
                local A = a.load'Z'
                local B = false
                local C = ao('Search', 'search', au.UIElements.SideBarContainer, true)

                C.Size = UDim2.new(1, -au.UIPadding / 2, 0, 39)
                C.Position = UDim2.new(0, au.UIPadding / 2, 0, 0)

                al.AddSignal(C.MouseButton1Click, function()
                    if B then
                        return
                    end

                    A.new(au.TabModule, au.UIElements.Main, function()
                        B = false

                        if au.Resizable then
                            au.CanResize = true
                        end

                        an(az, 0.1, {ImageTransparency = 1}):Play()

                        az.Active = false
                    end)
                    an(az, 0.1, {ImageTransparency = 0.65}):Play()

                    az.Active = true
                    B = true
                    au.CanResize = false
                end)
            end

            function au.DisableTopbarButtons(A, B)
                for C, D in next, B do
                    for E, F in next, au.TopBarButtons do
                        if F.Name == D then
                            F.Object.Visible = false
                        end
                    end
                end
            end

            if au.OpenButtonMain and au.OpenButtonMain.Button then
                task.spawn(function()
                    local A = au.OpenButtonMain.Button:FindFirstChild('Glow', true)

                    while task.wait(1.5) do
                        if A then
                            an(A, 0.75, {ImageTransparency = 0.4}):Play()
                            task.wait(0.75)
                            an(A, 0.75, {ImageTransparency = 0.8}):Play()
                        end
                    end
                end)
            end

            task.spawn(function()
                local A = au.UIElements.Main:FindFirstChild('AnimatedGradient1', true)
                local B = au.UIElements.Main:FindFirstChild('AnimationOverlay', true)
                local C = B and B:FindFirstChild('AnimatedGradient2', true)
                local D = 0
                local E

                E = af.RenderStepped:Connect(function(F)
                    if au.Destroyed or not au.UIElements.Main then
                        if E then
                            E:Disconnect()
                        end

                        return
                    end

                    D = D + (F * 60)

                    if A then
                        A.Rotation = D % 360
                    end
                    if C then
                        C.Rotation = (360 - D) % 360
                    end
                end)
            end)

            return au
        end
    end
    function a.aa()
        local aa = (cloneref or clonereference or function(aa)
            return aa
        end)
        local ae = aa(game:GetService'RunService')
        local af = aa(game:GetService'Players')
        local ah = aa(game:GetService'Stats')
        local aj = a.load'c'
        local ak = aj.New
        local al = aj.Tween
        local am = {}

        function am.New(an)
            local ao = an.IntiHub
            local ap = an.Window
            local aq = ak('Frame', {
                Name = 'StatusBar',
                Size = UDim2.new(0, 0, 0, 45),
                Position = UDim2.new(0.5, 0, 0, 10),
                AnchorPoint = Vector2.new(0.5, 0),
                BackgroundColor3 = Color3.fromHex'#0F0D00',
                BackgroundTransparency = 0.2,
                AutomaticSize = 'X',
                Visible = true,
                Parent = ao.ScreenGui,
            }, {
                ak('UICorner', {
                    CornerRadius = UDim.new(0, 10),
                }),
                ak('UIStroke', {
                    Thickness = 1.5,
                    ThemeTag = {
                        Color = 'Accent',
                    },
                    Transparency = 0.5,
                }),
                ak('UIListLayout', {
                    FillDirection = 'Horizontal',
                    Padding = UDim.new(0, 25),
                    VerticalAlignment = 'Center',
                    SortOrder = 'LayoutOrder',
                }),
                ak('UIPadding', {
                    PaddingLeft = UDim.new(0, 20),
                    PaddingRight = UDim.new(0, 20),
                }),
            })
            local ar = function(ar, as, at, au)
                local av = ak('Frame', {
                    Size = UDim2.new(0, 0, 1, 0),
                    AutomaticSize = 'X',
                    BackgroundTransparency = 1,
                    LayoutOrder = au,
                }, {
                    ak('UIListLayout', {
                        FillDirection = 'Horizontal',
                        Padding = UDim.new(0, 10),
                        VerticalAlignment = 'Center',
                    }),
                    ak('Frame', {
                        Size = UDim2.new(0, 30, 0, 30),
                        BackgroundColor3 = Color3.fromHex'#1A1A1A',
                        ThemeTag = {
                            BackgroundColor3 = 'Accent',
                        },
                    }, {
                        ak('UICorner', {
                            CornerRadius = UDim.new(0, 6),
                        }),
                        ak('ImageLabel', {
                            Image = aj.Icon(ar) and aj.Icon(ar)[1] or '',
                            ImageRectOffset = aj.Icon(ar) and aj.Icon(ar)[2].ImageRectPosition or Vector2.new(0, 0),
                            ImageRectSize = aj.Icon(ar) and aj.Icon(ar)[2].ImageRectSize or Vector2.new(0, 0),
                            Size = UDim2.new(0, 20, 0, 20),
                            Position = UDim2.new(0.5, 0, 0.5, 0),
                            AnchorPoint = Vector2.new(0.5, 0.5),
                            BackgroundTransparency = 1,
                            ImageColor3 = Color3.fromHex'#000000',
                        }),
                    }),
                    ak('Frame', {
                        Size = UDim2.new(0, 0, 0, 0),
                        AutomaticSize = 'XY',
                        BackgroundTransparency = 1,
                    }, {
                        ak('UIListLayout', {
                            FillDirection = 'Vertical',
                            Padding = UDim.new(0, 2),
                        }),
                        ak('TextLabel', {
                            Text = as:upper(),
                            TextSize = 11,
                            FontFace = Font.new(aj.Font, Enum.FontWeight.Bold),
                            TextColor3 = Color3.fromHex'#FFC300',
                            ThemeTag = {
                                TextColor3 = 'Accent',
                            },
                            TextTransparency = 0.4,
                            AutomaticSize = 'XY',
                            BackgroundTransparency = 1,
                        }),
                        at,
                    }),
                })

                av.Parent = aq

                return at
            end
            local as = ap.Icon or 'rbxassetid://0'

            if typeof(as) == 'string' and string.find(as, 'http') then
                as = aj.GetAsset(as, ap.Folder, 'icon', 'StatusBarLogo')
            end

            local at = ak('Frame', {
                Size = UDim2.new(0, 0, 1, 0),
                AutomaticSize = 'X',
                BackgroundTransparency = 1,
                LayoutOrder = 1,
            }, {
                ak('UIListLayout', {
                    FillDirection = 'Horizontal',
                    Padding = UDim.new(0, 10),
                    VerticalAlignment = 'Center',
                }),
                ak('Frame', {
                    Size = UDim2.new(0, 30, 0, 30),
                    BackgroundColor3 = Color3.fromHex'#FFC300',
                    ThemeTag = {
                        BackgroundColor3 = 'Accent',
                    },
                }, {
                    ak('UICorner', {
                        CornerRadius = UDim.new(0, 4),
                    }),
                    ak('ImageLabel', {
                        Image = as,
                        Size = UDim2.new(0, 22, 0, 22),
                        Position = UDim2.new(0.5, 0, 0.5, 0),
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        BackgroundTransparency = 1,
                        ImageColor3 = Color3.new(0, 0, 0),
                    }),
                }),
                ak('TextLabel', {
                    Text = ap.Title or 'INTIHUB',
                    TextSize = 16,
                    FontFace = Font.new(aj.Font, Enum.FontWeight.Bold),
                    TextColor3 = Color3.fromHex'#FFC300',
                    ThemeTag = {
                        TextColor3 = 'Accent',
                    },
                    AutomaticSize = 'XY',
                    BackgroundTransparency = 1,
                }),
            })

            at.Parent = aq

            ak('Frame', {
                Size = UDim2.new(0, 1, 0, 25),
                BackgroundColor3 = Color3.new(1, 1, 1),
                BackgroundTransparency = 0.8,
                Parent = aq,
                LayoutOrder = 2,
            })

            local au = 'Unknown Game'

            pcall(function()
                au = game:GetService'MarketplaceService':GetProductInfo(game.PlaceId).Name
            end)

            local av = ak('TextLabel', {
                Text = au,
                TextSize = 14,
                FontFace = Font.new(aj.Font, Enum.FontWeight.SemiBold),
                TextColor3 = Color3.new(1, 1, 1),
                AutomaticSize = 'XY',
                BackgroundTransparency = 1,
            })

            ar('solar:gamepad-minimalistic-bold', 'GAME', av, 3)

            local aw = ak('TextLabel', {
                Text = af.LocalPlayer.DisplayName,
                TextSize = 14,
                FontFace = Font.new(aj.Font, Enum.FontWeight.SemiBold),
                TextColor3 = Color3.new(1, 1, 1),
                AutomaticSize = 'XY',
                BackgroundTransparency = 1,
            })

            ar('solar:user-bold', 'SESSION', aw, 4)

            local ax = ak('TextLabel', {
                Text = '0 ms',
                TextSize = 14,
                FontFace = Font.new(aj.Font, Enum.FontWeight.Bold),
                TextColor3 = Color3.fromHex'#FFC300',
                ThemeTag = {
                    TextColor3 = 'Accent',
                },
                AutomaticSize = 'XY',
                BackgroundTransparency = 1,
            })

            ar('solar:transmission-bold', 'PING', ax, 5)

            local ay = ak('TextLabel', {
                Text = '0 MB',
                TextSize = 14,
                FontFace = Font.new(aj.Font, Enum.FontWeight.Bold),
                TextColor3 = Color3.fromHex'#FFC300',
                ThemeTag = {
                    TextColor3 = 'Accent',
                },
                AutomaticSize = 'XY',
                BackgroundTransparency = 1,
            })

            ar('solar:cpu-bold', 'RAM', ay, 6)

            local az = ak('TextLabel', {
                Text = '0 FPS',
                TextSize = 14,
                FontFace = Font.new(aj.Font, Enum.FontWeight.Bold),
                TextColor3 = Color3.fromHex'#FFC300',
                ThemeTag = {
                    TextColor3 = 'Accent',
                },
                AutomaticSize = 'XY',
                BackgroundTransparency = 1,
            })

            ar('solar:chart-2-bold', 'FPS', az, 7)

            local aA = ak('TextLabel', {
                Text = '00:00:00',
                TextSize = 14,
                FontFace = Font.new(aj.Font, Enum.FontWeight.Bold),
                TextColor3 = Color3.fromHex'#FFC300',
                ThemeTag = {
                    TextColor3 = 'Accent',
                },
                AutomaticSize = 'XY',
                BackgroundTransparency = 1,
            })

            ar('solar:alarm-clock-bold', 'TIME', aA, 8)

            local aB = tick()
            local aC = 0
            local b = 0
            local c = ae.RenderStepped:Connect(function()
                aC = aC + 1

                local c = tick()

                if c - aB >= 1 then
                    b = aC
                    aC = 0
                    aB = c
                    az.Text = tostring(b) .. ' FPS'
                    aA.Text = os.date'%H:%M:%S'

                    local d = math.floor(ah.Network.ServerStatsItem['Data Ping']:GetValue())

                    ax.Text = tostring(d) .. ' ms'

                    local e = math.floor(ah:GetTotalMemoryUsageMb())

                    if e > 1024 then
                        ay.Text = string.format('%.1f GB', e / 1024)
                    else
                        ay.Text = tostring(e) .. ' MB'
                    end
                end
            end)

            aq.Position = UDim2.new(0.5, 0, 1, -60)

            aj.Drag(aq)

            local d = {}

            function d.Destroy(e)
                c:Disconnect()
                aq:Destroy()
            end
            function d.Visible(e, f)
                aq.Visible = f
            end

            return d
        end

        return am
    end
end

local aa = {
    Window = nil,
    Theme = nil,
    Creator = a.load'c',
    LocalizationModule = a.load'd',
    NotificationModule = a.load'e',
    Themes = nil,
    Transparent = false,
    TransparencyValue = 0.15,
    UIScale = 1,
    ConfigManager = nil,
    Version = '0.0.0',
    Services = a.load'j',
    OnThemeChangeFunction = nil,
    cloneref = nil,
    UIScaleObj = nil,
    StatusBar = nil,
}
local ae = (cloneref or clonereference or function(ae)
    return ae
end)

aa.cloneref = ae

local af = ae(game:GetService'HttpService')
local ah = ae(game:GetService'Players')
local aj = ae(game:GetService'CoreGui')
local ak = ae(game:GetService'RunService')
local al = ah.LocalPlayer or nil
local am = af:JSONDecode(a.load'k')

if am then
    aa.Version = am.version
end

local an = a.load'o'
local ao = aa.Creator
local ap = ao.New
local aq = a.load's'
local ar = protectgui or (syn and syn.protect_gui) or function() end
local as = gethui and gethui() or (aj or al:WaitForChild'PlayerGui')
local at = ap('UIScale', {
    Scale = aa.UIScale,
})

aa.UIScaleObj = at
aa.ScreenGui = ap('ScreenGui', {
    Name = 'IntiHub',
    Parent = as,
    IgnoreGuiInset = true,
    ScreenInsets = 'None',
    DisplayOrder = -99999,
}, {
    ap('Folder', {
        Name = 'Window',
    }),
    ap('Folder', {
        Name = 'KeySystem',
    }),
    ap('Folder', {
        Name = 'Popups',
    }),
    ap('Folder', {
        Name = 'ToolTips',
    }),
})
aa.NotificationGui = ap('ScreenGui', {
    Name = 'IntiHub/Notifications',
    Parent = as,
    IgnoreGuiInset = true,
})
aa.DropdownGui = ap('ScreenGui', {
    Name = 'IntiHub/Dropdowns',
    Parent = as,
    IgnoreGuiInset = true,
})
aa.TooltipGui = ap('ScreenGui', {
    Name = 'IntiHub/Tooltips',
    Parent = as,
    IgnoreGuiInset = true,
})

ar(aa.ScreenGui)
ar(aa.NotificationGui)
ar(aa.DropdownGui)
ar(aa.TooltipGui)
ao.Init(aa)

function aa.SetParent(au, av)
    if aa.ScreenGui then
        aa.ScreenGui.Parent = av
    end
    if aa.NotificationGui then
        aa.NotificationGui.Parent = av
    end
    if aa.DropdownGui then
        aa.DropdownGui.Parent = av
    end
    if aa.TooltipGui then
        aa.TooltipGui.Parent = av
    end
end

math.clamp(aa.TransparencyValue, 0, 1)

local au = aa.NotificationModule.Init(aa.NotificationGui)

function aa.Notify(av, aw)
    aw.Holder = au.Frame
    aw.Window = aa.Window

    return aa.NotificationModule.New(aw)
end
function aa.SetNotificationLower(av, aw)
    au.SetLower(aw)
end
function aa.SetFont(av, aw)
    ao.UpdateFont(aw)
end
function aa.OnThemeChange(av, aw)
    aa.OnThemeChangeFunction = aw
end
function aa.AddTheme(av, aw)
    aa.Themes[aw.Name] = aw

    return aw
end
function aa.SetTheme(av, aw)
    if aa.Themes[aw] then
        aa.Theme = aa.Themes[aw]

        ao.SetTheme(aa.Themes[aw])

        if aa.OnThemeChangeFunction then
            aa.OnThemeChangeFunction(aw)
        end

        return aa.Themes[aw]
    end

    return nil
end
function aa.GetThemes(av)
    return aa.Themes
end
function aa.GetCurrentTheme(av)
    return aa.Theme.Name
end
function aa.GetTransparency(av)
    return aa.Transparent or false
end
function aa.GetWindowSize(av)
    return aa.Window.UIElements.Main.Size
end
function aa.Localization(av, aw)
    return aa.LocalizationModule:New(aw, ao)
end
function aa.SetLanguage(av, aw)
    if ao.Localization then
        return ao.SetLanguage(aw)
    end

    return false
end
function aa.ToggleAcrylic(av, aw)
    if aa.Window and aa.Window.AcrylicPaint and aa.Window.AcrylicPaint.Model then
        aa.Window.Acrylic = aw
        aa.Window.AcrylicPaint.Model.Transparency = aw and 0.98 or 1

        if aw then
            aq.Enable()
        else
            aq.Disable()
        end
    end
end
function aa.Gradient(av, aw, ax)
    local ay = {}
    local az = {}

    for aA, aB in next, aw do
        local aC = tonumber(aA)

        if aC then
            aC = math.clamp(aC / 100, 0, 1)

            local b = aB.Color

            if typeof(b) == 'string' and string.sub(b, 1, 1) == '#' then
                b = Color3.fromHex(b)
            end

            local c = aB.Transparency or 0

            table.insert(ay, ColorSequenceKeypoint.new(aC, b))
            table.insert(az, NumberSequenceKeypoint.new(aC, c))
        end
    end

    table.sort(ay, function(aA, aB)
        return aA.Time < aB.Time
    end)
    table.sort(az, function(aA, aB)
        return aA.Time < aB.Time
    end)

    if #ay < 2 then
        table.insert(ay, ColorSequenceKeypoint.new(1, ay[1].Value))
        table.insert(az, NumberSequenceKeypoint.new(1, az[1].Value))
    end

    local aA = {
        Color = ColorSequence.new(ay),
        Transparency = NumberSequence.new(az),
    }

    if ax then
        for aB, aC in pairs(ax)do
            aA[aB] = aC
        end
    end

    return aA
end
function aa.Popup(av, aw)
    aw.IntiHub = aa

    return a.load't'.new(aw)
end

aa.Themes = a.load'u'(aa)
ao.Themes = aa.Themes

aa:SetTheme'Dark'
aa:SetLanguage(ao.Language)

function aa.CreateWindow(av, aw)
    local ax = a.load'_'

    if not ak:IsStudio() and writefile then
        pcall(function()
            if not isfolder'IntiHub_Data' then
                makefolder'IntiHub_Data'
            end

            local ay = 'IntiHub_Data/' .. (aw.Folder or aw.Title or 'Default')

            if not isfolder(ay) then
                makefolder(ay)
            end
        end)
    end

    aw.IntiHub = aa
    aw.Parent = aa.ScreenGui.Window

    if aa.Window then
        warn'You cannot create more than one window'

        return
    end

    local ay = true
    local az = aa.Themes[aw.Theme or 'Dark']

    ao.SetTheme(az)

    local aA = gethwid or function()
        return ah.LocalPlayer.UserId
    end
    local aB = aA()

    if aw.KeySystem then
        ay = false

        local aC = function()
            an.new(aw, aB, function(aC)
                ay = aC
            end)
        end
        local b = (aw.Folder or 'Temp') .. '/' .. aB .. '.key'

        if aw.KeySystem.KeyValidator then
            if aw.KeySystem.SaveKey and isfile(b) then
                local c = readfile(b)
                local d = aw.KeySystem.KeyValidator(c)

                if d then
                    ay = true
                else
                    aC()
                end
            else
                aC()
            end
        elseif not aw.KeySystem.API then
            if aw.KeySystem.SaveKey and isfile(b) then
                local c = readfile(b)
                local d = (type(aw.KeySystem.Key) == 'table') and table.find(aw.KeySystem.Key, c) or tostring(aw.KeySystem.Key) == tostring(c)

                if d then
                    ay = true
                else
                    aC()
                end
            else
                aC()
            end
        else
            if isfile(b) then
                local c = readfile(b)
                local d = false

                for e, f in next, aw.KeySystem.API do
                    local g = aa.Services[f.Type]

                    if g then
                        local i = {}

                        for j, k in next, g.Args do
                            table.insert(i, f[k])
                        end

                        local j = g.New(table.unpack(i))
                        local k = j.Verify(c)

                        if k then
                            d = true

                            break
                        end
                    end
                end

                ay = d

                if not d then
                    aC()
                end
            else
                aC()
            end
        end

        repeat
            task.wait()
        until ay
    end

    local aC = ax(aw)

    aa.Transparent = aw.Transparent
    aa.Window = aC
    aa.StatusBar = a.load'aa'.New{
        IntiHub = aa,
        Window = aC,
    }
    aa.StatusBar = a.load'aa'.New{
        IntiHub = aa,
        Window = aC,
    }

    aC:OnDestroy(function()
        if aa.StatusBar then
            aa.StatusBar:Destroy()

            aa.StatusBar = nil
        end
    end)

    if aa.StatusBar then
        aa.StatusBar:Visible(true)
    end
    if aw.Acrylic then
        aq.init()
    end

    return aC
end

return aa

