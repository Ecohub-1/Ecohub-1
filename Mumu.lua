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

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

local AutoNext = Tabs.Main:AddToggle("AutoVoteNext", {
    Title = "Auto Vote Next",
    Default = false
})

AutoNext:OnChanged(function()
    if Options.AutoVoteNext.Value then
        task.spawn(function()
            while Options.AutoVoteNext.Value do
                local RewardsUI = player:FindFirstChild("PlayerGui"):FindFirstChild("RewardsUI")
                if RewardsUI then
                    local NextButton = RewardsUI:FindFirstChild("Main")
                        and RewardsUI.Main:FindFirstChild("LeftSide")
                        and RewardsUI.Main.LeftSide:FindFirstChild("Button")
                        and RewardsUI.Main.LeftSide.Button:FindFirstChild("Next")

                    if NextButton and NextButton.Visible then
                        NextButton:Click()
                        ReplicatedStorage.Remote.Server.OnGame.Voting.VoteNext:FireServer()
                        task.wait(1)
                    end
                end
                task.wait(0.5)
            end
        end)
    end
end)
