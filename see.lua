local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "ECO HUB " .. Fluent.Version,
    SubTitle = " | by zero9ZX",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "align-left" }),
    Teleport = Window:AddTab({ Title = "Teleport", Icon = "layers" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" }),
}
local Options = Fluent.Options

do
    Fluent:Notify({
        Title = "Eco Hub",
        Content = "",
        SubContent = "Thank for play", 
        Duration = 10-- Set to nil to make the notification not disappear
    })

    local settings = game:GetService("Players").LocalPlayer:FindFirstChild("Settings")

    if settings then
        local attributes = { AlwaysRun = true, AutoArise = true, AutoAttack = true }

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

    -- Adding Teleport Section
    Tabs.Teleport:AddParagraph({
        Title = "Teleport",
        Content = "Select a location and teleport."
    })

    -- Dropdown for selecting teleport location
    local TeleportDropdown = Tabs.Teleport:AddDropdown("TeleportDropdown", {
        Title = "เลือกสถานที่",
        Values = {"Leveling City", 'Grass Village", "Brum Island", "Faceheal Town", "Lucky Kingdom", "Nipon City", "Mori Town"},
        Multi = false,
        Default = 1,
    })

    -- Teleport Button
    Tabs.Teleport:AddButton({
        Title = "Teleport",
        Description = "Teleport to selected location",
        Callback = function()
            local selectedValue = TeleportDropdown.Value
            local teleportLocations = {
                ["Leveling City"] = CFrame.new(576.453369140625, 28.434574127197266, 272.19970703125),
                ["Mori Town"] = CFrame.new(4872.19873, 41.0314293, -113.925926, -0.0977165624, 6.15684598e-07, -0.995214283, 5.63333913e-07, 1, 5.63333515e-07, 0.995214283, -5.05590947e-07, -0.0977165624), -- Change this to actual location
                ["Grass Village"] = CFrame.new(50, 10, 50), -- Change this to actual location
                ["Brum Island"] = CFrame.new(0, 0, 0),
                ["Faceheal Town"] = CFrame.new(0, 0, 0),
                ["Lucky Kingdom"] = CFrame.new(0, 0, 0),
                ["Niop City"] = CFrame.new(0, 0, 0),
            }

            -- Check if location exists in teleportLocations
            if teleportLocations[selectedValue] then
                -- Teleport the player to the selected location smoothly using Tween
                local target = teleportLocations[selectedValue]
                local delay = 1 -- Duration for the tween

                local tweenInfo = TweenInfo.new(delay, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
                local tween = game:GetService('TweenService'):Create(game.Players.LocalPlayer.Character.HumanoidRootPart, tweenInfo, {CFrame = target})
                
                tween:Play() -- Start the tween
                tween.Completed:Wait() -- Wait for the tween to complete before doing anything else
                
                Fluent:Notify({
                    Title = "Teleporting",
                    Content = "You are teleporting to " .. selectedValue,
                    Duration = 5
                })
            else
                Fluent:Notify({
                    Title = "Error",
                    Content = "Invalid location selected!",
                    Duration = 5
                })
            end
        end
    })

end
