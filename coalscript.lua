--//====================================================//
--//                 COAL HUB V2                       //
--//        Modern Mobile / PC Roblox Interface        //
--//====================================================//

--======================================================
-- STATES
--======================================================

local AimbotEnabled = false
local FovEnabled = false
local FovRadius = 150
local WallCheckEnabled = false

local ESPEnabled = false
local TracersEnabled = false
local NamesEnabled = false
local FullbrightEnabled = false
local SpinEnabled = false

local WalkSpeedEnabled = false
local WalkSpeedValue = 16
local JumpPowerEnabled = false
local JumpPowerValue = 50
local NoclipEnabled = false
local FlyEnabled = false
local FlySpeedValue = 50
local InfJumpEnabled = false

local SelectedTargetPlayer = nil

local ThemeColor = Color3.fromRGB(0, 170, 255)
local CurrentFont = Enum.Font.GothamBold

local ShowFPS = false
local ShowPing = false
local ShowCPS = false
local CpsCounter = 0

--======================================================
-- SERVICES
--======================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local StatsService = game:GetService("Stats")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--======================================================
-- COLORS
--======================================================

local BG = Color3.fromRGB(10, 12, 18)
local BG2 = Color3.fromRGB(15, 18, 27)
local PANEL = Color3.fromRGB(20, 24, 35)
local PANEL2 = Color3.fromRGB(25, 30, 43)
local PANEL_HOVER = Color3.fromRGB(31, 37, 52)

local TEXT = Color3.fromRGB(240, 243, 250)
local SUBTEXT = Color3.fromRGB(145, 153, 170)
local OFF = Color3.fromRGB(55, 62, 78)

--======================================================
-- LIGHTING DEFAULTS
--======================================================

local DefaultAmbient = Lighting.Ambient
local DefaultOutdoorAmbient = Lighting.OutdoorAmbient
local DefaultBrightness = Lighting.Brightness
local DefaultClockTime = Lighting.ClockTime

--======================================================
-- SCREEN GUI
--======================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CoalHubV2"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 9999
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local pGui = LocalPlayer:WaitForChild("PlayerGui", 5)

if pGui then
    ScreenGui.Parent = pGui
else
    ScreenGui.Parent = game:GetService("CoreGui")
end

--======================================================
-- UTILITY
--======================================================

local function corner(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = obj
    return c
end

local function stroke(obj, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0
    s.Parent = obj
    return s
end

local function tween(obj, info, props)
    return TweenService:Create(obj, info, props)
end

--======================================================
-- FOV
--======================================================

local FovFrame = Instance.new("Frame")
FovFrame.Name = "FovCircle"
FovFrame.AnchorPoint = Vector2.new(0.5, 0.5)
FovFrame.Position = UDim2.fromScale(0.5, 0.5)
FovFrame.Size = UDim2.fromOffset(FovRadius * 2, FovRadius * 2)
FovFrame.BackgroundTransparency = 1
FovFrame.Visible = false
FovFrame.Parent = ScreenGui

corner(FovFrame, 999)

local FovStroke = stroke(
    FovFrame,
    ThemeColor,
    2,
    0
)

--======================================================
-- MINI BUTTON
--======================================================

local MiniSquare = Instance.new("TextButton")
MiniSquare.Name = "MiniButton"
MiniSquare.Size = UDim2.fromOffset(54, 54)
MiniSquare.Position = UDim2.new(0, 20, 0.5, -27)
MiniSquare.BackgroundColor3 = BG2
MiniSquare.BackgroundTransparency = 0.05
MiniSquare.Text = "C"
MiniSquare.TextColor3 = ThemeColor
MiniSquare.TextSize = 22
MiniSquare.Font = CurrentFont
MiniSquare.Visible = false
MiniSquare.AutoButtonColor = false
MiniSquare.Active = true
MiniSquare.Parent = ScreenGui

corner(MiniSquare, 16)

local MiniStroke = stroke(MiniSquare, ThemeColor, 2, 0)

--======================================================
-- HUD
--======================================================

local HudFrame = Instance.new("Frame")
HudFrame.Name = "StatsHUD"
HudFrame.Size = UDim2.fromOffset(155, 95)
HudFrame.Position = UDim2.new(0, 15, 0.3, 0)
HudFrame.BackgroundColor3 = BG
HudFrame.BackgroundTransparency = 0.08
HudFrame.BorderSizePixel = 0
HudFrame.Active = true
HudFrame.Visible = false
HudFrame.Parent = ScreenGui

corner(HudFrame, 14)

local HudStroke = stroke(HudFrame, ThemeColor, 1.5, 0)

local HudPadding = Instance.new("UIPadding")
HudPadding.PaddingTop = UDim.new(0, 10)
HudPadding.PaddingLeft = UDim.new(0, 12)
HudPadding.PaddingRight = UDim.new(0, 8)
HudPadding.Parent = HudFrame

local HudList = Instance.new("UIListLayout")
HudList.SortOrder = Enum.SortOrder.LayoutOrder
HudList.Padding = UDim.new(0, 5)
HudList.Parent = HudFrame

local function makeHudLabel(text)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 18)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = TEXT
    label.TextSize = 12
    label.Font = CurrentFont
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = HudFrame
    return label
end

local FpsLabel = makeHudLabel("FPS  •  60")
local PingLabel = makeHudLabel("PING • 0 ms")
local CpsLabel = makeHudLabel("CPS  • 0")

FpsLabel.Visible = false
PingLabel.Visible = false
CpsLabel.Visible = false

--======================================================
-- MAIN WINDOW
--======================================================

local MainFrame = Instance.new("CanvasGroup")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.fromOffset(590, 390)
MainFrame.Position = UDim2.new(0.5, -295, 0.5, -195)
MainFrame.BackgroundColor3 = BG
MainFrame.GroupTransparency = 0
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

corner(MainFrame, 18)

local MainStroke = stroke(MainFrame, Color3.fromRGB(45, 53, 70), 1.5, 0)

--======================================================
-- TOP BAR
--======================================================

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 58)
TopBar.BackgroundColor3 = BG2
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

