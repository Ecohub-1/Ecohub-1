
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Net = ReplicatedStorage:WaitForChild("Util"):WaitForChild("Net")
local GunShootEvent = Net:WaitForChild("RE/GunShootEvent")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

local weaponName = "Beakwood Rifle"
local bulletType = "Dart"

while task.wait(0.2) do
    local weapon = LocalPlayer.Backpack:FindFirstChild(weaponName) or Character:FindFirstChild(weaponName)
    local targetFolder = workspace:FindFirstChild("Regions") and workspace.Regions:FindFirstChild("Beakwoods") and workspace.Regions.Beakwoods:FindFirstChild("ClientBirds")
    
    -- Debug: Check if targetFolder exists
    if targetFolder then
        print("Found target folder: ClientBirds")
    else
        print("No ClientBirds folder found!")
    end

    if weapon and targetFolder then
        for _, bird in pairs(targetFolder:GetChildren()) do
            local targetPart
            if bird:FindFirstChild("HumanoidRootPart") then
                targetPart = bird.HumanoidRootPart
            elseif bird:FindFirstChild("PrimaryPart") then
                targetPart = bird.PrimaryPart
            elseif bird:FindFirstChild("Head") then
                targetPart = bird.Head
            end

            if targetPart then
                local targetPosition = targetPart.Position
                
                -- Debug: Check the bird being targeted
                print("Targeting bird:", bird.Name, "at", targetPosition)

                -- FireServer with debug
                GunShootEvent:FireServer(
                    "BulletFired",
                    weapon,
                    targetPosition,
                    bulletType
                )
            else
                -- Debug: If no valid part found
                print("No valid part found in", bird.Name)
            end
        end
    else
        print("No weapon or no birds found!")
    end
end
