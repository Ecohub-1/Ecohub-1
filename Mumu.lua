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
    Dungeon = Window:AddTab({ Title = "Dungeon", Icon = "bookmark" }),
    Webhook = Window:AddTab({ Title = "Webhook", Icon = "banana" }),
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
    Callback = function(v)
        getgenv().AF = v
        if v then
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
Player.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
             if hrp then
                local offset = CFrame.new(0, 20, 0)
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
Tabs.Settings:AddToggle("z", {
    Title = "Auto skill Z",
    Default = false,
    Callback = function(z)
        getgenv().z = z
             if z then
                task.spawn(function()
                        while getgenv().z and task.wait(0.5) do
                            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Z, false, game)
                            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Z, false, game)
                        end
                    end)
                end
            end
        })

getgenv().x = false
Tabs.Settings:AddToggle("x", {
    Title = "Auto skill X",
    Default = false,
    Callback = function(x)
        getgenv().x = x
             if x then
                task.spawn(function()
                        while getgenv().x and task.wait(0.5) do
                            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.X, false, game)
                            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.X, false, game)
                        end
                    end)
                end
            end
        })

getgenv().c = false
Tabs.Settings:AddToggle("c", {
    Title = "Auto skill C",
    Default = false,
    Callback = function(c)
        getgenv().c = c
             if c then
                task.spawn(function()
                        while getgenv().c and task.wait(0.5) do
                            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.C, false, game)
                            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.C, false, game)
                        end
                    end)
                end
            end
        })

getgenv().v = false
Tabs.Settings:AddToggle("v", {
    Title = "Auto skill V",
    Default = false,
    Callback = function(v)
        getgenv().v = v
             if v then
                task.spawn(function()
                        while getgenv().v and task.wait(0.5) do
                            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.V, false, game)
                            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.V, false, game)
                        end
                    end)
                end
            end
        })

getgenv().f = false
Tabs.Settings:AddToggle("f", {
    Title = "Auto skill F",
    Default = false,
    Callback = function(f)
        getgenv().f = f
             if f then
                task.spawn(function()
                        while getgenv().f and task.wait(0.5) do
                            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
                            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
                        end
                    end)
                end
            end
        })

