--// =========================================================
--// COAL HUB V1 — Clean Interface Edition
--// Variant 1: NO IMAGE BACKGROUND
--// =========================================================

--// SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Stats = game:GetService("Stats")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--// =========================================================
--// SETTINGS / STATES
--// =========================================================

local ThemeColor = Color3.fromRGB(0, 170, 255)
local CurrentFont = Enum.Font.GothamBold

local WindowWidth = 590
local WindowHeight = 390

local MenuTransparency = 0.08
local AnimationSpeed = 0.20

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

local ShowFPS = false
local ShowPing = false
local ShowCPS = false
local ShowPlayers = true
local ShowTime = true

local ThirdPersonEnabled = false
local CameraDistance = 12
local LockCameraDistance = false

local SelectedTargetPlayer = nil
local CpsCounter = 0
local SpinAngle = 0

--// =========================================================
--// GUI
--// =========================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CoalHubUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 9999
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

--// MAIN
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.fromOffset(WindowWidth, WindowHeight)
MainFrame.Position = UDim2.new(0.5, -WindowWidth / 2, 0.5, -WindowHeight / 2)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 20, 26)
MainFrame.BackgroundTransparency = MenuTransparency
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = ThemeColor
MainStroke.Thickness = 1.5
MainStroke.Transparency = 0.15
MainStroke.Parent = MainFrame

--// HEADER
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 55)
Header.BackgroundColor3 = Color3.fromRGB(14, 16, 22)
Header.BackgroundTransparency = 0.05
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = Header

local Logo = Instance.new("TextLabel")
Logo.Size = UDim2.fromOffset(40, 40)
Logo.Position = UDim2.fromOffset(12, 7)
Logo.BackgroundColor3 = ThemeColor
Logo.Text = "C"
Logo.TextColor3 = Color3.new(1,1,1)
Logo.TextSize = 22
Logo.Font = CurrentFont
Logo.Parent = Header

local LogoCorner = Instance.new("UICorner")
LogoCorner.CornerRadius = UDim.new(0, 10)
LogoCorner.Parent = Logo

local Title = Instance.new("TextLabel")
Title.Position = UDim2.fromOffset(62, 7)
Title.Size = UDim2.fromOffset(220, 25)
Title.BackgroundTransparency = 1
Title.Text = "COAL HUB"
Title.TextColor3 = Color3.new(1,1,1)
Title.TextSize = 20
Title.Font = CurrentFont
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local Version = Instance.new("TextLabel")
Version.Position = UDim2.fromOffset(63, 30)
Version.Size = UDim2.fromOffset(100, 18)
Version.BackgroundTransparency = 1
Version.Text = "V1 • Clean"
Version.TextColor3 = ThemeColor
Version.TextSize = 11
Version.Font = Enum.Font.Gotham
Version.TextXAlignment = Enum.TextXAlignment.Left
Version.Parent = Header

--// CLOSE
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.fromOffset(34, 34)
CloseButton.Position = UDim2.new(1, -43, 0, 10)
CloseButton.BackgroundColor3 = Color3.fromRGB(35, 37, 45)
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseButton.TextSize = 23
CloseButton.Font = CurrentFont
CloseButton.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 9)
CloseCorner.Parent = CloseButton

--// =========================================================
--// SIDEBAR
--// =========================================================

local Sidebar = Instance.new("Frame")
Sidebar.Position = UDim2.fromOffset(0, 55)
Sidebar.Size = UDim2.new(0, 130, 1, -55)
Sidebar.BackgroundColor3 = Color3.fromRGB(14, 16, 21)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.Padding = UDim.new(0, 5)
SidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
SidebarLayout.Parent = Sidebar

local SidebarPadding = Instance.new("UIPadding")
SidebarPadding.PaddingTop = UDim.new(0, 12)
SidebarPadding.PaddingLeft = UDim.new(0, 8)
SidebarPadding.PaddingRight = UDim.new(0, 8)
SidebarPadding.Parent = Sidebar

--// CONTENT
local Content = Instance.new("Frame")
Content.Position = UDim2.fromOffset(130, 55)
Content.Size = UDim2.new(1, -130, 1, -55)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

local Pages = {}
local TabButtons = {}

