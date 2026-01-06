-- 脚を削除するスクリプト (R6キャラクター用)

local Players = game:GetService("Players")

-- プレイヤーが追加された時の処理
local function onCharacterAdded(character)
    -- R6かどうかを確認
    if character:FindFirstChild("Humanoid") then
        local humanoid = character.Humanoid
        if humanoid.RigType == Enum.HumanoidRigType.R6 then
            -- 削除する脚のパーツ名
            local legParts = {
                "Left Leg",
                "Right Leg",
                "LeftLowerLeg",
                "RightLowerLeg",
                "LeftUpperLeg", 
                "RightUpperLeg"
            }
            
            -- 各パーツを検索して削除
            for _, partName in ipairs(legParts) do
                local part = character:FindFirstChild(partName)
                if part then
                    part:Destroy()
                end
            end
            
            -- 脚の接続を切断するための処理
            local torso = character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
            if torso then
                -- 脚の接続を切断
                for _, weldName in ipairs({"Left Hip", "Right Hip"}) do
                    local weld = torso:FindFirstChild(weldName)
                    if weld then
                        weld:Destroy()
                    end
                end
            end
            
            -- アニメーションの問題を防ぐため、Humanoidを調整
            task.wait(0.1)
            humanoid.PlatformStand = false
        end
    end
end

-- プレイヤーが参加した時の処理
local function onPlayerAdded(player)
    -- キャラクターが追加された時
    player.CharacterAdded:Connect(onCharacterAdded)
    
    -- 既にキャラクターが存在する場合
    if player.Character then
        onCharacterAdded(player.Character)
    end
end

-- 既存のプレイヤーと新規プレイヤーに接続
for _, player in ipairs(Players:GetPlayers()) do
    onPlayerAdded(player)
end
Players.PlayerAdded:Connect(onPlayerAdded)
