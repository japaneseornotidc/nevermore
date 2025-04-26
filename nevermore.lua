local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local Lighting = game:GetService("Lighting")

StarterGui:SetCore("SendNotification", {
    Title = "neverlose.cc";
    Text = "successfully injected";
    Icon = "rbxassetid://9182892449";
    Duration = 5;
})

local screenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))

local functionPanel = Instance.new("Frame", screenGui)
functionPanel.Size = UDim2.new(0, 120, 0, 200)
functionPanel.Position = UDim2.new(0, 10, 0, 10)
functionPanel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
functionPanel.Visible = false
functionPanel.BackgroundTransparency = 1

local backgroundImage = Instance.new("ImageLabel", functionPanel)
backgroundImage.Size = UDim2.new(1, 0, 1, 0)
backgroundImage.Image = "rbxassetid://9182892449"
backgroundImage.BackgroundTransparency = 1
backgroundImage.ImageTransparency = 0.5

local music = Instance.new("Sound")
music.SoundId = "rbxassetid://119911947699272"
music.Volume = 0.5
music.Parent = functionPanel
music:Play()

local espSound = Instance.new("Sound")
espSound.SoundId = "rbxassetid://17779566040"
espSound.Volume = 0.5
espSound.Parent = functionPanel

local dragging = false
local dragStart = nil
local startPos = nil

functionPanel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = functionPanel.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        functionPanel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

local playerGuis = {}
local displayESP = false
local textColor = Color3.new(1, 1, 1)
local textTransparency = 0.2
local espKey = Enum.KeyCode.E
local fullbrightEnabled = false

local function updateESP()
    if not displayESP then 
        for player, gui in pairs(playerGuis) do
            if gui then
                gui:Destroy()
                playerGuis[player] = nil
            end
        end
        return 
    end

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local head = player.Character:FindFirstChild("Head")
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")

            if head and humanoid then
                if not playerGuis[player] then
                    local playerInfo = Instance.new("BillboardGui")
                    playerInfo.Size = UDim2.new(0, 200, 0, 20)
                    playerInfo.StudsOffset = Vector3.new(0, 5, 0)
                    playerInfo.Adornee = head
                    playerInfo.AlwaysOnTop = true

                    local textLabel = Instance.new("TextLabel", playerInfo)
                    textLabel.Size = UDim2.new(1, 0, 1, 0)
                    textLabel.BackgroundTransparency = 1
                    textLabel.TextColor3 = textColor
                    textLabel.TextStrokeTransparency = 0.5
                    textLabel.TextTransparency = textTransparency
                    playerInfo.Parent = head
                    playerGuis[player] = playerInfo
                end

                local distance = (head.Position - Camera.CFrame.Position).Magnitude
                local currentHealth = humanoid.Health
                local maxHealth = humanoid.MaxHealth
                local sPlusText = ""

                if maxHealth > 1600 then
                    sPlusText = " maybe S+"
                    playerGuis[player].TextLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                else
                    playerGuis[player].TextLabel.TextColor3 = textColor
                end

                local playerName = player.DisplayName or player.Name
                playerGuis[player].TextLabel.Text = string.format("%s%s\nDis: %.2f\nHP: %d/%d", playerName, sPlusText, distance, currentHealth, maxHealth)

                local dynamicTextHeight = math.clamp(1000 / distance, 10, 20)
                playerGuis[player].Size = UDim2.new(0, 200, 0, dynamicTextHeight)
                playerGuis[player].TextLabel.Size = UDim2.new(1, 0, 1, 0)
                playerGuis[player].TextLabel.TextTransparency = textTransparency
            end
        end
    end
end

local espCheckbox = Instance.new("TextButton", functionPanel)
espCheckbox.Size = UDim2.new(1, 0, 0, 30)
espCheckbox.Position = UDim2.new(0, 0, 0, 10)
espCheckbox.Text = "ESP: Off"
espCheckbox.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
espCheckbox.TextColor3 = Color3.new(1, 1, 1)
espCheckbox.TextStrokeTransparency = 0.5

espCheckbox.MouseButton1Click:Connect(function()
    displayESP = not displayESP
    espCheckbox.Text = displayESP and "ESP: On" or "ESP: Off"
    espCheckbox.BackgroundColor3 = displayESP and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
    if not displayESP then
        for player, gui in pairs(playerGuis) do
            if gui then
                gui:Destroy()
                playerGuis[player] = nil
            end
        end
    end
end)

local bindButton = Instance.new("TextButton", functionPanel)
bindButton.Size = UDim2.new(1, 0, 0, 30)
bindButton.Position = UDim2.new(0, 0, 0, 50)
bindButton.Text = "Set Key Bind"
bindButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
bindButton.TextColor3 = Color3.new(1, 1, 1)
bindButton.TextStrokeTransparency = 0.5

local waitingForKey = false

bindButton.MouseButton1Click:Connect(function()
    waitingForKey = true
    bindButton.Text = "Press any key..."
end)

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if not gameProcessedEvent and waitingForKey then
        espKey = input.KeyCode
        bindButton.Text = "Key set: " .. espKey.Name
        waitingForKey = false
    elseif not gameProcessedEvent and input.KeyCode == espKey then
        displayESP = not displayESP
        espCheckbox.Text = displayESP and "ESP: On" or "ESP: Off"
        espCheckbox.BackgroundColor3 = displayESP and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
        espSound:Play()

        if not displayESP then
            for player, gui in pairs(playerGuis) do
                if gui then
                    gui:Destroy()
                    playerGuis[player] = nil
                end
            end
        end
    elseif not gameProcessedEvent and input.KeyCode == Enum.KeyCode.Insert then
        functionPanel.Visible = not functionPanel.Visible
        
        if functionPanel.Visible then
            functionPanel.BackgroundTransparency = 1
            functionPanel:TweenSize(UDim2.new(0, 120, 0, 200), "Out", "Quad", 0.5, true)
            functionPanel:TweenTransparency(0, "Out", "Quad", 0.5, true)
        else
            functionPanel:TweenTransparency(1, "In", "Quad", 0.5, true)
            functionPanel:TweenSize(UDim2.new(0, 120, 0, 0), "In", "Quad", 0.5, true)
        end
    end
end)

local fullbrightButton = Instance.new("TextButton", functionPanel)
fullbrightButton.Size = UDim2.new(1, 0, 0, 30)
fullbrightButton.Position = UDim2.new(0, 0, 0, 90)
fullbrightButton.Text = "Fullbright: Off"
fullbrightButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
fullbrightButton.TextColor3 = Color3.new(1, 1, 1)
fullbrightButton.TextStrokeTransparency = 0.5

fullbrightButton.MouseButton1Click:Connect(function()
    fullbrightEnabled = not fullbrightEnabled
    fullbrightButton.Text = fullbrightEnabled and "Fullbright: On" or "Fullbright: Off"
    fullbrightButton.BackgroundColor3 = fullbrightEnabled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)

    if fullbrightEnabled then
        Lighting.Brightness = 2
        Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        Lighting.Ambient = Color3.new(1, 1, 1)
    else
        Lighting.Brightness = 1
        Lighting.OutdoorAmbient = Color3.new(0.5, 0.5, 0.5)
        Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
    end
end)

while true do
    wait(0.1)
    updateESP()
end