local function createPage(name)
    local page = Instance.new("ScrollingFrame")
    page.Name = name
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = ThemeColor
    page.CanvasSize = UDim2.new(0,0,0,0)
    page.Visible = false
    page.Parent = Content

    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 15)
    padding.PaddingLeft = UDim.new(0, 15)
    padding.PaddingRight = UDim.new(0, 15)
    padding.PaddingBottom = UDim.new(0, 15)
    padding.Parent = page

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 10)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = page

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.fromOffset(
            0,
            layout.AbsoluteContentSize.Y + 25
        )
    end)

    Pages[name] = page
    return page
end

local HomePage = createPage("Home")
local PlayerPage = createPage("Player")
local CombatPage = createPage("Combat")
local VisualsPage = createPage("Visuals")
local TeleportPage = createPage("Teleport")
local HUDPage = createPage("HUD")
local InterfacePage = createPage("Interface")
local SettingsPage = createPage("Settings")

local function createTab(text, icon, page)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -4, 0, 35)
    button.BackgroundColor3 = Color3.fromRGB(24, 27, 34)
    button.BackgroundTransparency = 1
    button.Text = icon .. "  " .. text
    button.TextColor3 = Color3.fromRGB(165, 170, 180)
    button.TextSize = 13
    button.Font = CurrentFont
    button.TextXAlignment = Enum.TextXAlignment.Left
    button.Parent = Sidebar

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button

    TabButtons[page] = button

    button.MouseEnter:Connect(function()
        if button:GetAttribute("Selected") ~= true then
            TweenService:Create(
                button,
                TweenInfo.new(0.15),
                {BackgroundTransparency = 0.5}
            ):Play()
        end
    end)

    button.MouseLeave:Connect(function()
        if button:GetAttribute("Selected") ~= true then
            TweenService:Create(
                button,
                TweenInfo.new(0.15),
                {BackgroundTransparency = 1}
            ):Play()
        end
    end)

    button.MouseButton1Click:Connect(function()
        for p, b in pairs(TabButtons) do
            b:SetAttribute("Selected", false)

            TweenService:Create(
                b,
                TweenInfo.new(0.15),
                {
                    BackgroundTransparency = 1,
                    TextColor3 = Color3.fromRGB(165,170,180)
                }
            ):Play()

            p.Visible = false
        end

        button:SetAttribute("Selected", true)

        TweenService:Create(
            button,
            TweenInfo.new(0.15),
            {
                BackgroundTransparency = 0,
                BackgroundColor3 = ThemeColor,
                TextColor3 = Color3.new(1,1,1)
            }
        ):Play()

        page.Visible = true
    end)

    return button
end

createTab("Home", "⌂", HomePage)
createTab("Player", "●", PlayerPage)
createTab("Combat", "✦", CombatPage)
createTab("Visuals", "◉", VisualsPage)
createTab("Teleport", "◆", TeleportPage)
createTab("HUD", "▣", HUDPage)
createTab("Interface", "⚙", InterfacePage)
createTab("Settings", "☰", SettingsPage)

--// =========================================================
--// UI HELPERS
--// =========================================================

local function createSection(parent, title, description)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 58)
    frame.BackgroundColor3 = Color3.fromRGB(25, 28, 36)
    frame.BackgroundTransparency = 0.15
    frame.BorderSizePixel = 0
    frame.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 9)
    corner.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(45, 48, 58)
    stroke.Transparency = 0.5
    stroke.Parent = frame

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Position = UDim2.fromOffset(12, 7)
    titleLabel.Size = UDim2.new(1, -24, 0, 22)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.new(1,1,1)
    titleLabel.TextSize = 15
    titleLabel.Font = CurrentFont
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = frame

    local desc = Instance.new("TextLabel")
    desc.Position = UDim2.fromOffset(12, 29)
    desc.Size = UDim2.new(1, -24, 0, 18)
    desc.BackgroundTransparency = 1
    desc.Text = description or ""
    desc.TextColor3 = Color3.fromRGB(145,150,160)
    desc.TextSize = 11
    desc.Font = Enum.Font.Gotham
    desc.TextXAlignment = Enum.TextXAlignment.Left
    desc.Parent = frame

    return frame
end

