-- // Modern GUI: Coal Hub (Updated)
local AimbotEnabled = false
local FovEnabled = false
local FovRadius = 150
local WallCheckEnabled = false

-- Visuals Tab States
local ESPEnabled = false
local TracersEnabled = false
local NamesEnabled = false
local FullbrightEnabled = false
local SpinEnabled = false

-- Main Tab States
local WalkSpeedEnabled = false
local WalkSpeedValue = 16
local JumpPowerEnabled = false
local JumpPowerValue = 50
local NoclipEnabled = false
local FlyEnabled = false
local FlySpeedValue = 50
local InfJumpEnabled = false

-- Teleport Tab States
local SelectedTargetPlayer = nil

-- Settings States
local ThemeColor = Color3.fromRGB(0, 170, 255)
local CurrentFont = Enum.Font.GothamBold

-- HUD Stats States
local ShowFPS = false
local ShowPing = false
local ShowCPS = false
local CpsCounter = 0

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local StatsService = game:GetService("Stats")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Save Lighting Defaults
local DefaultAmbient = Lighting.Ambient
local DefaultOutdoorAmbient = Lighting.OutdoorAmbient
local DefaultBrightness = Lighting.Brightness
local DefaultClockTime = Lighting.ClockTime

-- Screen GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CoalHubUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 9999

local pGui = LocalPlayer:WaitForChild("PlayerGui", 5)
if pGui then
    ScreenGui.Parent = pGui
else
    ScreenGui.Parent = game:GetService("CoreGui")
end

-- FOV Circle
local FovFrame = Instance.new("Frame")
FovFrame.Name = "FovCircle"
FovFrame.AnchorPoint = Vector2.new(0.5, 0.5)
FovFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
FovFrame.Size = UDim2.new(0, FovRadius * 2, 0, FovRadius * 2)
FovFrame.BackgroundTransparency = 1
FovFrame.Visible = false
FovFrame.Parent = ScreenGui

local FovCorner = Instance.new("UICorner")
FovCorner.CornerRadius = UDim.new(1, 0)
FovCorner.Parent = FovFrame

local FovStroke = Instance.new("UIStroke")
FovStroke.Color = Color3.fromRGB(255, 255, 255)
FovStroke.Thickness = 2
FovStroke.Parent = FovFrame

-- Mini Open Button
local MiniSquare = Instance.new("TextButton")
MiniSquare.Name = "MiniSquare"
MiniSquare.Size = UDim2.new(0, 50, 0, 50)
MiniSquare.Position = UDim2.new(0.05, 0, 0.1, 0)
MiniSquare.BackgroundColor3 = Color3.fromRGB(25, 28, 40)
MiniSquare.BackgroundTransparency = 1
MiniSquare.Text = "HUB"
MiniSquare.TextColor3 = ThemeColor
MiniSquare.TextTransparency = 1
MiniSquare.TextSize = 14
MiniSquare.Font = CurrentFont
MiniSquare.Visible = false
MiniSquare.Active = true
MiniSquare.Draggable = true
MiniSquare.Parent = ScreenGui

local SquareCorner = Instance.new("UICorner")
SquareCorner.CornerRadius = UDim.new(0, 12)
SquareCorner.Parent = MiniSquare

local SquareStroke = Instance.new("UIStroke")
SquareStroke.Color = ThemeColor
SquareStroke.Transparency = 1
SquareStroke.Thickness = 1.5
SquareStroke.Parent = MiniSquare

-- Draggable Stats HUD Frame
local HudFrame = Instance.new("Frame")
HudFrame.Name = "HudFrame"
HudFrame.Size = UDim2.new(0, 140, 0, 80)
HudFrame.Position = UDim2.new(0.02, 0, 0.3, 0)
HudFrame.BackgroundColor3 = Color3.fromRGB(18, 20, 28)
HudFrame.BackgroundTransparency = 0.2
HudFrame.BorderSizePixel = 0
HudFrame.Active = true
HudFrame.Draggable = true
HudFrame.Visible = false
HudFrame.Parent = ScreenGui

