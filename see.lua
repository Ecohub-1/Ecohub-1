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
local mobNamesSet = {}
local mobNamesList = {}

for _, mob in pairs(workspace.Mob:GetChildren()) do
    local name = mob.Name
    if not mobNamesSet[name] then
        mobNamesSet[name] = true
        table.insert(mobNamesList, name)
    end
end

table.sort(mobNamesList)

local toggle = Tabs.Main:AddToggle("MyToggle", {
    Title = "Enable/Disable AutoFarm",
    Default = false
})

local mobDropdown = Tabs.Main:AddDropdown("MobDropdown", {
    Title = "Select Mob Name",
    Values = mobNamesList,
    Multi = false,
    Default = 1,
})
Tabs.Main:AddSection("Auto Farm Setting")
local dropdown = Tabs.Main:AddDropdown("MyDropdown", {
    Title = "Select Position",
    Values = {"Above", "Behind", "Below"},
    Default = 1
})

local input = Tabs.Main:AddInput("MyInput", {
    Title = "Distance",
    Placeholder = "Enter the desired distance",
    Callback = function(Value)
        local distance = tonumber(Value)
        if distance then
        end
    end
})

local selectedMob = ""

mobDropdown:OnChanged(function(Value)
    selectedMob = Value
end)

toggle:OnChanged(function()
    if toggle.Value then
        _G.AutoFarm = true
        spawn(function()
            while _G.AutoFarm do
                pcall(function()
                    for _, v in pairs(workspace.Mob:GetChildren()) do
                        if v.Name == selectedMob and v:FindFirstChild("Humanoid") then
                            local humanoid = v:FindFirstChild("Humanoid")
                            if humanoid.Health > 0 then
                                local distance = tonumber(input.Value) or 5
                                local position = v.HumanoidRootPart.Position
                                if dropdown.Value == "Above" then
                                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(position + Vector3.new(0, distance, 0))
                                elseif dropdown.Value == "Behind" then
                                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(position - v.HumanoidRootPart.CFrame.LookVector * distance)
                                elseif dropdown.Value == "Below" then
                                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(position - Vector3.new(0, distance, 0))
                                end
                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(math.rad(-30), 0, 0)
                                local character = game.Players.LocalPlayer.Character
                                local humanoid = character:FindFirstChildOfClass("Humanoid")
                                local tool = character:FindFirstChildOfClass("Tool")
                                if not tool then
                                    humanoid:MoveTo(v.HumanoidRootPart.Position)
                                end
                            end
                        elseif humanoid.Health <= 0 then
                            break
                        end
                    end
                end)
                task.wait(1)
            end
        end)
    else
        _G.AutoFarm = false
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
