local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Eco Hub : Beaks" ,
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

local Toggle = Tabs.Main:AddToggle("AutoEquipRifle", {Title = "Auto Equip Rifle", Default = false })

local AutoEquipRifleEnabled = false

Toggle:OnChanged(function()
    AutoEquipRifleEnabled = Toggle.Value
    print("Auto Equip Rifle Toggle changed:", AutoEquipRifleEnabled)

    if AutoEquipRifleEnabled then
        for _, item in ipairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
            if item.Name:match("Rifle") then
                game.Players.LocalPlayer.Character.Humanoid:EquipTool(item)
                print("Equipped:", item.Name)
                break
            end
        end
    end
end)

Options.AutoEquipRifle:SetValue(false)

local ATF = false

local function AutoFarm()
    while ATF do
        if AutoEquipRifleEnabled then
            local equippedRifle = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if equippedRifle and equippedRifle.Name:match("Rifle") then
                print("Equipped Rifle:", equippedRifle.Name)
            else
                for _, item in ipairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                    if item.Name:match("Rifle") then
                        game.Players.LocalPlayer.Character.Humanoid:EquipTool(item)
                        print("Equipped:", item.Name)
                        break
                    end
                end
            end
        end

        local equippedRifle = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if equippedRifle and equippedRifle.Name:match("Rifle") then
            local args = {
                [1] = "BulletFired",
                [2] = equippedRifle,
                [3] = Vector3.new(492.4790954589844, 298.8387451171875, 173.68939208984375),
                [4] = "Dart"
            }

            game:GetService("ReplicatedStorage").Util.Net:FindFirstChild("RE/GunShootEvent"):FireServer(unpack(args))
            wait(0.1)
        end
    end
end

local Options = {
    AutoFarm = Tabs.AutoFarm:AddToggle("AutoFarmToggle", {
        Title = "Auto Farm",
        Default = false,
        Callback = function(Value)
            ATF = Value
            if ATF then
                AutoFarm()
            end
        end
    })
}