local HudCorner = Instance.new("UICorner")
HudCorner.CornerRadius = UDim.new(0, 8)
HudCorner.Parent = HudFrame

local HudStroke = Instance.new("UIStroke")
HudStroke.Color = ThemeColor
HudStroke.Thickness = 1.5
HudStroke.Parent = HudFrame

local HudList = Instance.new("UIListLayout")
HudList.SortOrder = Enum.SortOrder.LayoutOrder
HudList.Padding = UDim.new(0, 4)
HudList.Parent = HudFrame

local HudPadding = Instance.new("UIPadding")
HudPadding.PaddingTop = UDim.new(0, 8)
HudPadding.PaddingLeft = UDim.new(0, 10)
HudPadding.Parent = HudFrame

local FpsLabel = Instance.new("TextLabel")
FpsLabel.Size = UDim2.new(1, -10, 0, 18)
FpsLabel.BackgroundTransparency = 1
FpsLabel.Text = "FPS: 60"
FpsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
FpsLabel.TextSize = 12
FpsLabel.Font = CurrentFont
FpsLabel.TextXAlignment = Enum.TextXAlignment.Left
FpsLabel.Visible = false
FpsLabel.Parent = HudFrame

local PingLabel = Instance.new("TextLabel")
PingLabel.Size = UDim2.new(1, -10, 0, 18)
PingLabel.BackgroundTransparency = 1
PingLabel.Text = "PING: 0 ms"
PingLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
PingLabel.TextSize = 12
PingLabel.Font = CurrentFont
PingLabel.TextXAlignment = Enum.TextXAlignment.Left
PingLabel.Visible = false
PingLabel.Parent = HudFrame

local CpsLabel = Instance.new("TextLabel")
CpsLabel.Size = UDim2.new(1, -10, 0, 18)
CpsLabel.BackgroundTransparency = 1
CpsLabel.Text = "CPS: 0"
CpsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
CpsLabel.TextSize = 12
CpsLabel.Font = CurrentFont
CpsLabel.TextXAlignment = Enum.TextXAlignment.Left
CpsLabel.Visible = false
CpsLabel.Parent = HudFrame

-- Main Container Window
local MainFrame = Instance.new("CanvasGroup")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 520, 0, 340)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -170)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 20, 28)
MainFrame.GroupTransparency = 0
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(45, 52, 70)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

-- Top Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 28, 40)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -50, 1, 0)
TitleText.Position = UDim2.new(0, 15, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "COAL HUB"
TitleText.TextColor3 = ThemeColor
TitleText.TextSize = 16
TitleText.Font = CurrentFont
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 14
CloseBtn.Font = CurrentFont
CloseBtn.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

-- Sidebar Category Panel
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 130, 1, -40)
Sidebar.Position = UDim2.new(0, 0, 0, 40)
Sidebar.BackgroundColor3 = Color3.fromRGB(22, 25, 35)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SidebarList = Instance.new("UIListLayout")
SidebarList.SortOrder = Enum.SortOrder.LayoutOrder
SidebarList.Padding = UDim.new(0, 5)
SidebarList.Parent = Sidebar

local SidebarPadding = Instance.new("UIPadding")
SidebarPadding.PaddingTop = UDim.new(0, 10)
SidebarPadding.PaddingLeft = UDim.new(0, 10)
SidebarPadding.PaddingRight = UDim.new(0, 10)
SidebarPadding.Parent = Sidebar

-- Content Container
local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -130, 1, -40)
ContentContainer.Position = UDim2.new(0, 130, 0, 40)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

local function createPage()
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 4
    page.ScrollBarImageColor3 = ThemeColor
    page.Visible = false
    page.Parent = ContentContainer
    
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 10)
    layout.Parent = page
    
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 10)
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingRight = UDim.new(0, 15)
    padding.Parent = page

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
    end)
    
    return page
end

local MainPage = createPage()
local TeleportPage = createPage()
local CombatPage = createPage()
local VisualsPage = createPage()
local SettingsPage = createPage()
MainPage.Visible = true

