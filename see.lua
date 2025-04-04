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
    Content = "ตั้งค่า Auto Equip และ Auto Click"
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

--======================= Auto Equip =======================--
local autoEquipRunning = false

local function autoEquip()
    if autoEquipRunning then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") and tool.Parent ~= player.Character then
                tool.Parent = player.Character
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
                if autoEquipRunning and child.Parent ~= player.Character then
                    child.Parent = player.Character
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
local autoClicking = false
local clickDelay = 0.1

local autoClickToggle = Tabs.Settings:AddToggle("AutoClickToggle", {
    Title = "เปิด/ปิด Auto Click (Tool)",
    Default = false
})

autoClickToggle:OnChanged(function(value)
    autoClicking = value
end)

Tabs.Settings:AddSlider("ClickDelaySlider", {
    Title = "หน่วงเวลาคลิก (วินาที)",
    Description = "ค่าน้อย = คลิกเร็ว",
    Min = 0.05,
    Max = 1,
    Default = 0.1,
    Rounding = true,
    Callback = function(value)
        if type(value) == "number" then
            clickDelay = value
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

--== UI เริ่มต้น + แจ้งเตือน ==--
Window:SelectTab(1)

Fluent:Notify({
    Title = "Eco Hub",
    Content = "Script Loaded.",
    Duration = 3
})
task.wait(3)
Fluent:Notify({
    Title = "Eco Hub",
    Content = "Ready to use!",
    Duration = 5
})

SaveManager:LoadAutoloadConfig()
