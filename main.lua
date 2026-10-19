local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local COLORS = {
    bg = Color3.fromRGB(25, 25, 30),
    card = Color3.fromRGB(40, 40, 48),
    text = Color3.fromRGB(255, 255, 255),
    red = Color3.fromRGB(255, 70, 70),
    blue = Color3.fromRGB(70, 150, 255),
    button = Color3.fromRGB(60, 60, 75),
    buttonHover = Color3.fromRGB(80, 80, 100),
    registered = Color3.fromRGB(40, 120, 40),
    accent = Color3.fromRGB(0, 170, 255)
}

local function makeDraggable(guiObject)
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        guiObject.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
    guiObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = guiObject.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    guiObject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Luncher_UI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.IgnoreGuiInset = true
screenGui.Parent = PlayerGui

local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Parent = screenGui
toggleButton.Size = UDim2.new(0, 36, 0, 36)
toggleButton.Position = UDim2.new(1, -46, 0, 15)
toggleButton.BackgroundColor3 = COLORS.accent
toggleButton.BorderSizePixel = 0
toggleButton.Text = "☰"
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.TextScaled = true
toggleButton.Font = Enum.Font.GothamBold
toggleButton.ZIndex = 10

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(1, 0)
toggleCorner.Parent = toggleButton

makeDraggable(toggleButton)

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Parent = screenGui
mainFrame.Size = UDim2.new(0, 220, 0, 240)
mainFrame.Position = UDim2.new(0.5, -110, 0.5, -120)
mainFrame.BackgroundColor3 = COLORS.bg
mainFrame.BorderSizePixel = 0
mainFrame.Visible = true
mainFrame.Active = true
makeDraggable(mainFrame)

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = COLORS.accent
mainStroke.Thickness = 1
mainStroke.Transparency = 0.5
mainStroke.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Parent = mainFrame
titleLabel.Size = UDim2.new(1, 0, 0, 20)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "صنع لانشر"
titleLabel.TextColor3 = COLORS.text
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.ZIndex = 2

local gridFrame = Instance.new("Frame")
gridFrame.Name = "GridFrame"
gridFrame.Parent = mainFrame
gridFrame.Size = UDim2.new(1, -6, 1, -26)
gridFrame.Position = UDim2.new(0, 3, 0, 22)
gridFrame.BackgroundTransparency = 1

local gridLayout = Instance.new("UIGridLayout")
gridLayout.Parent = gridFrame
gridLayout.CellSize = UDim2.new(0.5, -2, 0.5, -2)
gridLayout.CellPadding = UDim2.new(0, 4, 0, 4)
gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
gridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
gridLayout.VerticalAlignment = Enum.VerticalAlignment.Center

local cards = {}

