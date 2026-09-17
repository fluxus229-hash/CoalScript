-- Modern GUI: Coal Hub (With Smooth Animations)
local AimbotEnabled = false
local FovEnabled = false
local FovRadius = 150
local WallCheckEnabled = true
local ESPEnabled = false
local WalkSpeedValue = 16
local JumpPowerValue = 50
local AimBtnGuiVisible = true

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

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

-- Floating AIM Button (Быстрая кнопка)
local QuickAimBtn = Instance.new("TextButton")
QuickAimBtn.Name = "QuickAimButton"
QuickAimBtn.Size = UDim2.new(0, 55, 0, 55)
QuickAimBtn.Position = UDim2.new(0.85, 0, 0.35, 0)
QuickAimBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
QuickAimBtn.Text = "AIM"
QuickAimBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
QuickAimBtn.TextSize = 15
QuickAimBtn.Font = Enum.Font.GothamBold
QuickAimBtn.Active = true
QuickAimBtn.Draggable = true
QuickAimBtn.Visible = true
QuickAimBtn.Parent = ScreenGui

local QuickAimCorner = Instance.new("UICorner")
QuickAimCorner.CornerRadius = UDim.new(0, 14)
QuickAimCorner.Parent = QuickAimBtn

local QuickAimStroke = Instance.new("UIStroke")
QuickAimStroke.Color = Color3.fromRGB(255, 255, 255)
QuickAimStroke.Transparency = 0.5
QuickAimStroke.Thickness = 2
QuickAimStroke.Parent = QuickAimBtn

-- Mini Open Button (Свернутая кнопка HUB)
local MiniSquare = Instance.new("TextButton")
MiniSquare.Name = "MiniSquare"
MiniSquare.Size = UDim2.new(0, 50, 0, 50)
MiniSquare.Position = UDim2.new(0.05, 0, 0.1, 0)
MiniSquare.BackgroundColor3 = Color3.fromRGB(25, 28, 40)
MiniSquare.BackgroundTransparency = 1
MiniSquare.Text = "HUB"
MiniSquare.TextColor3 = Color3.fromRGB(0, 170, 255)
MiniSquare.TextTransparency = 1
MiniSquare.TextSize = 14
MiniSquare.Font = Enum.Font.GothamBold
MiniSquare.Visible = false
MiniSquare.Active = true
MiniSquare.Draggable = true
MiniSquare.Parent = ScreenGui

local SquareCorner = Instance.new("UICorner")
SquareCorner.CornerRadius = UDim.new(0, 12)
SquareCorner.Parent = MiniSquare

local SquareStroke = Instance.new("UIStroke")
SquareStroke.Color = Color3.fromRGB(0, 170, 255)
SquareStroke.Transparency = 1
SquareStroke.Thickness = 1.5
SquareStroke.Parent = MiniSquare

-- Main Container Window
local MainFrame = Instance.new("CanvasGroup") -- CanvasGroup гарантирует идеальное плавное исчезновение всех дочерних элементов
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 520, 0, 320)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -160)
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

-- Top Bar (Header)
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.BackgroundTransparency = 1
TopBar.Parent = MainFrame

-- Title Label (Coal Hub)
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Position = UDim2.new(0, 15, 0, 6)
TitleLabel.Size = UDim2.new(0, 180, 0, 20)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Coal Hub"
TitleLabel.TextColor3 = Color3.fromRGB(120, 160, 255)
TitleLabel.TextSize = 15
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TopBar

local SubTitle = Instance.new("TextLabel")
SubTitle.Position = UDim2.new(0, 15, 0, 24)
SubTitle.Size = UDim2.new(0, 180, 0, 15)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "coalhub.top"
SubTitle.TextColor3 = Color3.fromRGB(120, 130, 150)
SubTitle.TextSize = 11
SubTitle.Font = Enum.Font.Gotham
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.Parent = TopBar

-- Keyless Badge
local KeylessBadge = Instance.new("TextLabel")
KeylessBadge.Position = UDim2.new(0, 110, 0, 12)
KeylessBadge.Size = UDim2.new(0, 65, 0, 22)
KeylessBadge.BackgroundColor3 = Color3.fromRGB(30, 90, 220)
KeylessBadge.Text = "Keyless"
KeylessBadge.TextColor3 = Color3.fromRGB(255, 255, 255)
KeylessBadge.TextSize = 11
KeylessBadge.Font = Enum.Font.GothamBold
KeylessBadge.Parent = TopBar

local BadgeCorner = Instance.new("UICorner")
BadgeCorner.CornerRadius = UDim.new(0, 8)
BadgeCorner.Parent = KeylessBadge

