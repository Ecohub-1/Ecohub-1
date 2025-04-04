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
    Content = "Setting Autoskill, AutoClick, and AutoEquip"
})

local Options = Fluent.Options

-- เชื่อมกับตัวผู้เล่น
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local backpack = player:WaitForChild("Backpack")

-- ตั้งค่า SaveManager และ InterfaceManager
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")

InterfaceManager:BuildInterfaceSection(Tabs.misc)
SaveManager:BuildConfigSection(Tabs.misc)

--===================== Auto Equip =====================--
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
                wait(0.1)
                if autoEquipRunning then
                    child.Parent = player.Character
                end
            end
        end)
    else
        stopAutoEquip()
    end
end)

player.CharacterAdded:Connect(function()
    wait(1)
    if equipToggle.Value then
        autoEquip()
    end
end)

--===================== Auto Click =====================--
local autoClicking = false
local clickDelay = 0.1

Tabs.Settings:AddToggle("AutoClickToggle", {
    Title = "เปิด/ปิด Auto Click",
    Default = false
}):OnChanged(function(value)
    autoClicking = value
end)

Tabs.Settings:AddSlider("ClickSpeedSlider", {
    Title = "ความเร็ว Auto Click (วินาที)",
    Description = "ยิ่งน้อยยิ่งคลิกเร็ว",
    Min = 0.01,
    Max = 1,
    Default = 0.1,
    Rounding = true,
    Callback = function(value)
        clickDelay = value
    end
})

local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")

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

--===================== Start UI =====================--
Window:SelectTab(1)

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

SaveManager:LoadAutoloadConfig()
