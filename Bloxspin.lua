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
    Main = Window:AddTab({ Title = "Main", Icon = "" }),
    AutoFarm = Window:AddTab({ Title = "AutoFarm", Icon = "" }),
    Inf = Window:AddTab({ Title = "Inf", Icon = "" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local character = Player.Character or Player.CharacterAdded:Wait()
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

getgenv().af = false

Tabs.AutoFarm:AddToggle("af", {
    Title = "AutoFarm",
    Default = false,
    Callback = function(af)
        getgenv().af = af
         if af then
            task.spawn(function()
                while getgenv().af and task.wait(0.1) do
                for _, v in pairs(Workspace.Enemy.Mob:GetChildren()) do
                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                if v.Humanoid.Health > 0 then
            repeat
                task.wait(0.1)
     local hrp = game.Players.LocalPlayer.Character and 
            game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                 if hrp then
        local offset = CFrame.new(0, 0, 7)
            local lookDown = CFrame.Angles(math.rad(0), 0, 0)
                 hrp.CFrame = v.HumanoidRootPart.CFrame * offset * lookDown
                                   end
                    until v.Humanoid.Health <= 0 or not getgenv().af
                                        end
                                    end
                                end
                            end
                         end)
                    end
                end})

getgenv().atk = false

Tabs.Main:AddToggle("atk", {
    Title = "Auto Attack",
    Default = false,
    Callback = function(atk)
        getgenv().atk = atk
        if atk then
            task.spawn(function()
                while getgenv().atk and task.wait(0.1) do
                    local slotID
                    if LocalPlayer.CharValue and LocalPlayer.CharValue.Slot1 and LocalPlayer.CharValue.Slot1.ID then
                        slotID = LocalPlayer.CharValue.Slot1.ID.Value
                    end
                    if slotID then
                        for i = 1, 3 do
                            ReplicatedStorage.Events.Combat:FireServer(slotID, i)
                            task.wait(0.1)
                        end
                    end
                end
            end)
        end
    end
})