-- Close Button (✕)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(1, -35, 0, 10)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(160, 170, 190)
CloseBtn.TextSize = 16
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = TopBar

-- Sidebar Left Panel
local Sidebar = Instance.new("Frame")
Sidebar.Position = UDim2.new(0, 0, 0, 45)
Sidebar.Size = UDim2.new(0, 125, 1, -45)
Sidebar.BackgroundTransparency = 1
Sidebar.Parent = MainFrame

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.Padding = UDim.new(0, 4)
SidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
SidebarLayout.Parent = Sidebar

-- Right Content Panel
local ContentArea = Instance.new("Frame")
ContentArea.Position = UDim2.new(0, 130, 0, 45)
ContentArea.Size = UDim2.new(1, -135, 1, -50)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainFrame

-- Container Tabs
local Tabs = {
    Main = Instance.new("ScrollingFrame"),
    Visuals = Instance.new("ScrollingFrame"),
    LocalPlayer = Instance.new("ScrollingFrame"),
    Settings = Instance.new("ScrollingFrame")
}

for tabName, tabFrame in pairs(Tabs) do
    tabFrame.Name = tabName .. "Tab"
    tabFrame.Size = UDim2.new(1, 0, 1, 0)
    tabFrame.BackgroundTransparency = 1
    tabFrame.BorderSizePixel = 0
    tabFrame.ScrollBarThickness = 2
    tabFrame.Visible = false
    tabFrame.Parent = ContentArea
    
    local list = Instance.new("UIListLayout")
    list.Padding = UDim.new(0, 8)
    list.HorizontalAlignment = Enum.HorizontalAlignment.Center
    list.Parent = tabFrame
end

Tabs.Main.Visible = true

-- Helper Functions for Controls
local function createToggleRow(parentTab, titleText, initialStatus, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(0.95, 0, 0, 40)
    row.BackgroundColor3 = Color3.fromRGB(28, 32, 45)
    row.BackgroundTransparency = 0.3
    row.Parent = parentTab
    
    local rCorner = Instance.new("UICorner")
    rCorner.CornerRadius = UDim.new(0, 8)
    rCorner.Parent = row

    local label = Instance.new("TextLabel")
    label.Position = UDim2.new(0, 12, 0, 0)
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = titleText
    label.TextColor3 = Color3.fromRGB(220, 225, 240)
    label.TextSize = 13
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = row

    local button = Instance.new("TextButton")
    button.Position = UDim2.new(1, -100, 0.5, -13)
    button.Size = UDim2.new(0, 90, 0, 26)
    button.BackgroundColor3 = initialStatus and Color3.fromRGB(35, 160, 95) or Color3.fromRGB(180, 50, 50)
    button.Text = initialStatus and "ON" or "OFF"
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 12
    button.Font = Enum.Font.GothamBold
    button.Parent = row

    local bCorner = Instance.new("UICorner")
    bCorner.CornerRadius = UDim.new(0, 6)
    bCorner.Parent = button

    local state = initialStatus
    button.MouseButton1Click:Connect(function()
        state = not state
        button.Text = state and "ON" or "OFF"
        button.BackgroundColor3 = state and Color3.fromRGB(35, 160, 95) or Color3.fromRGB(180, 50, 50)
        callback(state, button)
    end)

    return button
end

local function createButtonRow(parentTab, titleText, btnText, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(0.95, 0, 0, 40)
    row.BackgroundColor3 = Color3.fromRGB(28, 32, 45)
    row.BackgroundTransparency = 0.3
    row.Parent = parentTab
    
    local rCorner = Instance.new("UICorner")
    rCorner.CornerRadius = UDim.new(0, 8)
    rCorner.Parent = row

    local label = Instance.new("TextLabel")
    label.Position = UDim2.new(0, 12, 0, 0)
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = titleText
    label.TextColor3 = Color3.fromRGB(220, 225, 240)
    label.TextSize = 13
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = row

    local button = Instance.new("TextButton")
    button.Position = UDim2.new(1, -120, 0.5, -13)
    button.Size = UDim2.new(0, 110, 0, 26)
    button.BackgroundColor3 = Color3.fromRGB(45, 60, 90)
    button.Text = btnText
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 12
    button.Font = Enum.Font.GothamBold
    button.Parent = row

    local bCorner = Instance.new("UICorner")
    bCorner.CornerRadius = UDim.new(0, 6)
    bCorner.Parent = button

    button.MouseButton1Click:Connect(function()
        callback(button)
    end)
    return button
end

-- Sidebar Navigation Setup
local tabButtons = {}

local function createTabButton(name, displayName)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 32)
    btn.BackgroundTransparency = 1
    btn.Text = "  " .. displayName
    btn.TextColor3 = Color3.fromRGB(140, 150, 175)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamMedium
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = Sidebar

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        for tName, tFrame in pairs(Tabs) do
            tFrame.Visible = (tName == name)
        end
        for _, button in pairs(tabButtons) do
            button.BackgroundTransparency = 1
            button.TextColor3 = Color3.fromRGB(140, 150, 175)
        end
        btn.BackgroundTransparency = 0.8
        btn.BackgroundColor3 = Color3.fromRGB(100, 140, 255)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)

    table.insert(tabButtons, btn)
    return btn
