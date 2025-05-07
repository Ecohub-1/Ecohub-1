local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Eco Hub" .. Fluent.Version,
    SubTitle = " | by zer09Xz",
    TabWidth = 150,
    Size = UDim2.fromOffset(580, 400),
    Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
})

local Tabs = {
    main = Window:AddTab({ Title = "main", Icon = "" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")


Tabs.main:AddButton({
    Title = "inf money",
    Description = "is op money",
    Callback = function()
            ReplicatedStorage.Remotes.AddRewardEvent:FireServer("Cash", 1/0)
    end
})

Tabs.main:AddButton({
    Title = "inf Gems",
    Description = "is op Gems",
    Callback = function()
      ReplicatedStorage.Remotes.AddRewardEvent:FireServer("Gems", 1/0)
    end
})


Tabs.main:AddInput("Gems", {
    Title = "Gems",
    Default = "0",
    Numeric = true,
    Finished = true,
    Callback = function(V)
    ReplicatedStorage.Remotes.AddRewardEvent:FireServer("Gems", tonumber(V))
    end
})

Tabs.main:AddInput("Cash", {
    Title = "Cash",
    Default = 0,
    Numeric = true,
    Finished = true,
    Callback = function(G)
    ReplicatedStorage.Remotes.AddRewardEvent:FireServer("Cash", tonumber(G))
    end
})
Tab:AddSection("Spin inf")
local selectedAmount = 1 

local gg = Tabs.main:AddDropdown{
    Title = "Free Spin",
    Values = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "10"},
    Callback = function(S)
        selectedAmount = tonumber(S)
    end
}

getgenv().SP = false
Tabs.main:AddToggle("SP", {
    Titile = "Auto Spin",
    Default = false,
    Callback = function(SP)
    getgenv().SP = SP
        if SP then
            while getgenv().SP and task.wait(1) do
                for i = 1, selectedAmount do
                        ReplicatedStorage.Remotes.SpinPrizeEvent:FireServer(1)
                        end
                    end
                end
        end
 })