local function createToggle(parent, text, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 43)
    frame.BackgroundColor3 = Color3.fromRGB(23, 26, 33)
    frame.BorderSizePixel = 0
    frame.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame

    local label = Instance.new("TextLabel")
    label.Position = UDim2.fromOffset(12, 0)
    label.Size = UDim2.new(1, -65, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(225,225,230)
    label.TextSize = 13
    label.Font = CurrentFont
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local switch = Instance.new("TextButton")
    switch.Size = UDim2.fromOffset(42, 22)
    switch.Position = UDim2.new(1, -53, 0.5, -11)
    switch.BackgroundColor3 = Color3.fromRGB(55,58,66)
    switch.Text = ""
    switch.AutoButtonColor = false
    switch.Parent = frame

    local switchCorner = Instance.new("UICorner")
    switchCorner.CornerRadius = UDim.new(1,0)
    switchCorner.Parent = switch

    local knob = Instance.new("Frame")
    knob.Size = UDim2.fromOffset(16,16)
    knob.Position = UDim2.new(0,3,0.5,-8)
    knob.BackgroundColor3 = Color3.fromRGB(220,220,225)
    knob.Parent = switch

    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1,0)
    knobCorner.Parent = knob

    local enabled = default or false

    local function update()
        TweenService:Create(
            switch,
            TweenInfo.new(0.15),
            {
                BackgroundColor3 = enabled
                    and ThemeColor
                    or Color3.fromRGB(55,58,66)
            }
        ):Play()

        TweenService:Create(
            knob,
            TweenInfo.new(0.15),
            {
                Position = enabled
                    and UDim2.new(1,-19,0.5,-8)
                    or UDim2.new(0,3,0.5,-8)
            }
        ):Play()

        callback(enabled)
    end

    switch.MouseButton1Click:Connect(function()
        enabled = not enabled
        update()
    end)

    update()

    return {
        Set = function(v)
            enabled = v
            update()
        end
    }
end

local function createSlider(parent, text, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 58)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -65, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220,220,225)
    label.TextSize = 12
    label.Font = CurrentFont
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.fromOffset(55,20)
    valueLabel.Position = UDim2.new(1,-55,0,0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.TextColor3 = ThemeColor
    valueLabel.TextSize = 12
    valueLabel.Font = CurrentFont
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = frame

    local bar = Instance.new("Frame")
    bar.Position = UDim2.fromOffset(0,31)
    bar.Size = UDim2.new(1,0,0,5)
    bar.BackgroundColor3 = Color3.fromRGB(48,51,60)
    bar.BorderSizePixel = 0
    bar.Parent = frame

    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(1,0)
    barCorner.Parent = bar

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default-min)/(max-min),0,1,0)
    fill.BackgroundColor3 = ThemeColor
    fill.BorderSizePixel = 0
    fill.Parent = bar

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1,0)
    fillCorner.Parent = fill

    local knob = Instance.new("Frame")
    knob.Size = UDim2.fromOffset(14,14)
    knob.AnchorPoint = Vector2.new(0.5,0.5)
    knob.Position = UDim2.new((default-min)/(max-min),0,0.5,0)
    knob.BackgroundColor3 = Color3.fromRGB(225,225,230)
    knob.Parent = bar

    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1,0)
    knobCorner.Parent = knob

    local value = default

    local function setValue(v)
        value = math.clamp(math.floor(v + 0.5), min, max)

        local percent = (value-min)/(max-min)

        fill.Size = UDim2.new(percent,0,1,0)
        knob.Position = UDim2.new(percent,0,0.5,0)
        valueLabel.Text = tostring(value)

        callback(value)
    end

    local dragging = false

    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true

            local percent = math.clamp(
                (input.Position.X - bar.AbsolutePosition.X) /
                bar.AbsoluteSize.X,
                0,
                1
            )

            setValue(min + (max-min)*percent)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (
            input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch
        ) then

            local percent = math.clamp(
                (input.Position.X - bar.AbsolutePosition.X) /
                bar.AbsoluteSize.X,
                0,
                1
            )

            setValue(min + (max-min)*percent)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    setValue(default)

    return {
        Set = setValue,
        Get = function()
            return value
        end
    }
end

