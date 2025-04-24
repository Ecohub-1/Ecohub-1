
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
    Other = Window:AddTab({ Title = "Other", Icon = "candy" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" }),
}

local Options = SaveManager:SetLibrary(Fluent)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local AutoVote = Tabs.Game:AddToggle("Autovote", { Title = "Auto Vote", Default = false })
local voteValue = ReplicatedStorage:WaitForChild("Player_Data"):WaitForChild(player.Name):WaitForChild("Data"):WaitForChild("Vote")
local autoVoteLoop = false

AutoVote:OnChanged(function(value)
    autoVoteLoop = value
end)

task.spawn(function()
    while true do
        if autoVoteLoop and not voteValue.Value then
            ReplicatedStorage.Remote.Server.OnGame.Voting.VotePlaying:FireServer()
        end
        task.wait(2)
    end
end)

local AutoPlay = Tabs.Game:AddToggle("AutoPlay", { Title = "Auto Play", Default = false })
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

local AutoYen = Tabs.Game:AddToggle("AutoYen", { Title = "Auto Yen", Default = false })
local running = false

AutoYen:OnChanged(function(value)
    running = value
    if running then
        task.spawn(function()
            while running do
                ReplicatedStorage.Remote.Server.Gameplay.StatsManager:FireServer("MaximumYen")
                task.wait(3)
            end
        end)
    end
end)

Options.AutoYen:SetValue(false)

Tabs.Game:AddSection("End Game")

local voteNextRemote = ReplicatedStorage.Remote.Server.OnGame.Voting.VoteNext
local AutoNext = Tabs.Game:AddToggle("AutoNext", { Title = "Auto Next", Default = false })
local nextButtonConnection

AutoNext:OnChanged(function(value)
    if value then
        local nextButton = player:WaitForChild("PlayerGui")
            :WaitForChild("RewardsUI")
            .Main.LeftSide.Button:WaitForChild("Next")

        nextButtonConnection = nextButton.MouseButton1Click:Connect(function()
            voteNextRemote:FireServer()
        end)
    else
        if nextButtonConnection then
            nextButtonConnection:Disconnect()
            nextButtonConnection = nil
        end
    end
end)

Options.AutoNext:SetValue(false)
