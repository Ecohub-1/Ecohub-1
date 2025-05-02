local player = game.Players.LocalPlayer
local backpack = player.Backpack

local maxRange = 50
local maxSpeed = 10

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
    Aimbot = Window:AddTab({ Title = "Aimbot", Icon = "" }),
    Weapon = Window:AddTab({ Title = "Weapon", Icon = "" }),
    ESP = Window:AddTab({ Title = "ESP", Icon = "" }),
    Player = Window:AddTab({ Title = "Player", Icon = "" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

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

local NoRecoilToggle = Tabs.Weapon:AddToggle("NoRecoilToggle", {
    Title = "No Recoil",
    Default = false,
})

local NoReloadToggle = Tabs.Weapon:AddToggle("NoReloadToggle", {
    Title = "No Reload Time",
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
            if item then
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
            if item then
                item:SetAttribute("Speed", newSpeed)
            end
        end
    end
})

Toggle:OnChanged(function()
    local item = backpack:FindFirstChild(Dropdown.Value)
    if item then
        if not Toggle.Value then
            item:SetAttribute("Range", 10)
            item:SetAttribute("Speed", 5)
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(0.5)
        local selectedItem = backpack:FindFirstChild(Dropdown.Value)
        if selectedItem then
            if NoRecoilToggle.Value then
                selectedItem:SetAttribute("Recoil", 0)
            end
            if NoReloadToggle.Value then
                selectedItem:SetAttribute("ReloadTime", 0)
            end
        end
    end
end)
