--[[
    ___       __  _ __  __      __  
   /  _/___  / /_(_) / / /_  __/ /_ 
   / // __ \/ __/ / /_/ / / / / __ \
 _/ // / / / /_/ / __  / /_/ / /_/ /
/___/_/ /_/\__/_/_/ /_/\__,_/_.___/ 
                                    
    v1.7.0  |  2026-06-02  |  Roblox UI Library for scripts
    
    To view the source code, see the `src/` folder on the official GitHub repository.
    
    Author: Sammir_Inti
    Github: https://github.com/Sam123mir/IntiHub-LibraryUI
    Discord: {{DISCORD_URL}}
    License: MIT
]]

local a a={cache={}, load=function(b)if not a.cache[b]then a.cache[b]={c=a[b]()}end return a.cache[b].c end}do function a.a()local b=(cloneref or clonereference or function(b)return b end)
local d=b(game:GetService"HttpService")
b(game:GetService"RunService")

local e={
Icons={},
Spritesheets={},
IconsType="lucide",
}


e.LocalIcons={crown=
120997033468887,
["layout-grid"]=114197133177,settings=
11419719547,zap=
130551565616516,
["check-circle"]=11419711612,component=
11419712165,star=
11419714881,
["minimize-2"]=11419715732,
["shield-check"]=11419718420,lock=
134724289526879,
["alert-circle"]=83898160590116,home=
98755624629571,
["check-square"]=134682053539509,
["mouse-pointer"]=72322454962935,type=
133543553793564,sliders=
85538382643347,list=
113179976918783,sun=
110150589884127,expand=
137492887754537,
}

local function Get(f)
local g,h=pcall(function()
return game:HttpGet(f)
end)
if g then return h end

g,h=pcall(function()
return d:GetAsync(f)
end)
return g and h or nil
end


function e.FetchIcons()
local f="https://raw.githubusercontent.com/Footagesus/Icons/main/Main-v2.lua"
local g=Get(f)
if g then local
h=loadstring(g)
if h then
local i=h()
if i and i.Icons then
for j,l in next,i.Icons do
e.Icons[j]=l
end
end
end
end
end


e.Icons.lucide={Icons={},Spritesheets={}}
for f,g in next,e.LocalIcons do
e.Icons.lucide.Icons[f]={
Image="rbxassetid://"..tostring(g),
ImageRectSize=Vector2.new(0,0),
ImageRectPosition=Vector2.new(0,0)
}
end


task.spawn(e.FetchIcons)

local function parseIconString(f)
if type(f)=="string"then
local g=f:find":"
if g then
local h=f:sub(1,g-1)
local i=f:sub(g+1)
return h,i
end
end
return nil,f
end

function e.AddIcons(f,g)
if type(f)~="string"or type(g)~="table"then
error"AddIcons: packName must be string, iconsData must be table"
return
end

if not e.Icons[f]then
e.Icons[f]={
Icons={},
Spritesheets={}
}
end

for h,i in pairs(g)do
if type(i)=="number"or(type(i)=="string"and i:match"^rbxassetid://")then
local j=i
if type(i)=="number"then
j="rbxassetid://"..tostring(i)
end

e.Icons[f].Icons[h]={
Image=j,
ImageRectSize=Vector2.new(0,0),
ImageRectPosition=Vector2.new(0,0),
Parts=nil
}
e.Icons[f].Spritesheets[j]=j

elseif type(i)=="table"then
if i.Image and i.ImageRectSize and i.ImageRectPosition then
local j=i.Image
if type(j)=="number"then
j="rbxassetid://"..tostring(j)
end

e.Icons[f].Icons[h]={
Image=j,
ImageRectSize=i.ImageRectSize,
ImageRectPosition=i.ImageRectPosition,
Parts=i.Parts
}

if not e.Icons[f].Spritesheets[j]then
e.Icons[f].Spritesheets[j]=j
end
else
warn("AddIcons: Invalid spritesheet data format for icon '"..h.."'")
end
else
warn("AddIcons: Unsupported data type for icon '"..h.."': "..type(i))
end
end
end

function e.SetIconsType(f)
e.IconsType=f
end

local f
function e.Init(g,h)
e.New=g
e.IconThemeTag=h

f=g
return e
end

function e.Icon(g,h,i)
i=i~=false
local j,l=parseIconString(g)

local m=j or h or e.IconsType
local p=l

if p=="sliders"then
p="sliders-horizontal"
end

local r=e.Icons[m]

if r and r.Icons and r.Icons[p]then
return{
r.Spritesheets[tostring(r.Icons[p].Image)],
r.Icons[p],
}
elseif r and r[p]and string.find(r[p],"rbxassetid://")then
return i and{
r[p],
{ImageRectSize=Vector2.new(0,0),ImageRectPosition=Vector2.new(0,0)}
}or r[p]
end
return nil
end

function e.GetIcon(g,h)
return e.Icon(g,h,false)
end


function e.Icon2(g,h,i)
return e.Icon(g,h,true)
end

function e.Image(g)
local h={
Icon=g.Icon or nil,
Type=g.Type,
Colors=g.Colors or{(e.IconThemeTag or Color3.new(1,1,1)),Color3.new(1,1,1)},
Transparency=g.Transparency or{0,0},
Size=g.Size or UDim2.new(0,24,0,24),

IconFrame=nil,
}

local i={}
local j={}

for l,m in next,h.Colors do
i[l]={
ThemeTag=typeof(m)=="string"and m,
Color=typeof(m)=="Color3"and m,
}
end

for l,m in next,h.Transparency do
j[l]={
ThemeTag=typeof(m)=="string"and m,
Value=typeof(m)=="number"and m,
}
end


local l=e.Icon2(h.Icon,h.Type)
if not l then
l=e.Icon"lucide:alert-circle"or{
"rbxassetid://11419710381",
{ImageRectSize=Vector2.new(0,0),ImageRectPosition=Vector2.new(0,0)}
}
end
local m=typeof(l)=="string"and string.find(l,'rbxassetid://')

if e.New then
local p=f or e.New



local r=p("ImageLabel",{
Size=h.Size,
BackgroundTransparency=1,
ImageColor3=i[1].Color or nil,
ImageTransparency=j[1].Value or nil,
ThemeTag=i[1].ThemeTag and{
ImageColor3=i[1].ThemeTag,
ImageTransparency=j[1].ThemeTag,
},
Image=m and l or l[1],
ImageRectSize=m and nil or l[2].ImageRectSize,
ImageRectOffset=m and nil or l[2].ImageRectPosition,
})


if not m and l[2].Parts then
for u,v in next,l[2].Parts do
local x=e.Icon(v,h.Type)

p("ImageLabel",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
ImageColor3=i[1+u].Color or nil,
ImageTransparency=j[1+u].Value or nil,
ThemeTag=i[1+u].ThemeTag and{
ImageColor3=i[1+u].ThemeTag,
ImageTransparency=j[1+u].ThemeTag,
},
Image=x[1],
ImageRectSize=x[2].ImageRectSize,
ImageRectOffset=x[2].ImageRectPosition,
Parent=r,
})
end
end

h.IconFrame=r
else
local p=Instance.new"ImageLabel"
p.Size=h.Size
p.BackgroundTransparency=1
p.ImageColor3=i[1].Color
p.ImageTransparency=j[1].Value or nil
p.Image=m and l or l[1]
p.ImageRectSize=m and nil or l[2].ImageRectSize
p.ImageRectOffset=m and nil or l[2].ImageRectPosition


if not m and l[2].Parts then
for r,u in next,l[2].Parts do
local v=e.Icon(u,h.Type)

local x=Instance.New"ImageLabel"
x.Size=UDim2.new(1,0,1,0)
x.BackgroundTransparency=1
x.ImageColor3=i[1+r].Color
x.ImageTransparency=j[1+r].Value or nil
x.Image=v[1]
x.ImageRectSize=v[2].ImageRectSize
x.ImageRectOffset=v[2].ImageRectPosition
x.Parent=p
end
end

h.IconFrame=p
end


return h
end

return e end function a.b()

return{


Primary="Icon",

White=Color3.new(1,1,1),
Black=Color3.new(0,0,0),

Dialog="Accent",

Background="Accent",
BackgroundTransparency=0,
Hover="Text",

PanelBackground="White",
PanelBackgroundTransparency=.95,

WindowBackground="Background",
WindowBackgroundTransparency="BackgroundTransparency",

WindowShadow="Black",


WindowTopbarTitle="Text",
WindowTopbarAuthor="Text",
WindowTopbarIcon="Icon",
WindowTopbarButtonIcon="Icon",

WindowSearchBarBackground="Background",

TabBackground="Hover",
TabBackgroundHover="Hover",
TabBackgroundHoverTransparency=.97,
TabBackgroundActive="Hover",
TabBackgroundActiveTransparency=0.93,
TabText="Text",
TabTextTransparency=0.3,
TabTextTransparencyActive=0,
TabTitle="Text",
TabIcon="Icon",
TabIconTransparency=0.4,
TabIconTransparencyActive=0.1,
TabBorderTransparency=1,
TabBorderTransparencyActive=0.75,
TabBorder="White",


ElementBackground="Text",
ElementTitle="Text",
ElementDesc="Text",
ElementIcon="Icon",

PopupBackground="Background",
PopupBackgroundTransparency="BackgroundTransparency",
PopupTitle="Text",
PopupContent="Text",
PopupIcon="Icon",

DialogBackground="Background",
DialogBackgroundTransparency="BackgroundTransparency",
DialogTitle="Text",
DialogContent="Text",
DialogIcon="Icon",

Toggle="Button",
ToggleBar="White",

Checkbox="Primary",
CheckboxIcon="White",
CheckboxBorder="White",
CheckboxBorderTransparency=.75,

SliderIcon="Icon",

Slider="Primary",
SliderThumb="White",
SliderIconFrom="SliderIcon",
SliderIconTo="SliderIcon",

Tooltip=Color3.fromHex"4C4C4C",
TooltipText="White",
TooltipSecondary="Primary",
TooltipSecondaryText="White",

TabSectionIcon="Icon",

SectionIcon="Icon",

SectionExpandIcon="White",
SectionExpandIconTransparency=.4,
SectionBox="White",
SectionBoxTransparency=.95,
SectionBoxBorder="White",
SectionBoxBorderTransparency=.75,
SectionBoxBackground="White",
SectionBoxBackgroundTransparency=.95,

SearchBarBorder="White",
SearchBarBorderTransparency=.75,

Notification="Background",
NotificationTitle="Text",
NotificationTitleTransparency=0,
NotificationContent="Text",
NotificationContentTransparency=.4,
NotificationDuration="White",
NotificationDurationTransparency=.95,
NotificationBorder="White",
NotificationBorderTransparency=.75,

DropdownTabBorder="White",

LabelBackground="White",
LabelBackgroundTransparency=.95,
}end function a.c()

local b=(cloneref or clonereference or function(b)
return b
end)

local d=b(game:GetService"RunService")
local e=b(game:GetService"UserInputService")
local f=b(game:GetService"TweenService")
local g=b(game:GetService"LocalizationService")
local h=b(game:GetService"HttpService")local i=

d.Heartbeat

local j="https://raw.githubusercontent.com/Footagesus/Icons/main/Main-v2.lua"

local l
if d:IsStudio()or not writefile then
l=a.load'a'
else
local m,p=pcall(function()
local m=game.HttpGetAsync and game:HttpGetAsync(j)or h:GetAsync(j)
return loadstring(m)()
end)
if m and p then
l=p
else
warn("[IntiHub] Failed to fetch remote icons, using local fallback. Error: "..tostring(p))
l=a.load'a'
end
end

l.SetIconsType"lucide"

local m

local p={
Font="rbxassetid://12187365364",
Localization=nil,
CanDraggable=true,
Theme=nil,
Themes=nil,
Icons=l,
Signals={},
Objects={},
LocalizationObjects={},
FontObjects={},
Language=string.match(g.SystemLocaleId,"^[a-z]+"),
Request=http_request or(syn and syn.request)or request,
DefaultProperties={
ScreenGui={
ResetOnSpawn=false,
ZIndexBehavior="Sibling",
},
CanvasGroup={
BorderSizePixel=0,
BackgroundColor3=Color3.new(1,1,1),
},
Frame={
BorderSizePixel=0,
BackgroundColor3=Color3.new(1,1,1),
},
TextLabel={
BackgroundColor3=Color3.new(1,1,1),
BorderSizePixel=0,
Text="",
RichText=true,
TextColor3=Color3.new(1,1,1),
TextSize=14,
},
TextButton={
BackgroundColor3=Color3.new(1,1,1),
BorderSizePixel=0,
Text="",
AutoButtonColor=false,
TextColor3=Color3.new(1,1,1),
TextSize=14,
},
TextBox={
BackgroundColor3=Color3.new(1,1,1),
BorderColor3=Color3.new(0,0,0),
ClearTextOnFocus=false,
Text="",
TextColor3=Color3.new(0,0,0),
TextSize=14,
},
ImageLabel={
BackgroundTransparency=1,
BackgroundColor3=Color3.new(1,1,1),
BorderSizePixel=0,
},
ImageButton={
BackgroundColor3=Color3.new(1,1,1),
BorderSizePixel=0,
AutoButtonColor=false,
},
UIListLayout={
SortOrder="LayoutOrder",
},
ScrollingFrame={
ScrollBarImageTransparency=1,
BorderSizePixel=0,
},
VideoFrame={
BorderSizePixel=0,
},
UIStroke={
Thickness=1,
ApplyStrokeMode="Border",
Transparency=0,
},
},
Colors={
Red="#e53935",
Orange="#f57c00",
Green="#43a047",
Blue="#039be5",
White="#ffffff",
Grey="#484848",
},
ThemeFallbacks=a.load'b',
Shapes={Square=
"rbxassetid://82909646051652",
["Square-Outline"]="rbxassetid://72946211851948",Squircle=

"rbxassetid://80999662900595",SquircleOutline=
"rbxassetid://117788349049947",
["Squircle-Outline"]="rbxassetid://117817408534198",SquircleOutline2=

"rbxassetid://117817408534198",

["Shadow-sm"]="rbxassetid://84825982946844",

["Squircle-TL-TR"]="rbxassetid://73569156276236",
["Squircle-BL-BR"]="rbxassetid://93853842912264",
["Squircle-TL-TR-Outline"]="rbxassetid://136702870075563",
["Squircle-BL-BR-Outline"]="rbxassetid://75035847706564",

["Glass-0.7"]="rbxassetid://79047752995006",
["Glass-1"]="rbxassetid://97324581055162",
["Glass-1.4"]="rbxassetid://95071123641270",
},
ThemeChangeCallbacks={},
}

function p.Init(r)
m=r
end

function p.AddSignal(r,u)
local v=r:Connect(u)
table.insert(p.Signals,v)
return v
end

function p.DisconnectAll()
for r,u in next,p.Signals do
local v=table.remove(p.Signals,r)
v:Disconnect()
end
end

function p.SafeCallback(r,...)
if not r then
return
end

local u,v=pcall(r,...)
if not u then
if m and m.Window and m.Window.Debug then local
x, z=v:find":%d+: "

warn("[ IntiHub: DEBUG Mode ] "..v)

return m:Notify{
Title="DEBUG Mode: Error",
Content=not z and v or v:sub(z+1),
Duration=8,
}
end
end
end

function p.Gradient(r,u)
if m and m.Gradient then
return m:Gradient(r,u)
end

local v={}
local x={}

for z,A in next,r do
local B=tonumber(z)
if B then
B=math.clamp(B/100,0,1)
table.insert(v,ColorSequenceKeypoint.new(B,A.Color))
table.insert(x,NumberSequenceKeypoint.new(B,A.Transparency or 0))
end
end

table.sort(v,function(z,A)
return z.Time<A.Time
end)
table.sort(x,function(z,A)
return z.Time<A.Time
end)

if#v<2 then
error"ColorSequence requires at least 2 keypoints"
end

local z={
Color=ColorSequence.new(v),
Transparency=NumberSequence.new(x),
}

if u then
for A,B in pairs(u)do
z[A]=B
end
end

return z
end

function p.SetTheme(r)
local u=p.Theme
p.Theme=r
p.UpdateTheme(nil,false)

for v,x in next,p.ThemeChangeCallbacks do
p.SafeCallback(x,r,u)
end
end

function p.AddFontObject(r)
table.insert(p.FontObjects,r)
p.UpdateFont(p.Font)
end

function p.UpdateFont(r)
p.Font=r
for u,v in next,p.FontObjects do
v.FontFace=Font.new(r,v.FontFace.Weight,v.FontFace.Style)
end
end

function p.GetThemeProperty(r,u)
local function getValue(v,x)
local z=x[v]

if z==nil then
return nil
end

if typeof(z)=="string"and string.sub(z,1,1)=="#"then
return Color3.fromHex(z)
end

if typeof(z)=="Color3"then
return z
end

if typeof(z)=="number"then
return z
end

if typeof(z)=="table"and z.Color and z.Transparency then
return z
end

if typeof(z)=="function"then
return z()
end

return z
end

local v=getValue(r,u)
if v~=nil then
if typeof(v)=="string"and string.sub(v,1,1)~="#"then
local x=p.GetThemeProperty(v,u)
if x~=nil then
return x
end
else
return v
end
end

local x=p.ThemeFallbacks[r]
if x~=nil then
if typeof(x)=="string"and string.sub(x,1,1)~="#"then
return p.GetThemeProperty(x,u)
else
return getValue(r,{[r]=x})
end
end

v=getValue(r,p.Themes.Dark)
if v~=nil then
if typeof(v)=="string"and string.sub(v,1,1)~="#"then
local z=p.GetThemeProperty(v,p.Themes.Dark)
if z~=nil then
return z
end
else
return v
end
end

if x~=nil then
if typeof(x)=="string"and string.sub(x,1,1)~="#"then
return p.GetThemeProperty(x,p.Themes.Dark)
else
return getValue(r,{[r]=x})
end
end

return nil
end

function p.AddThemeObject(r,u)
if p.Objects[r]then
for v,x in pairs(u)do
p.Objects[r].Properties[v]=x
end
else
p.Objects[r]={Object=r,Properties=u}
end

p.UpdateTheme(r,false)
return r
end

function p.AddLangObject(r)
local u=p.LocalizationObjects[r]
if not u then
return
end

local v=u.Object

p.SetLangForObject(r)

return v
end

function p.UpdateTheme(r,u,v,x,z,A)
local function ApplyTheme(B)
for C,F in pairs(B.Properties or{})do
local G=p.GetThemeProperty(F,p.Theme)
if G~=nil then
if typeof(G)=="Color3"then
local H=B.Object:FindFirstChild"LibraryGradient"
if H then
H:Destroy()
end

if v then
p.Tween(
B.Object,
x or 0.2,
{[C]=G},
z or Enum.EasingStyle.Quint,
A or Enum.EasingDirection.Out
):Play()
elseif u then
p.Tween(B.Object,0.08,{[C]=G}):Play()
else
B.Object[C]=G
end
elseif typeof(G)=="table"and G.Color and G.Transparency then
B.Object[C]=Color3.new(1,1,1)

local H=B.Object:FindFirstChild"LibraryGradient"
if not H then
H=Instance.new"UIGradient"
H.Name="LibraryGradient"
H.Parent=B.Object
end

H.Color=G.Color
H.Transparency=G.Transparency

for J,L in pairs(G)do
if J~="Color"and J~="Transparency"and H[J]~=nil then
H[J]=L
end
end
elseif typeof(G)=="number"then
if v then
p.Tween(
B.Object,
x or 0.2,
{[C]=G},
z or Enum.EasingStyle.Quint,
A or Enum.EasingDirection.Out
):Play()
elseif u then
p.Tween(B.Object,0.08,{[C]=G}):Play()
else
B.Object[C]=G
end
end
else
local H=B.Object:FindFirstChild"LibraryGradient"
if H then
H:Destroy()
end
end
end
end

if r then
local B=p.Objects[r]
if B then
ApplyTheme(B)
end
else
for B,C in pairs(p.Objects)do
ApplyTheme(C)
end
end
end

function p.SetThemeTag(r,u,v,x,z)
p.AddThemeObject(r,u)
p.UpdateTheme(r,false,true,v,x,z)
end

function p.SetLangForObject(r)
if p.Localization and p.Localization.Enabled then
local u=p.LocalizationObjects[r]
if not u then
return
end

local v=u.Object
local x=u.TranslationId

local z=p.Localization.Translations[p.Language]
if z and z[x]then
v.Text=z[x]
else
local A=p.Localization
and p.Localization.Translations
and p.Localization.Translations.en
or nil
if A and A[x]then
v.Text=A[x]
else
v.Text="["..x.."]"
end
end
end
end

function p.ChangeTranslationKey(r,u,v)
if p.Localization and p.Localization.Enabled then
local x=string.match(v,"^"..p.Localization.Prefix.."(.+)")
if x then
for z,A in ipairs(p.LocalizationObjects)do
if A.Object==u then
A.TranslationId=x
p.SetLangForObject(z)
return
end
end

table.insert(p.LocalizationObjects,{
TranslationId=x,
Object=u,
})
p.SetLangForObject(#p.LocalizationObjects)
end
end
end

function p.UpdateLang(r)
if r then
p.Language=r
end

for u=1,#p.LocalizationObjects do
local v=p.LocalizationObjects[u]
if v.Object and v.Object.Parent~=nil then
p.SetLangForObject(u)
else
p.LocalizationObjects[u]=nil
end
end
end

function p.SetLanguage(r)
p.Language=r
p.UpdateLang()
end

function p.Icon(r,u)
return l.Icon2(r,nil,u~=false)
end

function p.AddIcons(r,u)
return l.AddIcons(r,u)
end

function p.New(r,u,v)
local x=Instance.new(r)

for z,A in next,p.DefaultProperties[r]or{}do
x[z]=A
end

for z,A in next,u or{}do
if z~="ThemeTag"then
x[z]=A
end
if p.Localization and p.Localization.Enabled and z=="Text"then
local B=string.match(A,"^"..p.Localization.Prefix.."(.+)")
if B then
local C=#p.LocalizationObjects+1
p.LocalizationObjects[C]={TranslationId=B,Object=x}

p.SetLangForObject(C)
end
end
end

for z,A in next,v or{}do
A.Parent=x
end

if u and u.ThemeTag then
p.AddThemeObject(x,u.ThemeTag)
end
if u and u.FontFace then
p.AddFontObject(x)
end
return x
end

function p.Tween(r,u,v,...)
return f:Create(r,TweenInfo.new(u,...),v)
end

function p.NewRoundFrame(r,u,v,x,z,A)
local function getImageForType(B)
return p.Shapes[B]
end

local function getSliceCenterForType(B)
return not table.find({"Shadow-sm","Glass-0.7","Glass-1","Glass-1.4"},B)
and Rect.new(256,256,256,256)
or Rect.new(512,512,512,512)
end

local B=p.New(z and"ImageButton"or"ImageLabel",{
Image=getImageForType(u),
ScaleType="Slice",
SliceCenter=getSliceCenterForType(u),
SliceScale=1,
BackgroundTransparency=1,
ThemeTag=v.ThemeTag and v.ThemeTag,
},x)

for C,F in pairs(v or{})do
if C~="ThemeTag"then
B[C]=F
end
end

local function UpdateSliceScale(C)
local F=not table.find({"Shadow-sm","Glass-0.7","Glass-1","Glass-1.4"},u)
and(C/(256))
or(C/512)
B.SliceScale=math.max(F,0.0001)
end

local C={}

function C.SetRadius(F,G)
UpdateSliceScale(G)
end

function C.SetType(F,G)
u=G
B.Image=getImageForType(G)
B.SliceCenter=getSliceCenterForType(G)
UpdateSliceScale(r)
end

function C.UpdateShape(F,G,H)
if H then
u=H
B.Image=getImageForType(H)
B.SliceCenter=getSliceCenterForType(H)
end
if G then
r=G
end
UpdateSliceScale(r)
end

function C.GetRadius(F)
return r
end

function C.GetType(F)
return u
end

UpdateSliceScale(r)

return B,A and C or nil
end

local r=p.New local u=
p.Tween

function p.SetDraggable(v)
p.CanDraggable=v
end

function p.Drag(v,x,z)
local A
local B,C,F
local G={
CanDraggable=true,
}

if not x or typeof(x)~="table"then
x={v}
end

local function update(H)
if not B or not G.CanDraggable then
return
end

local J=H.Position-C
p.Tween(v,0.02,{
Position=UDim2.new(
F.X.Scale,
F.X.Offset+J.X,
F.Y.Scale,
F.Y.Offset+J.Y
),
}):Play()
end

for H,J in pairs(x)do
J.InputBegan:Connect(function(L)
if
(
L.UserInputType==Enum.UserInputType.MouseButton1
or L.UserInputType==Enum.UserInputType.Touch
)and G.CanDraggable
then
if A==nil then
A=J
B=true
C=L.Position
F=v.Position

if z and typeof(z)=="function"then
z(true,A)
end

L.Changed:Connect(function()
if L.UserInputState==Enum.UserInputState.End then
B=false
A=nil

if z and typeof(z)=="function"then
z(false,nil)
end
end
end)
end
end
end)

J.InputChanged:Connect(function(L)
if B and A==J then
if
L.UserInputType==Enum.UserInputType.MouseMovement
or L.UserInputType==Enum.UserInputType.Touch
then
update(L)
end
end
end)
end

e.InputChanged:Connect(function(H)
if B and A~=nil then
if
H.UserInputType==Enum.UserInputType.MouseMovement
or H.UserInputType==Enum.UserInputType.Touch
then
update(H)
end
end
end)

function G.Set(H,J)
G.CanDraggable=J
end

return G
end

l.Init(r,"Icon")

function p.SanitizeFilename(v)
local x=v:match"([^/]+)$"or v

x=x:gsub("%.[^%.]+$","")

x=x:gsub("[^%w%-_]","_")

if#x>50 then
x=x:sub(1,50)
end

return x
end

function p.GetAsset(v,x,z,A)
x=x or"Temp"
A=p.SanitizeFilename(A or"Asset")
z=z or"Image"

local B="IntiHub_Data/"..x.."/assets/."..z.."-"..A..".png"

if not d:IsStudio()and isfile and isfile(B)then
local C,F=pcall(function()
return getcustomasset(B)
end)
if C then
return F
end
return B
end

if string.find(v,"http")then
local C,F=pcall(function()
local C=p.Request
and p.Request{
Url=v,
Method="GET",
}.Body
or""

if not d:IsStudio()and writefile then
pcall(function()
if not isfolder"IntiHub_Data"then
makefolder"IntiHub_Data"
end
if not isfolder("IntiHub_Data/"..x)then
makefolder("IntiHub_Data/"..x)
end
if not isfolder("IntiHub_Data/"..x.."/assets")then
makefolder("IntiHub_Data/"..x.."/assets")
end
end)
pcall(function()
writefile(B,C)
end)

local F,G=pcall(function()
return getcustomasset(B)
end)

if F then
return G
end
end
return v
end)

if C and F then
return F
end
return v
end

return v
end

function p.Image(v,x,z,A,B,C,F,G)
A=A or"Temp"
x=p.SanitizeFilename(x)

local H=r("Frame",{
Size=UDim2.new(0,0,0,0),
BackgroundTransparency=1,
},{
r("ImageLabel",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
ScaleType="Crop",
ThemeTag=(p.Icon(v)or F)and{
ImageColor3=C and(G or"Icon")or nil,
}or nil,
},{
r("UICorner",{
CornerRadius=UDim.new(0,z),
}),
}),
})
if p.Icon(v)then
H.ImageLabel:Destroy()

local J=l.Image{
Icon=v,
Size=UDim2.new(1,0,1,0),
Colors={
(C and(G or"Icon")or false),
"Button",
},
}.IconFrame
J.Parent=H
elseif string.find(v,"http")then
local J="IntiHub_Data/"..A.."/assets/."..B.."-"..x..".png"

if not d:IsStudio()and isfile and isfile(J)then
local L,M=pcall(function()
return getcustomasset(J)
end)
if L then
H.ImageLabel.Image=M
return H
end
end

task.spawn(function()
local L,M=pcall(function()
return p.Request and p.Request{
Url=v,
Method="GET",
}.Body
end)

if L and M and M~=""then
pcall(function()
if writefile then
writefile(J,M)
end
end)

local N,O=pcall(function()
return getcustomasset(J)
end)

if N then
H.ImageLabel.Image=O
else
H.ImageLabel.Image=v
end
else
H.ImageLabel.Image=v
end
end)
elseif v==""then
H.Visible=false
else
H.ImageLabel.Image=v
end

return H
end

function p.Color3ToHSB(v)
local x,z,A=v.R,v.G,v.B
local B=math.max(x,z,A)
local C=math.min(x,z,A)
local F=B-C

local G=0
if F~=0 then
if B==x then
G=(z-A)/F%6
elseif B==z then
G=(A-x)/F+2
else
G=(x-z)/F+4
end
G=G*60
else
G=0
end

local H=(B==0)and 0 or(F/B)
local J=B

return{
h=math.floor(G+0.5),
s=H,
b=J,
}
end

function p.GetPerceivedBrightness(v)
local x=v.R
local z=v.G
local A=v.B
return 0.299*x+0.587*z+0.114*A
end

function p.GetTextColorForHSB(v,x)
local z=p.Color3ToHSB(v)local
A, B, C=z.h, z.s, z.b
if p.GetPerceivedBrightness(v)>(x or 0.5)then
return Color3.fromHSV(A/360,0,0.05)
else
return Color3.fromHSV(A/360,0,0.98)
end
end

function p.GetAverageColor(v)
local x,z,A=0,0,0
local B=v.Color.Keypoints
for C,F in ipairs(B)do

x=x+F.Value.R
z=z+F.Value.G
A=A+F.Value.B
end
local C=#B
return Color3.new(x/C,z/C,A/C)
end

function p.GenerateUniqueID(v)
return h:GenerateGUID(false)
end

function p.OnThemeChange(v,x)
if typeof(x)~="function"then
return
end

local z=h:GenerateGUID(false)
p.ThemeChangeCallbacks[z]=x

return{
Disconnect=function()
p.ThemeChangeCallbacks[z]=nil
end,
}
end

return p end function a.d()

local b={}







function b.New(d,e,f)
local g={
Enabled=e.Enabled or false,
Translations=e.Translations or{},
Prefix=e.Prefix or"loc:",
DefaultLanguage=e.DefaultLanguage or"en"
}

f.Localization=g

return g
end



return b end function a.e()
local b=a.load'c'
local d=b.New
local e=b.Tween

local function GetSolidColor(f)
local g=b.GetThemeProperty(f,b.Theme)
if typeof(g)=="Color3"then
return g
elseif typeof(g)=="table"and g.Color and typeof(g.Color)=="ColorSequence"then
return g.Color.Keypoints[1].Value
end
return Color3.fromHex"#00F2FE"
end

local f={
Size=UDim2.new(0,320,1,-156),
SizeLower=UDim2.new(0,320,1,-56),
UICorner=12,
UIPadding=16,
Holder=nil,
NotificationIndex=0,
Notifications={}
}

function f.Init(g)
local h={
Lower=false
}

function h.SetLower(j)
h.Lower=j
if h.Frame then
h.Frame.Size=j and f.SizeLower or f.Size
end
end

h.Frame=d("Frame",{
Name="NotificationHolder",
Position=UDim2.new(1,-20,0,56),
AnchorPoint=Vector2.new(1,0),
Size=f.Size,
Parent=g,
BackgroundTransparency=1,
},{
d("UIListLayout",{
HorizontalAlignment="Right",
SortOrder="LayoutOrder",
VerticalAlignment="Bottom",
Padding=UDim.new(0,10),
}),
d("UIPadding",{
PaddingBottom=UDim.new(0,20),
PaddingRight=UDim.new(0,0),
})
})
return h
end

function f.New(g)
local h={
Title=g.Title or"Notification",
Content=g.Content or nil,
Icon=g.Icon or"bell",
IconThemed=g.IconThemed,
Background=g.Background,
BackgroundImageTransparency=g.BackgroundImageTransparency,
Duration=g.Duration or 5,
Buttons=g.Buttons or{},
CanClose=g.CanClose~=false,
Closed=false,
}

f.NotificationIndex=f.NotificationIndex+1
f.Notifications[f.NotificationIndex]=h

local j=b.Image(
h.Icon,
h.Title..":"..(h.Icon or"bell"),
0,
g.Window and g.Window.Folder or"IntiHub",
"Notification",
h.IconThemed
)
j.Size=UDim2.new(0,22,0,22)
j.Position=UDim2.new(0,f.UIPadding,0,f.UIPadding)
local l=j:FindFirstChildWhichIsA("ImageLabel",true)
if l then
l.ImageColor3=GetSolidColor"Accent"
end

local m
if h.CanClose then
m=d("ImageButton",{
Image=b.Icon"x"[1],
ImageRectSize=b.Icon"x"[2].ImageRectSize,
ImageRectOffset=b.Icon"x"[2].ImageRectPosition,
BackgroundTransparency=1,
Size=UDim2.new(0,14,0,14),
Position=UDim2.new(1,-f.UIPadding,0,f.UIPadding),
AnchorPoint=Vector2.new(1,0),
ImageColor3=GetSolidColor"Accent",
ImageTransparency=0.5,
},{
d("TextButton",{
Size=UDim2.new(1,10,1,10),
BackgroundTransparency=1,
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Text="",
})
})
end

local p=d("Frame",{
Name="DurationBar",
Size=UDim2.new(1,0,0,2),
Position=UDim2.new(0,0,1,0),
AnchorPoint=Vector2.new(0,1),
BackgroundColor3=GetSolidColor"Accent",
BorderSizePixel=0,
ZIndex=5,
})

local r=d("Frame",{
Size=UDim2.new(1,-22-(f.UIPadding*2),0,0),
Position=UDim2.new(0,22+(f.UIPadding*1.5),0,0),
BackgroundTransparency=1,
AutomaticSize="Y",
},{
d("UIPadding",{
PaddingTop=UDim.new(0,f.UIPadding),
PaddingBottom=UDim.new(0,f.UIPadding),
PaddingRight=UDim.new(0,f.UIPadding),
}),
d("UIListLayout",{
Padding=UDim.new(0,4),
SortOrder="LayoutOrder",
}),
d("TextLabel",{
Name="Title",
AutomaticSize="Y",
Size=UDim2.new(1,0,0,0),
TextWrapped=true,
TextXAlignment="Left",
RichText=true,
BackgroundTransparency=1,
TextSize=14,
TextColor3=GetSolidColor"Accent",
Text="<b>"..h.Title.."</b>",
FontFace=Font.new(b.Font,Enum.FontWeight.Bold),
LayoutOrder=1,
}),
h.Content and d("TextLabel",{
Name="Content",
AutomaticSize="Y",
Size=UDim2.new(1,0,0,0),
TextWrapped=true,
TextXAlignment="Left",
RichText=true,
BackgroundTransparency=1,
TextSize=13,
TextColor3=Color3.new(1,1,1),
TextTransparency=0.3,
Text=h.Content,
FontFace=Font.new(b.Font,Enum.FontWeight.Medium),
LayoutOrder=2,
})or nil,
})

local u=d("Frame",{
Name="NotificationFrame",
Size=UDim2.new(1,0,0,0),
Position=UDim2.new(1.5,0,0,0),
BackgroundTransparency=0,
BackgroundColor3=Color3.fromHex"#0F0F0F",
AutomaticSize="Y",
ClipsDescendants=true,
},{
d("UICorner",{CornerRadius=UDim.new(0,f.UICorner)}),
d("UIStroke",{
Thickness=1.5,
ThemeTag={
Color="Outline",
},
Transparency=0.6,
}),
p,
r,
j,
m,
})

local v=d("Frame",{
Name="Container",
BackgroundTransparency=1,
Size=UDim2.new(1,0,0,0),
Parent=g.Holder,
ClipsDescendants=true,
},{
u
})

function h.Close(x)
if not h.Closed then
h.Closed=true
e(u,0.4,{Position=UDim2.new(1.5,0,0,0)},Enum.EasingStyle.Quint,Enum.EasingDirection.In):Play()
task.wait(0.1)
local z=e(v,0.3,{Size=UDim2.new(1,0,0,0)},Enum.EasingStyle.Quint,Enum.EasingDirection.Out)
z.Completed:Connect(function()v:Destroy()end)
z:Play()
end
end

task.spawn(function()
task.wait()
e(v,0.5,{Size=UDim2.new(1,0,0,u.AbsoluteSize.Y+10)},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
e(u,0.5,{Position=UDim2.new(0,0,0,0)},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

if h.Duration then
p.Size=UDim2.new(1,0,0,2)
e(p,h.Duration,{Size=UDim2.new(0,0,0,2)},Enum.EasingStyle.Linear):Play()
task.wait(h.Duration)
h:Close()
end
end)

if m then
b.AddSignal(m.TextButton.MouseButton1Click,function()
h:Close()
end)
end

return h
end

return f end function a.f()












local b=4294967296;local d=b-1;local function c(e,f)local g,h=0,1;while e~=0 or f~=0 do local j,l=e%2,f%2;local m=(j+l)%2;g=g+m*h;e=math.floor(e/2)f=math.floor(f/2)h=h*2 end;return g%b end;local function k(e,f,g,...)local h;if f then e=e%b;f=f%b;h=c(e,f)if g then h=k(h,g,...)end;return h elseif e then return e%b else return 0 end end;local function n(e,f,g,...)local h;if f then e=e%b;f=f%b;h=(e+f-c(e,f))/2;if g then h=n(h,g,...)end;return h elseif e then return e%b else return d end end;local function o(e)return d-e end;local function q(e,f)if f<0 then return lshift(e,-f)end;return math.floor(e%4294967296/2^f)end;local function s(e,f)if f>31 or f<-31 then return 0 end;return q(e%b,f)end;local function lshift(e,f)if f<0 then return s(e,-f)end;return e*2^f%4294967296 end;local function t(e,f)e=e%b;f=f%32;local g=n(e,2^f-1)return s(e,f)+lshift(g,32-f)end;local e={0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2}local function w(f)return string.gsub(f,".",function(g)return string.format("%02x",string.byte(g))end)end;local function y(f,g)local h=""for j=1,g do local l=f%256;h=string.char(l)..h;f=(f-l)/256 end;return h end;local function D(f,g)local h=0;for j=g,g+3 do h=h*256+string.byte(f,j)end;return h end;local function E(f,g)local h=64-(g+9)%64;g=y(8*g,8)f=f.."\128"..string.rep("\0",h)..g;assert(#f%64==0)return f end;local function I(f)f[1]=0x6a09e667;f[2]=0xbb67ae85;f[3]=0x3c6ef372;f[4]=0xa54ff53a;f[5]=0x510e527f;f[6]=0x9b05688c;f[7]=0x1f83d9ab;f[8]=0x5be0cd19;return f end;local function K(f,g,h)local j={}for l=1,16 do j[l]=D(f,g+(l-1)*4)end;for l=17,64 do local m=j[l-15]local p=k(t(m,7),t(m,18),s(m,3))m=j[l-2]j[l]=(j[l-16]+p+j[l-7]+k(t(m,17),t(m,19),s(m,10)))%b end;local l,m,p,r,u,v,x,z=h[1],h[2],h[3],h[4],h[5],h[6],h[7],h[8]for A=1,64 do local B=k(t(l,2),t(l,13),t(l,22))local C=k(n(l,m),n(l,p),n(m,p))local F=(B+C)%b;local G=k(t(u,6),t(u,11),t(u,25))local H=k(n(u,v),n(o(u),x))local J=(z+G+H+e[A]+j[A])%b;z=x;x=v;v=u;u=(r+J)%b;r=p;p=m;m=l;l=(J+F)%b end;h[1]=(h[1]+l)%b;h[2]=(h[2]+m)%b;h[3]=(h[3]+p)%b;h[4]=(h[4]+r)%b;h[5]=(h[5]+u)%b;h[6]=(h[6]+v)%b;h[7]=(h[7]+x)%b;h[8]=(h[8]+z)%b end;local function Z(f)f=E(f,#f)local g=I{}for h=1,#f,64 do K(f,h,g)end;return w(y(g[1],4)..y(g[2],4)..y(g[3],4)..y(g[4],4)..y(g[5],4)..y(g[6],4)..y(g[7],4)..y(g[8],4))end;local f;local g={["\\"]="\\",["\""]="\"",["\b"]="b",["\f"]="f",["\n"]="n",["\r"]="r",["\t"]="t"}local h={["/"]="/"}for j,l in pairs(g)do h[l]=j end;local j=function(j)return"\\"..(g[j]or string.format("u%04x",j:byte()))end;local l=function(l)return"null"end;local m=function(m,p)local r={}p=p or{}if p[m]then error"circular reference"end;p[m]=true;if rawget(m,1)~=nil or next(m)==nil then local u=0;for v in pairs(m)do if type(v)~="number"then error"invalid table: mixed or invalid key types"end;u=u+1 end;if u~=#m then error"invalid table: sparse array"end;for v,x in ipairs(m)do table.insert(r,f(x,p))end;p[m]=nil;return"["..table.concat(r,",").."]"else for u,v in pairs(m)do if type(u)~="string"then error"invalid table: mixed or invalid key types"end;table.insert(r,f(u,p)..":"..f(v,p))end;p[m]=nil;return"{"..table.concat(r,",").."}"end end;local p=function(p)return'"'..p:gsub('[%z\1-\31\\"]',j)..'"'end;local r=function(r)if r~=r or r<=-math.huge or r>=math.huge then error("unexpected number value '"..tostring(r).."'")end;return string.format("%.14g",r)end;local u={["nil"]=l,table=m,string=p,number=r,boolean=tostring}f=function(v,x)local z=type(v)local A=u[z]if A then return A(v,x)end;error("unexpected type '"..z.."'")end;local v=function(v)return f(v)end;local x;local z=function(...)local z={}for A=1,select("#",...)do z[select(A,...)]=true end;return z end;local A=z(" ","\t","\r","\n")local B=z(" ","\t","\r","\n","]","}",",")local C=z("\\","/",'"',"b","f","n","r","t","u")local F=z("true","false","null")local G={["true"]=true,["false"]=false,null=nil}local H=function(H,J,L,M)for N=J,#H do if L[H:sub(N,N)]~=M then return N end end;return#H+1 end;local J=function(J,L,M)local N=1;local O=1;for P=1,L-1 do O=O+1;if J:sub(P,P)=="\n"then N=N+1;O=1 end end;error(string.format("%s at line %d col %d",M,N,O))end;local L=function(L)local M=math.floor;if L<=0x7f then return string.char(L)elseif L<=0x7ff then return string.char(M(L/64)+192,L%64+128)elseif L<=0xffff then return string.char(M(L/4096)+224,M(L%4096/64)+128,L%64+128)elseif L<=0x10ffff then return string.char(M(L/262144)+240,M(L%262144/4096)+128,M(L%4096/64)+128,L%64+128)end;error(string.format("invalid unicode codepoint '%x'",L))end;local M=function(M)local N=tonumber(M:sub(1,4),16)local O=tonumber(M:sub(7,10),16)if O then return L((N-0xd800)*0x400+O-0xdc00+0x10000)else return L(N)end end;local N=function(N,O)local P=""local Q=O+1;local R=Q;while Q<=#N do local S=N:byte(Q)if S<32 then J(N,Q,"control character in string")elseif S==92 then P=P..N:sub(R,Q-1)Q=Q+1;local T=N:sub(Q,Q)if T=="u"then local U=N:match("^[dD][89aAbB]%x%x\\u%x%x%x%x",Q+1)or N:match("^%x%x%x%x",Q+1)or J(N,Q-1,"invalid unicode escape in string")P=P..M(U)Q=Q+#U else if not C[T]then J(N,Q-1,"invalid escape char '"..T.."' in string")end;P=P..h[T]end;R=Q+1 elseif S==34 then P=P..N:sub(R,Q-1)return P,Q+1 end;Q=Q+1 end;J(N,O,"expected closing quote for string")end;local O=function(O,P)local Q=H(O,P,B)local R=O:sub(P,Q-1)local S=tonumber(R)if not S then J(O,P,"invalid number '"..R.."'")end;return S,Q end;local P=function(P,Q)local R=H(P,Q,B)local S=P:sub(Q,R-1)if not F[S]then J(P,Q,"invalid literal '"..S.."'")end;return G[S],R end;local Q=function(Q,R)local S={}local T=1;R=R+1;while 1 do local U;R=H(Q,R,A,true)if Q:sub(R,R)=="]"then R=R+1;break end;U,R=x(Q,R)S[T]=U;T=T+1;R=H(Q,R,A,true)local V=Q:sub(R,R)R=R+1;if V=="]"then break end;if V~=","then J(Q,R,"expected ']' or ','")end end;return S,R end;local R=function(R,S)local T={}S=S+1;while 1 do local U,V;S=H(R,S,A,true)if R:sub(S,S)=="}"then S=S+1;break end;if R:sub(S,S)~='"'then J(R,S,"expected string for key")end;U,S=x(R,S)S=H(R,S,A,true)if R:sub(S,S)~=":"then J(R,S,"expected ':' after key")end;S=H(R,S+1,A,true)V,S=x(R,S)T[U]=V;S=H(R,S,A,true)local W=R:sub(S,S)S=S+1;if W=="}"then break end;if W~=","then J(R,S,"expected '}' or ','")end end;return T,S end;local S={['"']=N,["0"]=O,["1"]=O,["2"]=O,["3"]=O,["4"]=O,["5"]=O,["6"]=O,["7"]=O,["8"]=O,["9"]=O,["-"]=O,t=P,f=P,n=P,["["]=Q,["{"]=R}x=function(T,U)local V=T:sub(U,U)local W=S[V]if W then return W(T,U)end;J(T,U,"unexpected character '"..V.."'")end;local T=function(T)if type(T)~="string"then error("expected argument of type string, got "..type(T))end;local U,V=x(T,H(T,1,A,true))V=H(T,V,A,true)if V<=#T then J(T,V,"trailing garbage")end;return U end;
local U,V,W=v,T,Z;





local X={}

local Y=(cloneref or clonereference or function(Y)return Y end)


function X.New(_,aa)

local ab=_;
local ac=aa;
local ad=true;


local ae=function(ae)end;


repeat task.wait(1)until game:IsLoaded();


local af=false;
local ag,ah,ai,aj,ak,al,am,an,ao=setclipboard or toclipboard,request or http_request or syn_request,string.char,tostring,string.sub,os.time,math.random,math.floor,gethwid or function()return Y(game:GetService"Players").LocalPlayer.UserId end
local ap,aq="",0;


local ar="https://api.platoboost.app";
local as=ah{
Url=ar.."/public/connectivity",
Method="GET"
};
if as.StatusCode~=200 and as.StatusCode~=429 then
ar="https://api.platoboost.net";
end


function cacheLink()
if aq+(600)<al()then
local at=ah{
Url=ar.."/public/start",
Method="POST",
Body=U{
service=ab,
identifier=W(ao())
},
Headers={
["Content-Type"]="application/json",
["User-Agent"]="Roblox/Exploit"
}
};

if at.StatusCode==200 then
local au=V(at.Body);

if au.success==true then
ap=au.data.url;
aq=al();
return true,ap
else
ae(au.message);
return false,au.message
end
elseif at.StatusCode==429 then
local au="you are being rate limited, please wait 20 seconds and try again.";
ae(au);
return false,au
end

local au="Failed to cache link.";
ae(au);
return false,au
else
return true,ap
end
end

cacheLink();


local at=function()
local at=""
for au=1,16 do
at=at..ai(an(am()*(26))+97)
end
return at
end


for au=1,5 do
local av=at();
task.wait(0.2)
if at()==av then
local aw="platoboost nonce error.";
ae(aw);
error(aw);
end
end


local au=function()
local au,av=cacheLink();

if au then
ag(av);
end
end


local av=function(av)
local aw=at();
local ax=ar.."/public/redeem/"..aj(ab);

local ay={
identifier=W(ao()),
key=av
}

if ad then
ay.nonce=aw;
end

local az=ah{
Url=ax,
Method="POST",
Body=U(ay),
Headers={
["Content-Type"]="application/json"
}
};

if az.StatusCode==200 then
local aA=V(az.Body);

if aA.success==true then
if aA.data.valid==true then
if ad then
if aA.data.hash==W("true".."-"..aw.."-"..ac)then
return true
else
ae"failed to verify integrity.";
return false
end
else
return true
end
else
ae"key is invalid.";
return false
end
else
if ak(aA.message,1,27)=="unique constraint violation"then
ae"you already have an active key, please wait for it to expire before redeeming it.";
return false
else
ae(aA.message);
return false
end
end
elseif az.StatusCode==429 then
ae"you are being rate limited, please wait 20 seconds and try again.";
return false
else
ae"server returned an invalid status code, please try again later.";
return false
end
end


local aw=function(aw)
if af==true then
return false,("A request is already being sent, please slow down.")
else
af=true;
end

local ax=at();
local ay=ar.."/public/whitelist/"..aj(ab).."?identifier="..W(ao()).."&key="..aw;

if ad then
ay=ay.."&nonce="..ax;
end

local az=ah{
Url=ay,
Method="GET",
};

af=false;

if az.StatusCode==200 then
local aA=V(az.Body);

if aA.success==true then
if aA.data.valid==true then
if ad then
if aA.data.hash==W("true".."-"..ax.."-"..ac)then
return true,""
else
return false,("failed to verify integrity.")
end
else
return true
end
else
if ak(aw,1,4)=="KEY_"then
return true,av(aw)
else
return false,("Key is invalid.")
end
end
else
return false,(aA.message)
end
elseif az.StatusCode==429 then
return false,("You are being rate limited, please wait 20 seconds and try again.")
else
return false,("Server returned an invalid status code, please try again later.")
end
end


local ax=function(ax)
local ay=at();
local az=ar.."/public/flag/"..aj(ab).."?name="..ax;

if ad then
az=az.."&nonce="..ay;
end

local aA=ah{
Url=az,
Method="GET",
};

if aA.StatusCode==200 then
local aB=V(aA.Body);

if aB.success==true then
if ad then
if aB.data.hash==W(aj(aB.data.value).."-"..ay.."-"..ac)then
return aB.data.value
else
ae"failed to verify integrity.";
return nil
end
else
return aB.data.value
end
else
ae(aB.message);
return nil
end
else
return nil
end
end


return{
Verify=aw,
GetFlag=ax,
Copy=au,
}
end


return X end function a.g()






local aa=(cloneref or clonereference or function(aa)
return aa
end)

local ab=aa(game:GetService"HttpService")
local ac={}

function ac.New(ad)
local ae=gethwid or function()
return aa(game:GetService"Players").LocalPlayer.UserId
end
local af,ag=request or http_request or syn_request,setclipboard or toclipboard

function ValidateKey(ah)
local ai="https://new.pandadevelopment.net/api/v1/keys/validate"

local aj={
ServiceID=ad,
HWID=tostring(ae()),
Key=tostring(ah),
}

local ak=ab:JSONEncode(aj)
local al,am=pcall(function()
return af{
Url=ai,
Method="POST",
Headers={
["User-Agent"]="Roblox/Exploit",
["Content-Type"]="application/json",
},
Body=ak,
}
end)

if al and am then
if am.Success then
local an,ao=pcall(function()
return ab:JSONDecode(am.Body)
end)

if an and ao then
if ao.Authenticated_Status and ao.Authenticated_Status=="Success"then
return true,"Authenticated"
else
local ap=ao.Note or"Unknown reason"
return false,"Authentication failed: "..ap
end
else
return false,"JSON decode error"
end
else
warn(
" HTTP request was not successful. Code: "
..tostring(am.StatusCode)
.." Message: "
..am.StatusMessage
)
return false,"HTTP request failed: "..am.StatusMessage
end
else
return false,"Request pcall error"
end
end

function GetKeyLink()
return"https://new.pandadevelopment.net/getkey/"..tostring(ad).."?hwid="..tostring(ae())
end

function CopyLink()
return ag(GetKeyLink())
end

return{
Verify=ValidateKey,
Copy=CopyLink,
}
end

return ac end function a.h()









local aa={}


function aa.New(ab,ac)
local ad="https://sdkapi-public.luarmor.net/library.lua"

local ae=loadstring(
game.HttpGetAsync and game:HttpGetAsync(ad)
or HttpService:GetAsync(ad)
)()
local af=setclipboard or toclipboard

ae.script_id=ab

function ValidateKey(ag)
local ah=ae.check_key(ag);


if(ah.code=="KEY_VALID")then
return true,"Whitelisted!"

elseif(ah.code=="KEY_HWID_LOCKED")then
return false,"Key linked to a different HWID. Please reset it using our bot"

elseif(ah.code=="KEY_INCORRECT")then
return false,"Key is wrong or deleted!"
else
return false,"Key check failed:"..ah.message.." Code: "..ah.code
end
end

function CopyLink()
af(tostring(ac))
end

return{
Verify=ValidateKey,
Copy=CopyLink
}
end


return aa end function a.i()








local aa={}

function aa.New(ab,ac,ad)
JunkieProtected.API_KEY=ac
JunkieProtected.PROVIDER=ad
JunkieProtected.SERVICE_ID=ab

local function ValidateKey(ae)
if not ae or ae==""then
print"No key provided!"

return false,"No key provided. Please get a key."
end

local af=JunkieProtected.IsKeylessMode()
if af and af.keyless_mode then
print"Keyless mode enabled. Starting script..."
return true,"Keyless mode enabled. Starting script..."
end

local ag=JunkieProtected.ValidateKey{Key=ae}
if ag=="valid"then
print"Key is valid! Starting script..."
load()
if _G.JD_IsPremium then
print"Premium user detected!"
else
print"Standard user"
end

return true,"Key is valid!"
else
local ah=JunkieProtected.GetKeyLink()
print"Invalid key!"

return false,"Invalid key. Get one from:"..ah
end
end

local function copyLink()
local ae=JunkieProtected.GetKeyLink()

if setclipboard then
setclipboard(ae)
end
end
return{
Verify=ValidateKey,
Copy=copyLink
}
end

return aa end function a.j()



return{
platoboost={
Name="Platoboost",
Icon="rbxassetid://75920162824531",
Args={"ServiceId","Secret"},

New=a.load'f'.New
},
pandadevelopment={
Name="Panda Development",
Icon="panda",
Args={"ServiceId"},

New=a.load'g'.New
},
luarmor={
Name="Luarmor",
Icon="rbxassetid://130918283130165",
Args={"ScriptId","Discord"},

New=a.load'h'.New
},
junkiedevelopment={
Name="Junkie Development",
Icon="rbxassetid://106310347705078",
Args={"ServiceId","ApiKey","Provider"},

New=a.load'i'.New
},


}end function a.k()



return[[
{
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
]]end function a.l()

local aa={}

local ab=a.load'c'
local ac=ab.New
local ad=ab.Tween

function aa.New(ae,af,ag,ah,ai,aj,ak,al)
ah=ah or"Primary"
local am=al or(not ak and 14 or 99)
local an
if af and af~=""then
an=ac("ImageLabel",{
Image=ab.Icon(af)[1],
ImageRectSize=ab.Icon(af)[2].ImageRectSize,
ImageRectOffset=ab.Icon(af)[2].ImageRectPosition,
Size=UDim2.new(0,21,0,21),
BackgroundTransparency=1,
ImageColor3=ah=="White"and Color3.new(0,0,0)or nil,
ImageTransparency=ah=="White"and 0.4 or 0,
ThemeTag={
ImageColor3=ah~="White"and"Icon"or nil,
},
})
end

local ao=ac("TextButton",{
Size=UDim2.new(0,0,1,0),
AutomaticSize="X",
Parent=ai,
BackgroundTransparency=1,
},{
ab.NewRoundFrame(am,"Squircle",{
ThemeTag={
ImageColor3=ah~="White"and"Button"or nil,
},
ImageColor3=ah=="White"and Color3.new(1,1,1)or nil,
Size=UDim2.new(1,0,1,0),
Name="Squircle",
ImageTransparency=ah=="Primary"and 0 or ah=="White"and 0 or 1,
},{
ah=="Primary"and ac("UIGradient",{
Rotation=45,
Color=ColorSequence.new{
ColorSequenceKeypoint.new(0,Color3.fromHex"#FFC300"),
ColorSequenceKeypoint.new(1,Color3.fromHex"#FF8C00"),
},
})or nil,
}),

ab.NewRoundFrame(am,"Squircle",{



ImageColor3=Color3.new(1,1,1),
Size=UDim2.new(1,0,1,0),
Name="Special",
ImageTransparency=ah=="Secondary"and 0.95 or 1,
}),

ab.NewRoundFrame(am,"Shadow-sm",{



ImageColor3=Color3.new(0,0,0),
Size=UDim2.new(1,3,1,3),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Name="Shadow",

ImageTransparency=1,
Visible=not ak,
}),

ab.NewRoundFrame(am,not ak and"Glass-1"or"Glass-0.7",{
ThemeTag={
ImageColor3="White",
},
Size=UDim2.new(1,0,1,0),

ImageTransparency=0.6,
Name="Outline",
},{













}),

ab.NewRoundFrame(am,"Squircle",{
Size=UDim2.new(1,0,1,0),
Name="Frame",
ThemeTag={
ImageColor3=ah~="White"and"Text"or nil,
},
ImageColor3=ah=="White"and Color3.new(0,0,0)or nil,
ImageTransparency=1,
},{
ac("UIPadding",{
PaddingLeft=UDim.new(0,16),
PaddingRight=UDim.new(0,16),
}),
ac("UIListLayout",{
FillDirection="Horizontal",
Padding=UDim.new(0,8),
VerticalAlignment="Center",
HorizontalAlignment="Center",
}),
an,
ac("TextLabel",{
BackgroundTransparency=1,
FontFace=Font.new(ab.Font,Enum.FontWeight.SemiBold),
Text=ae or"Button",
ThemeTag={
TextColor3=(ah~="Primary"and ah~="White")and"Text",
},
TextColor3=ah=="Primary"and Color3.new(1,1,1)
or ah=="White"and Color3.new(0,0,0)
or nil,
AutomaticSize="XY",
TextSize=18,
}),
}),
})

ab.AddSignal(ao.MouseEnter,function()
ad(ao.Frame,0.047,{ImageTransparency=0.95}):Play()
end)
ab.AddSignal(ao.MouseLeave,function()
ad(ao.Frame,0.047,{ImageTransparency=1}):Play()
end)
ab.AddSignal(ao.MouseButton1Up,function()
if aj then
aj:Close()()
end
if ag then
ab.SafeCallback(ag)
end
end)

return ao
end

return aa end function a.m()

local aa={}

local ab=a.load'c'
local ac=ab.New local ad=
ab.Tween


function aa.New(ae,af,ag,ah,ai,aj,ak,al)
ah=ah or"Input"
local am=ak or 10
local an
if af and af~=""then
an=ac("ImageLabel",{
Image=ab.Icon(af)[1],
ImageRectSize=ab.Icon(af)[2].ImageRectSize,
ImageRectOffset=ab.Icon(af)[2].ImageRectPosition,
Size=UDim2.new(0,21,0,21),
BackgroundTransparency=1,
ThemeTag={
ImageColor3="Icon",
}
})
end

local ao=ah~="Input"

local ap=ac("TextBox",{
BackgroundTransparency=1,
TextSize=17,
FontFace=Font.new(ab.Font,Enum.FontWeight.Regular),
Size=UDim2.new(1,an and-29 or 0,1,0),
PlaceholderText=ae,
ClearTextOnFocus=al or false,
ClipsDescendants=true,
TextWrapped=ao,
MultiLine=ao,
TextXAlignment="Left",
TextYAlignment=ah=="Input"and"Center"or"Top",

ThemeTag={
PlaceholderColor3="PlaceholderText",
TextColor3="Text",
},
})

local aq=ac("Frame",{
Size=UDim2.new(1,0,0,42),
Parent=ag,
BackgroundTransparency=1
},{
ac("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
},{
ab.NewRoundFrame(am,"Squircle",{
ThemeTag={
ImageColor3="Accent",
},
Size=UDim2.new(1,0,1,0),
ImageTransparency=.97,
}),
ab.NewRoundFrame(am,"Glass-1",{
ThemeTag={
ImageColor3="Outline",
},
Size=UDim2.new(1,0,1,0),
ImageTransparency=.75,
},{













}),
ab.NewRoundFrame(am,"Squircle",{
Size=UDim2.new(1,0,1,0),
Name="Frame",
ImageColor3=Color3.new(1,1,1),
ImageTransparency=.95
},{
ac("UIPadding",{
PaddingTop=UDim.new(0,ah=="Input"and 0 or 12),
PaddingLeft=UDim.new(0,12),
PaddingRight=UDim.new(0,12),
PaddingBottom=UDim.new(0,ah=="Input"and 0 or 12),
}),
ac("UIListLayout",{
FillDirection="Horizontal",
Padding=UDim.new(0,8),
VerticalAlignment=ah=="Input"and"Center"or"Top",
HorizontalAlignment="Left",
}),
an,
ap,
})
})
})










if aj then
ab.AddSignal(ap:GetPropertyChangedSignal"Text",function()
if ai then
ab.SafeCallback(ai,ap.Text)
end
end)
else
ab.AddSignal(ap.FocusLost,function()
if ai then
ab.SafeCallback(ai,ap.Text)
end
end)
end

return aq
end


return aa end function a.n()
local aa=a.load'c'
local ab=aa.New
local ac=aa.Tween

local ad
local ae

local af={
Holder=nil,

Parent=nil,
}

function af.Init(ag,ah,ai)
ad=ag
ae=ah
af.Parent=ai
return af
end

function af.Create(ag,ah)
local ai={
UICorner=28,
UIPadding=12,

Window=ad,
IntiHub=ae,

UIElements={},
}

if ag then
ai.UIPadding=0
end
if ag then
ai.UICorner=26
end

ah=ah or"Dialog"

if not ag then
ai.UIElements.FullScreen=ab("Frame",{
ZIndex=999,
BackgroundTransparency=1,
BackgroundColor3=Color3.fromHex"#000000",
Size=UDim2.new(1,0,1,0),
Active=false,
Visible=false,
Parent=af.Parent
or(ad and ad.UIElements and ad.UIElements.Main and ad.UIElements.Main.Main),
},{
ab("UICorner",{
CornerRadius=UDim.new(0,ad.UICorner),
}),
})
end

ab("ImageLabel",{
Image="rbxassetid://8992230677",
ThemeTag={
ImageColor3="WindowShadow",

},
ImageTransparency=1,
Size=UDim2.new(1,100,1,100),
Position=UDim2.new(0,-50,0,-50),
ScaleType="Slice",
SliceCenter=Rect.new(99,99,99,99),
BackgroundTransparency=1,
ZIndex=-999999999999999,
Name="Blur",
})

ai.UIElements.Main=ab("Frame",{
Size=UDim2.new(0,280,0,0),
ThemeTag={
BackgroundColor3=ah.."Background",
},
AutomaticSize="Y",
BackgroundTransparency=1,
Visible=false,
ZIndex=99999,
},{
ab("UIPadding",{
PaddingTop=UDim.new(0,ai.UIPadding),
PaddingLeft=UDim.new(0,ai.UIPadding),
PaddingRight=UDim.new(0,ai.UIPadding),
PaddingBottom=UDim.new(0,ai.UIPadding),
}),
})

ai.UIElements.MainContainer=aa.NewRoundFrame(ai.UICorner,"Squircle",{
Visible=false,

ImageTransparency=ag and 0.15 or 0,
Parent=ag and af.Parent or ai.UIElements.FullScreen,
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
AutomaticSize="XY",
ThemeTag={
ImageColor3=ah.."Background",
ImageTransparency=ah.."BackgroundTransparency",
},
ZIndex=9999,
},{





ai.UIElements.Main,




















})

function ai.Open(aj)
if not ag then
ai.UIElements.FullScreen.Visible=true
ai.UIElements.FullScreen.Active=true
end

task.spawn(function()
ai.UIElements.MainContainer.Visible=true

if not ag then
ac(ai.UIElements.FullScreen,0.1,{BackgroundTransparency=0.3}):Play()
end
ac(ai.UIElements.MainContainer,0.1,{ImageTransparency=0}):Play()


task.spawn(function()
task.wait(0.05)
ai.UIElements.Main.Visible=true
end)
end)
end
function ai.Close(aj)
if not ag then
ac(ai.UIElements.FullScreen,0.1,{BackgroundTransparency=1}):Play()
ai.UIElements.FullScreen.Active=false
task.spawn(function()
task.wait(0.1)
ai.UIElements.FullScreen.Visible=false
end)
end
ai.UIElements.Main.Visible=false

ac(ai.UIElements.MainContainer,0.1,{ImageTransparency=1}):Play()



task.spawn(function()
task.wait(0.1)
if not ag then
ai.UIElements.FullScreen:Destroy()
else
ai.UIElements.MainContainer:Destroy()
end
end)

return function()end
end


return ai
end

return af end function a.o()

local aa={}

local ab=a.load'c'
local ac=ab.New
local ad=ab.Tween

local ae=a.load'l'.New
local af=a.load'm'.New

function aa.new(ag,ah,ai,aj)
local ak=a.load'n'.Init(nil,ag.IntiHub,ag.IntiHub.ScreenGui.KeySystem)
local al=ak.Create(true)

local am={}

local an

local ao=(ag.KeySystem.Thumbnail and ag.KeySystem.Thumbnail.Width)or 200

local ap=430
if ag.KeySystem.Thumbnail and ag.KeySystem.Thumbnail.Image then
ap=430+(ao/2)
end

al.UIElements.Main.AutomaticSize="Y"
al.UIElements.Main.Size=UDim2.new(0,ap,0,0)

local aq

if ag.Icon then
aq=
ab.Image(ag.Icon,ag.Title..":"..ag.Icon,0,"Temp","KeySystem",ag.IconThemed)
aq.Size=UDim2.new(0,24,0,24)
aq.LayoutOrder=-1
end

local ar=ac("TextLabel",{
AutomaticSize="XY",
BackgroundTransparency=1,
Text=ag.KeySystem.Title or ag.Title,
FontFace=Font.new(ab.Font,Enum.FontWeight.SemiBold),
ThemeTag={
TextColor3="Text",
},
TextSize=20,
})

local as=ac("TextLabel",{
AutomaticSize="XY",
BackgroundTransparency=1,
Text="Key System",
AnchorPoint=Vector2.new(1,0.5),
Position=UDim2.new(1,0,0.5,0),
TextTransparency=1,
FontFace=Font.new(ab.Font,Enum.FontWeight.Medium),
ThemeTag={
TextColor3="Text",
},
TextSize=16,
})

local at=ac("Frame",{
BackgroundTransparency=1,
AutomaticSize="XY",
},{
ac("UIListLayout",{
Padding=UDim.new(0,14),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
aq,
ar,
})

local au=ac("Frame",{
AutomaticSize="Y",
Size=UDim2.new(1,0,0,0),
BackgroundTransparency=1,
},{





at,
as,
})

local av=af("Enter Key","key",nil,"Input",function(av)
an=av
end)

local aw
if ag.KeySystem.Note and ag.KeySystem.Note~=""then
aw=ac("TextLabel",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
FontFace=Font.new(ab.Font,Enum.FontWeight.Medium),
TextXAlignment="Left",
Text=ag.KeySystem.Note,
TextSize=18,
TextTransparency=0.4,
ThemeTag={
TextColor3="Text",
},
BackgroundTransparency=1,
RichText=true,
TextWrapped=true,
})
end

local ax=ac("Frame",{
Size=UDim2.new(1,0,0,42),
BackgroundTransparency=1,
},{
ac("Frame",{
BackgroundTransparency=1,
AutomaticSize="X",
Size=UDim2.new(0,0,1,0),
},{
ac("UIListLayout",{
Padding=UDim.new(0,9),
FillDirection="Horizontal",
}),
}),
})

local ay
if ag.KeySystem.Thumbnail and ag.KeySystem.Thumbnail.Image then
local az
if ag.KeySystem.Thumbnail.Title then
az=ac("TextLabel",{
Text=ag.KeySystem.Thumbnail.Title,
ThemeTag={
TextColor3="Text",
},
TextSize=18,
FontFace=Font.new(ab.Font,Enum.FontWeight.Medium),
BackgroundTransparency=1,
AutomaticSize="XY",
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
})
end
ay=ac("ImageLabel",{
Image=ag.KeySystem.Thumbnail.Image,
BackgroundTransparency=1,
Size=UDim2.new(0,ao,1,-12),
Position=UDim2.new(0,6,0,6),
Parent=al.UIElements.Main,
ScaleType="Crop",
},{
az,
ac("UICorner",{
CornerRadius=UDim.new(0,20),
}),
})
end

ac("Frame",{

Size=UDim2.new(1,ay and-ao or 0,1,0),
Position=UDim2.new(0,ay and ao or 0,0,0),
BackgroundTransparency=1,
Parent=al.UIElements.Main,
},{
ac("Frame",{

Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
},{
ac("UIListLayout",{
Padding=UDim.new(0,18),
FillDirection="Vertical",
}),
au,
aw,
av,
ax,
ac("UIPadding",{
PaddingTop=UDim.new(0,16),
PaddingLeft=UDim.new(0,16),
PaddingRight=UDim.new(0,16),
PaddingBottom=UDim.new(0,16),
}),
}),
})





local az=ae("Exit","log-out",function()
al:Close()()
end,"Tertiary",ax.Frame)

if ay then
az.Parent=ay
az.Size=UDim2.new(0,0,0,42)
az.Position=UDim2.new(0,10,1,-10)
az.AnchorPoint=Vector2.new(0,1)
end

if ag.KeySystem.URL then
ae("Get key","key",function()
setclipboard(ag.KeySystem.URL)
end,"Secondary",ax.Frame)
end

if ag.KeySystem.API then








local aA=240
local aB=false
local b=ae("Get key","key",nil,"Secondary",ax.Frame)

local d=ab.NewRoundFrame(99,"Squircle",{
Size=UDim2.new(0,1,1,0),
ThemeTag={
ImageColor3="Text",
},
ImageTransparency=0.9,
})

ac("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(0,0,1,0),
AutomaticSize="X",
Parent=b.Frame,
},{
d,
ac("UIPadding",{
PaddingLeft=UDim.new(0,5),
PaddingRight=UDim.new(0,5),
}),
})

local f=ab.Image("chevron-down","chevron-down",0,"Temp","KeySystem",true)

f.Size=UDim2.new(1,0,1,0)

ac("Frame",{
Size=UDim2.new(0,21,0,21),
Parent=b.Frame,
BackgroundTransparency=1,
},{
f,
})

local g=ab.NewRoundFrame(15,"Squircle",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
ThemeTag={
ImageColor3="Background",
},
},{
ac("UIPadding",{
PaddingTop=UDim.new(0,5),
PaddingLeft=UDim.new(0,5),
PaddingRight=UDim.new(0,5),
PaddingBottom=UDim.new(0,5),
}),
ac("UIListLayout",{
FillDirection="Vertical",
Padding=UDim.new(0,5),
}),
})

local h=ac("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(0,aA,0,0),
ClipsDescendants=true,
AnchorPoint=Vector2.new(1,0),
Parent=b,
Position=UDim2.new(1,0,1,15),
},{
g,
})

ac("TextLabel",{
Text="Select Service",
BackgroundTransparency=1,
FontFace=Font.new(ab.Font,Enum.FontWeight.Medium),
ThemeTag={TextColor3="Text"},
TextTransparency=0.2,
TextSize=16,
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
TextWrapped=true,
TextXAlignment="Left",
Parent=g,
},{
ac("UIPadding",{
PaddingTop=UDim.new(0,10),
PaddingLeft=UDim.new(0,10),
PaddingRight=UDim.new(0,10),
PaddingBottom=UDim.new(0,10),
}),
})

for j,l in next,ag.KeySystem.API do
local m=ag.IntiHub.Services[l.Type]
if m then
local p={}
for r,u in next,m.Args do
table.insert(p,l[u])
end

local r=m.New(table.unpack(p))
r.Type=l.Type
table.insert(am,r)

local u=ab.Image(
l.Icon or m.Icon or Icons[l.Type]or"user",
l.Icon or m.Icon or Icons[l.Type]or"user",
0,
"Temp",
"KeySystem",
true
)
u.Size=UDim2.new(0,24,0,24)

local v=ab.NewRoundFrame(10,"Squircle",{
Size=UDim2.new(1,0,0,0),
ThemeTag={ImageColor3="Text"},
ImageTransparency=1,
Parent=g,
AutomaticSize="Y",
},{
ac("UIListLayout",{
FillDirection="Horizontal",
Padding=UDim.new(0,10),
VerticalAlignment="Center",
}),
u,
ac("UIPadding",{
PaddingTop=UDim.new(0,10),
PaddingLeft=UDim.new(0,10),
PaddingRight=UDim.new(0,10),
PaddingBottom=UDim.new(0,10),
}),
ac("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(1,-34,0,0),
AutomaticSize="Y",
},{
ac("UIListLayout",{
FillDirection="Vertical",
Padding=UDim.new(0,5),
HorizontalAlignment="Center",
}),
ac("TextLabel",{
Text=l.Title or m.Name,
BackgroundTransparency=1,
FontFace=Font.new(ab.Font,Enum.FontWeight.Medium),
ThemeTag={TextColor3="Text"},
TextTransparency=0.05,
TextSize=18,
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
TextWrapped=true,
TextXAlignment="Left",
}),
ac("TextLabel",{
Text=l.Desc or"",
BackgroundTransparency=1,
FontFace=Font.new(ab.Font,Enum.FontWeight.Regular),
ThemeTag={TextColor3="Text"},
TextTransparency=0.2,
TextSize=16,
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
TextWrapped=true,
Visible=l.Desc and true or false,
TextXAlignment="Left",
}),
}),
},true)

ab.AddSignal(v.MouseEnter,function()
ad(v,0.08,{ImageTransparency=0.95}):Play()
end)
ab.AddSignal(v.InputEnded,function()
ad(v,0.08,{ImageTransparency=1}):Play()
end)
ab.AddSignal(v.MouseButton1Click,function()
r.Copy()
ag.IntiHub:Notify{
Title="Key System",
Content="Key link copied to clipboard.",
Image="key",
}
end)
end
end

ab.AddSignal(b.MouseButton1Click,function()
if not aB then
ad(
h,
0.3,
{Size=UDim2.new(0,aA,0,g.AbsoluteSize.Y+1)},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out
):Play()
ad(f,0.3,{Rotation=180},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
else
ad(
h,
0.25,
{Size=UDim2.new(0,aA,0,0)},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out
):Play()
ad(f,0.25,{Rotation=0},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
aB=not aB
end)
end

local function handleSuccess(aA)
al:Close()()
local aB=ag.Folder or"Temp"
pcall(function()
pcall(function()
if not isfolder(aB)then
makefolder(aB)
end
writefile(aB.."/"..ah..".key",tostring(aA))
end)
end)
task.wait(0.4)
ai(true)
end

local aA=ae("Submit","arrow-right",function()
local aA=tostring(an or"empty")local aB=
ag.Folder or ag.Title

if ag.KeySystem.KeyValidator then
local b=ag.KeySystem.KeyValidator(aA)

if b then
if ag.KeySystem.SaveKey then
handleSuccess(aA)
else
al:Close()()
task.wait(0.4)
ai(true)
end
else
ag.IntiHub:Notify{
Title="Key System. Error",
Content="Invalid key.",
Icon="triangle-alert",
}
end
elseif not ag.KeySystem.API then
local b=type(ag.KeySystem.Key)=="table"and table.find(ag.KeySystem.Key,aA)
or ag.KeySystem.Key==aA

if b then
if ag.KeySystem.SaveKey then
handleSuccess(aA)
else
al:Close()()
task.wait(0.4)
ai(true)
end
end
else
local b,d
for f,g in next,am do
local h,j=g.Verify(aA)
if h then
b,d=true,j
break
end
d=j
end

if b then
handleSuccess(aA)
else
ag.IntiHub:Notify{
Title="Key System. Error",
Content=d,
Icon="triangle-alert",
}
end
end
end,"Primary",ax)

aA.AnchorPoint=Vector2.new(1,0.5)
aA.Position=UDim2.new(1,0,0.5,0)










al:Open()
end

return aa end function a.p()




local aa=(cloneref or clonereference or function(aa)return aa end)


local function map(ab,ac,ad,ae,af)
return(ab-ac)*(af-ae)/(ad-ac)+ae
end

local function viewportPointToWorld(ab,ac)
local ad=aa(game:GetService"Workspace").CurrentCamera:ScreenPointToRay(ab.X,ab.Y)
return ad.Origin+ad.Direction*ac
end

local function getOffset()
local ab=aa(game:GetService"Workspace").CurrentCamera.ViewportSize.Y
return map(ab,0,2560,8,56)
end

return{viewportPointToWorld,getOffset}end function a.q()



local aa=(cloneref or clonereference or function(aa)return aa end)


local ab=a.load'c'
local ac=ab.New


local ad,ae=unpack(a.load'p')
local af=Instance.new("Folder",aa(game:GetService"Workspace").CurrentCamera)


local function createAcrylic()
local ag=ac("Part",{
Name="Body",
Color=Color3.new(0,0,0),
Material=Enum.Material.Glass,
Size=Vector3.new(1,1,0),
Anchored=true,
CanCollide=false,
Locked=true,
CastShadow=false,
Transparency=0.98,
},{
ac("SpecialMesh",{
MeshType=Enum.MeshType.Brick,
Offset=Vector3.new(0,0,-1E-6),
}),
})

return ag
end


local function createAcrylicBlur(ag)
local ah={}

ag=ag or 0.001
local ai={
topLeft=Vector2.new(),
topRight=Vector2.new(),
bottomRight=Vector2.new(),
}
local aj=createAcrylic()
aj.Parent=af

local function updatePositions(ak,al)
ai.topLeft=al
ai.topRight=al+Vector2.new(ak.X,0)
ai.bottomRight=al+ak
end

local function render()
local ak=aa(game:GetService"Workspace").CurrentCamera
if ak then
ak=ak.CFrame
end
local al=ak
if not al then
al=CFrame.new()
end

local am=al
local an=ai.topLeft
local ao=ai.topRight
local ap=ai.bottomRight

local aq=ad(an,ag)
local ar=ad(ao,ag)
local as=ad(ap,ag)

local at=(ar-aq).Magnitude
local au=(ar-as).Magnitude

aj.CFrame=
CFrame.fromMatrix((aq+as)/2,am.XVector,am.YVector,am.ZVector)
aj.Mesh.Scale=Vector3.new(at,au,0)
end

local function onChange(ak)
local al=ae()
local am=ak.AbsoluteSize-Vector2.new(al,al)
local an=ak.AbsolutePosition+Vector2.new(al/2,al/2)

updatePositions(am,an)
task.spawn(render)
end

local function renderOnChange()
local ak=aa(game:GetService"Workspace").CurrentCamera
if not ak then
return
end

table.insert(ah,ak:GetPropertyChangedSignal"CFrame":Connect(render))
table.insert(ah,ak:GetPropertyChangedSignal"ViewportSize":Connect(render))
table.insert(ah,ak:GetPropertyChangedSignal"FieldOfView":Connect(render))
task.spawn(render)
end

aj.Destroying:Connect(function()
for ak,al in ah do
pcall(function()
al:Disconnect()
end)
end
end)

renderOnChange()

return onChange,aj
end

return function(ag)
local ah={}
local ai,aj=createAcrylicBlur(ag)

local ak=ac("Frame",{
BackgroundTransparency=1,
Size=UDim2.fromScale(1,1),
})

ab.AddSignal(ak:GetPropertyChangedSignal"AbsolutePosition",function()
ai(ak)
end)

ab.AddSignal(ak:GetPropertyChangedSignal"AbsoluteSize",function()
ai(ak)
end)

ah.AddParent=function(al)
ab.AddSignal(al:GetPropertyChangedSignal"Visible",function()

end)
end

ah.SetVisibility=function(al)
aj.Transparency=al and 0.98 or 1
end

ah.Frame=ak
ah.Model=aj

return ah
end end function a.r()


local aa=a.load'c'
local ab=a.load'q'

local ac=aa.New

return function(ad)
local ae={}

ae.Frame=ac("Frame",{
Size=UDim2.fromScale(1,1),
BackgroundTransparency=1,
BackgroundColor3=Color3.fromRGB(255,255,255),
BorderSizePixel=0,
},{












ac("UICorner",{
CornerRadius=UDim.new(0,8),
}),

ac("Frame",{
BackgroundTransparency=1,
Size=UDim2.fromScale(1,1),
Name="Background",
ThemeTag={
BackgroundColor3="AcrylicMain",
},
},{
ac("UICorner",{
CornerRadius=UDim.new(0,8),
}),
}),

ac("Frame",{
BackgroundColor3=Color3.fromRGB(255,255,255),
BackgroundTransparency=1,
Size=UDim2.fromScale(1,1),
},{










}),

ac("ImageLabel",{
Image="rbxassetid://9968344105",
ImageTransparency=0.98,
ScaleType=Enum.ScaleType.Tile,
TileSize=UDim2.new(0,128,0,128),
Size=UDim2.fromScale(1,1),
BackgroundTransparency=1,
},{
ac("UICorner",{
CornerRadius=UDim.new(0,8),
}),
}),

ac("ImageLabel",{
Image="rbxassetid://9968344227",
ImageTransparency=0.9,
ScaleType=Enum.ScaleType.Tile,
TileSize=UDim2.new(0,128,0,128),
Size=UDim2.fromScale(1,1),
BackgroundTransparency=1,
ThemeTag={
ImageTransparency="AcrylicNoise",
},
},{
ac("UICorner",{
CornerRadius=UDim.new(0,8),
}),
}),

ac("Frame",{
BackgroundTransparency=1,
Size=UDim2.fromScale(1,1),
ZIndex=2,
},{










}),
})


local af

task.wait()
if ad.UseAcrylic then
af=ab()

af.Frame.Parent=ae.Frame
ae.Model=af.Model
ae.AddParent=af.AddParent
ae.SetVisibility=af.SetVisibility
end

return ae,af
end end function a.s()



local aa=(cloneref or clonereference or function(aa)return aa end)


local ab={
AcrylicBlur=a.load'q',

AcrylicPaint=a.load'r',
}

local ac=Instance.new"DepthOfFieldEffect"
ac.FarIntensity=0
ac.InFocusRadius=0.1
ac.NearIntensity=1

local ad={}

function ab.Enable()
for ae,af in pairs(ad)do
af.Enabled=false
end
ac.Parent=aa(game:GetService"Lighting")
end

function ab.Disable()
for ae,af in pairs(ad)do
af.Enabled=af.enabled
end
ac.Parent=nil
end

function ab.init()
local function registerDefaults()
local function register(ae)
if ae:IsA"DepthOfFieldEffect"then
ad[ae]={enabled=ae.Enabled}
end
end

for ae,af in pairs(aa(game:GetService"Lighting"):GetChildren())do
register(af)
end

if aa(game:GetService"Workspace").CurrentCamera then
for ae,af in pairs(aa(game:GetService"Workspace").CurrentCamera:GetChildren())do
register(af)
end
end
end

registerDefaults()
ab.Enable()
end

return ab end function a.t()

local aa={}

local ab=a.load'c'
local ac=ab.New local ad=
ab.Tween


function aa.new(ae)
local af={
Title=ae.Title or"Dialog",
Content=ae.Content,
Icon=ae.Icon,
IconThemed=ae.IconThemed,
Thumbnail=ae.Thumbnail,
Buttons=ae.Buttons,

IconSize=22,
}

local ag=a.load'n'.Init(nil,ae.IntiHub.ScreenGui.Popups)
local ah=ag.Create(true,"Popup")

local ai=200

local aj=430
if af.Thumbnail and af.Thumbnail.Image then
aj=430+(ai/2)
end

ah.UIElements.Main.AutomaticSize="Y"
ah.UIElements.Main.Size=UDim2.new(0,aj,0,0)



local ak

if af.Icon then
ak=ab.Image(
af.Icon,
af.Title..":"..af.Icon,
0,
ae.IntiHub.Window,
"Popup",
true,
ae.IconThemed,
"PopupIcon"
)
ak.Size=UDim2.new(0,af.IconSize,0,af.IconSize)
ak.LayoutOrder=-1
end


local al=ac("TextLabel",{
AutomaticSize="Y",
BackgroundTransparency=1,
Text=af.Title,
TextXAlignment="Left",
FontFace=Font.new(ab.Font,Enum.FontWeight.SemiBold),
ThemeTag={
TextColor3="PopupTitle",
},
TextSize=20,
TextWrapped=true,
Size=UDim2.new(1,ak and-af.IconSize-14 or 0,0,0)
})

local am=ac("Frame",{
BackgroundTransparency=1,
AutomaticSize="XY",
},{
ac("UIListLayout",{
Padding=UDim.new(0,14),
FillDirection="Horizontal",
VerticalAlignment="Center"
}),
ak,al
})

local an=ac("Frame",{
AutomaticSize="Y",
Size=UDim2.new(1,0,0,0),
BackgroundTransparency=1,
},{





am,
})

local ao
if af.Content and af.Content~=""then
ao=ac("TextLabel",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
FontFace=Font.new(ab.Font,Enum.FontWeight.Medium),
TextXAlignment="Left",
Text=af.Content,
TextSize=18,
TextTransparency=.2,
ThemeTag={
TextColor3="PopupContent",
},
BackgroundTransparency=1,
RichText=true,
TextWrapped=true,
})
end

local ap=ac("Frame",{
Size=UDim2.new(1,0,0,42),
BackgroundTransparency=1,
},{
ac("UIListLayout",{
Padding=UDim.new(0,9),
FillDirection="Horizontal",
HorizontalAlignment="Right"
})
})

local aq
if af.Thumbnail and af.Thumbnail.Image then
local ar
if af.Thumbnail.Title then
ar=ac("TextLabel",{
Text=af.Thumbnail.Title,
ThemeTag={
TextColor3="Text",
},
TextSize=18,
FontFace=Font.new(ab.Font,Enum.FontWeight.Medium),
BackgroundTransparency=1,
AutomaticSize="XY",
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
})
end
aq=ac("ImageLabel",{
Image=af.Thumbnail.Image,
BackgroundTransparency=1,
Size=UDim2.new(0,ai,1,0),
Parent=ah.UIElements.Main,
ScaleType="Crop"
},{
ar,
ac("UICorner",{
CornerRadius=UDim.new(0,0),
})
})
end

ac("Frame",{

Size=UDim2.new(1,aq and-ai or 0,1,0),
Position=UDim2.new(0,aq and ai or 0,0,0),
BackgroundTransparency=1,
Parent=ah.UIElements.Main
},{
ac("Frame",{

Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
},{
ac("UIListLayout",{
Padding=UDim.new(0,18),
FillDirection="Vertical",
}),
an,
ao,
ap,
ac("UIPadding",{
PaddingTop=UDim.new(0,16),
PaddingLeft=UDim.new(0,16),
PaddingRight=UDim.new(0,16),
PaddingBottom=UDim.new(0,16),
})
}),
})

local ar=a.load'l'.New

for as,at in next,af.Buttons do
ar(at.Title,at.Icon,at.Callback,at.Variant,ap,ah)
end

ah:Open()


return af
end

return aa end function a.u()
return function(aa)
return{
Dark={
Name="Dark",

Accent=aa:Gradient({
["0"]={Color=Color3.fromHex"#00F2FE",Transparency=0},
["50"]={Color=Color3.fromHex"#0091FF",Transparency=0},
["100"]={Color=Color3.fromHex"#0055FF",Transparency=0},
},{Rotation=45}),
Dialog=Color3.fromHex"#050505",
Outline=Color3.fromHex"#00F2FE",
Text=Color3.fromHex"#FFFFFF",
Placeholder=Color3.fromHex"#7a7a7a",
Background=Color3.fromHex"#000000",
BackgroundTransparency=0.05,
Button=Color3.fromHex"#141414",
Icon=Color3.fromHex"#00F2FE",
Toggle=aa:Gradient({
["0"]={Color=Color3.fromHex"#00F2FE",Transparency=0},
["100"]={Color=Color3.fromHex"#0091FF",Transparency=0},
},{Rotation=45}),
Slider=Color3.fromHex"#00F2FE",
Checkbox=Color3.fromHex"#00F2FE",

PanelBackground=Color3.fromHex"#0A0A0A",
PanelBackgroundTransparency=0.35,

SliderIcon=Color3.fromHex"#00F2FE",
Primary=Color3.fromHex"#00F2FE",

LabelBackground=Color3.fromHex"#000000",
LabelBackgroundTransparency=0.8,
},

Light={
Name="Light",

Accent=Color3.fromHex"#FFFFFF",
Dialog=Color3.fromHex"#f4f4f5",
Outline=Color3.fromHex"#ffffff",
Text=Color3.fromHex"#000000",
Placeholder=Color3.fromHex"#555555",
Background=Color3.fromHex"#e9e9e9",
Button=Color3.fromHex"#18181b",
Icon=Color3.fromHex"#52525b",
Toggle=Color3.fromHex"#33C759",
Slider=Color3.fromHex"#0091FF",
Checkbox=Color3.fromHex"#0091FF",

TabBackground=Color3.fromHex"#ffffff",
TabBackgroundHover=Color3.fromHex"#ffffff",
TabBackgroundHoverTransparency=0.5,
TabBackgroundActive=Color3.fromHex"#ffffff",
TabBackgroundActiveTransparency=0,

PanelBackground=Color3.fromHex"#FFFFFF",
PanelBackgroundTransparency=0,

LabelBackground=Color3.fromHex"#ffffff",
LabelBackgroundTransparency=0,
},

Rose={
Name="Rose",

Accent=Color3.fromHex"#be185d",
Dialog=Color3.fromHex"#4c0519",

Text=Color3.fromHex"#fdf2f8",
Placeholder=Color3.fromHex"#d67aa6",
Background=Color3.fromHex"#1f0308",
Button=Color3.fromHex"#e95f74",
Icon=Color3.fromHex"#fb7185",
},

Plant={
Name="Plant",

Accent=Color3.fromHex"#166534",
Dialog=Color3.fromHex"#052e16",

Text=Color3.fromHex"#f0fdf4",
Placeholder=Color3.fromHex"#4fbf7a",
Background=Color3.fromHex"#0a1b0f",
Button=Color3.fromHex"#16a34a",
Icon=Color3.fromHex"#4ade80",
},

Red={
Name="Red",

Accent=Color3.fromHex"#991b1b",
Dialog=Color3.fromHex"#450a0a",

Text=Color3.fromHex"#fef2f2",
Placeholder=Color3.fromHex"#d95353",
Background=Color3.fromHex"#1c0606",
Button=Color3.fromHex"#dc2626",
Icon=Color3.fromHex"#ef4444",
},

Indigo={
Name="Indigo",

Accent=Color3.fromHex"#3730a3",
Dialog=Color3.fromHex"#1e1b4b",

Text=Color3.fromHex"#f1f5f9",
Placeholder=Color3.fromHex"#7078d9",
Background=Color3.fromHex"#0f0a2e",
Button=Color3.fromHex"#4f46e5",
Icon=Color3.fromHex"#6366f1",
},

Sky={
Name="Sky",

Accent=Color3.fromHex"#00d4ff",
Dialog=Color3.fromHex"#0a4d66",

Text=Color3.fromHex"#e6f7ff",
Placeholder=Color3.fromHex"#66b3cc",
Background=Color3.fromHex"#051a26",
Button=Color3.fromHex"#00a8cc",
Icon=Color3.fromHex"#2db8d9",

Toggle=Color3.fromHex"#00d9d9",
Slider=Color3.fromHex"#00d4ff",
Checkbox=Color3.fromHex"#00d4ff",

PanelBackground=Color3.fromHex"#0d3a47",
PanelBackgroundTransparency=0.8,
},

Violet={
Name="Violet",

Accent=Color3.fromHex"#6d28d9",
Dialog=Color3.fromHex"#3c1361",

Text=Color3.fromHex"#faf5ff",
Placeholder=Color3.fromHex"#8f7ee0",
Background=Color3.fromHex"#1e0a3e",
Button=Color3.fromHex"#7c3aed",
Icon=Color3.fromHex"#8b5cf6",
},

Amber={
Name="Amber",

Accent=aa:Gradient({
["0"]={Color=Color3.fromHex"#b45309",Transparency=0},
["100"]={Color=Color3.fromHex"#d97706",Transparency=0},
},{Rotation=45}),

Dialog=aa:Gradient({
["0"]={Color=Color3.fromHex"#451a03",Transparency=0},
["100"]={Color=Color3.fromHex"#6b2e05",Transparency=0},
},{Rotation=90}),






Text=aa:Gradient({
["0"]={Color=Color3.fromHex"#fffbeb",Transparency=0},
["100"]={Color=Color3.fromHex"#fff7ed",Transparency=0},
},{Rotation=45}),

Placeholder=aa:Gradient({
["0"]={Color=Color3.fromHex"#d1a326",Transparency=0},
["100"]={Color=Color3.fromHex"#fbbf24",Transparency=0},
},{Rotation=45}),

Background=aa:Gradient({
["0"]={Color=Color3.fromHex"#1c1003",Transparency=0},
["100"]={Color=Color3.fromHex"#3f210d",Transparency=0},
},{Rotation=90}),

Button=aa:Gradient({
["0"]={Color=Color3.fromHex"#d97706",Transparency=0},
["100"]={Color=Color3.fromHex"#f59e0b",Transparency=0},
},{Rotation=45}),

Icon=Color3.fromHex"#f59e0b",

Toggle=aa:Gradient({
["0"]={Color=Color3.fromHex"#d97706",Transparency=0},
["100"]={Color=Color3.fromHex"#f59e0b",Transparency=0},
},{Rotation=45}),

Slider=Color3.fromHex"#d97706",

Checkbox=aa:Gradient({
["0"]={Color=Color3.fromHex"#d97706",Transparency=0},
["100"]={Color=Color3.fromHex"#fbbf24",Transparency=0},
},{Rotation=45}),

PanelBackground=Color3.fromHex"#FFFFFF",
PanelBackgroundTransparency=0.95,
},

Emerald={
Name="Emerald",

Accent=Color3.fromHex"#047857",
Dialog=Color3.fromHex"#022c22",

Text=Color3.fromHex"#ecfdf5",
Placeholder=Color3.fromHex"#3fbf8f",
Background=Color3.fromHex"#011411",
Button=Color3.fromHex"#059669",
Icon=Color3.fromHex"#10b981",
},

Midnight={
Name="Midnight",

Accent=Color3.fromHex"#1e3a8a",
Dialog=Color3.fromHex"#0c1e42",

Text=Color3.fromHex"#dbeafe",
Placeholder=Color3.fromHex"#2f74d1",
Background=Color3.fromHex"#0a0f1e",
Button=Color3.fromHex"#2563eb",
Primary=Color3.fromHex"#2563eb",
Icon=Color3.fromHex"#5591f4",
},

Crimson={
Name="Crimson",

Accent=Color3.fromHex"#b91c1c",
Dialog=Color3.fromHex"#450a0a",

Text=Color3.fromHex"#fef2f2",
Placeholder=Color3.fromHex"#6f757b",
Background=Color3.fromHex"#0c0404",
Button=Color3.fromHex"#991b1b",
Icon=Color3.fromHex"#dc2626",
},

MonokaiPro={
Name="Monokai Pro",

Accent=Color3.fromHex"#fc9867",
Dialog=Color3.fromHex"#1e1e1e",

Text=Color3.fromHex"#fcfcfa",
Placeholder=Color3.fromHex"#6f6f6f",
Background=Color3.fromHex"#191622",
Button=Color3.fromHex"#ab9df2",
Icon=Color3.fromHex"#a9dc76",

Metadata={
PullRequest=23,
},
},

CottonCandy={
Name="Cotton Candy",

Accent=Color3.fromHex"#ec4899",
Dialog=Color3.fromHex"#2d1b3d",

Text=Color3.fromHex"#fdf2f8",
Placeholder=Color3.fromHex"#8a5fd3",
Background=Color3.fromHex"#1a0b2e",
Button=Color3.fromHex"#d946ef",
Slider=Color3.fromHex"#d946ef",
Icon=Color3.fromHex"#06b6d4",
},

Mellowsi={
Name="Mellowsi",

Accent=Color3.fromHex"#342A1E",
Dialog=Color3.fromHex"#291C13",

Text=Color3.fromHex"#F5EBDD",
Placeholder=Color3.fromHex"#9C8A73",
Background=Color3.fromHex"#1C1002",
Button=Color3.fromHex"#342A1E",
Icon=Color3.fromHex"#C9B79C",

Toggle=Color3.fromHex"#a9873f",
Slider=Color3.fromHex"#C9A24D",
Checkbox=Color3.fromHex"#C9A24D",

Metadata={
PullRequest=52,
},
},

Rainbow={
Name="Rainbow",

Accent=aa:Gradient({
["0"]={Color=Color3.fromHex"#00ff41",Transparency=0},
["33"]={Color=Color3.fromHex"#00ffff",Transparency=0},
["66"]={Color=Color3.fromHex"#0080ff",Transparency=0},
["100"]={Color=Color3.fromHex"#8000ff",Transparency=0},
},{Rotation=45}),

Dialog=aa:Gradient({
["0"]={Color=Color3.fromHex"#ff0080",Transparency=0},
["25"]={Color=Color3.fromHex"#8000ff",Transparency=0},
["50"]={Color=Color3.fromHex"#0080ff",Transparency=0},
["75"]={Color=Color3.fromHex"#00ff80",Transparency=0},
["100"]={Color=Color3.fromHex"#ff8000",Transparency=0},
},{Rotation=135}),


Text=Color3.fromHex"#ffffff",
Placeholder=Color3.fromHex"#00ff80",

Background=aa:Gradient({
["0"]={Color=Color3.fromHex"#000000",Transparency=0},
["100"]={Color=Color3.fromHex"#1A1A1A",Transparency=0},
},{Rotation=90}),

Button=aa:Gradient({
["0"]={Color=Color3.fromHex"#FFC300",Transparency=0},
["100"]={Color=Color3.fromHex"#FF8C00",Transparency=0},
},{Rotation=45}),

Icon=Color3.fromHex"#ffffff",
},

Oceanic={
Name="Oceanic",

Accent=aa:Gradient({
["0"]={Color=Color3.fromHex"#00F2FE",Transparency=0},
["100"]={Color=Color3.fromHex"#4FACFE",Transparency=0},
},{Rotation=45}),
Dialog=Color3.fromHex"#0A1128",
Outline=Color3.fromHex"#00F2FE",
Text=Color3.fromHex"#E6F8FF",
Placeholder=Color3.fromHex"#6B8EA7",
Background=Color3.fromHex"#020514",
BackgroundTransparency=0.1,
Button=Color3.fromHex"#0B1E36",
Icon=Color3.fromHex"#00F2FE",
Toggle=aa:Gradient({
["0"]={Color=Color3.fromHex"#00F2FE",Transparency=0},
["100"]={Color=Color3.fromHex"#4FACFE",Transparency=0},
},{Rotation=45}),
Slider=Color3.fromHex"#00F2FE",
Checkbox=Color3.fromHex"#00F2FE",

PanelBackground=Color3.fromHex"#0A1128",
PanelBackgroundTransparency=0.4,

SliderIcon=Color3.fromHex"#00F2FE",
Primary=Color3.fromHex"#00F2FE",

LabelBackground=Color3.fromHex"#020514",
LabelBackgroundTransparency=0.7,
},
}
end end function a.v()

local aa={}

local ab=a.load'c'
local ac=ab.New local ad=
ab.Tween

function aa.New(ae,af,ag,ah,ai)
local aj=ai or 10
local ak
if af and af~=""then
ak=ac("ImageLabel",{
Image=ab.Icon(af)[1],
ImageRectSize=ab.Icon(af)[2].ImageRectSize,
ImageRectOffset=ab.Icon(af)[2].ImageRectPosition,
Size=UDim2.new(0,21,0,21),
BackgroundTransparency=1,
ThemeTag={
ImageColor3="Icon",
},
})
end

local al=ac("TextLabel",{
BackgroundTransparency=1,
TextSize=17,
FontFace=Font.new(ab.Font,Enum.FontWeight.Regular),
Size=UDim2.new(1,ak and-29 or 0,1,0),
TextXAlignment="Left",
ThemeTag={
TextColor3=ah and"Placeholder"or"Text",
},
Text=ae,
})

local am=ac("TextButton",{
Size=UDim2.new(1,0,0,42),
Parent=ag,
BackgroundTransparency=1,
Text="",
},{
ac("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
},{
ab.NewRoundFrame(aj,"Squircle",{
ThemeTag={
ImageColor3="Accent",
},
Size=UDim2.new(1,0,1,0),
ImageTransparency=0.97,
}),
ab.NewRoundFrame(aj,"Glass-1.4",{
ThemeTag={
ImageColor3="Outline",
},
Size=UDim2.new(1,0,1,0),
ImageTransparency=0.48,
},{













}),
ab.NewRoundFrame(aj,"Squircle",{
Size=UDim2.new(1,0,1,0),
Name="Frame",
ThemeTag={
ImageColor3="LabelBackground",
ImageTransparency="LabelBackgroundTransparency",
},


},{
ac("UIPadding",{
PaddingLeft=UDim.new(0,12),
PaddingRight=UDim.new(0,12),
}),
ac("UIListLayout",{
FillDirection="Horizontal",
Padding=UDim.new(0,8),
VerticalAlignment="Center",
HorizontalAlignment="Left",
}),
ak,
al,
}),
}),
})

return am
end

return aa end function a.w()

local aa={}

local ab=(cloneref or clonereference or function(ab)return ab end)


local ac=ab(game:GetService"UserInputService")

local ad=a.load'c'
local ae=ad.New local af=
ad.Tween


function aa.New(ag,ah,ai,aj)
local ak=ae("Frame",{
Size=UDim2.new(0,aj,1,0),
BackgroundTransparency=1,
Position=UDim2.new(1,0,0,0),
AnchorPoint=Vector2.new(1,0),
Parent=ah,
ZIndex=999,
Active=true,
})

local al=ad.NewRoundFrame(aj/2,"Squircle",{
Size=UDim2.new(1,0,0,0),
ImageTransparency=0.85,
ThemeTag={ImageColor3="Text"},
Parent=ak,
})

local am=ae("Frame",{
Size=UDim2.new(1,12,1,12),
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
BackgroundTransparency=1,
Active=true,
ZIndex=999,
Parent=al,
})

local an=false
local ao=0

local function updateSliderSize()
local ap=ag
local aq=ap.AbsoluteCanvasSize.Y
local ar=ap.AbsoluteWindowSize.Y

if aq<=ar then
al.Visible=false
return
end

local as=math.clamp(ar/aq,0.1,1)
al.Size=UDim2.new(1,0,as,0)
al.Visible=true
end

local function updateScrollingFramePosition()
local ap=al.Position.Y.Scale
local aq=ag.AbsoluteCanvasSize.Y
local ar=ag.AbsoluteWindowSize.Y
local as=math.max(aq-ar,0)

if as<=0 then return end

local at=math.max(1-al.Size.Y.Scale,0)
if at<=0 then return end

local au=ap/at

ag.CanvasPosition=Vector2.new(
ag.CanvasPosition.X,
au*as
)
end

local function updateThumbPosition()
if an then return end

local ap=ag.CanvasPosition.Y
local aq=ag.AbsoluteCanvasSize.Y
local ar=ag.AbsoluteWindowSize.Y
local as=math.max(aq-ar,0)

if as<=0 then
al.Position=UDim2.new(0,0,0,0)
return
end

local at=ap/as
local au=math.max(1-al.Size.Y.Scale,0)
local av=math.clamp(at*au,0,au)

al.Position=UDim2.new(0,0,av,0)
end

ad.AddSignal(ak.InputBegan,function(ap)
if(ap.UserInputType==Enum.UserInputType.MouseButton1 or ap.UserInputType==Enum.UserInputType.Touch)then
local aq=al.AbsolutePosition.Y
local ar=aq+al.AbsoluteSize.Y

if not(ap.Position.Y>=aq and ap.Position.Y<=ar)then
local as=ak.AbsolutePosition.Y
local at=ak.AbsoluteSize.Y
local au=al.AbsoluteSize.Y

local av=ap.Position.Y-as-au/2
local aw=at-au

local ax=math.clamp(av/aw,0,1-al.Size.Y.Scale)

al.Position=UDim2.new(0,0,ax,0)
updateScrollingFramePosition()
end
end
end)

ad.AddSignal(am.InputBegan,function(ap)
if ap.UserInputType==Enum.UserInputType.MouseButton1 or ap.UserInputType==Enum.UserInputType.Touch then
an=true
ao=ap.Position.Y-al.AbsolutePosition.Y

local aq
local ar

aq=ac.InputChanged:Connect(function(as)
if as.UserInputType==Enum.UserInputType.MouseMovement or as.UserInputType==Enum.UserInputType.Touch then
local at=ak.AbsolutePosition.Y
local au=ak.AbsoluteSize.Y
local av=al.AbsoluteSize.Y

local aw=as.Position.Y-at-ao
local ax=au-av

local ay=math.clamp(aw/ax,0,1-al.Size.Y.Scale)

al.Position=UDim2.new(0,0,ay,0)
updateScrollingFramePosition()
end
end)

ar=ac.InputEnded:Connect(function(as)
if as.UserInputType==Enum.UserInputType.MouseButton1 or as.UserInputType==Enum.UserInputType.Touch then
an=false
if aq then aq:Disconnect()end
if ar then ar:Disconnect()end
end
end)
end
end)

ad.AddSignal(ag:GetPropertyChangedSignal"AbsoluteWindowSize",function()
updateSliderSize()
updateThumbPosition()
end)

ad.AddSignal(ag:GetPropertyChangedSignal"AbsoluteCanvasSize",function()
updateSliderSize()
updateThumbPosition()
end)

ad.AddSignal(ag:GetPropertyChangedSignal"CanvasPosition",function()
if not an then
updateThumbPosition()
end
end)

updateSliderSize()
updateThumbPosition()

return ak
end


return aa end function a.x()
local aa={}

local ab=a.load'c'
local ac=ab.New
local ad=ab.Tween

function aa.New(ae,af,ag)
local ah={
Title=af.Title or"Tag",
Icon=af.Icon,
Color=af.Color or Color3.fromHex"#315dff",
Radius=af.Radius or 999,
Border=af.Border or false,

TagFrame=nil,
Height=26,
Padding=10,
TextSize=14,
IconSize=16,
}

local ai
if ah.Icon then
ai=ab.Image(ah.Icon,ah.Icon,0,af.Window,"Tag",false)

ai.Size=UDim2.new(0,ah.IconSize,0,ah.IconSize)
ai.ImageLabel.ImageColor3=typeof(ah.Color)=="Color3"
and ab.GetTextColorForHSB(ah.Color)
or typeof(ah.Color)=="string"
and(ab.GetTextColorForHSB(ab.GetThemeProperty(ah.Color,ab.Theme)))
end

local aj=ac("TextLabel",{
BackgroundTransparency=1,
AutomaticSize="XY",
TextSize=ah.TextSize,
FontFace=Font.new(ab.Font,Enum.FontWeight.SemiBold),
Text=ah.Title,
TextColor3=typeof(ah.Color)=="Color3"and ab.GetTextColorForHSB(ah.Color)or typeof(
ah.Color
)=="string"and(ab.GetTextColorForHSB(ab.GetThemeProperty(ah.Color,ab.Theme))),
})

local ak

if typeof(ah.Color)=="table"then
ak=ac"UIGradient"
for al,am in next,ah.Color do
ak[al]=am
end

aj.TextColor3=ab.GetTextColorForHSB(ab.GetAverageColor(ak))
if ai then
ai.ImageLabel.ImageColor3=ab.GetTextColorForHSB(ab.GetAverageColor(ak))
end
end

local al=ab.NewRoundFrame(ah.Radius,"Squircle",{
LayoutOrder=af.LayoutOrder or 0,
AutomaticSize="X",
Size=UDim2.new(0,0,0,ah.Height),
Parent=ag,
ImageColor3=typeof(ah.Color)=="Color3"and ah.Color
or typeof(ah.Color)=="table"and Color3.new(1,1,1)
or nil,
ThemeTag=typeof(ah.Color)=="string"and{
ImageColor3=ah.Color,
},
},{
ak,
ab.NewRoundFrame(ah.Radius,"Glass-1",{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="White",
},
ImageTransparency=0.75,
}),
ac("Frame",{
Size=UDim2.new(0,0,1,0),
AutomaticSize="X",
Name="Content",
BackgroundTransparency=1,
},{
ai,
aj,
ac("UIPadding",{
PaddingLeft=UDim.new(0,ah.Padding),
PaddingRight=UDim.new(0,ah.Padding),
}),
ac("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
Padding=UDim.new(0,ah.Padding/1.5),
}),
}),
})

function ah.SetTitle(am,an)
ah.Title=an
aj.Text=an

return ah
end

function ah.SetColor(am,an)
ah.Color=an
if typeof(an)=="table"then
local ao=ab.GetAverageColor(an)
ad(aj,0.06,{TextColor3=ab.GetTextColorForHSB(ao)}):Play()
local ap=al:FindFirstChildOfClass"UIGradient"or ac("UIGradient",{Parent=al})
for aq,ar in next,an do
ap[aq]=ar
end
ad(al,0.06,{ImageColor3=Color3.new(1,1,1)}):Play()
else
if ak then
ak:Destroy()
end
ad(aj,0.06,{TextColor3=ab.GetTextColorForHSB(an)}):Play()
if ai then
ad(ai.ImageLabel,0.06,{ImageColor3=ab.GetTextColorForHSB(an)}):Play()
end
ad(al,0.06,{ImageColor3=an}):Play()
end

return ah
end

function ah.SetIcon(am,an)
ah.Icon=an

if an then
ai=ab.Image(an,an,0,af.Window,"Tag",false)

ai.Size=UDim2.new(0,ah.IconSize,0,ah.IconSize)
ai.Parent=al

if typeof(ah.Color)=="Color3"then
ai.ImageLabel.ImageColor3=ab.GetTextColorForHSB(ah.Color)
elseif typeof(ah.Color)=="table"then
ai.ImageLabel.ImageColor3=ab.GetTextColorForHSB(ab.GetAverageColor(ak))
end
else
if ai then
ai:Destroy()
ai=nil
end
end
return ah
end

function ah.Destroy(am)
al:Destroy()
return ah
end

ab:OnThemeChange(function(am,an)
aj.TextColor3=ab.GetTextColorForHSB(ab.GetThemeProperty(ah.Color,ab.Theme))
ai.ImageLabel.ImageColor3=
ab.GetTextColorForHSB(ab.GetThemeProperty(ah.Color,ab.Theme))
end)

return ah
end

return aa end function a.y()

local aa=a.load'c'
local ab=aa.New
local ac=aa.Tween

local ad=Color3
local ae=UDim
local af=UDim2
local ag=Font
local ah=Enum

local ai={
Window=nil,
Bar=nil,
Version="2.0.0",
}

function ai.New(aj)
local ak={
Window=aj,
Dragging=false,
}

local al=ab("ImageLabel",{
Name="DragHandle",
Size=af.new(0,24,0,24),
BackgroundTransparency=1,
Image=aa.Icon"grip-vertical"[1],
ImageRectOffset=aa.Icon"grip-vertical"[2].ImageRectPosition,
ImageRectSize=aa.Icon"grip-vertical"[2].ImageRectSize,
ThemeTag={
ImageColor3="Accent",
},
})

local am=ab("TextLabel",{
Name="Title",
Text="INTIHUB - v"..(aj.Version or"2.0.0"),
TextSize=14,
FontFace=ag.new(aa.Font,ah.FontWeight.Bold),
ThemeTag={
TextColor3="Accent",
},
BackgroundTransparency=1,
AutomaticSize="X",
Size=af.new(0,0,1,0),
})

local an=ab("Frame",{
Name="Separator",
Size=af.new(0,1,0,18),
ThemeTag={
BackgroundColor3="Outline",
},
BackgroundTransparency=0.6,
})

local ao=ab("Frame",{
Name="IntiHubMinimizedBar",
Size=af.new(0,0,0,36),
Position=af.new(0.5,0,0.05,0),
AnchorPoint=Vector2.new(0.5,0),
BackgroundColor3=ad.fromHex"#0A0A0A",
Active=true,
Visible=false,
Parent=aj.Parent,
AutomaticSize="X",
},{
ab("UICorner",{CornerRadius=ae.new(0,8)}),
ab("UIStroke",{
Thickness=1.5,
ThemeTag={
Color="Outline",
},
Transparency=0.3,
}),
ab("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
Padding=ae.new(0,12),
HorizontalAlignment="Center",
}),
ab("UIPadding",{
PaddingLeft=ae.new(0,12),
PaddingRight=ae.new(0,16),
}),
al,
an,
am,
})

ak.Bar=ao


aa.Drag(ao,{al},function(ap)
ak.Dragging=ap
if not ap then

end
end)


local ap=ab("TextButton",{
Size=af.new(1,0,1,0),
BackgroundTransparency=1,
Text="",
Parent=am,
ZIndex=10,
})

aa.AddSignal(ap.MouseButton1Click,function()
if not ak.Dragging then
aj:Open()
end
end)

function ak.Visible(aq,ar)
if ar then
ao.Visible=true
ac(ao,0.4,{BackgroundTransparency=0},ah.EasingStyle.Quint):Play()
else
local as=ac(ao,0.3,{BackgroundTransparency=1},ah.EasingStyle.Quint)
as.Completed:Connect(function()ao.Visible=false end)
as:Play()
end
end

return ak
end

return ai end function a.z()

return{
Tab="table-of-contents",
Paragraph="type",
Button="square-mouse-pointer",
Toggle="toggle-right",
Slider="sliders-horizontal",
Keybind="command",
Input="text-cursor-input",
Dropdown="chevrons-up-down",
Code="terminal",
Colorpicker="palette",
}end function a.A()
local aa=(cloneref or clonereference or function(aa)
return aa
end)

aa(game:GetService"UserInputService")

local ab={
Margin=8,
Padding=9,
}

local ac=a.load'c'
local ad=ac.New
local ae=ac.Tween


local af=UDim
local ag=UDim2
local ah=Vector2
local ai=Font
local aj=Enum

function ab.new(ak,al,am)
local an={
IconSize=18,
Padding=14,
Radius=22,
Width=400,
MaxHeight=380,

Icons=a.load'z',
}

local ao=ad("TextBox",{
Text="",
PlaceholderText="Search...",
ThemeTag={
PlaceholderColor3="Placeholder",
TextColor3="Text",
},
Size=ag.new(1,-((an.IconSize*2)+(an.Padding*2)),0,0),
AutomaticSize="Y",
ClipsDescendants=true,
ClearTextOnFocus=false,
BackgroundTransparency=1,
TextXAlignment="Left",
FontFace=ai.new(ac.Font,aj.FontWeight.Regular),
TextSize=18,
})

local ap=ad("ImageLabel",{
Image=ac.Icon"x"[1],
ImageRectSize=ac.Icon"x"[2].ImageRectSize,
ImageRectOffset=ac.Icon"x"[2].ImageRectPosition,
BackgroundTransparency=1,
ThemeTag={
ImageColor3="Icon",
},
ImageTransparency=0.1,
Size=ag.new(0,an.IconSize,0,an.IconSize),
},{
ad("TextButton",{
Size=ag.new(1,8,1,8),
BackgroundTransparency=1,
Active=true,
ZIndex=999999999,
AnchorPoint=ah.new(0.5,0.5),
Position=ag.new(0.5,0,0.5,0),
Text="",
}),
})

local aq=ad("ScrollingFrame",{
Size=ag.new(1,0,0,0),
AutomaticCanvasSize="Y",
ScrollingDirection="Y",
ElasticBehavior="Never",
ScrollBarThickness=0,
CanvasSize=ag.new(0,0,0,0),
BackgroundTransparency=1,
Visible=false,
},{
ad("UIListLayout",{
Padding=af.new(0,0),
FillDirection="Vertical",
}),
ad("UIPadding",{
PaddingTop=af.new(0,an.Padding),
PaddingLeft=af.new(0,an.Padding),
PaddingRight=af.new(0,an.Padding),
PaddingBottom=af.new(0,an.Padding),
}),
})

local ar=ac.NewRoundFrame(an.Radius,"Squircle",{
Size=ag.new(1,0,1,0),
ThemeTag={
ImageColor3="WindowSearchBarBackground",
},
ImageTransparency=0,
},{
ac.NewRoundFrame(an.Radius,"Squircle",{
Size=ag.new(1,0,1,0),
BackgroundTransparency=1,

Visible=false,
ThemeTag={
ImageColor3="White",
},
ImageTransparency=1,
Name="Frame",
},{
ad("Frame",{
Size=ag.new(1,0,0,46),
BackgroundTransparency=1,
},{








ad("Frame",{
Size=ag.new(1,0,1,0),
BackgroundTransparency=1,
},{
ad("ImageLabel",{
Image=ac.Icon"search"[1],
ImageRectSize=ac.Icon"search"[2].ImageRectSize,
ImageRectOffset=ac.Icon"search"[2].ImageRectPosition,
BackgroundTransparency=1,
ThemeTag={
ImageColor3="Icon",
},
ImageTransparency=0.1,
Size=ag.new(0,an.IconSize,0,an.IconSize),
}),
ao,
ap,
ad("UIListLayout",{
Padding=af.new(0,an.Padding),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
ad("UIPadding",{
PaddingLeft=af.new(0,an.Padding),
PaddingRight=af.new(0,an.Padding),
}),
}),
}),
ad("Frame",{
BackgroundTransparency=1,
AutomaticSize="Y",
Size=ag.new(1,0,0,0),
Name="Results",
},{
ad("Frame",{
Size=ag.new(1,0,0,1),
ThemeTag={
BackgroundColor3="Outline",
},
BackgroundTransparency=0.9,
Visible=false,
}),
aq,
ad("UISizeConstraint",{
MaxSize=ah.new(an.Width,an.MaxHeight),
}),
}),
ad("UIListLayout",{
Padding=af.new(0,0),
FillDirection="Vertical",
}),
}),
})

local as=ad("Frame",{
Size=ag.new(0,an.Width,0,0),
AutomaticSize="Y",
Parent=al,
BackgroundTransparency=1,
Position=ag.new(0.5,0,0.45,0),
AnchorPoint=ah.new(0.5,0.5),
Visible=false,

ZIndex=99999999,
},{
ad("UIScale",{
Scale=0.9,
}),
ar,
ac.NewRoundFrame(an.Radius,"Glass-0.7",{
Size=ag.new(1,0,1,0),
BackgroundTransparency=1,


ThemeTag={
ImageColor3="SearchBarBorder",
ImageTransparency="SearchBarBorderTransparency",
},
Name="Outline",
}),
})

local function CreateSearchTab(at,au,av,aw,ax,ay)
local az=ad("TextButton",{
Size=ag.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Parent=aw or nil,
},{
ac.NewRoundFrame(an.Radius-11,"Squircle",{
Size=ag.new(1,0,0,0),
Position=ag.new(0.5,0,0.5,0),
AnchorPoint=ah.new(0.5,0.5),

ThemeTag={
ImageColor3="Text",
},
ImageTransparency=1,
Name="Main",
},{
ac.NewRoundFrame(an.Radius-11,"Glass-1",{
Size=ag.new(1,0,1,0),
Position=ag.new(0.5,0,0.5,0),
AnchorPoint=ah.new(0.5,0.5),
ThemeTag={
ImageColor3="White",
},
ImageTransparency=1,
Name="Outline",
},{








ad("UIPadding",{
PaddingTop=af.new(0,an.Padding-2),
PaddingLeft=af.new(0,an.Padding),
PaddingRight=af.new(0,an.Padding),
PaddingBottom=af.new(0,an.Padding-2),
}),
ad("ImageLabel",{
Image=ac.Icon(av)[1],
ImageRectSize=ac.Icon(av)[2].ImageRectSize,
ImageRectOffset=ac.Icon(av)[2].ImageRectPosition,
BackgroundTransparency=1,
ThemeTag={
ImageColor3="Icon",
},
ImageTransparency=0.1,
Size=ag.new(0,an.IconSize,0,an.IconSize),
}),
ad("Frame",{
Size=ag.new(1,-an.IconSize-an.Padding,0,0),
BackgroundTransparency=1,
},{
ad("TextLabel",{
Text=at,
ThemeTag={
TextColor3="Text",
},
TextSize=17,
BackgroundTransparency=1,
TextXAlignment="Left",
FontFace=ai.new(ac.Font,aj.FontWeight.Medium),
Size=ag.new(1,0,0,0),
TextTruncate="AtEnd",
AutomaticSize="Y",
Name="Title",
}),
ad("TextLabel",{
Text=au or"",
Visible=au and true or false,
ThemeTag={
TextColor3="Text",
},
TextSize=15,
TextTransparency=0.3,
BackgroundTransparency=1,
TextXAlignment="Left",
FontFace=ai.new(ac.Font,aj.FontWeight.Medium),
Size=ag.new(1,0,0,0),
TextTruncate="AtEnd",
AutomaticSize="Y",
Name="Desc",
})or nil,
ad("UIListLayout",{
Padding=af.new(0,6),
FillDirection="Vertical",
}),
}),
ad("UIListLayout",{
Padding=af.new(0,an.Padding),
FillDirection="Horizontal",
}),
}),
},true),
ad("Frame",{
Name="ParentContainer",
Size=ag.new(1,-an.Padding,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Visible=ax,

},{
ac.NewRoundFrame(99,"Squircle",{
Size=ag.new(0,2,1,0),
BackgroundTransparency=1,
ThemeTag={
ImageColor3="Text",
},
ImageTransparency=0.9,
}),
ad("Frame",{
Size=ag.new(1,-an.Padding-2,0,0),
Position=ag.new(0,an.Padding+2,0,0),
BackgroundTransparency=1,
},{
ad("UIListLayout",{
Padding=af.new(0,0),
FillDirection="Vertical",
}),
}),
}),
ad("UIListLayout",{
Padding=af.new(0,0),
FillDirection="Vertical",
HorizontalAlignment="Right",
}),
})



az.Main.Size=ag.new(
1,
0,
0,
az.Main.Outline.Frame.Desc.Visible
and(((an.Padding-2)*2)+az.Main.Outline.Frame.Title.TextBounds.Y+6+az.Main.Outline.Frame.Desc.TextBounds.Y)
or(((an.Padding-2)*2)+az.Main.Outline.Frame.Title.TextBounds.Y)
)

ac.AddSignal(az.Main.MouseEnter,function()
ae(az.Main,0.04,{ImageTransparency=0.95}):Play()
ae(az.Main.Outline,0.04,{ImageTransparency=0.75}):Play()
end)
ac.AddSignal(az.Main.InputEnded,function()
ae(az.Main,0.08,{ImageTransparency=1}):Play()
ae(az.Main.Outline,0.08,{ImageTransparency=1}):Play()
end)
ac.AddSignal(az.Main.MouseButton1Click,function()
if ay then
ay()
end
end)

return az
end

local function ContainsText(at,au)
if not au or au==""then
return false
end

if not at or at==""then
return false
end

local av=string.lower(at)
local aw=string.lower(au)

return string.find(av,aw,1,true)~=nil
end

local function Search(at)
if not at or at==""then
return{}
end

local au={}
for av,aw in next,ak.Tabs do
local ax=ContainsText(aw.Title or"",at)
local ay={}

for az,aA in next,aw.Elements do
if aA.__type~="Section"then
local aB=ContainsText(aA.Title or"",at)
local b=ContainsText(aA.Desc or"",at)

if aB or b then
ay[az]={
Title=aA.Title,
Desc=aA.Desc,
Original=aA,
__type=aA.__type,
Index=az,
}
end
end
end

if ax or next(ay)~=nil then
au[av]={
Tab=aw,
Title=aw.Title,
Icon=aw.Icon,
Elements=ay,
}
end
end
return au
end

ac.AddSignal(aq.UIListLayout:GetPropertyChangedSignal"AbsoluteContentSize",function()

ae(aq,0.06,{
Size=ag.new(
1,
0,
0,
math.clamp(
aq.UIListLayout.AbsoluteContentSize.Y+(an.Padding*2),
0,
an.MaxHeight
)
),
},aj.EasingStyle.Quint,aj.EasingDirection.InOut):Play()






end)

function an.Open(at)
task.spawn(function()
ar.Frame.Visible=true
as.Visible=true
ae(as.UIScale,0.12,{Scale=1},aj.EasingStyle.Quint,aj.EasingDirection.Out):Play()
end)
end

function an.Close(at,au)
task.spawn(function()
am()
ar.Frame.Visible=false
ae(as.UIScale,0.12,{Scale=1},aj.EasingStyle.Quint,aj.EasingDirection.Out):Play()

task.wait(0.12)
as.Visible=false
if au then
as:Destroy()
end
end)
end

ac.AddSignal(ap.TextButton.MouseButton1Click,function()
an:Close(true)
end)

an:Open()

function an.Search(at,au)
au=au or""

local av=Search(au)

aq.Visible=true
ar.Frame.Results.Frame.Visible=true
for aw,ax in next,aq:GetChildren()do
if ax.ClassName~="UIListLayout"and ax.ClassName~="UIPadding"then
ax:Destroy()
end
end

if av and next(av)~=nil then
for aw,ax in next,av do
local ay=an.Icons.Tab
local az=CreateSearchTab(ax.Title,nil,ay,aq,true,function()
an:Close()
ak:SelectTab(aw)
end)
if ax.Elements and next(ax.Elements)~=nil then
for aA,aB in next,ax.Elements do
local b=an.Icons[aB.__type]
CreateSearchTab(
aB.Title,
aB.Desc,
b,
az:FindFirstChild"ParentContainer"and az.ParentContainer.Frame
or nil,
false,
function()
an:Close()
ak:SelectTab(aw)
if ax.Tab.ScrollToTheElement then

ax.Tab:ScrollToTheElement(aB.Index)
end

end
)

end
end
end
elseif au~=""then
ad("TextLabel",{
Size=ag.new(1,0,0,70),
Text="No results found",
TextSize=16,
ThemeTag={
TextColor3="Text",
},
TextTransparency=0.2,
BackgroundTransparency=1,
FontFace=ai.new(ac.Font,aj.FontWeight.Medium),
Parent=aq,
Name="NotFound",
})
else
aq.Visible=false
ar.Frame.Results.Frame.Visible=false
end
end

ac.AddSignal(ao:GetPropertyChangedSignal"Text",function()
an:Search(ao.Text)
end)

return an
end

function ab.Init(ak)
local al={
Active=false,
Bar=nil,
}

function al.Toggle(am)
if not al.Active then
al.Active=true
al.Bar=ab.new(ak,ak.UIElements.Main,function()
al.Active=false
al.Bar=nil
end)
else
if al.Bar then
al.Bar:Close(true)
end
end
end

return al
end

return ab end function a.B()

local aa=(cloneref or clonereference or function(aa)return aa end)


local ab=aa(game:GetService"RunService")
local ac=aa(game:GetService"HttpService")

local ad

local ae
ae={
Folder=nil,
Path=nil,
Configs={},
Parser={
Colorpicker={
Save=function(af)
return{
__type=af.__type,
value=af.Default:ToHex(),
transparency=af.Transparency or nil,
}
end,
Load=function(af,ag)
if af and af.Update then
af:Update(Color3.fromHex(ag.value),ag.transparency or nil)
end
end
},
Dropdown={
Save=function(af)
return{
__type=af.__type,
value=af.Value,
}
end,
Load=function(af,ag)
if af and af.Select then
af:Select(ag.value)
end
end
},
Input={
Save=function(af)
return{
__type=af.__type,
value=af.Value,
}
end,
Load=function(af,ag)
if af and af.Set then
af:Set(ag.value)
end
end
},
Keybind={
Save=function(af)
return{
__type=af.__type,
value=af.Value,
}
end,
Load=function(af,ag)
if af and af.Set then
af:Set(ag.value)
end
end
},
Slider={
Save=function(af)
return{
__type=af.__type,
value=af.Value.Default,
}
end,
Load=function(af,ag)
if af and af.Set then
af:Set(tonumber(ag.value))
end
end
},
Toggle={
Save=function(af)
return{
__type=af.__type,
value=af.Value,
}
end,
Load=function(af,ag)
if af and af.Set then
af:Set(ag.value)
end
end
},
}
}

function ae.Init(af,ag)
if not ag.Folder then
warn"[ IntiHub.ConfigManager ] Window.Folder is not specified."
return false
end
if ab:IsStudio()or not writefile then
warn"[ IntiHub.ConfigManager ] The config system doesn't work in the studio."
return false
end

ad=ag
ae.Folder=ad.Folder
ae.Path="IntiHub_Data/"..tostring(ae.Folder).."/config/"

pcall(function()
if not isfolder"IntiHub_Data"then
makefolder"IntiHub_Data"
end
if not isfolder("IntiHub_Data/"..tostring(ae.Folder))then
makefolder("IntiHub_Data/"..tostring(ae.Folder))
end
if not isfolder(ae.Path)then
makefolder(ae.Path)
end
end)

local ah=ae:AllConfigs()

for ai,aj in next,ah do
local ak=ae.Path..aj..".json"
pcall(function()
if isfile and readfile and isfile(ak)then
ae.Configs[aj]=readfile(ak)
end
end)
end

return ae
end

function ae.SetPath(af,ag)
if not ag then
warn"[ IntiHub.ConfigManager ] Custom path is not specified."
return false
end

ae.Path=ag
if not ag:match"/$"then
ae.Path=ag.."/"
end

pcall(function()
if not isfolder(ae.Path)then
makefolder(ae.Path)
end
end)

return true
end

function ae.CreateConfig(af,ag,ah)
local ai={
Path=ae.Path..ag..".json",
Elements={},
CustomData={},
AutoLoad=ah or false,
Version=1.2,
}

if not ag then
return false,"No config file is selected"
end

function ai.SetAsCurrent(aj)
ad:SetCurrentConfig(ai)
end

function ai.Register(aj,ak,al)
ai.Elements[ak]=al
end

function ai.Set(aj,ak,al)
ai.CustomData[ak]=al
end

function ai.Get(aj,ak)
return ai.CustomData[ak]
end

function ai.SetAutoLoad(aj,ak)
ai.AutoLoad=ak
end

function ai.Save(aj)
if ad.PendingFlags then
for ak,al in next,ad.PendingFlags do
ai:Register(ak,al)
end
end

local ak={
__version=ai.Version,
__elements={},
__autoload=ai.AutoLoad,
__custom=ai.CustomData
}

for al,am in next,ai.Elements do
if ae.Parser[am.__type]then
ak.__elements[tostring(al)]=ae.Parser[am.__type].Save(am)
end
end

local al=ac:JSONEncode(ak)
pcall(function()
if writefile then
writefile(ai.Path,al)
end
end)

return ak
end

function ai.Load(aj)
if isfile and not isfile(ai.Path)then
return false,"Config file does not exist"
end

local ak,al=pcall(function()
local ak=readfile or function()
warn"[ IntiHub.ConfigManager ] The config system doesn't work in the studio."
return nil
end
return ac:JSONDecode(ak(ai.Path))
end)

if not ak then
return false,"Failed to parse config file"
end

if not al.__version then
local am={
__version=ai.Version,
__elements=al,
__custom={}
}
al=am
end

if ad.PendingFlags then
for am,an in next,ad.PendingFlags do
ai:Register(am,an)
end
end

for am,an in next,(al.__elements or{})do
if ai.Elements[am]and ae.Parser[an.__type]then
task.spawn(function()
ae.Parser[an.__type].Load(ai.Elements[am],an)
end)
end
end

ai.CustomData=al.__custom or{}

return ai.CustomData
end

function ai.Delete(aj)
if not delfile then
return false,"delfile function is not available"
end

if not isfile(ai.Path)then
return false,"Config file does not exist"
end

local ak,al=pcall(function()
delfile(ai.Path)
end)

if not ak then
return false,"Failed to delete config file: "..tostring(al)
end

ae.Configs[ag]=nil

if ad.CurrentConfig==ai then
ad.CurrentConfig=nil
end

return true,"Config deleted successfully"
end

function ai.GetData(aj)
return{
elements=ai.Elements,
custom=ai.CustomData,
autoload=ai.AutoLoad
}
end


if isfile(ai.Path)then
local aj,ak=pcall(function()
return ac:JSONDecode(readfile(ai.Path))
end)

if aj and ak and ak.__autoload then
ai.AutoLoad=true

task.spawn(function()
task.wait(0.5)
local al,am=pcall(function()
return ai:Load()
end)
if al then
if ad.Debug then print("[ IntiHub.ConfigManager ] AutoLoaded config: "..ag)end
else
warn("[ IntiHub.ConfigManager ] Failed to AutoLoad config: "..ag.." - "..tostring(am))
end
end)
end
end


ai:SetAsCurrent()
ae.Configs[ag]=ai
return ai
end

function ae.Config(af,ag,ah)
return ae:CreateConfig(ag,ah)
end

function ae.GetAutoLoadConfigs(af)
local ag={}

for ah,ai in pairs(ae.Configs)do
if ai.AutoLoad then
table.insert(ag,ah)
end
end

return ag
end

function ae.DeleteConfig(af,ag)
if not delfile then
return false,"delfile function is not available"
end

local ah=ae.Path..ag..".json"

if not isfile(ah)then
return false,"Config file does not exist"
end

local ai,aj=pcall(function()
delfile(ah)
end)

if not ai then
return false,"Failed to delete config file: "..tostring(aj)
end

ae.Configs[ag]=nil

if ad.CurrentConfig and ad.CurrentConfig.Path==ah then
ad.CurrentConfig=nil
end

return true,"Config deleted successfully"
end

function ae.AllConfigs(af)
if not listfiles then return{}end

local ag={}
pcall(function()
if not isfolder(ae.Path)then
makefolder(ae.Path)
end
end)
pcall(function()
for ah,ai in next,listfiles(ae.Path)do
local aj=ai:match"([^\\/]+)%.json$"
if aj then
table.insert(ag,aj)
end
end
end)

return ag
end

function ae.GetConfig(af,ag)
return ae.Configs[ag]
end

return ae end function a.C()
local aa={}

local ab=a.load'c'
local ac=ab.New local ad=
ab.Tween

local ae=(cloneref or clonereference or function(ae)return ae end)
ae(game:GetService"UserInputService")

function aa.New(af)
local ag={
Button=nil
}

local ah=ac("Frame",{
Name="Branding",
BackgroundTransparency=1,
AutomaticSize="XY",
},{
ac("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
Padding=UDim.new(0,6),
}),
ac("ImageLabel",{
Name="Logo",
Size=UDim2.new(0,20,0,20),
BackgroundTransparency=1,
Image=ab.GetAsset("https://raw.githubusercontent.com/Sam123mir/IntiHub-LibraryUI/main/docs/logo.png","IntiHub","Image","Logo"),
}),
ac("Frame",{
Name="TextGroup",
BackgroundTransparency=1,
AutomaticSize="XY",
},{
ac("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
Padding=UDim.new(0,2),
}),
ac("TextLabel",{
Text="INTI",
TextSize=13,
FontFace=Font.new(ab.Font,Enum.FontWeight.Bold),
BackgroundTransparency=1,
AutomaticSize="XY",
ThemeTag={
TextColor3="Accent",
},
}),
ac("TextLabel",{
Text="HUB",
TextSize=13,
FontFace=Font.new(ab.Font,Enum.FontWeight.Bold),
BackgroundTransparency=1,
AutomaticSize="XY",
TextColor3=Color3.fromHex"#FFFFFF",
}),
ac("TextLabel",{
Text=" - v2.1.2",
TextSize=12,
FontFace=Font.new(ab.Font,Enum.FontWeight.Medium),
BackgroundTransparency=1,
AutomaticSize="XY",
TextColor3=Color3.fromHex"#FFFFFF",
TextTransparency=0.4,
}),
}),
ac("TextButton",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Text="",
ZIndex=10,
Name="OpenTrigger",
})
})

local ai=ac("ImageLabel",{
Size=UDim2.new(0,18,0,18),
BackgroundTransparency=1,
Image="rbxassetid://138450125867375",
ThemeTag={
ImageColor3="Accent",
},
Active=true,
})

local aj=ac("Frame",{
Size=UDim2.new(0,1,0,16),
BackgroundColor3=Color3.new(1,1,1),
BackgroundTransparency=0.8,
BorderSizePixel=0,
})

local ak=ac("Frame",{
Size=UDim2.new(0,150,0,40),
Position=UDim2.new(0.5,0,1,-60),
AnchorPoint=Vector2.new(0.5,1),
Parent=af.Parent,
BackgroundTransparency=1,
Active=true,
Visible=false,
},{
ac("UIScale",{Name="UIScale",Scale=1})
})

local al=ac("Frame",{
Name="Bar",
AutomaticSize="X",
Size=UDim2.new(0,120,0,32),
Parent=ak,
BackgroundColor3=Color3.fromHex"#0A0A0A",
BackgroundTransparency=0.1,
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
},{
ac("UICorner",{CornerRadius=UDim.new(0,8)}),
ac("UIStroke",{
Thickness=2,
ApplyStrokeMode=Enum.ApplyStrokeMode.Border,
ThemeTag={Color="Outline"},
},{
ac("UIGradient",{
Rotation=0,
Name="GlowTrail"
})
}),
ac("UIPadding",{
PaddingLeft=UDim.new(0,12),
PaddingRight=UDim.new(0,12),
}),
ac("UIListLayout",{
Padding=UDim.new(0,10),
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Center",
}),
ai,
aj,
ah,
})

task.spawn(function()
local am=al:FindFirstChild"UIStroke"
local an=am and am:FindFirstChild"GlowTrail"
if an then
while true do
for ao=0,360,2 do
an.Rotation=ao
local ap=ab.GetThemeProperty("Outline",ab.Theme)or Color3.fromHex"#00F2FE"
local aq=Color3.new(ap.R*0.3,ap.G*0.3,ap.B*0.3)
an.Color=ColorSequence.new{
ColorSequenceKeypoint.new(0,ap),
ColorSequenceKeypoint.new(0.5,aq),
ColorSequenceKeypoint.new(1,ap),
}
task.wait(0.02)
if not al.Parent then break end
end
if not al.Parent then break end
end
end
end)

ab.Drag(ak,{ai})

ab.AddSignal(ah.OpenTrigger.MouseButton1Click,function()
af:Open()
end)


function ag.Visible(am,an)
ak.Visible=an
end

function ag.SetScale(am,an)
ak.UIScale.Scale=an
end

function ag.SetIcon(am)

end

function ag.Edit(am,an)
if an.Scale then
ag:SetScale(an.Scale)
end
end

ag.Button=al
return ag
end

return aa end function a.D()
local aa={}

local ab=a.load'c'
local ac=ab.New
local ad=ab.Tween


function aa.New(ae,af,ag,ah,ai,aj)
local ak={
Container=nil,
TooltipSize=16,

TooltipArrowSizeX=ai=="Small"and 16 or 24,
TooltipArrowSizeY=ai=="Small"and 6 or 9,

PaddingX=ai=="Small"and 12 or 14,
PaddingY=ai=="Small"and 7 or 9,

Radius=999,

TitleFrame=nil,
}

ah=ah or""
aj=aj~=false

local al=ac("TextLabel",{
AutomaticSize="XY",
TextWrapped=aj,
BackgroundTransparency=1,
FontFace=Font.new(ab.Font,Enum.FontWeight.Medium),
Text=ae,
TextSize=ai=="Small"and 15 or 17,
TextTransparency=1,
ThemeTag={
TextColor3="Tooltip"..ah.."Text",
}
})

ak.TitleFrame=al

local am=ac("UIScale",{
Scale=.9
})

local an=ac("Frame",{
AnchorPoint=Vector2.new(0.5,0),
AutomaticSize="XY",
BackgroundTransparency=1,
Parent=af,

Visible=false
},{
ac("UISizeConstraint",{
MaxSize=Vector2.new(400,math.huge)
}),
ac("Frame",{
AutomaticSize="XY",
BackgroundTransparency=1,
LayoutOrder=99,
Visible=ag,
Name="Arrow",
},{
ac("ImageLabel",{
Size=UDim2.new(0,ak.TooltipArrowSizeX,0,ak.TooltipArrowSizeY),
BackgroundTransparency=1,

Image="rbxassetid://105854070513330",
ThemeTag={
ImageColor3="Tooltip"..ah,
},
},{










}),
}),
ab.NewRoundFrame(ak.Radius,"Squircle",{
AutomaticSize="XY",
ThemeTag={
ImageColor3="Tooltip"..ah,
},
ImageTransparency=1,
Name="Background",
},{



ac("Frame",{



AutomaticSize="XY",
BackgroundTransparency=1,
},{
ac("UICorner",{
CornerRadius=UDim.new(0,16),
}),
ac("UIListLayout",{
Padding=UDim.new(0,12),
FillDirection="Horizontal",
VerticalAlignment="Center"
}),

al,
ac("UIPadding",{
PaddingTop=UDim.new(0,ak.PaddingY),
PaddingLeft=UDim.new(0,ak.PaddingX),
PaddingRight=UDim.new(0,ak.PaddingX),
PaddingBottom=UDim.new(0,ak.PaddingY),
}),
})
}),
am,
ac("UIListLayout",{
Padding=UDim.new(0,0),
FillDirection="Vertical",
VerticalAlignment="Center",
HorizontalAlignment="Center",
}),
})
ak.Container=an

function ak.Open(ao)
an.Visible=true


ad(an.Background,.2,{ImageTransparency=0},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ad(an.Arrow.ImageLabel,.2,{ImageTransparency=0},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ad(al,.2,{TextTransparency=0},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ad(am,.22,{Scale=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end

function ak.Close(ao,ap)

ad(an.Background,.3,{ImageTransparency=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ad(an.Arrow.ImageLabel,.2,{ImageTransparency=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ad(al,.3,{TextTransparency=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ad(am,.35,{Scale=.9},Enum.EasingStyle.Quint,Enum.EasingDirection.In):Play()

ap=ap~=false
if ap then
task.wait(.35)

an.Visible=false
an:Destroy()
end
end

return ak
end



return aa end function a.E()
local aa=a.load'c'
local ab=aa.New
local ac=aa.NewRoundFrame
local ad=aa.Tween

local ae=(cloneref or clonereference or function(ae)
return ae
end)

ae(game:GetService"UserInputService")

local function Color3ToHSB(af)
local ag,ah,ai=af.R,af.G,af.B
local aj=math.max(ag,ah,ai)
local ak=math.min(ag,ah,ai)
local al=aj-ak

local am=0
if al~=0 then
if aj==ag then
am=(ah-ai)/al%6
elseif aj==ah then
am=(ai-ag)/al+2
else
am=(ag-ah)/al+4
end
am=am*60
else
am=0
end

local an=(aj==0)and 0 or(al/aj)
local ao=aj

return{
h=math.floor(am+0.5),
s=an,
b=ao,
}
end

local function GetPerceivedBrightness(af)
local ag=af.R
local ah=af.G
local ai=af.B
return 0.299*ag+0.587*ah+0.114*ai
end

local function GetTextColorForHSB(af)
local ag=Color3ToHSB(af)local
ah, ai, aj=ag.h, ag.s, ag.b
if GetPerceivedBrightness(af)>0.5 then
return Color3.fromHSV(ah/360,0,0.05)
else
return Color3.fromHSV(ah/360,0,0.98)
end
end

local function getElementPosition(af,ag)
if type(ag)~="number"or ag~=math.floor(ag)then
return nil,1
end






local ah=#af


if ah==0 or ag<1 or ag>ah then
return nil,2
end

local function isDelimiter(ai)
if ai==nil then
return true
end
local aj=ai.__type
return aj=="Divider"or aj=="Space"or aj=="Section"or aj=="Code"
end

if isDelimiter(af[ag])then
return nil,3
end

local function calculate(ai,aj)
if aj==1 then
return"Squircle"
end
if ai==1 then
return"Squircle-TL-TR"
end
if ai==aj then
return"Squircle-BL-BR"
end
return"Square"
end

local ai=1
local aj=0

for ak=1,ah do
local al=af[ak]
if isDelimiter(al)then
if ag>=ai and ag<=ak-1 then
local am=ag-ai+1
return calculate(am,aj)
end
ai=ak+1
aj=0
else
aj=aj+1
end
end

if ag>=ai and ag<=ah then
local ak=ag-ai+1
return calculate(ak,aj)
end

return nil,4
end

return function(af)
local ag={
Title=af.Title,
Desc=af.Desc or nil,
Hover=af.Hover,
Thumbnail=af.Thumbnail,
ThumbnailSize=af.ThumbnailSize or 80,
Image=af.Image,
IconThemed=af.IconThemed or false,
ImageSize=af.ImageSize or 30,
Color=af.Color,
Scalable=af.Scalable,
Parent=af.Parent,
Justify=af.Justify or"Between",
UIPadding=af.Window.ElementConfig.UIPadding,
UICorner=af.Window.ElementConfig.UICorner,
Size=af.Size or"Default",
UIElements={},

Index=af.Index,
}

local ah=ag.Size=="Small"and-4 or ag.Size=="Large"and 4 or 0
local ai=ag.Size=="Small"and-4 or ag.Size=="Large"and 4 or 0

local aj=ag.ImageSize
local ak=ag.ThumbnailSize
local al=true


local am=0

local an
local ao
if ag.Thumbnail then
an=aa.Image(
ag.Thumbnail,
ag.Title,
af.Window.NewElements and ag.UICorner-11 or(ag.UICorner-4),
af.Window.Folder,
"Thumbnail",
false,
ag.IconThemed
)
an.Size=UDim2.new(1,0,0,ak)
end
if ag.Image then
ao=aa.Image(
ag.Image,
ag.Title,
af.Window.NewElements and ag.UICorner-11 or(ag.UICorner-4),
af.Window.Folder,
"Image",
ag.IconThemed,
not ag.Color and true or false,
"ElementIcon"
)
if typeof(ag.Color)=="string"and not string.find(ag.Image,"rbxthumb")then
ao.ImageLabel.ImageColor3=GetTextColorForHSB(Color3.fromHex(aa.Colors[ag.Color]))
elseif typeof(ag.Color)=="Color3"and not string.find(ag.Image,"rbxthumb")then
ao.ImageLabel.ImageColor3=GetTextColorForHSB(ag.Color)
end

ao.Size=UDim2.new(0,aj,0,aj)

am=aj
end

local function CreateText(ap,aq)
local ar=typeof(ag.Color)=="string"
and GetTextColorForHSB(Color3.fromHex(aa.Colors[ag.Color]))
or typeof(ag.Color)=="Color3"and GetTextColorForHSB(ag.Color)

return ab("TextLabel",{
BackgroundTransparency=1,
Text=ap or"",
TextSize=aq=="Desc"and 15 or 17,
TextXAlignment="Left",
ThemeTag={
TextColor3=not ag.Color and("Element"..aq)or nil,
},
TextColor3=ag.Color and ar or nil,
TextTransparency=aq=="Desc"and 0.3 or 0,
TextWrapped=true,
Size=UDim2.new(ag.Justify=="Between"and 1 or 0,0,0,0),
AutomaticSize=ag.Justify=="Between"and"Y"or"XY",
FontFace=Font.new(aa.Font,aq=="Desc"and Enum.FontWeight.Medium or Enum.FontWeight.SemiBold),
})
end

local ap=CreateText(ag.Title,"Title")
local aq=CreateText(ag.Desc,"Desc")
if not ag.Title or ag.Title==""then
aq.Visible=false
end
if not ag.Desc or ag.Desc==""then
aq.Visible=false
end

local ar=ab("Frame",{
BackgroundTransparency=1,
AutomaticSize=ag.Justify=="Between"and"Y"or"XY",
Size=UDim2.new(
ag.Justify=="Between"and 1 or 0,
ag.Justify=="Between"and(ao and-am-ag.UIPadding or-am)
or 0,
0,
0
),
Name="TextContainer",
},{
ab("UIPadding",{
PaddingTop=UDim.new(0,(af.Window.NewElements and ag.UIPadding/2 or 0)+ai),
PaddingLeft=UDim.new(0,(af.Window.NewElements and ag.UIPadding/2 or 0)+ah),
PaddingRight=UDim.new(
0,
(af.Window.NewElements and ag.UIPadding/2 or 0)+ah
),
PaddingBottom=UDim.new(
0,
(af.Window.NewElements and ag.UIPadding/2 or 0)+ai
),
}),
ab("UIListLayout",{
Padding=UDim.new(0,6),
FillDirection="Vertical",
VerticalAlignment="Center",
HorizontalAlignment="Left",
}),
ap,
aq,
})

local as=ab("Frame",{
Size=UDim2.new(
ag.Justify=="Between"and 1 or 0,
ag.Justify=="Between"and-(af.TextOffset or 0)or 0,
0,
0
),
AutomaticSize=ag.Justify=="Between"and"Y"or"XY",
BackgroundTransparency=1,
Name="MainTitleFrame",
},{
ab("UIListLayout",{
Padding=UDim.new(0,ag.UIPadding),
FillDirection="Horizontal",
VerticalAlignment=af.Window.NewElements and(ag.Justify=="Between"and"Top"or"Center")
or"Center",
HorizontalAlignment=ag.Justify~="Between"and ag.Justify or"Center",
}),
ao,
ar,
})

ag.UIElements.Title=ap
ag.UIElements.Desc=aq
ag.UIElements.MainTitleFrame=as
ag.UIElements.ContentFrame=ar

ag.UIElements.Container=ab("Frame",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
},{
ab("UIListLayout",{
Padding=UDim.new(0,ag.UIPadding),
FillDirection="Vertical",
VerticalAlignment="Center",
HorizontalAlignment=ag.Justify=="Between"and"Left"or"Center",
}),
an,
as
})





local at=aa.Image("lock","lock",0,af.Window.Folder,"Lock",false)
at.Size=UDim2.new(0,20,0,20)
at.ImageLabel.ImageColor3=Color3.new(1,1,1)
at.ImageLabel.ImageTransparency=0.4

local au=ab("TextLabel",{
Text="Locked",
TextSize=18,
FontFace=Font.new(aa.Font,Enum.FontWeight.Medium),
AutomaticSize="XY",
BackgroundTransparency=1,
TextColor3=Color3.new(1,1,1),
TextTransparency=0.05,
})

local av=ab("Frame",{
Size=UDim2.new(1,ag.UIPadding*2,1,ag.UIPadding*2),
BackgroundTransparency=1,
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
ZIndex=9999999,
})

local aw,ax=ac(ag.UICorner,"Squircle",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=0.25,
ImageColor3=Color3.new(0,0,0),
Visible=false,
Active=false,
Parent=av,
},{
ab("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Center",
Padding=UDim.new(0,8),
}),
at,
au,
},nil,true)

local ay,az=ac(ag.UICorner,"Squircle-Outline",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=1,
Active=false,
ThemeTag={
ImageColor3="Text",
},
Parent=av,
},{
ab("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Center",
Padding=UDim.new(0,8),
}),
},nil,true)

local aA,aB=ac(ag.UICorner,"Squircle",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=1,
Active=false,
ThemeTag={
ImageColor3="Text",
},
Parent=av,
},{
ab("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Center",
Padding=UDim.new(0,8),
}),
},nil,true)

local b,d=ac(ag.UICorner,"Squircle-Outline",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=1,
Active=false,
ThemeTag={
ImageColor3="Text",
},
Parent=av,
},{
ab("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Center",
Padding=UDim.new(0,8),
}),
ab("UIGradient",{
Name="HoverGradient",
Color=ColorSequence.new{
ColorSequenceKeypoint.new(0,Color3.new(1,1,1)),
ColorSequenceKeypoint.new(0.5,Color3.new(1,1,1)),
ColorSequenceKeypoint.new(1,Color3.new(1,1,1)),
},
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,1),
NumberSequenceKeypoint.new(0.25,0.9),
NumberSequenceKeypoint.new(0.5,0.3),
NumberSequenceKeypoint.new(0.75,0.9),
NumberSequenceKeypoint.new(1,1),
},
}),
},nil,true)

local f,g=ac(ag.UICorner,"Squircle",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=1,
Active=false,
ThemeTag={
ImageColor3="Text",
},
Parent=av,
},{
ab("UIGradient",{
Name="HoverGradient",
Color=ColorSequence.new{
ColorSequenceKeypoint.new(0,Color3.new(1,1,1)),
ColorSequenceKeypoint.new(0.5,Color3.new(1,1,1)),
ColorSequenceKeypoint.new(1,Color3.new(1,1,1)),
},
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,1),
NumberSequenceKeypoint.new(0.25,0.9),
NumberSequenceKeypoint.new(0.5,0.3),
NumberSequenceKeypoint.new(0.75,0.9),
NumberSequenceKeypoint.new(1,1),
},
}),
ab("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Center",
Padding=UDim.new(0,8),
}),
},nil,true)

local h,j=ac(ag.UICorner,"Squircle",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
ImageTransparency=ag.Color and 0.05 or 0.93,



Parent=af.Parent,
ThemeTag={
ImageColor3=not ag.Color and"ElementBackground"or nil,
},
ImageColor3=ag.Color and(typeof(ag.Color)=="string"and Color3.fromHex(
aa.Colors[ag.Color]
)or typeof(ag.Color)=="Color3"and ag.Color)or nil,
},{
ag.UIElements.Container,
av,
ab("UIPadding",{
PaddingTop=UDim.new(0,ag.UIPadding),
PaddingLeft=UDim.new(0,ag.UIPadding),
PaddingRight=UDim.new(0,ag.UIPadding),
PaddingBottom=UDim.new(0,ag.UIPadding),
}),
},true,true)

ag.UIElements.Main=h
ag.UIElements.Locked=aw

if ag.Hover then
aa.AddSignal(h.MouseEnter,function()
if al then
ad(h,0.12,{ImageTransparency=ag.Color and 0.15 or 0.9}):Play()
ad(f,0.12,{ImageTransparency=0.9}):Play()
ad(b,0.12,{ImageTransparency=0.8}):Play()
aa.AddSignal(h.MouseMoved,function(l,m)
f.HoverGradient.Offset=
Vector2.new(((l-h.AbsolutePosition.X)/h.AbsoluteSize.X)-0.5,0)
b.HoverGradient.Offset=
Vector2.new(((l-h.AbsolutePosition.X)/h.AbsoluteSize.X)-0.5,0)
end)
end
end)
aa.AddSignal(h.InputEnded,function()
if al then
ad(h,0.12,{ImageTransparency=ag.Color and 0.05 or 0.93}):Play()
ad(f,0.12,{ImageTransparency=1}):Play()
ad(b,0.12,{ImageTransparency=1}):Play()
end
end)
end

function ag.SetTitle(l,m)
ag.Title=m
ap.Text=m
end

function ag.SetDesc(l,m)
ag.Desc=m
aq.Text=m or""
if not m then
aq.Visible=false
elseif not aq.Visible then
aq.Visible=true
end
end

function ag.Colorize(l,m,p)
if ag.Color then
m[p]=typeof(ag.Color)=="string"
and GetTextColorForHSB(Color3.fromHex(aa.Colors[ag.Color]))
or typeof(ag.Color)=="Color3"and GetTextColorForHSB(ag.Color)
or nil
end
end

if af.ElementTable then
aa.AddSignal(ap:GetPropertyChangedSignal"Text",function()
if ag.Title~=ap.Text then
ag:SetTitle(ap.Text)
af.ElementTable.Title=ap.Text
end
end)
aa.AddSignal(aq:GetPropertyChangedSignal"Text",function()
if ag.Desc~=aq.Text then
ag:SetDesc(aq.Text)
af.ElementTable.Desc=aq.Text
end
end)
end





function ag.SetThumbnail(l,m,p)
ag.Thumbnail=m
if p then
ag.ThumbnailSize=p
ak=p
end

if an then
if m then
an:Destroy()
an=aa.Image(
m,
ag.Title,
ag.UICorner-3,
af.Window.Folder,
"Thumbnail",
false,
ag.IconThemed
)
an.Size=UDim2.new(1,0,0,ak)
an.Parent=ag.UIElements.Container
local r=ag.UIElements.Container:FindFirstChild"UIListLayout"
if r then
an.LayoutOrder=-1
end
else
an.Visible=false
end
else
if m then
an=aa.Image(
m,
ag.Title,
ag.UICorner-3,
af.Window.Folder,
"Thumbnail",
false,
ag.IconThemed
)
an.Size=UDim2.new(1,0,0,ak)
an.Parent=ag.UIElements.Container
local r=ag.UIElements.Container:FindFirstChild"UIListLayout"
if r then
an.LayoutOrder=-1
end
end
end
end

function ag.SetImage(l,m,p)
ag.Image=m
if p then
ag.ImageSize=p
aj=p
end

if m then
local r=ao.Parent
ao:Destroy()

ao=aa.Image(
m,
m,
ag.UICorner-3,
af.Window.Folder,
"Image",
not ag.Color and true or false
)

if typeof(ag.Color)=="string"and not string.find(ag.Image,"rbxthumb")then
ao.ImageLabel.ImageColor3=GetTextColorForHSB(Color3.fromHex(aa.Colors[ag.Color]))
elseif typeof(ag.Color)=="Color3"and not string.find(ag.Image,"rbxthumb")then
ao.ImageLabel.ImageColor3=GetTextColorForHSB(ag.Color)
end

ao.Visible=true
ao.Parent=r
ao.LayoutOrder=-99

ao.Size=UDim2.new(0,aj,0,aj)
am=ag.ImageSize+ag.UIPadding
else
if ao then
ao.Visible=true
end
am=0
end

ag.UIElements.Container.TitleFrame.TitleFrame.Size=UDim2.new(1,-am,1,0)
end

function ag.Destroy(l)
h:Destroy()
end

function ag.Lock(l,m)
al=false
aw.Active=true
aw.Visible=true
au.Text=m or"Locked"
end

function ag.Unlock(l)
al=true
aw.Active=false
aw.Visible=false
end

function ag.Highlight(l)
local m=ab("UIGradient",{
Color=ColorSequence.new{
ColorSequenceKeypoint.new(0,Color3.new(1,1,1)),
ColorSequenceKeypoint.new(0.5,Color3.new(1,1,1)),
ColorSequenceKeypoint.new(1,Color3.new(1,1,1)),
},
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,1),
NumberSequenceKeypoint.new(0.1,0.9),
NumberSequenceKeypoint.new(0.5,0.3),
NumberSequenceKeypoint.new(0.9,0.9),
NumberSequenceKeypoint.new(1,1),
},
Rotation=0,
Offset=Vector2.new(-1,0),
Parent=ay,
})

local p=ab("UIGradient",{
Color=ColorSequence.new{
ColorSequenceKeypoint.new(0,Color3.new(1,1,1)),
ColorSequenceKeypoint.new(0.5,Color3.new(1,1,1)),
ColorSequenceKeypoint.new(1,Color3.new(1,1,1)),
},
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,1),
NumberSequenceKeypoint.new(0.15,0.8),
NumberSequenceKeypoint.new(0.5,0.1),
NumberSequenceKeypoint.new(0.85,0.8),
NumberSequenceKeypoint.new(1,1),
},
Rotation=0,
Offset=Vector2.new(-1,0),
Parent=aA,
})

ay.ImageTransparency=0.65
aA.ImageTransparency=0.88

ad(m,0.75,{
Offset=Vector2.new(1,0),
}):Play()

ad(p,0.75,{
Offset=Vector2.new(1,0),
}):Play()

task.spawn(function()
task.wait(0.75)
ay.ImageTransparency=1
aA.ImageTransparency=1
m:Destroy()
p:Destroy()
end)
end

function ag.UpdateShape(l)
if af.Window.NewElements then
local m
if af.ParentConfig.ParentType=="Group"then
m="Squircle"
else
m=getElementPosition(l.Elements,ag.Index)
end

if m and h then
j:SetType(m)
ax:SetType(m)
aB:SetType(m)
az:SetType(m.."-Outline")
g:SetType(m)
d:SetType(m.."-Outline")
end
end
end





return ag
end end function a.F()

local aa=a.load'c'local ab=
aa.New

local ac={}

function ac.New(ad,ae)
local af={
__type="Paragraph",
Title=ae.Title or"Note",
Content=ae.Content or"",
UIElements={}
}

af.Frame=a.load'E'{
Title=af.Title,
Desc=af.Content,
Parent=ae.Parent,
Window=ae.Window,
Hover=false,
Tab=ae.Tab,
Index=ae.Index,
ElementTable=af,
ParentConfig=ae,
}

function af.SetTitle(ag,ah)
af.Title=ah
af.Frame:SetTitle(ah)
end

function af.SetContent(ag,ah)
af.Content=ah
af.Frame:SetDesc(ah)
end

return af.__type,af
end

return ac end function a.G()
local aa=a.load'c'local ab=
aa.New

local ac={}

function ac.New(ad,ae)
local af={
__type="Button",
Title=ae.Title or"Button",
Desc=ae.Desc or nil,
Icon=ae.Icon or"mouse-pointer-click",
IconThemed=ae.IconThemed or false,
Color=ae.Color,
Justify=ae.Justify or"Between",
IconAlign=ae.IconAlign or"Right",
Locked=ae.Locked or false,
LockedTitle=ae.LockedTitle,
Callback=ae.Callback or function()end,
UIElements={}
}

local ag=true

af.ButtonFrame=a.load'E'{
Title=af.Title,
Desc=af.Desc,
Parent=ae.Parent,




Window=ae.Window,
Color=af.Color,
Justify=af.Justify,
TextOffset=20,
Hover=true,
Scalable=true,
Tab=ae.Tab,
Index=ae.Index,
ElementTable=af,
ParentConfig=ae,
Size=ae.Size,
}














af.UIElements.ButtonIcon=aa.Image(
af.Icon,
af.Icon,
0,
ae.Window.Folder,
"Button",
not af.Color and true or nil,
af.IconThemed
)

af.UIElements.ButtonIcon.Size=UDim2.new(0,20,0,20)
af.UIElements.ButtonIcon.Parent=af.Justify=="Between"and af.ButtonFrame.UIElements.Main or af.ButtonFrame.UIElements.Container.TitleFrame
af.UIElements.ButtonIcon.LayoutOrder=af.IconAlign=="Left"and-99999 or 99999
af.UIElements.ButtonIcon.AnchorPoint=Vector2.new(1,0.5)
af.UIElements.ButtonIcon.Position=UDim2.new(1,0,0.5,0)

af.ButtonFrame:Colorize(af.UIElements.ButtonIcon.ImageLabel,"ImageColor3")

function af.Lock(ah)
af.Locked=true
ag=false
return af.ButtonFrame:Lock(af.LockedTitle)
end
function af.Unlock(ah)
af.Locked=false
ag=true
return af.ButtonFrame:Unlock()
end

if af.Locked then
af:Lock()
end

aa.AddSignal(af.ButtonFrame.UIElements.Main.MouseButton1Click,function()
if ag then
task.spawn(function()
aa.SafeCallback(af.Callback)
end)
end
end)
return af.__type,af
end

return ac end function a.H()
local aa={}

local ab=a.load'c'
local ac=ab.New
local ad=ab.Tween

local ae=game:GetService"UserInputService"

function aa.New(af,ag,ah,ai,aj,ak,al)
local am={}

local an=12
local ao
if ag and ag~=""then
ao=ac("ImageLabel",{
Size=UDim2.new(0,13,0,13),
BackgroundTransparency=1,
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Image=ab.Icon(ag)[1],
ImageRectOffset=ab.Icon(ag)[2].ImageRectPosition,
ImageRectSize=ab.Icon(ag)[2].ImageRectSize,
ImageTransparency=1,
ImageColor3=Color3.new(0,0,0),
})
end

local ap=ac("Frame",{
Size=UDim2.new(0,2,0,26),
BackgroundTransparency=1,
Parent=ai,
})

local aq=ab.NewRoundFrame(an,"Squircle",{
ImageTransparency=.85,
ThemeTag={
ImageColor3="Text"
},
Parent=ap,
Size=UDim2.new(0,ak and(52)or(40.8),0,24),
AnchorPoint=Vector2.new(1,0.5),
Position=UDim2.new(0,0,0.5,0),
},{
ab.NewRoundFrame(an,"Squircle",{
Size=UDim2.new(1,0,1,0),
Name="Layer",
ThemeTag={
ImageColor3="Toggle",
},
ImageTransparency=1,
}),
ab.NewRoundFrame(an,"SquircleOutline",{
Size=UDim2.new(1,0,1,0),
Name="Stroke",
ImageColor3=Color3.new(1,1,1),
ImageTransparency=1,
},{
ac("UIGradient",{
Rotation=90,
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,0),
NumberSequenceKeypoint.new(1,1),
}
})
}),


ab.NewRoundFrame(an,"Squircle",{
Size=UDim2.new(0,ak and 30 or 20,0,20),
Position=UDim2.new(0,2,0.5,0),
AnchorPoint=Vector2.new(0,0.5),
ImageTransparency=1,
Name="Frame",
},{
ab.NewRoundFrame(an,"Squircle",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=0,
ThemeTag={
ImageColor3="ToggleBar",
},
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Name="Bar"
},{
ab.NewRoundFrame(an,"Glass-1",{
Size=UDim2.new(1,0,1,0),
ImageColor3=Color3.new(1,1,1),
Name="Highlight",
ImageTransparency=0.4,
},{













}),
ao,
ac("UIScale",{
Scale=1,
})
}),
})
})

local ar
local as

local at=ak and 30 or 20
local au=aq.Size.X.Offset

function am.Set(av,aw,ax,ay)
if not ay then
if aw then
ad(aq.Frame,0.15,{
Position=UDim2.new(0,au-at-2,0.5,0),
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
else
ad(aq.Frame,0.15,{
Position=UDim2.new(0,2,0.5,0),
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
else
if aw then
aq.Frame.Position=UDim2.new(0,au-at-2,0.5,0)
else
aq.Frame.Position=UDim2.new(0,2,0.5,0)
end
end

if aw then
ad(aq.Layer,0.1,{
ImageTransparency=0,
}):Play()

if ao then
ad(ao,0.1,{
ImageTransparency=0,
}):Play()
end
else
ad(aq.Layer,0.1,{
ImageTransparency=1,
}):Play()

if ao then
ad(ao,0.1,{
ImageTransparency=1,
}):Play()
end
end

ax=ax~=false

task.spawn(function()
if aj and ax then
ab.SafeCallback(aj,aw)
end
end)
end


function am.Animate(av,aw,ax)
if not al.Window.IsToggleDragging then
al.Window.IsToggleDragging=true

local ay=aw.Position.X
local az=aw.Position.Y
local aA=aq.Frame.Position.X.Offset
local aB=false

ad(aq.Frame.Bar.UIScale,0.28,{Scale=1.5},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ad(aq.Frame.Bar,0.28,{ImageTransparency=.85},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

if ar then
ar:Disconnect()
end

ar=ae.InputChanged:Connect(function(b)
if al.Window.IsToggleDragging and(b.UserInputType==Enum.UserInputType.MouseMovement or b.UserInputType==Enum.UserInputType.Touch)then
if aB then
return
end

local d=math.abs(b.Position.X-ay)
local f=math.abs(b.Position.Y-az)

if f>d and f>10 then
aB=true
al.Window.IsToggleDragging=false

if ar then
ar:Disconnect()
ar=nil
end
if as then
as:Disconnect()
as=nil
end

ad(aq.Frame,0.15,{
Position=UDim2.new(0,aA,0.5,0)
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

ad(aq.Frame.Bar.UIScale,0.23,{Scale=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ad(aq.Frame.Bar,0.23,{ImageTransparency=0},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
return
end

local g=b.Position.X-ay
local h=math.max(2,math.min(aA+g,au-at-2))local j=

(aq.Frame.Position.X.Offset-2)/(au-at-4)

ad(aq.Frame,0.05,{
Position=UDim2.new(0,h,0.5,0)
},Enum.EasingStyle.Linear,Enum.EasingDirection.Out):Play()





end
end)

if as then
as:Disconnect()
end

as=ae.InputEnded:Connect(function(b)
if al.Window.IsToggleDragging and(b.UserInputType==Enum.UserInputType.MouseButton1 or b.UserInputType==Enum.UserInputType.Touch)then
al.Window.IsToggleDragging=false

if ar then
ar:Disconnect()
ar=nil
end

if as then
as:Disconnect()
as=nil
end

if aB then
return
end

local d=aq.Frame.Position.X.Offset
local f=math.abs(b.Position.X-ay)

if f<10 then
local g=not ax.Value
ax:Set(g,true,false)
else
local g=d+at/2
local h=au/2
local j=g>h
ax:Set(j,true,false)
end

ad(aq.Frame.Bar.UIScale,0.23,{Scale=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ad(aq.Frame.Bar,0.23,{ImageTransparency=0},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end)
end
end

return ap,am
end

return aa end function a.I()
local aa={}

local ab=a.load'c'local ac=
ab.New
local ad=ab.Tween


function aa.New(ae,af,ag,ah,ai,aj)
local ak={}

af=af or"sfsymbols:checkmark"

local al=9

local am=ab.Image(
af,
af,
0,
(aj and aj.Window.Folder or"Temp"),
"Checkbox",
true,
false,
"CheckboxIcon"
)
am.Size=UDim2.new(1,-26+ag,1,-26+ag)
am.AnchorPoint=Vector2.new(0.5,0.5)
am.Position=UDim2.new(0.5,0,0.5,0)


local an=ab.NewRoundFrame(al,"Squircle",{
ImageTransparency=.85,
ThemeTag={
ImageColor3="Text"
},
Parent=ah,
Size=UDim2.new(0,26,0,26),
},{
ab.NewRoundFrame(al,"Squircle",{
Size=UDim2.new(1,0,1,0),
Name="Layer",
ThemeTag={
ImageColor3="Checkbox",
},
ImageTransparency=1,
}),
ab.NewRoundFrame(al,"Glass-1.4",{
Size=UDim2.new(1,0,1,0),
Name="Stroke",
ThemeTag={
ImageColor3="CheckboxBorder",
ImageTransparency="CheckboxBorderTransparency",
},
},{







}),

am,
})

function ak.Set(ao,ap)
if ap then
ad(an.Layer,0.06,{
ImageTransparency=0,
}):Play()



ad(am.ImageLabel,0.06,{
ImageTransparency=0,
}):Play()
else
ad(an.Layer,0.05,{
ImageTransparency=1,
}):Play()



ad(am.ImageLabel,0.06,{
ImageTransparency=1,
}):Play()
end

task.spawn(function()
if ai then
ab.SafeCallback(ai,ap)
end
end)
end

return an,ak
end


return aa end function a.J()
local aa=a.load'c'local ab=
aa.New local ac=
aa.Tween

local ad=a.load'H'.New
local ae=a.load'I'.New

local af={}

function af.New(ag,ah)
local ai={
__type="Toggle",
Title=ah.Title or"Toggle",
Desc=ah.Desc or nil,
Locked=ah.Locked or false,
LockedTitle=ah.LockedTitle,
Value=ah.Value,
Icon=ah.Icon or nil,
IconSize=ah.IconSize or 23,
Type=ah.Type or"Toggle",
Callback=ah.Callback or function()end,
UIElements={}
}
ai.ToggleFrame=a.load'E'{
Title=ai.Title,
Desc=ai.Desc,




Window=ah.Window,
Parent=ah.Parent,
TextOffset=(52),
Hover=false,
Tab=ah.Tab,
Index=ah.Index,
ElementTable=ai,
ParentConfig=ah,
}

local aj=true

if ai.Value==nil then
ai.Value=false
end



function ai.Lock(ak)
ai.Locked=true
aj=false
return ai.ToggleFrame:Lock(ai.LockedTitle)
end
function ai.Unlock(ak)
ai.Locked=false
aj=true
return ai.ToggleFrame:Unlock()
end

if ai.Locked then
ai:Lock()
end

local ak=ai.Value

local al,am
if ai.Type=="Toggle"then
al,am=ad(ak,ai.Icon,ai.IconSize,ai.ToggleFrame.UIElements.Main,ai.Callback,ah.Window.NewElements,ah)
elseif ai.Type=="Checkbox"then
al,am=ae(ak,ai.Icon,ai.IconSize,ai.ToggleFrame.UIElements.Main,ai.Callback,ah)
else
error("Unknown Toggle Type: "..tostring(ai.Type))
end

al.AnchorPoint=Vector2.new(1,ah.Window.NewElements and 0 or 0.5)
al.Position=UDim2.new(1,0,ah.Window.NewElements and 0 or 0.5,0)

function ai.Set(an,ao,ap,aq)
if aj then
am:Set(ao,ap,aq or false)
ak=ao
ai.Value=ao
end
end

ai:Set(ak,false,ah.Window.NewElements)


if ah.Window.NewElements and am.Animate then
aa.AddSignal(ai.ToggleFrame.UIElements.Main.InputBegan,function(an)
if not ah.Window.IsToggleDragging and(an.UserInputType==Enum.UserInputType.MouseButton1 or an.UserInputType==Enum.UserInputType.Touch)then
am:Animate(an,ai)
end
end)






else
aa.AddSignal(ai.ToggleFrame.UIElements.Main.MouseButton1Click,function()
ai:Set(not ai.Value,nil,ah.Window.NewElements)
end)
end

return ai.__type,ai
end

return af end function a.K()
local aa=(cloneref or clonereference or function(aa)return aa end)

local ac=aa(game:GetService"UserInputService")
aa(game:GetService"RunService")

local ad=a.load'c'
local ae=ad.New
local af=ad.Tween

local ag=Color3
local ah=UDim
local ai=UDim2
local aj=Vector2
local ak=Font
local al=Enum
local am=math

local an={}

function an.New(ao,ap)
local aq=ap.Min or(typeof(ap.Value)=="table"and ap.Value.Min)or 0
local ar=ap.Max or(typeof(ap.Value)=="table"and ap.Value.Max)or 100
local as=ap.Default or(typeof(ap.Value)=="table"and ap.Value.Default)or(typeof(ap.Value)=="number"and ap.Value)or 50

local at={
__type="Slider",
Title=ap.Title or"Slider",
Desc=ap.Desc or nil,
Locked=ap.Locked or nil,
LockedTitle=ap.LockedTitle,
Value={Min=aq,Max=ar,Default=as},
Icons=ap.Icons or nil,
IsTooltip=ap.IsTooltip or false,
IsTextbox=ap.IsTextbox,
Step=ap.Step or 1,
Callback=ap.Callback or function()end,
UIElements={},
IsFocusing=false,

Width=ap.Width or 180,
TextBoxWidth=40,
ThumbSize=12,
IconSize=22,

IsHolding=false,
}

if at.IsTextbox==nil then
at.IsTextbox=true
end

local au
local av
local aw=at.Value.Default or at.Value.Min or 0

local ax=aw
local ay=am.clamp((aw-(at.Value.Min or 0))/((at.Value.Max or 100)-(at.Value.Min or 0)),0,1)

local az=at.Step%1~=0

local function FormatValue(aA)
if az then
return tonumber(string.format("%.2f",aA))
end
return am.floor(aA+0.5)
end

local function CalculateValue(aA)
return am.floor(aA/at.Step+0.5)*at.Step
end

local aA,aB
if at.Icons then
if at.Icons.From then
aA=ad.Image(at.Icons.From,"SliderFrom",0,ap.Window.Folder,"Slider",true,true,"Accent")
aA.Size=ai.new(0,at.IconSize,0,at.IconSize)
end
if at.Icons.To then
aB=ad.Image(at.Icons.To,"SliderTo",0,ap.Window.Folder,"Slider",true,true,"Accent")
aB.Size=ai.new(0,at.IconSize,0,at.IconSize)
end
end

local b
if at.IsTextbox then
b=ae("TextBox",{
Text=FormatValue(aw),
TextSize=13,
FontFace=ak.new(ad.Font,al.FontWeight.Bold),
TextColor3=ag.new(1,1,1),
BackgroundTransparency=0.85,
BackgroundColor3=ag.new(1,1,1),
Size=ai.new(0,at.TextBoxWidth,0,24),
ThemeTag={BorderColor3="Accent"},
},{
ae("UICorner",{CornerRadius=ah.new(0,5)}),
ae("UIStroke",{Thickness=1.2,ThemeTag={Color="Outline"},Transparency=0.4}),
})
end

at.SliderFrame=a.load'E'{
Title=at.Title,
Desc=at.Desc,
Parent=ap.Parent,
TextOffset=at.Width+10,
Hover=true,
Tab=ap.Tab,
Index=ap.Index,
Window=ap.Window,
ElementTable=at,
ParentConfig=ap,
}

local d=ae("Frame",{
Size=ai.new(0,at.Width,0,24),
BackgroundTransparency=1,
LayoutOrder=10,
Parent=at.SliderFrame.UIElements.Main,
AnchorPoint=aj.new(1,0.5),
Position=ai.new(1,0,0.5,0),
},{
ae("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
Padding=ah.new(0,8),
HorizontalAlignment="Right",
}),
aA,
ae("Frame",{
Name="SliderBack",
Size=ai.new(1,(aA and-30 or 0)+(aB and-30 or 0)+(at.IsTextbox and-at.TextBoxWidth-10 or 0),0,24),
BackgroundTransparency=1,
},{

ad.NewRoundFrame(99,"Squircle",{
Name="Track",
Size=ai.new(1,0,0,4),
Position=ai.new(0,0,0.5,0),
AnchorPoint=aj.new(0,0.5),
ImageTransparency=0.5,
ImageColor3=ag.fromRGB(60,60,60),
},{

ad.NewRoundFrame(99,"Squircle",{
Name="Fill",
Size=ai.new(ay,0,1,0),
ThemeTag={ImageColor3="Slider"},
},{

ad.NewRoundFrame(99,"Squircle",{
Name="Thumb",
Size=ai.new(0,14,0,14),
Position=ai.new(1,0,0.5,0),
AnchorPoint=aj.new(0.5,0.5),
ThemeTag={ImageColor3="Accent"},
},{
ae("UIStroke",{Thickness=1.5,ThemeTag={Color="Outline"},Transparency=0.2}),
})
})
})
}),
aB,
b,
})

local f=d.SliderBack

local function UpdateSlider(g)
local h=g.Position.X
local j=am.clamp((h-f.AbsolutePosition.X)/f.AbsoluteSize.X,0,1)
local l=CalculateValue(at.Value.Min+j*(at.Value.Max-at.Value.Min))
l=am.clamp(l,at.Value.Min,at.Value.Max)

if l~=ax then
ax=l
at.Value.Default=l
local m=(l-at.Value.Min)/(at.Value.Max-at.Value.Min)
af(f.Track.Fill,0.1,{Size=ai.new(m,0,1,0)},al.EasingStyle.Quint,al.EasingDirection.Out):Play()
if b then b.Text=tostring(FormatValue(l))end
ad.SafeCallback(at.Callback,l)
end
end

function at.Set(g,h)
h=am.clamp(CalculateValue(h),at.Value.Min,at.Value.Max)
local j=(h-at.Value.Min)/(at.Value.Max-at.Value.Min)
ax=h
at.Value.Default=h
af(f.Track.Fill,0.2,{Size=ai.new(j,0,1,0)},al.EasingStyle.Quint,al.EasingDirection.Out):Play()
if b then b.Text=tostring(FormatValue(h))end
ad.SafeCallback(at.Callback,h)
end

ad.AddSignal(f.InputBegan,function(g)
if(g.UserInputType==al.UserInputType.MouseButton1 or g.UserInputType==al.UserInputType.Touch)and not at.Locked then
at.IsHolding=true
UpdateSlider(g)

au=ac.InputChanged:Connect(function(h)
if h.UserInputType==al.UserInputType.MouseMovement or h.UserInputType==al.UserInputType.Touch then
UpdateSlider(h)
end
end)

av=ac.InputEnded:Connect(function(h)
if h.UserInputType==al.UserInputType.MouseButton1 or h.UserInputType==al.UserInputType.Touch then
at.IsHolding=false
if au then au:Disconnect()end
if av then av:Disconnect()end
end
end)
end
end)

if b then
ad.AddSignal(b.FocusLost,function()
local g=tonumber(b.Text)
if g then
at:Set(g)
else
b.Text=tostring(FormatValue(ax))
end
end)
end

return at.__type,at
end

return an end function a.L()
local aa=(cloneref or clonereference or function(aa)return aa end)

local ac=aa(game:GetService"UserInputService")

local ad=a.load'c'
local ae=ad.New local af=
ad.Tween

local ag={
UICorner=6,
UIPadding=8,
}

local ah=a.load'v'.New

function ag.New(ai,aj)
local function NormalizeKeyCode(ak)
if typeof(ak)=="EnumItem"then
return ak.Name
elseif type(ak)=="string"then
return ak
else
return"F"
end
end

local ak={
__type="Keybind",
Title=aj.Title or"Keybind",
Desc=aj.Desc or nil,
Locked=aj.Locked or false,
LockedTitle=aj.LockedTitle,
Value=NormalizeKeyCode(aj.Value)or"F",
Callback=aj.Callback or function()end,
CanChange=aj.CanChange or true,
Picking=false,
UIElements={},
}

local al=true

ak.KeybindFrame=a.load'E'{
Title=ak.Title,
Desc=ak.Desc,
Parent=aj.Parent,
TextOffset=85,
Hover=ak.CanChange,
Tab=aj.Tab,
Index=aj.Index,
Window=aj.Window,
ElementTable=ak,
ParentConfig=aj,
}

ak.UIElements.Keybind=ah(ak.Value,nil,ak.KeybindFrame.UIElements.Main,nil,aj.Window.NewElements and 12 or 10)

ak.UIElements.Keybind.Size=UDim2.new(
0,24
+ak.UIElements.Keybind.Frame.Frame.TextLabel.TextBounds.X,
0,
42
)
ak.UIElements.Keybind.AnchorPoint=Vector2.new(1,0.5)
ak.UIElements.Keybind.Position=UDim2.new(1,0,0.5,0)

ae("UIScale",{
Parent=ak.UIElements.Keybind,
Scale=.85,
})

ad.AddSignal(ak.UIElements.Keybind.Frame.Frame.TextLabel:GetPropertyChangedSignal"TextBounds",function()
ak.UIElements.Keybind.Size=UDim2.new(
0,24
+ak.UIElements.Keybind.Frame.Frame.TextLabel.TextBounds.X,
0,
42
)
end)

function ak.Lock(am)
ak.Locked=true
al=false
return ak.KeybindFrame:Lock(ak.LockedTitle)
end
function ak.Unlock(am)
ak.Locked=false
al=true
return ak.KeybindFrame:Unlock()
end

function ak.Set(am,an)
local ao=NormalizeKeyCode(an)
ak.Value=ao
ak.UIElements.Keybind.Frame.Frame.TextLabel.Text=ao
end

if ak.Locked then
ak:Lock()
end

ad.AddSignal(ak.KeybindFrame.UIElements.Main.MouseButton1Click,function()
if al then
if ak.CanChange then
ak.Picking=true
ak.UIElements.Keybind.Frame.Frame.TextLabel.Text="..."

task.wait(0.2)

local am
am=ac.InputBegan:Connect(function(an)
local ao

if an.UserInputType==Enum.UserInputType.Keyboard then
ao=an.KeyCode.Name
elseif an.UserInputType==Enum.UserInputType.MouseButton1 then
ao="MouseLeft"
elseif an.UserInputType==Enum.UserInputType.MouseButton2 then
ao="MouseRight"
end

local ap
ap=ac.InputEnded:Connect(function(aq)
if aq.KeyCode.Name==ao or ao=="MouseLeft"and aq.UserInputType==Enum.UserInputType.MouseButton1 or ao=="MouseRight"and aq.UserInputType==Enum.UserInputType.MouseButton2 then
ak.Picking=false

ak.UIElements.Keybind.Frame.Frame.TextLabel.Text=ao
ak.Value=ao

am:Disconnect()
ap:Disconnect()
end
end)
end)
end
end
end)

ad.AddSignal(ac.InputBegan,function(am,an)
if ac:GetFocusedTextBox()then
return
end

if not al then
return
end

if am.UserInputType==Enum.UserInputType.Keyboard then
if am.KeyCode.Name==ak.Value then
ad.SafeCallback(ak.Callback,am.KeyCode.Name)
end
elseif am.UserInputType==Enum.UserInputType.MouseButton1 and ak.Value=="MouseLeft"then
ad.SafeCallback(ak.Callback,"MouseLeft")
elseif am.UserInputType==Enum.UserInputType.MouseButton2 and ak.Value=="MouseRight"then
ad.SafeCallback(ak.Callback,"MouseRight")
end
end)

return ak.__type,ak
end

return ag end function a.M()
local aa=a.load'c'
local ac=aa.New local ad=
aa.Tween

local ae={
UICorner=8,
UIPadding=8,
}local af=a.load'l'


.New
local ag=a.load'm'.New

function ae.New(ah,ai)
local aj={
__type="Input",
Title=ai.Title or"Input",
Desc=ai.Desc or nil,
Type=ai.Type or"Input",
Locked=ai.Locked or false,
LockedTitle=ai.LockedTitle,
InputIcon=ai.InputIcon or false,
Placeholder=ai.Placeholder or"Enter Text...",
Value=ai.Value or"",
Callback=ai.Callback or function()end,
ClearTextOnFocus=ai.ClearTextOnFocus or false,
UIElements={},

Width=150,
}

local ak=true

aj.InputFrame=a.load'E'{
Title=aj.Title,
Desc=aj.Desc,
Parent=ai.Parent,
TextOffset=aj.Width,
Hover=false,
Tab=ai.Tab,
Index=ai.Index,
Window=ai.Window,
ElementTable=aj,
ParentConfig=ai,
}

local al=ag(
aj.Placeholder,
aj.InputIcon,
aj.Type=="Textarea"and aj.InputFrame.UIElements.Container or aj.InputFrame.UIElements.Main,
aj.Type,
function(al)
aj:Set(al,true)
end,
nil,
ai.Window.NewElements and 12 or 10,
aj.ClearTextOnFocus
)

if aj.Type=="Input"then
al.Size=UDim2.new(0,aj.Width,0,36)
al.Position=UDim2.new(1,0,ai.Window.NewElements and 0 or 0.5,0)
al.AnchorPoint=Vector2.new(1,ai.Window.NewElements and 0 or 0.5)
else
al.Size=UDim2.new(1,0,0,148)
end

ac("UIScale",{
Parent=al,
Scale=1,
})

function aj.Lock(am)
aj.Locked=true
ak=false
return aj.InputFrame:Lock(aj.LockedTitle)
end
function aj.Unlock(am)
aj.Locked=false
ak=true
return aj.InputFrame:Unlock()
end


function aj.Set(am,an,ao)
if ak then
aj.Value=an
aa.SafeCallback(aj.Callback,an)

if not ao then
al.Frame.Frame.TextBox.Text=an
end
end
end

function aj.SetPlaceholder(am,an)
al.Frame.Frame.TextBox.PlaceholderText=an
aj.Placeholder=an
end

aj:Set(aj.Value)

if aj.Locked then
aj:Lock()
end

return aj.__type,aj
end

return ae end function a.N()
local aa=a.load'c'
local ac=aa.New

local ae={}

function ae.New(af,ag)
local ah=ac("Frame",{
Size=ag.ParentType~="Group"and UDim2.new(1,0,0,1)or UDim2.new(0,1,1,0),
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
BackgroundTransparency=.9,
ThemeTag={
BackgroundColor3="Text"
}
})
local ai=ac("Frame",{
Parent=ag.Parent,
Size=ag.ParentType~="Group"and UDim2.new(1,-7,0,7)or UDim2.new(0,7,1,-7),
BackgroundTransparency=1,
},{
ah
})

return"Divider",{__type="Divider",ElementFrame=ai}
end

return ae end function a.O()
local aa={}

local ac=(cloneref or clonereference or function(ac)
return ac
end)

local ae=ac(game:GetService"UserInputService")
local af=ac(game:GetService"Players").LocalPlayer:GetMouse()
local ag=ac(game:GetService"Workspace").CurrentCamera

local ah=workspace.CurrentCamera

local ai=a.load'm'.New

local aj=a.load'c'
local ak=aj.New
local al=aj.Tween

function aa.New(am,an,ao,ap,aq)
local ar={}

if not an.Callback then
aq="Menu"
end

an.UIElements.UIListLayout=ak("UIListLayout",{
Padding=UDim.new(0,ao.MenuPadding/1.5),
FillDirection="Vertical",
HorizontalAlignment="Center",
})

an.UIElements.Menu=aj.NewRoundFrame(ao.MenuCorner,"Squircle",{
ThemeTag={
ImageColor3="Background",
},
ImageTransparency=1,
Size=UDim2.new(1,0,1,0),
AnchorPoint=Vector2.new(1,0),
Position=UDim2.new(1,0,0,0),
Name="MenuFrame"
},{
ak("UIPadding",{
PaddingTop=UDim.new(0,ao.MenuPadding),
PaddingLeft=UDim.new(0,ao.MenuPadding),
PaddingRight=UDim.new(0,ao.MenuPadding),
PaddingBottom=UDim.new(0,ao.MenuPadding),
}),
ak("UIListLayout",{
FillDirection="Vertical",
Padding=UDim.new(0,ao.MenuPadding),
}),
ak("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,an.SearchBarEnabled and-ao.MenuPadding-ao.SearchBarHeight or 0),
Name="ContentContainer",
ClipsDescendants=true,
LayoutOrder=999,
},{
ak("UICorner",{
CornerRadius=UDim.new(0,ao.MenuCorner-ao.MenuPadding),
}),
ak("ScrollingFrame",{
Size=UDim2.new(1,0,1,0),
ScrollBarThickness=0,
ScrollingDirection="Y",
AutomaticCanvasSize="Y",
CanvasSize=UDim2.new(0,0,0,0),
BackgroundTransparency=1,
ScrollBarImageTransparency=1,
Name="ScrollingFrame"
},{
an.UIElements.UIListLayout,
}),
}),
})

an.UIElements.MenuCanvas=ak("Frame",{
Size=UDim2.new(0,an.MenuWidth,0,300),
BackgroundTransparency=1,
Parent=am.IntiHub.DropdownGui,
AnchorPoint=Vector2.new(1,0),
Name="DropdownCanvas",
Position=UDim2.new(-10,0,-10,0),
Visible=false,
Active=false,
ZIndex=20000000,
},{
an.UIElements.Menu,
ak("UISizeConstraint",{
MinSize=Vector2.new(170,0),
MaxSize=Vector2.new(300,400),
}),
})

local function RecalculateCanvasSize()
local as=an.UIElements.Menu:FindFirstChild"ContentContainer"and an.UIElements.Menu.ContentContainer:FindFirstChild"ScrollingFrame"
if as then
as.CanvasSize=UDim2.fromOffset(0,an.UIElements.UIListLayout.AbsoluteContentSize.Y)
end
end

local function RecalculateListSize()
local as=ah.ViewportSize.Y*0.6

local at=an.UIElements.UIListLayout.AbsoluteContentSize.Y
local au=an.SearchBarEnabled and(ao.SearchBarHeight+(ao.MenuPadding*3))
or(ao.MenuPadding*2)
local av=at+au

if av>as then
an.UIElements.MenuCanvas.Size=
UDim2.fromOffset(an.UIElements.MenuCanvas.AbsoluteSize.X,as)
else
an.UIElements.MenuCanvas.Size=
UDim2.fromOffset(an.UIElements.MenuCanvas.AbsoluteSize.X,av)
end
end

function UpdatePosition()
local as=an.UIElements.Dropdown or an.DropdownFrame.UIElements.Main
local at=an.UIElements.MenuCanvas

local au=ag.ViewportSize.Y
-(as.AbsolutePosition.Y+as.AbsoluteSize.Y)
-ao.MenuPadding
-54
local av=at.AbsoluteSize.Y+ao.MenuPadding

local aw=-54
if au<av then
aw=av-au-54
end

at.Position=UDim2.new(
0,
as.AbsolutePosition.X+as.AbsoluteSize.X,
0,
as.AbsolutePosition.Y+as.AbsoluteSize.Y-aw+(ao.MenuPadding*2)
)
end

local as

function ar.Display(at)
local au=an.Values
local av=""

if an.Multi then
local aw={}
if typeof(an.Value)=="table"then
for ax,ay in ipairs(an.Value)do
local az=typeof(ay)=="table"and ay.Title or ay
aw[az]=true
end
end

for ax,ay in ipairs(au)do
local az=typeof(ay)=="table"and ay.Title or ay
if aw[az]then
av=av..az..", "
end
end

if#av>0 then
av=av:sub(1,#av-2)
end
else
av=typeof(an.Value)=="table"and an.Value.Title or an.Value or""
end

if an.UIElements.Dropdown then
an.UIElements.Dropdown.Frame.Frame.TextLabel.Text=(av==""and"--"or av)
end
end

local function Callback(at)
ar:Display()
if an.Callback then
task.spawn(function()
aj.SafeCallback(an.Callback,an.Value)
end)
else
task.spawn(function()
aj.SafeCallback(at)
end)
end
end

function ar.LockValues(at,au)
if not au then
return
end

for av,aw in next,an.Tabs do
if aw and aw.UIElements and aw.UIElements.TabItem then
local ax=aw.Name
local ay=false

for az,aA in next,au do
if ax==aA then
ay=true
break
end
end

if ay then
al(aw.UIElements.TabItem,0.1,{ImageTransparency=1}):Play()
al(aw.UIElements.TabItem.Highlight,0.1,{ImageTransparency=1}):Play()
al(aw.UIElements.TabItem.Frame.Title.TextLabel,0.1,{TextTransparency=0.6}):Play()
if aw.UIElements.TabIcon then
al(aw.UIElements.TabIcon.ImageLabel,0.1,{ImageTransparency=0.6}):Play()
end

aw.UIElements.TabItem.Active=false
aw.Locked=true
else
if aw.Selected then
al(aw.UIElements.TabItem,0.1,{ImageTransparency=0.95}):Play()
al(aw.UIElements.TabItem.Highlight,0.1,{ImageTransparency=0.75}):Play()
al(aw.UIElements.TabItem.Frame.Title.TextLabel,0.1,{TextTransparency=0}):Play()
if aw.UIElements.TabIcon then
al(aw.UIElements.TabIcon.ImageLabel,0.1,{ImageTransparency=0}):Play()
end
else
al(aw.UIElements.TabItem,0.1,{ImageTransparency=1}):Play()
al(aw.UIElements.TabItem.Highlight,0.1,{ImageTransparency=1}):Play()
al(
aw.UIElements.TabItem.Frame.Title.TextLabel,
0.1,
{TextTransparency=aq=="Dropdown"and 0.4 or 0.05}
):Play()
if aw.UIElements.TabIcon then
al(
aw.UIElements.TabIcon.ImageLabel,
0.1,
{ImageTransparency=aq=="Dropdown"and 0.2 or 0}
):Play()
end
end

aw.UIElements.TabItem.Active=true
aw.Locked=false
end
end
end
end

function ar.Refresh(at,au)
for av,aw in next,an.UIElements.Menu.ContentContainer.ScrollingFrame:GetChildren()do
if not aw:IsA"UIListLayout"then
aw:Destroy()
end
end

an.Tabs={}

if an.SearchBarEnabled then
if not as then
as=ai("Search...","search",an.UIElements.Menu,nil,function(av)
for aw,ax in next,an.Tabs do
if string.find(string.lower(ax.Name),string.lower(av),1,true)then
ax.UIElements.TabItem.Visible=true
else
ax.UIElements.TabItem.Visible=false
end
RecalculateListSize()
RecalculateCanvasSize()
end
end,true)
as.Size=UDim2.new(1,0,0,ao.SearchBarHeight)
as.Position=UDim2.new(0,0,0,0)
as.Name="SearchBar"
end
end

for av,aw in next,au do
if aw.Type~="Divider"then
local ax={
Name=typeof(aw)=="table"and aw.Title or aw,
Desc=typeof(aw)=="table"and aw.Desc or nil,
Icon=typeof(aw)=="table"and aw.Icon or nil,
IconSize=typeof(aw)=="table"and aw.IconSize or nil,
Original=aw,
Selected=false,
Locked=typeof(aw)=="table"and aw.Locked or false,
UIElements={},
}
local ay
if ax.Icon then
ay=aj.Image(ax.Icon,ax.Icon,0,am.Window.Folder,"Dropdown",true)
ay.Size=
UDim2.new(0,ax.IconSize or ao.TabIcon,0,ax.IconSize or ao.TabIcon)
ay.ImageLabel.ImageTransparency=aq=="Dropdown"and 0.2 or 0
ax.UIElements.TabIcon=ay
end
ax.UIElements.TabItem=aj.NewRoundFrame(
ao.MenuCorner-ao.MenuPadding,
"Squircle",
{
Size=UDim2.new(1,0,0,36),
AutomaticSize=ax.Desc and"Y",
ImageTransparency=1,
Parent=an.UIElements.Menu.ContentContainer.ScrollingFrame,
ImageColor3=Color3.new(1,1,1),
Active=not ax.Locked,
},
{
aj.NewRoundFrame(ao.MenuCorner-ao.MenuPadding,"Glass-1.4",{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="DropdownTabBorder",
},
ImageTransparency=1,
Name="Highlight",
},{













}),
ak("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
},{
ak("UIListLayout",{
Padding=UDim.new(0,ao.TabPadding),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
ak("UIPadding",{
PaddingTop=UDim.new(0,ao.TabPadding),
PaddingLeft=UDim.new(0,ao.TabPadding),
PaddingRight=UDim.new(0,ao.TabPadding),
PaddingBottom=UDim.new(0,ao.TabPadding),
}),
ak("UICorner",{
CornerRadius=UDim.new(0,ao.MenuCorner-ao.MenuPadding),
}),
ay,
ak("Frame",{
Size=UDim2.new(1,ay and-ao.TabPadding-ao.TabIcon or 0,0,0),
BackgroundTransparency=1,
AutomaticSize="Y",
Name="Title",
},{
ak("TextLabel",{
Text=ax.Name,
TextXAlignment="Left",
FontFace=Font.new(aj.Font,Enum.FontWeight.Medium),
ThemeTag={
TextColor3="Text",
BackgroundColor3="Text",
},
TextSize=15,
BackgroundTransparency=1,
TextTransparency=aq=="Dropdown"and 0.4 or 0.05,
LayoutOrder=999,
AutomaticSize="Y",
Size=UDim2.new(1,0,0,0),
}),
ak("TextLabel",{
Text=ax.Desc or"",
TextXAlignment="Left",
FontFace=Font.new(aj.Font,Enum.FontWeight.Regular),
ThemeTag={
TextColor3="Text",
BackgroundColor3="Text",
},
TextSize=15,
BackgroundTransparency=1,
TextTransparency=aq=="Dropdown"and 0.6 or 0.35,
LayoutOrder=999,
AutomaticSize="Y",
TextWrapped=true,
Size=UDim2.new(1,0,0,0),
Visible=ax.Desc and true or false,
Name="Desc",
}),
ak("UIListLayout",{
Padding=UDim.new(0,ao.TabPadding/3),
FillDirection="Vertical",
}),
}),
}),
},
true
)

if ax.Locked then
ax.UIElements.TabItem.Frame.Title.TextLabel.TextTransparency=0.6
if ax.UIElements.TabIcon then
ax.UIElements.TabIcon.ImageLabel.ImageTransparency=0.6
end
end

if an.Multi and typeof(an.Value)=="string"then
for az,aA in next,an.Values do
if typeof(aA)=="table"then
if aA.Title==an.Value then
an.Value={aA}
end
else
if aA==an.Value then
an.Value={an.Value}
end
end
end
end

if an.Multi then
local az=false
if typeof(an.Value)=="table"then
for aA,aB in ipairs(an.Value)do
local b=typeof(aB)=="table"and aB.Title or aB
if b==ax.Name then
az=true
break
end
end
end
ax.Selected=az
else
local az=typeof(an.Value)=="table"and an.Value.Title or an.Value
ax.Selected=az==ax.Name
end

if ax.Selected and not ax.Locked then
ax.UIElements.TabItem.ImageTransparency=0.95
ax.UIElements.TabItem.Highlight.ImageTransparency=0.75
ax.UIElements.TabItem.Frame.Title.TextLabel.TextTransparency=0
if ax.UIElements.TabIcon then
ax.UIElements.TabIcon.ImageLabel.ImageTransparency=0
end
end

an.Tabs[av]=ax

ar:Display()

if aq=="Dropdown"then
aj.AddSignal(ax.UIElements.TabItem.MouseButton1Click,function()
if ax.Locked then
return
end

if an.Multi then
if not ax.Selected then
ax.Selected=true
al(ax.UIElements.TabItem,0.1,{ImageTransparency=0.95}):Play()
al(ax.UIElements.TabItem.Highlight,0.1,{ImageTransparency=0.75}):Play()
al(ax.UIElements.TabItem.Frame.Title.TextLabel,0.1,{TextTransparency=0}):Play()
if ax.UIElements.TabIcon then
al(ax.UIElements.TabIcon.ImageLabel,0.1,{ImageTransparency=0}):Play()
end
table.insert(an.Value,ax.Original)
else
if not an.AllowNone and#an.Value==1 then
return
end
ax.Selected=false
al(ax.UIElements.TabItem,0.1,{ImageTransparency=1}):Play()
al(ax.UIElements.TabItem.Highlight,0.1,{ImageTransparency=1}):Play()
al(ax.UIElements.TabItem.Frame.Title.TextLabel,0.1,{TextTransparency=0.4}):Play()
if ax.UIElements.TabIcon then
al(ax.UIElements.TabIcon.ImageLabel,0.1,{ImageTransparency=0.2}):Play()
end

for az,aA in next,an.Value do
if typeof(aA)=="table"and(aA.Title==ax.Name)or(aA==ax.Name)then
table.remove(an.Value,az)
break
end
end
end
else
for az,aA in next,an.Tabs do
al(aA.UIElements.TabItem,0.1,{ImageTransparency=1}):Play()
al(aA.UIElements.TabItem.Highlight,0.1,{ImageTransparency=1}):Play()
al(
aA.UIElements.TabItem.Frame.Title.TextLabel,
0.1,
{TextTransparency=0.4}
):Play()
if aA.UIElements.TabIcon then
al(aA.UIElements.TabIcon.ImageLabel,0.1,{ImageTransparency=0.2}):Play()
end
aA.Selected=false
end
ax.Selected=true
al(ax.UIElements.TabItem,0.1,{ImageTransparency=0.95}):Play()
al(ax.UIElements.TabItem.Highlight,0.1,{ImageTransparency=0.75}):Play()
al(ax.UIElements.TabItem.Frame.Title.TextLabel,0.1,{TextTransparency=0}):Play()
if ax.UIElements.TabIcon then
al(ax.UIElements.TabIcon.ImageLabel,0.1,{ImageTransparency=0}):Play()
end
an.Value=ax.Original
end
Callback()
end)
elseif aq=="Menu"then
if not ax.Locked then
aj.AddSignal(ax.UIElements.TabItem.MouseEnter,function()
al(ax.UIElements.TabItem,0.08,{ImageTransparency=0.95}):Play()
end)
aj.AddSignal(ax.UIElements.TabItem.InputEnded,function()
al(ax.UIElements.TabItem,0.08,{ImageTransparency=1}):Play()
end)
end
aj.AddSignal(ax.UIElements.TabItem.MouseButton1Click,function()
if ax.Locked then
return
end
Callback(aw.Callback or function()end)
end)
end

RecalculateCanvasSize()
RecalculateListSize()
else a.load'N'
:New{Parent=an.UIElements.Menu.ContentContainer.ScrollingFrame}
end
end










an.UIElements.MenuCanvas.Size=UDim2.new(
0,
an.MenuWidth+6+6+5+5+18+6+6,
an.UIElements.MenuCanvas.Size.Y.Scale,
an.UIElements.MenuCanvas.Size.Y.Offset
)
Callback()

an.Values=au
end

ar:Refresh(an.Values)

function ar.Select(at,au)
if au then
an.Value=au
else
if an.Multi then
an.Value={}
else
an.Value=nil
end
end
ar:Refresh(an.Values)
end

RecalculateListSize()
RecalculateCanvasSize()

function ar.Open(at)
if ap then
an.UIElements.Menu.Visible=true
an.UIElements.MenuCanvas.Visible=true
an.UIElements.MenuCanvas.Active=true
an.UIElements.Menu.Size=UDim2.new(1,0,0,0)
al(an.UIElements.Menu,0.1,{
Size=UDim2.new(1,0,1,0),
ImageTransparency=0.05,
},Enum.EasingStyle.Quart,Enum.EasingDirection.Out):Play()

task.spawn(function()
task.wait(0.1)
an.Opened=true
end)

UpdatePosition()
end
end

function ar.Close(at)
an.Opened=false

al(an.UIElements.Menu,0.25,{
Size=UDim2.new(1,0,0,0),
ImageTransparency=1,
},Enum.EasingStyle.Quart,Enum.EasingDirection.Out):Play()

task.spawn(function()
task.wait(0.1)
an.UIElements.Menu.Visible=false
end)

task.spawn(function()
task.wait(0.25)
an.UIElements.MenuCanvas.Visible=false
an.UIElements.MenuCanvas.Active=false
end)
end

aj.AddSignal(
(
an.UIElements.Dropdown and an.UIElements.Dropdown.MouseButton1Click
or an.DropdownFrame.UIElements.Main.MouseButton1Click
),
function()
ar:Open()
end
)

aj.AddSignal(ae.InputBegan,function(at)
if
at.UserInputType==Enum.UserInputType.MouseButton1
or at.UserInputType==Enum.UserInputType.Touch
then
local au=an.UIElements.MenuCanvas
local av,aw=au.AbsolutePosition,au.AbsoluteSize

local ax=an.UIElements.Dropdown or an.DropdownFrame.UIElements.Main
local ay=ax.AbsolutePosition
local az=ax.AbsoluteSize

local aA=af.X>=ay.X
and af.X<=ay.X+az.X
and af.Y>=ay.Y
and af.Y<=ay.Y+az.Y

local aB=af.X>=av.X
and af.X<=av.X+aw.X
and af.Y>=av.Y
and af.Y<=av.Y+aw.Y

if am.Window.CanDropdown and an.Opened and not aA and not aB then
ar:Close()
end
end
end)

aj.AddSignal(
an.UIElements.Dropdown and an.UIElements.Dropdown:GetPropertyChangedSignal"AbsolutePosition"
or an.DropdownFrame.UIElements.Main:GetPropertyChangedSignal"AbsolutePosition",
UpdatePosition
)

return ar
end

return aa end function a.P()

local aa=(cloneref or clonereference or function(aa)
return aa
end)

aa(game:GetService"UserInputService")
aa(game:GetService"Players").LocalPlayer:GetMouse()local ac=
aa(game:GetService"Workspace").CurrentCamera

local ae=a.load'c'
local af=ae.New local ag=
ae.Tween

local ah=a.load'v'.New local ai=a.load'm'
.New
local aj=a.load'O'.New local ak=

workspace.CurrentCamera

local al={
UICorner=10,
UIPadding=12,
MenuCorner=15,
MenuPadding=5,
TabPadding=10,
SearchBarHeight=39,
TabIcon=18,
}

function al.New(am,an)
local ao={
__type="Dropdown",
Title=an.Title or"Dropdown",
Desc=an.Desc or nil,
Locked=an.Locked or false,
LockedTitle=an.LockedTitle,
Values=an.Values or an.Options or{},
MenuWidth=an.MenuWidth or 180,
Value=an.Value or an.Default,
AllowNone=an.AllowNone,
SearchBarEnabled=an.SearchBarEnabled or false,
Multi=an.Multi,
Callback=an.Callback or nil,

UIElements={},

Opened=false,
Tabs={},

Width=150,
}

if ao.Multi and not ao.Value then
ao.Value={}
end
if ao.Values and typeof(ao.Value)=="number"then
ao.Value=ao.Values[ao.Value]
end

local ap=true

ao.DropdownFrame=a.load'E'{
Title=ao.Title,
Desc=ao.Desc,
Parent=an.Parent,
TextOffset=ao.Callback and ao.Width or 20,
Hover=not ao.Callback and true or false,
Tab=an.Tab,
Index=an.Index,
Window=an.Window,
ElementTable=ao,
ParentConfig=an,
}

if ao.Callback then
ao.UIElements.Dropdown=
ah("",nil,ao.DropdownFrame.UIElements.Main,nil,an.Window.NewElements and 12 or 10)

ao.UIElements.Dropdown.Frame.Frame.TextLabel.TextTruncate="AtEnd"
ao.UIElements.Dropdown.Frame.Frame.TextLabel.Size=
UDim2.new(1,ao.UIElements.Dropdown.Frame.Frame.TextLabel.Size.X.Offset-18-12-12,0,0)

ao.UIElements.Dropdown.Size=UDim2.new(0,ao.Width,0,36)
ao.UIElements.Dropdown.Position=UDim2.new(1,0,an.Window.NewElements and 0 or 0.5,0)
ao.UIElements.Dropdown.AnchorPoint=Vector2.new(1,an.Window.NewElements and 0 or 0.5)





end

ao.DropdownMenu=aj(an,ao,al,ap,"Dropdown")

ao.Display=ao.DropdownMenu.Display
ao.Refresh=ao.DropdownMenu.Refresh
ao.Select=ao.DropdownMenu.Select
ao.Open=ao.DropdownMenu.Open
ao.Close=ao.DropdownMenu.Close

af("ImageLabel",{
Image=ae.Icon"chevrons-up-down"[1],
ImageRectOffset=ae.Icon"chevrons-up-down"[2].ImageRectPosition,
ImageRectSize=ae.Icon"chevrons-up-down"[2].ImageRectSize,
Size=UDim2.new(0,18,0,18),
Position=UDim2.new(1,ao.UIElements.Dropdown and-12 or 0,0.5,0),
ThemeTag={
ImageColor3="Icon",
},
AnchorPoint=Vector2.new(1,0.5),
Parent=ao.UIElements.Dropdown and ao.UIElements.Dropdown.Frame
or ao.DropdownFrame.UIElements.Main,
})

function ao.Lock(aq)
ao.Locked=true
ap=false
return ao.DropdownFrame:Lock(ao.LockedTitle)
end
function ao.Unlock(aq)
ao.Locked=false
ap=true
return ao.DropdownFrame:Unlock()
end

if ao.Locked then
ao:Lock()
end

return ao.__type,ao
end

return al end function a.Q()







local aa={}
local ae={
lua={
"and","break","or","else","elseif","if","then","until","repeat","while","do","for","in","end",
"local","return","function","export",
},
rbx={
"game","workspace","script","math","string","table","task","wait","select","next","Enum",
"tick","assert","shared","loadstring","tonumber","tostring","type",
"typeof","unpack","Instance","CFrame","Vector3","Vector2","Color3","UDim","UDim2","Ray","BrickColor",
"OverlapParams","RaycastParams","Axes","Random","Region3","Rect","TweenInfo",
"collectgarbage","not","utf8","pcall","xpcall","_G","setmetatable","getmetatable","os","pairs","ipairs"
},
operators={
"#","+","-","*","%","/","^","=","~","=","<",">",
}
}

local af={
numbers=Color3.fromHex"#FAB387",
boolean=Color3.fromHex"#FAB387",
operator=Color3.fromHex"#94E2D5",
lua=Color3.fromHex"#CBA6F7",
rbx=Color3.fromHex"#F38BA8",
str=Color3.fromHex"#A6E3A1",
comment=Color3.fromHex"#9399B2",
null=Color3.fromHex"#F38BA8",
call=Color3.fromHex"#89B4FA",
self_call=Color3.fromHex"#89B4FA",
local_property=Color3.fromHex"#CBA6F7",
}

local function createKeywordSet(ah)
local aj={}
for ak,al in ipairs(ah)do
aj[al]=true
end
return aj
end

local ah=createKeywordSet(ae.lua)
local aj=createKeywordSet(ae.rbx)
local ak=createKeywordSet(ae.operators)

local function getHighlight(al,am)
local an=al[am]

if af[an.."_color"]then
return af[an.."_color"]
end

if tonumber(an)then
return af.numbers
elseif an=="nil"then
return af.null
elseif an:sub(1,2)=="--"then
return af.comment
elseif ak[an]then
return af.operator
elseif ah[an]then
return af.lua
elseif aj[an]then
return af.rbx
elseif an:sub(1,1)=="\""or an:sub(1,1)=="\'"then
return af.str
elseif an=="true"or an=="false"then
return af.boolean
end

if al[am+1]=="("then
if al[am-1]==":"then
return af.self_call
end

return af.call
end

if al[am-1]=="."then
if al[am-2]=="Enum"then
return af.rbx
end

return af.local_property
end
end

function aa.run(al)
local am={}
local an=""

local ao=false
local ap=false
local aq=false

for ar=1,#al do
local as=al:sub(ar,ar)

if ap then
if as=="\n"and not aq then
table.insert(am,an)
table.insert(am,as)
an=""

ap=false
elseif al:sub(ar-1,ar)=="]]"and aq then
an=an.."]"

table.insert(am,an)
an=""

ap=false
aq=false
else
an=an..as
end
elseif ao then
if as==ao and al:sub(ar-1,ar-1)~="\\"or as=="\n"then
an=an..as
ao=false
else
an=an..as
end
else
if al:sub(ar,ar+1)=="--"then
table.insert(am,an)
an="-"
ap=true
aq=al:sub(ar+2,ar+3)=="[["
elseif as=="\""or as=="\'"then
table.insert(am,an)
an=as
ao=as
elseif ak[as]then
table.insert(am,an)
table.insert(am,as)
an=""
elseif as:match"[%w_]"then
an=an..as
else
table.insert(am,an)
table.insert(am,as)
an=""
end
end
end

table.insert(am,an)

local ar={}

for as,at in ipairs(am)do
local au=getHighlight(am,as)

if au then
local av=string.format("<font color = \"#%s\">%s</font>",au:ToHex(),at:gsub("<","&lt;"):gsub(">","&gt;"))

table.insert(ar,av)
else
table.insert(ar,at)
end
end

return table.concat(ar)
end

return aa end function a.R()
local aa={}

local ae=a.load'c'
local af=ae.New
local ah=ae.Tween

local aj=a.load'Q'

function aa.New(ak,al,am,an,ao)
local ap={
Radius=12,
Padding=10
}

local aq=af("TextLabel",{
Text="",
TextColor3=Color3.fromHex"#CDD6F4",
TextTransparency=0,
TextSize=14,
TextWrapped=false,
LineHeight=1.15,
RichText=true,
TextXAlignment="Left",
Size=UDim2.new(0,0,0,0),
BackgroundTransparency=1,
AutomaticSize="XY",
},{
af("UIPadding",{
PaddingTop=UDim.new(0,ap.Padding+3),
PaddingLeft=UDim.new(0,ap.Padding+3),
PaddingRight=UDim.new(0,ap.Padding+3),
PaddingBottom=UDim.new(0,ap.Padding+3),
})
})
aq.Font="Code"

local ar=af("ScrollingFrame",{
Size=UDim2.new(1,0,0,0),
BackgroundTransparency=1,
AutomaticCanvasSize="X",
ScrollingDirection="X",
ElasticBehavior="Never",
CanvasSize=UDim2.new(0,0,0,0),
ScrollBarThickness=0,
},{
aq
})

local as=af("TextButton",{
BackgroundTransparency=1,
Size=UDim2.new(0,30,0,30),
Position=UDim2.new(1,-ap.Padding/2,0,ap.Padding/2),
AnchorPoint=Vector2.new(1,0),
Visible=an and true or false,
},{
ae.NewRoundFrame(ap.Radius-4,"Squircle",{



ImageColor3=Color3.fromHex"#ffffff",
ImageTransparency=1,
Size=UDim2.new(1,0,1,0),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Name="Button",
},{
af("UIScale",{
Scale=1,
}),
af("ImageLabel",{
Image=ae.Icon"copy"[1],
ImageRectSize=ae.Icon"copy"[2].ImageRectSize,
ImageRectOffset=ae.Icon"copy"[2].ImageRectPosition,
BackgroundTransparency=1,
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Size=UDim2.new(0,12,0,12),



ImageColor3=Color3.fromHex"#ffffff",
ImageTransparency=.1,
})
})
})

ae.AddSignal(as.MouseEnter,function()
ah(as.Button,.05,{ImageTransparency=.95}):Play()
ah(as.Button.UIScale,.05,{Scale=.9}):Play()
end)
ae.AddSignal(as.InputEnded,function()
ah(as.Button,.08,{ImageTransparency=1}):Play()
ah(as.Button.UIScale,.08,{Scale=1}):Play()
end)

local at=ae.NewRoundFrame(ap.Radius,"Squircle",{



ImageColor3=Color3.fromHex"#212121",
ImageTransparency=.035,
Size=UDim2.new(1,0,0,20+(ap.Padding*2)),
AutomaticSize="Y",
Parent=am,
},{
ae.NewRoundFrame(ap.Radius,"SquircleOutline",{
Size=UDim2.new(1,0,1,0),



ImageColor3=Color3.fromHex"#ffffff",
ImageTransparency=.955,
}),
af("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
},{
ae.NewRoundFrame(ap.Radius,"Squircle-TL-TR",{



ImageColor3=Color3.fromHex"#ffffff",
ImageTransparency=.96,
Size=UDim2.new(1,0,0,20+(ap.Padding*2)),
Visible=al and true or false
},{
af("ImageLabel",{
Size=UDim2.new(0,18,0,18),
BackgroundTransparency=1,
Image="rbxassetid://132464694294269",



ImageColor3=Color3.fromHex"#ffffff",
ImageTransparency=.2,
}),
af("TextLabel",{
Text=al,



TextColor3=Color3.fromHex"#ffffff",
TextTransparency=.2,
TextSize=16,
AutomaticSize="Y",
FontFace=Font.new(ae.Font,Enum.FontWeight.Medium),
TextXAlignment="Left",
BackgroundTransparency=1,
TextTruncate="AtEnd",
Size=UDim2.new(1,as and-20-(ap.Padding*2),0,0)
}),
af("UIPadding",{

PaddingLeft=UDim.new(0,ap.Padding+3),
PaddingRight=UDim.new(0,ap.Padding+3),

}),
af("UIListLayout",{
Padding=UDim.new(0,ap.Padding),
FillDirection="Horizontal",
VerticalAlignment="Center",
})
}),
ar,
af("UIListLayout",{
Padding=UDim.new(0,0),
FillDirection="Vertical",
})
}),
as,
})

ap.CodeFrame=at

ae.AddSignal(aq:GetPropertyChangedSignal"TextBounds",function()
ar.Size=UDim2.new(1,0,0,(aq.TextBounds.Y/(ao or 1))+((ap.Padding+3)*2))
end)

function ap.Set(au)
aq.Text=aj.run(au)
end

function ap.Destroy()
at:Destroy()
ap=nil
end

ap.Set(ak)

ae.AddSignal(as.MouseButton1Click,function()
if an then
an()
local au=ae.Icon"check"
as.Button.ImageLabel.Image=au[1]
as.Button.ImageLabel.ImageRectSize=au[2].ImageRectSize
as.Button.ImageLabel.ImageRectOffset=au[2].ImageRectPosition

task.wait(1)
local av=ae.Icon"copy"
as.Button.ImageLabel.Image=av[1]
as.Button.ImageLabel.ImageRectSize=av[2].ImageRectSize
as.Button.ImageLabel.ImageRectOffset=av[2].ImageRectPosition
end
end)
return ap
end


return aa end function a.S()
local aa=a.load'c'local ae=
aa.New


local af=a.load'R'

local ah={}

function ah.New(aj,ak)
local al={
__type="Code",
Title=ak.Title,
Code=ak.Code,
OnCopy=ak.OnCopy,
}

local am=not al.Locked











local an=af.New(al.Code,al.Title,ak.Parent,function()
if am then
local an=al.Title or"code"
local ao,ap=pcall(function()
toclipboard(al.Code)

if al.OnCopy then al.OnCopy()end
end)
if not ao then
ak.IntiHub:Notify{
Title="Error",
Content="The "..an.." is not copied. Error: "..ap,
Icon="x",
Duration=5,
}
end
end
end,ak.IntiHub.UIScale,al)

function al.SetCode(ao,ap)
an.Set(ap)
al.Code=ap
end

function al.Set(ao,ap)
return al.SetCode(ap)
end

function al.Destroy(ao)
an.Destroy()
al=nil
end

al.ElementFrame=an.CodeFrame

return al.__type,al
end

return ah end function a.T()
local aa=a.load'c'
local ae=aa.New local af=
aa.Tween

local ah=(cloneref or clonereference or function(ah)return ah end)

local aj=ah(game:GetService"UserInputService")
ah(game:GetService"TouchInputService")
local ak=ah(game:GetService"RunService")
local al=ah(game:GetService"Players")

local am=ak.RenderStepped
local an=al.LocalPlayer
local ao=an:GetMouse()

local ap=a.load'l'.New
local aq=a.load'm'.New

local ar={
UICorner=9,

}

function ar.Colorpicker(as,at,au,av)
local aw={
__type="Colorpicker",
Title=at.Title,
Desc=at.Desc,
Default=at.Value or at.Default,
Callback=at.Callback,
Transparency=at.Transparency,
UIElements=at.UIElements,

TextPadding=10,
}

function aw.SetHSVFromRGB(ax,ay)
local az,aA,aB=Color3.toHSV(ay)
aw.Hue=az
aw.Sat=aA
aw.Vib=aB
end

aw:SetHSVFromRGB(aw.Default)

local ax=a.load'n'.Init(au)
local ay=ax.Create()

aw.ColorpickerFrame=ay

ay.UIElements.Main.Size=UDim2.new(1,0,0,0)



local az,aA,aB=aw.Hue,aw.Sat,aw.Vib

aw.UIElements.Title=ae("TextLabel",{
Text=aw.Title,
TextSize=20,
FontFace=Font.new(aa.Font,Enum.FontWeight.SemiBold),
TextXAlignment="Left",
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
ThemeTag={
TextColor3="Text"
},
BackgroundTransparency=1,
Parent=ay.UIElements.Main
},{
ae("UIPadding",{
PaddingTop=UDim.new(0,aw.TextPadding/2),
PaddingLeft=UDim.new(0,aw.TextPadding/2),
PaddingRight=UDim.new(0,aw.TextPadding/2),
PaddingBottom=UDim.new(0,aw.TextPadding/2),
})
})





local b=ae("Frame",{
Size=UDim2.new(0,14,0,14),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0,0),
Parent=HueDragHolder,
BackgroundColor3=aw.Default
},{
ae("UIStroke",{
Thickness=2,
Transparency=.1,
ThemeTag={
Color="Text",
},
}),
ae("UICorner",{
CornerRadius=UDim.new(1,0),
})
})

aw.UIElements.SatVibMap=ae("ImageLabel",{
Size=UDim2.fromOffset(160,158),
Position=UDim2.fromOffset(0,40+aw.TextPadding),
Image="rbxassetid://4155801252",
BackgroundColor3=Color3.fromHSV(az,1,1),
BackgroundTransparency=0,
Parent=ay.UIElements.Main,
},{
ae("UICorner",{
CornerRadius=UDim.new(0,8),
}),
aa.NewRoundFrame(8,"SquircleOutline",{
ThemeTag={
ImageColor3="Outline",
},
Size=UDim2.new(1,0,1,0),
ImageTransparency=.85,
ZIndex=99999,
},{
ae("UIGradient",{
Rotation=45,
Color=ColorSequence.new{
ColorSequenceKeypoint.new(0.0,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(1.0,Color3.fromRGB(255,255,255)),
},
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0.0,0.1),
NumberSequenceKeypoint.new(0.5,1),
NumberSequenceKeypoint.new(1.0,0.1),
}
})
}),

b,
})

aw.UIElements.Inputs=ae("Frame",{
AutomaticSize="XY",
Size=UDim2.new(0,0,0,0),
Position=UDim2.fromOffset(aw.Transparency and 240 or 210,40+aw.TextPadding),
BackgroundTransparency=1,
Parent=ay.UIElements.Main
},{
ae("UIListLayout",{
Padding=UDim.new(0,4),
FillDirection="Vertical",
})
})





local d=ae("Frame",{
BackgroundColor3=aw.Default,
Size=UDim2.fromScale(1,1),
BackgroundTransparency=aw.Transparency,
},{
ae("UICorner",{
CornerRadius=UDim.new(0,8),
}),
})

ae("ImageLabel",{
Image="http://www.roblox.com/asset/?id=14204231522",
ImageTransparency=0.45,
ScaleType=Enum.ScaleType.Tile,
TileSize=UDim2.fromOffset(40,40),
BackgroundTransparency=1,
Position=UDim2.fromOffset(85,208+aw.TextPadding),
Size=UDim2.fromOffset(75,24),
Parent=ay.UIElements.Main,
},{
ae("UICorner",{
CornerRadius=UDim.new(0,8),
}),
aa.NewRoundFrame(8,"SquircleOutline",{
ThemeTag={
ImageColor3="Outline",
},
Size=UDim2.new(1,0,1,0),
ImageTransparency=.85,
ZIndex=99999,
},{
ae("UIGradient",{
Rotation=60,
Color=ColorSequence.new{
ColorSequenceKeypoint.new(0.0,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(1.0,Color3.fromRGB(255,255,255)),
},
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0.0,0.1),
NumberSequenceKeypoint.new(0.5,1),
NumberSequenceKeypoint.new(1.0,0.1),
}
})
}),







d,
})

local f=ae("Frame",{
BackgroundColor3=aw.Default,
Size=UDim2.fromScale(1,1),
BackgroundTransparency=0,
ZIndex=9,
},{
ae("UICorner",{
CornerRadius=UDim.new(0,8),
}),
})

ae("ImageLabel",{
Image="http://www.roblox.com/asset/?id=14204231522",
ImageTransparency=0.45,
ScaleType=Enum.ScaleType.Tile,
TileSize=UDim2.fromOffset(40,40),
BackgroundTransparency=1,
Position=UDim2.fromOffset(0,208+aw.TextPadding),
Size=UDim2.fromOffset(75,24),
Parent=ay.UIElements.Main,
},{
ae("UICorner",{
CornerRadius=UDim.new(0,8),
}),







aa.NewRoundFrame(8,"SquircleOutline",{
ThemeTag={
ImageColor3="Outline",
},
Size=UDim2.new(1,0,1,0),
ImageTransparency=.85,
ZIndex=99999,
},{
ae("UIGradient",{
Rotation=60,
Color=ColorSequence.new{
ColorSequenceKeypoint.new(0.0,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(1.0,Color3.fromRGB(255,255,255)),
},
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0.0,0.1),
NumberSequenceKeypoint.new(0.5,1),
NumberSequenceKeypoint.new(1.0,0.1),
}
})
}),
f,
})

local g={}

for h=0,1,0.1 do
table.insert(g,ColorSequenceKeypoint.new(h,Color3.fromHSV(h,1,1)))
end

local h=ae("UIGradient",{
Color=ColorSequence.new(g),
Rotation=90,
})

local j=ae("Frame",{
Size=UDim2.new(1,0,1,0),
Position=UDim2.new(0,0,0,0),
BackgroundTransparency=1,
})

local l=ae("Frame",{
Size=UDim2.new(0,14,0,14),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0,0),
Parent=j,


BackgroundColor3=aw.Default
},{
ae("UIStroke",{
Thickness=2,
Transparency=.1,
ThemeTag={
Color="Text",
},
}),
ae("UICorner",{
CornerRadius=UDim.new(1,0),
})
})

local m=ae("Frame",{
Size=UDim2.fromOffset(6,192),
Position=UDim2.fromOffset(180,40+aw.TextPadding),
Parent=ay.UIElements.Main,
},{
ae("UICorner",{
CornerRadius=UDim.new(1,0),
}),
h,
j,
})


function CreateNewInput(p,r)
local u=aq(p,nil,aw.UIElements.Inputs)

ae("TextLabel",{
BackgroundTransparency=1,
TextTransparency=.4,
TextSize=17,
FontFace=Font.new(aa.Font,Enum.FontWeight.Regular),
AutomaticSize="XY",
ThemeTag={
TextColor3="Placeholder",
},
AnchorPoint=Vector2.new(1,0.5),
Position=UDim2.new(1,-12,0.5,0),
Parent=u.Frame,
Text=p,
})

ae("UIScale",{
Parent=u,
Scale=.85,
})

u.Frame.Frame.TextBox.Text=r
u.Size=UDim2.new(0,150,0,42)

return u
end

local function ToRGB(p)
return{
R=math.floor(p.R*255),
G=math.floor(p.G*255),
B=math.floor(p.B*255)
}
end

local p=CreateNewInput("Hex","#"..aw.Default:ToHex())

local r=CreateNewInput("Red",ToRGB(aw.Default).R)
local u=CreateNewInput("Green",ToRGB(aw.Default).G)
local v=CreateNewInput("Blue",ToRGB(aw.Default).B)
local x
if aw.Transparency then
x=CreateNewInput("Alpha",((1-aw.Transparency)*100).."%")
end

local z=ae("Frame",{
Size=UDim2.new(1,0,0,40),
AutomaticSize="Y",
Position=UDim2.new(0,0,0,254+aw.TextPadding),
BackgroundTransparency=1,
Parent=ay.UIElements.Main,
LayoutOrder=4,
},{
ae("UIListLayout",{
Padding=UDim.new(0,6),
FillDirection="Horizontal",
HorizontalAlignment="Right",
}),






})

local A={
{
Title="Cancel",
Variant="Secondary",
Callback=function()end
},
{
Title="Apply",
Icon="chevron-right",
Variant="Primary",
Callback=function()av(Color3.fromHSV(aw.Hue,aw.Sat,aw.Vib),aw.Transparency)end
}
}

for B,C in next,A do
local F=ap(C.Title,C.Icon,C.Callback,C.Variant,z,ay,false)
F.Size=UDim2.new(0.5,-3,0,40)
F.AutomaticSize="None"
end



local B,C,F
if aw.Transparency then
local G=ae("Frame",{
Size=UDim2.new(1,0,1,0),
Position=UDim2.fromOffset(0,0),
BackgroundTransparency=1,
})

C=ae("ImageLabel",{
Size=UDim2.new(0,14,0,14),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0,0),
ThemeTag={
BackgroundColor3="Text",
},
Parent=G,

},{
ae("UIStroke",{
Thickness=2,
Transparency=.1,
ThemeTag={
Color="Text",
},
}),
ae("UICorner",{
CornerRadius=UDim.new(1,0),
})

})

F=ae("Frame",{
Size=UDim2.fromScale(1,1),
},{
ae("UIGradient",{
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,0),
NumberSequenceKeypoint.new(1,1),
},
Rotation=270,
}),
ae("UICorner",{
CornerRadius=UDim.new(0,6),
}),
})

B=ae("Frame",{
Size=UDim2.fromOffset(6,192),
Position=UDim2.fromOffset(210,40+aw.TextPadding),
Parent=ay.UIElements.Main,
BackgroundTransparency=1,
},{
ae("UICorner",{
CornerRadius=UDim.new(1,0),
}),
ae("ImageLabel",{
Image="rbxassetid://14204231522",
ImageTransparency=0.45,
ScaleType=Enum.ScaleType.Tile,
TileSize=UDim2.fromOffset(40,40),
BackgroundTransparency=1,
Size=UDim2.fromScale(1,1),
},{
ae("UICorner",{
CornerRadius=UDim.new(1,0),
}),
}),
F,
G,
})
end

function aw.Round(G,H,J)
if J==0 then
return math.floor(H)
end
H=tostring(H)
return H:find"%."and tonumber(H:sub(1,H:find"%."+J))or H
end


function aw.Update(G,H,J)
if H then az,aA,aB=Color3.toHSV(H)else az,aA,aB=aw.Hue,aw.Sat,aw.Vib end

aw.UIElements.SatVibMap.BackgroundColor3=Color3.fromHSV(az,1,1)
b.Position=UDim2.new(aA,0,1-aB,0)
b.BackgroundColor3=Color3.fromHSV(az,aA,aB)
f.BackgroundColor3=Color3.fromHSV(az,aA,aB)
l.BackgroundColor3=Color3.fromHSV(az,1,1)
l.Position=UDim2.new(0.5,0,az,0)

p.Frame.Frame.TextBox.Text="#"..Color3.fromHSV(az,aA,aB):ToHex()
r.Frame.Frame.TextBox.Text=ToRGB(Color3.fromHSV(az,aA,aB)).R
u.Frame.Frame.TextBox.Text=ToRGB(Color3.fromHSV(az,aA,aB)).G
v.Frame.Frame.TextBox.Text=ToRGB(Color3.fromHSV(az,aA,aB)).B

if J or aw.Transparency then
f.BackgroundTransparency=aw.Transparency or J
F.BackgroundColor3=Color3.fromHSV(az,aA,aB)
C.BackgroundColor3=Color3.fromHSV(az,aA,aB)
C.BackgroundTransparency=aw.Transparency or J
C.Position=UDim2.new(0.5,0,1-aw.Transparency or J,0)
x.Frame.Frame.TextBox.Text=aw:Round((1-aw.Transparency or J)*100,0).."%"
end
end

aw:Update(aw.Default,aw.Transparency)




local function GetRGB()
local G=Color3.fromHSV(aw.Hue,aw.Sat,aw.Vib)
return{R=math.floor(G.r*255),G=math.floor(G.g*255),B=math.floor(G.b*255)}
end



local function clamp(G,H,J)
return math.clamp(tonumber(G)or 0,H,J)
end

aa.AddSignal(p.Frame.Frame.TextBox.FocusLost,function(G)
if G then
local H=p.Frame.Frame.TextBox.Text:gsub("#","")
local J,L=pcall(Color3.fromHex,H)
if J and typeof(L)=="Color3"then
aw.Hue,aw.Sat,aw.Vib=Color3.toHSV(L)
aw:Update()
aw.Default=L
end
end
end)

local function updateColorFromInput(G,H)
aa.AddSignal(G.Frame.Frame.TextBox.FocusLost,function(J)
if J then
local L=G.Frame.Frame.TextBox
local M=GetRGB()
local N=clamp(L.Text,0,255)
L.Text=tostring(N)

M[H]=N
local O=Color3.fromRGB(M.R,M.G,M.B)
aw.Hue,aw.Sat,aw.Vib=Color3.toHSV(O)
aw:Update()
end
end)
end

updateColorFromInput(r,"R")
updateColorFromInput(u,"G")
updateColorFromInput(v,"B")

if aw.Transparency then
aa.AddSignal(x.Frame.Frame.TextBox.FocusLost,function(G)
if G then
local H=x.Frame.Frame.TextBox
local J=clamp(H.Text,0,100)
H.Text=tostring(J)

aw.Transparency=1-J*0.01
aw:Update(nil,aw.Transparency)
end
end)
end



local G=aw.UIElements.SatVibMap
aa.AddSignal(G.InputBegan,function(H)
if H.UserInputType==Enum.UserInputType.MouseButton1 or H.UserInputType==Enum.UserInputType.Touch then
while aj:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)do
local J=G.AbsolutePosition.X
local L=J+G.AbsoluteSize.X
local M=math.clamp(ao.X,J,L)

local N=G.AbsolutePosition.Y
local O=N+G.AbsoluteSize.Y
local P=math.clamp(ao.Y,N,O)

aw.Sat=(M-J)/(L-J)
aw.Vib=1-((P-N)/(O-N))
aw:Update()

am:Wait()
end
end
end)

aa.AddSignal(m.InputBegan,function(H)
if H.UserInputType==Enum.UserInputType.MouseButton1 or H.UserInputType==Enum.UserInputType.Touch then
while aj:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)do
local J=m.AbsolutePosition.Y
local L=J+m.AbsoluteSize.Y
local M=math.clamp(ao.Y,J,L)

aw.Hue=((M-J)/(L-J))
aw:Update()

am:Wait()
end
end
end)

if aw.Transparency then
aa.AddSignal(B.InputBegan,function(H)
if H.UserInputType==Enum.UserInputType.MouseButton1 or H.UserInputType==Enum.UserInputType.Touch then
while aj:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)do
local J=B.AbsolutePosition.Y
local L=J+B.AbsoluteSize.Y
local M=math.clamp(ao.Y,J,L)

aw.Transparency=1-((M-J)/(L-J))
aw:Update()

am:Wait()
end
end
end)
end

return aw
end

function ar.New(as,at)
local au={
__type="Colorpicker",
Title=at.Title or"Colorpicker",
Desc=at.Desc or nil,
Locked=at.Locked or false,
LockedTitle=at.LockedTitle,
Default=at.Default or Color3.new(1,1,1),
Callback=at.Callback or function()end,

UIScale=at.UIScale,
Transparency=at.Transparency,
UIElements={}
}

local av=true



au.ColorpickerFrame=a.load'E'{
Title=au.Title,
Desc=au.Desc,
Parent=at.Parent,
TextOffset=40,
Hover=false,
Tab=at.Tab,
Index=at.Index,
Window=at.Window,
ElementTable=au,
ParentConfig=at,
}

au.UIElements.Colorpicker=aa.NewRoundFrame(ar.UICorner,"Squircle",{
ImageTransparency=0,
Active=true,
ImageColor3=au.Default,
Parent=au.ColorpickerFrame.UIElements.Main,
Size=UDim2.new(0,26,0,26),
AnchorPoint=Vector2.new(1,0),
Position=UDim2.new(1,0,0,0),
ZIndex=2
},nil,true)


function au.Lock(aw)
au.Locked=true
av=false
return au.ColorpickerFrame:Lock(au.LockedTitle)
end
function au.Unlock(aw)
au.Locked=false
av=true
return au.ColorpickerFrame:Unlock()
end

if au.Locked then
au:Lock()
end


function au.Update(aw,ax,ay)
au.UIElements.Colorpicker.ImageTransparency=ay or 0
au.UIElements.Colorpicker.ImageColor3=ax
au.Default=ax
if ay then
au.Transparency=ay
end
end

function au.Set(aw,ax,ay)
return au:Update(ax,ay)
end

aa.AddSignal(au.UIElements.Colorpicker.MouseButton1Click,function()
if av then
ar:Colorpicker(au,at.Window,function(aw,ax)
au:Update(aw,ax)
au.Default=aw
au.Transparency=ax
aa.SafeCallback(au.Callback,aw,ax)
end).ColorpickerFrame:Open()
end
end)

return au.__type,au
end

return ar end function a.U()
local aa=a.load'c'
local ae=aa.New
local af=aa.Tween

local ah={}

function ah.New(aj,ak)
local al={
__type="Section",
Title=ak.Title or"Section",
Desc=ak.Desc,
Icon=ak.Icon,
IconThemed=ak.IconThemed,
TextXAlignment=ak.TextXAlignment or"Left",
TextSize=ak.TextSize or 19,
DescTextSize=ak.DescTextSize or 16,
Box=ak.Box or false,
BoxBorder=ak.BoxBorder or false,
FontWeight=ak.FontWeight or Enum.FontWeight.SemiBold,
DescFontWeight=ak.DescFontWeight or Enum.FontWeight.Medium,
TextTransparency=ak.TextTransparency or 0.05,
DescTextTransparency=ak.DescTextTransparency or 0.4,
Opened=ak.Opened or false,
UIElements={},

HeaderSize=42,
IconSize=20,
Padding=10,

Elements={},

Expandable=false,
}

local am


function al.SetIcon(an,ao)
al.Icon=ao or nil
if am then am:Destroy()end
if ao then
am=aa.Image(
ao,
ao..":"..al.Title,
0,
ak.Window.Folder,
al.__type,
true,
al.IconThemed,
"SectionIcon"
)
am.Size=UDim2.new(0,al.IconSize,0,al.IconSize)
end
end

local an=ae("Frame",{
Size=UDim2.new(0,al.IconSize,0,al.IconSize),
BackgroundTransparency=1,
Visible=false
},{
ae("ImageLabel",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Image=aa.Icon"chevron-down"[1],
ImageRectSize=aa.Icon"chevron-down"[2].ImageRectSize,
ImageRectOffset=aa.Icon"chevron-down"[2].ImageRectPosition,
ThemeTag={
ImageTransparency="SectionExpandIconTransparency",
ImageColor3="SectionExpandIcon",
},
})
})


if al.Icon then
al:SetIcon(al.Icon)
end

local ao=ae("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
},{
ae("UIListLayout",{
FillDirection="Vertical",
HorizontalAlignment=al.TextXAlignment,
VerticalAlignment="Center",
Padding=UDim.new(0,4)
})
})

local ap,aq

local function createTitle(ar,as)
return ae("TextLabel",{
BackgroundTransparency=1,
TextXAlignment=al.TextXAlignment,
AutomaticSize="Y",
TextSize=as=="Title"and al.TextSize or al.DescTextSize,
TextTransparency=as=="Title"and al.TextTransparency or al.DescTextTransparency,
ThemeTag={
TextColor3="Text",
},
FontFace=Font.new(aa.Font,as=="Title"and al.FontWeight or al.DescFontWeight),


Text=ar,
Size=UDim2.new(
1,
0,
0,
0
),
TextWrapped=true,
Parent=ao,
})
end

ap=createTitle(al.Title,"Title")
if al.Desc then
aq=createTitle(al.Desc,"Desc")
end

local function UpdateTitleSize()
local ar=0
if am then
ar=ar-(al.IconSize+8)
end
if an.Visible then
ar=ar-(al.IconSize+8)
end
ao.Size=UDim2.new(1,ar,0,0)
end


local ar=ak.Parent
if ar and ar:FindFirstChild"LeftColumn"then
ar=ar.LeftColumn
end

local as=aa.NewRoundFrame(ak.Window.ElementConfig.UICorner,"Squircle",{
Size=UDim2.new(1,0,0,0),
BackgroundTransparency=1,
Parent=ar,
ClipsDescendants=true,
AutomaticSize="Y",
ThemeTag={
ImageTransparency=al.Box and"SectionBoxBackgroundTransparency"or nil,
ImageColor3="SectionBoxBackground",
},
ImageTransparency=not al.Box and 1 or nil,
},{
aa.NewRoundFrame(ak.Window.ElementConfig.UICorner,ak.Window.NewElements and"Glass-1"or"SquircleOutline",{
Size=UDim2.new(1,0,1,0),

ThemeTag={
ImageTransparency="SectionBoxBorderTransparency",
ImageColor3="SectionBoxBorder",
},
Visible=al.Box and al.BoxBorder,
Name="Outline",
},{

ae("UIStroke",{
Thickness=1.5,
ThemeTag={
Color="Outline",
},
Transparency=0.5,
ApplyStrokeMode="Border",
})
}),
ae("TextButton",{
Size=UDim2.new(1,0,0,al.Expandable and 0 or(not aq and al.HeaderSize or 0)),
BackgroundTransparency=1,
AutomaticSize=(not al.Expandable or aq)and"Y"or nil,
Text="",
Name="Top",
},{
al.Box and ae("UIPadding",{
PaddingTop=UDim.new(0,ak.Window.ElementConfig.UIPadding+(ak.Window.NewElements and 4 or 0)),
PaddingLeft=UDim.new(0,ak.Window.ElementConfig.UIPadding+(ak.Window.NewElements and 4 or 0)),
PaddingRight=UDim.new(0,ak.Window.ElementConfig.UIPadding+(ak.Window.NewElements and 4 or 0)),
PaddingBottom=UDim.new(0,ak.Window.ElementConfig.UIPadding+(ak.Window.NewElements and 4 or 0)),
})or nil,
am,
ao,
ae("UIListLayout",{
Padding=UDim.new(0,8),
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Left",
}),
an,
}),
ae("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
Name="Content",
Visible=false,
Position=UDim2.new(0,0,0,al.HeaderSize)
},{
al.Box and ae("UIPadding",{
PaddingLeft=UDim.new(0,ak.Window.ElementConfig.UIPadding),
PaddingRight=UDim.new(0,ak.Window.ElementConfig.UIPadding),
PaddingBottom=UDim.new(0,ak.Window.ElementConfig.UIPadding),
})or nil,
ae("UIListLayout",{
FillDirection="Vertical",
Padding=UDim.new(0,ak.Tab.Gap),
VerticalAlignment="Top",
}),
})
})





al.ElementFrame=as

if aq then
as.Top:GetPropertyChangedSignal"AbsoluteSize":Connect(function()
as.Content.Position=UDim2.new(0,0,0,as.Top.AbsoluteSize.Y/ak.UIScale)

if al.Opened then al:Open(true)else al.Close(true)end
end)
end


local at=ak.ElementsModule

at.Load(al,as.Content,at.Elements,ak.Window,ak.IntiHub,function()
if not al.Expandable then
al.Expandable=true
an.Visible=true
UpdateTitleSize()
end
end,at,ak.UIScale,ak.Tab)


UpdateTitleSize()

function al.SetTitle(au,av)
al.Title=av
ap.Text=av
end

function al.SetDesc(au,av)
al.Desc=av
if not aq then
aq=createTitle(av,"Desc")
end
aq.Text=av
end

function al.Destroy(au)
for av,aw in next,al.Elements do
aw:Destroy()
end








as:Destroy()
end

function al.Open(au,av)
if al.Expandable then
al.Opened=true
if av then
as.Size=UDim2.new(as.Size.X.Scale,as.Size.X.Offset,0,(as.Top.AbsoluteSize.Y)/ak.UIScale+(as.Content.AbsoluteSize.Y/ak.UIScale))
an.ImageLabel.Rotation=180
else
af(as,0.33,{
Size=UDim2.new(as.Size.X.Scale,as.Size.X.Offset,0,(as.Top.AbsoluteSize.Y)/ak.UIScale+(as.Content.AbsoluteSize.Y/ak.UIScale))
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

af(an.ImageLabel,0.2,{Rotation=180},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end
end
function al.Close(au,av)
if al.Expandable then
al.Opened=false
if av then
as.Size=UDim2.new(as.Size.X.Scale,as.Size.X.Offset,0,(as.Top.AbsoluteSize.Y/ak.UIScale))
an.ImageLabel.Rotation=0
else
af(as,0.26,{
Size=UDim2.new(as.Size.X.Scale,as.Size.X.Offset,0,(as.Top.AbsoluteSize.Y/ak.UIScale))
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
af(an.ImageLabel,0.2,{Rotation=0},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end
end

aa.AddSignal(as.Top.MouseButton1Click,function()
if al.Expandable then
if al.Opened then
al:Close()
else
al:Open()
end
end
end)

aa.AddSignal(as.Content.UIListLayout:GetPropertyChangedSignal"AbsoluteContentSize",function()
if al.Opened then
al:Open(true)
end
end)

task.spawn(function()
task.wait(0.02)
if al.Expandable then
as.Size=UDim2.new(as.Size.X.Scale,as.Size.X.Offset,0,as.Top.AbsoluteSize.Y/ak.UIScale)
as.AutomaticSize="None"
as.Top.Size=UDim2.new(1,0,0,(not aq and al.HeaderSize or 0))
as.Top.AutomaticSize=(not al.Expandable or aq)and"Y"or"None"
as.Content.Visible=true

if al.Opened then
al:Open()
end

task.spawn(function()
while task.wait(0.03)do
if not as or not as.Parent then break end
local au=as:FindFirstChild"Outline"
local av=au and au:FindFirstChildOfClass"UIStroke"
local aw=av and av:FindFirstChild"GlowTrail"
if aw then
aw.Rotation=(aw.Rotation+2)%360
end
end
end)
end
end)

return al.__type,al
end

return ah end function a.V()

local aa=a.load'c'
local ae=aa.New

local af={}

function af.New(ah,aj)
local ak=ae("Frame",{
Parent=aj.Parent,
Size=aj.ParentType~="Group"and UDim2.new(1,-7,0,7*(aj.Columns or 1))or UDim2.new(0,7*(aj.Columns or 1),0,0),
BackgroundTransparency=1,
})

return"Space",{__type="Space",ElementFrame=ak}
end

return af end function a.W()
local aa=a.load'c'
local ae=aa.New

local af={}

local function ParseAspectRatio(ah)
if type(ah)=="string"then
local aj,ak=ah:match"(%d+):(%d+)"
if aj and ak then
return tonumber(aj)/tonumber(ak)
end
elseif type(ah)=="number"then
return ah
end
return nil
end

function af.New(ah,aj)
local ak={
__type="Image",
Image=aj.Image or"",
AspectRatio=aj.AspectRatio or"16:9",
Radius=aj.Radius or aj.Window.ElementConfig.UICorner,
}
local al=aa.Image(
ak.Image,
ak.Image,
ak.Radius,
aj.Window.Folder,
"Image",
false
)
if al and al.Parent then
al.Parent=aj.Parent
al.Size=UDim2.new(1,0,0,0)
al.BackgroundTransparency=1












local am=ParseAspectRatio(ak.AspectRatio)
local an

if am then
an=ae("UIAspectRatioConstraint",{
Parent=al,
AspectRatio=am,
AspectType="ScaleWithParentSize",
DominantAxis="Width"
})
end

function ak.Destroy(ao)
al:Destroy()
end
end

return ak.__type,ak
end

return af end function a.X()
local aa=a.load'c'
local ae=aa.New

local af={}

function af.New(ah,aj)
local ak={
__type="Group",
Elements={}
}

local al
if aj.Title then
al=ae("TextLabel",{
Text=aj.Title,
TextSize=14,
FontFace=Font.new(aa.Font,Enum.FontWeight.Bold),
ThemeTag={
TextColor3="Accent",
},
TextXAlignment="Left",
BackgroundTransparency=1,
AutomaticSize="Y",
Size=UDim2.new(1,0,0,0),
},{
ae("UIPadding",{
PaddingLeft=UDim.new(0,4),
PaddingBottom=UDim.new(0,4),
})
})
end

local am=ae("Frame",{
Size=UDim2.new(1,0,0,0),
BackgroundTransparency=1,
AutomaticSize="Y",
Parent=aj.Parent,
},{
ae("UIListLayout",{
FillDirection="Vertical",
SortOrder="LayoutOrder",
Padding=UDim.new(0,6)
}),
al,
ae("Frame",{
Name="Container",
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
LayoutOrder=2,
},{
ae("UIListLayout",{
FillDirection="Horizontal",
HorizontalAlignment="Center",
Padding=UDim.new(0,aj.Tab and aj.Tab.Gap or(aj.Window.NewElements and 1 or 6))
}),
})
})

local an=am.Container

local ao=aj.ElementsModule
ao.Load(
ak,
an,
ao.Elements,
aj.Window,
aj.IntiHub,
function(ap,aq)
local ar=aj.Tab and aj.Tab.Gap or(aj.Window.NewElements and 1 or 6)

local as={}
local at=0

for au,av in next,aq do
if av.__type=="Space"then
at=at+(av.ElementFrame.Size.X.Offset or 6)
elseif av.__type=="Divider"then
at=at+(av.ElementFrame.Size.X.Offset or 1)
else
table.insert(as,av)
end
end

local au=#as
if au==0 then return end

local av=1/au

local aw=ar*(au-1)

local ax=-(aw+at)

local ay=math.floor(ax/au)
local az=ax-(ay*au)

for aA,aB in next,as do
local b=ay
if aA<=math.abs(az)then
b=b-1
end

if aB.ElementFrame then
aB.ElementFrame.Size=UDim2.new(av,b,1,0)
end
end
end,
ao,
aj.UIScale,
aj.Tab
)



return ak.__type,ak
end

return af end function a.Y()
return{
Elements={
Paragraph=a.load'F',
Button=a.load'G',
Toggle=a.load'J',
Slider=a.load'K',
Keybind=a.load'L',
Input=a.load'M',
Dropdown=a.load'P',
Code=a.load'S',
Colorpicker=a.load'T',
Section=a.load'U',
Divider=a.load'N',
Space=a.load'V',
Image=a.load'W',
Group=a.load'X',

},
Load=function(aa,ae,af,ah,aj,ak,al,am,an)
for ao,ap in next,af do
aa[ao]=function(aq,ar)
ar=ar or{}
ar.Tab=an or aa
ar.ParentType=aa.__type
ar.ParentTable=aa
ar.Index=#aa.Elements+1
ar.GlobalIndex=#ah.AllElements+1
ar.Parent=ae
ar.Window=ah
ar.IntiHub=aj
ar.UIScale=am
ar.ElementsModule=al local

as, at=ap:New(ar)

if ar.Flag and typeof(ar.Flag)=="string"then
if ah.CurrentConfig then
ah.CurrentConfig:Register(ar.Flag,at)

if ah.PendingConfigData and ah.PendingConfigData[ar.Flag]then
local au=ah.PendingConfigData[ar.Flag]

local av=ah.ConfigManager
if av.Parser[au.__type]then
task.defer(function()
local aw,ax=pcall(function()
av.Parser[au.__type].Load(at,au)
end)

if aw then
ah.PendingConfigData[ar.Flag]=nil
else
warn(
"[ IntiHub ] Failed to apply pending config for '"
..ar.Flag
.."': "
..tostring(ax)
)
end
end)
end
end
else
ah.PendingFlags=ah.PendingFlags or{}
ah.PendingFlags[ar.Flag]=at
end
end

local au
for av,aw in next,at do
if typeof(aw)=="table"and av~="ElementFrame"and av:match"Frame$"then
au=aw
break
end
end

if au then
at.ElementFrame=au.UIElements.Main
function at.SetTitle(av,aw)
return au.SetTitle and au:SetTitle(aw)
end
function at.SetDesc(av,aw)
return au.SetDesc and au:SetDesc(aw)
end
function at.SetImage(av,aw,ax)
return au.SetImage and au:SetImage(aw,ax)
end
function at.SetThumbnail(av,aw,ax)
return au.SetThumbnail and au:SetThumbnail(aw,ax)
end
function at.Highlight(av)
au:Highlight()
end
function at.Destroy(av)
au:Destroy()

table.remove(ah.AllElements,ar.GlobalIndex)
table.remove(aa.Elements,ar.Index)
table.remove(an.Elements,ar.Index)
aa:UpdateAllElementShapes(aa)
end
end

ah.AllElements[ar.GlobalIndex]=at
aa.Elements[ar.Index]=at
if an then
an.Elements[ar.Index]=at
end

if ah.NewElements then
aa:UpdateAllElementShapes(aa)
end

if ak then
ak(at,aa.Elements)
end
return at
end


local aq="Create"..ao
if not aa[aq]then
aa[aq]=aa[ao]
end
end
function aa.UpdateAllElementShapes(ao,ap)
for aq,ar in next,ap.Elements do
local as
for at,au in pairs(ar)do
if typeof(au)=="table"and at:match"Frame$"then
as=au
break
end
end

if as then

as.Index=aq
if as.UpdateShape then

as.UpdateShape(ap)
end
end
end
end
end,
}end function a.Z()

local aa=(cloneref or clonereference or function(aa)
return aa
end)

local ae=game:GetService"Players"

aa(game:GetService"UserInputService")
local af=ae.LocalPlayer:GetMouse()

local ah=a.load'c'
local aj=ah.New

local ak=a.load'D'.New
local al=a.load'w'.New



local am={


Tabs={},
Containers={},
SelectedTab=nil,
TabCount=0,
ToolTipParent=nil,
TabHighlight=nil,

OnChangeFunc=function(am)end,
}

function am.Init(an,ao,ap,aq)
Window=an
IntiHub=ao
am.ToolTipParent=ap
am.TabHighlight=aq
return am
end

function am.New(an,ao)
local ap={
__type="Tab",
Title=an.Title or"Tab",
Desc=an.Desc,
Icon=an.Icon,
IconColor=an.IconColor,
IconShape=an.IconShape,
IconThemed=an.IconThemed,
Locked=an.Locked,
ShowTabTitle=an.ShowTabTitle,
TabTitleAlign=an.TabTitleAlign or"Left",
CustomEmptyPage=(an.CustomEmptyPage and next(an.CustomEmptyPage)~=nil)and an.CustomEmptyPage
or{Icon="lucide:frown",IconSize=48,Title="This tab is Empty",Desc=nil},
Border=an.Border,
Selected=false,
Index=nil,
Parent=an.Parent,
UIElements={},
Elements={},
ContainerFrame=nil,
UICorner=Window.UICorner-(Window.UIPadding/2),

Gap=Window.NewElements and 1 or 6,

TabPaddingX=4+(Window.UIPadding/2),
TabPaddingY=3+(Window.UIPadding/2),
TitlePaddingY=0,
}









if ap.IconShape then
ap.TabPaddingX=2+(Window.UIPadding/4)
ap.TabPaddingY=2+(Window.UIPadding/4)
ap.TitlePaddingY=2+(Window.UIPadding/4)
end

am.TabCount=am.TabCount+1

local aq=am.TabCount
ap.Index=aq

ap.UIElements.Main=ah.NewRoundFrame(ap.UICorner,"Squircle",{
BackgroundTransparency=1,
Size=UDim2.new(1,-7,0,0),
AutomaticSize="Y",
Parent=an.Parent,
ThemeTag={
ImageColor3="TabBackground",
},
ImageTransparency=1,
},{
ah.NewRoundFrame(ap.UICorner,"Glass-1.4",{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="TabBorder",
},
ImageTransparency=1,
Name="Outline",
},{













}),
ah.NewRoundFrame(ap.UICorner,"Squircle",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
ThemeTag={
ImageColor3="Text",
},
ImageTransparency=1,
Name="Frame",
},{
aj("Frame",{
Size=UDim2.new(0,2,0,14),
Position=UDim2.new(0,-6,0.5,0),
AnchorPoint=Vector2.new(0,0.5),
ThemeTag={
BackgroundColor3="Accent",
},
BackgroundTransparency=1,
Name="Indicator",
},{
aj("UICorner",{CornerRadius=UDim.new(1,0)})
}),
aj("UIListLayout",{
SortOrder="LayoutOrder",
Padding=UDim.new(0,2+(Window.UIPadding/2)),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
aj("TextLabel",{
Text=ap.Title,
ThemeTag={
TextColor3="TabTitle",
},
TextTransparency=not ap.Locked and 0.4 or 0.7,
TextSize=15,
Size=UDim2.new(1,0,0,0),
FontFace=Font.new(ah.Font,Enum.FontWeight.Medium),
TextWrapped=true,
RichText=true,
AutomaticSize="Y",
LayoutOrder=2,
TextXAlignment="Left",
BackgroundTransparency=1,
},{
aj("UIPadding",{
PaddingTop=UDim.new(0,ap.TitlePaddingY),


PaddingBottom=UDim.new(0,ap.TitlePaddingY),
}),
}),
aj("UIPadding",{
PaddingTop=UDim.new(0,ap.TabPaddingY),
PaddingLeft=UDim.new(0,ap.TabPaddingX),
PaddingRight=UDim.new(0,ap.TabPaddingX),
PaddingBottom=UDim.new(0,ap.TabPaddingY),
}),
}),
},true)

local ar=0
local as
local at

if ap.Icon then
as=ah.Image(
ap.Icon,
ap.Icon..":"..ap.Title,
0,
Window.Folder,
ap.__type,
ap.IconColor and false or true,
ap.IconThemed,
"TabIcon"
)
as.Size=UDim2.new(0,16,0,16)
if ap.IconColor then
as.ImageLabel.ImageColor3=ap.IconColor
end
if not ap.IconShape and not ap.IconColor then
as.Parent=ap.UIElements.Main.Frame
ap.UIElements.Icon=as
as.ImageLabel.ImageTransparency=not ap.Locked and 0 or 0.7
ar=-18-(Window.UIPadding/2)
ap.UIElements.Main.Frame.TextLabel.Size=UDim2.new(1,ar,0,0)
elseif ap.IconShape or ap.IconColor then
if not ap.IconShape then ap.IconShape="Squircle"end
ah.NewRoundFrame(
ap.IconShape~="Circle"and(ap.UICorner+5-(2+(Window.UIPadding/4)))or 9999,
"Squircle",
{
Size=UDim2.new(0,26,0,26),
ImageColor3=ap.IconColor or nil,
ThemeTag=not ap.IconColor and{
ImageColor3="Accent",
}or nil,
Parent=ap.UIElements.Main.Frame,
},
{
as,
ah.NewRoundFrame(
ap.IconShape~="Circle"and(ap.UICorner+5-(2+(Window.UIPadding/4)))or 9999,
"Glass-1.4",
{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="White",
},
ImageTransparency=0,
Name="Outline",
},
{
}
),
}
)
as.AnchorPoint=Vector2.new(0.5,0.5)
as.Position=UDim2.new(0.5,0,0.5,0)
as.ImageLabel.ImageTransparency=0
as.ImageLabel.ImageColor3=(not ap.IconColor or ah.GetTextColorForHSB(ap.IconColor,0.68)==Color3.new(1,1,1))and Color3.fromHex"#1A1605"or ah.GetTextColorForHSB(ap.IconColor,0.68)
ar=-28-(Window.UIPadding/2)
ap.UIElements.Main.Frame.TextLabel.Size=UDim2.new(1,ar,0,0)
end

at=
ah.Image(ap.Icon,ap.Icon..":"..ap.Title,0,Window.Folder,ap.__type,true,ap.IconThemed)
at.Size=UDim2.new(0,16,0,16)
at.ImageLabel.ImageTransparency=not ap.Locked and 0 or 0.7
ar=-30




end

ap.UIElements.ContainerFrame=aj("ScrollingFrame",{
Size=UDim2.new(1,0,1,ap.ShowTabTitle and-((Window.UIPadding*2.4)+12)or 0),
BackgroundTransparency=1,
ScrollBarThickness=0,
ElasticBehavior="Never",
CanvasSize=UDim2.new(0,0,0,0),
AnchorPoint=Vector2.new(0,1),
Position=UDim2.new(0,0,1,0),
AutomaticCanvasSize="Y",
ScrollingDirection="Y",
},{
aj("UIPadding",{
PaddingTop=UDim.new(0,not Window.HidePanelBackground and 20 or 10),
PaddingLeft=UDim.new(0,not Window.HidePanelBackground and 20 or 10),
PaddingRight=UDim.new(0,not Window.HidePanelBackground and 20 or 10),
PaddingBottom=UDim.new(0,not Window.HidePanelBackground and 20 or 10),
}),
aj("Frame",{
Name="LeftColumn",
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
},{
aj("UIListLayout",{
SortOrder="LayoutOrder",
Padding=UDim.new(0,ap.Gap),
HorizontalAlignment="Center",
}),
}),
})





ap.UIElements.ContainerFrameCanvas=aj("Frame",{
Size=UDim2.new(1,0,1,-5),
BackgroundTransparency=1,
Visible=false,
Parent=Window.UIElements.MainBar,
ZIndex=5,
Position=UDim2.new(0,0,0,5),
},{
ap.UIElements.ContainerFrame,
aj("Frame",{
Size=UDim2.new(1,0,0,((Window.UIPadding*2.4)+12)),
BackgroundTransparency=1,
Visible=ap.ShowTabTitle or false,
Name="TabTitle",
},{
at,
aj("TextLabel",{
Text=ap.Title,
ThemeTag={
TextColor3="Text",
},
TextSize=20,
TextTransparency=0.1,
Size=UDim2.new(0,0,1,0),
FontFace=Font.new(ah.Font,Enum.FontWeight.SemiBold),

RichText=true,
LayoutOrder=2,
TextXAlignment="Left",
BackgroundTransparency=1,
AutomaticSize="X",
}),
aj("UIPadding",{
PaddingTop=UDim.new(0,20),
PaddingLeft=UDim.new(0,20),
PaddingRight=UDim.new(0,20),
PaddingBottom=UDim.new(0,20),
}),
aj("UIListLayout",{
SortOrder="LayoutOrder",
Padding=UDim.new(0,10),
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment=ap.TabTitleAlign,
}),
}),
aj("Frame",{
Size=UDim2.new(1,0,0,1),
BackgroundTransparency=0.9,
ThemeTag={
BackgroundColor3="Text",
},
Position=UDim2.new(0,0,0,((Window.UIPadding*2.4)+12)),
Visible=ap.ShowTabTitle or false,
}),
})

am.Containers[aq]=ap.UIElements.ContainerFrameCanvas
am.Tabs[aq]=ap

ap.ContainerFrame=ap.UIElements.ContainerFrameCanvas

ah.AddSignal(ap.UIElements.Main.MouseButton1Click,function()
if not ap.Locked then
am:SelectTab(aq)
end
end)

if Window.ScrollBarEnabled then
al(ap.UIElements.ContainerFrame,ap.UIElements.ContainerFrameCanvas,Window,3)
end

local au
local av
local aw
local ax=false


if ap.Desc then
ah.AddSignal(ap.UIElements.Main.InputBegan,function()
ax=true
av=task.spawn(function()
task.wait(0.35)
if ax and not au then
au=ak(ap.Desc,am.ToolTipParent,true)
au.Container.AnchorPoint=Vector2.new(0.5,0.5)

local function updatePosition()
if au then
au.Container.Position=UDim2.new(0,af.X,0,af.Y-4)
end
end

updatePosition()
aw=af.Move:Connect(updatePosition)
au:Open()
end
end)
end)
end

ah.AddSignal(ap.UIElements.Main.MouseEnter,function()
if not ap.Locked then
ah.SetThemeTag(ap.UIElements.Main.Frame,{
ImageTransparency="TabBackgroundHoverTransparency",
ImageColor3="TabBackgroundHover",
},0.1)
end
end)
ah.AddSignal(ap.UIElements.Main.InputEnded,function()
if ap.Desc then
ax=false
if av then
task.cancel(av)
av=nil
end
if aw then
aw:Disconnect()
aw=nil
end
if au then
au:Close()
au=nil
end
end

if not ap.Locked then
ah.SetThemeTag(ap.UIElements.Main.Frame,{
ImageTransparency="TabBorderTransparency",
},0.1)
end
end)

function ap.ScrollToTheElement(ay,az)
ap.UIElements.ContainerFrame.ScrollingEnabled=false

ah.Tween(ap.UIElements.ContainerFrame,0.45,{
CanvasPosition=Vector2.new(
0,
ap.Elements[az].ElementFrame.AbsolutePosition.Y
-ap.UIElements.ContainerFrame.AbsolutePosition.Y
-ap.UIElements.ContainerFrame.UIPadding.PaddingTop.Offset
),
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

task.spawn(function()
task.wait(0.48)

if ap.Elements[az].Highlight then
ap.Elements[az]:Highlight()
end
ap.UIElements.ContainerFrame.ScrollingEnabled=true
end)

return ap
end



local ay=a.load'Y'

ay.Load(
ap,
ap.UIElements.ContainerFrame,
ay.Elements,
Window,
IntiHub,
nil,
ay,
ao
)
ap.CreateSection=ap.Section

function ap.LockAll(az)

for aA,aB in next,Window.AllElements do
if aB.Tab and aB.Tab.Index and aB.Tab.Index==ap.Index and aB.Lock then
aB:Lock()
end
end
end
function ap.UnlockAll(az)
for aA,aB in next,Window.AllElements do
if aB.Tab and aB.Tab.Index and aB.Tab.Index==ap.Index and aB.Unlock then
aB:Unlock()
end
end
end
function ap.GetLocked(az)
local aA={}

for aB,b in next,Window.AllElements do
if b.Tab and b.Tab.Index and b.Tab.Index==ap.Index and b.Locked==true then
table.insert(aA,b)
end
end

return aA
end
function ap.GetUnlocked(az)
local aA={}

for aB,b in next,Window.AllElements do
if b.Tab and b.Tab.Index and b.Tab.Index==ap.Index and b.Locked==false then
table.insert(aA,b)
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
az=
ah.Image(ap.CustomEmptyPage.Icon,ap.CustomEmptyPage.Icon,0,"Temp","EmptyPage",true)
az.Size=
UDim2.fromOffset(ap.CustomEmptyPage.IconSize or 48,ap.CustomEmptyPage.IconSize or 48)
end

local aA=aj("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,-Window.UIElements.Main.Main.Topbar.AbsoluteSize.Y),
Parent=ap.UIElements.ContainerFrame,
},{
aj("UIListLayout",{
Padding=UDim.new(0,8),
SortOrder="LayoutOrder",
VerticalAlignment="Center",
HorizontalAlignment="Center",
FillDirection="Vertical",
}),











az,
ap.CustomEmptyPage.Title
and aj("TextLabel",{
AutomaticSize="XY",
Text=ap.CustomEmptyPage.Title,
ThemeTag={
TextColor3="Text",
},
TextSize=18,
TextTransparency=0.5,
BackgroundTransparency=1,
FontFace=Font.new(ah.Font,Enum.FontWeight.Medium),
})
or nil,
ap.CustomEmptyPage.Desc
and aj("TextLabel",{
AutomaticSize="XY",
Text=ap.CustomEmptyPage.Desc,
ThemeTag={
TextColor3="Text",
},
TextSize=15,
TextTransparency=0.65,
BackgroundTransparency=1,
FontFace=Font.new(ah.Font,Enum.FontWeight.Regular),
})
or nil,
})





local function checkEmpty()
local aB=false
if ap.UIElements.ContainerFrame:FindFirstChild"LeftColumn"then
for b,d in ipairs(ap.UIElements.ContainerFrame.LeftColumn:GetChildren())do
if d:IsA"GuiObject"and not d:IsA"UIListLayout"then
aB=true
break
end
end
end
aA.Visible=not aB
end

checkEmpty()

if ap.UIElements.ContainerFrame:FindFirstChild"LeftColumn"then
ah.AddSignal(ap.UIElements.ContainerFrame.LeftColumn.ChildAdded,checkEmpty)
ah.AddSignal(ap.UIElements.ContainerFrame.LeftColumn.ChildRemoved,checkEmpty)
end
end)

return ap
end

function am.OnChange(an,ao)
am.OnChangeFunc=ao
end

function am.SelectTab(an,ao)
if not am.Tabs[ao].Locked then
am.SelectedTab=ao

for ap,aq in next,am.Tabs do
if not aq.Locked then
ah.SetThemeTag(aq.UIElements.Main,{
ImageTransparency="TabBorderTransparency",
},0.15)
if aq.Border then
ah.SetThemeTag(aq.UIElements.Main.Outline,{
ImageTransparency="TabBorderTransparency",
},0.15)
end
ah.SetThemeTag(aq.UIElements.Main.Frame.TextLabel,{
TextTransparency="TabTextTransparency",
},0.15)
if aq.UIElements.Icon and not aq.IconColor then
ah.SetThemeTag(aq.UIElements.Icon.ImageLabel,{
ImageTransparency="TabIconTransparency",
},0.15)
end
aq.Selected=false
end
end
ah.SetThemeTag(am.Tabs[ao].UIElements.Main,{
ImageTransparency="TabBackgroundActiveTransparency",
},0.15)
if am.Tabs[ao].Border then
ah.SetThemeTag(am.Tabs[ao].UIElements.Main.Outline,{
ImageTransparency="TabBorderTransparencyActive",
},0.15)
end
ah.SetThemeTag(am.Tabs[ao].UIElements.Main.Frame.TextLabel,{
TextTransparency="TabTextTransparencyActive",
},0.15)
if am.Tabs[ao].UIElements.Icon and not am.Tabs[ao].IconColor then
ah.SetThemeTag(am.Tabs[ao].UIElements.Icon.ImageLabel,{
ImageTransparency="TabIconTransparencyActive",
},0.15)
end


local ap=am.Tabs[ao].UIElements.Main.Frame
if ap:FindFirstChild"Indicator"then
ah.Tween(ap.Indicator,0.2,{BackgroundTransparency=0}):Play()
end


for aq,ar in next,am.Tabs do
if ar.Index~=ao then
local as=ar.UIElements.Main.Frame
if as:FindFirstChild"Indicator"then
ah.Tween(as.Indicator,0.2,{BackgroundTransparency=1}):Play()
end
end
end

am.Tabs[ao].Selected=true

task.spawn(function()
for aq,ar in next,am.Containers do
ar.AnchorPoint=Vector2.new(0,0.05)
ar.Visible=false
end
am.Containers[ao].Visible=true


if Window.UIElements.MainBar:FindFirstChild"ContentHeader"then
local aq=Window.UIElements.MainBar.ContentHeader
if aq:FindFirstChild"TextLabel"then
aq.TextLabel.Text=string.upper(am.Tabs[ao].Title).." MODULE"
end
end

local aq=game:GetService"TweenService"

local ar=TweenInfo.new(0.15,Enum.EasingStyle.Quart,Enum.EasingDirection.Out)
local as=aq:Create(am.Containers[ao],ar,{
AnchorPoint=Vector2.new(0,0),
})
as:Play()
end)

am.OnChangeFunc(ao)
end
end

return am end function a._()

local aa={}


local ae=a.load'c'
local af=ae.New
local ah=ae.Tween

local aj=a.load'Z'

function aa.New(ak,al,am,an,ao)
local ap={
Title=ak.Title or"Section",
Icon=ak.Icon,
IconThemed=ak.IconThemed,
Opened=ak.Opened or false,

HeaderSize=42,
IconSize=18,

Expandable=false,
}

local aq
if ap.Icon then
local ar=ae.Image(
ap.Icon,
ap.Icon,
0,
am,
"Section",
true,
ap.IconThemed,
"TabSectionIcon"
)

ar.Size=UDim2.new(0,ap.IconSize,0,ap.IconSize)
ar.ImageLabel.ImageTransparency=.25
ar.Position=UDim2.new(0.5,0,0.5,0)
ar.AnchorPoint=Vector2.new(0.5,0.5)

aq=af("Frame",{
Size=UDim2.new(0,30,0,30),
ThemeTag={
BackgroundColor3="Accent",
},
BackgroundTransparency=0,
},{
af("UICorner",{CornerRadius=UDim.new(0,8)}),
af("UIStroke",{
Thickness=1.2,
Color=ak.IconColor or nil,
ThemeTag=not ak.IconColor and{
Color="Accent",
}or nil,
}),
ar
})
end

local ar=af("Frame",{
Size=UDim2.new(0,ap.IconSize,0,ap.IconSize),
BackgroundTransparency=1,
Visible=false
},{
af("ImageLabel",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Image=ae.Icon"chevron-down"[1],
ImageRectSize=ae.Icon"chevron-down"[2].ImageRectSize,
ImageRectOffset=ae.Icon"chevron-down"[2].ImageRectPosition,
ThemeTag={
ImageColor3="Icon",
},
ImageTransparency=.7,
})
})

local as=af("Frame",{
Size=UDim2.new(1,0,0,ap.HeaderSize),
BackgroundTransparency=1,
Parent=al,
ClipsDescendants=true,
},{
af("TextButton",{
Size=UDim2.new(1,0,0,ap.HeaderSize),
BackgroundTransparency=1,
Text="",
},{
aq,
af("TextLabel",{
Text=ap.Title,
TextXAlignment="Left",
Size=UDim2.new(
1,
aq and(-ap.IconSize-10)*2
or(-ap.IconSize-10),

1,
0
),
ThemeTag={
TextColor3="Text",
},
FontFace=Font.new(ae.Font,Enum.FontWeight.SemiBold),
TextSize=14,
BackgroundTransparency=1,
TextTransparency=.7,

TextWrapped=true
}),
af("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
Padding=UDim.new(0,10)
}),
ar,
af("UIPadding",{
PaddingLeft=UDim.new(0,11),
PaddingRight=UDim.new(0,11),
})
}),
af("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
Name="Content",
Visible=true,
Position=UDim2.new(0,0,0,ap.HeaderSize)
},{
af("UIListLayout",{
FillDirection="Vertical",
Padding=UDim.new(0,ao.Gap),
VerticalAlignment="Bottom",
}),
})
})


function ap.Tab(at,au)
if not ap.Expandable then
ap.Expandable=true
ar.Visible=true
end
au.Parent=as.Content
return aj.New(au,an)
end

function ap.Open(at)
if ap.Expandable then
ap.Opened=true
ah(as,0.33,{
Size=UDim2.new(1,0,0,ap.HeaderSize+(as.Content.AbsoluteSize.Y/an))
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

ah(ar.ImageLabel,0.1,{Rotation=180},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end
function ap.Close(at)
if ap.Expandable then
ap.Opened=false
ah(as,0.26,{
Size=UDim2.new(1,0,0,ap.HeaderSize)
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ah(ar.ImageLabel,0.1,{Rotation=0},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end

ae.AddSignal(as.TextButton.MouseButton1Click,function()
if ap.Expandable then
if ap.Opened then
ap:Close()
else
ap:Open()
end
end
end)

ae.AddSignal(as.Content.UIListLayout:GetPropertyChangedSignal"AbsoluteContentSize",function()
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


return aa end function a.aa()


local aa=(cloneref or clonereference or function(aa)
return aa
end)

local ae=aa(game:GetService"UserInputService")
local af=aa(game:GetService"RunService")
local ah=aa(game:GetService"Players")

local aj=workspace.CurrentCamera

local ak=a.load's'

local al=a.load'c'
local am=al.New
local an=al.Tween


local ao=a.load'v'.New
local ap=a.load'l'.New
local aq=a.load'w'.New
local ar=a.load'x'

local as=a.load'y'
local at=a.load'A'

local au=Color3
local av=UDim
local aw=UDim2
local ax=Vector2
local ay=Font
local az=Enum
local aA=math

local aB=a.load'B'



return function(b)
local d={
Title=b.Title or"UI Library",
Author=b.Author,
Icon=b.Icon or"https://raw.githubusercontent.com/Sam123mir/IntiHub-LibraryUI/main/docs/logo.png",
IconSize=b.IconSize or 22,
IconThemed=b.IconThemed,
IconRadius=b.IconRadius or 0,
Folder=b.Folder or"IntiHub",
Resizable=b.Resizable~=false,
Background=b.Background,
BackgroundImageTransparency=b.BackgroundImageTransparency or 0,
ShadowTransparency=b.ShadowTransparency or 0.6,
User=b.User or{},
Footer=b.Footer or{},
Topbar=b.Topbar or{Height=52,ButtonsType="Default"},

Size=b.Size,

MinSize=b.MinSize or ax.new(560,350),
MaxSize=b.MaxSize or ax.new(850,560),

TopBarButtonIconSize=b.TopBarButtonIconSize,

ToggleKey=b.ToggleKey,
ElementsRadius=b.ElementsRadius,
Radius=b.Radius or 14,
Transparent=b.Transparent or false,
HideSearchBar=b.HideSearchBar or false,
ScrollBarEnabled=b.ScrollBarEnabled or false,
SideBarWidth=b.SideBarWidth or 200,
Acrylic=b.Acrylic or false,
NewElements=b.NewElements or false,
IgnoreAlerts=b.IgnoreAlerts or false,
HidePanelBackground=b.HidePanelBackground or false,
AutoScale=b.AutoScale~=false,
OpenButton=b.OpenButton,
DragFrameSize=160,

Position=aw.new(0.5,0,0.5,0),
UICorner=nil,
UIPadding=14,
UIElements={},
CanDropdown=true,
Closed=false,
Parent=b.Parent,
Destroyed=false,
IsFullscreen=false,
CanResize=b.Resizable~=false,
IsOpenButtonEnabled=true,

CurrentConfig=nil,
ConfigManager=nil,
AcrylicPaint=nil,
CurrentTab=nil,
TabModule=nil,

OnOpenCallback=nil,
OnCloseCallback=nil,
OnDestroyCallback=nil,

IsPC=false,

Gap=5,

TopBarButtons={},
AllElements={},

ElementConfig={},

PendingFlags={},

IsToggleDragging=false,
}

d.UICorner=d.Radius

d.TopBarButtonIconSize=d.TopBarButtonIconSize or(d.Topbar.ButtonsType=="Mac"and 11 or 16)

d.ElementConfig={
UIPadding=(d.NewElements and 10 or 13),
UICorner=d.ElementsRadius or(d.NewElements and 23 or 12),
}

local f=d.Size or aw.new(0,780,0,500)
d.Size=aw.new(
f.X.Scale,
aA.clamp(f.X.Offset,d.MinSize.X,1200),
f.Y.Scale,
aA.clamp(f.Y.Offset,d.MinSize.Y,800)
)

if d.Topbar=={}then
d.Topbar={Height=52,ButtonsType="Default"}
end

if not af:IsStudio()and d.Folder and writefile then
pcall(function()
if not isfolder("IntiHub_Data/"..d.Folder)then
makefolder("IntiHub_Data/"..d.Folder)
end
if not isfolder("IntiHub_Data/"..d.Folder.."/assets")then
makefolder("IntiHub_Data/"..d.Folder.."/assets")
end
end)
end

local function GetUserThumb(g)
local h,j=pcall(function()
return ah:GetUserThumbnailAsync(
g and 1 or ah.LocalPlayer.UserId,
az.ThumbnailType.HeadShot,
az.ThumbnailSize.Size420x420
)
end)
return h and j or"rbxassetid://0"
end
d.User.Enabled=true
d.SideBarWidth=d.SideBarWidth or 200

local g=am("UICorner",{
CornerRadius=av.new(0,d.UICorner),
})

if d.Folder then
d.ConfigManager=aB:Init(d)
end

if d.Acrylic then local
h=ak.AcrylicPaint{UseAcrylic=d.Acrylic}

d.AcrylicPaint=h
end

local h=am("Frame",{
Size=aw.new(0,32,0,32),
Position=aw.new(1,0,1,0),
AnchorPoint=ax.new(0.5,0.5),
BackgroundTransparency=1,
ZIndex=99,
Active=true,
},{
am("ImageLabel",{
Size=aw.new(0,96,0,96),
BackgroundTransparency=1,
Image="rbxassetid://120997033468887",
Position=aw.new(0.5,-16,0.5,-16),
AnchorPoint=ax.new(0.5,0.5),
ImageTransparency=1,
}),
})
local j=al.NewRoundFrame(d.UICorner,"Squircle",{
Size=aw.new(1,0,1,0),
ImageTransparency=1,
ImageColor3=au.new(0,0,0),
ZIndex=98,
Active=false,
},{
am("ImageLabel",{
Size=aw.new(0,70,0,70),
Image=al.Icon"expand"[1],
ImageRectOffset=al.Icon"expand"[2].ImageRectPosition,
ImageRectSize=al.Icon"expand"[2].ImageRectSize,
BackgroundTransparency=1,
Position=aw.new(0.5,0,0.5,0),
AnchorPoint=ax.new(0.5,0.5),
ImageTransparency=1,
}),
})

local l=al.NewRoundFrame(d.UICorner,"Squircle",{
Size=aw.new(1,0,1,0),
ImageTransparency=1,
ImageColor3=au.new(0,0,0),
ZIndex=999,
Active=false,
})









d.UIElements.SideBar=am("ScrollingFrame",{
Size=aw.new(
1,
d.ScrollBarEnabled and-3-(d.UIPadding/2)or 0,
1,-6

),
Position=aw.new(0,0,1,0),
AnchorPoint=ax.new(0,1),
BackgroundTransparency=1,
ScrollBarThickness=0,
ElasticBehavior="Never",
CanvasSize=aw.new(0,0,0,0),
AutomaticCanvasSize="Y",
ScrollingDirection="Y",
ClipsDescendants=true,
VerticalScrollBarPosition="Left",
},{
am("Frame",{
BackgroundTransparency=1,
AutomaticSize="Y",
Size=aw.new(1,0,0,0),
Name="Frame",
},{
am("UIPadding",{



PaddingBottom=av.new(0,d.UIPadding/2),
}),
am("TextLabel",{
Text="MODULE CONTROL",
TextSize=10,
FontFace=ay.new(al.Font,az.FontWeight.Bold),
ThemeTag={
TextColor3="Accent",
},
TextTransparency=0.4,
BackgroundTransparency=1,
LayoutOrder=-1,
Size=aw.new(1,0,0,20),
TextXAlignment="Left",
}),
am("UIListLayout",{
SortOrder="LayoutOrder",
Padding=av.new(0,d.Gap),
}),
}),
am("UIPadding",{

PaddingLeft=av.new(0,d.UIPadding/2),
PaddingRight=av.new(0,d.UIPadding/2),

}),

})

d.UIElements.SideBarContainer=am("Frame",{
Size=aw.new(
0,
d.SideBarWidth,
1,
-d.Topbar.Height
),
Position=aw.new(0,0,0,d.Topbar.Height),
BackgroundTransparency=1,
Visible=true,
},{
am("Frame",{
Name="Content",
BackgroundTransparency=1,
Size=aw.new(1,0,1,0),
Position=aw.new(0,0,1,0),
AnchorPoint=ax.new(0,1),
}),
d.UIElements.SideBar,
am("Frame",{
Size=aw.new(0,1,1,-20),
Position=aw.new(1,0,0.5,0),
AnchorPoint=ax.new(0,0.5),
ThemeTag={
BackgroundColor3="Outline",
},
BackgroundTransparency=.92,
BorderSizePixel=0,
})
})

if d.ScrollBarEnabled then
aq(d.UIElements.SideBar,d.UIElements.SideBarContainer.Content,d,3)
end

d.UIElements.MainBar=am("Frame",{
Size=aw.new(1,-d.SideBarWidth,1,-d.Topbar.Height),
Position=aw.new(0,d.SideBarWidth,0,d.Topbar.Height),
BackgroundTransparency=1,
},{
al.NewRoundFrame(d.UICorner-(d.UIPadding/2),"Squircle",{
Size=aw.new(1,0,1,0),
ThemeTag={
ImageColor3="PanelBackground",
ImageTransparency="PanelBackgroundTransparency",
},
ZIndex=3,
Name="Background",
Visible=not d.HidePanelBackground,
},{
am("UIStroke",{
Thickness=1,
ThemeTag={
Color="Outline",
},
Transparency=.9,
})
}),
am("UIPadding",{
PaddingLeft=av.new(0,d.UIPadding),
PaddingRight=av.new(0,d.UIPadding),
PaddingBottom=av.new(0,d.UIPadding),
PaddingTop=av.new(0,d.UIPadding),
}),
})


local function CreateMiniStat(m,p)
return am("Frame",{
Size=aw.new(0.3,0,1,0),
BackgroundColor3=au.new(1,1,1),
BackgroundTransparency=.97,
},{
am("UICorner",{CornerRadius=av.new(0,6)}),
am("TextLabel",{
Text=m,
TextSize=9,
ThemeTag={
TextColor3="Accent",
},
Position=aw.new(0.5,0,0.3,0),
AnchorPoint=ax.new(0.5,0.5),
BackgroundTransparency=1,
}),
am("TextLabel",{
Name=p,
Text="...",
TextSize=12,
TextColor3=au.new(1,1,1),
Position=aw.new(0.5,0,0.7,0),
AnchorPoint=ax.new(0.5,0.5),
BackgroundTransparency=1,
FontFace=ay.new(al.Font,az.FontWeight.SemiBold),
})
})
end


local m=am("Frame",{
Size=aw.new(1,0,1,0),
BackgroundTransparency=1,
},{
am("UIListLayout",{
Padding=av.new(0,20),
HorizontalAlignment="Center",
VerticalAlignment="Top",
SortOrder="LayoutOrder",
}),
am("UIPadding",{
PaddingLeft=av.new(0,12),
PaddingRight=av.new(0,12),
PaddingBottom=av.new(0,12),
PaddingTop=av.new(0,12),
}),


am("Frame",{
Size=aw.new(1,0,0,130),
BackgroundTransparency=1,
LayoutOrder=1,
},{
am("UIListLayout",{
Padding=av.new(0,10),
HorizontalAlignment="Center",
}),

am("Frame",{
Size=aw.new(0,85,0,85),
BackgroundColor3=au.fromHex"#1A1A1A",
},{
am("UICorner",{CornerRadius=av.new(0,15)}),
am("UIStroke",{Thickness=2,ThemeTag={Color="Accent"},Transparency=.5}),
am("ImageLabel",{
Name="Avatar",
Size=aw.new(1,-10,1,-10),
Position=aw.new(0.5,0,0.5,0),
AnchorPoint=ax.new(0.5,0.5),
Image=GetUserThumb(false),
BackgroundTransparency=1,
},{
am("UICorner",{CornerRadius=av.new(1,0)})
})
}),
am("Frame",{
Name="NamesContainer",
Size=aw.new(1,0,0,45),
BackgroundTransparency=1,
},{
am("UIListLayout",{HorizontalAlignment="Center",Padding=av.new(0,2),VerticalAlignment="Center"}),
am("TextLabel",{
Text=ah.LocalPlayer.DisplayName,
TextSize=14,
FontFace=ay.new(al.Font,az.FontWeight.Bold),
TextColor3=au.new(1,1,1),
BackgroundTransparency=1,
AutomaticSize="XY",
}),
am("TextLabel",{
Text="@"..ah.LocalPlayer.Name,
TextSize=12,
TextColor3=au.new(1,1,1),
TextTransparency=.5,
BackgroundTransparency=1,
AutomaticSize="XY",
})
})
}),


am("Frame",{
Size=aw.new(0.9,0,0,1),
ThemeTag={
BackgroundColor3="Outline",
},
BackgroundTransparency=0.8,
LayoutOrder=2,
}),


am("Frame",{
Size=aw.new(1,0,0,125),
BackgroundTransparency=1,
LayoutOrder=3,
},{
am("UIListLayout",{Padding=av.new(0,8),HorizontalAlignment="Center"}),
am("TextLabel",{
Text="GAME INFORMATION",
TextSize=10,
FontFace=ay.new(al.Font,az.FontWeight.Bold),
ThemeTag={
TextColor3="Accent",
},
TextTransparency=.4,
BackgroundTransparency=1,
Size=aw.new(1,0,0,20),
}),


am("Frame",{
Size=aw.new(1,0,0,40),
BackgroundColor3=au.new(1,1,1),
BackgroundTransparency=.95,
AutomaticSize="Y",
},{
am("UICorner",{CornerRadius=av.new(0,8)}),
am("UIStroke",{Thickness=1.5,ThemeTag={Color="Outline"},Transparency=.8}),
am("UIPadding",{PaddingLeft=av.new(0,10),PaddingRight=av.new(0,10),PaddingTop=av.new(0,5),PaddingBottom=av.new(0,5)}),
am("TextLabel",{
Name="GameName",
Text="Loading...",
TextSize=12,
TextColor3=au.new(1,1,1),
Size=aw.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
TextWrapped=true,
})
}),


am("Frame",{
Size=aw.new(1,0,0,45),
BackgroundTransparency=1,
},{
am("UIListLayout",{
FillDirection="Horizontal",
Padding=av.new(0,6),
HorizontalAlignment="Center",
}),
CreateMiniStat("FPS","FPSValue"),
CreateMiniStat("PING","PingValue"),
CreateMiniStat("RAM","RamValue"),
})
}),


am("Frame",{
Size=aw.new(1,0,0,50),
ThemeTag={
BackgroundColor3="Outline",
},
BackgroundTransparency=.92,
LayoutOrder=4,
},{
am("UICorner",{CornerRadius=av.new(0,10)}),
am("UIStroke",{Thickness=1.5,ThemeTag={Color="Outline"},Transparency=.6}),
am("ImageLabel",{
Size=aw.new(0,22,0,22),
Position=aw.new(0,12,0.5,0),
AnchorPoint=ax.new(0,0.5),
Image=al.Icon"zap"[1],
ImageRectOffset=al.Icon"zap"[2].ImageRectPosition,
ImageRectSize=al.Icon"zap"[2].ImageRectSize,
ThemeTag={ImageColor3="Accent"},
}),
am("Frame",{
Size=aw.new(1,-20,0,45),
BackgroundTransparency=1,
Position=aw.new(0,10,0,2),
},{
am("UIListLayout",{
FillDirection="Horizontal",
Padding=av.new(0,10),
VerticalAlignment="Center",
}),
am("ImageLabel",{
Name="Avatar",
Size=aw.new(0,32,0,32),
BackgroundTransparency=1,
Image="rbxthumb://type=AvatarHeadShot&id="..(ah.LocalPlayer and ah.LocalPlayer.UserId or 0).."&w=150&h=150",
},{am("UICorner",{CornerRadius=av.new(1,0)})}),
am("Frame",{
Size=aw.new(1,-42,1,0),
BackgroundTransparency=1,
},{
am("UIListLayout",{VerticalAlignment="Center",Padding=av.new(0,2)}),
am("TextLabel",{
Text="@"..(ah.LocalPlayer and ah.LocalPlayer.Name or"Guest"),
TextSize=11,
TextColor3=au.fromHex"#FFC300",
ThemeTag={TextColor3="Accent"},
TextTransparency=0.5,
AutomaticSize="XY",
BackgroundTransparency=1,
}),
am("TextLabel",{
Text=(typeof(identifyexecutor)=="function"and identifyexecutor()or"Xeno"),
TextSize=13,
TextColor3=au.new(1,1,1),
FontFace=ay.new(al.Font,az.FontWeight.Bold),
AutomaticSize="XY",
BackgroundTransparency=1,
})
})
})
})
})

d.UIElements.RightPanel=am("Frame",{
Size=aw.new(0,230,1,0),
Position=aw.new(1,15,0,0),
BackgroundTransparency=1,
Visible=true,
ZIndex=0,
},{
am("CanvasGroup",{
Size=aw.new(1,0,1,0),
BackgroundTransparency=1,
Name="Group"
},{
al.NewRoundFrame(d.UICorner-(d.UIPadding/2),"Squircle",{
Name="Squircle",
Size=aw.new(1,0,1,0),
ThemeTag={
ImageColor3="Background",
ImageTransparency=0.05,
},
ZIndex=3,
},{
am("UIStroke",{
Thickness=2,
ApplyStrokeMode=az.ApplyStrokeMode.Border,
ThemeTag={Color="Outline"},
},{
am("UIGradient",{
Rotation=0,
Name="GlowTrail"
})
})
}),
m
})
})


task.spawn(function()
while task.wait(0.02)do
if d.Destroyed or not d.UIElements.RightPanel then break end
local p=d.UIElements.RightPanel:FindFirstChild"Group"
local r=p and p:FindFirstChild"Squircle"
local u=r and r:FindFirstChildOfClass"UIStroke"
local v=u and u:FindFirstChild"GlowTrail"

if v then
v.Rotation=(v.Rotation+2)%360
local x=al.GetThemeProperty("Outline",al.Theme)or au.fromHex"#00F2FE"
local z=au.new(x.R*0.3,x.G*0.3,x.B*0.3)
v.Color=ColorSequence.new{
ColorSequenceKeypoint.new(0,x),
ColorSequenceKeypoint.new(0.5,z),
ColorSequenceKeypoint.new(1,x),
}
else
break
end
end
end)

function d.ToggleRightPanel(p)
local r=d.UIElements.RightPanel
local u=d.TopBarButtons.SidebarToggle
local v=u and u.Object


d.RightPanelOpen=not d.RightPanelOpen
local x=d.RightPanelOpen

if d.RightPanelTween then
d.RightPanelTween:Cancel()
d.RightPanelTween=nil
end

if x then
r.Visible=true
local z=r:FindFirstChild"Group"
if z then
z.GroupTransparency=1
an(z,0.3,{GroupTransparency=0.05}):Play()
end

if v then
an(v:FindFirstChildWhichIsA("ImageLabel",true),0.3,{Rotation=180}):Play()
end
local A=an(r,0.5,{Position=aw.new(1,-245,0,0)},az.EasingStyle.Back,az.EasingDirection.Out)
d.RightPanelTween=A
A:Play()
else
if v then
an(v:FindFirstChildWhichIsA("ImageLabel",true),0.3,{Rotation=0}):Play()
end
local z=an(r,0.4,{Position=aw.new(1,15,0,0)},az.EasingStyle.Quint,az.EasingDirection.In)
d.RightPanelTween=z
local A
A=z.Completed:Connect(function(B)
A:Disconnect()
if B==az.PlaybackState.Completed and not d.RightPanelOpen then
r.Visible=false
end
end)
z:Play()
end
end



local p=am("ImageLabel",{
Image="rbxassetid://8992230677",
ThemeTag={
ImageColor3="WindowShadow",

},
ImageTransparency=1,
Size=aw.new(1,100,1,100),
Position=aw.new(0,-50,0,-50),
ScaleType="Slice",
SliceCenter=Rect.new(99,99,99,99),
BackgroundTransparency=1,
ZIndex=-999999999999999,
Name="Blur",
})

if ae.TouchEnabled and not ae.KeyboardEnabled then
d.IsPC=false
elseif ae.KeyboardEnabled then
d.IsPC=true
else
d.IsPC=nil
end









local r
local u

local v=false
local x

local z=typeof(d.Background)=="string"and string.match(d.Background,"^video:(.+)")or nil
local A=typeof(d.Background)=="string"
and not z
and string.match(d.Background,"^https?://.+")
or nil

local function GetImageExtension(B)
local C=B:match"%.(%w+)$"or B:match"%.(%w+)%?"
if C then
C=C:lower()
if C=="jpg"or C=="jpeg"or C=="png"or C=="webp"then
return"."..C
end
end
return".png"
end

if typeof(d.Background)=="string"and z then
v=true

if string.find(z,"http")then
local B=d.Folder.."/assets/."..al.SanitizeFilename(z)..".webm"
if not isfile(B)then
local C,F=pcall(function()





local C=game.HttpGet and game:HttpGet(z)
pcall(function()
writefile(B,C)
end)
end)
if not C then
warn("[ IntiHub.Window.Background ] Failed to download video: "..tostring(F))
return
end
end

local C,F=pcall(function()
return getcustomasset(B)
end)
if not C then
warn("[ IntiHub.Window.Background ] Failed to load custom asset: "..tostring(F))
return
end
warn"[ IntiHub.Window.Background ] VideoFrame may not work with custom video"
z=F
end

x=am("VideoFrame",{
BackgroundTransparency=1,
Size=aw.new(1,0,1,0),
Video=z,
Looped=true,
Volume=0,
},{
am("UICorner",{
CornerRadius=av.new(0,d.UICorner),
}),
})
x:Play()
elseif A then
local B=d.Folder
.."/assets/."
..al.SanitizeFilename(A)
..GetImageExtension(A)
if isfile and not isfile(B)then
local C,F=pcall(function()





local C=game.HttpGet and game:HttpGet(A)
pcall(function()
writefile(B,C)
end)
end)
if not C then
warn("[ Window.Background ] Failed to download image: "..tostring(F))
return
end
end

local C,F=pcall(function()
local C,F=pcall(function()
return getcustomasset(B)
end)
if C then
return F
end
return d.Background
end)
if not C then
warn("[ Window.Background ] Failed to load custom asset: "..tostring(F))
return
end

x=am("ImageLabel",{
BackgroundTransparency=1,
Size=aw.new(1,0,1,0),
Image=F,
ImageTransparency=0,
ScaleType="Crop",
},{
am("UICorner",{
CornerRadius=av.new(0,d.UICorner),
}),
})
elseif d.Background then
x=am("ImageLabel",{
BackgroundTransparency=1,
Size=aw.new(1,0,1,0),
Image=typeof(d.Background)=="string"and d.Background or"",
ImageTransparency=1,
ScaleType="Crop",
},{
am("UICorner",{
CornerRadius=av.new(0,d.UICorner),
}),
})
end

local B=al.NewRoundFrame(99,"Squircle",{
ImageTransparency=0.8,
ImageColor3=au.new(1,1,1),
Size=aw.new(0,0,0,4),
Position=aw.new(0.5,0,1,4),
AnchorPoint=ax.new(0.5,0),
},{
am("TextButton",{
Size=aw.new(1,12,1,12),
BackgroundTransparency=1,
Position=aw.new(0.5,0,0.5,0),
AnchorPoint=ax.new(0.5,0.5),
Active=true,
ZIndex=99,
Name="Frame",
}),
})

function createAuthor(C)
return am("TextLabel",{
Text=C,
FontFace=ay.new(al.Font,az.FontWeight.Medium),
BackgroundTransparency=1,
TextTransparency=0.35,
AutomaticSize="XY",
Parent=d.UIElements.Main and d.UIElements.Main.Main.Topbar.Left.Title,
TextXAlignment="Left",
TextSize=13,
LayoutOrder=2,
ThemeTag={
TextColor3="WindowTopbarAuthor",
},
Name="Author",
})
end

local C
local F

if d.Author then
C=createAuthor(d.Author)
end

local G=am("TextLabel",{
Text=d.Title,
FontFace=ay.new(al.Font,az.FontWeight.SemiBold),
BackgroundTransparency=1,
AutomaticSize="XY",
Name="Title",
TextXAlignment="Left",
TextSize=16,
ThemeTag={
TextColor3="WindowTopbarTitle",
},
})

d.UIElements.Main=am("Frame",{
Size=d.Size,
Position=d.Position,
BackgroundTransparency=1,
Parent=b.Parent,
AnchorPoint=ax.new(0.5,0.5),
Active=true,
},{
b.IntiHub.UIScaleObj,
d.AcrylicPaint and d.AcrylicPaint.Frame or nil,
p,
al.NewRoundFrame(d.UICorner,"Squircle",{
ImageTransparency=1,
Size=aw.new(1,0,1,-240),
AnchorPoint=ax.new(0.5,0.5),
Position=aw.new(0.5,0,0.5,0),
Name="Background",
ThemeTag={
ImageColor3="WindowBackground",
ImageTransparency="WindowBackgroundTransparency",
},

},{
x,
B,
h,



}),
am("UIStroke",{
Thickness=2,
ApplyStrokeMode="Border",
ThemeTag={
Color="Accent",
},
},{
am("UIGradient",{
Name="AnimatedGradient1",
Rotation=0,
Color=ColorSequence.new{
ColorSequenceKeypoint.new(0.0,au.fromHex"#FFC300"),
ColorSequenceKeypoint.new(0.5,au.fromHex"#000000"),
ColorSequenceKeypoint.new(1.0,au.fromHex"#FFC300"),
},
})
}),
am("Frame",{
Name="AnimationOverlay",
Size=aw.new(1,0,1,0),
BackgroundTransparency=1,
},{
am("UICorner",{
CornerRadius=av.new(0,d.UICorner),
}),
am("UIStroke",{
Thickness=3,
ApplyStrokeMode="Border",
Transparency=0.5,
ThemeTag={
Color="Accent",
},
},{
am("UIGradient",{
Name="AnimatedGradient2",
Rotation=0,
Color=ColorSequence.new{
ColorSequenceKeypoint.new(0.0,au.fromHex"#000000"),
ColorSequenceKeypoint.new(0.5,au.fromHex"#FFC300"),
ColorSequenceKeypoint.new(1.0,au.fromHex"#000000"),
},
})
})
}),
g,
j,
l,
am("Frame",{
Size=aw.new(1,0,1,0),
BackgroundTransparency=1,
Name="Main",

Visible=false,
ZIndex=97,
},{
am("UICorner",{
CornerRadius=av.new(0,d.UICorner),
}),
d.UIElements.SideBarContainer,
d.UIElements.MainBar,
d.UIElements.RightPanel,



u,
am("Frame",{
Size=aw.new(1,0,0,d.Topbar.Height),
BackgroundTransparency=1,
BackgroundColor3=au.fromRGB(50,50,50),
Name="Topbar",
},{
r,






am("Frame",{
AutomaticSize="X",
Size=aw.new(0,0,1,0),
BackgroundTransparency=1,
Name="Left",
},{
am("UIListLayout",{
Padding=av.new(0,d.UIPadding+4),
SortOrder="LayoutOrder",
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
am("Frame",{
AutomaticSize="XY",
BackgroundTransparency=1,
LayoutOrder=1,
},{
am("UIListLayout",{
Padding=av.new(0,8),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
(function()
local H=al.Image("sun","BrandingLogo",0,d.Folder,"Topbar",true,true,"Accent")
H.Size=aw.fromOffset(22,22)
H.LayoutOrder=1
return H
end)(),

am("Frame",{
Size=aw.new(0,1,0,20),
BackgroundColor3=au.new(1,1,1),
BackgroundTransparency=.8,
BorderSizePixel=0,
LayoutOrder=2,
}),
}),
am("Frame",{
AutomaticSize="XY",
BackgroundTransparency=1,
Name="Title",
Size=aw.new(0,0,1,0),
LayoutOrder=2,
},{
am("UIListLayout",{
Padding=av.new(0,0),
SortOrder="LayoutOrder",
FillDirection="Vertical",
VerticalAlignment="Center",
}),
G,
C,
}),
am("UIPadding",{
PaddingLeft=av.new(0,12),
}),
}),
am("ScrollingFrame",{
Name="Center",
BackgroundTransparency=1,
AutomaticSize="Y",
ScrollBarThickness=0,
ScrollingDirection="X",
AutomaticCanvasSize="X",
CanvasSize=aw.new(0,0,0,0),
Size=aw.new(0,0,1,0),
AnchorPoint=ax.new(0,0.5),
Position=aw.new(0,0,0.5,0),
Visible=false,
},{
am("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Left",
Padding=av.new(0,15),
}),
}),
am("Frame",{
AutomaticSize="XY",
BackgroundTransparency=1,
Position=aw.new(1,0,0.5,0),
AnchorPoint=ax.new(1,0.5),
Name="Right",
},{
am("UIListLayout",{
Padding=av.new(0,d.Topbar.ButtonsType=="Default"and 9 or 0),
FillDirection="Horizontal",
SortOrder="LayoutOrder",
}),
}),
am("UIPadding",{
PaddingTop=av.new(0,d.UIPadding),
PaddingLeft=av.new(
0,
d.Topbar.ButtonsType=="Default"and d.UIPadding or d.UIPadding-2
),
PaddingRight=av.new(0,8),
PaddingBottom=av.new(0,d.UIPadding),
}),
}),
}),
})


al.AddSignal(d.UIElements.Main.Main.Topbar.Left:GetPropertyChangedSignal"AbsoluteSize",function()
local H=(b.IntiHub and b.IntiHub.UIScale)or 1
local J=d.UIElements.Main.Main.Topbar.Left.AbsoluteSize.X/H
local L=d.UIElements.Main.Main.Topbar.Right.UIListLayout.AbsoluteContentSize.X/H

d.UIElements.Main.Main.Topbar.Center.Position=aw.new(0,J+(d.UIPadding/H),0.5,0)
d.UIElements.Main.Main.Topbar.Center.Size=aw.new(1,-J-L-((d.UIPadding*2)/H),1,0)
end)

d.UIElements.RightPanel.Parent=d.UIElements.Main
d.UIElements.TabScrollAdjustment=5



function d.CreateTopbarButton(H,J,L,M,N,O,P,Q)
local R=al.Image(
L,
L,
0,
d.Folder,
"WindowTopbarIcon",
d.Topbar.ButtonsType=="Default"and true or false,
O,
"WindowTopbarButtonIcon"
)
R.Size=d.Topbar.ButtonsType=="Default"
and aw.new(0,Q or d.TopBarButtonIconSize,0,Q or d.TopBarButtonIconSize)
or aw.new(0,0,0,0)
R.AnchorPoint=ax.new(0.5,0.5)
R.Position=aw.new(0.5,0,0.5,0)
local S=R:FindFirstChildWhichIsA("ImageLabel",true)
if S then
S.ImageTransparency=d.Topbar.ButtonsType=="Default"and 0 or 1
if d.Topbar.ButtonsType~="Default"then
S.ImageColor3=al.GetTextColorForHSB(P)
end
end

local T=al.NewRoundFrame(
d.Topbar.ButtonsType=="Default"and d.UICorner-(d.UIPadding/2)or 999,
"Squircle",
{
Size=d.Topbar.ButtonsType=="Default"
and aw.new(0,d.Topbar.Height-16,0,d.Topbar.Height-16)
or aw.new(0,14,0,14),
LayoutOrder=N or 999,


ZIndex=9999,
AnchorPoint=ax.new(0.5,0.5),
Position=aw.new(0.5,0,0.5,0),
ImageColor3=d.Topbar.ButtonsType~="Default"and(P or au.fromHex"#ff3030")or nil,
ThemeTag=d.Topbar.ButtonsType=="Default"and{
ImageColor3="Text",
}or nil,
ImageTransparency=d.Topbar.ButtonsType=="Default"and 1 or 0,
},
{
al.NewRoundFrame(
d.Topbar.ButtonsType=="Default"and d.UICorner-(d.UIPadding/2)or 999,
"Glass-1",
{
Size=aw.new(1,0,1,0),
ThemeTag={
ImageColor3="Outline",
},
ImageTransparency=d.Topbar.ButtonsType=="Default"and 1 or 0.5,
Name="Outline",
}
),
R,
am("UIScale",{
Scale=1,
}),
},
true
)

am("Frame",{
Size=d.Topbar.ButtonsType~="Default"and aw.new(0,24,0,24)
or aw.new(0,d.Topbar.Height-16,0,d.Topbar.Height-16),
BackgroundTransparency=1,
Parent=d.UIElements.Main.Main.Topbar.Right,
LayoutOrder=N or 999,
},{
T,
})



local U={
Name=J,
Object=T,
}
d.TopBarButtons[100-N]=U
d.TopBarButtons[J]=U

al.AddSignal(T.MouseButton1Click,function()
if M then
M()
end
end)
al.AddSignal(T.MouseEnter,function()
if d.Topbar.ButtonsType=="Default"then
an(T,0.15,{ImageTransparency=0.93}):Play()
an(T.Outline,0.15,{ImageTransparency=0.75}):Play()

else

an(
R.ImageLabel,
0.1,
{ImageTransparency=0},
az.EasingStyle.Quint,
az.EasingDirection.Out
):Play()
an(R,0.1,{
Size=aw.new(
0,
Q or d.TopBarButtonIconSize,
0,
Q or d.TopBarButtonIconSize
),
},az.EasingStyle.Quint,az.EasingDirection.Out):Play()
end
end)

al.AddSignal(T.MouseButton1Down,function()
an(T.UIScale,0.2,{Scale=0.9},az.EasingStyle.Quint,az.EasingDirection.Out):Play()
end)

al.AddSignal(T.MouseLeave,function()
if d.Topbar.ButtonsType=="Default"then
an(T,0.1,{ImageTransparency=1}):Play()
an(T.Outline,0.1,{ImageTransparency=1}):Play()

else

an(
R.ImageLabel,
0.1,
{ImageTransparency=1},
az.EasingStyle.Quint,
az.EasingDirection.Out
):Play()
an(
R,
0.1,
{Size=aw.new(0,0,0,0)},
az.EasingStyle.Quint,
az.EasingDirection.Out
):Play()
end
end)

al.AddSignal(T.InputEnded,function()
an(T.UIScale,0.2,{Scale=1},az.EasingStyle.Quint,az.EasingDirection.InOut):Play()
end)

return T
end

function d.Topbar.Button(H,J:{
Name:string,
Icon:string,
Callback:any,
LayoutOrder:number,
IconThemed:boolean,
Color:Color3,
IconSize:number,
})
return d:CreateTopbarButton(
J.Name,
J.Icon,
J.Callback,
J.LayoutOrder or 0,
J.IconThemed,
J.Color,
J.IconSize
)
end



d:CreateTopbarButton("SidebarToggle","panel-right",function()
d:ToggleRightPanel()
end,1000,true,au.fromHex"#00F2FE")


local H=al.Drag(
d.UIElements.Main,
{d.UIElements.Main.Main.Topbar,B.Frame},
function(H,J)
if not d.Closed then
if H and J==B.Frame then
an(B,0.1,{ImageTransparency=0.35}):Play()
else
an(B,0.2,{ImageTransparency=0.8}):Play()
end
d.Position=d.UIElements.Main.Position
d.Dragging=H
end
end
)

if not v and d.Background and typeof(d.Background)=="table"then
local J=am"UIGradient"
for L,M in next,d.Background do
J[L]=M
end

d.UIElements.BackgroundGradient=al.NewRoundFrame(d.UICorner,"Squircle",{
Size=aw.new(1,0,1,0),
Parent=d.UIElements.Main.Background,
ImageTransparency=d.Transparent and b.IntiHub.TransparencyValue or 0,
},{
J,
})
end















d.OpenButtonMain=a.load'C'.New(d)

d.OpenButtonMain:SetIcon(d.Icon)

function d.SetToggleKey(J,L)
d.ToggleKey=L
end

function d.SetTitle(J,L)
d.Title=L
G.Text=L
end

function d.SetAuthor(J,L)
d.Author=L
d.UIElements.Main.Main.Topbar.Left.Author.Text=L
return d
end

function d.SetSize(J,L)
if typeof(L)=="UDim2"then
d.Size=L

an(d.UIElements.Main,0.08,{Size=L},az.EasingStyle.Quint,az.EasingDirection.Out):Play()
end
end

function d.SetBackgroundImage(J,L)
d.UIElements.Main.Background.ImageLabel.Image=L
end
function d.SetBackgroundImageTransparency(J,L)
if x and x:IsA"ImageLabel"then
x.ImageTransparency=aA.floor(L*10+0.5)/10
end
d.BackgroundImageTransparency=aA.floor(L*10+0.5)/10
end

function d.SetBackgroundTransparency(J,L)
local M=aA.floor(tonumber(L)*10+0.5)/10
b.IntiHub.TransparencyValue=M
d:ToggleTransparency(M>0)
end

local J
local L
al.Icon"minimize"
al.Icon"maximize"

d:CreateTopbarButton(
"Fullscreen",
d.Topbar.ButtonsType=="Mac"and"rbxassetid://127426072704909"or"maximize",
function()
d:ToggleFullscreen()
end,
(d.Topbar.ButtonsType=="Default"and 998 or 999),
true,
au.fromHex"#60C762",
d.Topbar.ButtonsType=="Mac"and 9 or nil
)

function d.ToggleFullscreen(M)
local N=d.IsFullscreen

H:Set(N)

if not N then
J=d.UIElements.Main.Position
L=d.UIElements.Main.Size

d.CanResize=false
else
if d.Resizable then
d.CanResize=true
end
end

an(
d.UIElements.Main,
0.45,
{Size=N and L or aw.new(1,-20,1,-72)},
az.EasingStyle.Quint,
az.EasingDirection.Out
):Play()

an(
d.UIElements.Main,
0.45,
{Position=N and J or aw.new(0.5,0,0.5,26)},
az.EasingStyle.Quint,
az.EasingDirection.Out
):Play()



d.IsFullscreen=not N
end

d:CreateTopbarButton("Minimize","minus",function()
d:Close()






















end,(d.Topbar.ButtonsType=="Default"and 997 or 998),nil,au.fromHex"#F4C948")

function d.OnOpen(M,N)
d.OnOpenCallback=N
end
function d.OnClose(M,N)
d.OnCloseCallback=N
end
function d.OnDestroy(M,N)
d.OnDestroyCallback=N
end


d.MinimizedBar=as.New(d)
if not d.HideSearchBar then
d.Search=at.Init(d)
end

if b.IntiHub.UseAcrylic then
d.AcrylicPaint.AddParent(d.UIElements.Main)
end

function d.SetIconSize(M,N)
local O
if typeof(N)=="number"then
O=aw.new(0,N,0,N)
d.IconSize=N
elseif typeof(N)=="UDim2"then
O=N
d.IconSize=N.X.Offset
end

if F then
F.Size=O
end
end

function d.Open(M)
d.UIElements.Main.Visible=true
if d.MinimizedBar then d.MinimizedBar:Visible(false)end
task.spawn(function()
if d.OnOpenCallback then
task.spawn(function()
al.SafeCallback(d.OnOpenCallback)
end)
end

task.wait(0.06)
d.Closed=false

an(d.UIElements.Main.Background,0.2,{
ImageTransparency=d.Transparent and b.IntiHub.TransparencyValue or 0,
},az.EasingStyle.Quint,az.EasingDirection.Out):Play()

if d.UIElements.BackgroundGradient then
an(d.UIElements.BackgroundGradient,0.2,{
ImageTransparency=0,
},az.EasingStyle.Quint,az.EasingDirection.Out):Play()
end

an(d.UIElements.Main.Background,0.4,{
Size=aw.new(1,0,1,0),
},az.EasingStyle.Exponential,az.EasingDirection.Out):Play()

if x then
if x:IsA"VideoFrame"then
x.Visible=true
else
an(x,0.2,{
ImageTransparency=d.BackgroundImageTransparency,
},az.EasingStyle.Quint,az.EasingDirection.Out):Play()
end
end

if d.OpenButtonMain and d.IsOpenButtonEnabled then
d.OpenButtonMain:Visible(false)
end


an(
p,
0.25,
{ImageTransparency=d.ShadowTransparency},
az.EasingStyle.Quint,
az.EasingDirection.Out
):Play()
if UIStroke then
an(UIStroke,0.25,{Transparency=0.8},az.EasingStyle.Quint,az.EasingDirection.Out):Play()
end

task.spawn(function()
task.wait(0.3)
an(
B,
0.45,
{Size=aw.new(0,d.DragFrameSize,0,4),ImageTransparency=0.8},
az.EasingStyle.Exponential,
az.EasingDirection.Out
):Play()
H:Set(true)
task.wait(0.45)
if d.Resizable then
an(
h.ImageLabel,
0.45,
{ImageTransparency=0.8},
az.EasingStyle.Exponential,
az.EasingDirection.Out
):Play()
d.CanResize=true
end
end)

d.CanDropdown=true
d.UIElements.Main:WaitForChild"Main".Visible=true
b.IntiHub:ToggleAcrylic(true)
end)
end
function d.Close(M)
local N={}

if d.OnCloseCallback then
task.spawn(function()
al.SafeCallback(d.OnCloseCallback)
end)
end

b.IntiHub:ToggleAcrylic(false)

d.UIElements.Main:WaitForChild"Main".Visible=false

d.CanDropdown=false
d.Closed=true

an(d.UIElements.Main.Background,0.32,{
ImageTransparency=1,
},az.EasingStyle.Quint,az.EasingDirection.InOut):Play()
if d.UIElements.BackgroundGradient then
an(d.UIElements.BackgroundGradient,0.32,{
ImageTransparency=1,
},az.EasingStyle.Quint,az.EasingDirection.InOut):Play()
end

an(d.UIElements.Main.Background,0.4,{
Size=aw.new(1,0,1,-240),
},az.EasingStyle.Exponential,az.EasingDirection.InOut):Play()


if x then
if x:IsA"VideoFrame"then
x.Visible=false
else
an(x,0.3,{
ImageTransparency=1,
},az.EasingStyle.Quint,az.EasingDirection.Out):Play()
end
end
an(p,0.25,{ImageTransparency=1},az.EasingStyle.Quint,az.EasingDirection.Out):Play()
if UIStroke then
an(UIStroke,0.25,{Transparency=1},az.EasingStyle.Quint,az.EasingDirection.Out):Play()
end

an(
B,
0.3,
{Size=aw.new(0,0,0,4),ImageTransparency=1},
az.EasingStyle.Exponential,
az.EasingDirection.InOut
):Play()
an(
h.ImageLabel,
0.3,
{ImageTransparency=1},
az.EasingStyle.Exponential,
az.EasingDirection.Out
):Play()
H:Set(false)
d.CanResize=false

task.spawn(function()
task.wait(0.4)
d.UIElements.Main.Visible=false

if d.OpenButtonMain and not d.Destroyed and d.IsOpenButtonEnabled then

end
if d.MinimizedBar then d.MinimizedBar:Visible(true)end
end)

function N.Destroy(O)
task.spawn(function()
if d.OnDestroyCallback then
task.spawn(function()
al.SafeCallback(d.OnDestroyCallback)
end)
end
if d.AcrylicPaint and d.AcrylicPaint.Model then
d.AcrylicPaint.Model:Destroy()
end
d.Destroyed=true
task.wait(0.4)
b.IntiHub.ScreenGui:Destroy()
b.IntiHub.NotificationGui:Destroy()
b.IntiHub.DropdownGui:Destroy()
b.IntiHub.TooltipGui:Destroy()

al.DisconnectAll()

return
end)
end

return N
end
function d.Destroy(M)
return d:Close():Destroy()
end
function d.Toggle(M)
if d.Closed then
d:Open()
else
d:Close()
end
end

function d.ToggleTransparency(M,N)

d.Transparent=N
b.IntiHub.Transparent=N

d.UIElements.Main.Background.ImageTransparency=N and b.IntiHub.TransparencyValue or 0


end

function d.LockAll(M)
for N,O in next,d.AllElements do
if O.Lock then
O:Lock()
end
end
end
function d.UnlockAll(M)
for N,O in next,d.AllElements do
if O.Unlock then
O:Unlock()
end
end
end
function d.GetLocked(M)
local N={}

for O,P in next,d.AllElements do
if P.Locked then
table.insert(N,P)
end
end

return N
end
function d.GetUnlocked(M)
local N={}

for O,P in next,d.AllElements do
if P.Locked==false then
table.insert(N,P)
end
end

return N
end

function d.GetUIScale(M,N)
return b.IntiHub.UIScale
end

function d.SetUIScale(M,N)
b.IntiHub.UIScale=N
an(b.IntiHub.UIScaleObj,0.2,{Scale=N},az.EasingStyle.Quint,az.EasingDirection.Out):Play()
return d
end

function d.SetToTheCenter(M)
an(
d.UIElements.Main,
0.45,
{Position=aw.new(0.5,0,0.5,0)},
az.EasingStyle.Quint,
az.EasingDirection.Out
):Play()
return d
end

function d.SetCurrentConfig(M,N)
d.CurrentConfig=N
end

do
local M=40
local N=aj.ViewportSize
local O=d.UIElements.Main.AbsoluteSize

if not d.IsFullscreen and d.AutoScale then
local P=N.X-(M*2)
local Q=N.Y-(M*2)

local R=P/O.X
local S=Q/O.Y

local T=aA.min(R,S)

local U=0.3
local V=1.0

local W=aA.clamp(T,U,V)

local X=d:GetUIScale()or 1
local Y=0.05

if aA.abs(W-X)>Y then
d:SetUIScale(W)
end
end
end



al.AddSignal(ae.InputBegan,function(M,N)
if N then
return
end

if d.ToggleKey then
if M.KeyCode==d.ToggleKey then
d:Toggle()
end
end
end)

task.spawn(function()

d:Open()
end)

function d.EditOpenButton(M,N)
return d.OpenButtonMain:Edit(N)
end

if d.OpenButton and typeof(d.OpenButton)=="table"then
d:EditOpenButton(d.OpenButton)
end

local M=a.load'Z'
local N=a.load'_'
local O=M.Init(d,b.IntiHub,b.IntiHub.TooltipGui)
O:OnChange(function(P)
d.CurrentTab=P
end)

d.TabModule=O

function d.Tab(P,Q)
Q.Parent=d.UIElements.SideBar.Frame
return O.New(Q,b.IntiHub.UIScale)
end
d.CreateTab=d.Tab

function d.SelectTab(P,Q)
O:SelectTab(Q)
end

function d.Section(P,Q)
return N.New(
Q,
d.UIElements.SideBar.Frame,
d.Folder,
b.IntiHub.UIScale,
d
)
end

function d.IsResizable(P,Q)
d.Resizable=Q
d.CanResize=Q
end

function d.SetPanelBackground(P,Q)
if typeof(Q)=="boolean"then
d.HidePanelBackground=Q

d.UIElements.MainBar.Background.Visible=Q

if O then
for R,S in next,O.Containers do
S.ScrollingFrame.UIPadding.PaddingTop=av.new(0,d.HidePanelBackground and 20 or 10)
S.ScrollingFrame.UIPadding.PaddingLeft=
av.new(0,d.HidePanelBackground and 20 or 10)
S.ScrollingFrame.UIPadding.PaddingRight=
av.new(0,d.HidePanelBackground and 20 or 10)
S.ScrollingFrame.UIPadding.PaddingBottom=
av.new(0,d.HidePanelBackground and 20 or 10)
end
end
end
end

function d.Divider(P)
local Q=am("Frame",{
Size=aw.new(1,0,0,1),
Position=aw.new(0.5,0,0,0),
AnchorPoint=ax.new(0.5,0),
BackgroundTransparency=0.9,
ThemeTag={
BackgroundColor3="Text",
},
})
local R=am("Frame",{
Parent=d.UIElements.SideBar.Frame,

Size=aw.new(1,-7,0,5),
BackgroundTransparency=1,
},{
Q,
})

return R
end

local P=a.load'n'.Init(d,b.IntiHub,nil)
function d.Dialog(Q,R)
local S={
Title=R.Title or"Dialog",
Width=R.Width or 320,
Content=R.Content,
Buttons=R.Buttons or{},

TextPadding=14,
}
local T=P.Create(false)

T.UIElements.Main.Size=aw.new(0,S.Width,0,0)

local U=am("Frame",{
Size=aw.new(1,0,1,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Parent=T.UIElements.Main,
},{
am("UIListLayout",{
FillDirection="Vertical",

Padding=av.new(0,T.UIPadding),
}),
})

local V=am("Frame",{
Size=aw.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Parent=U,
},{
am("UIListLayout",{
FillDirection="Horizontal",
Padding=av.new(0,T.UIPadding),
VerticalAlignment="Center",
}),
am("UIPadding",{
PaddingTop=av.new(0,S.TextPadding/2),
PaddingLeft=av.new(0,S.TextPadding/2),
PaddingRight=av.new(0,S.TextPadding/2),
}),
})

local W
if R.Icon then
W=al.Image(
R.Icon,
S.Title..":"..R.Icon,
0,
d,
"Dialog",
true,
R.IconThemed
)
W.Size=aw.new(0,22,0,22)
W.Parent=V
end

T.UIElements.UIListLayout=am("UIListLayout",{
Padding=av.new(0,12),
FillDirection="Vertical",
HorizontalAlignment="Left",
VerticalFlex="SpaceBetween",
Parent=T.UIElements.Main,
})

am("UISizeConstraint",{
MinSize=ax.new(180,20),
MaxSize=ax.new(400,aA.huge),
Parent=T.UIElements.Main,
})

T.UIElements.Title=am("TextLabel",{
Text=S.Title,
TextSize=20,
FontFace=ay.new(al.Font,az.FontWeight.SemiBold),
TextXAlignment="Left",
TextWrapped=true,
RichText=true,
Size=aw.new(1,W and-26-T.UIPadding or 0,0,0),
AutomaticSize="Y",
ThemeTag={
TextColor3="Text",
},
BackgroundTransparency=1,
Parent=V,
})
if S.Content then
am("TextLabel",{
Text=S.Content,
TextSize=18,
TextTransparency=0.4,
TextWrapped=true,
RichText=true,
FontFace=ay.new(al.Font,az.FontWeight.Medium),
TextXAlignment="Left",
Size=aw.new(1,0,0,0),
AutomaticSize="Y",
LayoutOrder=2,
ThemeTag={
TextColor3="Text",
},
BackgroundTransparency=1,
Parent=U,
},{
am("UIPadding",{
PaddingLeft=av.new(0,S.TextPadding/2),
PaddingRight=av.new(0,S.TextPadding/2),
PaddingBottom=av.new(0,S.TextPadding/2),
}),
})
end

local X=am("UIListLayout",{
Padding=av.new(0,6),
FillDirection="Horizontal",
HorizontalAlignment="Center",
HorizontalFlex="Fill",
})

local Y=am("Frame",{
Size=aw.new(1,0,0,40),
AutomaticSize="None",
BackgroundTransparency=1,
Parent=T.UIElements.Main,
LayoutOrder=4,
},{
X,






})

local _={}

for aC,aD in next,S.Buttons do
local aE=
ap(aD.Title,aD.Icon,aD.Callback,aD.Variant,Y,T,true)
table.insert(_,aE)
aE.Size=aw.new(1,0,1,0)
end





















































T:Open()

return T
end

local aC=false

d:CreateTopbarButton("Close","x",function()
if not aC then
if not d.IgnoreAlerts then
aC=true
d:SetToTheCenter()
d:Dialog{

Title="Close Window",
Content="Do you want to close this window? You will not be able to open it again.",
Buttons={
{
Title="Cancel",

Callback=function()
aC=false
end,
Variant="Secondary",
},
{
Title="Close Window",

Callback=function()
aC=false
d:Destroy()
end,
Variant="Primary",
},
},
}
else
d:Destroy()
end
end
end,(d.Topbar.ButtonsType=="Default"and 999 or 997),nil,au.fromHex"#F4695F")

function d.Tag(aD,aE)
if d.UIElements.Main.Main.Topbar.Center.Visible==false then
d.UIElements.Main.Main.Topbar.Center.Visible=true
end
aE.Window=d
aE.LayoutOrder=aE.LayoutOrder or 0
return ar:New(aE,d.UIElements.Main.Main.Topbar.Center)
end

local function startResizing(aD)
if d.CanResize then
isResizing=true
j.Active=true
initialSize=d.UIElements.Main.Size
initialInputPosition=aD.Position


an(h.ImageLabel,0.1,{ImageTransparency=0.35}):Play()

al.AddSignal(aD.Changed,function()
if aD.UserInputState==az.UserInputState.End then
isResizing=false
j.Active=false


an(h.ImageLabel,0.17,{ImageTransparency=0.8}):Play()
end
end)
end
end

al.AddSignal(h.InputBegan,function(aD)
if
aD.UserInputType==az.UserInputType.MouseButton1
or aD.UserInputType==az.UserInputType.Touch
then
if d.CanResize then
startResizing(aD)
end
end
end)

al.AddSignal(ae.InputChanged,function(aD)
if
aD.UserInputType==az.UserInputType.MouseMovement
or aD.UserInputType==az.UserInputType.Touch
then
if isResizing and d.CanResize then
local aE=aD.Position-initialInputPosition
local Q=aw.new(0,initialSize.X.Offset+aE.X*2,0,initialSize.Y.Offset+aE.Y*2)

Q=aw.new(
Q.X.Scale,
aA.clamp(Q.X.Offset,d.MinSize.X,d.MaxSize.X),
Q.Y.Scale,
aA.clamp(Q.Y.Offset,d.MinSize.Y,d.MaxSize.Y)
)

an(d.UIElements.Main,0.08,{
Size=Q,
},az.EasingStyle.Quad,az.EasingDirection.Out):Play()

d.Size=Q
end
end
end)

al.AddSignal(h.MouseEnter,function()
if not isResizing then
an(h.ImageLabel,0.1,{ImageTransparency=0.35}):Play()
end
end)
al.AddSignal(h.MouseLeave,function()
if not isResizing then
an(h.ImageLabel,0.17,{ImageTransparency=0.8}):Play()
end
end)



local aD=0
local aE=0.4
local Q
local R=0

function onDoubleClick()
d:SetToTheCenter()
end

al.AddSignal(B.Frame.MouseButton1Up,function()
local S=tick()
local T=d.Position

R=R+1

if R==1 then
aD=S
Q=T

task.spawn(function()
task.wait(aE)
if R==1 then
R=0
Q=nil
end
end)
elseif R==2 then
if S-aD<=aE and T==Q then
onDoubleClick()
end

R=0
Q=nil
aD=0
else
R=1
aD=S
Q=T
end
end)



if not d.HideSearchBar then
local S=a.load'A'
local T=false


local U=ao("Search...","search",d.UIElements.Main.Main.Topbar.Center,true)
U.Size=aw.new(0,150,0,30)
U.LayoutOrder=5

d.UIElements.Main.Main.Topbar.Center.Visible=true

al.AddSignal(U.MouseButton1Click,function()
if T then
return
end

S.new(d.TabModule,d.UIElements.Main,function()

T=false
if d.Resizable then
d.CanResize=true
end

an(l,0.1,{ImageTransparency=1}):Play()
l.Active=false
end)
an(l,0.1,{ImageTransparency=0.65}):Play()
l.Active=true

T=true
d.CanResize=false
end)
end



function d.DisableTopbarButtons(S,T)
for U,V in next,T do
for W,X in next,d.TopBarButtons do
if X.Name==V then
X.Object.Visible=false
end
end
end
end



local S=aa(game:GetService"Stats")
local T=aa(game:GetService"MarketplaceService")

task.spawn(function()
local U=m:FindFirstChild("GameName",true)
local V=m:FindFirstChild("FPSValue",true)
local W=m:FindFirstChild("PingValue",true)
local X=m:FindFirstChild("RamValue",true)


task.spawn(function()
while not d.Destroyed do
pcall(function()
local Y,_=pcall(function()return T:GetProductInfo(game.PlaceId)end)
if Y and _ and _.Name then
U.Text=_.Name
else
U.Text=game.Name or"Unknown"
end
end)
task.wait(10)
end
end)


local Y=os.clock()
local _=0
local aF
aF=af.RenderStepped:Connect(function()
if d.Destroyed or not m.Parent then
if aF then aF:Disconnect()end
return
end
_=_+1
local aG=os.clock()
if aG-Y>=1 then
pcall(function()
if V then
V.Text=tostring(_)
end
if W then
local aH=0
local aI=S.Network:FindFirstChild"ServerStatsItem"
and S.Network.ServerStatsItem:FindFirstChild"Data Ping"
if aI then
aH=aA.round(aI:GetValue())
end
W.Text=tostring(aH).." ms"
end
if X then
local aH=aA.round(S:GetTotalMemoryUsageMb())
X.Text=tostring(aH).." MB"
end
end)
_=0
Y=aG
end
end)
end)


if d.OpenButtonMain and d.OpenButtonMain.Button then
task.spawn(function()
local aF=d.OpenButtonMain.Button:FindFirstChild("Glow",true)
while task.wait(1.5)do
if aF then
an(aF,0.75,{ImageTransparency=0.4}):Play()
task.wait(0.75)
an(aF,0.75,{ImageTransparency=0.8}):Play()
end
end
end)
end












task.spawn(function()
local aF=d.UIElements.Main:FindFirstChild("AnimatedGradient1",true)
local aG=d.UIElements.Main:FindFirstChild("AnimationOverlay",true)
local aH=aG and aG:FindFirstChild("AnimatedGradient2",true)

local aI=0
local U
U=af.RenderStepped:Connect(function(V)
if d.Destroyed or not d.UIElements.Main then
if U then U:Disconnect()end
return
end
aI=aI+(V*60)
if aF then aF.Rotation=aI%360 end
if aH then aH.Rotation=(360-aI)%360 end
end)
end)

return d
end end function a.ab()



local aa=(cloneref or clonereference or function(aa)
return aa
end)

local ae=aa(game:GetService"RunService")
aa(game:GetService"Players")
local af=aa(game:GetService"Stats")

local ah=a.load'c'
local aj=ah.New local ak=
ah.Tween

local al={}

function al.New(am)
local an=am.IntiHub
local ao=am.Window

local ap=aj("Frame",{
Name="StatusBar",
Size=UDim2.new(0,0,0,45),
Position=UDim2.new(0.5,0,0,10),
AnchorPoint=Vector2.new(0.5,0),
BackgroundColor3=Color3.fromHex"#0F0D00",
BackgroundTransparency=0.2,
AutomaticSize="X",
Visible=true,
Parent=an.ScreenGui,
},{
aj("UICorner",{
CornerRadius=UDim.new(0,10),
}),
aj("UIStroke",{
Thickness=1.5,
ThemeTag={
Color="Accent",
},
Transparency=0.5,
}),
aj("UIListLayout",{
FillDirection="Horizontal",
Padding=UDim.new(0,25),
VerticalAlignment="Center",
SortOrder="LayoutOrder",
}),
aj("UIPadding",{
PaddingLeft=UDim.new(0,20),
PaddingRight=UDim.new(0,20),
}),
})

local function CreateStat(aq,ar,as,at)
local au=aj("Frame",{
Size=UDim2.new(0,0,1,0),
AutomaticSize="X",
BackgroundTransparency=1,
LayoutOrder=at,
},{
aj("UIListLayout",{
FillDirection="Horizontal",
Padding=UDim.new(0,10),
VerticalAlignment="Center",
}),
aj("Frame",{
Size=UDim2.new(0,30,0,30),
BackgroundColor3=Color3.fromHex"#1A1A1A",
ThemeTag={
BackgroundColor3="Accent",
},
},{
aj("UICorner",{CornerRadius=UDim.new(0,6)}),
aj("ImageLabel",{
Image=ah.Icon(aq)and ah.Icon(aq)[1]or"",
ImageRectOffset=ah.Icon(aq)and ah.Icon(aq)[2].ImageRectPosition or Vector2.new(0,0),
ImageRectSize=ah.Icon(aq)and ah.Icon(aq)[2].ImageRectSize or Vector2.new(0,0),
Size=UDim2.new(0,20,0,20),
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
BackgroundTransparency=1,
ImageColor3=Color3.fromHex"#000000",
}),
}),
aj("Frame",{
Size=UDim2.new(0,0,0,0),
AutomaticSize="XY",
BackgroundTransparency=1,
},{
aj("UIListLayout",{FillDirection="Vertical",Padding=UDim.new(0,2)}),
aj("TextLabel",{
Text=ar:upper(),
TextSize=11,
FontFace=Font.new(ah.Font,Enum.FontWeight.Bold),
TextColor3=Color3.fromHex"#FFC300",
ThemeTag={TextColor3="Accent"},
TextTransparency=0.4,
AutomaticSize="XY",
BackgroundTransparency=1,
}),
as,
}),
})
au.Parent=ap
return as
end


local aq=ao.Icon or"rbxassetid://0"
if typeof(aq)=="string"and string.find(aq,"http")then
aq=ah.GetAsset(aq,ao.Folder,"icon","StatusBarLogo")
end

local ar=aj("Frame",{
Size=UDim2.new(0,0,1,0),
AutomaticSize="X",
BackgroundTransparency=1,
LayoutOrder=1,
},{
aj("UIListLayout",{
FillDirection="Horizontal",
Padding=UDim.new(0,10),
VerticalAlignment="Center",
}),
aj("Frame",{
Size=UDim2.new(0,30,0,30),
BackgroundColor3=Color3.fromHex"#FFC300",
ThemeTag={
BackgroundColor3="Accent",
},
},{
aj("UICorner",{CornerRadius=UDim.new(0,4)}),
aj("ImageLabel",{
Image=aq,
Size=UDim2.new(0,22,0,22),
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
BackgroundTransparency=1,
ImageColor3=Color3.new(0,0,0),
}),
}),
aj("TextLabel",{
Text="INTIHUB",
TextSize=16,
FontFace=Font.new(ah.Font,Enum.FontWeight.Bold),
TextColor3=Color3.fromHex"#FFC300",
ThemeTag={
TextColor3="Accent",
},
AutomaticSize="XY",
BackgroundTransparency=1,
}),
})
ar.Parent=ap


aj("Frame",{
Size=UDim2.new(0,1,0,25),
BackgroundColor3=Color3.new(1,1,1),
BackgroundTransparency=0.8,
Parent=ap,
LayoutOrder=2,
})

local as=aj("TextLabel",{
Text="0 ms",
TextSize=14,
FontFace=Font.new(ah.Font,Enum.FontWeight.Bold),
TextColor3=Color3.fromHex"#FFC300",
ThemeTag={TextColor3="Accent"},
AutomaticSize="XY",
BackgroundTransparency=1,
})
CreateStat("solar:transmission-bold","PING",as,5)

local at=aj("TextLabel",{
Text="0 MB",
TextSize=14,
FontFace=Font.new(ah.Font,Enum.FontWeight.Bold),
TextColor3=Color3.fromHex"#FFC300",
ThemeTag={TextColor3="Accent"},
AutomaticSize="XY",
BackgroundTransparency=1,
})
CreateStat("solar:cpu-bold","RAM",at,6)

local au=aj("TextLabel",{
Text="0 FPS",
TextSize=14,
FontFace=Font.new(ah.Font,Enum.FontWeight.Bold),
TextColor3=Color3.fromHex"#FFC300",
ThemeTag={TextColor3="Accent"},
AutomaticSize="XY",
BackgroundTransparency=1,
})
CreateStat("solar:chart-2-bold","FPS",au,7)

local av=aj("TextLabel",{
Text="00:00:00",
TextSize=14,
FontFace=Font.new(ah.Font,Enum.FontWeight.Bold),
TextColor3=Color3.fromHex"#FFC300",
ThemeTag={TextColor3="Accent"},
AutomaticSize="XY",
BackgroundTransparency=1,
})
CreateStat("solar:clock-circle-bold","TIME",av,8)


local aw=tick()
local ax=0
local ay=0

local az=ae.RenderStepped:Connect(function()
ax=ax+1
local az=tick()
if az-aw>=1 then
ay=ax
ax=0
aw=az

au.Text=tostring(ay).." FPS"
av.Text=os.date"%H:%M:%S"

local aA=math.floor(af.Network.ServerStatsItem["Data Ping"]:GetValue())
as.Text=tostring(aA).." ms"

local aB=math.floor(af:GetTotalMemoryUsageMb())
if aB>1024 then
at.Text=string.format("%.1f GB",aB/1024)
else
at.Text=tostring(aB).." MB"
end
end
end)

ap.Position=UDim2.new(0.5,0,1,-60)

ah.Drag(ap)

local aA={}

function aA.Destroy(aB)
az:Disconnect()
ap:Destroy()
end

function aA.Visible(aB,aC)
ap.Visible=aC
end

return aA
end

return al end end

local aa={
Window=nil,
Theme=nil,
Creator=a.load'c',
LocalizationModule=a.load'd',
NotificationModule=a.load'e',
Themes=nil,
Transparent=false,

TransparencyValue=0.15,

UIScale=1,

ConfigManager=nil,
Version="0.0.0",

Services=a.load'j',

OnThemeChangeFunction=nil,

cloneref=nil,
UIScaleObj=nil,
StatusBar=nil,
}

local ae=(cloneref or clonereference or function(ae)
return ae
end)

aa.cloneref=ae

local af=ae(game:GetService"HttpService")
local ah=ae(game:GetService"Players")
local aj=ae(game:GetService"CoreGui")
local ak=ae(game:GetService"RunService")

local al=ah.LocalPlayer or nil

local am=af:JSONDecode(a.load'k')
if am then
aa.Version=am.version
end

local an=a.load'o'

local ao=aa.Creator

local ap=ao.New




local aq=a.load's'

local ar=protectgui or(syn and syn.protect_gui)or function()end

local as=gethui and gethui()or(aj or al:WaitForChild"PlayerGui")

local at=ap("UIScale",{
Scale=aa.UIScale,
})

aa.UIScaleObj=at

aa.ScreenGui=ap("ScreenGui",{
Name="IntiHub",
Parent=as,
IgnoreGuiInset=true,
ScreenInsets="None",
DisplayOrder=100,
},{

ap("Folder",{
Name="Window",
}),






ap("Folder",{
Name="KeySystem",
}),
ap("Folder",{
Name="Popups",
}),
ap("Folder",{
Name="ToolTips",
}),
})

aa.NotificationGui=ap("ScreenGui",{
Name="IntiHub/Notifications",
Parent=as,
IgnoreGuiInset=true,
DisplayOrder=2001,
})
aa.DropdownGui=ap("Folder",{
Name="Dropdowns",
Parent=aa.ScreenGui,
})
aa.TooltipGui=ap("ScreenGui",{
Name="IntiHub/Tooltips",
Parent=as,
IgnoreGuiInset=true,
})
ar(aa.ScreenGui)
ar(aa.NotificationGui)
ar(aa.TooltipGui)

ao.Init(aa)

function aa.SetParent(au,av)
if aa.ScreenGui then
aa.ScreenGui.Parent=av
end
if aa.NotificationGui then
aa.NotificationGui.Parent=av
end
if aa.TooltipGui then
aa.TooltipGui.Parent=av
end
end
math.clamp(aa.TransparencyValue,0,1)

local au=aa.NotificationModule.Init(aa.NotificationGui)

function aa.Notify(av,aw)
aw.Holder=au.Frame
aw.Window=aa.Window

return aa.NotificationModule.New(aw)
end

function aa.SetNotificationLower(av,aw)
au.SetLower(aw)
end

function aa.SetFont(av,aw)
ao.UpdateFont(aw)
end

function aa.OnThemeChange(av,aw)
aa.OnThemeChangeFunction=aw
end

function aa.AddTheme(av,aw)
aa.Themes[aw.Name]=aw
return aw
end

function aa.SetTheme(av,aw)
if aa.Themes[aw]then
aa.Theme=aa.Themes[aw]
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
function aa.Localization(av,aw)
return aa.LocalizationModule:New(aw,ao)
end

function aa.SetLanguage(av,aw)
if ao.Localization then
return ao.SetLanguage(aw)
end
return false
end

function aa.ToggleAcrylic(av,aw)
if aa.Window and aa.Window.AcrylicPaint and aa.Window.AcrylicPaint.Model then
aa.Window.Acrylic=aw
aa.Window.AcrylicPaint.Model.Transparency=aw and 0.98 or 1
if aw and typeof(aq)=="table"and aq.Enable then
aq.Enable()
elseif not aw and typeof(aq)=="table"and aq.Disable then
aq.Disable()
end
end
end

function aa.Gradient(av,aw,ax)
local ay={}
local az={}

for aA,aB in next,aw do
local aC=tonumber(aA)
if aC then
aC=math.clamp(aC/100,0,1)

local aD=aB.Color
if typeof(aD)=="string"and string.sub(aD,1,1)=="#"then
aD=Color3.fromHex(aD)
end

local aE=aB.Transparency or 0

table.insert(ay,ColorSequenceKeypoint.new(aC,aD))
table.insert(az,NumberSequenceKeypoint.new(aC,aE))
end
end

table.sort(ay,function(aA,aB)
return aA.Time<aB.Time
end)
table.sort(az,function(aA,aB)
return aA.Time<aB.Time
end)

if#ay<2 then
table.insert(ay,ColorSequenceKeypoint.new(1,ay[1].Value))
table.insert(az,NumberSequenceKeypoint.new(1,az[1].Value))
end

local aA={
Color=ColorSequence.new(ay),
Transparency=NumberSequence.new(az),
}

if ax then
for aB,aC in pairs(ax)do
aA[aB]=aC
end
end

return aA
end

function aa.Popup(av,aw)
aw.IntiHub=aa
return a.load't'.new(aw)
end

aa.Themes=a.load'u'(aa)

ao.Themes=aa.Themes

aa:SetTheme"Dark"
aa:SetLanguage(ao.Language)

function aa.CreateWindow(av,aw)
local ax=a.load'aa'

if not ak:IsStudio()and writefile then
pcall(function()
if not isfolder"IntiHub_Data"then
makefolder"IntiHub_Data"
end
local ay="IntiHub_Data/"..(aw.Folder or aw.Title or"Default")
if not isfolder(ay)then
makefolder(ay)
end
end)
end

aw.IntiHub=aa
aw.Parent=aa.ScreenGui.Window

if aa.Window then
warn"You cannot create more than one window"
return
end

local ay=true

local az=aa.Themes[aw.Theme or"Dark"]


ao.SetTheme(az)

local aA=gethwid or function()
return ah.LocalPlayer.UserId
end

local aB=aA()

if aw.KeySystem then
ay=false

local function loadKeysystem()
an.new(aw,aB,function(aC)
ay=aC
end)
end

local aC=(aw.Folder or"Temp").."/"..aB..".key"

if aw.KeySystem.KeyValidator then
if aw.KeySystem.SaveKey and isfile(aC)then
local aD,aE=pcall(function()
return readfile(aC)
end)

if aD then
local aF=aw.KeySystem.KeyValidator(aE)

if aF then
ay=true
else
loadKeysystem()
end
else
loadKeysystem()
end
else
loadKeysystem()
end
elseif not aw.KeySystem.API then
if aw.KeySystem.SaveKey and isfile(aC)then
local aD,aE=pcall(function()
return readfile(aC)
end)

if aD then
local aF=(type(aw.KeySystem.Key)=="table")and table.find(aw.KeySystem.Key,aE)
or tostring(aw.KeySystem.Key)==tostring(aE)

if aF then
ay=true
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
if isfile(aC)then
local aD,aE=pcall(function()
return readfile(aC)
end)

if aD then
local aF=false

for aG,aH in next,aw.KeySystem.API do
local aI=aa.Services[aH.Type]
if aI then
local b={}
for d,f in next,aI.Args do
table.insert(b,aH[f])
end

local d=aI.New(table.unpack(b))
local f=d.Verify(aE)
if f then
aF=true
break
end
end
end

ay=aF
if not aF then
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
until ay
end

local aC=ax(aw)

aa.Transparent=aw.Transparent
aa.Window=aC

aa.StatusBar=a.load'ab'.New{
IntiHub=aa,
Window=aC,
}

aC:OnDestroy(function()
if aa.StatusBar then
aa.StatusBar:Destroy()
aa.StatusBar=nil
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