-- Tab Switching logic
local function createTabBtn(text, page)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(28, 32, 45)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = Sidebar

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        MainPage.Visible = false
        TeleportPage.Visible = false
        CombatPage.Visible = false
        VisualsPage.Visible = false
        SettingsPage.Visible = false
        page.Visible = true
        
        for _, child in ipairs(Sidebar:GetChildren()) do
            if child:IsA("TextButton") then
                child.BackgroundColor3 = Color3.fromRGB(28, 32, 45)
                child.TextColor3 = Color3.fromRGB(180, 180, 180)
            end
        end
        btn.BackgroundColor3 = ThemeColor
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    return btn
end

local MainTabBtn = createTabBtn("Main", MainPage)
local TeleportTabBtn = createTabBtn("Teleport", TeleportPage)
local CombatTabBtn = createTabBtn("Combat", CombatPage)
local VisualsTabBtn = createTabBtn("Visuals", VisualsPage)
local SettingsTabBtn = createTabBtn("Settings", SettingsPage)

MainTabBtn.BackgroundColor3 = ThemeColor
MainTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Dynamic Elements Theme Updater
local function updateTheme(newColor)
    ThemeColor = newColor
    TitleText.TextColor3 = newColor
    MiniSquare.TextColor3 = newColor
    SquareStroke.Color = newColor
    HudStroke.Color = newColor
    
    for _, btn in ipairs(Sidebar:GetChildren()) do
        if btn:IsA("TextButton") and btn.TextColor3 == Color3.fromRGB(255, 255, 255) then
            btn.BackgroundColor3 = newColor
        end
    end
end

local function updateFont(newFont)
    CurrentFont = newFont
    TitleText.Font = newFont
    CloseBtn.Font = newFont
    MiniSquare.Font = newFont
    FpsLabel.Font = newFont
    PingLabel.Font = newFont
    CpsLabel.Font = newFont
end

-- UI Control Creators
local function createToggle(page, text, defaultState, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(25, 28, 40)
    frame.Parent = page

    local fCorner = Instance.new("UICorner")
    fCorner.CornerRadius = UDim.new(0, 6)
    fCorner.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextSize = 13
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 40, 0, 22)
    toggleBtn.Position = UDim2.new(1, -50, 0.5, -11)
    toggleBtn.BackgroundColor3 = defaultState and ThemeColor or Color3.fromRGB(45, 50, 65)
    toggleBtn.Text = ""
    toggleBtn.Parent = frame

    local tCorner = Instance.new("UICorner")
    tCorner.CornerRadius = UDim.new(1, 0)
    tCorner.Parent = toggleBtn

    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 16, 0, 16)
    circle.Position = defaultState and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    circle.Parent = toggleBtn

    local cCorner = Instance.new("UICorner")
    cCorner.CornerRadius = UDim.new(1, 0)
    cCorner.Parent = circle

    local state = defaultState
    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        local targetColor = state and ThemeColor or Color3.fromRGB(45, 50, 65)
        local targetPos = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
        
        TweenService:Create(toggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
        TweenService:Create(circle, TweenInfo.new(0.2), {Position = targetPos}):Play()
        callback(state)
    end)
end

