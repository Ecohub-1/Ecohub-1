local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Eco Hub" .. Fluent.Version,
    SubTitle = " | Bloxspin",
    TabWidth = 150,
    Size = UDim2.fromOffset(580, 400),
    Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
})

local Tabs = {
    AutoFarm = Window:AddTab({ Title = "AutoFarm", Icon = "" }),
    Aimbot = Window:AddTab({ Title = "Aimbot", Icon = "" }),
    Weapon = Window:AddTab({ Title = "Weapon", Icon = "" }),
    ESP = Window:AddTab({ Title = "ESP", Icon = "" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local SelectedItemName = nil

local Dropdown = Tabs.Main:AddDropdown("Dropdown", {
    Title = "Select Item",
    Values = {},
    Multi = false,
    Default = nil,
})

local Input = Tabs.Main:AddInput("Input", {
    Title = "Set Custom Attribute",
    Default = "",
    Placeholder = "Enter number",
    Numeric = true,
    Finished = true,
})

local RangeInput = Tabs.Main:AddInput("RangeInput", {
    Title = "Range Value",
    Default = "",
    Placeholder = "Enter range",
    Numeric = true,
    Finished = true,
})

local SpeedInput = Tabs.Main:AddInput("SpeedInput", {
    Title = "Speed Value",
    Default = "",
    Placeholder = "Enter speed",
    Numeric = true,
    Finished = true,
})

Tabs.Main:AddButton("Find Valid Items", function()
    local validItems = {}

    local function scan(container)
        for _, item in ipairs(container:GetChildren()) do
            if item:IsA("Tool") then
                local name = item.Name:lower()
                if not name:find("range") and not name:find("speed") then
                    table.insert(validItems, item.Name)
                end
            end
        end
    end

    scan(LocalPlayer.Backpack)
    if LocalPlayer.Character then
        scan(LocalPlayer.Character)
    end

    Dropdown:SetValues(validItems)
end)

Dropdown:OnChanged(function(Value)
    SelectedItemName = Value
end)

local function findItem(name)
    for _, item in ipairs(LocalPlayer.Backpack:GetChildren()) do
        if item:IsA("Tool") and item.Name == name then
            return item
        end
    end
    if LocalPlayer.Character then
        for _, item in ipairs(LocalPlayer.Character:GetChildren()) do
            if item:IsA("Tool") and item.Name == name then
                return item
            end
        end
    end
    return nil
end

Input:OnChanged(function()
    local val = tonumber(Input.Value)
    if SelectedItemName and val then
        local item = findItem(SelectedItemName)
        if item then
            item:SetAttribute("CustomValue", val)
        end
    end
end)

Tabs.Main:AddButton("Set Range", function()
    local val = tonumber(RangeInput.Value)
    if SelectedItemName and val then
        local item = findItem(SelectedItemName)
        if item then
            item:SetAttribute("Range", val)
        end
    end
end)

Tabs.Main:AddButton("Set Speed", function()
    local val = tonumber(SpeedInput.Value)
    if SelectedItemName and val then
        local item = findItem(SelectedItemName)
        if item then
            item:SetAttribute("Speed", val)
        end
    end
end)
