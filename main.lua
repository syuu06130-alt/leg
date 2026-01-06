-- Roblox R6キャラクターの左脚のみを安全に削除するLocalScript
-- StarterPlayer > StarterPlayerScripts に配置してください
-- キャラクターのスポーン/リスポーン時に自動で左脚を削除します
-- 安全のため、まずHipジョイントを破壊してから脚パーツを破壊します

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local function removeLeftLeg(character)
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid and humanoid.RigType == Enum.HumanoidRigType.R6 then
        -- Torso内のLeft Hipジョイントを破壊（これで脚が切断される）
        local torso = character:FindFirstChild("Torso")
        if torso then
            local leftHip = torso:FindFirstChild("Left Hip")
            if leftHip then
                leftHip:Destroy()
            end
        end
        -- Left Legパーツを破壊
        local leftLeg = character:FindFirstChild("Left Leg")
        if leftLeg then
            leftLeg:Destroy()
        end
    end
end

local function onCharacterAdded(character)
    character:WaitForChild("Humanoid")
    task.wait(0.1)  -- キャラクターが完全にロードされるのを少し待つ
    removeLeftLeg(character)
end

-- 現在のキャラクターに適用
if player.Character then
    onCharacterAdded(player.Character)
end

-- リスポーン時にも適用
player.CharacterAdded:Connect(onCharacterAdded)