end

local firstTab = createTabButton("Main", "🎯 Main")
createTabButton("Visuals", "👁 Visuals")
createTabButton("LocalPlayer", "🏃 Player")
createTabButton("Settings", "⚙ Settings")

firstTab.BackgroundTransparency = 0.8
firstTab.BackgroundColor3 = Color3.fromRGB(100, 140, 255)
firstTab.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Tab Content Setup
local mainAimBtn = createToggleRow(Tabs.Main, "Aimbot", AimbotEnabled, function(state)
    AimbotEnabled = state
    QuickAimBtn.BackgroundColor3 = AimbotEnabled and Color3.fromRGB(35, 160, 95) or Color3.fromRGB(180, 50, 50)
end)

createToggleRow(Tabs.Main, "Wall Check", WallCheckEnabled, function(state)
    WallCheckEnabled = state
end)

local function toggleAimbotGlobal(state)
    if state == nil then
        AimbotEnabled = not AimbotEnabled
    else
        AimbotEnabled = state
    end
    
    mainAimBtn.Text = AimbotEnabled and "ON" or "OFF"
    mainAimBtn.BackgroundColor3 = AimbotEnabled and Color3.fromRGB(35, 160, 95) or Color3.fromRGB(180, 50, 50)
    
    QuickAimBtn.BackgroundColor3 = AimbotEnabled and Color3.fromRGB(35, 160, 95) or Color3.fromRGB(180, 50, 50)
end

QuickAimBtn.MouseButton1Click:Connect(function()
    toggleAimbotGlobal()
end)

createToggleRow(Tabs.Visuals, "FOV Circle", FovEnabled, function(state)
    FovEnabled = state
    FovFrame.Visible = FovEnabled
end)

createButtonRow(Tabs.Visuals, "FOV Radius", "Radius: 150", function(btn)
    if FovRadius == 100 then FovRadius = 150
    elseif FovRadius == 150 then FovRadius = 200
    elseif FovRadius == 200 then FovRadius = 250
    else FovRadius = 100 end
    btn.Text = "Radius: " .. tostring(FovRadius)
    FovFrame.Size = UDim2.new(0, FovRadius * 2, 0, FovRadius * 2)
end)

createToggleRow(Tabs.Visuals, "ESP (Red Highlight)", ESPEnabled, function(state)
    ESPEnabled = state
end)

createButtonRow(Tabs.LocalPlayer, "Walk Speed", "Speed: Normal", function(btn)
    if WalkSpeedValue == 16 then WalkSpeedValue = 30
    elseif WalkSpeedValue == 30 then WalkSpeedValue = 50
    else WalkSpeedValue = 16 end
    btn.Text = "Speed: " .. (WalkSpeedValue == 16 and "Normal" or tostring(WalkSpeedValue))
end)

createButtonRow(Tabs.LocalPlayer, "Jump Power", "Jump: Normal", function(btn)
    if JumpPowerValue == 50 then JumpPowerValue = 90
    elseif JumpPowerValue == 90 then JumpPowerValue = 130
    else JumpPowerValue = 50 end
    btn.Text = "Jump: " .. (JumpPowerValue == 50 and "Normal" or tostring(JumpPowerValue))
end)

createToggleRow(Tabs.Settings, "AIM Button UI", AimBtnGuiVisible, function(state)
    AimBtnGuiVisible = state
    QuickAimBtn.Visible = AimBtnGuiVisible
end)

---------------------------------------------------------
-- SMOOTH ANIMATION TWEEN LOGIC (Плавное открытие / закрытие)
---------------------------------------------------------
local tweenInfo = TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local isAnimating = false

