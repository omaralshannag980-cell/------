-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- GUI
local Gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
Gui.Name = "M1Tracker"
Gui.ResetOnSpawn = false

-- === [GUI الإشعارات - أسود صغير تحت الزر] ===
local NotifGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
NotifGui.Name = "M1Tracker_Notifs"
NotifGui.ResetOnSpawn = false
NotifGui.DisplayOrder = 999

local NotifContainer = Instance.new("Frame", NotifGui)
NotifContainer.Size = UDim2.new(0, 180, 0, 62)
NotifContainer.Position = UDim2.new(1, -20, 0, 75)
NotifContainer.AnchorPoint = UDim2.new(1, 0, 0, 0)
NotifContainer.BackgroundTransparency = 1
NotifContainer.Active = false
NotifContainer.ClipsDescendants = false

local NotifLayout = Instance.new("UIListLayout", NotifContainer)
NotifLayout.Padding = UDim.new(0, 6)
NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotifLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right

-- تكبير تلقائي للكونتينر بدون AutomaticSize
NotifLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	NotifContainer.Size = UDim2.new(0, 180, 0, math.max(NotifLayout.AbsoluteContentSize.Y, 62))
end)

local notifOrder = 0

local function showNotification(playerName, kind)
	local ok, err = pcall(function()
		notifOrder += 1

		local isJoin = (kind == "join")
		local txtColor    = isJoin and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 60, 60)
		local strokeColor = isJoin and Color3.fromRGB(0, 180, 60)  or Color3.fromRGB(200, 40, 40)

		local notif = Instance.new("TextButton")
		notif.Size = UDim2.new(0, 180, 0, 62)
		notif.LayoutOrder = -notifOrder
		notif.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		notif.BackgroundTransparency = 0.15
		notif.Text = ""
		notif.AutoButtonColor = false
		notif.BorderSizePixel = 0
		notif.Parent = NotifContainer

		Instance.new("UICorner", notif).CornerRadius = UDim.new(0, 8)

		local stroke = Instance.new("UIStroke", notif)
		stroke.Color = strokeColor
		stroke.Thickness = 1.5
		stroke.Transparency = 0.3

		local arLine = Instance.new("TextLabel", notif)
		arLine.Size = UDim2.new(1, -12, 0, 20)
		arLine.Position = UDim2.new(0, 6, 0, 4)
		arLine.BackgroundTransparency = 1
		arLine.Font = Enum.Font.GothamBold
		arLine.TextSize = 15
		arLine.TextColor3 = txtColor
		arLine.TextXAlignment = Enum.TextXAlignment.Center
		arLine.Text = isJoin and "اللاعب رجع🟢" or "اللاعب هرب🔴"

		local enLine = Instance.new("TextLabel", notif)
		enLine.Size = UDim2.new(1, -12, 0, 18)
		enLine.Position = UDim2.new(0, 6, 0, 24)
		enLine.BackgroundTransparency = 1
		enLine.Font = Enum.Font.GothamBold
		enLine.TextSize = 12
		enLine.TextColor3 = txtColor
		enLine.TextXAlignment = Enum.TextXAlignment.Center
		enLine.Text = isJoin and "The player returned🟢" or "The player ran away🔴"

		local nameLine = Instance.new("TextLabel", notif)
		nameLine.Size = UDim2.new(1, -12, 0, 14)
		nameLine.Position = UDim2.new(0, 6, 0, 45)
		nameLine.BackgroundTransparency = 1
		nameLine.Font = Enum.Font.Gotham
		nameLine.TextSize = 11
		nameLine.TextColor3 = Color3.fromRGB(210, 210, 210)
		nameLine.TextXAlignment = Enum.TextXAlignment.Center
		nameLine.Text = playerName

		-- أنيميشن ظهور
		notif.BackgroundTransparency = 1
		arLine.TextTransparency = 1
		enLine.TextTransparency = 1
		nameLine.TextTransparency = 1
		stroke.Transparency = 1
		TweenService:Create(notif,    TweenInfo.new(0.3), {BackgroundTransparency = 0.15}):Play()
		TweenService:Create(arLine,   TweenInfo.new(0.3), {TextTransparency = 0}):Play()
		TweenService:Create(enLine,   TweenInfo.new(0.3), {TextTransparency = 0}):Play()
		TweenService:Create(nameLine, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
		TweenService:Create(stroke,   TweenInfo.new(0.3), {Transparency = 0.3}):Play()

		-- إغلاق بالضغط
		local closed = false
		local function closeNotif()
			if closed then return end
			closed = true
			TweenService:Create(notif,    TweenInfo.new(0.25), {BackgroundTransparency = 1}):Play()
			TweenService:Create(arLine,   TweenInfo.new(0.25), {TextTransparency = 1}):Play()
			TweenService:Create(enLine,   TweenInfo.new(0.25), {TextTransparency = 1}):Play()
			TweenService:Create(nameLine, TweenInfo.new(0.25), {TextTransparency = 1}):Play()
			local st = TweenService:Create(stroke, TweenInfo.new(0.25), {Transparency = 1})
			st:Play()
			st.Completed:Connect(function()
				notif:Destroy()
			end)
		end

		notif.MouseButton1Click:Connect(closeNotif)
	end)
	if not ok then
		warn("[M1Tracker] Notification error: " .. tostring(err))
	end
