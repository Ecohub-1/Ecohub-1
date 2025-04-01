local success, Fluent = pcall(function()
    return loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
end)

if not success then
    warn("Failed to load Fluent UI!")
    return
end

local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "ECO HUB " .. Fluent.Version,
    SubTitle = " | by zero9ZX",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "align-left" }),
    AutoRank = Window:AddTab({ Title = "Rank", Icon = "layers" }),
    Teleport = Window:AddTab({ Title = "Teleport", Icon = "layers" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options
Fluent:Notify({ Title = "Eco Hub", Content = "", SubContent = "Thanks for playing", Duration = 10 })

-- Load settings
local settings = game:GetService("Players").LocalPlayer:FindFirstChild("Settings")
if settings then
    local attributes = { AutoArise = true, AutoAttack = true, AutoDestroy = true }
    for name, default in pairs(attributes) do
        local toggle = Tabs.Main:AddToggle(name, { Title = name, Default = settings:GetAttribute(name) or default })
        toggle:OnChanged(function(value)
            settings:SetAttribute(name, value)
            print(name .. " changed to:", value)
        end)
    end
    Fluent:Notify({ Title = "Fluent UI", Content = "Settings Loaded!", Duration = 5 })
else
    Fluent:Notify({ Title = "Error", Content = "Settings not found!", Duration = 5 })
end

-- สร้างปุ่มเปิด/ปิด AutoClick
local player = game:GetService("Players").LocalPlayer
local autoClickEnabled = false  -- ตั้งค่าเริ่มต้น

local ToggleAutoClickButton = Tabs.Main:AddButton({
    Title = "กดเพื่อเปิด/ปิด",  -- ชื่อปุ่ม
    Description = "เปิด/ปิด AutoClick สำหรับผู้เล่น",
    Callback = function()
        -- เปลี่ยนสถานะของ AutoClick
        autoClickEnabled = not autoClickEnabled
        player:SetAttribute("AutoClick", autoClickEnabled)
        
        if autoClickEnabled then
            print(player.Name .. " เปิด AutoClick")
        else
            print(player.Name .. " ปิด AutoClick")
        end
    end
})

-- Teleport UI
Tabs.Teleport:AddParagraph({ Title = "Teleport", Content = "Select a location and teleport." })
local TeleportDropdown = Tabs.Teleport:AddDropdown("TeleportDropdown", { Title = "Select Location", Values = {"Leveling City", "Grass Village", "Brum Island", "Faceheal Town", "Lucky Kingdom", "Nipon City", "Mori Town", "Ant Island"}, Multi = false, Default = 1 })
Tabs.Teleport:AddButton({ Title = "Teleport", Description = "Teleport to selected location", Callback = function()
    local selectedValue = TeleportDropdown.Value
    local teleportLocations = {
        ["Leveling City"] = CFrame.new(576.453, 28.434, 272.199),
        ["Mori Town"] = CFrame.new(4872.198, 41.031, -113.925),
        ["Grass Village"] = CFrame.new(-3379.502, 30.260, 2242.388),
        ["Brum Island"] = CFrame.new(-2846.382, 49.484, -2015.288),
        ["Faceheal Town"] = CFrame.new(2637.912, 45.426, -2623.082),
        ["Lucky Kingdom"] = CFrame.new(197.094, 38.707, 4298.842),
        ["Nipon City"] = CFrame.new(183.854, 32.896, -4297.652),
        ["Ant Island"] = CFrame.new(3839.946, 60.122, 3003.159)
    }

    local player = game.Players.LocalPlayer
    local character = player.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    
    if hrp and teleportLocations[selectedValue] then
        local targetPosition = teleportLocations[selectedValue]
        local TweenService = game:GetService("TweenService")
        local targetTween = TweenService:Create(hrp, TweenInfo.new(0.2), { CFrame = targetPosition })
        targetTween:Play()

        targetTween.Completed:Connect(function()
            Fluent:Notify({
                Title = "Teleporting",
                Content = "You have been teleported to " .. selectedValue,
                Duration = 5
            })
        end)
    else
        Fluent:Notify({
            Title = "Error",
            Content = "Invalid location selected or HumanoidRootPart missing!",
            Duration = 5
        })
    end
end})

-- Rank Test UI
local RankDropdown = Tabs.AutoRank:AddDropdown("RankDropdown", { Title = "Select Rank", Values = {"E", "D", "C", "B", "A", "S", "SS"}, Multi = false, Default = 1 })
Tabs.AutoRank:AddButton({ Title = "Start Rank Test", Description = "Test selected rank", Callback = function()
    local selectedRank = RankDropdown.Value
    local remoteEvent = game:GetService("ReplicatedStorage"):FindFirstChild("BridgeNet2")
    if remoteEvent and remoteEvent:FindFirstChild("dataRemoteEvent") then
        local args = {
            [1] = {
                [1] = {
                    ["Event"] = "DungeonAction",
                    ["Action"] = "TestEnter",
                    ["Rank"] = selectedRank
                },
                [2] = "\n"
            }
        }

        remoteEvent.dataRemoteEvent:FireServer(unpack(args))
        Fluent:Notify({
            Title = "Rank Test",
            Content = "Starting rank test for: " .. selectedRank,
            Duration = 5
        })
    else
        Fluent:Notify({
            Title = "Error",
            Content = "RemoteEvent not found!",
            Duration = 5
        })
    end
end})