local function createSlider(page, text, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 50)
    frame.BackgroundColor3 = Color3.fromRGB(25, 28, 40)
    frame.Parent = page

    local fCorner = Instance.new("UICorner")
    fCorner.CornerRadius = UDim.new(0, 6)
    fCorner.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 0, 20)
    label.Position = UDim2.new(0, 10, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextSize = 13
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local valLabel = Instance.new("TextLabel")
    valLabel.Size = UDim2.new(0, 40, 0, 20)
    valLabel.Position = UDim2.new(1, -50, 0, 5)
    valLabel.BackgroundTransparency = 1
    valLabel.Text = tostring(default)
    valLabel.TextColor3 = ThemeColor
    valLabel.TextSize = 13
    valLabel.Font = Enum.Font.GothamBold
    valLabel.Parent = frame

    local sliderBack = Instance.new("TextButton")
    sliderBack.Size = UDim2.new(1, -20, 0, 10)
    sliderBack.Position = UDim2.new(0, 10, 1, -18)
    sliderBack.BackgroundColor3 = Color3.fromRGB(45, 50, 65)
    sliderBack.Text = ""
    sliderBack.AutoButtonColor = false
    sliderBack.Parent = frame

    local sbCorner = Instance.new("UICorner")
    sbCorner.CornerRadius = UDim.new(1, 0)
    sbCorner.Parent = sliderBack

    local sliderFill = Instance.new("Frame")
    local startFactor = (default - min) / (max - min)
    sliderFill.Size = UDim2.new(startFactor, 0, 1, 0)
    sliderFill.BackgroundColor3 = ThemeColor
    sliderFill.Parent = sliderBack

    local sfCorner = Instance.new("UICorner")
    sfCorner.CornerRadius = UDim.new(1, 0)
    sfCorner.Parent = sliderFill

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new(startFactor, 0, 0.5, 0)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.Parent = sliderBack

    local kCorner = Instance.new("UICorner")
    kCorner.CornerRadius = UDim.new(1, 0)
    kCorner.Parent = knob

    local dragging = false

    local function update(input)
        local posX = input.Position.X - sliderBack.AbsolutePosition.X
        local factor = math.clamp(posX / sliderBack.AbsoluteSize.X, 0, 1)
        local value = math.floor(min + (max - min) * factor)
        
        sliderFill.Size = UDim2.new(factor, 0, 1, 0)
        knob.Position = UDim2.new(factor, 0, 0.5, 0)
        valLabel.Text = tostring(value)
        callback(value)
    end

    sliderBack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            update(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)
end

local function createButton(page, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = ThemeColor
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamBold
    btn.Parent = page

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn

    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- POPULATE TAB: Main
createToggle(MainPage, "Включить скорость бега", false, function(v)
    WalkSpeedEnabled = v
end)

createSlider(MainPage, "Скорость бега", 1, 300, WalkSpeedValue, function(v)
    WalkSpeedValue = v
end)

createToggle(MainPage, "Включить высоту прыжка", false, function(v)
    JumpPowerEnabled = v
end)

createSlider(MainPage, "Высота прыжка", 1, 300, JumpPowerValue, function(v)
    JumpPowerValue = v
end)

createToggle(MainPage, "Бесконечный прыжок", false, function(v)
    InfJumpEnabled = v
end)

createToggle(MainPage, "Ноуклип (Noclip)", false, function(v)
    NoclipEnabled = v
end)

createToggle(MainPage, "Полет (Fly)", false, function(v)
    FlyEnabled = v
end)

createSlider(MainPage, "Скорость полета", 1, 300, FlySpeedValue, function(v)
    FlySpeedValue = v
end)

-- POPULATE TAB: Teleport
local RefreshBtn = createButton(TeleportPage, "Обновить список игроков", function() end)

local PlayerListContainer = Instance.new("Frame")
PlayerListContainer.Size = UDim2.new(1, 0, 0, 120)
PlayerListContainer.BackgroundColor3 = Color3.fromRGB(25, 28, 40)
PlayerListContainer.Parent = TeleportPage

local PlrListCorner = Instance.new("UICorner")
PlrListCorner.CornerRadius = UDim.new(0, 6)
PlrListCorner.Parent = PlayerListContainer

local PlrScroll = Instance.new("ScrollingFrame")
PlrScroll.Size = UDim2.new(1, -10, 1, -10)
PlrScroll.Position = UDim2.new(0, 5, 0, 5)
PlrScroll.BackgroundTransparency = 1
PlrScroll.BorderSizePixel = 0
PlrScroll.ScrollBarThickness = 4
PlrScroll.ScrollBarImageColor3 = ThemeColor
PlrScroll.Parent = PlayerListContainer

local PlrLayout = Instance.new("UIListLayout")
PlrLayout.SortOrder = Enum.SortOrder.LayoutOrder
PlrLayout.Padding = UDim.new(0, 5)
PlrLayout.Parent = PlrScroll

PlrLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    PlrScroll.CanvasSize = UDim2.new(0, 0, 0, PlrLayout.AbsoluteContentSize.Y + 5)
end)

local SelectedPlrLabel = Instance.new("TextLabel")
SelectedPlrLabel.Size = UDim2.new(1, 0, 0, 20)
SelectedPlrLabel.BackgroundTransparency = 1
SelectedPlrLabel.Text = "Выбран: Никто"
SelectedPlrLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
SelectedPlrLabel.TextSize = 13
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
            pBtn.Size = UDim2.new(1, -5, 0, 28)
            pBtn.BackgroundColor3 = (SelectedTargetPlayer == plr) and ThemeColor or Color3.fromRGB(35, 40, 55)
            pBtn.Text = plr.DisplayName .. " (@" .. plr.Name .. ")"
            pBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            pBtn.TextSize = 12
            pBtn.Font = Enum.Font.Gotham
            pBtn.Parent = PlrScroll

            local pCorner = Instance.new("UICorner")
            pCorner.CornerRadius = UDim.new(0, 4)
            pCorner.Parent = pBtn

            pBtn.MouseButton1Click:Connect(function()
                SelectedTargetPlayer = plr
                SelectedPlrLabel.Text = "Выбран: " .. plr.Name
                for _, b in ipairs(PlrScroll:GetChildren()) do
                    if b:IsA("TextButton") then
                        b.BackgroundColor3 = Color3.fromRGB(35, 40, 55)
                    end
                end
                pBtn.BackgroundColor3 = ThemeColor
            end)
        end
    end
end

RefreshBtn.MouseButton1Click:Connect(refreshPlayers)
refreshPlayers()

createButton(TeleportPage, "Fast TP (Мгновенно)", function()
    if SelectedTargetPlayer and SelectedTargetPlayer.Character and SelectedTargetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = SelectedTargetPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
        end
    end
end)

createButton(TeleportPage, "Slow TP (Быстрый полет)", function()
    if SelectedTargetPlayer and SelectedTargetPlayer.Character and SelectedTargetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = LocalPlayer.Character.HumanoidRootPart
            local targetHrp = SelectedTargetPlayer.Character.HumanoidRootPart
            local distance = (targetHrp.Position - hrp.Position).Magnitude
            local flyTime = math.clamp(distance / 200, 0.5, 5)

            local conn
            conn = RunService.Stepped:Connect(function()
                if LocalPlayer.Character then
                    for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)

            local tween = TweenService:Create(
                hrp,
                TweenInfo.new(flyTime, Enum.EasingStyle.Linear),
                {CFrame = targetHrp.CFrame * CFrame.new(0, 0, 3)}
            )
            
            tween:Play()
            tween.Completed:Connect(function()
                if conn then conn:Disconnect() end
            end)
        end
    end
end)

-- POPULATE TAB: Combat
createToggle(CombatPage, "Включить Aimbot", false, function(v)
    AimbotEnabled = v
end)

createToggle(CombatPage, "Показывать круг FOV", false, function(v)
    FovEnabled = v
    FovFrame.Visible = v
end)

createSlider(CombatPage, "Радиус FOV", 50, 500, FovRadius, function(v)
    FovRadius = v
    FovFrame.Size = UDim2.new(0, v * 2, 0, v * 2)
end)

createToggle(CombatPage, "Проверка стен (WallCheck)", true, function(v)
    WallCheckEnabled = v
end)

-- POPULATE TAB: Visuals
createToggle(VisualsPage, "Включить ESP (Подсветка)", false, function(v)
    ESPEnabled = v
end)

createToggle(VisualsPage, "Tracers (Линии к игрокам)", false, function(v)
    TracersEnabled = v
end)

createToggle(VisualsPage, "Имена и Дистанция", false, function(v)
    NamesEnabled = v
end)

createToggle(VisualsPage, "Fullbright (Без темноты)", false, function(v)
    FullbrightEnabled = v
    if not v then
        Lighting.Ambient = DefaultAmbient
        Lighting.OutdoorAmbient = DefaultOutdoorAmbient
        Lighting.Brightness = DefaultBrightness
        Lighting.ClockTime = DefaultClockTime
    end
end)

createToggle(VisualsPage, "Spin (Крутиться 360)", false, function(v)
    SpinEnabled = v
end)

-- POPULATE TAB: Settings
local function updateHudVisibility()
    HudFrame.Visible = ShowFPS or ShowPing or ShowCPS
end

createToggle(SettingsPage, "Показывать FPS", false, function(v)
    ShowFPS = v
    FpsLabel.Visible = v
    updateHudVisibility()
end)

createToggle(SettingsPage, "Показывать Пинг", false, function(v)
    ShowPing = v
    PingLabel.Visible = v
    updateHudVisibility()
end)

createToggle(SettingsPage, "Показывать CPS", false, function(v)
    ShowCPS = v
    CpsLabel.Visible = v
    updateHudVisibility()
end)

createSlider(SettingsPage, "Прозрачность меню", 0, 90, 0, function(v)
    MainFrame.GroupTransparency = v / 100
end)

createSlider(SettingsPage, "Ширина меню", 400, 700, 520, function(v)
    MainFrame.Size = UDim2.new(0, v, 0, MainFrame.Size.Y.Offset)
end)

createSlider(SettingsPage, "Высота меню", 260, 500, 340, function(v)
    MainFrame.Size = UDim2.new(0, MainFrame.Size.X.Offset, 0, v)
end)

createButton(SettingsPage, "Цвет: Синий", function() updateTheme(Color3.fromRGB(0, 170, 255)) end)
createButton(SettingsPage, "Цвет: Фиолетовый", function() updateTheme(Color3.fromRGB(170, 0, 255)) end)
createButton(SettingsPage, "Цвет: Зеленый", function() updateTheme(Color3.fromRGB(0, 255, 120)) end)
createButton(SettingsPage, "Цвет: Красный", function() updateTheme(Color3.fromRGB(255, 60, 60)) end)

createButton(SettingsPage, "Шрифт: GothamBold", function() updateFont(Enum.Font.GothamBold) end)
createButton(SettingsPage, "Шрифт: Code", function() updateFont(Enum.Font.Code) end)
createButton(SettingsPage, "Шрифт: Roboto", function() updateFont(Enum.Font.Roboto) end)

-- CPS Click Tracking
UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        CpsCounter = CpsCounter + 1
        task.delay(1, function()
            CpsCounter = math.clamp(CpsCounter - 1, 0, 999)
        end)
    end
end)

