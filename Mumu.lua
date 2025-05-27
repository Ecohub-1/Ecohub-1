local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Eco Hub",
    SubTitle = " | Rock Fruit",
    TabWidth = 150,
    Size = UDim2.fromOffset(580, 400),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    AutoFarm = Window:AddTab({ Title = "AutoFarm", Icon = "box" }),
    Dungeon = Window:AddTab({ Title = "Dungeon", Icon = "bookmark" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" }),
    other = Window:AddTab({ Title = "other", Icon = "banana" })
}

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Backpack = Player:WaitForChild("Backpack")
local character = Player.Character or Player.CharacterAdded:Wait()
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local VirtualUser = game:GetService("VirtualUser")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- ดีคับ
Fluent:Notify({
    Title = "ECO Dev",
    Content = "💞ยินดีตอนรับคับอ้วน💞\nมือใหม่หัดเขียน",
    Duration = 5
})
--ควย
local Distance = 23
local selectedMob = nil
local se = {}

local mobNames, mobSet = {}, {}
for _, mob in pairs(Workspace.Mob:GetChildren()) do
    if mob:IsA("Model") and not mobSet[mob.Name] then
        table.insert(mobNames, mob.Name)
        mobSet[mob.Name] = true
    end
end
selectedMob = mobNames[1]

Tabs.AutoFarm:AddDropdown("SM", {
    Title = "Select Mob",
    Values = mobNames,
    Multi = false,
    Default = 1,
    Callback = function(value)
        selectedMob = value
    end
})

Tabs.AutoFarm:AddToggle("AF", {
    Title = "Auto Farm",
    Default = false,
    Callback = function(state)
        getgenv().AF = state
        if state then
            task.spawn(function()
                while getgenv().AF and task.wait(0.01) do
                    for _, mob in pairs(workspace.Mob:GetChildren()) do
                        if mob.Name == selectedMob and mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
                            repeat
                                task.wait(0.01)
                                local hrp = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
                                if hrp then
                                    hrp.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, Distance, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                                end
                            until mob.Humanoid.Health <= 0 or not getgenv().AF
                        end
                    end
                end
            end)
        end
    end
})

Tabs.AutoFarm:AddInput("Distance", {
    Title = "Distance",
    Default = Distance,
    Numeric = true,
    Finished = true,
    Callback = function(Dis)
        Dis = tonumber(Dis)
        if Dis and Dis >= 1 and Dis <= 1000 then
            Distance = Dis
        end
    end
})

Tabs.AutoFarm:AddSection("Auto Boss")

Tabs.Settings:AddDropdown("se", {
    Title = "Select weapon",
    Values = {"Melee", "Sword", "DevilFruit", "Special"},
    Default = {},
    Multi = true,
    Callback = function(value)
        se = value
        if getgenv().equip then
            equip()
        end
    end
})

local function equip()
    for _, weaponName in ipairs(se) do
        local tool = Backpack:FindFirstChild(weaponName) or LocalPlayer.Character:FindFirstChild(weaponName)
        if tool then
            task.wait(0.4)
            LocalPlayer.Character.Humanoid:EquipTool(tool)
        end
    end
end

getgenv().equip = false
Tabs.Settings:AddToggle("equip", {
    Title = "Auto Equip",
    Default = false,
    Callback = function(state)
        getgenv().equip = state
        if state then
            task.spawn(function()
                while getgenv().equip do
                    equip()
                    task.wait(0.1)
                end
            end)
        end
    end
})

Tabs.Settings:AddSection("Auto Click")

getgenv().click = false
Tabs.Settings:AddToggle("click", {
    Title = "Auto Click",
    Default = false,
    Callback = function(click)
        getgenv().click = click
        if click then
            task.spawn(function()
                while getgenv().click and task.wait(0.1) do
                    VirtualUser:Button1Down(Vector2.new(0.9, 0.9))
                    VirtualUser:Button1Up(Vector2.new(0.9, 0.9))
                end
            end)
        end
    end
})

local env = getgenv()
env.b = false

local Haki = Tabs.Settings:AddToggle("AutoHaki", {
    Title = "Auto Haki",
    Default = false
})

local function pressHaki()
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.J, false, game)
    task.wait(0.1)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.J, false, game)
