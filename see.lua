local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Eco Hub" .. Fluent.Version,
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

Tabs.Settings:AddParagraph({
    Title = "Auto Setting",
    Content = "Setting Autoskill and AutoCilck"
})

local Options = Fluent.Options

-- เชื่อมกับตัวผู้เล่น
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local backpack = player:WaitForChild("Backpack")

-- ตรวจสอบว่า backpack ถูกต้องหรือไม่
print("Backpack: ", backpack)  -- ตรวจสอบว่า Backpack ถูกโหลดเสร็จหรือไม่

-- ตั้งค่า SaveManager และ InterfaceManager
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")

InterfaceManager:BuildInterfaceSection(Tabs.misc)
SaveManager:BuildConfigSection(Tabs.misc)

-- ตัวแปรเพื่อติดตามสถานะการทำงานของ Auto Equip
local autoEquipRunning = false

-- ฟังก์ชันสำหรับ Auto Equip
local function autoEquip()
    if autoEquipRunning then
        print("Auto Equip เริ่มทำงาน")  -- ตรวจสอบว่า autoEquip ทำงานหรือไม่
        -- ทำการสวมใส่เครื่องมือที่สามารถทำดาเมจได้จาก Backpack ไปที่ Character
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                -- ตรวจสอบว่าเครื่องมือสามารถทำดาเมจได้
                local damage = tool:FindFirstChild("Damage")
                local isWeapon = tool:FindFirstChild("Weapon") -- ถ้ามี Weapon เป็น Child

                print("กำลังตรวจสอบเครื่องมือ: ", tool.Name)  -- ตรวจสอบว่าเครื่องมือที่กำลังตรวจสอบคืออะไร

                if damage or isWeapon then
                    -- ถ้ามี Damage หรือเป็น Weapon, ก็ให้สวมใส่เครื่องมือ
                    tool.Parent = player.Character
                    print("สวมใส่เครื่องมือ: ", tool.Name)  -- แจ้งว่าเครื่องมือได้ถูกสวมใส่
                end
            end
        end
    end
end

-- ฟังก์ชันหยุดทำงาน Auto Equip
local function stopAutoEquip()
    autoEquipRunning = false
    print("Auto Equip หยุดทำงาน")
end

-- สร้าง Toggle สำหรับ Auto Equip
local toggle = Tabs.Settings:AddToggle("MyToggle", {
    Title = "เปิด/ปิด Auto Equip",
    Default = false
})

-- ตรวจสอบเมื่อสถานะของ Toggle เปลี่ยน
toggle:OnChanged(function()
    print("สถานะ Toggle:", toggle.Value)
    
    if toggle.Value then
        -- เมื่อเปิด toggle ให้เริ่มทำงาน Auto Equip
        autoEquipRunning = true
        autoEquip()
        
        -- เชื่อมกับการเพิ่ม Tool ใหม่ใน Backpack
        backpack.ChildAdded:Connect(function(child)
            print("เครื่องมือใหม่ถูกเพิ่ม:", child.Name)  -- แจ้งว่าเครื่องมือใหม่ถูกเพิ่มเข้าไปใน Backpack
            if child:IsA("Tool") then
                wait(0.1) -- รอให้มันใส่เข้า backpack เสร็จ
                if autoEquipRunning then
                    -- ตรวจสอบว่าเครื่องมือที่เพิ่มมาเป็นเครื่องมือที่สามารถทำดาเมจได้
                    local damage = child:FindFirstChild("Damage")
                    local isWeapon = child:FindFirstChild("Weapon")
                    
                    if damage or isWeapon then
                        child.Parent = player.Character
                        print("สวมใส่เครื่องมือที่เพิ่มมา: ", child.Name)  -- แจ้งว่าเครื่องมือที่เพิ่มมาได้ถูกสวมใส่
                    end
                end
            end
        end)
    else
        -- เมื่อปิด toggle ให้หยุดทำงาน Auto Equip
        stopAutoEquip()
    end
end)

-- เมื่อโหลด Character เสร็จ
player.CharacterAdded:Connect(function()
    wait(1) -- รอให้ตัวละครโหลดของครบก่อน
    if toggle.Value then
        autoEquip()
    end
end)

-- เลือกแท็บแรก
Window:SelectTab(1)

-- แจ้งเตือนเมื่อสคริปต์โหลดเสร็จ
Fluent:Notify({
    Title = "Notify | by zer09Xz",
    Content = "script loaded.",
    Duration = 3
})
wait(3)
Fluent:Notify({
    Title = "Notify | by zer09Xz",
    Content = "Succeed",
    Duration = 5
})

-- โหลดการตั้งค่าจาก SaveManager
SaveManager:LoadAutoloadConfig()