local function createButton(parent, text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1,0,0,40)
    button.BackgroundColor3 = Color3.fromRGB(27,30,38)
    button.Text = text
    button.TextColor3 = Color3.fromRGB(225,225,230)
    button.TextSize = 13
    button.Font = CurrentFont
    button.AutoButtonColor = false
    button.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,8)
    corner.Parent = button

    button.MouseEnter:Connect(function()
        TweenService:Create(
            button,
            TweenInfo.new(0.12),
            {BackgroundColor3 = ThemeColor}
        ):Play()
    end)

    button.MouseLeave:Connect(function()
        TweenService:Create(
            button,
            TweenInfo.new(0.12),
            {BackgroundColor3 = Color3.fromRGB(27,30,38)}
        ):Play()
    end)

    button.MouseButton1Click:Connect(callback)

    return button
end

--// =========================================================
--// HOME
--// =========================================================

createSection(
    HomePage,
    "Welcome to Coal Hub",
    "Modern interface • simple controls • clean design"
)

createButton(HomePage, "Open Player Settings", function()
    PlayerPage.Visible = true
    HomePage.Visible = false
end)

createButton(HomePage, "Open Interface Settings", function()
    InterfacePage.Visible = true
    HomePage.Visible = false
end)

--// =========================================================
--// PLAYER
--// =========================================================

createSection(PlayerPage, "Movement", "Настройки передвижения персонажа")

createToggle(PlayerPage, "WalkSpeed", false, function(v)
    WalkSpeedEnabled = v
end)

createSlider(PlayerPage, "Speed", 16, 150, 16, function(v)
    WalkSpeedValue = v
end)

createToggle(PlayerPage, "Jump Power", false, function(v)
    JumpPowerEnabled = v
end)

createSlider(PlayerPage, "Jump Power", 50, 200, 50, function(v)
    JumpPowerValue = v
end)

createToggle(PlayerPage, "Infinite Jump", false, function(v)
    InfJumpEnabled = v
end)

createToggle(PlayerPage, "Noclip", false, function(v)
    NoclipEnabled = v
end)

createToggle(PlayerPage, "Fly", false, function(v)
    FlyEnabled = v
end)

createSlider(PlayerPage, "Fly Speed", 10, 150, 50, function(v)
    FlySpeedValue = v
end)

--// =========================================================
--// COMBAT
--// =========================================================

createSection(CombatPage, "Aimbot", "Настройки прицеливания")

createToggle(CombatPage, "Aimbot", false, function(v)
    AimbotEnabled = v
end)

createToggle(CombatPage, "FOV Circle", false, function(v)
    FovEnabled = v
end)

createSlider(CombatPage, "FOV Radius", 50, 500, 150, function(v)
    FovRadius = v
end)

createToggle(CombatPage, "Wall Check", false, function(v)
    WallCheckEnabled = v
end)

--// =========================================================
--// VISUALS
--// =========================================================

createSection(
    VisualsPage,
    "ESP",
    "Визуальные функции игроков"
)

createToggle(VisualsPage, "ESP", false, function(v)
    ESPEnabled = v
end)

createToggle(VisualsPage, "Tracers", false, function(v)
    TracersEnabled = v
end)

createToggle(VisualsPage, "Names + Distance", false, function(v)
    NamesEnabled = v
end)

createToggle(VisualsPage, "Fullbright", false, function(v)
    FullbrightEnabled = v
end)

createToggle(VisualsPage, "Spin", false, function(v)
    SpinEnabled = v
end)

createSection(
    VisualsPage,
    "Camera",
    "Настройки третьего лица"
)

createToggle(
    VisualsPage,
    "Third Person",
    false,
    function(v)
        ThirdPersonEnabled = v

        if v then
            LocalPlayer.CameraMode = Enum.CameraMode.Classic
            LocalPlayer.CameraMaxZoomDistance = CameraDistance

            if LockCameraDistance then
                LocalPlayer.CameraMinZoomDistance = CameraDistance
            else
                LocalPlayer.CameraMinZoomDistance = 0.5
            end
        else
            LocalPlayer.CameraMode = Enum.CameraMode.Classic
            LocalPlayer.CameraMinZoomDistance = 0.5
            LocalPlayer.CameraMaxZoomDistance = 128
        end
    end
)

createSlider(
    VisualsPage,
    "Camera Distance",
    5,
    30,
    12,
    function(v)
        CameraDistance = v

        if ThirdPersonEnabled then
            LocalPlayer.CameraMaxZoomDistance = v

            if LockCameraDistance then
                LocalPlayer.CameraMinZoomDistance = v
            end
        end
    end
)

