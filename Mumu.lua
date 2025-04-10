-- // Load Dependencies
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- // Main Window Setup
local Window = Fluent:CreateWindow({
    Title = "Eco Hub " .. Fluent.Version,
    SubTitle = "by zer09Xz",
    TabWidth = 150,
    Size = UDim2.fromOffset(580, 400),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- // Tabs
local Tabs = {
    Credits = Window:AddTab({ Title = "Credits", Icon = "trophy" }),
    AutoFarm = Window:AddTab({ Title = "Auto Farm", Icon = "gamepad" }),
    Dungeon = Window:AddTab({ Title = "Dungeon", Icon = "globe" }),
    Teleport = Window:AddTab({ Title = "Teleport", Icon = "map-pinned" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-- // Credits
Tabs.Credits:AddParagraph({
    Title = "Owner & Script",
    Content = "Owner: zer09Xz\nScript: zer09Xz\nHelper: Lucas, Dummy"
})

-- // Player & Backpack References
local player = game.Players.LocalPlayer
local backpack = player:WaitForChild("Backpack")

-- ===================================
-- // SETTINGS TAB - Auto Equip
-- ===================================
Tabs.Settings:AddSection("Auto Equip")

local selectedOptions = {"Melee", "Sword"}
local autoEquipRunning = false

Tabs.Settings:AddDropdown("WeaponTypeDropdown", {
    Title = "Select Weapon Type(s)",
    Values = {"Melee", "Sword", "DevilFruit", "Special"},
    Multi = true,
    Default = selectedOptions,
    Callback = function(value)
        selectedOptions = value
    end
})

Tabs.Settings:AddToggle("AutoEquipToggle", {
    Title = "Auto Equip",
    Default = false,
    Callback = function(value)
        autoEquipRunning = value
        if value then
            task.spawn(function()
                while autoEquipRunning do
                    if player.Character then
                        for _, tool in ipairs(backpack:GetChildren()) do
                            if tool:IsA("Tool") and table.find(selectedOptions, tool:GetAttribute("Type")) then
                                tool.Parent = player.Character
                            end
                        end
                    end
                    task.wait(0.1)
                end
            end)
        end
    end
})

-- ===================================
-- // SETTINGS TAB - Auto Click
-- ===================================
Tabs.Settings:AddSection("Auto Click")

local autoClicking = false
local clickDelay = 0.1
local VirtualUser = game:GetService("VirtualUser")

Tabs.Settings:AddToggle("AutoClickToggle", {
    Title = "Auto Click",
    Default = false,
    Callback = function(value)
        autoClicking = value
    end
})

game:GetService("RunService").RenderStepped:Connect(function()
    if autoClicking then
        VirtualUser:Button1Down(Vector2.new(0.9, 0.9))
        VirtualUser:Button1Up(Vector2.new(0.9, 0.9))
        task.wait(clickDelay)
    end
end)

-- ===================================
-- // SETTINGS TAB - Auto Skill
-- ===================================
Tabs.Settings:AddSection("Auto Skill")

local VirtualInputManager = game:GetService("VirtualInputManager")
local skillKeys = { Z = "AutoSkillZ", X = "AutoSkillX", C = "AutoSkillC", V = "AutoSkillV", F = "AutoSkillF" }

for key, id in pairs(skillKeys) do
    local AutoSkill = false
    local toggle = Tabs.Settings:AddToggle(id, { Title = "Skill " .. key, Default = false })

    toggle:OnChanged(function(state)
        AutoSkill = state
        if AutoSkill then
            task.spawn(function()
                while AutoSkill do
                    VirtualInputManager:SendKeyEvent(true, key, false, game)
                    task.wait(0.05)
                    VirtualInputManager:SendKeyEvent(false, key, false, game)
                    task.wait(0.1)
                end
            end)
        end
    end)
end

-- ===================================
-- // AUTO FARM TAB
-- ===================================
Tabs.AutoFarm:AddSection("Auto Farm")

local MobFolder = workspace:WaitForChild("Mob")
local MobNames = {}

for _, mob in ipairs(MobFolder:GetChildren()) do
    if mob:IsA("Model") and not table.find(MobNames, mob.Name) then
        table.insert(MobNames, mob.Name)
    end
end

table.sort(MobNames)
local SelectedMob = MobNames[1]
local Distance = 25

Tabs.AutoFarm:AddDropdown("MobDropdown", {
    Title = "Select Mob",
    Values = MobNames,
    Default = SelectedMob,
    Callback = function(Value)
        SelectedMob = Value
    end
})

Tabs.AutoFarm:AddInput("DistanceInput", {
    Title = "Distance",
    Default = "25",
    Placeholder = "ใส่ตัวเลข เช่น 50",
    Numeric = true,
    Finished = true,
    Callback = function(Value)
        local num = tonumber(Value)
        if num then Distance = math.clamp(num, 0, 100) end
    end
})

Tabs.AutoFarm:AddToggle("AutoFarmToggle", {
    Title = "Auto Farm",
    Default = false,
    Callback = function(Value)
        _G.AutoFarm = Value

        if Value then
            task.spawn(function()
                while _G.AutoFarm do
                    pcall(function()
                        local char = player.Character
                        local hrp = char and char:FindFirstChild("HumanoidRootPart")
                        local humanoid = char and char:FindFirstChild("Humanoid")
                        if not hrp or not humanoid then return end

                        humanoid.AutoRotate = false

                        if hrp.Position.Y < workspace.FallenPartsDestroyHeight + 10 then
                            hrp.CFrame = CFrame.new(0, 50, 0)
                            return
                        end

                        for _, mob in ipairs(workspace.Mob:GetChildren()) do
                            if mob.Name == SelectedMob and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                                local targetPos = mob.HumanoidRootPart.Position + Vector3.new(0, Distance, 0)
                                local look = (mob.HumanoidRootPart.Position - targetPos).Unit
                                hrp.CFrame = CFrame.lookAt(targetPos, targetPos + look)
                                break
                            end
                        end
                    end)
                    task.wait(0.01)
                end
            end)
        end
    end
})

-- ===================================
-- // AUTO BOSS
-- ===================================
Tabs.AutoFarm:AddSection("Auto Boss")

local bossList = {"Vasto Hollw", "Phoenix Man", "Spongebob", "Ghost Gojo"}
local selectedBoss = bossList[1]
local notificationSent = false

Tabs.AutoFarm:AddDropdown("BossDropdown", {
    Title = "Select Boss",
    Values = bossList,
    Default = selectedBoss,
    Callback = function(value) selectedBoss = value end
})

Tabs.AutoFarm:AddToggle("AutoBossToggle", {
    Title = "Auto Boss",
    Default = false,
    Callback = function(Value)
        _G.Autoboss = Value
        if Value then
            task.spawn(function()
                while _G.Autoboss do
                    pcall(function()
                        local args = {
                            ["Vasto Hollw"] = "Orb Demon",
                            ["Phoenix Man"] = "Banana",
                            ["Spongebob"] = "Banana",
                            ["Ghost Gojo"] = "Orb Demon"
                        }

                        local itemName = args[selectedBoss]
                        if not itemName then return end

                        if not table.find(game.ReplicatedStorage.Remotes.Inventory:GetChildren(), itemName) then
                            if not notificationSent then
                                Fluent:Notify({ Title = "Notification", Content = "You don't have " .. itemName .. " in inventory!", Duration = 5 })
                                notificationSent = true
                            end
                            return
                        end

                        game.ReplicatedStorage.Remotes.Inventory:FireServer(itemName)
                        game.ReplicatedStorage.Modules.NetworkFramework.NetworkEvent:FireServer("fire", nil, "SummonBoss", selectedBoss)

                        for _, mob in pairs(workspace.Mob:GetChildren()) do
                            if mob.Name == selectedBoss and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                                local targetPos = mob.HumanoidRootPart.Position + Vector3.new(0, Distance, 0)
                                local look = (mob.HumanoidRootPart.Position - targetPos).Unit
                                local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                                if hrp then hrp.CFrame = CFrame.lookAt(targetPos, targetPos + look) end
                                break
                            end
                        end
                    end)
                    task.wait(0.01)
                end
            end)
        end
    end
})

-- ===================================
-- // AUTO DUNGEON
-- ===================================
Tabs.Dungeon:AddSection("Auto Dungeon")

Tabs.Dungeon:AddToggle("DungeonToggle", {
    Title = "Auto Dungeon",
    Default = false,
    Callback = function(Value)
        _G.AutoDungeon = Value
        if Value then
            task.spawn(function()
                while _G.AutoDungeon do
                    pcall(function()
                        local char = player.Character
                        local hrp = char and char:FindFirstChild("HumanoidRootPart")
                        local humanoid = char and char:FindFirstChild("Humanoid")
                        if not hrp or not humanoid then return end

                        humanoid.AutoRotate = false
                        local dungeonNPC = workspace.npcClick:FindFirstChild("Raid")
                        if not dungeonNPC then return end

                        game.ReplicatedStorage.Remotes.Inventory:FireServer("Orb Dungeon")

                        local prompt = dungeonNPC:FindFirstChild("Prompt")
                        if prompt then prompt:Click() end

                        while not workspace:FindFirstChild("DungeonRing"):FindFirstChild("Pad") do
                            task.wait(1)
                            prompt:Click()
                        end

                        hrp.CFrame = workspace.DungeonRing.Pad.CFrame
                        repeat task.wait(1) until #workspace.DunMob:GetChildren() > 0

                        for _, mob in pairs(workspace.DunMob:GetChildren()) do
                            if mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                                local targetPos = mob.HumanoidRootPart.Position + Vector3.new(0, 5, 0)
                                local look = (mob.HumanoidRootPart.Position - targetPos).Unit
                                hrp.CFrame = CFrame.lookAt(targetPos, targetPos + look)
                                break
                            end
                        end
                    end)
                    task.wait(0.01)
                end
            end)
        end
    end
})
