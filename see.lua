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

local player = game.Players.LocalPlayer
local backpack = player:WaitForChild("Backpack")

Tabs.Settings:AddSection("Auto Equip")

local autoEquipRunning = false
local selectedOption = "Melee"

Tabs.Settings:AddDropdown("TypeDropdown", {
    Title = "Search weapon",
    Values = { "Melee", "Sword", "DevilFruit", "Special" },
    Default = 1,
    Callback = function(value)
        selectedOption = value
    end
})

local function autoEquipLoop()
    task.spawn(function()
        while autoEquipRunning do
            if player.Character then
                for _, tool in ipairs(backpack:GetChildren()) do
                    if tool:IsA("Tool") and tool:GetAttribute("Type") == selectedOption then
                        tool.Parent = player.Character
                        if selectedOption == "Melee" then break end
                    end
                end
            end
            task.wait(0.1)
        end
    end)
end

Tabs.Settings:AddToggle("AutoEquipToggle", {
    Title = "Auto Equip",
    Default = false,
    Callback = function(value)
        autoEquipRunning = value
        if autoEquipRunning then autoEquipLoop() end
    end
})

player.CharacterAdded:Connect(function(char)
    char:WaitForChild("HumanoidRootPart", 5)
end)

Tabs.Settings:AddSection("Auto Click")
local autoClicking = false
local clickDelay = 0.1

Tabs.Settings:AddToggle("AutoClickToggle", {
    Title = "Auto Click",
    Default = false,
    Callback = function(value)
        autoClicking = value
    end
})

local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")

RunService.RenderStepped:Connect(function()
    if autoClicking then
      
        VirtualUser:Button1Down(Vector2.new(0.9, 0.9))
        VirtualUser:Button1Up(Vector2.new(0.9, 0.9))
        task.wait(clickDelay)
    end
end)

Tabs.Settings:AddSection("Auto Skill")
local skillKeys = {
    Z = "AutoSkillZ",
    X = "AutoSkillX",
    C = "AutoSkillC",
    V = "AutoSkillV",
    F = "AutoSkillF"
}

for key, id in pairs(skillKeys) do
    local AutoSkill = false
    Tabs.Settings:AddToggle(id, {
        Title = "Skill " .. key,
        Default = false,
        Callback = function(state)
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
        end
    })
end

Tabs.AutoFarm:AddSection("Auto Farm")
local MobFolder = workspace:WaitForChild("Mob")
local MobNames = {}

for _, mob in pairs(MobFolder:GetChildren()) do
    if mob:IsA("Model") and not table.find(MobNames, mob.Name) then
        table.insert(MobNames, mob.Name)
    end
end

table.sort(MobNames)

local SelectedMob = MobNames[1]
local Dropdown = Tabs.AutoFarm:AddDropdown("MobDropdown", {
    Title = "SelectedMob",
    Values = MobNames,
    Multi = false,
    Default = SelectedMob,
})

Dropdown:OnChanged(function(Value)
    SelectedMob = Value
end)

local Distance = 25
local Input = Tabs.AutoFarm:AddInput("DistanceInput", {
    Title = "Distance",
    Default = "25",
    Placeholder = "ใส่ตัวเลข เช่น 50",
    Numeric = true,
    Finished = true,
})

Input:OnChanged(function(Value)
    local num = tonumber(Value)
    if num then
        Distance = math.clamp(num, 0, 100) 
    end
end)

local Toggle = Tabs.AutoFarm:AddToggle("AutoFarmToggle", {Title = "Auto Farm", Default = false })
local AutoClickToggle = Tabs.AutoFarm:AddToggle("AutoClickToggle", {Title = "Auto Click", Default = false })

Toggle:OnChanged(function(Value)
    _G.AutoFarm = Value

    if _G.AutoFarm then
        task.spawn(function()
            while _G.AutoFarm do
                pcall(function()
                    local player = game.Players.LocalPlayer
                    local char = player.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")

                    if not hrp then return end

                    for _, v in pairs(workspace.Mob:GetChildren()) do
                        if v.Name == SelectedMob and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                            local humanoid = v.Humanoid
                            if humanoid.Health > 0 then
                                local targetPos = v.HumanoidRootPart.Position + Vector3.new(0, Distance, 0)

                                -- หันหน้าเฉพาะแนวนอน (ล็อก Y)
                                local lookDirection = Vector3.new(
                                    v.HumanoidRootPart.Position.X,
                                    hrp.Position.Y,
                                    v.HumanoidRootPart.Position.Z
                                )

                                local newCFrame = CFrame.lookAt(targetPos, lookDirection)

                                -- ป้องกันการกลับหลังหัน
                                local directionToTarget = (lookDirection - targetPos).Unit
                                if newCFrame.LookVector:Dot(directionToTarget) < 0 then
                                    newCFrame = newCFrame * CFrame.Angles(0, math.pi, 0)
                                end

                                hrp.CFrame = newCFrame

                                -- ถ้าเปิด Auto Click
                                if AutoClickToggle.Value then
                                    -- ทำการคลิกที่ศัตรู
                                    local mouse = game.Players.LocalPlayer:GetMouse()
                                    mouse.Target = v.HumanoidRootPart
                                    mouse:Click()
                                end

                                break
                            end
                        end
                    end
                end)
                task.wait(0.1) -- ลดความเร็วของ loop ให้ช้าลง
            end
        end)
    else
        -- รีเซ็ตตำแหน่งลงพื้นเมื่อปิด AutoFarm
        local player = game.Players.LocalPlayer
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")

        if hrp then
            -- ใช้ Raycast เพื่อตรวจสอบพื้น
            local rayOrigin = hrp.Position
            local rayDirection = Vector3.new(0, -100, 0) -- มองลง

            local raycastParams = RaycastParams.new()
            raycastParams.FilterDescendantsInstances = {char}
            raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

            local result = workspace:Raycast(rayOrigin, rayDirection, raycastParams)

            if result then
                hrp.CFrame = CFrame.new(result.Position + Vector3.new(0, 3, 0)) -- ยืนเหนือตำแหน่งพื้น 3 หน่วย
            end
        end
    end
end)
