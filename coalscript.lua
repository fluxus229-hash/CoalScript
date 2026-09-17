-- Modern GUI: Coal Hub
local AimbotEnabled = false
local FovEnabled = false
local FovRadius = 150
local WallCheckEnabled = false
local ESPEnabled = false
local WalkSpeedValue = 16
local JumpPowerValue = 50
local AimBtnGuiVisible = false

-- Main Tab States
local NoclipEnabled = false
local FlyEnabled = false
local FlySpeedValue = 50
local InfJumpEnabled = false

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
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

-- Floating AIM Button
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
QuickAimBtn.Visible = false
QuickAimBtn.Parent = ScreenGui

local QuickAimCorner = Instance.new("UICorner")
QuickAimCorner.CornerRadius = UDim.new(0, 14)
QuickAimCorner.Parent = QuickAimBtn

local QuickAimStroke = Instance.new("UIStroke")
QuickAimStroke.Color = Color3.fromRGB(255, 255, 255)
QuickAimStroke.Transparency = 0.5
QuickAimStroke.Thickness = 2
QuickAimStroke.Parent = QuickAimBtn

-- Mini Open Button
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
TitleText.TextColor3 = Color3.fromRGB(0, 170, 255)
TitleText.TextSize = 16
TitleText.Font = Enum.Font.GothamBold
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.GothamBold
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
    page.ScrollBarImageColor3 = Color3.fromRGB(0, 170, 255)
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
local CombatPage = createPage()
local VisualsPage = createPage()
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
        CombatPage.Visible = false
        VisualsPage.Visible = false
        page.Visible = true
        
        for _, child in ipairs(Sidebar:GetChildren()) do
            if child:IsA("TextButton") then
                child.BackgroundColor3 = Color3.fromRGB(28, 32, 45)
                child.TextColor3 = Color3.fromRGB(180, 180, 180)
            end
        end
        btn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    return btn
end

local MainTabBtn = createTabBtn("Main", MainPage)
local CombatTabBtn = createTabBtn("Combat", CombatPage)
local VisualsTabBtn = createTabBtn("Visuals", VisualsPage)

MainTabBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
MainTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

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
    toggleBtn.BackgroundColor3 = defaultState and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(45, 50, 65)
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
        local targetColor = state and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(45, 50, 65)
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
    valLabel.TextColor3 = Color3.fromRGB(0, 170, 255)
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
    sliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
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

-- POPULATE TAB: Main
createSlider(MainPage, "Скорость бега", 1, 300, WalkSpeedValue, function(v)
    WalkSpeedValue = v
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = v
    end
end)

createSlider(MainPage, "Высота прыжка", 1, 300, JumpPowerValue, function(v)
    JumpPowerValue = v
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = v
        LocalPlayer.Character.Humanoid.UseJumpPower = true
    end
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

createToggle(CombatPage, "Проверка стен (WallCheck)", false, function(v)
    WallCheckEnabled = v
end)

createToggle(CombatPage, "Кнопка AIM на экране", false, function(v)
    AimBtnGuiVisible = v
    QuickAimBtn.Visible = v
end)

-- POPULATE TAB: Visuals
createToggle(VisualsPage, "Включить ESP (Подсветка)", false, function(v)
    ESPEnabled = v
end)

-- Window Smooth Animations
local isMenuOpen = true

local function hideMenu()
    if not isMenuOpen then return end
    isMenuOpen = false
    
    MiniSquare.Visible = true
    
    local tweenMain = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        GroupTransparency = 1,
        Size = UDim2.new(0, 480, 0, 300)
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
        Size = UDim2.new(0, 520, 0, 340)
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

-- Infinite Jump Key Handler
UserInputService.JumpRequest:Connect(function()
    if InfJumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- Aimbot Mechanics
local isAiming = false

QuickAimBtn.MouseButton1Down:Connect(function() isAiming = true end)
QuickAimBtn.MouseButton1Up:Connect(function() isAiming = false end)
QuickAimBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isAiming = false
    end
end)

local function isVisible(targetPart)
    if not WallCheckEnabled then return true end
    local origin = Camera.CFrame.Position
    local ray = Ray.new(origin, targetPart.Position - origin)
    local hit = workspace:FindPartOnWithIgnoreList(ray, {LocalPlayer.Character})
    return hit and hit:IsDescendantOf(targetPart.Parent)
end

local function getClosestPlayer()
    local closest = nil
    local shortestDistance = FovRadius

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local pos, onScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
            if onScreen then
                local mousePos = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                local dist = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                if dist < shortestDistance then
                    if isVisible(player.Character.HumanoidRootPart) then
                        shortestDistance = dist
                        closest = player.Character.HumanoidRootPart
                    end
                end
            end
        end
    end
    return closest
end

-- Fly Objects
local flyBV = nil
local flyBG = nil

-- Main Loops
RunService.RenderStepped:Connect(function()
    -- Speed & Jump Power
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = WalkSpeedValue
        LocalPlayer.Character.Humanoid.JumpPower = JumpPowerValue
        LocalPlayer.Character.Humanoid.UseJumpPower = true
    end

    -- Aimbot
    if AimbotEnabled and isAiming then
        local target = getClosestPlayer()
        if target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
        end
    end

    -- ESP Visuals
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local highlight = player.Character:FindFirstChild("CoalESP")
            if ESPEnabled then
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "CoalESP"
                    highlight.FillColor = Color3.fromRGB(255, 50, 50)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.FillTransparency = 0.5
                    highlight.Parent = player.Character
                end
            else
                if highlight then
                    highlight:Destroy()
                end
            end
        end
    end

    -- Noclip Logic
    if NoclipEnabled and LocalPlayer.Character then
        local char = LocalPlayer.Character
        local rayOrigin = char.PrimaryPart and char.PrimaryPart.Position or Vector3.new(0,0,0)
        
        local ray = Ray.new(rayOrigin, Vector3.new(0, -3.5, 0))
        local floorPart = workspace:FindPartOnWithIgnoreList(ray, {char})

        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                if FlyEnabled then
                    part.CanCollide = false
                elseif floorPart and (part.Name == "HumanoidRootPart" or part.Name == "LowerTorso") then
                    part.CanCollide = true
                else
                    part.CanCollide = false
                end
            end
        end
    end

    -- Fly Logic (Keyboard WASD + Space/Shift + Camera Dir)
    if FlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        
        if not flyBV then
            flyBV = Instance.new("BodyVelocity")
            flyBV.MaxForce = Vector3.new(1e9, 1e9, 1e9)
            flyBV.Parent = hrp
        end

        if not flyBG then
            flyBG = Instance.new("BodyGyro")
            flyBG.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
            flyBG.P = 9e4
            flyBG.Parent = hrp
        end

        flyBG.CFrame = Camera.CFrame

        local moveDir = Vector3.new(0, 0, 0)
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDir = moveDir + Camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDir = moveDir - Camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDir = moveDir - Camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDir = moveDir + Camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) or UserInputService:IsKeyDown(Enum.KeyCode.E) then
            moveDir = moveDir + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.Q) then
            moveDir = moveDir - Vector3.new(0, 1, 0)
        end

        if moveDir.Magnitude > 0 then
            flyBV.Velocity = moveDir.Unit * FlySpeedValue
        else
            flyBV.Velocity = Vector3.new(0, 0, 0)
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