-- Window Smooth Animations
local isMenuOpen = true

local function hideMenu()
    if not isMenuOpen then return end
    isMenuOpen = false
    
    MiniSquare.Visible = true
    
    local tweenMain = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        GroupTransparency = 1,
        Size = UDim2.new(0, MainFrame.Size.X.Offset - 40, 0, MainFrame.Size.Y.Offset - 40)
    })
    
    local tweenSquareBg = TweenService:Create(MiniSquare, TweenInfo.new(0.3), {BackgroundTransparency = 0})
    local tweenSquareText = TweenService:Create(MiniSquare, TweenInfo.new(0.3), {TextTransparency = 0})
    local tweenSquareStroke = TweenService:Create(SquareStroke, TweenInfo.new(0.3), {Transparency = 0})

    tweenMain:Play()
    tweenSquareBg:Play()
    tweenSquareText:Play()
    tweenSquareStroke:Play()
    
    tweenMain.Completed:Connect(function()
        if not isMenuOpen then
            MainFrame.Visible = false
        end
    end)
end

local function showMenu()
    if isMenuOpen then return end
    isMenuOpen = true
    
    MainFrame.Visible = true
    
    local tweenMain = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        GroupTransparency = 0,
        Size = UDim2.new(0, MainFrame.Size.X.Offset + 40, 0, MainFrame.Size.Y.Offset + 40)
    })
    
    local tweenSquareBg = TweenService:Create(MiniSquare, TweenInfo.new(0.3), {BackgroundTransparency = 1})
    local tweenSquareText = TweenService:Create(MiniSquare, TweenInfo.new(0.3), {TextTransparency = 1})
    local tweenSquareStroke = TweenService:Create(SquareStroke, TweenInfo.new(0.3), {Transparency = 1})

    tweenMain:Play()
    tweenSquareBg:Play()
    tweenSquareText:Play()
    tweenSquareStroke:Play()
    
    tweenSquareBg.Completed:Connect(function()
        if isMenuOpen then
            MiniSquare.Visible = false
        end
    end)
