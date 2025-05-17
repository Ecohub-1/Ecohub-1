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

local allowedType = {"Melee", "Sword", "DevilFruit", "Special"}
local selectedType = {}


local TypeDropdown = Tabs.Settings:AddDropdown("WeaponTypes", {
    Title = "Select Weapon",
    Values = allowedTypes,
    Default = {},
    Multi = true,
    Callback = function(type)
        selectedTypes = type
        print("Selected type:", table.concat(selectedType, ", "))
    end
})

getgenv().E = false
Tabs.Settings:AddToggle("E", {
    Title = "Auto Equip",
    Default = false,
    Callback = function(E)
        getgenv().E = E
        if E then
            task.spawn(function()
                while getgenv().E and task.wait(0.2) do
                    for _, tool in pairs(Backpack:GetChildren()) do
                        if tool:IsA("Tool") and tool:FindFirstChild("Type") then
                            print("Checking tool:", tool.Name)
                            print("Tool type:", tool.Type.Value)

                            if table.find(selectedTypes, tool.Type.Value) then
                                local humanoid = character:FindFirstChildOfClass("Humanoid")
                                if humanoid then
                                    print("Equipping:", tool.Name)
                                    humanoid:EquipTool(tool)
                                    break
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
})

