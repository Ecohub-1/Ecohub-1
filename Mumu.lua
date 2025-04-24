local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Eco Hub 1.0" ,
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
    other = Window:AddTab({ Title = "other", Icon = "candy" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" }),
}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = game.Players.LocalPlayer

local AutoPlay = Tabs.Game:AddToggle("AutoPlay", {
    Title = "Auto Play",
    Default = false
})

local autoPlayValue = ReplicatedStorage:WaitForChild("Player_Data"):WaitForChild(player.Name):WaitForChild("Data"):WaitForChild("AutoPlay")

local autoPlayLoop = false

AutoPlay:OnChanged(function(value)
    autoPlayLoop = value
end)

task.spawn(function()
    while true do
        if autoPlayLoop and not autoPlayValue.Value then
            ReplicatedStorage.Remote.Server.Units.AutoPlay:FireServer()
        end
        task.wait(2)
     end
end)
