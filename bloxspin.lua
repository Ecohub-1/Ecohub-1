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

-- สมมติว่าเรามี Dropdown, Input และ Toggle
local player = game.Players.LocalPlayer
local backpack = player.Backpack

-- ขีดจำกัดสูงสุดของ Range และ Speed
local maxRange = 50
local maxSpeed = 10

-- ฟังก์ชันสำหรับแสดงการแจ้งเตือน
local function showNotification(message)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Notification",
        Text = message,
        Duration = 3
    })
end

-- สร้าง Dropdown สำหรับเลือกไอเทม
local Dropdown = Tabs.Weapon:AddDropdown("ItemDropdown", {
    Title = "Select Item",
    Values = {},  -- จะใส่ชื่อไอเทมจากกระเป๋า
    Multi = false,
    Default = 1,
})

-- สร้าง Input สำหรับรับค่าที่ผู้เล่นป้อน (Range)
local RangeInput = Tabs.Weapon:AddInput("RangeInput", {
    Title = "Range",
    Default = "10",
    Placeholder = "Enter Range",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        print("Range changed:", Value)
        
        local newRange = tonumber(Value)
        
        -- ตรวจสอบว่า Range ไม่เกินขีดจำกัด
        if newRange > maxRange then
            showNotification("Maximum Range is " .. maxRange)
        else
            -- ปรับค่า Range ให้กับไอเทมที่เลือก
            local selectedItem = backpack:FindFirstChild(Dropdown.Value)
            if selectedItem and Toggle.Value then
                selectedItem:SetAttribute("Range", newRange)
                print("Updated Range for item:", selectedItem.Name)
            end
        end
    end
})

-- สร้าง Input สำหรับรับค่าที่ผู้เล่นป้อน (Speed)
local SpeedInput = Tabs.Weapon:AddInput("SpeedInput", {
    Title = "Speed",
    Default = "5",
    Placeholder = "Enter Speed",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        print("Speed changed:", Value)
        
        local newSpeed = tonumber(Value)
        
        -- ตรวจสอบว่า Speed ไม่เกินขีดจำกัด
        if newSpeed > maxSpeed then
            showNotification("Maximum Speed is " .. maxSpeed)
        else
            -- ปรับค่า Speed ให้กับไอเทมที่เลือก
            local selectedItem = backpack:FindFirstChild(Dropdown.Value)
            if selectedItem and Toggle.Value then
                selectedItem:SetAttribute("Speed", newSpeed)
                print("Updated Speed for item:", selectedItem.Name)
            end
        end
    end
})

-- สร้าง Toggle สำหรับเปิด/ปิดการปรับค่า
local Toggle = Tabs.Weapon:AddToggle("MyToggle", {
    Title = "Enable Adjustments",
    Default = false,
})

-- ฟังก์ชันสำหรับรีเฟรชชื่อไอเทมในกระเป๋า
local function refreshItemNames()
    local itemNames = {}
    for _, item in ipairs(backpack:GetChildren()) do
        table.insert(itemNames, item.Name)
    end
    -- อัปเดตรายการใน Dropdown
    Dropdown:SetValues(itemNames)
    -- เซ็ตค่าเริ่มต้นเป็นไอเทมแรก
    if #itemNames > 0 then
        Dropdown:SetValue(itemNames[1])
    end
end

-- รีเฟรชชื่อไอเทมครั้งแรก
refreshItemNames()

-- เมื่อเลือกไอเทมจาก Dropdown
Dropdown:OnChanged(function(Value)
    print("Item selected:", Value)
    -- แสดงค่า Range และ Speed ของไอเทมที่เลือก
    local selectedItem = backpack:FindFirstChild(Value)
    if selectedItem then
        local range = selectedItem:GetAttribute("Range")
        local speed = selectedItem:GetAttribute("Speed")
        print("Current Range:", range or "Not set")
        print("Current Speed:", speed or "Not set")
    end
end)

-- เมื่อ Toggle เปลี่ยนสถานะ
Toggle:OnChanged(function()
    print("Toggle changed:", Toggle.Value)

    local selectedItem = backpack:FindFirstChild(Dropdown.Value)

    if selectedItem then
        if not Toggle.Value then
            -- ถ้า Toggle ปิด รีเซ็ตค่า Range และ Speed
            selectedItem:SetAttribute("Range", 10)  -- ค่าเริ่มต้นของ Range
            selectedItem:SetAttribute("Speed", 5)   -- ค่าเริ่มต้นของ Speed
            print("Reset Range and Speed for item:", selectedItem.Name)
        end
    end
end)