corner(TopBar, 18)

local TopFix = Instance.new("Frame")
TopFix.Size = UDim2.new(1, 0, 0, 20)
TopFix.Position = UDim2.new(0, 0, 1, -20)
TopFix.BackgroundColor3 = BG2
TopFix.BorderSizePixel = 0
TopFix.Parent = TopBar

local Logo = Instance.new("Frame")
Logo.Size = UDim2.fromOffset(36, 36)
Logo.Position = UDim2.new(0, 12, 0.5, -18)
Logo.BackgroundColor3 = ThemeColor
Logo.Parent = TopBar

corner(Logo, 11)

local LogoText = Instance.new("TextLabel")
LogoText.Size = UDim2.fromScale(1, 1)
LogoText.BackgroundTransparency = 1
LogoText.Text = "C"
LogoText.TextColor3 = Color3.new(1, 1, 1)
LogoText.TextSize = 20
LogoText.Font = Enum.Font.GothamBlack
LogoText.Parent = Logo

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(0, 220, 0, 25)
TitleText.Position = UDim2.new(0, 58, 0, 8)
TitleText.BackgroundTransparency = 1
TitleText.Text = "COAL HUB"
TitleText.TextColor3 = TEXT
TitleText.TextSize = 17
TitleText.Font = Enum.Font.GothamBlack
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TopBar

local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(0, 220, 0, 18)
SubTitle.Position = UDim2.new(0, 59, 0, 30)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "MODERN EDITION  •  V2"
SubTitle.TextColor3 = SUBTEXT
SubTitle.TextSize = 9
SubTitle.Font = Enum.Font.GothamMedium
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.Parent = TopBar

-- Close button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.fromOffset(34, 34)
CloseBtn.Position = UDim2.new(1, -45, 0.5, -17)
CloseBtn.BackgroundColor3 = Color3.fromRGB(38, 42, 55)
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(230, 235, 245)
CloseBtn.TextSize = 23
CloseBtn.Font = Enum.Font.GothamMedium
CloseBtn.AutoButtonColor = false
CloseBtn.Parent = TopBar

corner(CloseBtn, 10)

--======================================================
-- SIDEBAR
--======================================================

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 145, 1, -58)
Sidebar.Position = UDim2.new(0, 0, 0, 58)
Sidebar.BackgroundColor3 = Color3.fromRGB(13, 16, 24)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SidebarPadding = Instance.new("UIPadding")
SidebarPadding.PaddingTop = UDim.new(0, 12)
SidebarPadding.PaddingLeft = UDim.new(0, 10)
SidebarPadding.PaddingRight = UDim.new(0, 10)
SidebarPadding.Parent = Sidebar

local SidebarList = Instance.new("UIListLayout")
SidebarList.SortOrder = Enum.SortOrder.LayoutOrder
SidebarList.Padding = UDim.new(0, 7)
SidebarList.Parent = Sidebar

--======================================================
-- CONTENT
--======================================================

local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -145, 1, -58)
ContentContainer.Position = UDim2.new(0, 145, 0, 58)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

--======================================================
-- PAGES
--======================================================

local function createPage()
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.fromScale(1, 1)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = ThemeColor
    page.ScrollBarImageTransparency = 0.15
    page.Visible = false
    page.Parent = ContentContainer

    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 14)
    padding.PaddingLeft = UDim.new(0, 14)
    padding.PaddingRight = UDim.new(0, 18)
    padding.PaddingBottom = UDim.new(0, 15)
    padding.Parent = page

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 9)
    layout.Parent = page

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(
            0,
            0,
            0,
            layout.AbsoluteContentSize.Y + 30
        )
    end)

    return page
end

local MainPage = createPage()
local TeleportPage = createPage()
local CombatPage = createPage()
local VisualsPage = createPage()
local SettingsPage = createPage()

MainPage.Visible = true

--======================================================
-- TAB BUTTONS
--======================================================

local TabButtons = {}

local function createTab(text, icon, page)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 42)
    btn.BackgroundColor3 = Color3.fromRGB(18, 22, 32)
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.Parent = Sidebar

    corner(btn, 11)

    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.fromOffset(28, 42)
    iconLabel.Position = UDim2.new(0, 7, 0, 0)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = icon
    iconLabel.TextColor3 = SUBTEXT
    iconLabel.TextSize = 17
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.Parent = btn

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -42, 1, 0)
    textLabel.Position = UDim2.new(0, 39, 0, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text
    textLabel.TextColor3 = SUBTEXT
    textLabel.TextSize = 12
    textLabel.Font = Enum.Font.GothamSemibold
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Parent = btn

    btn.MouseEnter:Connect(function()
        if btn:GetAttribute("Active") ~= true then
            tween(
                btn,
                TweenInfo.new(0.15),
                {BackgroundColor3 = PANEL_HOVER}
            ):Play()
        end
    end)

    btn.MouseLeave:Connect(function()
        if btn:GetAttribute("Active") ~= true then
            tween(
                btn,
                TweenInfo.new(0.15),
                {BackgroundColor3 = Color3.fromRGB(18,22,32)}
            ):Play()
        end
    end)

    btn.MouseButton1Click:Connect(function()

        MainPage.Visible = false
        TeleportPage.Visible = false
        CombatPage.Visible = false
        VisualsPage.Visible = false
        SettingsPage.Visible = false

        page.Visible = true

        for _, tab in ipairs(TabButtons) do
            tab:SetAttribute("Active", false)
            tween(
                tab,
                TweenInfo.new(0.18),
                {
                    BackgroundColor3 = Color3.fromRGB(18,22,32)
                }
            ):Play()

            local i = tab:FindFirstChild("Icon")
            local t = tab:FindFirstChild("TabText")

            if i then
                i.TextColor3 = SUBTEXT
            end

            if t then
                t.TextColor3 = SUBTEXT
            end
        end

        btn:SetAttribute("Active", true)

        tween(
            btn,
            TweenInfo.new(0.2, Enum.EasingStyle.Quart),
            {
                BackgroundColor3 = ThemeColor
            }
        ):Play()

        iconLabel.TextColor3 = Color3.new(1,1,1)
        textLabel.TextColor3 = Color3.new(1,1,1)
    end)

    iconLabel.Name = "Icon"
    textLabel.Name = "TabText"

    table.insert(TabButtons, btn)

    return btn
end

local MainTabBtn = createTab("Main", "◆", MainPage)
local TeleportTabBtn = createTab("Teleport", "◇", TeleportPage)
local CombatTabBtn = createTab("Combat", "⚔", CombatPage)
local VisualsTabBtn = createTab("Visuals", "◉", VisualsPage)
local SettingsTabBtn = createTab("Settings", "⚙", SettingsPage)

MainTabBtn:SetAttribute("Active", true)
MainTabBtn.BackgroundColor3 = ThemeColor

MainTabBtn.Icon.TextColor3 = Color3.new(1,1,1)
MainTabBtn.TabText.TextColor3 = Color3.new(1,1,1)

--======================================================
-- SECTION HEADER
--======================================================

local function createSection(page, title, description)

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 47)
    frame.BackgroundTransparency = 1
    frame.Parent = page

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 24)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = TEXT
    titleLabel.TextSize = 16
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = frame

    local desc = Instance.new("TextLabel")
    desc.Size = UDim2.new(1, 0, 0, 18)
    desc.Position = UDim2.new(0, 0, 0, 25)
    desc.BackgroundTransparency = 1
    desc.Text = description
    desc.TextColor3 = SUBTEXT
    desc.TextSize = 10
    desc.Font = Enum.Font.Gotham
    desc.TextXAlignment = Enum.TextXAlignment.Left
    desc.Parent = frame

    return frame
