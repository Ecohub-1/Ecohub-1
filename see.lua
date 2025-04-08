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
    Credits = Window:AddTab({ Title = "Credits", Icon = "award" }),
    Main = Window:AddTab({ Title = "Main", Icon = "gamepad-2" }),
    Dungeon = Window:AddTab({ Title = "Auto Dungeon", Icon = "globe" }),
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
local autoEquipRunning, selectedOption = false, "Melee"

Tabs.Settings:AddDropdown("TypeDropdown", {
    Title = "เลือกประเภทอาวุธ",
    Values = { "Melee", "Sword", "DevilFruit", "Special" },
    Default = 1,
    Callback = function(value)
        selectedOption = value
        if autoEquipRunning then autoEquip() end
    end
})

local function autoEquip()
    if autoEquipRunning then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") and tool:GetAttribute("Type") == selectedOption then
                tool.Parent = player.Character
                if selectedOption == "Melee" then break end
            end
        end
    end
end

Tabs.Settings:AddToggle("AutoEquipToggle", {
    Title = "เปิด/ปิด Auto Equip",
    Default = false,
    OnChanged = function() autoEquipRunning = equipToggle.Value; if autoEquipRunning then autoEquip() end end
})

backpack.ChildAdded:Connect(function(child)
    if child:IsA("Tool") and autoEquipRunning and child:GetAttribute("Type") == selectedOption then
        child.Parent = player.Character
    end
end)

player.CharacterAdded:Connect(function() if autoEquipRunning then autoEquip() end end)


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

local skillKeys = {
    Z = "AutoSkillZ",
    X = "AutoSkillX",
    C = "AutoSkillC",
    V = "AutoSkillV",
    F = "AutoSkillF"
}

for key, id in pairs(skillKeys) do
    local AutoSkill = false

    local toggle = Tabs.Settings:AddToggle(id, {
        Title = "Skill " .. key,
        Default = false
    })

    toggle:OnChanged(function(state)
        AutoSkill = state
        if AutoSkill then
            task.spawn(function()
                while AutoSkill do
                    VirtualInputManager:SendKeyEvent(true, key, false, game)
                    task.wait(0.05)
                    VirtualInputManager:SendKeyEvent(false, key, false, game)
                    task.wait(0.1)
                end
            end)
        end
    end)
end



Tabs.Credits:AddParagraph({
    Title = "Credits",
    Content = "Owner: zer09Xz\nScript: zer09Xz\nHelper: Lucas, Dummy"
})

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