end

Haki:OnChanged(function(value)
    env.b = value
    if value and Player.Character then
        pressHaki()
    end
end)

Player.CharacterAdded:Connect(function(v)
    task.wait(2)
    if env.b then
        pressHaki()
    end
end)

Tabs.Settings:AddSection("Auto Skill")

getgenv().z = false
getgenv().x = false
getgenv().c = false
getgenv().v = false
getgenv().f = false

local keys = {
    z = Enum.KeyCode.Z,
    x = Enum.KeyCode.X,
    c = Enum.KeyCode.C,
    v = Enum.KeyCode.V,
    f = Enum.KeyCode.F,
}

for keyName, keyCode in pairs(keys) do
    Tabs.Settings:AddToggle(keyName, {
        Title = "Auto Skill: " .. keyName:upper(),
        Default = false,
        Callback = function(state)
            getgenv()[keyName] = state
            if state then
                task.spawn(function()
                    while getgenv()[keyName] and task.wait(0.5) do
                        VirtualInputManager:SendKeyEvent(true, keyCode, false, game)
                        VirtualInputManager:SendKeyEvent(false, keyCode, false, game)
                    end
                end)
            end
        end
    })
end

Tabs.Dungeon:AddSection("Auto Dungeon")

getgenv().Dungeon = false
getgenv().SafeHPPercent = 20

-- Input สำหรับ HP Threshold
Tabs.Dungeon:AddInput("HPThresholdInput", {
    Title = "HP% Threshold (1–100)",
    Default = tostring(getgenv().SafeHPPercent),
    Placeholder = "Enter a value between 1 and 100",
    Numeric = true,
    Callback = function(value)
        local number = tonumber(value)
        if number and number >= 1 and number <= 100 then
            getgenv().SafeHPPercent = math.floor(number)
        else
            Fluent:Notify({
                Title = "Invalid Input",
                Content = "❌ Please enter a number between 1 and 100.",
                Duration = 5
            })
        end
    end
})

-- Toggle สำหรับ Auto Dungeon
Tabs.Dungeon:AddToggle("Dungeon", {
    Title = "Auto Dungeon",
    Default = false,
    Callback = function(enabled)
        getgenv().Dungeon = enabled
        if not enabled then return end

        task.spawn(function()
            local RunService = game:GetService("RunService")
            local player = game.Players.LocalPlayer
            local dunMobFolder = workspace:WaitForChild("DunMob")

            while getgenv().Dungeon do
                local character = player.Character
                local hrp = character and character:FindFirstChild("HumanoidRootPart")
                local humanoid = character and character:FindFirstChild("Humanoid")

                if humanoid and hrp then
                    local hpPercent = (humanoid.Health / humanoid.MaxHealth) * 100
                    if hpPercent <= getgenv().SafeHPPercent then
                        hrp.CFrame = hrp.CFrame + Vector3.new(0, 100, 0)
                        task.wait(1)
                        continue
                    end
                end

                for _, mob in ipairs(dunMobFolder:GetChildren()) do
                    local mobHumanoid = mob:FindFirstChild("Humanoid")
                    local mobHRP = mob:FindFirstChild("HumanoidRootPart")

                    if mobHumanoid and mobHumanoid.Health > 0 and mobHRP and hrp then
                        repeat
                            RunService.Heartbeat:Wait()
                            if not getgenv().Dungeon then break end
                            hrp.CFrame = mobHRP.CFrame * CFrame.new(0, Distance or 0, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                        until mobHumanoid.Health <= 0 or not getgenv().Dungeon
                    end
                end

                task.wait(0.1)
            end
        end)
    end
})

-- ปุ่ม Teleport ไป Dungeon
Tabs.Dungeon:AddButton("inf", {
    Title = "Teleport to Dungeon",
    Callback = function()
        local placeId = 138317269457177
        game:GetService("TeleportService"):Teleport(placeId)
    end
})
