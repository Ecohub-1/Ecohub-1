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

Tabs.Settings:AddParagraph({
    Title = "Auto Setting",
    Content = "ตั้งค่า Auto Equip, Auto Click และโหมด Dropdown"
})

local Options = Fluent.Options

--== บริการพื้นฐาน ==--
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local backpack = player:WaitForChild("Backpack")

--== ตั้งค่า SaveManager / InterfaceManager ==--
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
local selectedOption = "Melee"  -- กำหนดค่า Default ให้ตรงกับ Dropdown index 1

--======================= Auto Equip =======================--
local function autoEquip()
    if autoEquipRunning then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                -- ถ้าเลือกโหมด "Melee" ให้เช็ค Attribute "Type" ของ Tool
                if selectedOption == "Melee" then
                    local toolType = tool:GetAttribute("Type")
                    if toolType and string.lower(toolType) == "melee" then
                        if tool.Parent ~= player.Character then
                            tool.Parent = player.Character
                        end
                    end
                else
                    -- ถ้าเลือกโหมดอื่น ให้สวมใส่ทุกเครื่องมือ (หรือปรับเพิ่มเติมตามต้องการ)
                    if tool.Parent ~= player.Character then
                        tool.Parent = player.Character
                    end
                end
            end
        end
    end
end

local function stopAutoEquip()
    autoEquipRunning = false
end

local equipToggle = Tabs.Settings:AddToggle("AutoEquipToggle", {
    Title = "เปิด/ปิด Auto Equip",
    Default = false
})

equipToggle:OnChanged(function()
    if equipToggle.Value then
        autoEquipRunning = true
        autoEquip()
        backpack.ChildAdded:Connect(function(child)
            if child:IsA("Tool") then
                task.wait(0.1)
                if autoEquipRunning then
                    if selectedOption == "Melee" then
                        local toolType = child:GetAttribute("Type")
                        if toolType and string.lower(toolType) == "melee" then
                            if child.Parent ~= player.Character then
                                child.Parent = player.Character
                            end
                        end
                    else
                        if child.Parent ~= player.Character then
                            child.Parent = player.Character
                        end
                    end
                end
            end
        end)
    else
        stopAutoEquip()
    end
end)

player.CharacterAdded:Connect(function()
    task.wait(1)
    if equipToggle.Value then
        autoEquip()
    end
end)

--======================= Auto Click =======================--
Tabs.Settings:AddToggle("AutoClickToggle", {
    Title = "เปิด/ปิด Auto Click (Tool)",
    Default = false
}):OnChanged(function(value)
    autoClicking = value
end)

Tabs.Settings:AddInput("ClickDelayInput", {
    Title = "ความเร็ว Auto Click (วินาที)",
    Default = "0.1",
    Placeholder = "ใส่ตัวเลข เช่น 0.1",
    Numeric = true,
    Callback = function(text)
        local number = tonumber(text)
        if number and number > 0 then
            clickDelay = number
        else
            Fluent:Notify({
                Title = "Eco Hub",
                Content = "กรุณาใส่ตัวเลขที่มากกว่า 0",
                Duration = 3
            })
        end
    end
})

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

--======================= Dropdown =======================--
Tabs.Settings:AddDropdown("MyDropdown", {
    Title = "เลือกโหมด",
    Values = { "Melee", "Sword", "DevilFruit", "Special" },
    Multi = false,
    Default = 1,
    Callback = function(value)
        selectedOption = value
        Fluent:Notify({
            Title = "Eco Hub",
            Content = "เลือกอาวุธ" .. tostring(value),
            Duration = 3
        })
        -- เมื่อเลือกโหมดใหม่ สามารถเรียก autoEquip ใหม่ได้
        if equipToggle.Value then
            autoEquip()
        end
    end
})

--== UI เริ่มต้น + แจ้งเตือน ==--
Window:SelectTab(1)

Fluent:Notify({
    Title = "Eco Hub",
    Content = "Script Loaded.",
    Duration = 2.1
})
task.wait(2)
Fluent:Notify({
    Title = "Eco Hub",
    Content = "Ready to use!",
    Duration = 3
})

SaveManager:LoadAutoloadConfig()
