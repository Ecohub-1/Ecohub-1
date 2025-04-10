-- // Load Libraries
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- // Create Window
local Window = Fluent:CreateWindow({
    Title = "Eco Hub" .. Fluent.Version,
    SubTitle = " | by zer09Xz",
    TabWidth = 150,
    Size = UDim2.fromOffset(580, 400),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- // Tabs
local Tabs = {
    Credits = Window:AddTab({ Title = "credit", Icon = "trophy" }),
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

-- // Variables
local player = game.Players.LocalPlayer
local backpack = player:WaitForChild("Backpack")
local selectedWeaponTypes = { "Melee", "Sword","DevilFruit", "Special", }

-- // Auto Equip
Tabs.Settings:AddSection("Auto Equip")

Tabs.Settings:AddDropdown("Search weapon", {
    Title = "Weapon Type",
    Values = { "Melee", "Sword", "DevilFruit", "Special" },
    Multi = true,
    Default = selectedWeaponTypes,
    Callback = function(value)
        selectedWeaponTypes = value
    end
})

local autoEquipRunning = false
Tabs.Settings:AddToggle("AutoEquipToggle", {
    Title = "Auto Equip",
    Default = false,
    Callback = function(value)
        autoEquipRunning = value
        if autoEquipRunning then
            task.spawn(function()
                while autoEquipRunning do
                    if player.Character then
                        for _, tool in ipairs(backpack:GetChildren()) do
                            if tool:IsA("Tool") and table.find(selectedWeaponTypes, tool:GetAttribute("Type")) then
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

-- // Auto Click
Tabs.Settings:AddSection("Auto Click")
local autoClicking = false
local clickDelay = 0.1

Tabs.Settings:AddToggle("AutoClickToggle", {
    Title = "Auto Click",
    Default = false,
    Callback = function(value)
        autoClicking = value
    end
})

local VirtualUser = game:GetService("VirtualUser")
game:GetService("RunService").RenderStepped:Connect(function()
    if autoClicking then
        VirtualUser:Button1Down(Vector2.new(0.9, 0.9))
        VirtualUser:Button1Up(Vector2.new(0.9, 0.9))
        task.wait(clickDelay)
    end
end)

-- // Auto Skill
Tabs.Settings:AddSection("Auto Skill")
local VirtualInputManager = game:GetService("VirtualInputManager")
local skillKeys = { Z = "AutoSkillZ", X = "AutoSkillX", C = "AutoSkillC", V = "AutoSkillV", F = "AutoSkillF" }

for key, id in pairs(skillKeys) do
    Tabs.Settings:AddToggle(id, {
        Title = "Skill " .. key,
        Default = false,
        Callback = function(state)
            if state then
                task.spawn(function()
                    while state do
                        VirtualInputManager:SendKeyEvent(true, key, false, game)
                        task.wait(0.05)
                        VirtualInputManager:SendKeyEvent(false, key, false, game)
                        task.wait(0.1)
                        if not Options[id].Value then break end
                    end
                end)
            end
        end
    })
end

-- // Auto Farm
Tabs.AutoFarm:AddSection("Auto Farm")

local MobFolder = workspace:WaitForChild("Mob")
local MobNames = {}
for _, mob in pairs(MobFolder:GetChildren()) do
    if mob:IsA("Model") and not table.find(MobNames, mob.Name) then
        table.insert(MobNames, mob.Name)
    end
end
table.sort(MobNames)

local SelectedMob = MobNames[1]
Tabs.AutoFarm:AddDropdown("MobDropdown", {
    Title = "Select Mob",
    Values = MobNames,
    Default = SelectedMob,
    Callback = function(Value)
        SelectedMob = Value
    end
})

local Distance = 25
Tabs.AutoFarm:AddInput("DistanceInput", {
    Title = "Distance",
    Default = tostring(Distance),
    Placeholder = "ใส่ระยะ",
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
                        for _, v in pairs(workspace.Mob:GetChildren()) do
                            if v.Name == SelectedMob and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                local targetPos = v.HumanoidRootPart.Position + Vector3.new(0, Distance, 0)
                                local look = (v.HumanoidRootPart.Position - targetPos).Unit
                                hrp.CFrame = CFrame.lookAt(targetPos, targetPos + look)
                                break
                            end
                        end
                    end)
                    task.wait(0.01)
                end
            end)
        else
            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local humanoid = char and char:FindFirstChild("Humanoid")
            if humanoid then humanoid.AutoRotate = true end
        end
    end
})

-- // Auto Dungeon (Single Toggle)
Tabs.Dungeon:AddSection("Auto Dungeon")
Tabs.Dungeon:AddToggle("AutoDungeonToggle", {
    Title = "Auto Dungeon",
    Default = false,
    Callback = function(state)
        _G.AutoDungeon = state
        if state then
            task.spawn(function()
                while _G.AutoDungeon do
                    pcall(function()
                        local char = player.Character
                        local hrp = char and char:FindFirstChild("HumanoidRootPart")
                        local humanoid = char and char:FindFirstChild("Humanoid")
                        if not hrp or not humanoid then return end
                        humanoid.AutoRotate = false
                        if not workspace.npcClick.Raid then return end

                        -- Fire dungeon item
                        game:GetService("ReplicatedStorage").Remotes.Inventory:FireServer("Orb Dungeon")

                        -- Click prompt
                        local prompt = workspace.npcClick.Raid:FindFirstChild("Prompt")
                        if prompt then prompt:Click() end

                        repeat task.wait(1) until workspace.DungeonRing:FindFirstChild("Pad")
                        hrp.CFrame = workspace.DungeonRing.Pad.CFrame

                        repeat task.wait(1) until #workspace.DunMob:GetChildren() > 0
                        for _, mob in pairs(workspace.DunMob:GetChildren()) do
                            if mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
                                local target = mob.HumanoidRootPart.Position + Vector3.new(0, 5, 0)
                                hrp.CFrame = CFrame.lookAt(target, mob.HumanoidRootPart.Position)
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
