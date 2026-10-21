local P=game:GetService("Players")
local U=game:GetService("UserInputService")
local LP=P.LocalPlayer

local G=Instance.new("ScreenGui",LP:WaitForChild("PlayerGui"))
G.Name="JoinLeaveTracker"

local F=Instance.new("Frame",G)
F.Size=UDim2.fromOffset(320,210)
F.Position=UDim2.new(.5,-160,.5,-105)
F.BackgroundColor3=Color3.fromRGB(25,55,35)
Instance.new("UICorner",F).CornerRadius=UDim.new(0,10)

local T=Instance.new("TextLabel",F)
T.Size=UDim2.new(1,0,0,42)
T.BackgroundColor3=Color3.fromRGB(25,150,65)
T.Text="📊 تتبع دخول وخروج (صنع لانشر) (صنع سلندر)"
T.TextColor3=Color3.new(1,1,1)
T.TextSize=20
T.Font=Enum.Font.GothamBold

local Box=Instance.new("TextBox",F)
Box.Position=UDim2.fromOffset(10,52)
Box.Size=UDim2.new(1,-55,0,38)
Box.BackgroundColor3=Color3.fromRGB(45,95,55)
Box.PlaceholderText="اسم اللاعب"
Box.Text=""
Box.TextColor3=Color3.new(1,1,1)
Box.PlaceholderColor3=Color3.fromRGB(190,220,195)
Box.TextSize=18
Box.Font=Enum.Font.GothamBold

local Check=Instance.new("TextButton",F)
Check.Position=UDim2.new(1,-43,0,52)
Check.Size=UDim2.fromOffset(33,38)
Check.BackgroundColor3=Color3.fromRGB(30,180,70)
Check.Text="✓"
Check.TextColor3=Color3.new(1,1,1)
Check.TextSize=24
Check.Font=Enum.Font.GothamBold

local J=Instance.new("TextLabel",F)
J.Position=UDim2.fromOffset(10,100)
J.Size=UDim2.new(1,-20,0,28)
J.BackgroundTransparency=1
J.Text="دخول: 0"
J.TextColor3=Color3.fromRGB(80,255,120)
J.TextSize=18
J.Font=Enum.Font.GothamBold

local R=J:Clone()
R.Parent=F
R.Position=UDim2.fromOffset(10,132)
R.Text="خروج: 0"
R.TextColor3=Color3.fromRGB(255,110,110)

local TM=J:Clone()
TM.Parent=F
TM.Position=UDim2.fromOffset(10,164)
TM.Text="وقت التشغيل: 00:00:00"
TM.TextColor3=Color3.new(1,1,1)
TM.TextSize=16

local j,r=0,0

P.PlayerAdded:Connect(function(p)
	j=j+1
	J.Text="دخول: "..j
end)

P.PlayerRemoving:Connect(function(p)
	r=r+1
	R.Text="خروج: "..r
end)

local start=os.clock()
task.spawn(function()
	while G.Parent do
		local t=math.floor(os.clock()-start)
		TM.Text=string.format(
			"وقت التشغيل: %02d:%02d:%02d",
			t/3600,(t%3600)/60,t%60
		)
		task.wait(1)
	end
end)