createToggle(
    VisualsPage,
    "Lock Camera Distance",
    false,
    function(v)
        LockCameraDistance = v

        if ThirdPersonEnabled then
            if v then
                LocalPlayer.CameraMinZoomDistance = CameraDistance
                LocalPlayer.CameraMaxZoomDistance = CameraDistance
            else
                LocalPlayer.CameraMinZoomDistance = 0.5
                LocalPlayer.CameraMaxZoomDistance = CameraDistance
            end
        end
    end
)

createButton(
    VisualsPage,
    "Reset Camera",
    function()
        CameraDistance = 12
        LockCameraDistance = false

        LocalPlayer.CameraMode = Enum.CameraMode.Classic
        LocalPlayer.CameraMinZoomDistance = 0.5
        LocalPlayer.CameraMaxZoomDistance = 128
    end
)

--// =========================================================
--// TELEPORT
--// =========================================================

createSection(
    TeleportPage,
    "Teleport",
    "Выбор игрока для телепортации"
)

local SelectedLabel = Instance.new("TextLabel")
SelectedLabel.Size = UDim2.new(1,0,0,35)
SelectedLabel.BackgroundColor3 = Color3.fromRGB(24,27,34)
SelectedLabel.Text = "Selected: None"
SelectedLabel.TextColor3 = Color3.fromRGB(200,205,215)
SelectedLabel.TextSize = 12
SelectedLabel.Font = CurrentFont
SelectedLabel.Parent = TeleportPage

local SelectedCorner = Instance.new("UICorner")
SelectedCorner.CornerRadius = UDim.new(0,8)
SelectedCorner.Parent = SelectedLabel

local PlayerList = Instance.new("ScrollingFrame")
PlayerList.Size = UDim2.new(1,0,0,150)
PlayerList.BackgroundColor3 = Color3.fromRGB(21,24,30)
PlayerList.BorderSizePixel = 0
PlayerList.ScrollBarThickness = 3
PlayerList.Parent = TeleportPage

local PlayerLayout = Instance.new("UIListLayout")
PlayerLayout.Padding = UDim.new(0,4)
PlayerLayout.Parent = PlayerList

local function RefreshPlayers()
    for _, child in ipairs(PlayerList:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local button = Instance.new("TextButton")
            button.Size = UDim2.new(1,-8,0,32)
            button.BackgroundColor3 = Color3.fromRGB(30,33,41)
            button.Text = player.DisplayName .. "  @" .. player.Name
            button.TextColor3 = Color3.fromRGB(220,220,225)
            button.TextSize = 11
            button.Font = Enum.Font.Gotham
            button.Parent = PlayerList

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0,7)
            corner.Parent = button

            button.MouseButton1Click:Connect(function()
                SelectedTargetPlayer = player
                SelectedLabel.Text = "Selected: " .. player.Name
            end)
        end
    end

    PlayerList.CanvasSize = UDim2.fromOffset(
        0,
        PlayerLayout.AbsoluteContentSize.Y + 8
    )
end

createButton(TeleportPage, "Refresh Players", RefreshPlayers)

createButton(TeleportPage, "Fast Teleport", function()
    if SelectedTargetPlayer
    and SelectedTargetPlayer.Character
    and SelectedTargetPlayer.Character:FindFirstChild("HumanoidRootPart")
    and LocalPlayer.Character
    and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then

        LocalPlayer.Character.HumanoidRootPart.CFrame =
            SelectedTargetPlayer.Character.HumanoidRootPart.CFrame
    end
end)

--// =========================================================
--// HUD
--// =========================================================

createSection(
    HUDPage,
    "HUD Information",
    "Информация на экране"
)

createToggle(HUDPage, "FPS", false, function(v)
    ShowFPS = v
end)

createToggle(HUDPage, "Ping", false, function(v)
    ShowPing = v
end)

createToggle(HUDPage, "CPS", false, function(v)
    ShowCPS = v
end)

createToggle(HUDPage, "Players", true, function(v)
    ShowPlayers = v
end)

createToggle(HUDPage, "Time", true, function(v)
    ShowTime = v
end)

