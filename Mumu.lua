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
            local targetPosition = nil

            -- Check if the bird has CFrame, and use its Position
            if bird:FindFirstChild("CFrame") then
                targetPosition = bird.CFrame.Position
                print("Using CFrame Position:", targetPosition)
            elseif bird:FindFirstChild("HumanoidRootPart") then
                targetPosition = bird.HumanoidRootPart.Position
                print("Using HumanoidRootPart Position:", targetPosition)
            elseif bird:FindFirstChild("PrimaryPart") then
                targetPosition = bird.PrimaryPart.Position
                print("Using PrimaryPart Position:", targetPosition)
            elseif bird:FindFirstChild("Head") then
                targetPosition = bird.Head.Position
                print("Using Head Position:", targetPosition)
            elseif bird:FindFirstChild("Torso") then
                targetPosition = bird.Torso.Position
                print("Using Torso Position:", targetPosition)
            else
                -- If no valid part found, use the model's position (CFrame)
                targetPosition = bird.Position
                print("Using model's Position:", targetPosition)
            end

            if targetPosition then
                -- FireServer with debug
                print("Firing at:", targetPosition)  -- Check the target position
                GunShootEvent:FireServer(
                    "BulletFired",
                    weapon,
                    targetPosition,
                    bulletType
                )
            else
                -- Debug: If no valid position found
                print("No valid position found for", bird.Name)
            end
        end
    else
        print("No weapon or no birds found!")
    end
end