end

--======================================================
-- TOGGLE
--======================================================

local function createToggle(page, text, defaultState, callback)

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 48)
    frame.BackgroundColor3 = PANEL
    frame.BorderSizePixel = 0
    frame.Parent = page

    corner(frame, 12)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -75, 1, 0)
    label.Position = UDim2.new(0, 14, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = TEXT
    label.TextSize = 12
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.fromOffset(45, 25)
    toggle.Position = UDim2.new(1, -59, 0.5, -12)
    toggle.BackgroundColor3 = defaultState and ThemeColor or OFF
    toggle.Text = ""
    toggle.AutoButtonColor = false
    toggle.Parent = frame

    corner(toggle, 999)

    local dot = Instance.new("Frame")
    dot.Size = UDim2.fromOffset(19, 19)
    dot.Position = defaultState
        and UDim2.new(1, -22, 0.5, -9)
        or UDim2.new(0, 3, 0.5, -9)
    dot.BackgroundColor3 = Color3.new(1,1,1)
    dot.Parent = toggle

    corner(dot, 999)

    local state = defaultState

    toggle.MouseButton1Click:Connect(function()

        state = not state

        local targetColor = state and ThemeColor or OFF

        local targetPosition = state
            and UDim2.new(1, -22, 0.5, -9)
            or UDim2.new(0, 3, 0.5, -9)

        tween(
            toggle,
            TweenInfo.new(0.2, Enum.EasingStyle.Quart),
            {BackgroundColor3 = targetColor}
        ):Play()

        tween(
            dot,
            TweenInfo.new(0.2, Enum.EasingStyle.Quart),
            {Position = targetPosition}
        ):Play()

        callback(state)
    end)

    return frame
end

--======================================================
-- SLIDER
--======================================================

local function createSlider(page, text, min, max, default, callback)

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 62)
    frame.BackgroundColor3 = PANEL
    frame.BorderSizePixel = 0
    frame.Parent = page

    corner(frame, 12)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -75, 0, 22)
    label.Position = UDim2.new(0, 14, 0, 6)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = TEXT
    label.TextSize = 12
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.fromOffset(55, 22)
    valueLabel.Position = UDim2.new(1, -69, 0, 6)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = ThemeColor
    valueLabel.TextSize = 12
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = frame

    local back = Instance.new("TextButton")
    back.Size = UDim2.new(1, -28, 0, 7)
    back.Position = UDim2.new(0, 14, 1, -18)
    back.BackgroundColor3 = OFF
    back.Text = ""
    back.AutoButtonColor = false
    back.Parent = frame

    corner(back, 999)

    local factor = math.clamp(
        (default - min) / (max - min),
        0,
        1
    )

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(factor, 0, 1, 0)
    fill.BackgroundColor3 = ThemeColor
    fill.BorderSizePixel = 0
    fill.Parent = back

    corner(fill, 999)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.fromOffset(15, 15)
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new(factor, 0, 0.5, 0)
    knob.BackgroundColor3 = Color3.new(1,1,1)
    knob.Parent = back

    corner(knob, 999)

    local dragging = false

    local function update(input)

        local x = input.Position.X - back.AbsolutePosition.X

        local f = math.clamp(
            x / back.AbsoluteSize.X,
            0,
            1
        )

        local value = math.floor(
            min + (max - min) * f
        )

        fill.Size = UDim2.new(f, 0, 1, 0)
        knob.Position = UDim2.new(f, 0, 0.5, 0)

        valueLabel.Text = tostring(value)

        callback(value)
    end

    back.InputBegan:Connect(function(input)

        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

            dragging = true
            update(input)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)

        if dragging then

            if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then

                update(input)
            end
        end
    end)

    UserInputService.InputEnded:Connect(function(input)

        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

            dragging = false
        end
    end)

    return frame
end

--======================================================
-- BUTTON
--======================================================

