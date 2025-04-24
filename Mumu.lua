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
    Main = Window:AddTab({ Title = "Auto Farm", Icon = "earth" }),
    Game = Window:AddTab({ Title = "Game", Icon = "gamepad-2" }),
    other = Window:AddTab({ Title = "other", Icon = "chart-column-decreasing" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" }),
}
local replicatedStorage = game:GetService("ReplicatedStorage")
local autoPlayRemote = replicatedStorage.Remote.Server.Units.AutoPlay
local autoPlayStatus = replicatedStorage:WaitForChild("Player_Data")
    :WaitForChild("LocalPlayer")
    :WaitForChild("Data")
    :WaitForChild("AutoPlay")

local AutoPlay = Tabs.Game:AddToggle("AutoPlayToggle", {
    Title = "AutoPlay",
    Default = autoPlayStatus.Value
})

AutoPlay:OnChanged(function(value)
    if value and autoPlayStatus.Value == false then
        autoPlayRemote:FireServer()
    end
end)

autoPlayStatus:GetPropertyChangedSignal("Value"):Connect(function()
    Options.AutoPlayToggle:SetValue(autoPlayStatus.Value)
end)

if autoPlayStatus.Value == false then
    autoPlayRemote:FireServer()
end
