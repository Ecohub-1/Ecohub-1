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
   Aimbot = Window:AddTab({ Title = "Aimbot", Icon = "" }),
   Weapon = Window:AddTab({ Title = "Weapon", Icon = "" }),
   ESP = Window:AddTab({ Title = "ESP", Icon = "" }),
  Player = Window:AddTab({ Title = "Player", Icon = "" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}
local player = game.Players.LocalPlayer
local backpack = player.Backpack

local maxRange = 50
local maxSpeed = 10

local Dropdown = Tabs.Weapon:AddDropdown("ItemDropdown", {
    Title = "Select Item",
    Values = {},
    Multi = false,
    Default = 1,
})

local Toggle = Tabs.Weapon:AddToggle("MyToggle", {
    Title = "Enable Adjustments",
    Default = false,
})

local function refreshItemNames()
    local itemNames = {}
    for _, item in ipairs(backpack:GetChildren()) do
        table.insert(itemNames, item.Name)
    end
    Dropdown:SetValues(itemNames)
    if #itemNames > 0 then
        Dropdown:SetValue(itemNames[1])
    end
end

Tabs.Weapon:AddButton({
    Title = "Refresh Items",
    Callback = refreshItemNames,
})

refreshItemNames()

local RangeInput = Tabs.Weapon:AddInput("RangeInput", {
    Title = "Range",
    Default = "10",
    Placeholder = "Enter Range",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        local newRange = tonumber(Value)
        if not newRange then return end
        if newRange > maxRange then return end
        if Toggle.Value then
            local item = backpack:FindFirstChild(Dropdown.Value)
            if item and item:GetAttribute("Range") ~= nil then
                item:SetAttribute("Range", newRange)
            end
        end
    end
})

local SpeedInput = Tabs.Weapon:AddInput("SpeedInput", {
    Title = "Speed",
    Default = "5",
    Placeholder = "Enter Speed",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        local newSpeed = tonumber(Value)
        if not newSpeed then return end
        if newSpeed > maxSpeed then return end
        if Toggle.Value then
            local item = backpack:FindFirstChild(Dropdown.Value)
            if item and item:GetAttribute("Speed") ~= nil then
                item:SetAttribute("Speed", newSpeed)
            end
        end
    end
})

Toggle:OnChanged(function()
    if not Toggle.Value then
        local item = backpack:FindFirstChild(Dropdown.Value)
        if item then
            if item:GetAttribute("Range") ~= nil then
                item:SetAttribute("Range", 10)
            end
            if item:GetAttribute("Speed") ~= nil then
                item:SetAttribute("Speed", 5)
            end
        end
    end
end)

local RunService = game:GetService("RunService")

local NoRecoilToggle = Tabs.Weapon:AddToggle("NoRecoilToggle", {
    Title = "No Recoil",
    Default = false,
})

local NoReloadToggle = Tabs.Weapon:AddToggle("NoReloadToggle", {
    Title = "No Reload Time",
    Default = false,
})

task.spawn(function()
    while true do
        task.wait(0.5)
        local selectedItem = backpack:FindFirstChild(Dropdown.Value)
        if selectedItem then
            if Options.NoRecoilToggle.Value then
                selectedItem:SetAttribute("Recoil", 0)
            end
            if Options.NoReloadToggle.Value then
                selectedItem:SetAttribute("ReloadTime", 0)
            end
        end
    end
end)
