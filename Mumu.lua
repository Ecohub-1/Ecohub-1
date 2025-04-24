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

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local voteRemote = ReplicatedStorage.Remote.Server.OnGame.Voting.VotePlaying
local player = Players.LocalPlayer

-- UI Toggle
local AuV = Tabs.Game:AddToggle("AutoVote", {Title = "Auto Vote", Default = false})

-- Task loop
local autoVoteRunning = false

AuV:OnChanged(function()
    local enabled = Options.AutoVote.Value
    if enabled and not autoVoteRunning then
        autoVoteRunning = true
        task.spawn(function()
            while Options.AutoVote.Value do
                local success, voteButton = pcall(function()
                    return player.PlayerGui.HUD.InGame.VotePlaying.Frame.Vote
                end)

                if success and voteButton and voteButton.Visible then
                    voteRemote:FireServer()  
                end

                task.wait(2)  
            end

            autoVoteRunning = false
        end)
    end
end)