--// HUD FRAME
local HUDFrame = Instance.new("Frame")
HUDFrame.Size = UDim2.fromOffset(175, 115)
HUDFrame.Position = UDim2.fromOffset(15, 15)
HUDFrame.BackgroundColor3 = Color3.fromRGB(15,17,22)
HUDFrame.BackgroundTransparency = 0.12
HUDFrame.BorderSizePixel = 0
HUDFrame.Visible = true
HUDFrame.Parent = ScreenGui

local HUDCorner = Instance.new("UICorner")
HUDCorner.CornerRadius = UDim.new(0,10)
HUDCorner.Parent = HUDFrame

local HUDStroke = Instance.new("UIStroke")
HUDStroke.Color = ThemeColor
HUDStroke.Transparency = 0.25
HUDStroke.Parent = HUDFrame

local HUDText = Instance.new("TextLabel")
HUDText.Position = UDim2.fromOffset(10,8)
HUDText.Size = UDim2.new(1,-20,1,-16)
HUDText.BackgroundTransparency = 1
HUDText.TextColor3 = Color3.new(1,1,1)
HUDText.TextSize = 12
HUDText.Font = Enum.Font.GothamBold
HUDText.TextXAlignment = Enum.TextXAlignment.Left
HUDText.TextYAlignment = Enum.TextYAlignment.Top
HUDText.Parent = HUDFrame

--// =========================================================
--// INTERFACE
--// =========================================================

createSection(
    InterfacePage,
    "Window Size",
    "Изменение размера главного окна"
)

local WidthSlider = createSlider(
    InterfacePage,
    "Width",
    450,
    900,
    590,
    function(v)
        WindowWidth = v

        MainFrame.Size = UDim2.fromOffset(
            WindowWidth,
            WindowHeight
        )

        MainFrame.Position = UDim2.new(
            0.5,
            -WindowWidth / 2,
            0.5,
            -WindowHeight / 2
        )
    end
)

local HeightSlider = createSlider(
    InterfacePage,
    "Height",
    300,
    600,
    390,
    function(v)
        WindowHeight = v

        MainFrame.Size = UDim2.fromOffset(
            WindowWidth,
            WindowHeight
        )

        MainFrame.Position = UDim2.new(
            0.5,
            -WindowWidth / 2,
            0.5,
            -WindowHeight / 2
        )
    end
)

createButton(
    InterfacePage,
    "Reset Size  •  590 × 390",
    function()
        WindowWidth = 590
        WindowHeight = 390

        WidthSlider.Set(590)
        HeightSlider.Set(390)
    end
)

createSection(
    InterfacePage,
    "Menu",
    "Дополнительные настройки интерфейса"
)

createSlider(
    InterfacePage,
    "Transparency",
    0,
    80,
    8,
    function(v)
        MenuTransparency = v / 100

        MainFrame.BackgroundTransparency = MenuTransparency
    end
)

createSlider(
    InterfacePage,
    "Animation Speed",
    5,
    100,
    20,
    function(v)
        AnimationSpeed = v / 100
    end
)

--// =========================================================
--// SETTINGS
--// =========================================================

createSection(
    SettingsPage,
    "Theme",
    "Выбор цвета интерфейса"
)

local function setTheme(color)
    ThemeColor = color

    MainStroke.Color = color
    HUDStroke.Color = color
    Logo.BackgroundColor3 = color

    for _, button in pairs(TabButtons) do
        if button:GetAttribute("Selected") then
            button.BackgroundColor3 = color
        end
    end

    -- обновляем FOV
    if FOVCircle then
        FOVCircle.BackgroundColor3 = color
    end
end

createButton(SettingsPage, "Blue", function()
    setTheme(Color3.fromRGB(0,170,255))
end)

createButton(SettingsPage, "Purple", function()
    setTheme(Color3.fromRGB(150,80,255))
end)

createButton(SettingsPage, "Green", function()
    setTheme(Color3.fromRGB(50,220,130))
end)

createButton(SettingsPage, "Red", function()
    setTheme(Color3.fromRGB(255,75,90))
end)

createSection(
    SettingsPage,
    "Font",
    "Выбор шрифта интерфейса"
)

createButton(SettingsPage, "GothamBold", function()
    CurrentFont = Enum.Font.GothamBold
end)

