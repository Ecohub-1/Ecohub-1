-- FULL SYSTEM INSTALLER

-- ========== STEP 1: สร้าง RemoteEvent ==========
local ReplicatedStorage = game:GetService("ReplicatedStorage")
if not ReplicatedStorage:FindFirstChild("ToggleUndergroundRemote") then
    local remote = Instance.new("RemoteEvent")
    remote.Name = "ToggleUndergroundRemote"
    remote.Parent = ReplicatedStorage
end

-- ========== STEP 2: สร้าง Server Script ==========
local ServerScriptService = game:GetService("ServerScriptService")
if not ServerScriptService:FindFirstChild("UndergroundServer") then
    local serverScript = Instance.new("Script")
    serverScript.Name = "UndergroundServer"
    serverScript.Source = 
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local Players = game:GetService("Players")

        local remote = ReplicatedStorage:WaitForChild("ToggleUndergroundRemote")

        local function hideCharacter(character)
            for _, obj in ipairs(character:GetDescendants()) do
                if obj:IsA("BasePart") then
                    obj.Transparency = 1
                    obj.CanCollide = false
                elseif obj:IsA("Decal") then
                    obj.Transparency = 1
                end
            end
        end

        local function showCharacter(character)
            for _, obj in ipairs(character:GetDescendants()) do
                if obj:IsA("BasePart") then
                    obj.Transparency = 0
                    obj.CanCollide = true
                elseif obj:IsA("Decal") then
                    obj.Transparency = 0
                end
            end
        end

        remote.OnServerEvent:Connect(function(player, enable)
            local character = player.Character
            if not character then return end

            if enable then
                hideCharacter(character)

                local old = workspace:FindFirstChild("Fake_" .. player.Name)
                if old then old:Destroy() end

                local clone = character:Clone()
                clone.Name = "Fake_" .. player.Name
                for _, obj in ipairs(clone:GetDescendants()) do
                    if obj:IsA("Script") or obj:IsA("LocalScript") then
                        obj:Destroy()
                    end
                end
                clone.Parent = workspace

                local hrp = clone:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.Anchored = true
                    hrp.CFrame = hrp.CFrame * CFrame.new(0, -6, 0) * CFrame.Angles(math.rad(180), 0, 0)
                end
            else
                showCharacter(character)

                local old = workspace:FindFirstChild("Fake_" .. player.Name)
                if old then old:Destroy() end
            end
        end)

        Players.PlayerRemoving:Connect(function(player)
            local fake = workspace:FindFirstChild("Fake_" .. player.Name)
            if fake then
                fake:Destroy()
            end
        end)

    serverScript.Parent = ServerScriptService
end

-- ========== STEP 3: สร้าง LocalScript ==========
local StarterPlayer = game:GetService("StarterPlayer")
local StarterPlayerScripts = StarterPlayer:WaitForChild("StarterPlayerScripts")
if not StarterPlayerScripts:FindFirstChild("UndergroundClient") then
    local localScript = Instance.new("LocalScript")
    localScript.Name = "UndergroundClient"
    localScript.Source = 
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local Players = game:GetService("Players")
        local UserInputService = game:GetService("UserInputService")

        local player = Players.LocalPlayer
        local remote = ReplicatedStorage:WaitForChild("ToggleUndergroundRemote")

        local isUnderground = false
        local TOGGLE_KEY = Enum.KeyCode.G

        local function toggleUnderground()
            isUnderground = not isUnderground
            remote:FireServer(isUnderground)
        end

        UserInputService.InputBegan:Connect(function(input, processed)
            if processed then return end
            if input.KeyCode == TOGGLE_KEY then
                toggleUnderground()
            end
        end)
    
    localScript.Parent = StarterPlayerScripts
end
