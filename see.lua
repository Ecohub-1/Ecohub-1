local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Eco Hub " .. Fluent.Version,
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

local Options = Fluent.Options
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local backpack = player:WaitForChild("Backpack")

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")
InterfaceManager:BuildInterfaceSection(Tabs.misc)
SaveManager:BuildConfigSection(Tabs.misc)

-- ▼▼▼ Auto Click ▼▼▼
local autoClicking = false
local clickDelay = 0.1

Tabs.Settings:AddToggle("AutoClickToggle", {
    Title = "Auto Click",
    Default = false
}):OnChanged(function(value)
    autoClicking = value
end)

Tabs.Settings:AddInput("ClickDelayInput", {
    Title = "Click Delay",
    Default = "0.1",
    Placeholder = "Seconds",
    Numeric = true,
    Callback = function(text)
        local num = tonumber(text)
        if num and num > 0 then
            clickDelay = num
        end
    end
})

task.spawn(function()
    while true do
        if autoClicking then
            local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
            if tool then
                pcall(function()
                    tool:Activate()
                end)
            end
            task.wait(clickDelay)
        else
            task.wait(0.1)
        end
    end
end)
-- ▲▲▲ Auto Click ▲▲▲

-- ▼▼▼ Dropdown ประเภทอาวุธ ▼▼▼
local selectedOption = "Melee"

Tabs.Settings:AddDropdown("TypeDropdown", {
    Title = "Weapon Type",
    Values = { "Melee", "Sword", "DevilFruit", "Special" },
    Multi = false,
    Default = 1,
    Callback = function(value)
        selectedOption = value
        if equipToggle and equipToggle.Value then
            autoEquip()
        end
    end
})
-- ▲▲▲ Dropdown ประเภทอาวุธ ▲▲▲

-- ▼▼▼ Auto Equip ▼▼▼
local autoEquipRunning = false

local function autoEquip()
    if autoEquipRunning then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                local toolType = tool:GetAttribute("Type")
                if toolType and string.lower(toolType) == string.lower(selectedOption) then
                    if tool.Parent ~= player.Character then
                        tool.Parent = player.Character
                    end
                end
            end
        end
    end
end

local equipToggle = Tabs.Settings:AddToggle("AutoEquipToggle", {
    Title = "Auto Equip",
    Default = false
})

equipToggle:OnChanged(function()
    if equipToggle.Value then
        autoEquipRunning = true
        autoEquip()
        backpack.ChildAdded:Connect(function(child)
            if child:IsA("Tool") then
                task.wait(0.1)
                if autoEquipRunning then
                    local toolType = child:GetAttribute("Type")
                    if toolType and string.lower(toolType) == string.lower(selectedOption) then
                        if child.Parent ~= player.Character then
                            child.Parent = player.Character
                        end
                    end
                end
            end
        end)
    else
        autoEquipRunning = false
    end
end)

player.CharacterAdded:Connect(function()
    task.wait(1)
    if equipToggle.Value then
        autoEquip()
    end
end)
-- ▲▲▲ Auto Equip ▲▲▲

Window:SelectTab(1)

Fluent:Notify({
    Title = "Eco Hub",
    Content = "Script Loaded",
    Duration = 3
})

task.wait(3)

Fluent:Notify({
    Title = "Eco Hub",
    Content = "Ready!",
    Duration = 3
})

SaveManager:LoadAutoloadConfig()
