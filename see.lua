-------------------
 -- ui หน้าต่างสคริป
-------------------
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
------------------
 -- เเต่งui
------------------
local Window = Fluent:CreateWindow({
    Title = "Eco Hub " .. Fluent.Version,
    SubTitle = "| by zer09Xz",
    TabWidth = 150,
    Size = UDim2.fromOffset(580, 400),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})
------------------
 -- เเทบช่อง
------------------
local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "app-window" }),
    Dungeon = Window:AddTab({ Title = "Auto Dungeon", Icon = "align-justify" }),
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

--------------------------
-- หมวด: Auto Equip
--------------------------
Tabs.Settings:AddSection("Auto Equip")

local autoEquipRunning = false
local selectedOption = "Melee"

-- Dropdown เลือกประเภทอาวุธ
Tabs.Settings:AddDropdown("TypeDropdown", {
    Title = "เลือกประเภทอาวุธ",
    Values = { "Melee", "Sword", "DevilFruit", "Special" },
    Multi = false,
    Default = 1,
    Callback = function(value)
        selectedOption = value
        if autoEquipRunning then autoEquip() end
    end
})

-- ฟังก์ชัน Auto Equip
local function autoEquip()
    if not autoEquipRunning then return end

    local equipped = false
    for _, tool in ipairs(backpack:GetChildren()) do
        if tool:IsA("Tool") then
            local toolType = tool:GetAttribute("Type")
            if toolType and string.lower(toolType) == string.lower(selectedOption) then
                if tool.Parent ~= player.Character then
                    tool.Parent = player.Character
                    equipped = true
                    if selectedOption == "Melee" then break end -- ใส่แค่อันเดียวสำหรับ Melee
                end
            end
        end
    end
end

-- toggle เปิด/ปิด Auto Equip พร้อม Notify
local equipToggle = Tabs.Settings:AddToggle("AutoEquipToggle", {
    Title = "เปิด/ปิด Auto Equip",
    Default = false
})

equipToggle:OnChanged(function()
    autoEquipRunning = equipToggle.Value
    if autoEquipRunning then
        autoEquip()
        Fluent:Notify({
            Title = "Auto Equip",
            Content = "Auto Equip: true",
            Duration = 3
        })
    else
        Fluent:Notify({
            Title = "Auto Equip",
            Content = "Auto Equip: false",
            Duration = 3
        })
    end
end)

-- ตรวจจับเมื่อมี Tool ใหม่
backpack.ChildAdded:Connect(function(child)
    if child:IsA("Tool") then
        task.wait(0.1)
        if autoEquipRunning then
            local toolType = child:GetAttribute("Type")
            if toolType and string.lower(toolType) == string.lower(selectedOption) then
                child.Parent = player.Character
            end
        end
    end
end)

-- เมื่อโหลดตัวละครใหม่
player.CharacterAdded:Connect(function()
    task.wait(1)
    if autoEquipRunning then autoEquip() end
end)

--------------------------
-- หมวด: Auto Click
--------------------------
Tabs.Settings:AddSection("Auto Click")

local autoClicking = false
local clickDelay = 0.1

Tabs.Settings:AddToggle("AutoClickToggle", {
    Title = "เปิด/ปิด Auto Click",
    Default = false
}):OnChanged(function(value)
    autoClicking = value
end)

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

-- ลูปสำหรับ Auto Click
task.spawn(function()
    while true do
        if autoClicking then
            local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
            if tool then
                pcall(function() tool:Activate() end)
            end
            task.wait(clickDelay)
        else
            task.wait(0.1)
        end
    end
end)
------------------
 --Auto Farm
------------------
Tabs.Main:AddSection("Auto Farm mob")
-- ตัวแปรเก็บชื่อมอนที่เลือก
local selectedMobName = nil

-- สร้าง Dropdown สำหรับเลือกชื่อมอน
local Dropdown = Tabs.Main:AddDropdown("MobDropdown", {
    Title = "เลือกชื่อม่อน",
    Values = mobNamesList,
    Multi = false,
    Default = 1,
})

Dropdown:OnChanged(function(Value)
    selectedMobName = Value
    print("เลือกม่อนชื่อ:", selectedMobName)
end)

-- Toggle สำหรับเปิด/ปิด Auto-Farm
local Toggle = Tabs.Main:AddToggle("MyToggle", {Title = "Auto Farm", Default = false})

Toggle:OnChanged(function()
    print("Auto Farm toggle:", Options.MyToggle.Value)
end)

Options.MyToggle:SetValue(false)

-- เริ่ม Auto-Farm loop
task.spawn(function()
    while true do
        task.wait(0.5)

        -- ถ้า toggle ปิดอยู่ หรือยังไม่ได้เลือกมอน จะไม่ทำงาน
        if not Options.MyToggle.Value or not selectedMobName then continue end

        for _, mob in pairs(workspace.Mob:GetChildren()) do
            if mob.Name == selectedMobName and mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") then
                local humanoid = mob.Humanoid
                if humanoid.Health > 0 then
                    local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                    end
                end
            end
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

SaveManager:LoadAutoloadConfig()
