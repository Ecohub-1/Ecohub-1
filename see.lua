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
    Teleport = Window:AddTab({ Title = "Teleport", Icon = "layers" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" }),
}

local Options = Fluent.Options

Fluent:Notify({ Title = "Eco Hub", Content = "", SubContent = "Thank for playing", Duration = 10 })

local settings = game:GetService("Players").LocalPlayer:FindFirstChild("Settings")

if settings then
    local attributes = { AlwaysRun = true, AutoArise = true, AutoAttack = true }

    for name, default in pairs(attributes) do
        local toggle = Tabs.Settings:AddToggle(name, { Title = name, Default = settings:GetAttribute(name) or default })
        
        toggle:OnChanged(function(value)
            settings:SetAttribute(name, value)
            print(name .. " changed to:", value)
        end)
    end

    Fluent:Notify({ Title = "Fluent UI", Content = "Settings Loaded!", Duration = 5 })
else
    Fluent:Notify({ Title = "Error", Content = "Settings not found!", Duration = 5 })
end

Tabs.Teleport:AddParagraph({ Title = "Teleport", Content = "Select a location and teleport." })

local TeleportDropdown = Tabs.Teleport:AddDropdown("TeleportDropdown", { 
    Title = "เลือกสถานที่", 
    Values = {"Leveling City", "Grass Village", "Brum Island", "Faceheal Town", "Lucky Kingdom", "Nipon City", "Mori Town"}, 
    Multi = false, 
    Default = 1, 
})

Tabs.Teleport:AddButton({
    Title = "Teleport",
    Description = "Teleport to selected location",
    Callback = function()
        local selectedValue = TeleportDropdown.Value
        local teleportLocations = {
            ["Leveling City"] = CFrame.new(576.453, 28.434, 272.199),
            ["Mori Town"] = CFrame.new(4872.198, 41.031, -113.925),
            ["Grass Village"] = CFrame.new(-3379.502, 30.260, 2242.388),
            ["Brum Island"] = CFrame.new(-2846.382, 49.484, -2015.288),
            ["Faceheal Town"] = CFrame.new(2637.912, 45.426, -2623.082),
            ["Lucky Kingdom"] = CFrame.new(197.094, 38.707, 4298.842),
            ["Nipon City"] = CFrame.new(183.854, 32.896, -4297.652),
        }

        local player = game.Players.LocalPlayer
        local character = player.Character
        local hrp = character and character:FindFirstChild("HumanoidRootPart")
        
        -- เพิ่มการตรวจสอบให้แน่ใจว่า hrp มีอยู่และพร้อมใช้งาน
        if hrp and teleportLocations[selectedValue] then
            local target = teleportLocations[selectedValue]
            local attemptCount = 0
            local maxAttempts = 10  -- กำหนดจำนวนการลองซ้ำ
            local success = false

            -- พยายามตั้งค่า CFrame ซ้ำหลายครั้ง
            repeat
                hrp.CFrame = target
                attemptCount = attemptCount + 1
                wait(0.1)  -- รอระหว่างการลองซ้ำ
                success = (hrp.Position == target.Position)  -- เช็คว่า CFrame ถูกตั้งค่าเรียบร้อยแล้ว
            until success or attemptCount >= maxAttempts

            if success then
                Fluent:Notify({
                    Title = "Teleporting",
                    Content = "You are teleporting to " .. selectedValue,
                    Duration = 5
                })
            else
                Fluent:Notify({
                    Title = "Error",
                    Content = "Failed to teleport to " .. selectedValue,
                    Duration = 5
                })
            end
        else
            Fluent:Notify({
                Title = "Error",
                Content = "Invalid location selected or HumanoidRootPart missing!",
                Duration = 5
            })
        end
    end
})