local function fetchThumb(userId)
    local ok, content = pcall(function()
        return Players:GetUserThumbnailAsync(userId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
    end)
    if ok and content then
        return content
    end
    return "rbxthumb://type=AvatarHeadShot&id=" .. userId .. "&w=100&h=100"
end

local function createCard(index)
    local card = Instance.new("Frame")
    card.Name = "Card_" .. index
    card.Parent = gridFrame
    card.BackgroundColor3 = COLORS.card
    card.BorderSizePixel = 0
    card.LayoutOrder = index

    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 5)
    cardCorner.Parent = card

    local cardPadding = Instance.new("UIPadding")
    cardPadding.PaddingTop = UDim.new(0, 3)
    cardPadding.PaddingBottom = UDim.new(0, 3)
    cardPadding.PaddingLeft = UDim.new(0, 3)
    cardPadding.PaddingRight = UDim.new(0, 3)
    cardPadding.Parent = card

    local cardLayout = Instance.new("UIListLayout")
    cardLayout.Parent = card
    cardLayout.SortOrder = Enum.SortOrder.LayoutOrder
    cardLayout.Padding = UDim.new(0, 2)

    local textBox = Instance.new("TextBox")
    textBox.Name = "InputBox"
    textBox.Parent = card
    textBox.Size = UDim2.new(1, 0, 0, 18)
    textBox.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
    textBox.BorderSizePixel = 0
    textBox.PlaceholderText = "3 أحرف"
    textBox.Text = ""
    textBox.TextColor3 = COLORS.text
    textBox.PlaceholderColor3 = Color3.fromRGB(160, 160, 170)
    textBox.TextScaled = true
    textBox.Font = Enum.Font.Gotham
    textBox.ClearTextOnFocus = false
    textBox.ZIndex = 2

    local tbCorner = Instance.new("UICorner")
    tbCorner.CornerRadius = UDim.new(0, 3)
    tbCorner.Parent = textBox

    local goButton = Instance.new("TextButton")
    goButton.Name = "GoButton"
    goButton.Parent = card
    goButton.Size = UDim2.new(1, 0, 0, 16)
    goButton.BackgroundColor3 = COLORS.button
    goButton.BorderSizePixel = 0
    goButton.Text = "هيا بنا!"
    goButton.TextColor3 = COLORS.text
    goButton.TextScaled = true
    goButton.Font = Enum.Font.GothamBold
    goButton.ZIndex = 2

    local goCorner = Instance.new("UICorner")
    goCorner.CornerRadius = UDim.new(0, 3)
    goCorner.Parent = goButton

    local resultFrame = Instance.new("Frame")
    resultFrame.Name = "ResultFrame"
    resultFrame.Parent = card
    resultFrame.Size = UDim2.new(1, 0, 0, 0)
    resultFrame.BackgroundTransparency = 1
    resultFrame.Visible = false
    resultFrame.ZIndex = 1

    local resultLayout = Instance.new("UIListLayout")
    resultLayout.Parent = resultFrame
    resultLayout.SortOrder = Enum.SortOrder.LayoutOrder
    resultLayout.Padding = UDim.new(0, 0)

    local avatarImage = Instance.new("ImageLabel")
    avatarImage.Name = "AvatarImage"
    avatarImage.Parent = resultFrame
    avatarImage.Size = UDim2.new(0, 26, 0, 26)
    avatarImage.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
    avatarImage.BorderSizePixel = 0
    avatarImage.Image = ""
    avatarImage.ZIndex = 2

    local avCorner = Instance.new("UICorner")
    avCorner.CornerRadius = UDim.new(1, 0)
    avCorner.Parent = avatarImage

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "NameLabel"
    nameLabel.Parent = resultFrame
    nameLabel.Size = UDim2.new(1, 0, 0, 11)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = ""
    nameLabel.TextColor3 = COLORS.text
    nameLabel.TextScaled = true
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.ZIndex = 2

    local timerLabel = Instance.new("TextLabel")
    timerLabel.Name = "TimerLabel"
    timerLabel.Parent = resultFrame
    timerLabel.Size = UDim2.new(1, 0, 0, 11)
    timerLabel.BackgroundTransparency = 1
    timerLabel.Text = "00:00"
    timerLabel.TextColor3 = Color3.new(1, 1, 1)
    timerLabel.TextScaled = true
    timerLabel.Font = Enum.Font.GothamBold
    timerLabel.ZIndex = 2

    local leaveLabel = Instance.new("TextLabel")
    leaveLabel.Name = "LeaveLabel"
    leaveLabel.Parent = resultFrame
    leaveLabel.Size = UDim2.new(1, 0, 0, 9)
    leaveLabel.BackgroundTransparency = 1
    leaveLabel.Text = "خروج: 0"
    leaveLabel.TextColor3 = COLORS.red
    leaveLabel.TextScaled = true
    leaveLabel.Font = Enum.Font.Gotham
    leaveLabel.ZIndex = 2

    local joinLabel = Instance.new("TextLabel")
    joinLabel.Name = "JoinLabel"
    joinLabel.Parent = resultFrame
    joinLabel.Size = UDim2.new(1, 0, 0, 9)
    joinLabel.BackgroundTransparency = 1
    joinLabel.Text = "دخول: 0"
    joinLabel.TextColor3 = COLORS.blue
    joinLabel.TextScaled = true
    joinLabel.Font = Enum.Font.Gotham
    joinLabel.ZIndex = 2

    local cardData = {
        cardFrame = card,
        textBox = textBox,
        goButton = goButton,
        resultFrame = resultFrame,
        avatarImage = avatarImage,
        nameLabel = nameLabel,
        timerLabel = timerLabel,
        leaveLabel = leaveLabel,
        joinLabel = joinLabel,
        userId = nil,
        isTracking = false,
        isRegistered = false,
        startTime = 0,
        accumulatedTime = 0,
        leaveCount = 0,
        joinCount = 0
    }

    cards[index] = cardData

    local function resetForNewPlayer(plr)
        cardData.userId = plr.UserId
        cardData.isTracking = true
        cardData.startTime = os.time()
        cardData.accumulatedTime = 0
        cardData.leaveCount = 0
        cardData.joinCount = 0

        resultFrame.Visible = true
        avatarImage.Image = fetchThumb(plr.UserId)
        nameLabel.Text = plr.Name
        timerLabel.Text = "00:00"
        leaveLabel.Text = "خروج: 0"
        joinLabel.Text = "دخول: 0"
    end

    local function clearCard()
        cardData.userId = nil
        cardData.isTracking = false
        cardData.accumulatedTime = 0
        cardData.leaveCount = 0
        cardData.joinCount = 0
        resultFrame.Visible = false
        avatarImage.Image = ""
        nameLabel.Text = ""
        timerLabel.Text = "00:00"
        leaveLabel.Text = "خروج: 0"
        joinLabel.Text = "دخول: 0"
    end

    textBox:GetPropertyChangedSignal("Text"):Connect(function()
        if cardData.isRegistered then return end

        local text = textBox.Text
        if #text < 3 then
            clearCard()
            return
        end

        local prefix = string.sub(text, 1, 3):lower()
        local foundPlayer = nil
        for _, plr in ipairs(Players:GetPlayers()) do
            if string.sub(plr.Name, 1, 3):lower() == prefix then
                foundPlayer = plr
                break
            end
        end

        if foundPlayer then
            if cardData.userId == foundPlayer.UserId then
                return
            end
            resetForNewPlayer(foundPlayer)
        else
            clearCard()
        end
    end)

    goButton.MouseButton1Click:Connect(function()
        if cardData.isRegistered then return end
        if not cardData.userId then
            local originalColor = goButton.BackgroundColor3
            goButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            task.wait(0.2)
            goButton.BackgroundColor3 = originalColor
            return
        end

        cardData.isRegistered = true
        textBox.TextEditable = false
        textBox.BackgroundColor3 = Color3.fromRGB(40, 60, 40)
        goButton.Text = "✓ مسجل"
        goButton.BackgroundColor3 = COLORS.registered
    end)

    goButton.MouseEnter:Connect(function()
        if cardData.isRegistered then return end
        TweenService:Create(goButton, TweenInfo.new(0.15), {
            BackgroundColor3 = COLORS.buttonHover
        }):Play()
    end)
    goButton.MouseLeave:Connect(function()
        if cardData.isRegistered then return end
        TweenService:Create(goButton, TweenInfo.new(0.15), {
            BackgroundColor3 = COLORS.button
        }):Play()
    end)

    return cardData
