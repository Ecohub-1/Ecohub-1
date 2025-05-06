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

local mob = {}
local moblist = {}
local SM = nil
   for _, m in pairs(game:GetService("Workspace").Mob:GetChildren()) do
    if m:IsA("Model") and moblist[m.Name] == nil then
    table.insert(mob, m.Name)
    moblist[m.Name] = true
       end
    end
Tabs.AutoFarm:AddDropdown("SM", {
    Title = "Select Mob",
    Values = mob,
    Multi = false,
    Default = 1
    })

local AF = false
 Tabs.AutoFarm:AddToggle("AF", {
    Title = "Auto Farm",
    Default = AF,
    Callback = function(A)
    getgenv().AF = A
            if A then
            task.spawn(function()
                while task.wait(0.01) do
                    for _,v in pairs(game:GetService("Workspace").Mob:GetChildren()) do
                        if v.Name == SM and v:FindFirstChild("humanoid") and v:FindFirstChild("HumanoidRootPart") then
                     if v.humanoid.Health > 0 then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0,30,0)  
                            end
                        end
                    end                           
                end             
            end)
        end
    end
})
