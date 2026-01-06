-- 現在のキャラクターの脚を即座に削除
local character = script.Parent -- スクリプトをHumanoidやパーツの中に入れた場合
if not character:IsA("Model") then
    character = game.Players.LocalPlayer.Character
end

if character and character:FindFirstChild("Humanoid") then
    local humanoid = character.Humanoid
    if humanoid.RigType == Enum.HumanoidRigType.R6 then
        local partsToRemove = {"Left Leg", "Right Leg"}
        
        for _, partName in ipairs(partsToRemove) do
            local part = character:FindFirstChild(partName)
            if part then
                part:Destroy()
            end
        end
    end
end