local function createButton(page, text, callback)

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 42)
    btn.BackgroundColor3 = ThemeColor
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    btn.Parent = page

    corner(btn, 11)

    btn.MouseEnter:Connect(function()

        tween(
            btn,
            TweenInfo.new(0.15),
            {
                BackgroundColor3 = ThemeColor:Lerp(
                    Color3.new(1,1,1),
                    0.12
                )
            }
        ):Play()
    end)

    btn.MouseLeave:Connect(function()

        tween(
            btn,
            TweenInfo.new(0.15),
            {
                BackgroundColor3 = ThemeColor
            }
        ):Play()
    end)

    btn.MouseButton1Click:Connect(callback)

    return btn
end

--======================================================
-- MAIN PAGE
--======================================================

createSection(
    MainPage,
    "Movement",
    "Настройки передвижения персонажа"
)

createToggle(
    MainPage,
    "Включить скорость бега",
    false,
    function(v)
        WalkSpeedEnabled = v
    end
)

createSlider(
    MainPage,
    "Скорость бега",
    1,
    300,
    WalkSpeedValue,
    function(v)
        WalkSpeedValue = v
    end
)

createToggle(
    MainPage,
    "Включить высоту прыжка",
    false,
    function(v)
        JumpPowerEnabled = v
    end
)

createSlider(
    MainPage,
    "Высота прыжка",
    1,
    300,
    JumpPowerValue,
    function(v)
        JumpPowerValue = v
    end
)

createToggle(
    MainPage,
    "Бесконечный прыжок",
    false,
    function(v)
        InfJumpEnabled = v
    end
)

createToggle(
    MainPage,
    "Noclip",
    false,
    function(v)
        NoclipEnabled = v
    end
)

createToggle(
    MainPage,
    "Fly",
    false,
    function(v)
        FlyEnabled = v
    end
)

createSlider(
    MainPage,
    "Скорость полёта",
    1,
    300,
    FlySpeedValue,
    function(v)
        FlySpeedValue = v
    end
)

--======================================================
-- TELEPORT
--======================================================

createSection(
    TeleportPage,
    "Teleport",
    "Выберите игрока для телепортации"
)

local RefreshBtn = createButton(
    TeleportPage,
    "↻  Обновить список игроков",
    function() end
)

local PlayerListContainer = Instance.new("Frame")
PlayerListContainer.Size = UDim2.new(1, 0, 0, 135)
PlayerListContainer.BackgroundColor3 = PANEL
PlayerListContainer.BorderSizePixel = 0
PlayerListContainer.Parent = TeleportPage

corner(PlayerListContainer, 12)

local PlrScroll = Instance.new("ScrollingFrame")
PlrScroll.Size = UDim2.new(1, -12, 1, -12)
PlrScroll.Position = UDim2.fromOffset(6, 6)
PlrScroll.BackgroundTransparency = 1
PlrScroll.BorderSizePixel = 0
PlrScroll.ScrollBarThickness = 3
PlrScroll.ScrollBarImageColor3 = ThemeColor
PlrScroll.Parent = PlayerListContainer

local PlrLayout = Instance.new("UIListLayout")
PlrLayout.SortOrder = Enum.SortOrder.LayoutOrder
PlrLayout.Padding = UDim.new(0, 5)
PlrLayout.Parent = PlrScroll

PlrLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    PlrScroll.CanvasSize = UDim2.new(
        0,
        0,
        0,
        PlrLayout.AbsoluteContentSize.Y + 8
    )
end)

local SelectedPlrLabel = Instance.new("TextLabel")
SelectedPlrLabel.Size = UDim2.new(1, 0, 0, 24)
SelectedPlrLabel.BackgroundTransparency = 1
SelectedPlrLabel.Text = "Selected  •  None"
SelectedPlrLabel.TextColor3 = SUBTEXT
SelectedPlrLabel.TextSize = 11
SelectedPlrLabel.Font = Enum.Font.GothamMedium
SelectedPlrLabel.TextXAlignment = Enum.TextXAlignment.Left
SelectedPlrLabel.Parent = TeleportPage

local function refreshPlayers()

    for _, child in ipairs(PlrScroll:GetChildren()) do

        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    for _, plr in ipairs(Players:GetPlayers()) do

        if plr ~= LocalPlayer then

            local pBtn = Instance.new("TextButton")
            pBtn.Size = UDim2.new(1, -5, 0, 32)
            pBtn.BackgroundColor3 =
                SelectedTargetPlayer == plr
                and ThemeColor
                or PANEL2

            pBtn.Text = "  " .. plr.DisplayName ..
                "   @" .. plr.Name

            pBtn.TextColor3 = TEXT
            pBtn.TextSize = 11
            pBtn.Font = Enum.Font.GothamMedium
            pBtn.TextXAlignment = Enum.TextXAlignment.Left
            pBtn.AutoButtonColor = false
            pBtn.Parent = PlrScroll

            corner(pBtn, 8)

            pBtn.MouseButton1Click:Connect(function()

                SelectedTargetPlayer = plr

                SelectedPlrLabel.Text =
                    "Selected  •  " .. plr.Name

                for _, b in ipairs(PlrScroll:GetChildren()) do

                    if b:IsA("TextButton") then
                        b.BackgroundColor3 = PANEL2
                    end
                end

                pBtn.BackgroundColor3 = ThemeColor
            end)
        end
    end
end

RefreshBtn.MouseButton1Click:Connect(refreshPlayers)

refreshPlayers()

createButton(
    TeleportPage,
    "⚡  Fast TP",
    function()

        if SelectedTargetPlayer
        and SelectedTargetPlayer.Character
        and SelectedTargetPlayer.Character:FindFirstChild("HumanoidRootPart") then

            if LocalPlayer.Character
            and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then

                LocalPlayer.Character.HumanoidRootPart.CFrame =
                    SelectedTargetPlayer.Character.HumanoidRootPart.CFrame
                    * CFrame.new(0, 0, 3)
            end
        end
    end
)

