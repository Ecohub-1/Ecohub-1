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

-- ตัวแปรควบคุม
local autoEquipRunning = false
local autoClicking = false
local clickDelay = 0.1
local selectedOption = "Melee"

--------------------------
-- หมวด: Auto Equip
--------------------------
Tabs.Settings:AddSection("Auto Equip")

-- Toggle Auto Equip
local equipToggle = Tabs.Settings:AddToggle("AutoEquipToggle", {
    Title = "เปิด/ปิด Auto Equip",
    Default = false
})

-- Dropdown ประเภทอาวุธ
Tabs.Settings:AddDropdown("TypeDropdown", {
    Title = "เลือกประเภทอาวุธ",
    Values = { "Melee", "Sword", "DevilFruit", "Special" },
    Multi = false,
    Default = 1,
    Callback = function(value)
        selectedOption = value
        Fluent:Notify({
            Title = "Eco Hub",
            Content = "เลือกประเภท: " .. value,
            Duration = 3
        })
        if equipToggle.Value then
            autoEquip()
        end
    end
})

-- ฟังก์ชัน Auto Equip
local function autoEquip()
    if autoEquipRunning then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                local toolType = tool:GetAttribute("Type")
                if toolType and string.lower(toolType) == string.lower(selectedOption) then
                    if tool.Parent ~= player.Character then
                        tool.Parent = player.Character
                        break -- ไม่ว่าจะเป็น Melee หรืออื่นๆ ก็ใส่แค่ชิ้นเดียว
                    end
                end
            end
        end
    end
end

-- ตรวจจับตอนเพิ่ม Tool ใหม่
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

-- เมื่อ toggle เปลี่ยน
equipToggle:OnChanged(function()
    autoEquipRunning = equipToggle.Value
    if autoEquipRunning then
        autoEquip()
    end
end)

-- โหลดตัวละครใหม่
player.CharacterAdded:Connect(function()
    task.wait(1)
    if autoEquipRunning then
        autoEquip()
    end
end)

--------------------------
-- หมวด: Auto Click
--------------------------
Tabs.Settings:AddSection("Auto Click")

-- Toggle Auto Click
Tabs.Settings:AddToggle("AutoClickToggle", {
    Title = "เปิด/ปิด Auto Click",
    Default = false
}):OnChanged(function(value)
    autoClicking = value
end)

-- ป้อน Delay Auto Click
Tabs.Settings:AddInput("ClickDelayInput", {
    Title = "Click Delay (วินาที)",
    Default = "0.1",
    Placeholder = "ใส่ตัวเลข เช่น 0.1",
    Numeric = true,
    Callback = function(text)
        local num = tonumber(text)
        if num and num > 0 then
            clickDelay = num
        else
            Fluent:Notify({
                Title = "Eco Hub",
                Content = "กรุณาใส่เลขมากกว่า 0",
                Duration = 3
            })
        end
    end
})

-- ลูปคลิก
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

--------------------------
-- เริ่มต้น
--------------------------
Window:SelectTab(1)

Fluent:Notify({
    Title = "Eco Hub",
    Content = "Script Loaded",
    Duration = 3
})

task.wait(2)

Fluent:Notify({
    Title = "Eco Hub",
    Content = "Ready!",
    Duration = 3
})

SaveManager:LoadAutoloadConfig()
