herelocal Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local old = PlayerGui:FindFirstChild("Luncher_UI")
if old then old:Destroy() end

local COLORS = {
    bg = Color3.fromRGB(0, 0, 0),
    card = Color3.fromRGB(20, 20, 20),
    text = Color3.fromRGB(255, 255, 255),
    red = Color3.fromRGB(255, 70, 70),
    blue = Color3.fromRGB(70, 150, 255),
    button = Color3.fromRGB(45, 45, 55),
    buttonHover = Color3.fromRGB(70, 70, 85),
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
toggleButton.Size = UDim2.new(0, 40, 0, 40)
toggleButton.Position = UDim2.new(1, -50, 0, 15)
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
mainFrame.Size = UDim2.new(0, 360, 0, 340)
mainFrame.Position = UDim2.new(0.5, -180, 0.5, -170)
mainFrame.BackgroundColor3 = COLORS.bg
mainFrame.BorderSizePixel = 0
mainFrame.Visible = true
mainFrame.Active = true
makeDraggable(mainFrame)

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Parent = mainFrame
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "صنع لانشر"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.ZIndex = 3

local gridFrame = Instance.new("Frame")
gridFrame.Name = "GridFrame"
gridFrame.Parent = mainFrame
gridFrame.Size = UDim2.new(1, -10, 1, -40)
gridFrame.Position = UDim2.new(0, 5, 0, 34)
gridFrame.BackgroundTransparency = 1

local gridLayout = Instance.new("UIGridLayout")
gridLayout.Parent = gridFrame
gridLayout.CellSize = UDim2.new(0.5, -4, 0.5, -4)
gridLayout.CellPadding = UDim2.new(0, 8, 0, 8)
gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
gridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
gridLayout.VerticalAlignment = Enum.VerticalAlignment.Center

local cards = {}

local function fetchThumb(userId)
    local ok, content = pcall(function()
        return Players:GetUserThumbnailAsync(userId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
    end)
    if ok and content then
        return content
    end
    return "rbxthumb://type=AvatarHeadShot&id=" .. userId .. "&w=150&h=150"
end

local function createCard(index)
    local card = Instance.new("Frame")
    card.Name = "Card_" .. index
    card.Parent = gridFrame
    card.BackgroundColor3 = COLORS.card
    card.BorderSizePixel = 0
    card.LayoutOrder = index
    card.ClipsDescendants = false

    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 6)
    cardCorner.Parent = card

    local cardPadding = Instance.new("UIPadding")
    cardPadding.PaddingTop = UDim.new(0, 5)
    cardPadding.PaddingBottom = UDim.new(0, 5)
    cardPadding.PaddingLeft = UDim.new(0, 5)
    cardPadding.PaddingRight = UDim.new(0, 5)
    cardPadding.Parent = card

    local cardLayout = Instance.new("UIListLayout")
    cardLayout.Parent = card
    cardLayout.SortOrder = Enum.SortOrder.LayoutOrder
    cardLayout.Padding = UDim.new(0, 4)

    local textBox = Instance.new("TextBox")
    textBox.Name = "InputBox"
    textBox.Parent = card
    textBox.Size = UDim2.new(1, 0, 0, 24)
    textBox.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
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
    tbCorner.CornerRadius = UDim.new(0, 4)
    tbCorner.Parent = textBox

    local goButton = Instance.new("TextButton")
    goButton.Name = "GoButton"
    goButton.Parent = card
    goButton.Size = UDim2.new(1, 0, 0, 22)
    goButton.BackgroundColor3 = COLORS.button
    goButton.BorderSizePixel = 0
    goButton.Text = "هيا بنا!"
    goButton.TextColor3 = COLORS.text
    goButton.TextScaled = true
    goButton.Font = Enum.Font.GothamBold
    goButton.ZIndex = 2

    local goCorner = Instance.new("UICorner")
    goCorner.CornerRadius = UDim.new(0, 4)
    goCorner.Parent = goButton

    local resultFrame = Instance.new("Frame")
    resultFrame.Name = "ResultFrame"
    resultFrame.Parent = card
    resultFrame.Size = UDim2.new(1, 0, 0, 105)
    resultFrame.BackgroundTransparency = 1
    resultFrame.Visible = false
    resultFrame.ZIndex = 1

    local resultLayout = Instance.new("UIListLayout")
    resultLayout.Parent = resultFrame
    resultLayout.SortOrder = Enum.SortOrder.LayoutOrder
    resultLayout.Padding = UDim.new(0, 1)

    local avatarImage = Instance.new("ImageLabel")
    avatarImage.Name = "AvatarImage"
    avatarImage.Parent = resultFrame
    avatarImage.Size = UDim2.new(0, 36, 0, 36)
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
    nameLabel.Size = UDim2.new(1, 0, 0, 14)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = ""
    nameLabel.TextColor3 = COLORS.text
    nameLabel.TextScaled = true
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.ZIndex = 2

    local timerLabel = Instance.new("TextLabel")
    timerLabel.Name = "TimerLabel"
    timerLabel.Parent = resultFrame
    timerLabel.Size = UDim2.new(1, 0, 0, 15)
    timerLabel.BackgroundTransparency = 1
    timerLabel.Text = "00:00:00"
    timerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    timerLabel.TextScaled = true
    timerLabel.Font = Enum.Font.GothamBold
    timerLabel.ZIndex = 2

    local leaveLabel = Instance.new("TextLabel")
    leaveLabel.Name = "LeaveLabel"
    leaveLabel.Parent = resultFrame
    leaveLabel.Size = UDim2.new(1, 0, 0, 12)
    leaveLabel.BackgroundTransparency = 1
    leaveLabel.Text = "خروج: 0"
    leaveLabel.TextColor3 = COLORS.red
    leaveLabel.TextScaled = true
    leaveLabel.Font = Enum.Font.Gotham
    leaveLabel.ZIndex = 2

    local joinLabel = Instance.new("TextLabel")
    joinLabel.Name = "JoinLabel"
    joinLabel.Parent = resultFrame
    joinLabel.Size = UDim2.new(1, 0, 0, 12)
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
        timerLabel.Text = "00:00:00"
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
        timerLabel.Text = "00:00:00"
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
        textBox.BackgroundColor3 = Color3.fromRGB(30, 60, 30)
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
            local hours = math.floor(elapsed / 3600)
            local minutes = math.floor((elapsed % 3600) / 60)
            local seconds = elapsed % 60
            data.timerLabel.Text = string.format("%02d:%02d:%02d", hours, minutes, seconds)
        end
    end
end)