createButton(
    TeleportPage,
    "➜  Slow TP",
    function()

        if SelectedTargetPlayer
        and SelectedTargetPlayer.Character
        and SelectedTargetPlayer.Character:FindFirstChild("HumanoidRootPart") then

            if LocalPlayer.Character
            and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then

                local hrp =
                    LocalPlayer.Character.HumanoidRootPart

                local target =
                    SelectedTargetPlayer.Character.HumanoidRootPart

                local distance =
                    (target.Position - hrp.Position).Magnitude

                local flyTime =
                    math.clamp(distance / 200, 0.5, 5)

                local conn

                conn = RunService.Stepped:Connect(function()

                    if LocalPlayer.Character then

                        for _, part in ipairs(
                            LocalPlayer.Character:GetDescendants()
                        ) do

                            if part:IsA("BasePart") then
                                part.CanCollide = false
                            end
                        end
                    end
                end)

                local tw = TweenService:Create(
                    hrp,
                    TweenInfo.new(
                        flyTime,
                        Enum.EasingStyle.Linear
                    ),
                    {
                        CFrame =
                            target.CFrame *
                            CFrame.new(0, 0, 3)
                    }
                )

                tw:Play()

                tw.Completed:Connect(function()

                    if conn then
                        conn:Disconnect()
                    end
                end)
            end
        end
    end
)

--======================================================
-- COMBAT
--======================================================

createSection(
    CombatPage,
    "Combat",
    "Настройки боевых функций"
)

createToggle(
    CombatPage,
    "Aimbot",
    false,
    function(v)
        AimbotEnabled = v
    end
)

createToggle(
    CombatPage,
    "Показывать FOV",
    false,
    function(v)

        FovEnabled = v
        FovFrame.Visible = v
    end
)

createSlider(
    CombatPage,
    "Радиус FOV",
    50,
    500,
    FovRadius,
    function(v)

        FovRadius = v

        FovFrame.Size =
            UDim2.fromOffset(
                v * 2,
                v * 2
            )
    end
)

createToggle(
    CombatPage,
    "WallCheck",
    true,
    function(v)
        WallCheckEnabled = v
    end
)

--======================================================
-- VISUALS
--======================================================

createSection(
    VisualsPage,
    "Visuals",
    "Информация и визуальные эффекты"
)

createToggle(
    VisualsPage,
    "ESP",
    false,
    function(v)
        ESPEnabled = v
    end
)

createToggle(
    VisualsPage,
    "Tracers",
    false,
    function(v)
        TracersEnabled = v
    end
)

createToggle(
    VisualsPage,
    "Имена + дистанция",
    false,
    function(v)
        NamesEnabled = v
    end
)

createToggle(
    VisualsPage,
    "Fullbright",
    false,
    function(v)

        FullbrightEnabled = v

        if not v then

            Lighting.Ambient = DefaultAmbient
            Lighting.OutdoorAmbient = DefaultOutdoorAmbient
            Lighting.Brightness = DefaultBrightness
            Lighting.ClockTime = DefaultClockTime

        end
    end
)

createToggle(
    VisualsPage,
    "Spin",
    false,
    function(v)
        SpinEnabled = v
    end
)

--======================================================
-- SETTINGS
--======================================================

createSection(
    SettingsPage,
    "Interface",
    "Настройка внешнего вида Coal Hub"
)

local function updateHudVisibility()

    HudFrame.Visible =
        ShowFPS
        or ShowPing
        or ShowCPS
end

createToggle(
    SettingsPage,
    "Показывать FPS",
    false,
    function(v)

        ShowFPS = v
        FpsLabel.Visible = v

        updateHudVisibility()
    end
)

createToggle(
    SettingsPage,
    "Показывать Ping",
    false,
    function(v)

        ShowPing = v
        PingLabel.Visible = v

        updateHudVisibility()
    end
)

createToggle(
    SettingsPage,
    "Показывать CPS",
    false,
    function(v)

        ShowCPS = v
        CpsLabel.Visible = v

        updateHudVisibility()
    end
)

createSlider(
    SettingsPage,
    "Прозрачность",
    0,
    90,
    0,
    function(v)

        MainFrame.GroupTransparency =
            v / 100
    end
)

createSlider(
    SettingsPage,
    "Ширина",
    430,
    750,
    590,
    function(v)

        MainFrame.Size =
            UDim2.fromOffset(
                v,
                MainFrame.Size.Y.Offset
            )
    end
)

createSlider(
    SettingsPage,
    "Высота",
    300,
    550,
    390,
    function(v)

        MainFrame.Size =
            UDim2.fromOffset(
                MainFrame.Size.X.Offset,
                v
            )
    end
)

createSection(
    SettingsPage,
    "Theme",
    "Выберите цвет интерфейса"
)

createButton(
    SettingsPage,
    "●  Neon Blue",
    function()
        ThemeColor = Color3.fromRGB(0,170,255)
    end
)

createButton(
    SettingsPage,
    "●  Purple",
    function()
        ThemeColor = Color3.fromRGB(170,0,255)
    end
)

createButton(
    SettingsPage,
    "●  Green",
    function()
        ThemeColor = Color3.fromRGB(0,255,120)
    end
)

createButton(
    SettingsPage,
    "●  Red",
    function()
        ThemeColor = Color3.fromRGB(255,60,60)
    end
)

--======================================================
-- THEME UPDATER
--======================================================

local function updateTheme(newColor)

    ThemeColor = newColor

    TitleText.TextColor3 = TEXT

    Logo.BackgroundColor3 = newColor

    MiniSquare.TextColor3 = newColor
    MiniStroke.Color = newColor

    HudStroke.Color = newColor

    FovStroke.Color = newColor

    for _, tab in ipairs(TabButtons) do

        if tab:GetAttribute("Active") then
            tab.BackgroundColor3 = newColor
        end
    end

    -- Update every object that currently uses accent
    for _, obj in ipairs(ScreenGui:GetDescendants()) do

        if obj:IsA("TextLabel") then

            if obj.Text == "●  Neon Blue"
            or obj.Text == "●  Purple"
            or obj.Text == "●  Green"
            or obj.Text == "●  Red" then

                -- leave theme buttons readable
            end

        elseif obj:IsA("UIStroke") then

            if obj == MainStroke then
                continue
            end
        end
    end