end

for i = 1, 4 do
    createCard(i)
end

toggleButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

Players.PlayerRemoving:Connect(function(player)
    for _, data in pairs(cards) do
        if data.userId == player.UserId and data.isTracking then
            data.isTracking = false
            data.accumulatedTime = data.accumulatedTime + (os.time() - data.startTime)
            data.leaveCount = data.leaveCount + 1
            data.leaveLabel.Text = "خروج: " .. data.leaveCount
        end
    end
end)

Players.PlayerAdded:Connect(function(player)
    for _, data in pairs(cards) do
        if data.userId == player.UserId and not data.isTracking and data.leaveCount > 0 then
            data.joinCount = data.joinCount + 1
            data.joinLabel.Text = "دخول: " .. data.joinCount
            data.startTime = os.time()
            data.isTracking = true
            data.avatarImage.Image = fetchThumb(player.UserId)
            data.nameLabel.Text = player.Name
        end
    end
end)

RunService.Heartbeat:Connect(function()
    for _, data in pairs(cards) do
        if data.isTracking then
            local elapsed = data.accumulatedTime + (os.time() - data.startTime)
            local minutes = math.floor(elapsed / 60)
            local seconds = elapsed % 60
            data.timerLabel.Text = string.format("%02d:%02d", minutes, seconds)
        end
    end
end)
