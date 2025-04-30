local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local backpack = player:WaitForChild("Backpack")
local gunRemote = ReplicatedStorage:WaitForChild("Util"):WaitForChild("Net"):FindFirstChild("RE/GunSE")

local weapon

-- หาอาวุธประเภทปืน (ชื่อขึ้นต้นด้วย "Rifle")
for _, item in ipairs(backpack:GetChildren()) do
    if item:IsA("Tool") and item.Name:match("^Rifle") then
        weapon = item
        break
    end
end

-- ถ้ามีอาวุธ เริ่ม Kill Aura
if weapon then
    local range = 50 -- ระยะตรวจจับ
    RunService.RenderStepped:Connect(function()
        for _, enemy in pairs(workspace:GetDescendants()) do
            if enemy:IsA("Model") and enemy:FindFirstChild("Humanoid") and enemy:FindFirstChild("HumanoidRootPart") then
                local hrp = enemy.HumanoidRootPart
                local distance = (hrp.Position - character.HumanoidRootPart.Position).Magnitude

                if distance <= range and enemy ~= character then
                    -- ยิงศัตรู
                    local args = {
                        [1] = "BulletFired",
                        [2] = weapon,
                        [3] = hrp.Position,
                        [4] = "Dart"
                    }
                    gunRemote:FireServer(unpack(args))
                end
            end
        end
    end)
else
    warn("ไม่พบอาวุธประเภทปืนใน Backpack")
end