end

-- Rebind theme buttons
local themeButtons = {}

for _, child in ipairs(SettingsPage:GetChildren()) do

    if child:IsA("TextButton") then
        table.insert(themeButtons, child)
    end
end

for _, btn in ipairs(themeButtons) do

    if btn.Text == "●  Neon Blue" then
        btn.MouseButton1Click:Connect(function()
            updateTheme(Color3.fromRGB(0,170,255))
        end)

    elseif btn.Text == "●  Purple" then
        btn.MouseButton1Click:Connect(function()
            updateTheme(Color3.fromRGB(170,0,255))
        end)

    elseif btn.Text == "●  Green" then
        btn.MouseButton1Click:Connect(function()
            updateTheme(Color3.fromRGB(0,255,120))
        end)

    elseif btn.Text == "●  Red" then
        btn.MouseButton1Click:Connect(function()
            updateTheme(Color3.fromRGB(255,60,60))
        end)
    end
end

--======================================================
-- FONT
--======================================================

createSection(
    SettingsPage,
    "Font",
    "Выберите шрифт интерфейса"
)

createButton(
    SettingsPage,
    "Gotham Bold",
    function()
        CurrentFont = Enum.Font.GothamBold
    end
)

createButton(
    SettingsPage,
    "Code",
    function()
        CurrentFont = Enum.Font.Code
    end
)

createButton(
    SettingsPage,
    "Roboto",
    function()
        CurrentFont = Enum.Font.Roboto
    end
)

--======================================================
-- CPS
--======================================================

UserInputService.InputBegan:Connect(function(input, gpe)

    if not gpe then

        if input.UserInputType ==
            Enum.UserInputType.MouseButton1
        or input.UserInputType ==
            Enum.UserInputType.Touch then

            CpsCounter += 1

            task.delay(1, function()

                CpsCounter =
                    math.clamp(
                        CpsCounter - 1,
                        0,
                        999
                    )
            end)
        end
    end
end)

--======================================================
-- MENU ANIMATION
--======================================================

local isMenuOpen = true
local OriginalSize = MainFrame.Size

local function hideMenu()

    if not isMenuOpen then
        return
    end

    isMenuOpen = false

    MiniSquare.Visible = true

    MainFrame.Visible = true

    tween(
        MainFrame,
        TweenInfo.new(
            0.3,
            Enum.EasingStyle.Quart,
            Enum.EasingDirection.In
        ),
        {
            GroupTransparency = 1,
            Size = UDim2.fromOffset(
                math.max(300, OriginalSize.X.Offset - 50),
                math.max(250, OriginalSize.Y.Offset - 50)
            )
        }
    ):Play()

    tween(
        MiniSquare,
        TweenInfo.new(
            0.3,
            Enum.EasingStyle.Quart
        ),
        {
            BackgroundTransparency = 0
        }
    ):Play()

    task.delay(0.3, function()

        if not isMenuOpen then
            MainFrame.Visible = false
        end
    end)
end

local function showMenu()

    if isMenuOpen then
        return
    end

    isMenuOpen = true

    MainFrame.Visible = true

    MainFrame.Size = UDim2.fromOffset(
        math.max(300, OriginalSize.X.Offset - 50),
        math.max(250, OriginalSize.Y.Offset - 50)
    )

    tween(
        MainFrame,
        TweenInfo.new(
            0.35,
            Enum.EasingStyle.Back,
            Enum.EasingDirection.Out
        ),
        {
            GroupTransparency = 0,
            Size = OriginalSize
        }
    ):Play()

    tween(
        MiniSquare,
        TweenInfo.new(
            0.25,
            Enum.EasingStyle.Quart
        ),
        {
            BackgroundTransparency = 1
        }
    ):Play()

    task.delay(0.25, function()

        if isMenuOpen then
            MiniSquare.Visible = false
        end
    end)
end

CloseBtn.MouseButton1Click:Connect(hideMenu)
MiniSquare.MouseButton1Click:Connect(showMenu)

--======================================================
-- MOBILE DRAGGING
--======================================================

local function makeDraggable(guiObject, dragObject)

    local dragging = false
    local dragStart
    local startPos

    dragObject.InputBegan:Connect(function(input)

        if input.UserInputType ==
            Enum.UserInputType.MouseButton1
        or input.UserInputType ==
            Enum.UserInputType.Touch then

            dragging = true

            dragStart = input.Position
            startPos = guiObject.Position

            input.Changed:Connect(function()

                if input.UserInputState ==
                    Enum.UserInputState.End then

                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)

        if dragging then

            if input.UserInputType ==
                Enum.UserInputType.MouseMovement
            or input.UserInputType ==
                Enum.UserInputType.Touch then

                local delta =
                    input.Position - dragStart

                guiObject.Position =
                    UDim2.new(
                        startPos.X.Scale,
                        startPos.X.Offset + delta.X,
                        startPos.Y.Scale,
                        startPos.Y.Offset + delta.Y
                    )
            end
        end
    end)
end

makeDraggable(MainFrame, TopBar)
makeDraggable(MiniSquare, MiniSquare)
makeDraggable(HudFrame, HudFrame)

--======================================================
-- INFINITE JUMP
--======================================================

UserInputService.JumpRequest:Connect(function()

    if InfJumpEnabled
    and LocalPlayer.Character then

        local hum =
            LocalPlayer.Character:FindFirstChildOfClass(
                "Humanoid"
            )

        if hum then
            hum:ChangeState(
                Enum.HumanoidStateType.Jumping
            )
        end
    end
end)

--======================================================
-- WALL CHECK
--======================================================

local function isVisible(targetPart)

    if not WallCheckEnabled then
        return true
    end

    local origin =
        Camera.CFrame.Position

    local direction =
        targetPart.Position - origin

    local params =
        RaycastParams.new()

    params.FilterType =
        Enum.RaycastFilterType.Blacklist

    params.FilterDescendantsInstances = {
        LocalPlayer.Character,
        Camera
    }

    params.IgnoreWater = true

    local result =
        workspace:Raycast(
            origin,
            direction,
            params
        )

    if result then

        return result.Instance:IsDescendantOf(
            targetPart.Parent
        )
    end

    return true
