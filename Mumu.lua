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
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local BP = Player:WaitForChild("Backpack")
local CR = Player.Character or Player.CharacterAdded:Wait()

local AE = Tabs.Main:AddToggle("AE", {
 Title = "Auto Equip",
 Default = false
    })
local function AutoEquip()
    for _, e in pairs(BP:GetChildren()) do
        if e:IsA("Tool") and string.find(e.Name, "Drill") then
            if not CR:FindFirstChildOfClass("Tool") or CR:FindFirstChildOfClass("Tool") ~= e then
                e.Parent = CR
            end
        break
        end
    end
end

AE:OnChanged(function(E)
        if E then
            task.spawn(function()
                    while Options.AE.Value do
                        pcall(AutoEquip)
                        task.wait(0.1)
                    end
                end)
         end
    end)




-- ขุดควย
local autoDrill = false

Tabs.Main:AddToggle("AD", {
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
