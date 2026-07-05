local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")

local targetPlayer = nil
local isAiming = false
local highlight = Instance.new("Highlight")

-- GUI Setup
local screenGui = Instance.new("ScreenGui", game.CoreGui)
local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 400, 0, 250)
frame.Position = UDim2.new(0.5, -200, 0.5, -125)
frame.Draggable = true
frame.Active = true
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

-- Buttons
local hideButton = Instance.new("TextButton", frame)
hideButton.Size = UDim2.new(0, 30, 0, 30)
hideButton.Position = UDim2.new(1, -30, 0, 0)
hideButton.Text = "—"

local openButton = Instance.new("TextButton", screenGui)
openButton.Size = UDim2.new(0, 50, 0, 50)
openButton.Position = UDim2.new(0, 10, 0, 10)
openButton.Text = "†"
openButton.Visible = false
openButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
openButton.TextColor3 = Color3.new(1, 1, 1)

-- Hiding Logic
hideButton.MouseButton1Click:Connect(function() frame.Visible = false; openButton.Visible = true end)
openButton.MouseButton1Click:Connect(function() frame.Visible = true; openButton.Visible = false end)

-- Slider Function
local function createSlider(yPos, name, min, max, callback)
    local sliderBg = Instance.new("Frame", frame)
    sliderBg.Size = UDim2.new(0.9, 0, 0, 30)
    sliderBg.Position = UDim2.new(0.05, 0, 0, yPos)
    sliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    
    local fill = Instance.new("Frame", sliderBg)
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    
    local btn = Instance.new("TextButton", sliderBg)
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = name
    
    btn.MouseButton1Down:Connect(function()
        local connection
        connection = runService.RenderStepped:Connect(function()
            local mousePos = userInputService:GetMouseLocation().X
            local relX = math.clamp((mousePos - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
            fill.Size = UDim2.new(relX, 0, 1, 0)
            callback(min + (max - min) * relX)
            if not userInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                connection:Disconnect()
            end
        end)
    end)
end

-- Controls
createSlider(150, "Speed (16-300)", 16, 300, function(v) player.Character.Humanoid.WalkSpeed = v end)
createSlider(190, "Jump (50-300)", 50, 300, function(v) player.Character.Humanoid.JumpPower = v end)

local aimButton = Instance.new("TextButton", frame)
aimButton.Size = UDim2.new(0.4, 0, 0, 40)
aimButton.Position = UDim2.new(0.05, 0, 0, 20)
aimButton.Text = "Toggle Aim"

local playerList = Instance.new("ScrollingFrame", frame)
playerList.Size = UDim2.new(0.5, 0, 0, 100)
playerList.Position = UDim2.new(0.47, 0, 0, 20)

local function refreshPlayerList()
    for _, child in pairs(playerList:GetChildren()) do if child:IsA("TextButton") then child:Destroy() end end
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= player then
            local btn = Instance.new("TextButton", playerList)
            btn.Size = UDim2.new(1, -5, 0, 25)
            btn.Position = UDim2.new(0, 0, 0, (#playerList:GetChildren()) * 25)
            btn.Text = p.Name
            btn.MouseButton1Click:Connect(function()
                targetPlayer = p
                highlight.Parent = p.Character
            end)
        end
    end
end

runService.RenderStepped:Connect(function()
    if isAiming and targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Head") then
        camera.CFrame = camera.CFrame:Lerp(CFrame.lookAt(camera.CFrame.Position, targetPlayer.Character.Head.Position), 0.6)
    end
end)

aimButton.MouseButton1Click:Connect(function() isAiming = not isAiming end)
refreshPlayerList()
game.Players.PlayerAdded:Connect(refreshPlayerList)
game.Players.PlayerRemoving:Connect(refreshPlayerList)