end

--======================================================
-- TARGET
--======================================================

local function getClosestPlayerTarget()

    local closest = nil
    local shortest = math.huge

    local center =
        Vector2.new(
            Camera.ViewportSize.X / 2,
            Camera.ViewportSize.Y / 2
        )

    for _, player in ipairs(
        Players:GetPlayers()
    ) do

        if player ~= LocalPlayer
        and player.Character then

            local char = player.Character

            local hrp =
                char:FindFirstChild(
                    "HumanoidRootPart"
                )

            local hum =
                char:FindFirstChildOfClass(
                    "Humanoid"
                )

            if hrp
            and hum
            and hum.Health > 0 then

                local screenPoint, onScreen =
                    Camera:WorldToViewportPoint(
                        hrp.Position
                    )

                if onScreen then

                    local point =
                        Vector2.new(
                            screenPoint.X,
                            screenPoint.Y
                        )

                    local distance =
                        (point - center).Magnitude

                    local inRange = true

                    if FovEnabled then
                        inRange =
                            distance <= FovRadius
                    end

                    if inRange
                    and isVisible(hrp) then

                        local worldDistance =
                            (
                                hrp.Position -
                                Camera.CFrame.Position
                            ).Magnitude

                        if worldDistance < shortest then

                            shortest =
                                worldDistance

                            closest = hrp
                        end
                    end
                end
            end
        end
    end

    return closest
end

--======================================================
-- NOCLIP
--======================================================

