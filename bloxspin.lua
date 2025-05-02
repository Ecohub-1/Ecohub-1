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
    Main = Window:AddTab({ Title = "Main", Icon = "" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local SelectedItemName = nil

-- Dropdown สำหรับเลือกไอเท็มที่ไม่ใช่ Range หรือ Speed
local Dropdown = Tabs.Main:AddDropdown("Dropdown", {
    Title = "Select Item (No Range/Speed)",
    Values = {},
    Multi = false,
    Default = nil,
})

-- Input สำหรับเซ็ตค่า Attribute ปกติ
local Input = Tabs.Main:AddInput("Input", {
    Title = "Set Custom Attribute",
    Default = "",
    Placeholder = "Enter number",
    Numeric = true,
    Finished = true,
})

-- Input สำหรับ Range
local RangeInput = Tabs.Main:AddInput("Range", {
    Title = "Set Range",
    Default = "",
    Placeholder = "Enter range value",
    Numeric = true,
    Finished = true,
})

-- Input สำหรับ Speed
local SpeedInput = Tabs.Main:AddInput("Speed", {
    Title = "Set Speed",
    Default = "",
    Placeholder = "Enter speed value",
    Numeric = true,
    Finished = true,
})

-- ปุ่มค้นหาไอเท็มที่ไม่ใช่ Range/Speed
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

-- เมื่อเลือกไอเท็มจาก Dropdown
Dropdown:OnChanged(function(Value)
    SelectedItemName = Value
    print("Selected item:", Value)
end)

-- ฟังก์ชันช่วยหาไอเท็มตามชื่อ
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

-- เมื่อกรอกค่า Input ปกติ
Input:OnChanged(function()
    local val = tonumber(Input.Value)
    if SelectedItemName and val then
        local item = findItem(SelectedItemName)
        if item then
            item:SetAttribute("CustomValue", val)
            print("Set CustomValue for", item.Name, "to", val)
        end
    end
end)

-- เมื่อกรอกค่า Range
RangeInput:OnChanged(function()
    local val = tonumber(RangeInput.Value)
    if SelectedItemName and val then
        local item = findItem(SelectedItemName)
        if item then
            item:SetAttribute("Range", val)
            print("Set Range for", item.Name, "to", val)
        end
    end
end)

-- เมื่อกรอกค่า Speed
SpeedInput:OnChanged(function()
    local val = tonumber(SpeedInput.Value)
    if SelectedItemName and val then
        local item = findItem(SelectedItemName)
        if item then
            item:SetAttribute("Speed", val)
            print("Set Speed for", item.Name, "to", val)
        end
    end
end)