end

CloseBtn.MouseButton1Click:Connect(hideMenu)
MiniSquare.MouseButton1Click:Connect(showMenu)

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if InfJumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- Strict WallCheck and Aimbot Mechanics
local function isVisible(targetPart)
    if not WallCheckEnabled then return true end
    local origin = Camera.CFrame.Position
    local direction = targetPart.Position - origin
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
    raycastParams.IgnoreWater = true
    
    local result = workspace:Raycast(origin, direction, raycastParams)
    if result then
        if result.Instance:IsDescendantOf(targetPart.Parent) then
            return true
        else
            return false
        end
    end
    return true
end

local function getClosestPlayerTarget()
    local closest = nil
    local shortestDistance = math.huge
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local char = player.Character
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChildOfClass("Humanoid")

            if hrp and hum and hum.Health > 0 then
                local screenPoint, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                
                if onScreen then
                    local mouseVector = Vector2.new(screenPoint.X, screenPoint.Y)
                    local distanceToCenter = (mouseVector - screenCenter).Magnitude
                    
                    -- Проверка по кругу FOV (если включен)
                    local inRange = true
                    if FovEnabled then
                        inRange = (distanceToCenter <= FovRadius)
                    end
                    
                    if inRange then
                        if isVisible(hrp) then
                            local distanceToPlayer = (hrp.Position - Camera.CFrame.Position).Magnitude
                            if distanceToPlayer < shortestDistance then
                                shortestDistance = distanceToPlayer
                                closest = hrp
                            end
                        end
                    end
                end
            end
        end
    end
    return closest
