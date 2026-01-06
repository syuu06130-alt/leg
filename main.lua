--[[
=== PART 1: SERVER SCRIPT ===
Place this Script in ServerScriptService
Name it: "LegRemoverServer"
--]]

-- RemoteEventの作成
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local remoteEvent = Instance.new("RemoteEvent")
remoteEvent.Name = "RemoveLegEvent"
remoteEvent.Parent = ReplicatedStorage

-- R6とR15の脚パーツ名
local R6_LEGS = {
	Left = {"Left Leg"},
	Right = {"Right Leg"}
}

local R15_LEGS = {
	Left = {"LeftUpperLeg", "LeftLowerLeg", "LeftFoot"},
	Right = {"RightUpperLeg", "RightLowerLeg", "RightFoot"}
}

-- 脚を削除する関数
local function removeLeg(player, legSide)
	local character = player.Character
	if not character then return false end
	
	local humanoid = character:FindFirstChild("Humanoid")
	if not humanoid then return false end
	
	local isR15 = humanoid.RigType == Enum.HumanoidRigType.R15
	local partsToRemove = isR15 and R15_LEGS[legSide] or R6_LEGS[legSide]
	
	local removed = false
	
	if partsToRemove then
		for _, partName in ipairs(partsToRemove) do
			local part = character:FindFirstChild(partName)
			if part then
				part:Destroy()
				removed = true
			end
		end
	end
	
	return removed
end

-- RemoteEventのリスナー
remoteEvent.OnServerEvent:Connect(function(player, legSide)
	if legSide == "Left" or legSide == "Right" then
		removeLeg(player, legSide)
	end
end)

print("Leg Remover Server Script loaded!")

--[[
=== PART 2: LOCAL SCRIPT ===
Place this LocalScript in StarterPlayer > StarterPlayerScripts
Name it: "LegRemoverClient"
--]]

-- 以下のコードは別のLocalScriptに入れてください：

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- RemoteEventを取得（サーバーが作成するまで待機）
local remoteEvent = ReplicatedStorage:WaitForChild("RemoveLegEvent", 10)

if not remoteEvent then
	warn("RemoteLegEvent not found! Make sure the server script is running.")
	return
end

-- ScreenGuiの作成
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LegRemoverGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- メインフレームの作成
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 300, 0, 200)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame

-- タイトルバーの作成
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleBar

-- タイトルテキスト
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -20, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Leg Remover (R6/R15)"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 16
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- Left Legボタンの作成
local leftLegButton = Instance.new("TextButton")
leftLegButton.Name = "LeftLegButton"
leftLegButton.Size = UDim2.new(0, 120, 0, 50)
leftLegButton.Position = UDim2.new(0.5, -130, 0.5, -10)
leftLegButton.BackgroundColor3 = Color3.fromRGB(60, 150, 255)
leftLegButton.BorderSizePixel = 0
leftLegButton.Text = "Remove Left Leg"
leftLegButton.TextColor3 = Color3.fromRGB(255, 255, 255)
leftLegButton.TextSize = 14
leftLegButton.Font = Enum.Font.GothamBold
leftLegButton.Parent = mainFrame

local leftCorner = Instance.new("UICorner")
leftCorner.CornerRadius = UDim.new(0, 8)
leftCorner.Parent = leftLegButton

-- Right Legボタンの作成
local rightLegButton = Instance.new("TextButton")
rightLegButton.Name = "RightLegButton"
rightLegButton.Size = UDim2.new(0, 120, 0, 50)
rightLegButton.Position = UDim2.new(0.5, 10, 0.5, -10)
rightLegButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
rightLegButton.BorderSizePixel = 0
rightLegButton.Text = "Remove Right Leg"
rightLegButton.TextColor3 = Color3.fromRGB(255, 255, 255)
rightLegButton.TextSize = 14
rightLegButton.Font = Enum.Font.GothamBold
rightLegButton.Parent = mainFrame

local rightCorner = Instance.new("UICorner")
rightCorner.CornerRadius = UDim.new(0, 8)
rightCorner.Parent = rightLegButton

-- 閉じるボタンの作成
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
closeButton.BorderSizePixel = 0
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 16
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1, 0)
closeCorner.Parent = closeButton

-- ステータスラベルの作成
local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Size = UDim2.new(1, -20, 0, 30)
statusLabel.Position = UDim2.new(0, 10, 1, -40)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Select a leg to remove"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.TextSize = 12
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = mainFrame

-- ドラッグ機能の実装
local dragging = false
local dragInput
local dragStart
local startPos

local function update(input)
	local delta = input.Position - dragStart
	mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

titleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position
		
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

titleBar.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)

-- 脚を削除する関数（サーバーにリクエスト）
local function removeLeg(legSide)
	statusLabel.Text = "Removing " .. legSide:lower() .. " leg..."
	statusLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
	
	-- サーバーに削除リクエストを送信
	remoteEvent:FireServer(legSide)
	
	-- フィードバック
	wait(0.1)
	statusLabel.Text = legSide .. " leg removed!"
	statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
end

-- ボタンのクリックイベント
leftLegButton.MouseButton1Click:Connect(function()
	removeLeg("Left")
end)

rightLegButton.MouseButton1Click:Connect(function()
	removeLeg("Right")
end)

closeButton.MouseButton1Click:Connect(function()
	screenGui:Destroy()
end)

print("Leg Remover Client Script loaded!")
