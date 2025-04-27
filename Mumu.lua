local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Eco Hub : Beaks",
    SubTitle = " | by zer09Xz",
    TabWidth = 150,
    Size = UDim2.fromOffset(580, 400),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local autoEquipEnabled = false
local autoFarmEnabled = false
local shootingRange = 100

local ATE = Tabs.Main:AddToggle("AutoEquip", {
    Title = "Auto Equip",
    Default = false
})

ATE:OnChanged(function(Value)
    autoEquipEnabled = Value
end)

task.spawn(function()
    while task.wait(0.1) do
        if autoEquipEnabled then
            local player = game.Players.LocalPlayer
            local character = player.Character
            if character then
                local tool = character:FindFirstChildOfClass("Tool")
                if tool and tool.Name:match("Rifle") then
                    -- Equip the tool only if not already equipped
                    if not character.Humanoid:HasTool(tool) then
                        character.Humanoid:EquipTool(tool)
                    end
                end
            end
        end
    end
end)

local AUF = Tabs.Main:AddToggle("AutoFarm", {
    Title = "Auto Farm",
    Default = false
})

AUF:OnChanged(function(Value)
    autoFarmEnabled = Value
end)

task.spawn(function()
    while task.wait(0.1) do
        if autoFarmEnabled then
            local player = game.Players.LocalPlayer
            local character = player.Character
            if character then
                local tool = character:FindFirstChildOfClass("Tool")
                if tool then
                    local remote = game:GetService("ReplicatedStorage"):WaitForChild("Util"):WaitForChild("Net"):FindFirstChild("RE/GunShootEvent")
                    if remote then
                        local birdsFolder = workspace:FindFirstChild("Regions") and workspace.Regions:FindFirstChild("Beakwoods") and workspace.Regions.Beakwoods:FindFirstChild("ClientBirds")
                        if birdsFolder then
                            local closestBird = nil
                            local closestDistance = shootingRange

                            for _, bird in ipairs(birdsFolder:GetChildren()) do
                                if bird:IsA("Model") and bird:FindFirstChild("HumanoidRootPart") then
                                    local humanoid = bird:FindFirstChildWhichIsA("Humanoid")
                                    if humanoid and humanoid.Health > 0 then
                                        local distance = (character.HumanoidRootPart.Position - bird.HumanoidRootPart.Position).Magnitude
                                        if distance <= shootingRange and distance < closestDistance then
                                            closestDistance = distance
                                            closestBird = bird
                                        end
                                    end
                                end
                            end

                            if closestBird then
                                remote:FireServer(
                                    "BulletFired",
                                    tool.Name,
                                    closestBird.HumanoidRootPart.Position,
                                    "Dart"
                                )
                            end
                        end
                    end
                end
            end
        end
    end
end)

local Input = Tabs.Main:AddInput("RangeInput", {
    Title = "Shooting Range",
    Default = tostring(shootingRange),
    Placeholder = "Enter range (e.g., 100)",
    Numeric = true,
    Finished = true,
    Callback = function(Value)
        local num = tonumber(Value)
        if num then
            if num > 500 then
                num = 500
                Fluent:Notify({
                    Title = "Warning",
                    Content = "Maximum range is 500!",
                    SubContent = "Input capped at 500",
                    Duration = 3
                })
            end
            shootingRange = num
        end
    end
})
Fluent:Notify({
                    Title = "Test",
                    Content = "Test",
                    Duration = 3
    end})