createButton(SettingsPage, "Gotham", function()
    CurrentFont = Enum.Font.Gotham
end)

createButton(SettingsPage, "SourceSans", function()
    CurrentFont = Enum.Font.SourceSansBold
end)

--// =========================================================
--// FOV CIRCLE
--// =========================================================

local FOVCircle = Instance.new("Frame")
FOVCircle.Name = "FOVCircle"
FOVCircle.AnchorPoint = Vector2.new(0.5,0.5)
FOVCircle.Position = UDim2.new(0.5,0,0.5,0)
FOVCircle.Size = UDim2.fromOffset(FovRadius*2,FovRadius*2)
FOVCircle.BackgroundTransparency = 1
FOVCircle.Visible = false
FOVCircle.Parent = ScreenGui

local FOVCorner = Instance.new("UICorner")
FOVCorner.CornerRadius = UDim.new(1,0)
FOVCorner.Parent = FOVCircle

local FOVStroke = Instance.new("UIStroke")
FOVStroke.Color = ThemeColor
FOVStroke.Thickness = 1.5
FOVStroke.Transparency = 0.25
FOVStroke.Parent = FOVCircle

--// =========================================================
--// MINI HUB BUTTON
--// =========================================================

local MiniButton = Instance.new("TextButton")
MiniButton.Size = UDim2.fromOffset(48,48)
MiniButton.Position = UDim2.new(0,15,0.5,-24)
MiniButton.BackgroundColor3 = ThemeColor
MiniButton.Text = "C"
MiniButton.TextColor3 = Color3.new(1,1,1)
MiniButton.TextSize = 21
MiniButton.Font = CurrentFont
MiniButton.Visible = false
MiniButton.Parent = ScreenGui

local MiniCorner = Instance.new("UICorner")
MiniCorner.CornerRadius = UDim.new(0,12)
MiniCorner.Parent = MiniButton

--// =========================================================
--// DRAG SYSTEM
--// =========================================================

local function makeDraggable(frame, handle)
    local dragging = false
    local dragStart
    local startPos

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

            dragging = true
            dragStart = input.Position
            startPos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (
            input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch
        ) then

            local delta = input.Position - dragStart

            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

makeDraggable(MainFrame, Header)
makeDraggable(HUDFrame, HUDFrame)

--// =========================================================
--// OPEN / CLOSE
--// =========================================================

local MenuOpen = true

CloseButton.MouseButton1Click:Connect(function()
    MenuOpen = false
    MainFrame.Visible = false
    MiniButton.Visible = true
end)

MiniButton.MouseButton1Click:Connect(function()
    MenuOpen = true
    MainFrame.Visible = true
    MiniButton.Visible = false
end)

--// =========================================================
--// INFINITE JUMP
--// =========================================================

