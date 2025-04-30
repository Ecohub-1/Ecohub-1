

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
local selectedeq = "Melee" -- default

local selectedequip = Tabs.Settings:AddDropdown("selectedequip", {
    Title = "Selected Equip",
    Options = {"Melee", "Sword", "DevilFruit", "Special"},
    Multi = false,
    Default = "Melee"
})

selectedequip:OnChanged(function(value)
    selectedeq = value
end)

local AutoEquip = Tabs.Settings:AddToggle("AutoEquip", {
    Title = "AutoEquip",
    Default = false
})

AutoEquip:OnChanged(function(state)
    if state then
        task.spawn(function()
            while AutoEquip.Value do
                local backpack = game:GetService("Players").LocalPlayer:WaitForChild("Backpack")
                local character = game:GetService("Players").LocalPlayer.Character or game:GetService("Players").LocalPlayer.CharacterAdded:Wait()

                for _, tool in pairs(backpack:GetChildren()) do
                    if tool:IsA("Tool") then
                        if string.find(tool.Name:lower(), selectedeq:lower()) then
                            if not character:FindFirstChild(tool.Name) then
                                character.Humanoid:EquipTool(tool)
                            end
                            break
                        end
                    end
                end

                task.wait(0.2)
            end
        end)
    end
end)
