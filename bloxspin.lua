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
local backpack = Players.LocalPlayer:WaitForChild("Backpack")

-- ฟังก์ชันดึงชื่อไอเทม
local function GetBackpackItemNames()
    local names = {}
    for _, item in ipairs(backpack:GetChildren()) do
        table.insert(names, item.Name)
    end
    return names
end

-- สร้าง Dropdown
local Dropdown = Tabs.Main:AddDropdown("Dropdown", {
    Title = "เลือกไอเทมใน Backpack",
    Values = GetBackpackItemNames(),
    Multi = false,
    Default = 1,
})

local selectedItemName = Dropdown.Value

Dropdown:OnChanged(function(Value)
    selectedItemName = Value
end)

-- Input สำหรับกำหนดค่า
local Input = Tabs.Main:AddInput("Input", {
    Title = "ปรับค่า Range/Speed",
    Default = "",
    Placeholder = "ใส่ตัวเลข",
    Numeric = true,
    Finished = true,
    Callback = function(Value)
        local num = tonumber(Value)
        if not num then return end

        local item = backpack:FindFirstChild(selectedItemName)
        if item then
            item:SetAttribute("Range", num)
            item:SetAttribute("Speed", num)
        end
    end
})
