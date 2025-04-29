
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
Title = "Eco Hub",
SubTitle = " | Rock Fruit",
TabWidth = 150,
Size = UDim2.fromOffset(580, 400),
Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
Theme = "Dark",
MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
})

local Tabs = {
Main = Window:AddTab({ Title = "Main", Icon = "" }),
Autoboss = Window:AddTab({ Title = "Boss", Icon = "" }),
Dungeon = Window:AddTab({ Title = "Dungeon", Icon = "" }), Settings = Window:AddTab({ Title = "Settings", Icon = "settings" }),
Misc = Window:AddTab({ Title = "Misc", Icon = "" }),
}

local loo = "Melee"
local autoEquipEnabled = false

local equipsh = Tabs.Settings:AddDropdown({ 
    Name = "EquipSearch", 
    Title = "Equip Search", 
    Values = {"Melee", "Sword", "DevilFruit", "Special"},
    Multi = false
})

equipsh:OnChanged(function(oi)
    loo = oi 
end)

Tabs.Settings:AddToggle("Autoequip", {
    Title = "Auto Equip",
    Default = false,
    Callback = function(val)
        autoEquipEnabled = val
        task.spawn(function()
            while autoEquipEnabled do
                local player = game:GetService("Players").LocalPlayer
                local backpack = player:WaitForChild("Backpack")

                for _, tool in ipairs(backpack:GetChildren()) do
                    if tool:IsA("Tool") then
                        local itemType = tool:GetAttribute("Type")
                        if itemType == loo then
                            tool.Parent = player.Character
                        end
                    end
                end

                task.wait(0.5) -- Adjust delay as needed
            end
        end)
    end
})
