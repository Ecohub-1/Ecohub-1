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

-- Dropdown for item selection
local Dropdown = Tabs.Weapon:AddDropdown("ItemDropdown", {
    Title = "Select Item",
    Values = {},
    Multi = false,
    Default = 1,
})

-- Toggle for enabling adjustments
local EnableAdjustmentToggle = Tabs.Weapon:AddToggle("EnableAdjustmentToggle", {
    Title = "Enable Value",
    Default = false,
})

-- Function to refresh item names in the dropdown
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

-- Button to refresh items
Tabs.Weapon:AddButton({
    Title = "Refresh Items",
    Callback = refreshItemNames,
})

-- Call the refresh function on startup
refreshItemNames()

-- Input for Range
local RangeInput = Tabs.Weapon:AddInput("RangeInput", {
    Title = "Range",
    Default = "10",
    Placeholder = "Enter Range",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        local newRange = tonumber(Value)
        if newRange and newRange <= maxRange then
            local item = backpack:FindFirstChild(Dropdown.Value)
            if item and EnableAdjustmentToggle.Value then
                item:SetAttribute("Range", newRange)
            end
        end
    end
})

-- Input for Speed
local SpeedInput = Tabs.Weapon:AddInput("SpeedInput", {
    Title = "Speed",
    Default = "5",
    Placeholder = "Enter Speed",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        local newSpeed = tonumber(Value)
        if newSpeed and newSpeed <= maxSpeed then
            local item = backpack:FindFirstChild(Dropdown.Value)
            if item and EnableAdjustmentToggle.Value then
                item:SetAttribute("Speed", newSpeed)
            end
        end
    end
})

-- Loop to adjust Range and Speed automatically when Toggle is on
task.spawn(function()
    while true do
        task.wait(0.5)  -- Wait 0.5 seconds before checking again

        -- Only adjust if the toggle is enabled
        if EnableAdjustmentToggle.Value then
            local selectedItem = backpack:FindFirstChild(Dropdown.Value)
            
            if selectedItem then
                -- Adjust Range if within the limit
                local currentRange = selectedItem:GetAttribute("Range") or 10
                if currentRange < maxRange then
                    selectedItem:SetAttribute("Range", currentRange + 1)  -- Increment range by 1
                end
                
                -- Adjust Speed if within the limit
                local currentSpeed = selectedItem:GetAttribute("Speed") or 5
                if currentSpeed < maxSpeed then
                    selectedItem:SetAttribute("Speed", currentSpeed + 1)  -- Increment speed by 1
                end
            end
        end
    end
end)

-- Toggle for No Recoil
local NoRecoilToggle = Tabs.Weapon:AddToggle("NoRecoilToggle", {
    Title = "No Recoil",
    Default = false,
})

-- Toggle for No Reload Time
local NoReloadToggle = Tabs.Weapon:AddToggle("NoReloadToggle", {
    Title = "No Reload Time",
    Default = false,
})

-- Loop to adjust No Recoil and No Reload Time attributes when toggles are on
task.spawn(function()
    while true do
        task.wait(0.5)
        local selectedItem = backpack:FindFirstChild(Dropdown.Value)
        if selectedItem then
            -- Apply No Recoil if toggle is on
            if NoRecoilToggle.Value then
                selectedItem:SetAttribute("Recoil", 0)
            end
            
            -- Apply No Reload Time if toggle is on
            if NoReloadToggle.Value then
                selectedItem:SetAttribute("ReloadTime", 0)
            end
        end
    end
end)