end
-- === [نهاية GUI الإشعارات] ===

-- المهم الي يحسب السكربت تزوير وا يشكك فا فكسمك يا ابن الكحبه
local Button = Instance.new("TextButton", Gui)
Button.Size = UDim2.new(0,140,0,45)
Button.Position = UDim2.new(1,-160,0,20)
Button.BackgroundColor3 = Color3.fromRGB(25,25,25)
Button.Text = "📋خش افحلهم"
Button.TextColor3 = Color3.new(1,1,1)
Button.Font = Enum.Font.GothamBold
Button.TextScaled = true
Instance.new("UICorner", Button).CornerRadius = UDim.new(0,12)

-- السحب للزرار
local dragging, dragInput, dragStart, startPos
Button.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = Button.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)
Button.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if dragging and input == dragInput then
		local delta = input.Position - dragStart
		Button.Position = UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
	end
end)

-- الإطار الرئيسي
local Frame = Instance.new("Frame", Gui)
Frame.Size = UDim2.new(0,360,0,280)
Frame.Position = UDim2.new(0.5,-180,0.38,0)
Frame.BackgroundColor3 = Color3.fromRGB(18,18,25)
Frame.Visible = false
Frame.Active = true
Frame.Draggable = true
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0,12)

-- ظل
local Shadow = Instance.new("ImageLabel", Frame)
Shadow.ZIndex = -1
Shadow.Size = UDim2.new(1,30,1,30)
Shadow.Position = UDim2.new(0,-15,0,-15)
Shadow.BackgroundTransparency = 1
Shadow.Image = "rbxassetid://1316045217"
Shadow.ImageTransparency = 0.4

-- عنوان
local key=123
local function xorCrypt(str,key)
	local res={}
	for i=1,#str do
		res[i] = string.char(bit32.bxor(string.byte(str,i),key))
	end
	return table.concat(res)
end

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1,0,0,35)
Title.BackgroundColor3 = Color3.fromRGB(28,28,34)
Title.Font = Enum.Font.GothamBlack
Title.TextColor3 = Color3.fromRGB(0,200,255)
Title.Text = xorCrypt(xorCrypt("صنع سلندر-لانشر",key),key)
Title.TextScaled = true
Instance.new("UICorner", Title).CornerRadius = UDim.new(0,12)

-- بيانات
local AllPlayersStats={}
local PlayersData={}
local playerFrameHeight=110
local spacing=10

-- تنسيق الوقت
local function formatTime(t)
	local h = math.floor(t/3600)
	local m = math.floor((t%3600)/60)
	local s = math.floor(t%60)
	return string.format("%02d:%02d:%02d",h,m,s)
end