end

-- Noclip Loop
RunService.Stepped:Connect(function()
    if NoclipEnabled and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- Main Render Loop (Fly, Spin, Aimbot, Stats, Visuals)
local flyBV = nil
local flyBG = nil
local spinAngle = 0
local lastTime = tick()
local frameCount = 0

RunService.RenderStepped:Connect(function()
    -- Calculate Stats HUD
    frameCount = frameCount + 1
    if tick() - lastTime >= 1 then
        if ShowFPS then FpsLabel.Text = "FPS: " .. frameCount end
        if ShowPing then
            local ping = math.floor(StatsService.Network.ServerStatsItem["Data Ping"]:GetValue())
            PingLabel.Text = "PING: " .. ping .. " ms"
        end
        frameCount = 0
        lastTime = tick()
    end
    if ShowCPS then CpsLabel.Text = "CPS: " .. CpsCounter end

    -- Speed & Jump Power Control
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        
        if WalkSpeedEnabled then
            humanoid.WalkSpeed = WalkSpeedValue
        else
            humanoid.WalkSpeed = 16
        end

        if JumpPowerEnabled then
            humanoid.JumpPower = JumpPowerValue
            humanoid.UseJumpPower = true
        else
            humanoid.JumpPower = 50
        end
    end

    -- Aimbot Logic with FOV and WallCheck
    if AimbotEnabled then
        local target = getClosestPlayerTarget()
        if target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
        end
    end

    -- Fullbright
    if FullbrightEnabled then
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        Lighting.Brightness = 2
    end

    -- Spin Bot Logic
    if SpinEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        spinAngle = (spinAngle + 45) % 360
        hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, math.rad(spinAngle), 0)
    end

    -- Visuals Render Loop (Tracers & Names)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local char = player.Character
            local hrp = char:FindFirstChild("HumanoidRootPart")

            -- Highlight ESP
            local highlight = char:FindFirstChild("CoalESP")
            if ESPEnabled then
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "CoalESP"
                    highlight.FillColor = Color3.fromRGB(255, 50, 50)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.FillTransparency = 0.5
                    highlight.Parent = char
                end
            elseif highlight then
                highlight:Destroy()
            end

            -- Tracers
            local tracer = char:FindFirstChild("CoalTracer")
            if TracersEnabled and hrp then
                local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                if onScreen then
                    if not tracer then
                        tracer = Instance.new("Frame")
                        tracer.Name = "CoalTracer"
                        tracer.AnchorPoint = Vector2.new(0.5, 0)
                        tracer.BackgroundColor3 = ThemeColor
                        tracer.BorderSizePixel = 0
                        tracer.Parent = ScreenGui
                    end
                    local startPos = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                    local endPos = Vector2.new(pos.X, pos.Y)
                    local distance = (endPos - startPos).Magnitude
                    local angle = math.atan2(endPos.Y - startPos.Y, endPos.X - startPos.X)

                    tracer.Size = UDim2.new(0, distance, 0, 1.5)
                    tracer.Position = UDim2.new(0, startPos.X, 0, startPos.Y)
                    tracer.Rotation = math.deg(angle)
                    tracer.Visible = true
                elseif tracer then
                    tracer.Visible = false
                end
            elseif tracer then
                tracer:Destroy()
            end

            -- Name & Distance Tag
            local nameTag = char:FindFirstChild("CoalNameTag")
            if NamesEnabled and hrp then
                local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                local dist = myHrp and math.floor((hrp.Position - myHrp.Position).Magnitude) or 0
                
                if not nameTag then
                    local bb = Instance.new("BillboardGui")
                    bb.Name = "CoalNameTag"
                    bb.Size = UDim2.new(0, 150, 0, 30)
                    bb.StudsOffset = Vector3.new(0, 3, 0)
                    bb.AlwaysOnTop = true
                    bb.Parent = char

                    local txt = Instance.new("TextLabel")
                    txt.Name = "Label"
                    txt.Size = UDim2.new(1, 0, 1, 0)
                    txt.BackgroundTransparency = 1
                    txt.TextColor3 = Color3.fromRGB(255, 255, 255)
                    txt.TextStrokeTransparency = 0
                    txt.TextSize = 12
                    txt.Font = CurrentFont
                    txt.Parent = bb
                end
                
                local lbl = nameTag:FindFirstChild("Label")
                if lbl then
                    lbl.Text = player.Name .. " [" .. dist .. "m]"
                end
            elseif nameTag then
                nameTag:Destroy()
            end
        end
    end

    -- Universal Fly Logic (PC + Mobile support)
    if FlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        
        if hum then hum:ChangeState(Enum.HumanoidStateType.Swimming) end

        if not flyBV then
            flyBV = Instance.new("BodyVelocity")
            flyBV.MaxForce = Vector3.new(1e9, 1e9, 1e9)
            flyBV.Velocity = Vector3.new(0, 0, 0)
            flyBV.Parent = hrp
        end

        if not flyBG then
            flyBG = Instance.new("BodyGyro")
            flyBG.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
            flyBG.P = 9e4
            flyBG.CFrame = Camera.CFrame
            flyBG.Parent = hrp
        end

        flyBG.CFrame = Camera.CFrame

        local moveDir = Vector3.new(0, 0, 0)
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) or UserInputService:IsKeyDown(Enum.KeyCode.E) then moveDir = moveDir + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.Q) then moveDir = moveDir - Vector3.new(0, 1, 0) end

        if hum and hum.MoveDirection.Magnitude > 0 then
            moveDir = moveDir + (Camera.CFrame:VectorToWorldSpace(Vector3.new(hum.MoveDirection.X, 0, hum.MoveDirection.Z)).Unit)
        end

        if moveDir.Magnitude > 0 then
            flyBV.Velocity = moveDir.Unit * FlySpeedValue
        else
            flyBV.Velocity = Vector3.new(0, 0, 0)
        end
    else
        if flyBV then flyBV:Destroy(); flyBV = nil end
        if flyBG then flyBG:Destroy(); flyBG = nil end
    end
end)
