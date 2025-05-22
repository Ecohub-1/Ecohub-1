local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Eco Hub" .. Fluent.Version,
    SubTitle = " | Rock Fruit",
    TabWidth = 150,
    Size = UDim2.fromOffset(580, 400),
    Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
})

local Tabs = {
    AutoFarm = Window:AddTab({ Title = "AutoFarm", Icon = "box" }),
    boss = Window:AddTab({ Title = "boss", Icon = "compass" }),
    Dungeon = Window:AddTab({ Title = "Dungeon", Icon = "bookmark" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" }),
    other = Window:AddTab({ Title = "other", Icon = "banana" })
}

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Backpack = Player:WaitForChild("Backpack")
local character = Player.Character or Player.CharacterAdded:Wait()
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local VirtualUser = game:GetService("VirtualUser")
local VirtualInputManager = game:GetService("VirtualInputManager")

local mobNames = {}
local mobSet = {}

for _, mob in pairs(Workspace.Mob:GetChildren()) do
    if mob:IsA("Model") and not mobSet[mob.Name] then
        table.insert(mobNames, mob.Name)
        mobSet[mob.Name] = true
    end
end

local selectedMob = mobNames[1]

local mobDropdown = Tabs.AutoFarm:AddDropdown("SM", {
    Title = "Select Mob",
    Values = mobNames,
    Multi = false,
    Default = 1
})

mobDropdown:OnChanged(function(value)
    selectedMob = value
end)

getgenv().AF = false

Tabs.AutoFarm:AddToggle("AF", {
    Title = "Auto Farm",
    Default = false,
    Callback = function(state)
        getgenv().AF = state
        if state then
            task.spawn(function()
                while getgenv().AF and task.wait(0.01) do
                    for _, mob in pairs(Workspace.Mob:GetChildren()) do
                        if mob.Name == selectedMob and 
                           mob:FindFirstChild("Humanoid") and 
                           mob:FindFirstChild("HumanoidRootPart") and 
                           mob.Humanoid.Health > 0 then

                            repeat
                   task.wait(0.01)
 local hrp = game.Players.LocalPlayer.Character and 
           game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
             if hrp then
                local offset = CFrame.new(0, 30, 0)
                local lookDown = CFrame.Angles(math.rad(-90), 0, 0)
                hrp.CFrame = mob.HumanoidRootPart.CFrame * offset * lookDown
                             end
                until mob.Humanoid.Health <= 0 or not getgenv().AF
                        end
                    end
                end
           end)
        end
    end
})


local selectedWeapons = {}
local dropdown

local function updateWeaponDropdown()
    local eq = {}

    for _, v in pairs(Backpack:GetChildren()) do
        if v:IsA("Tool") then
            table.insert(eq, v.Name)
        end
    end

    for _, v in pairs(character:GetChildren()) do
        if v:IsA("Tool") then
            table.insert(eq, v.Name)
        end
    end

    if dropdown then
        dropdown:SetValues(eq)
    else
        dropdown = Tabs.Settings:AddDropdown("eq", {
            Title = "Select weapon",
            Values = eq,
            Default = {},
            Multi = true,
            Callback = function(selected)
                selectedWeapons = selected
                print("Selected Weapons:", table.concat(selectedWeapons, ", "))
            end
        })
    end
end

updateWeaponDropdown()

Backpack.ChildAdded:Connect(updateWeaponDropdown)
Backpack.ChildRemoved:Connect(updateWeaponDropdown)
character.ChildAdded:Connect(updateWeaponDropdown)
character.ChildRemoved:Connect(updateWeaponDropdown)

getgenv().equip = false
Tabs.Settings:AddToggle("equip", {
    Title = "Auto Equip",
    Default = false,
    Callback = function(state)
        getgenv().equip = state
        if state then
            task.spawn(function()
                while getgenv().equip do
                    task.wait(0.1)
                    for _, tool in pairs(Backpack:GetChildren()) do
                        if tool:IsA("Tool") and table.find(selectedWeapons, tool.Name) then
                            print("Equipping:", tool.Name)
                            tool.Parent = character
                        end
                    end
                    for _, tool in pairs(character:GetChildren()) do
                        if tool:IsA("Tool") and not table.find(selectedWeapons, tool.Name) then
                            print("Unequipping:", tool.Name)
                            tool.Parent = Backpack
                        end
                    end
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

Tabs.Settings:AddSection("Auto Stast")

local StatValues = {
    Melee = 10000,
    Sword = 10000,
    Defense = 10000,
    DevilFruit = 10000,
    Special = 10000,
}

local function createStatControl(statName)
    Tabs.Settings:AddInput(statName .. "Input", {
        Title = statName .. " Value",
        Default = "10000",
        Placeholder = "",
        Numeric = true,
        Callback = function(value)
            StatValues[statName] = tonumber(value) or 10000
        end
    })

    getgenv()[statName] = false
    Tabs.Settings:AddToggle(statName .. "Toggle", {
        Title = "Auto Stat " .. statName,
        Default = false,
        Callback = function(state)
            getgenv()[statName] = state
            if state then
                task.spawn(function()
                    while getgenv()[statName] and task.wait(0.1) do
                        ReplicatedStorage.Remotes.System:FireServer("UpStats", statName, StatValues[statName])
                    end
                end)
            end
        end
    })
end

createStatControl("Melee")
createStatControl("Sword")
createStatControl("Defense")
createStatControl("DevilFruit")
createStatControl("Special")
