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
local BP = Player:WaitForChild("Backpack")
local character = Player.Character or Player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
local plotService = ReplicatedStorage.Packages.Knit.Services.PlotService.RE

--มีไมไม่รู้
local AE = Tabs.AutoFarm:AddToggle("AE", {
 Title = "Auto Equip",
 Default = false
    })
local function AutoEquip()
    for _, e in pairs(BP:GetChildren()) do
        if e:IsA("Tool") and string.find(e.Name, "Drill") then
            if not character:FindFirstChildOfClass("Tool") or character:FindFirstChildOfClass("Tool") ~= e then
                e.Parent = character
            end
        break
        end
    end
end

AE:OnChanged(function(E)
        if E then
            task.spawn(function()
                    while AutoEquip do
                        pcall(AutoEquip)
                        task.wait(0.1)
                    end
                end)
         end
    end)




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
                        game:GetService("ReplicatedStorage").Packages.Knit.Services.OreService.RE.RequestRandomOre:FireServer()
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
            game:GetService("ReplicatedStorage").Packages.Knit.Services.OreService.RE.SellAll:FireServer()
            task.wait(0.3)
            hrp.CFrame = OCF
            task.wait(0.3)
        end
    end)
        end
    end)

local collect = false

local autocollect = Tabs.AutoFarm:AddToggle("AC",{
    Title = "Auto Collect",
    Default = false,
    })
autocollect:OnChanged(function()
    collect = Options.AC.Value
        if collect then
            task.spawn(function()
                    while collect do
    for _,v in ipairs(workspace.Plots:GetChildren()) do
       if v:FindFirstChild("Owner")  and v.Owner.Value == player then
        local drillsFolder = v:FindFirstChild("Drills")
                                if drillsFolder then
    for _,v in ipairs(drillsFolder:GetChildren()) do
                        if v:IsA("Model") then
                plotService:CollectDrill(v)
                            task.wait(1)
                                            end
                                        end
                                    end
                                break
                                end
                            end
                        end
                    end)
                end
            end)