-- Закрытие меню (Нажатие на ✕)
CloseBtn.MouseButton1Click:Connect(function()
    if isAnimating then return end
    isAnimating = true

    -- Плавное уменьшение и затухание меню
    local hideTween = TweenService:Create(MainFrame, tweenInfo, {
        GroupTransparency = 1,
        Size = UDim2.new(0, 480, 0, 290)
    })
    
    hideTween:Play()
    
    hideTween.Completed:Connect(function()
        MainFrame.Visible = false
        MiniSquare.Visible = true
        
        -- Появление плавающей кнопки HUB
        local showHubTween = TweenService:Create(MiniSquare, tweenInfo, {
            BackgroundTransparency = 0,
            TextTransparency = 0
        })
        local strokeTween = TweenService:Create(SquareStroke, tweenInfo, {
            Transparency = 0
        })
        
        showHubTween:Play()
        strokeTween:Play()
        showHubTween.Completed:Connect(function()
            isAnimating = false
        end)
    end)
end)

-- Открытие меню (Нажатие на HUB)
MiniSquare.MouseButton1Click:Connect(function()
    if isAnimating then return end
    isAnimating = true

    -- Плавное исчезновение кнопки HUB
    local hideHubTween = TweenService:Create(MiniSquare, tweenInfo, {
        BackgroundTransparency = 1,
        TextTransparency = 1
    })
    local strokeTween = TweenService:Create(SquareStroke, tweenInfo, {
        Transparency = 1
    })
    
    hideHubTween:Play()
    strokeTween:Play()
    
    hideHubTween.Completed:Connect(function()
        MiniSquare.Visible = false
        
        -- Сброс начальных анимационных значений меню
        MainFrame.Size = UDim2.new(0, 480, 0, 290)
        MainFrame.GroupTransparency = 1
        MainFrame.Visible = true
        
        -- Плавное увеличение и появление меню
        local showTween = TweenService:Create(MainFrame, tweenInfo, {
            GroupTransparency = 0,
            Size = UDim2.new(0, 520, 0, 320)
        })
        
        showTween:Play()
        showTween.Completed:Connect(function()
            isAnimating = false
        end)
    end)
end)

---------------------------------------------------------
-- GAME MECHANICS
---------------------------------------------------------

local function isVisible(targetPart)
    if not WallCheckEnabled then return true end
    if not LocalPlayer.Character then return false end

    local origin = Camera.CFrame.Position
    local destination = targetPart.Position
    local direction = destination - origin

    local params = RaycastParams.new()
    params.FilterType = RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {LocalPlayer.Character, targetPart.Parent}
    params.IgnoreWater = true

    local result = workspace:Raycast(origin, direction, params)
    return result == nil
end

local function getClosestPlayerInWorld()
    local nearest = nil
    local shortest3DDistance = math.huge
    local myChar = LocalPlayer.Character
    local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
    local centerScreen = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    if not myHrp then return nil end

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            local targetHead = player.Character:FindFirstChild("Head") or player.Character:FindFirstChild("HumanoidRootPart")
            local targetHrp = player.Character:FindFirstChild("HumanoidRootPart")
            
            if hum and hum.Health > 0 and targetHead and targetHrp then
                local distance3D = (myHrp.Position - targetHrp.Position).Magnitude
                local screenPosition, onScreen = Camera:WorldToViewportPoint(targetHead.Position)
                
                if onScreen then
                    local screenDist = (Vector2.new(screenPosition.X, screenPosition.Y) - centerScreen).Magnitude
                    local inFov = not FovEnabled or (screenDist <= FovRadius)
                    
                    if inFov and distance3D < shortest3DDistance then
                        if isVisible(targetHead) then
                            shortest3DDistance = distance3D
                            nearest = targetHead
                        end
                    end
                end
            end
        end
    end
    return nearest
end

local function applyESP(player)
    if player == LocalPlayer then return end
    local function highlight(char)
        if not char:FindFirstChild("RedHighlight") then
            local h = Instance.new("Highlight")
            h.Name = "RedHighlight"
            h.FillColor = Color3.fromRGB(255, 0, 0)
            h.OutlineColor = Color3.fromRGB(255, 255, 255)
            h.FillTransparency = 0.4
            h.Parent = char
        end
    end
    player.CharacterAdded:Connect(function(char)
        task.wait(0.5)
        if ESPEnabled then highlight(char) end
    end)
    if player.Character then highlight(player.Character) end
end

for _, p in pairs(Players:GetPlayers()) do applyESP(p) end
Players.PlayerAdded:Connect(applyESP)

RunService:BindToRenderStep("MobileAimbotBypass", Enum.RenderPriority.Camera.Value + 1, function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        hum.WalkSpeed = WalkSpeedValue
        hum.JumpPower = JumpPowerValue
    end

    if AimbotEnabled then
        local targetHead = getClosestPlayerInWorld()
        if targetHead then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetHead.Position)
        end
    end

    for _, player in pairs(Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("RedHighlight") then
            player.Character.RedHighlight.Enabled = ESPEnabled
        end
    end
end)
