local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local Lighting = game:GetService("Lighting")

-- Создаем уведомление при инжекте скрипта
StarterGui:SetCore("SendNotification", {
    Title = "neverlose.cc";
    Text = "successfully injected";
    Icon = "rbxassetid://9182892449"; -- Указываем ID изображения
    Duration = 5; -- Длительность уведомления в секундах
})

-- Создаем ScreenGui
local screenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))

-- Создаем основную панель для функций
local functionPanel = Instance.new("Frame", screenGui)
functionPanel.Size = UDim2.new(0, 120, 0, 200)
functionPanel.Position = UDim2.new(0, 10, 0, 10) -- Начальная позиция
functionPanel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
functionPanel.Visible = false -- Панель изначально скрыта
functionPanel.BackgroundTransparency = 1 -- Полностью прозрачная панель

-- Создаем ImageLabel для установки изображения фона
local backgroundImage = Instance.new("ImageLabel", functionPanel)
backgroundImage.Size = UDim2.new(1, 0, 1, 0) -- Заполняем всю панель
backgroundImage.Image = "rbxassetid://9182892449" -- Устанавливаем изображение
backgroundImage.BackgroundTransparency = 1 -- Делаем фон прозрачным
backgroundImage.ImageTransparency = 0.5 -- Устанавливаем прозрачность изображения

-- Создаем объект Sound для воспроизведения музыки
local music = Instance.new("Sound")
music.SoundId = "rbxassetid://119911947699272" -- Устанавливаем ID вашей музыки
music.Volume = 0.5 -- Устанавливаем громкость (от 0 до 1)
music.Parent = functionPanel -- Привязываем звук к панели, чтобы он не удалялся
music:Play() -- Проигрываем музыку один раз при внедрении скрипта

-- Создаем объект Sound для проигрывания звука при нажатии кей бinda
local espSound = Instance.new("Sound")
espSound.SoundId = "rbxassetid://17779566040" -- Устанавливаем ID звука
espSound.Volume = 0.5 -- Устанавливаем громкость звука
espSound.Parent = functionPanel -- Привязываем звук к панели

-- Переменные для перетаскивания
local dragging = false
local dragStart = nil
local startPos = nil

-- Функция для начала перетаскивания
functionPanel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = functionPanel.Position
    end
end)

-- Функция для перетаскивания
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        functionPanel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Функция для завершения перетаскивания
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Таблица для хранения BillboardGui для каждого игрока
local playerGuis = {}
local displayESP = false -- Флаг для отображения ESP
local textColor = Color3.new(1, 1, 1) -- Цвет текста по умолчанию (белый)
local textTransparency = 0.2 -- Прозрачность текста по умолчанию (80%)
local espKey = Enum.KeyCode.E -- Начальный кей бинд для ESP
local fullbrightEnabled = false -- Флаг для Fullbright

-- Функция для обновления информации о игроках (ESP)
local function updateESP()
    if not displayESP then 
        -- Удаляем BillboardGui, если отображение отключено
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
                -- Если BillboardGui не существует, создаем его
                if not playerGuis[player] then
                    local playerInfo = Instance.new("BillboardGui")
                    playerInfo.Size = UDim2.new(0, 200, 0, 20) -- Уменьшаем высоту
                    playerInfo.StudsOffset = Vector3.new(0, 5, 0) -- Перемещаем выше головы
                    playerInfo.Adornee = head
                    playerInfo.AlwaysOnTop = true

                    local textLabel = Instance.new("TextLabel", playerInfo)
                    textLabel.Size = UDim2.new(1, 0, 1, 0)
                    textLabel.BackgroundTransparency = 1
                    textLabel.TextColor3 = textColor
                    textLabel.TextStrokeTransparency = 0.5
                    textLabel.TextTransparency = textTransparency -- Установка прозрачности текста
                    playerInfo.Parent = head
                    playerGuis[player] = playerInfo
                end

                -- Обновляем текст
                local distance = (head.Position - Camera.CFrame.Position).Magnitude
                local currentHealth = humanoid.Health
                local maxHealth = humanoid.MaxHealth
                local sPlusText = ""

                -- Условие для отображения "maybe S+" только для игроков с maxHealth > 1600
                if maxHealth > 1600 then
                    sPlusText = " maybe S+"
                    playerGuis[player].TextLabel.TextColor3 = Color3.fromRGB(255, 0, 0) -- Красный цвет для текста
                else
                    playerGuis[player].TextLabel.TextColor3 = textColor -- Основной цвет текста
                end

                -- Используем никнейм игрока из таблицы
                local playerName = player.DisplayName or player.Name
                playerGuis[player].TextLabel.Text = string.format("%s%s\nDis: %.2f\nHP: %d/%d", playerName, sPlusText, distance, currentHealth, maxHealth)

                -- Динамическое изменение высоты текста в зависимости от расстояния
                local dynamicTextHeight = math.clamp(1000 / distance, 10, 20) -- Максимум 20, минимум 10
                playerGuis[player].Size = UDim2.new(0, 200, 0, dynamicTextHeight)
                playerGuis[player].TextLabel.Size = UDim2.new(1, 0, 1, 0)
                playerGuis[player].TextLabel.TextTransparency = textTransparency -- Установка прозрачности текста
            end
        end
    end
