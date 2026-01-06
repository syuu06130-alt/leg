-- Remove Legs (R6) Script
-- Place this LocalScript in StarterPlayer > StarterCharacterScripts

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- 削除する脚を選択（"Left Leg" または "Right Leg"）
local legToRemove = "Left Leg"  -- ここを変更して削除する脚を選択

-- 脚を安全に削除する関数
local function removeLeg()
	-- キャラクターが存在するか確認
	if not character then
		warn("Character not found")
		return
	end
	
	-- 脚のパーツを取得
	local leg = character:FindFirstChild(legToRemove)
	
	if leg then
		-- 脚が存在する場合、削除
		leg:Destroy()
		print(legToRemove .. " has been removed")
	else
		warn(legToRemove .. " not found in character")
	end
end

-- キャラクターがロードされた後に脚を削除
wait(0.1)  -- キャラクターが完全にロードされるまで少し待機
removeLeg()

-- キャラクターがリスポーンした際にも脚を削除
player.CharacterAdded:Connect(function(newCharacter)
	character = newCharacter
	humanoid = character:WaitForChild("Humanoid")
	wait(0.1)
	removeLeg()
end)