-- إنشاء الإطارات
for i=1,4 do
	local row = math.floor((i-1)/2)
	local col = (i%2==0) and 0.52 or 0.02
	local PFrame = Instance.new("Frame", Frame)
	PFrame.Size = UDim2.new(0.46,0,0,playerFrameHeight)
	PFrame.Position = UDim2.new(col,0,0,40 + row*(playerFrameHeight + spacing))
	PFrame.BackgroundTransparency = 1

	local Box = Instance.new("TextBox", PFrame)
	Box.PlaceholderText = "اسم الگحبه😜"..i
	Box.Size = UDim2.new(1,0,0,25)
	Box.BackgroundColor3 = Color3.fromRGB(38,38,48)
	Box.TextColor3 = Color3.new(1,1,1)
	Box.Font = Enum.Font.GothamSemibold
	Box.TextScaled = true
	Instance.new("UICorner", Box).CornerRadius = UDim.new(0,6)

	local Image = Instance.new("ImageLabel", PFrame)
	Image.Size = UDim2.new(0,36,0,36)
	Image.Position = UDim2.new(1,-36,0.3,0)
	Image.BackgroundTransparency = 1

	local NameLabel = Instance.new("TextLabel", PFrame)
	NameLabel.Size = UDim2.new(0.6,0,0,18)
	NameLabel.Position = UDim2.new(0,0,0.3,0)
	NameLabel.BackgroundTransparency = 1
	NameLabel.Font = Enum.Font.GothamBold
	NameLabel.TextColor3 = Color3.new(1,1,1)
	NameLabel.TextScaled = true

	local JoinLabel = Instance.new("TextLabel", PFrame)
	JoinLabel.Size = UDim2.new(0.6,0,0,16)
	JoinLabel.Position = UDim2.new(0,0,0.5,0)
	JoinLabel.BackgroundTransparency = 1
	JoinLabel.Font = Enum.Font.GothamBold
	JoinLabel.TextColor3 = Color3.fromRGB(0,255,0)
	JoinLabel.Text = "✅ رجع: 0"
	JoinLabel.TextScaled = true

	local LeaveLabel = Instance.new("TextLabel", PFrame)
	LeaveLabel.Size = UDim2.new(0.6,0,0,16)
	LeaveLabel.Position = UDim2.new(0,0,0.65,0)
	LeaveLabel.BackgroundTransparency = 1
	LeaveLabel.Font = Enum.Font.GothamBold
	LeaveLabel.TextColor3 = Color3.fromRGB(255,0,0)
	LeaveLabel.Text = "❌ هرب: 0"
	LeaveLabel.TextScaled = true

	local TimeLabel = Instance.new("TextLabel", PFrame)
	TimeLabel.Size = UDim2.new(0.6,0,0,16)
	TimeLabel.Position = UDim2.new(0,0,0.82,0)
	TimeLabel.BackgroundTransparency = 1
	TimeLabel.Font = Enum.Font.GothamBold
	TimeLabel.TextColor3 = Color3.new(1,1,1)
	TimeLabel.Text = "⏱️ 00:00:00"
	TimeLabel.TextScaled = true

	PlayersData[i] = {Box=Box,Image=Image,NameLabel=NameLabel,JoinLabel=JoinLabel,LeaveLabel=LeaveLabel,TimeLabel=TimeLabel,Time=0,Running=false,currentPlayer=nil}

	-- البحث
	Box:GetPropertyChangedSignal("Text"):Connect(function()
		local text=Box.Text:lower()
		local foundPlayer=nil
		for _,pl in pairs(Players:GetPlayers()) do
			if pl.Name:lower():find(text) or pl.DisplayName:lower():find(text) then
				foundPlayer=pl
				break
			end
		end
		PlayersData[i].currentPlayer=foundPlayer
		if foundPlayer then
			Image.Image="https://www.roblox.com/headshot-thumbnail/image?userId="..foundPlayer.UserId.."&width=100&height=100&format=png"
			NameLabel.Text="👤 "..foundPlayer.Name
			PlayersData[i].Running=true
			PlayersData[i].Time=AllPlayersStats[foundPlayer.UserId] and AllPlayersStats[foundPlayer.UserId].Time or 0
		else
			Image.Image=""
			NameLabel.Text=""
			PlayersData[i].Running=false
		end
		local stats=foundPlayer and AllPlayersStats[foundPlayer.UserId] or {JoinCount=0,LeaveCount=0,Time=0}
		JoinLabel.Text="✅ رجع: "..stats.JoinCount
		LeaveLabel.Text="❌ هرب: "..stats.LeaveCount
		TimeLabel.Text="⏱️ "..formatTime(stats.Time)
	end)
end

-- تحديث العداد
RunService.Heartbeat:Connect(function(deltaTime)
	for i=1,4 do
		local pdata=PlayersData[i]
		if pdata.currentPlayer and pdata.Running then
			pdata.Time+=deltaTime
			pdata.TimeLabel.Text="⏱️ "..formatTime(pdata.Time)
		end
	end
end)

-- عند دخول لاعب
Players.PlayerAdded:Connect(function(pl)
	if not AllPlayersStats[pl.UserId] then
		AllPlayersStats[pl.UserId]={JoinCount=0,LeaveCount=0,Time=0}
	end
	AllPlayersStats[pl.UserId].JoinCount+=1

	local isTracked = false
	for i=1,4 do
		local pdata=PlayersData[i]
		if pdata.currentPlayer and pdata.currentPlayer.UserId==pl.UserId then
			pdata.JoinLabel.Text="✅ رجع: "..AllPlayersStats[pl.UserId].JoinCount
			pdata.Running=true
			pdata.Time=AllPlayersStats[pl.UserId].Time
			pdata.currentPlayer = pl
			isTracked = true
		end
	end

	if isTracked then
		showNotification(pl.Name, "join")
	end
end)

-- عند خروج لاعب
Players.PlayerRemoving:Connect(function(pl)
	if not AllPlayersStats[pl.UserId] then
		AllPlayersStats[pl.UserId]={JoinCount=0,LeaveCount=0,Time=0}
	end
	AllPlayersStats[pl.UserId].LeaveCount+=1

	local isTracked = false
	for i=1,4 do
		local pdata=PlayersData[i]
		if pdata.currentPlayer and pdata.currentPlayer.UserId==pl.UserId then
			pdata.LeaveLabel.Text="❌ هرب: "..AllPlayersStats[pl.UserId].LeaveCount
			pdata.Running=false
			AllPlayersStats[pl.UserId].Time=pdata.Time
			isTracked = true
		end
	end

	if isTracked then
		showNotification(pl.Name, "leave")
	end
end)

-- Animation فتح/غلق القائمة
local function toggleFrame(frame)
	if frame.Visible == false then
		frame.Visible = true
		frame.Size = UDim2.new(0,0,0,0)
		local tween = TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0,360,0,280)})
		tween:Play()
	else
		local tween = TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0,0,0,0)})
		tween:Play()
		tween.Completed:Connect(function()
			frame.Visible = false
			frame.Size = UDim2.new(0,360,0,280)
		end)
	end
end

Button.MouseButton1Click:Connect(function()
	toggleFrame(Frame)
end)
