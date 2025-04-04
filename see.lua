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

-- ตัวแปรหลัก
local autoEquipRunning = false
local selectedWeaponType = "Melee"

-- สร้าง Dropdown เลือกประเภทอาวุธ
Tabs.Settings:AddDropdown("WeaponTypeDropdown", {
    Title = "เลือกประเภทอาวุธ",
    Values = { "Melee", "Sword", "DevilFruit", "Special" },
    Multi = false,
    Default = 1
}):OnChanged(function(value)
    selectedWeaponType = value
    if autoEquipRunning then
        autoEquip()
    end
end)

-- ฟังก์ชัน Auto Equip
local function autoEquip()
    if not autoEquipRunning then return end

    local found = false
    for _, tool in ipairs(backpack:GetChildren()) do
        if tool:IsA("Tool") and tool:FindFirstChild("Type") then
            local typeValue = tool.Type.Value
            if typeValue == selectedWeaponType then
                if selectedWeaponType == "Melee" and not found then
                    tool.Parent = player.Character
                    found = true
                elseif selectedWeaponType ~= "Melee" then
                    tool.Parent = player.Character
                end
            end
        end
    end
end

-- สร้าง Toggle เปิด/ปิด Auto Equip
Tabs.Settings:AddToggle("AutoEquipToggle", {
    Title = "เปิด/ปิด Auto Equip",
    Default = false
}):OnChanged(function(value)
    autoEquipRunning = value

    if value then
        Fluent:Notify({
            Title = "Auto Equip",
            Content = "Auto Equip: true",
            Duration = 3
        })
        autoEquip()
    else
        Fluent:Notify({
            Title = "Auto Equip",
            Content = "Auto Equip: false",
            Duration = 3
        })
    end
end)

-- อัปเดตเมื่อเพิ่มของใหม่เข้า Backpack
backpack.ChildAdded:Connect(function(child)
    task.wait(0.1)
    if autoEquipRunning and child:IsA("Tool") and child:FindFirstChild("Type") then
        if child.Type.Value == selectedWeaponType then
            if selectedWeaponType == "Melee" then
                for _, equipped in ipairs(player.Character:GetChildren()) do
                    if equipped:IsA("Tool") and equipped:FindFirstChild("Type") and equipped.Type.Value == "Melee" then
                        equipped.Parent = backpack
                    end
                end
                child.Parent = player.Character
            else
                child.Parent = player.Character
            end
        end
    end
end)

-- โหลดตัวละครใหม่แล้วตรวจสอบ Auto Equip
player.CharacterAdded:Connect(function()
    wait(1)
    if autoEquipRunning then
        autoEquip()
    end
end)

-- ระบบ Auto Click
local autoClicking = false
local clickDelay = 0.1
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")

Tabs.Settings:AddToggle("AutoClickToggle", {
    Title = "เปิด/ปิด Auto Click",
    Default = false
}):OnChanged(function(value)
    autoClicking = value
end)

RunService.RenderStepped:Connect(function()
    if autoClicking then
        local cam = workspace.CurrentCamera
        local x = cam.ViewportSize.X / 2
        local y = cam.ViewportSize.Y / 2
        VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 0)
        VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 0)
        task.wait(clickDelay)
    end
end)

-- ตั้งค่า UI เริ่มต้น
Window:SelectTab(1)

-- โหลดคอนฟิก
SaveManager:LoadAutoloadConfig()
