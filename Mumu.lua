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

local Autovote = Tabs.Main:AddToggle("Autovote", {Title = "Auto Vote", Default = false })
local voteFrame = game:GetService("Players").LocalPlayer.PlayerGui.HUD.InGame.VotePlaying.Frame.Vote
local remote = game:GetService("ReplicatedStorage").Remote.Server.OnGame.Voting.VotePlaying

Autovote:OnChanged(function()
    if Autovote.Value then
        while true do
            if voteFrame and voteFrame.Value == true then
                remote:FireServer()
            end
            wait(1)
        end
    end
end)

Options.Autovote:SetValue(false)

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

local AutoYen = Tabs.Main:AddToggle("AutoYen", {
    Title = "Auto Yen", 
    Default = false 
})

local running = false

AutoYen:OnChanged(function(value)
    running = value
    print("AutoYen changed:", value)

    if running then
        task.spawn(function()
            while running do
                game.ReplicatedStorage.Remote.Server.Gameplay.StatsManager:FireServer("MaximumYen")
                task.wait(3)
            end
        end)
    end
end)


Options.AutoYen:SetValue(false)

Tabs.Game:AddSection("End Game")

local player = game:GetService("Players").LocalPlayer
local replicatedStorage = game:GetService("ReplicatedStorage")
local voteNextRemote = replicatedStorage.Remote.Server.OnGame.Voting.VoteNext

local AutoNext = Tabs.Game:AddToggle("AutoNext", {Title = "AutoNext", Default = false})

local connection

AutoNext:OnChanged(function()
    if Options.MyToggle.Value then
        local nextValue = player:WaitForChild("PlayerGui")
            :WaitForChild("RewardsUI")
            .Main.LeftSide.Button:WaitForChild("Next")

        connection = nextValue:GetPropertyChangedSignal("Value"):Connect(function()
            if nextValue.Value == true then
                voteNextRemote:FireServer()
            end
        end)

        if nextValue.Value == true then
            voteNextRemote:FireServer()
        end
    else
        if connection then
            connection:Disconnect()
            connection = nil
        end
    end
end)

Options.AutoNext:SetValue(false)
