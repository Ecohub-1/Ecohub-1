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
-- สร้างตารางสำหรับเก็บชื่อม่อนไม่ซ้ำ
local mobNamesSet = {}
local mobNamesList = {}

-- ค้นหาชื่อม่อนใน workspace.Mob
for _, mob in pairs(workspace.Mob:GetChildren()) do
    local name = mob.Name
    -- ตรวจสอบไม่ให้ชื่อม่อนซ้ำ
    if not mobNamesSet[name] then
        mobNamesSet[name] = true
        table.insert(mobNamesList, name)
    end
end

-- เรียงลำดับชื่อม่อน
table.sort(mobNamesList)

-- สร้าง Dropdown UI ด้วยชื่อม่อนที่ได้
local Dropdown = Tabs.Main:AddDropdown("MobDropdown", {
    Title = "เลือกชื่อม่อน",
    Values = mobNamesList,
    Multi = false,
    Default = 1,
})

-- ตัวแปรสำหรับเก็บชื่อม่อนที่เลือก
local selectedMob = ""

-- ฟังก์ชันเมื่อเลือกชื่อม่อน
Dropdown:OnChanged(function(Value)
    print("คุณเลือกม่อนชื่อ:", Value)
    selectedMob = Value
end)

-- สร้าง Toggle UI
local Toggle = Tabs.Main:AddToggle("AutoFarmToggle", {Title = "เปิด/ปิด AutoFarm", Default = false })

-- ฟังก์ชันเมื่อ Toggle เปลี่ยน
Toggle:OnChanged(function(Value)
    print("AutoFarm Toggle เปลี่ยนเป็น:", Value)

    -- หาก Toggle ถูกเปิด
    if Value then
        _G.AutoFarm = true
        -- เริ่มทำการ AutoFarm
        spawn(function()  -- Use spawn to prevent blocking other code
            while _G.AutoFarm do
                pcall(function()
                    -- ค้นหาม็อบใน workspace
                    for _, v in pairs(workspace.Mob:GetChildren()) do
                        -- ตรวจสอบว่าเป็นม็อบที่เลือกใน Dropdown
                        if v.Name == selectedMob and v:FindFirstChild("Humanoid") then
                            local humanoid = v:FindFirstChild("Humanoid")
                            if humanoid.Health > 0 then
                                -- เคลื่อนที่ผู้เล่นไปยังม็อบที่เลือก
                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)

                                -- การโจมตี (เช็คว่าผู้เล่นมีอาวุธหรือไม่)
                                local character = game.Players.LocalPlayer.Character
                                local humanoid = character:FindFirstChildOfClass("Humanoid")

                                -- ตรวจสอบว่า character มีอาวุธ (tool) หรือไม่
                                local tool = character:FindFirstChildOfClass("Tool")
                                if tool then
                                    -- ถ้ามีอาวุธ ให้โจมตี
                                    tool:Activate()  -- ทำการโจมตี
                                else
                                    -- ถ้าไม่มีอาวุธ สามารถใช้วิธีการโจมตีธรรมดา
                                    humanoid:MoveTo(v.HumanoidRootPart.Position)  -- เคลื่อนที่ไปยังม็อบ
                                    -- สามารถเพิ่มโค้ดโจมตีที่นี่ได้ถ้าจำเป็น
                                end
                            end
                        end
                    end
                end)
                task.wait(1)  -- เลื่อนการทำงานเล็กน้อยเพื่อลดการโหลด
            end
        end)
    else
        _G.AutoFarm = false  -- ปิด AutoFarm
    end
end)
--------------------
 -- auto skill
--------------------
Tabs.Settings:AddSection("Auto Skill")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")

local Toggle = Tabs.Settings:AddToggle("AutoskillZ", {
    Title = "Skill Z", 
    Default = false 
})

local autoPress = false

Toggle:OnChanged(function(state)
    autoPress = state

    if autoPress then
        task.spawn(function()
            while autoPress do
                VirtualInputManager:SendKeyEvent(true, "Z", false, game)
                task.wait(0.05)
                VirtualInputManager:SendKeyEvent(false, "Z", false, game)
                task.wait(0.1)
            end
        end)
    end
end)

Options.AutoskillZ:SetValue(false)
-- Skill x กุเขียนเอง
local Toggle = Tabs.Settings:AddToggle("AutoskillX", {
    Title = "Skill X", 
    Default = false 
})

local autoPress = false

Toggle:OnChanged(function(state)
    autoPress = state

    if autoPress then
        task.spawn(function()
            while autoPress do
                VirtualInputManager:SendKeyEvent(true, "X", false, game)
                task.wait(0.05)
                VirtualInputManager:SendKeyEvent(false, "X", false, game)
                task.wait(0.1)
            end
        end)
    end
end)

Options.AutoskillX:SetValue(false)

local Toggle = Tabs.Setting:AddToggle("AutoskillC", {
    Title = "Skill C", 
    Default = false 
})

local autoPress = false

Toggle:OnChanged(function(state)
    autoPress = state

    if autoPress then
        task.spawn(function()
            while autoPress do
                VirtualInputManager:SendKeyEvent(true, "C", false, game)
                task.wait(0.05)
                VirtualInputManager:SendKeyEvent(false, "C", false, game)
                task.wait(0.1)
            end
        end)
    end
end)

Options.AutoskillC:SetValue(false)
-- Skill V
local Toggle = Tabs.Settings:AddToggle("AutoskillV", {
    Title = "Skill V", 
    Default = false 
})

local autoPress = false

Toggle:OnChanged(function(state)
    autoPress = state

    if autoPress then
        task.spawn(function()
            while autoPress do
                VirtualInputManager:SendKeyEvent(true, "V", false, game)
                task.wait(0.05)
                VirtualInputManager:SendKeyEvent(false, "V", false, game)
                task.wait(0.1)
            end
        end)
    end
end)

Options.AutoskillV:SetValue(false)

local Toggle = Tabs.Settings:AddToggle("AutoskillF", {
    Title = "Skill F", 
    Default = false 
})

local autoPress = false

Toggle:OnChanged(function(state)
    autoPress = state

    if autoPress then
        task.spawn(function()
            while autoPress do
                VirtualInputManager:SendKeyEvent(true, "F", false, game)
                task.wait(0.05)
                VirtualInputManager:SendKeyEvent(false, "F", false, game)
                task.wait(0.1)
            end
        end)
    end
end)

Options.AutoskillF:SetValue(false)
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
