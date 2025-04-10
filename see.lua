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
local player = game.Players.LocalPlayer
local backpack = player.Backpack
local selectedOptions = {}

local weaponDropdown = Tabs.Settings:AddDropdown("Search weapon", {
    Title = "Search weapon",
    Values = { "Melee", "Sword", "DevilFruit", "Special" },
    Multi = true,
    Default = { "Melee", "Sword" },
    Callback = function(value)
        selectedOptions = value
    end
})

local autoEquipRunning = false

local function autoEquipLoop()
    task.spawn(function()
        while autoEquipRunning do
            if player.Character then
                for _, tool in ipairs(backpack:GetChildren()) do
                    if tool:IsA("Tool") then
                        if table.find(selectedOptions, tool:GetAttribute("Type")) then
                            tool.Parent = player.Character
                        end
                    end
                end
            end
            task.wait(0.1)
        end
    end)
end

Tabs.Settings:AddToggle("AutoEquipToggle", {
    Title = "Auto Equip all",
    Default = false,
    Callback = function(value)
        autoEquipRunning = value
        if autoEquipRunning then
            autoEquipLoop()
        end
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
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")

local MultiDropdown = Tabs.Main:AddDropdown("MultiDropdown", {
    Title = "Multi Dropdown",
    Description = "You can select multiple values.",
    Values = {"Z", "X", "C", "V", "F"},
    Multi = true,
    Default = {"Z", "X"},
})

MultiDropdown:SetValue({
    Z = true,
    X = true
})

MultiDropdown:OnChanged(function(Value)
    local Values = {}
    for Value, State in next, Value do
        table.insert(Values, Value)
    end

    for _, selectedKey in ipairs(Values) do
        sendKey(selectedKey)
    end
end)

local function sendKey(key)
    VirtualInputManager:SendKeyEvent(true, key, false, game)
    wait(0.05)
    VirtualInputManager:SendKeyEvent(false, key, false, game)
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

Toggle:OnChanged(function(Value)
    _G.AutoFarm = Value

    if _G.AutoFarm then
        task.spawn(function()
            while _G.AutoFarm do
                pcall(function()
                    local player = game.Players.LocalPlayer
                    local char = player.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    local humanoid = char and char:FindFirstChild("Humanoid")

                    if not hrp or not humanoid then return end

                    humanoid.AutoRotate = false

                    -- ถ้าตกแมพ ให้กลับ Y = 50
                    if hrp.Position.Y < workspace.FallenPartsDestroyHeight + 10 then
                        hrp.CFrame = CFrame.new(0, 50, 0)
                        return
                    end

                    for _, v in pairs(workspace.Mob:GetChildren()) do
                        if v.Name == SelectedMob and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                            local mobHRP = v.HumanoidRootPart
                            local mobHumanoid = v.Humanoid

                            if mobHumanoid.Health > 0 then
                                local targetPos = mobHRP.Position + Vector3.new(0, Distance, 0)
                                
                                -- สร้าง LookVector จากบนลงล่างเล็กน้อย
                                local lookVector = (mobHRP.Position - targetPos).Unit
                                
                                -- วาร์ปแล้วก้มมอง
                                hrp.CFrame = CFrame.lookAt(targetPos, targetPos + lookVector)

                                break
                            end
                        end
                    end
                end)

                task.wait(0.01)
            end
        end)
    else
        local player = game.Players.LocalPlayer
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local humanoid = char and char:FindFirstChild("Humanoid")

        if humanoid then
            humanoid.AutoRotate = true
        end

        -- Gradual repositioning when turning off AutoFarm
        if hrp then
            local rayOrigin = hrp.Position
            local rayDirection = Vector3.new(0, -100, 0)

            local raycastParams = RaycastParams.new()
            raycastParams.FilterDescendantsInstances = {char}
            raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

            local result = workspace:Raycast(rayOrigin, rayDirection, raycastParams)

            if result then
                -- Use a smoother method instead of directly setting CFrame
                local targetPosition = result.Position + Vector3.new(0, 3, 0)
                local currentPos = hrp.Position
                local difference = targetPosition - currentPos

                -- Smooth transition over time
                local duration = 0.5 -- Adjust the time taken for the transition
                local startTime = tick()

                -- Tween the HRP position back smoothly
                while tick() - startTime < duration do
                    hrp.CFrame = CFrame.new(currentPos + difference * ((tick() - startTime) / duration))
                    task.wait(0.03)
                end
                hrp.CFrame = CFrame.new(targetPosition) -- Final position
            end
        end
    end
end)

Tabs.AutoFarm:AddSection("Auto boss")
local Dropdown = Tabs.AutoFarm:AddDropdown("Dropdown", {
    Title = "Dropdown",
    Values = {"Vasto Hollw", "Phoenix Man", "Spongebob", "Ghost Gojo"},
    Multi = false,
    Default = 1,
})

Dropdown:SetValue("Ghost Gojo")

local Toggle = Tabs.AutoFarm:AddToggle("AutobossToggle", {Title = "Auto Farm", Default = false})

local notificationSent = false  -- Flag to track if the notification has been sent

Toggle:OnChanged(function(Value)
    _G.Autoboss = Value

    if _G.Autoboss then
        task.spawn(function()
            while _G.Autoboss do
                pcall(function()
                    local player = game.Players.LocalPlayer
                    local char = player.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    local humanoid = char and char:FindFirstChild("Humanoid")

                    if not hrp or not humanoid then return end

                    humanoid.AutoRotate = false

                    if hrp.Position.Y < workspace.FallenPartsDestroyHeight + 10 then
                        hrp.CFrame = CFrame.new(0, 50, 0)
                        return
                    end

                    local selectedMob = Dropdown.Value

                    local args = {}
                    if selectedMob == "Vasto Hollw" then
                        args = {"Orb Demon"}
                    elseif selectedMob == "Phoenix Man" then
                        args = {"Banana"}
                    elseif selectedMob == "Spongebob" then
                        args = {"Banana"}
                    elseif selectedMob == "Ghost Gojo" then
                        args = {"Orb Demon"}
                    end

                    -- Check if the item exists in the inventory
                    local inventoryItems = {}
                    for _, item in pairs(game:GetService("ReplicatedStorage").Remotes.Inventory:GetChildren()) do
                        table.insert(inventoryItems, item.Name)
                    end

                    if not table.find(inventoryItems, args[1]) then
                        -- If notification hasn't been sent yet, send it and mark it as sent
                        if not notificationSent then
                            Fluent:Notify({
                                Title = "Notification",                -- Title of the notification
                                Content = "You don't have " .. args[1] .. " In your inventory!", -- Message content
                                Duration = 5                        -- Duration in seconds
                            })
                            notificationSent = true  -- Mark notification as sent
                        end
                        return
                    end

                    -- Remove or add item from/to inventory
                    game:GetService("ReplicatedStorage").Remotes.Inventory:FireServer(unpack(args))
                    
                    local summonArgs = {
                        [1] = "fire",
                        [3] = "SummonBoss",
                        [4] = selectedMob
                    }
                    game:GetService("ReplicatedStorage").Modules.NetworkFramework.NetworkEvent:FireServer(unpack(summonArgs))

                    -- Loop to check if the mob already exists in the game
                    local mobExists = false
                    for _, v in pairs(workspace.Mob:GetChildren()) do
                        if v.Name == selectedMob and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                            mobExists = true
                            local mobHRP = v.HumanoidRootPart
                            local mobHumanoid = v.Humanoid

                            if mobHumanoid.Health > 0 then
                                local targetPos = mobHRP.Position + Vector3.new(0, Distance, 0)
                                local lookVector = (mobHRP.Position - targetPos).Unit
                                hrp.CFrame = CFrame.lookAt(targetPos, targetPos + lookVector)

                                -- Attack logic or move towards the mob
                                -- (You can add any attack functionality here if needed)
                                break
                            end
                        end
                    end

                    -- If the mob doesn't exist, it will be summoned
                    if not mobExists then
                        -- You can put your mob summoning code here again if you want
                        game:GetService("ReplicatedStorage").Modules.NetworkFramework.NetworkEvent:FireServer(unpack(summonArgs))
                    end
                end)

                task.wait(0.01)
            end
        end)
    else
        local player = game.Players.LocalPlayer
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local humanoid = char and char:FindFirstChild("Humanoid")

        if humanoid then
            humanoid.AutoRotate = true
        end

        if hrp then
            local rayOrigin = hrp.Position
            local rayDirection = Vector3.new(0, -100, 0)

            local raycastParams = RaycastParams.new()
            raycastParams.FilterDescendantsInstances = {char}
            raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

            local result = workspace:Raycast(rayOrigin, rayDirection, raycastParams)

            if result then
                local targetPosition = result.Position + Vector3.new(0, 3, 0)
                local currentPos = hrp.Position
                local difference = targetPosition - currentPos

                local duration = 0.5
                local startTime = tick()

                while tick() - startTime < duration do
                    hrp.CFrame = CFrame.new(currentPos + difference * ((tick() - startTime) / duration))
                    task.wait(0.03)
                end
                hrp.CFrame = CFrame.new(targetPosition)
            end
        end
    end
end)
