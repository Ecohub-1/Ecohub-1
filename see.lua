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
    Credits = Window:AddTab({ Title = "credit", Icon = "trophy" }),
    AutoFarm = Window:AddTab({ Title = "Auto Farm", Icon = "gamepad" }),
    AutoBoss = Window:AddTab({ Title = "Auto boss", Icon = "gamepad" }),
    Dungeon = Window:AddTab({ Title = "Dungeon", Icon = "globe" }),
    Teleport = Window:AddTab({ Title = "Teleport", Icon = "map-pinned" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

Tabs.Credits:AddParagraph({
    Title = "Owner & Script",
    Content = "Owner: zer09Xz\nScript: zer09Xz\nHelper: Lucas, Dummy",
    Description = ""
})

Tabs.Settings:AddSection("Auto Equip")
local autoEquipRunning, selectedOption = false, "Melee"

Tabs.Settings:AddDropdown("TypeDropdown", {
    Title = "Search weapon",
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
    Title = "Auto Equip",
    Default = false,
    OnChanged = function() autoEquipRunning = equipToggle.Value; if autoEquipRunning then autoEquip() end end
})

backpack.ChildAdded:Connect(function(child)
    if child:IsA("Tool") and autoEquipRunning and child:GetAttribute("Type") == selectedOption then
        child.Parent = player.Character
    end
end)

player.CharacterAdded:Connect(function() if autoEquipRunning then autoEquip() end end)
Tabs.Settings:AddSection("Auto Cilck")

local autoClicking = false
local clickDelay = 0.1

Tabs.Settings:AddToggle("AutoClickToggle", {
    Title = "Auto Click",
    Default = false
}):OnChanged(function(value)
    autoClicking = value
end)

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
