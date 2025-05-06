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
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VotePlay = ReplicatedStorage.Remote.Server.OnGame.Voting.VotePlaying:FireServer()



local AVP = false
Tabs.Game:AddToggle("AVP", {
   Title = "Auto VotePlay",
   Default = false, 
   Callback = function(V)
    getgenv().AVP = V
        if AVP then
            while task.wait(1) do
        local inGame = player:WaitForChild("PlayerGui"):WaitForChild("HUD"):WaitForChild("InGame")
        local votePlaying = inGame:WaitForChild("VotePlaying")
         if votePlaying:IsA("GuiObject") and votePlaying.Visible then
                     VotePlay:FireServer()
                    end
                end
            end
        end
    })
