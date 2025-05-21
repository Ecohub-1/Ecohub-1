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


getgenv().eq = false
getgenv().SelectedWeaponTypes = {}

Tabs.Settings:AddDropdown("Search weapon", {
    Title = "Search Weapon",
    Values = { "Melee", "Sword", "DevilFruit", "Special" },
    Multi = true,
    Default = {},
    Callback = function(selection)
        getgenv().SelectedWeaponTypes = selection
    end
})

Tabs.Settings:AddToggle("eq", {
    Title = "Auto Equip",
    Default = false,
    Callback = function(eq)
        getgenv().eq = eq

        if eq then 
            task.spawn(function()
                while getgenv().eq and task.wait(0.1) do
                    for _, v in ipairs(Backpack:GetChildren()) do
                        local typeValue = v:FindFirstChild("Type")
                        if v:IsA("Tool") and typeValue and table.find(getgenv().SelectedWeaponTypes, typeValue.Value) then
                            v.Parent = Player.Character
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

local Haki = Tabs.Main:AddToggle("AutoHaki", {
    Title = "Auto Haki",
    Default = false
})

local function pressHaki()
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.J, false, game)
    task.wait(0.1)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.J, false, game)
end

spawn(function()
    while task.wait(5) do
        if env.b and Player.Character then
            pressHaki()
        end
    end
end)

Haki:OnChanged(function(value)
    env.b = value
    if value and Player.Character then
        pressHaki()
    end
end)

Player.CharacterAdded:Connect(function(character)
    task.wait(2)
    if env.b and character then
        pressHaki()
    end
end)

Tabs.Settings:AddSection("Auto Stast")

local Typeup = {}
getgenv().st = false
local upin = 1000

Tabs.Main:AddInput("upin", {
    Title = "Up stats",
    Default = "1000",
    Numeric = true,
    Finished = true,
    Callback = function(e)
        upin = tonumber(e) or 1000
    end
})

Tabs.Settings:AddDropdown("Typeup", {
    Title = "Search stats",
    Values = {"Melee", "Sword", "Defense", "DevilFruit", "Special"},
    Multi = true,
    Default = {},
    Callback = function(v)
        Typeup = v
    end
})

Tabs.Settings:AddToggle("st", {
    Title = "Auto Stats",
    Default = false,
    Callback = function(st)
        getgenv().st = st
        if st then
            task.spawn(function()
                while getgenv().st do
                    for _, stat in ipairs(Typeup) do
                        ReplicatedStorage.Remotes.System:FireServer("UpStats", stat, upin)
                    end
                    task.wait(0.1)
                end
            end)
        end
    end
})
