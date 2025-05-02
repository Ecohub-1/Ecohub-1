local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Eco Hub" .. Fluent.Version,
    SubTitle = " | Bloxspin",
    TabWidth = 150,
    Size = UDim2.fromOffset(580, 400),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
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

-- Dropdown สำหรับเลือกอาวุธ
local SelectWeaponDropdown = Tabs.Weapon:AddDropdown("SelectWeaponDropdown", {
    Title = "Select Weapon",
    Values = {},
    Multi = false,
    Default = nil,
})

-- Input: กำหนดค่า Range
local RangeInput = Tabs.Weapon:AddInput("RangeInput", {
    Title = "Range Value",
    Default = "",
    Placeholder = "Enter range",
    Numeric = true,
    Finished = true,
})

-- Input: กำหนดค่า Speed
local SpeedWeapon = Tabs.Weapon:AddInput("SpeedWeapon", {
    Title = "Speed Weapon",
    Default = "10",
    Placeholder = "Enter speed",
    Numeric = true,
    Finished = true,
})

-- ปุ่ม: ค้นหาอาวุธทั้งหมด (รวมจาก Backpack และ Character, ไม่มีซ้ำ)
Tabs.Weapon:AddButton("Find Valid Items", function()
    local itemNames = {}
    local nameSet = {}

    local function scan(container)
        for _, item in ipairs(container:GetChildren()) do
            if item:IsA("Tool") and not nameSet[item.Name] then
                nameSet[item.Name] = true
                table.insert(itemNames, item.Name)
            end
        end
    end

    if LocalPlayer:FindFirstChild("Backpack") then
        scan(LocalPlayer.Backpack)
    end
    if LocalPlayer.Character then
        scan(LocalPlayer.Character)
    end

    if #itemNames > 0 then
        SelectWeaponDropdown:SetValues(itemNames)
    else
        SelectWeaponDropdown:SetValues({"No tools found"})
    end
end)

-- เมื่อเลือกอาวุธจาก Dropdown
SelectWeaponDropdown:OnChanged(function(Value)
    SelectedItemName = Value
    print("Selected Weapon:", Value)
end)

-- ฟังก์ชันหาวัตถุตามชื่อ
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

-- ปุ่ม: กำหนด Range
Tabs.Weapon:AddButton("Set Range", function()
    local val = tonumber(RangeInput.Value)
    if SelectedItemName and val then
        local item = findItem(SelectedItemName)
        if item then
            item:SetAttribute("Range", val)
        end
    end
end)

-- ปุ่ม: กำหนด Speed
Tabs.Weapon:AddButton("Set Speed", function()
    local val = tonumber(SpeedWeapon.Value)
    if SelectedItemName and val then
        local item = findItem(SelectedItemName)
        if item then
            item:SetAttribute("Speed", val)
        end
    end
end)
