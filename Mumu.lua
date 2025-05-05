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
    AutoFarm = Window:AddTab({ Title = "AutoFarm", Icon = "" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Backpack = Player:WaitForChild("Backpack")
local character = Player.Character or Player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Services = ReplicatedStorage.Packages.Knit.Services
local plotService = Services.PlotService.RE
local OreServiceRE = ReplicatedStorage.Packages.Knit.Services.OreService.RE
local Ore = OreServiceRE.RequestRandomOre
local Sell = OreServiceRE.SellAll
-- ขุดควย
local autoDrill = false

Tabs.AutoFarm:AddToggle("AD", {
    Title = "Auto Drill",
    Default = false,
    Callback = function(C)
        autoDrill = C
        if C then
            task.spawn(function()
                while autoDrill do
                    pcall(function()
                        Ore:FireServer()
                    end)
                    task.wait(0.001)
                end
            end)
        end
    end
})

local AS = Tabs.AutoFarm:AddToggle("AS", {
    Title = "Auto Sell",
    Default = false
})

AS:OnChanged(function()
    if AS.Value then
        task.spawn(function()
            while AS.Value do
                local OCF = hrp.CFrame
                local SC = CFrame.new(-385, 93, 282)
                hrp.CFrame = SC
                task.wait(0.5)
                Sell:FireServer()
                task.wait(0.3)
                hrp.CFrame = OCF
                task.wait(0.3)
            end
        end)
    end
end)


local ACC = false

Tabs.AutoFarm:AddToggle("AC", {
    Title = "Auto Collect",
    Default = false,
    Callback = function(C)
        ACC = C
        print("Auto Collect Toggle:", ACC)

        if ACC then
            task.spawn(function()
                while ACC do
                    for _, plot in ipairs(workspace:WaitForChild("Plots"):GetChildren()) do
                        local owner = plot:FindFirstChild("Owner")
                        local drillsFolder = plot:FindFirstChild("Drills")

                        if owner and owner:IsA("ObjectValue") and owner.Value == Player and drillsFolder then
                            for _, drill in ipairs(drillsFolder:GetChildren()) do
                                if drill:IsA("Model") then
                                    print("Collecting from:", drill.Name)
                                    plotService:WaitForChild("CollectDrill"):FireServer(drill)
                                end
                            end
                        end
                    end
                    task.wait(0.1)
                end
            end)
        end
    end
})


Tabs.AutoFarm:AddSection("Auto lock")

local lk = {}
for _, Ores in pairs(ReplicatedStorage.Ores:GetChildren()) do
    if Ores:IsA("Model") then
       table.insert(lk, Ores.Name)
   end
end

Tabs.AutoFarm:AddMultiDropdown("lock", {
    Title = "Auto lock",
    Values = lk,
    Multi = true
    })

-- local autol = {}
-- for _, O in pairs(game:GetService("Players").LocalPlayer.Backpack:GetChildren()) do
-- if  
-- end