UserInputService.JumpRequest:Connect(function()
    if InfJumpEnabled then
        local character = LocalPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")

        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

--// =========================================================
--// AIMBOT HELPERS
--// =========================================================

local function isVisible(target)
    if not WallCheckEnabled then
        return true
    end

    local character = target.Character
    if not character then
        return false
    end

    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then
        return false
    end

    local origin = Camera.CFrame.Position
    local direction = root.Position - origin

    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {
        LocalPlayer.Character
    }

    local result = workspace:Raycast(
        origin,
        direction,
        params
    )

    return result and result.Instance:IsDescendantOf(character)
end

local function getClosestTarget()
    local closest = nil
    local closestDistance = FovRadius

    local viewport = Camera.ViewportSize
    local center = Vector2.new(
        viewport.X/2,
        viewport.Y/2
    )

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then

            local humanoid =
                player.Character:FindFirstChildOfClass("Humanoid")

            local head =
                player.Character:FindFirstChild("Head")

            if humanoid
            and head
            and humanoid.Health > 0 then

                local screenPos, visible =
                    Camera:WorldToViewportPoint(head.Position)

                if visible then
                    local distance = (
                        Vector2.new(
                            screenPos.X,
                            screenPos.Y
                        ) - center
                    ).Magnitude

                    if distance < closestDistance
                    and isVisible(player) then
                        closestDistance = distance
                        closest = player
                    end
                end
            end
        end
    end

    return closest
end

--// =========================================================
--// NOCLIP
--// =========================================================

RunService.Stepped:Connect(function()
    if not NoclipEnabled then
        return
    end

    local character = LocalPlayer.Character

    if character then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

--// =========================================================
--// MAIN LOOP
--// =========================================================

local lastTime = tick()
local frames = 0
local FPS = 0

RunService.RenderStepped:Connect(function(deltaTime)

    --// FPS
    frames += 1

    if tick() - lastTime >= 1 then
        FPS = frames
        frames = 0
        lastTime = tick()
    end

    --// CHARACTER
    local character = LocalPlayer.Character
    local humanoid = character and
        character:FindFirstChildOfClass("Humanoid")

    --// SPEED
    if humanoid then
        if WalkSpeedEnabled then
            humanoid.WalkSpeed = WalkSpeedValue
        else
            humanoid.WalkSpeed = 16
        end

        if JumpPowerEnabled then
            humanoid.JumpPower = JumpPowerValue
        else
            humanoid.JumpPower = 50
        end
    end

    --// FOV
    FOVCircle.Visible = FovEnabled
    FOVCircle.Size = UDim2.fromOffset(
        FovRadius*2,
        FovRadius*2
    )

    --// AIMBOT
    if AimbotEnabled then
        local target = getClosestTarget()

        if target
        and target.Character
        and target.Character:FindFirstChild("Head") then

            local head =
                target.Character.Head

            Camera.CFrame = CFrame.lookAt(
                Camera.CFrame.Position,
                head.Position
            )
        end
    end

    --// FULLBRIGHT
    if FullbrightEnabled then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
        Lighting.OutdoorAmbient =
            Color3.fromRGB(255,255,255)
    end

    --// SPIN
    if SpinEnabled and character then
        local root =
            character:FindFirstChild("HumanoidRootPart")

        if root then
            SpinAngle += 180 * deltaTime

            root.CFrame =
                CFrame.new(root.Position) *
                CFrame.Angles(0, math.rad(SpinAngle), 0)
        end
    end

    --// CAMERA
    if ThirdPersonEnabled then
        LocalPlayer.CameraMode =
            Enum.CameraMode.Classic

        LocalPlayer.CameraMaxZoomDistance =
            CameraDistance

        if LockCameraDistance then
            LocalPlayer.CameraMinZoomDistance =
                CameraDistance
        else
            LocalPlayer.CameraMinZoomDistance =
                0.5
        end
    end

    --// HUD
    local lines = {}

    if ShowFPS then
        table.insert(lines, "FPS: " .. FPS)
    end

    if ShowPing then
        local ping = 0

        pcall(function()
            ping = math.floor(
                Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
            )
        end)

        table.insert(lines, "PING: " .. ping .. " ms")
    end

    if ShowCPS then
        table.insert(lines, "CPS: " .. CpsCounter)
    end

    if ShowPlayers then
        table.insert(
            lines,
            "PLAYERS: " ..
            #Players:GetPlayers()
        )
    end

    if ShowTime then
        table.insert(
            lines,
            "TIME: " ..
            os.date("%H:%M:%S")
        )
    end

    HUDText.Text = table.concat(lines, "\n")

    if #lines == 0 then
        HUDFrame.Visible = false
    else
        HUDFrame.Visible = true
    end
end)

--// =========================================================
--// CPS
--// =========================================================

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then
        return
    end

    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        CpsCounter += 1

        task.delay(1, function()
            CpsCounter = math.max(
                0,
                CpsCounter - 1
            )
        end)
    end
end)

--// =========================================================
--// PLAYERS
--// =========================================================

Players.PlayerAdded:Connect(function()
    RefreshPlayers()
end)

Players.PlayerRemoving:Connect(function(player)
    if SelectedTargetPlayer == player then
        SelectedTargetPlayer = nil
        SelectedLabel.Text = "Selected: None"
    end

    RefreshPlayers()
end)

--// =========================================================
--// INITIAL STATE
--// =========================================================

HomePage.Visible = true

local firstButton = TabButtons[HomePage]

if firstButton then
    firstButton:SetAttribute("Selected", true)
    firstButton.BackgroundTransparency = 0
    firstButton.BackgroundColor3 = ThemeColor
    firstButton.TextColor3 = Color3.new(1,1,1)
end

RefreshPlayers()

print("Coal Hub V1 loaded successfully.")
