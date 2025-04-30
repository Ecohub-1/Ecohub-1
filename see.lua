
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Eco Hub" .. Fluent.Version,
    SubTitle = " | by zer09Xz",
    TabWidth = 150,
    Size = UDim2.fromOffset(580, 400),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "house" }),
    Dungeon = Window:AddTab({ Title = "Auto Dungeon", Icon = "radar" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" }),
    misc = Window:AddTab({ Title = "misc", Icon = "align-justify" })
}

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local backpack = player:WaitForChild("Backpack")

local autoEquipRunning = false
local selectedType = "Melee"

local function autoEquip()
    if not autoEquipRunning then return end
    for _, tool in ipairs(backpack:GetChildren()) do
        if tool:IsA("Tool") then
            if selectedType == "Melee" then
                if tool:FindFirstChild("Type") and tool.Type.Value == "Melee" then
                    tool.Parent = player.Character
                    break
                end
            elseif tool:FindFirstChild("Type") and tool.Type.Value == selectedType then
                tool.Parent = player.Character
            end
        end
    end
end

local function stopAutoEquip()
    autoEquipRunning = false
end

Tabs.Settings:AddDropdown("WeaponType", {
    Title = "SelectWeapon",
    Items = { "Melee", "Sword", "DevilFruit", "Special" },
    Default = "Melee",
    Callback = function(value)
        selectedType = value
        if autoEquipRunning then
            autoEquip()
        end
    end
})

local AutoEquip = Tabs.Settings:AddToggle("AutoEquipToggle", {
    Title = "Auto Equip",
    Default = false
})

AutoEquip:OnChanged(function(value)
    autoEquipRunning = value
    if value then
        autoEquip()
        backpack.ChildAdded:Connect(function(child)
            if child:IsA("Tool") then
                task.wait(0.1)
                if autoEquipRunning and child:FindFirstChild("Type") and child.Type.Value == selectedType then
                    if selectedType == "Melee" then
                        for _, equipped in ipairs(player.Character:GetChildren()) do
                            if equipped:IsA("Tool") and equipped ~= child and equipped:FindFirstChild("Type") and equipped.Type.Value == "Melee" then
                                equipped.Parent = backpack
                            end
                        end
                    end
                    child.Parent = player.Character
                end
            end
        end)
    else
        stopAutoEquip()
    end
end)

player.CharacterAdded:Connect(function()
    task.wait(1)
    if AutoEquip.Value then
        autoEquip()
    end
end)

Window:SelectTab(1)
SaveManager:LoadAutoloadConfig()