end

-- Создаем чекбокс для включения/выключения отображения ESP
local espCheckbox = Instance.new("TextButton", functionPanel)
espCheckbox.Size = UDim2.new(1, 0, 0, 30)
espCheckbox.Position = UDim2.new(0, 0, 0, 10)
espCheckbox.Text = "ESP: Off"
espCheckbox.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
espCheckbox.TextColor3 = Color3.new(1, 1, 1)
espCheckbox.TextStrokeTransparency = 0.5

-- Обработчик нажатия на чекбокс для включения/выключения отображения ESP
espCheckbox.MouseButton1Click:Connect(function()
    displayESP = not displayESP
    espCheckbox.Text = displayESP and "ESP: On" or "ESP: Off"
    espCheckbox.BackgroundColor3 = displayESP and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
    if not displayESP then
        -- Удаляем все BillboardGui, если отображение отключено
        for player, gui in pairs(playerGuis) do
            if gui then
                gui:Destroy()
                playerGuis[player] = nil
            end
        end
    end
end)

-- Создаем кнопку для установки нового кей бинда
local bindButton = Instance.new("TextButton", functionPanel)
bindButton.Size = UDim2.new(1, 0, 0, 30)
bindButton.Position = UDim2.new(0, 0, 0, 50)
bindButton.Text = "Set Key Bind"
bindButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
bindButton.TextColor3 = Color3.new(1, 1, 1)
bindButton.TextStrokeTransparency = 0.5

-- Переменная для ожидания нажатия клавиши
local waitingForKey = false

-- Обработчик нажатия на кнопку для установки нового кей бинда
bindButton.MouseButton1Click:Connect(function()
    waitingForKey = true
    bindButton.Text = "Press any key..."
end)

-- Обработчик нажатия клавиши для изменения бинда
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if not gameProcessedEvent and waitingForKey then
        espKey = input.KeyCode
        bindButton.Text = "Key set: " .. espKey.Name
        waitingForKey = false
    elseif not gameProcessedEvent and input.KeyCode == espKey then
        displayESP = not displayESP
        espCheckbox.Text = displayESP and "ESP: On" or "ESP: Off"
        espCheckbox.BackgroundColor3 = displayESP and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
        
        -- Воспроизводим звук при нажатии на кей бинд
        espSound:Play()

        if not displayESP then
            -- Удаляем все BillboardGui, если отображение отключено
            for player, gui in pairs(playerGuis) do
                if gui then
                    gui:Destroy()
                    playerGuis[player] = nil
                end
            end
        end
    elseif not gameProcessedEvent and input.KeyCode == Enum.KeyCode.Insert then
        -- Переключение видимости панели при нажатии клавиши Insert
        functionPanel.Visible = not functionPanel.Visible
        
        -- Анимация появления/исчезновения панели
        if functionPanel.Visible then
            functionPanel.BackgroundTransparency = 1 -- Устанавливаем начальную прозрачность
            functionPanel:TweenSize(UDim2.new(0, 120, 0, 200), "Out", "Quad", 0.5, true) -- Плавное появление
            functionPanel:TweenTransparency(0, "Out", "Quad", 0.5, true) -- Плавное изменение прозрачности
        else
            functionPanel:TweenTransparency(1, "In", "Quad", 0.5, true) -- Плавное исчезновение
            functionPanel:TweenSize(UDim2.new(0, 120, 0, 0), "In", "Quad", 0.5, true) -- Плавное уменьшение размера
        end
    end
end)

-- Создаем кнопку для включения/выключения Fullbright
local fullbrightButton = Instance.new("TextButton", functionPanel)
fullbrightButton.Size = UDim2.new(1, 0, 0, 30)
fullbrightButton.Position = UDim2.new(0, 0, 0, 90)
fullbrightButton.Text = "Fullbright: Off"
fullbrightButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
fullbrightButton.TextColor3 = Color3.new(1, 1, 1)
fullbrightButton.TextStrokeTransparency = 0.5

-- Обработчик нажатия на кнопку для включения/выключения Fullbright
fullbrightButton.MouseButton1Click:Connect(function()
    fullbrightEnabled = not fullbrightEnabled
    fullbrightButton.Text = fullbrightEnabled and "Fullbright: On" or "Fullbright: Off"
    fullbrightButton.BackgroundColor3 = fullbrightEnabled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)

    if fullbrightEnabled then
        -- Устанавливаем параметры освещения для Fullbright
        Lighting.Brightness = 2 -- Увеличиваем яркость
        Lighting.OutdoorAmbient = Color3.new(1, 1, 1) -- Устанавливаем цвет освещения
        Lighting.Ambient = Color3.new(1, 1, 1) -- Устанавливаем цвет окружения
    else
        -- Возвращаем параметры освещения к нормальным значениям
        Lighting.Brightness = 1 -- Устанавливаем стандартную яркость
        Lighting.OutdoorAmbient = Color3.new(0.5, 0.5, 0.5) -- Возвращаем цвет освещения
        Lighting.Ambient = Color3.new(0.5, 0.5, 0.5) -- Возвращаем цвет окружения
    end
end)

-- Основной цикл
while true do
    wait(0.1) -- Задержка для оптимизации
    updateESP() -- Обновляем информацию о игроках (ESP)
end
