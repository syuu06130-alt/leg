-- Remove Legs (R6) with Draggable UI
-- Place this LocalScript in StarterPlayer > StarterPlayerScripts

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

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

-- UIコーナーの追加
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
titleLabel.Text = "Leg Remover (R6)"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 18
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

-- 脚を削除する関数
local function removeLeg(legName)
	local character = player.Character
	if not character then
		statusLabel.Text = "Character not found!"
		statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
		return
	end
	
	local leg = character:FindFirstChild(legName)
	if leg then
		leg:Destroy()
		statusLabel.Text = legName .. " removed!"
		statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
	else
		statusLabel.Text = legName .. " not found!"
		statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
	end
end

-- ボタンのクリックイベント
leftLegButton.MouseButton1Click:Connect(function()
	removeLeg("Left Leg")
end)

rightLegButton.MouseButton1Click:Connect(function()
	removeLeg("Right Leg")
end)

closeButton.MouseButton1Click:Connect(function()
	screenGui:Destroy()
end)
