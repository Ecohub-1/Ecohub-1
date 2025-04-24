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
local AuV = Tabs.Main:AddToggle("AuV", {Title = "Auto Vote", Default = false})

-- Task loop
local autoVoteRunning = false

AuV:OnChanged(function(value)
    if value and not autoVoteRunning then
        autoVoteRunning = true

        task.spawn(function()
            while value do
                local success, voteButton = pcall(function()
                    return player.PlayerGui.HUD.InGame.VotePlaying.Frame.Vote
                end)

                if success and voteButton and voteButton.Visible then
                    voteRemote:FireServer()
                end

                task.wait(1)
            end

            autoVoteRunning = false
        end)
    elseif not value then
        autoVoteRunning = false
    end
end)

local player = game:GetService("Players").LocalPlayer
local unitsFolder = player.UnitsFolder

-- Function to upgrade each unit
local function upgradeUnit(unit)
    -- Make sure the unit is a Model and has a valid Upgrade method or part
    if unit:IsA("Model") then
        local args = { unit }
        game:GetService("ReplicatedStorage").Remote.Server.Units.Upgrade:FireServer(unpack(args))
    end
end


local AutoUpgrade = Tabs.Game:AddToggle("AutoUpgrade", {Title = "Auto Upgrade", Default = false})

AutoUpgrade:OnChanged(function()
    if AutoUpgrade.Value then
        -- Iterate over all units and upgrade them if AutoUpgrade is on
        for _, unit in pairs(unitsFolder:GetChildren()) do
            upgradeUnit(unit)
        end
    end
end)


AutoUpgrade:SetValue(false)
