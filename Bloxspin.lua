local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Eco Hub 1.0",
    SubTitle = " | by zer09Xz",
    TabWidth = 150,
    Size = UDim2.fromOffset(580, 400),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Auto Farm", Icon = "bookmark" }),
    Game = Window:AddTab({ Title = "Game", Icon = "gamepad-2" }),
    Other = Window:AddTab({ Title = "Other", Icon = "Banana" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" }),
}
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer


getgenv().AV = false
Tabs.Game:AddToggle("ATV", {
    Title = "Auto Vote",
    Default = false,
    Callback = function(V)
        getgenv().AV = V
         if V then
        spawn(function()
            while getgenv().AV and task.wait(1) do
ReplicatedStorage.Remote.Server.OnGame.Voting.VotePlaying:FireServer()
                  end
             end)
         end
    end
})

getgenv().AP = false

Tabs.Game:AddToggle("AP", {
    Title = "Auto Play",
    Default = false,
    Callback = function(P)
        getgenv().AP = P
        if P then
            spawn(function()
                while getgenv().AP and task.wait(1) do
                    local autoPlay = ReplicatedStorage:WaitForChild("Player_Data"):WaitForChild(player.Name):WaitForChild("Data"):WaitForChild("AutoPlay")
                    if autoPlay.Value == false then
                        ReplicatedStorage.Remote.Server.Units.AutoPlay:FireServer()
                    end
                end
            end)
        end
    end
})

getgenv().MY = false
Tabs.Game:AddToggle("ATV", {
    Title = "Auto stats",
    Default = false,
    Callback = function(Y)
        getgenv().MY = Y
         if Y then
        spawn(function()
            while getgenv().MY and task.wait(0.61) do
ReplicatedStorage.Remote.Server.Gameplay.StatsManager:FireServer("MaximumYen")
                  end
             end)
         end
    end
})

local UnitUp = {}
for _, P in pairs(game:GetService("Players").LocalPlayer.UnitsFolder:GetChildren()) do 
    table.insert(UnitUp, P.Name)
    end

getgenv().AU = false

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

getgenv().AU = false

Tabs.Game:AddToggle("AU", {
    Title = "Auto Upgrade",
    Default = false,
    Callback = function(U)
        getgenv().AU = U
        if U then
            spawn(function()
                while getgenv().AU and task.wait(0.5) do
                    for _, unit in ipairs(player.UnitsFolder:GetChildren()) do
                        ReplicatedStorage.Remote.Server.Units.Upgrade:FireServer(unit)
                    end
                end
            end)
        end
    end
})