RunService.Stepped:Connect(function()

    if NoclipEnabled
    and LocalPlayer.Character then

        for _, part in ipairs(
            LocalPlayer.Character:GetDescendants()
        ) do

            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

--======================================================
-- MAIN LOOP
--======================================================

local flyBV = nil
local flyBG = nil

local spinAngle = 0

local lastTime = tick()
local frameCount = 0

RunService.RenderStepped:Connect(function()

    -- FPS / PING
    frameCount += 1

    if tick() - lastTime >= 1 then

        if ShowFPS then
            FpsLabel.Text =
                "FPS  •  " .. frameCount
        end

        if ShowPing then

            local success, ping =
                pcall(function()

                    return math.floor(
                        StatsService
                        .Network
                        .ServerStatsItem[
                            "Data Ping"
                        ]
                        :GetValue()
                    )
                end)

            if success then

                PingLabel.Text =
                    "PING • " ..
                    tostring(ping) ..
                    " ms"
            end
        end

        frameCount = 0
        lastTime = tick()
    end

    if ShowCPS then

        CpsLabel.Text =
            "CPS  •  " ..
            tostring(CpsCounter)
    end

    -- MOVEMENT
    if LocalPlayer.Character then

        local humanoid =
            LocalPlayer.Character:FindFirstChildOfClass(
                "Humanoid"
            )

        if humanoid then

            if WalkSpeedEnabled then
                humanoid.WalkSpeed =
                    WalkSpeedValue
            else
                humanoid.WalkSpeed = 16
            end

            if JumpPowerEnabled then

                humanoid.UseJumpPower = true
                humanoid.JumpPower =
                    JumpPowerValue

            else

                humanoid.JumpPower = 50
            end
        end
    end

    -- AIMBOT
    if AimbotEnabled then

        local target =
            getClosestPlayerTarget()

        if target then

            Camera.CFrame =
                CFrame.new(
                    Camera.CFrame.Position,
                    target.Position
                )
        end
    end

    -- FULLBRIGHT
    if FullbrightEnabled then

        Lighting.Ambient =
            Color3.fromRGB(
                255,255,255
            )

        Lighting.OutdoorAmbient =
            Color3.fromRGB(
                255,255,255
            )

        Lighting.Brightness = 2
    end

    -- SPIN
    if SpinEnabled
    and LocalPlayer.Character then

        local hrp =
            LocalPlayer.Character:FindFirstChild(
                "HumanoidRootPart"
            )

        if hrp then

            spinAngle =
                (spinAngle + 3) % 360

            hrp.CFrame =
                CFrame.new(hrp.Position)
                * CFrame.Angles(
                    0,
                    math.rad(spinAngle),
                    0
                )
        end
    end

    -- VISUALS
    for _, player in ipairs(
        Players:GetPlayers()
    ) do

        if player ~= LocalPlayer
        and player.Character then

            local char = player.Character

            local hrp =
                char:FindFirstChild(
                    "HumanoidRootPart"
                )

            -- ESP
            local highlight =
                char:FindFirstChild(
                    "CoalESP"
                )

            if ESPEnabled then

                if not highlight then

                    highlight =
                        Instance.new(
                            "Highlight"
                        )

                    highlight.Name =
                        "CoalESP"

                    highlight.FillColor =
                        ThemeColor

                    highlight.OutlineColor =
                        Color3.new(1,1,1)

                    highlight.FillTransparency =
                        0.5

                    highlight.Parent = char
                else

                    highlight.FillColor =
                        ThemeColor
                end

            elseif highlight then

                highlight:Destroy()
            end

            -- TRACERS
            local tracer =
                char:FindFirstChild(
                    "CoalTracer"
                )

            if TracersEnabled and hrp then

                local pos, onScreen =
                    Camera:WorldToViewportPoint(
                        hrp.Position
                    )

                if onScreen then

                    if not tracer then

                        tracer =
                            Instance.new(
                                "Frame"
                            )

                        tracer.Name =
                            "CoalTracer"

                        tracer.AnchorPoint =
                            Vector2.new(
                                0.5,
                                0
                            )

                        tracer.BackgroundColor3 =
                            ThemeColor

                        tracer.BorderSizePixel =
                            0

                        tracer.Parent =
                            ScreenGui
                    end

                    local startPos =
                        Vector2.new(
                            Camera.ViewportSize.X / 2,
                            Camera.ViewportSize.Y
                        )

                    local endPos =
                        Vector2.new(
                            pos.X,
                            pos.Y
                        )

                    local distance =
                        (
                            endPos -
                            startPos
                        ).Magnitude

                    local angle =
                        math.atan2(
                            endPos.Y -
                            startPos.Y,

                            endPos.X -
                            startPos.X
                        )

                    tracer.Size =
                        UDim2.fromOffset(
                            distance,
                            1.5
                        )

                    tracer.Position =
                        UDim2.fromOffset(
                            startPos.X,
                            startPos.Y
                        )

                    tracer.Rotation =
                        math.deg(angle)

                    tracer.Visible = true

                elseif tracer then

                    tracer.Visible = false
                end

            elseif tracer then

                tracer:Destroy()
            end

            -- NAME TAGS
            local nameTag =
                char:FindFirstChild(
                    "CoalNameTag"
                )

            if NamesEnabled and hrp then

                local myHrp =
                    LocalPlayer.Character
                    and LocalPlayer.Character:FindFirstChild(
                        "HumanoidRootPart"
                    )

                local dist = 0

                if myHrp then

                    dist = math.floor(
                        (
                            hrp.Position -
                            myHrp.Position
                        ).Magnitude
                    )
                end

                if not nameTag then

                    local bb =
                        Instance.new(
                            "BillboardGui"
                        )

                    bb.Name =
                        "CoalNameTag"

                    bb.Size =
                        UDim2.fromOffset(
                            170,
                            35
                        )

                    bb.StudsOffset =
                        Vector3.new(
                            0,
                            3,
                            0
                        )

                    bb.AlwaysOnTop = true
                    bb.Parent = char

                    local txt =
                        Instance.new(
                            "TextLabel"
                        )

                    txt.Name = "Label"
                    txt.Size =
                        UDim2.fromScale(
                            1,
                            1
                        )

                    txt.BackgroundTransparency =
                        1

                    txt.TextColor3 =
                        Color3.new(
                            1,1,1
                        )

                    txt.TextStrokeTransparency =
                        0

                    txt.TextSize = 12
                    txt.Font = CurrentFont

                    txt.Parent = bb
                end

                local lbl =
                    nameTag:FindFirstChild(
                        "Label"
                    )

                if lbl then

                    lbl.Text =
                        player.Name ..
                        "  •  " ..
                        dist ..
                        "m"
                end

            elseif nameTag then

                nameTag:Destroy()
            end
        end
    end

    --==================================================
    -- FLY
    --==================================================

    if FlyEnabled
    and LocalPlayer.Character then

        local hrp =
            LocalPlayer.Character:FindFirstChild(
                "HumanoidRootPart"
            )

        local hum =
            LocalPlayer.Character:FindFirstChildOfClass(
                "Humanoid"
            )

        if hrp and hum then

            hum:ChangeState(
                Enum.HumanoidStateType.Swimming
            )

            if not flyBV then

                flyBV =
                    Instance.new(
                        "BodyVelocity"
                    )

                flyBV.MaxForce =
                    Vector3.new(
                        1e9,
                        1e9,
                        1e9
                    )

                flyBV.Velocity =
                    Vector3.zero

                flyBV.Parent = hrp
            end

            if not flyBG then

                flyBG =
                    Instance.new(
                        "BodyGyro"
                    )

                flyBG.MaxTorque =
                    Vector3.new(
                        1e9,
                        1e9,
                        1e9
                    )

                flyBG.P = 90000
                flyBG.CFrame =
                    Camera.CFrame

                flyBG.Parent = hrp
            end

            flyBG.CFrame =
                Camera.CFrame

            local moveDir =
                Vector3.zero

            if UserInputService:IsKeyDown(
                Enum.KeyCode.W
            ) then

                moveDir +=
                    Camera.CFrame.LookVector
            end

            if UserInputService:IsKeyDown(
                Enum.KeyCode.S
            ) then

                moveDir -=
                    Camera.CFrame.LookVector
            end

            if UserInputService:IsKeyDown(
                Enum.KeyCode.A
            ) then

                moveDir -=
                    Camera.CFrame.RightVector
            end

            if UserInputService:IsKeyDown(
                Enum.KeyCode.D
            ) then

                moveDir +=
                    Camera.CFrame.RightVector
            end

            if UserInputService:IsKeyDown(
                Enum.KeyCode.Space
            )
            or UserInputService:IsKeyDown(
                Enum.KeyCode.E
            ) then

                moveDir +=
                    Vector3.new(
                        0,1,0
                    )
            end

            if UserInputService:IsKeyDown(
                Enum.KeyCode.LeftShift
            )
            or UserInputService:IsKeyDown(
                Enum.KeyCode.Q
            ) then

                moveDir -=
                    Vector3.new(
                        0,1,0
                    )
            end

            if hum.MoveDirection.Magnitude > 0 then

                moveDir +=
                    Camera.CFrame:VectorToWorldSpace(
                        Vector3.new(
                            hum.MoveDirection.X,
                            0,
                            hum.MoveDirection.Z
                        )
                    ).Unit
            end

            if moveDir.Magnitude > 0 then

                flyBV.Velocity =
                    moveDir.Unit *
                    FlySpeedValue

            else

                flyBV.Velocity =
                    Vector3.zero
            end
        end

    else

        if flyBV then
            flyBV:Destroy()
            flyBV = nil
        end

        if flyBG then
            flyBG:Destroy()
            flyBG = nil
        end
    end
end)

--======================================================
-- FINAL UI EFFECT
--======================================================

MainFrame.GroupTransparency = 1
MainFrame.Size = UDim2.fromOffset(540, 340)

task.wait(0.05)

tween(
    MainFrame,
    TweenInfo.new(
        0.45,
        Enum.EasingStyle.Back,
        Enum.EasingDirection.Out
    ),
    {
        GroupTransparency = 0,
        Size = OriginalSize
    }
):Play()

print("Coal Hub V2 loaded successfully.")
