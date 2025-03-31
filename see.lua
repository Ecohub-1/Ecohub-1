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

if settings then local attributes = { AlwaysRun = true, AutoArise = true, AutoAttack = true }

for name, default in pairs(attributes) do
    local toggle = Tabs.Main:AddToggle(name, { Title = name, Default = settings:GetAttribute(name) or default })
    
    toggle:OnChanged(function(value)
        settings:SetAttribute(name, value)
        print(name .. " changed to:", value)
    end)
end

Fluent:Notify({ Title = "Fluent UI", Content = "Settings Loaded!", Duration = 5 })

else Fluent:Notify({ Title = "Error", Content = "Settings not found!", Duration = 5 }) end



    Tabs.Teleport:AddParagraph({
        Title = "Teleport",
        Content = "tp to island"
    })



    Tabs.Teleport:AddButton({
        Title = "Solo leveling",
        Description = "tp to Solo leveling city",
        Callback = function()
            Window:Dialog({
                Title = "TP",
                Content = "Are you sure you want to teleport?",
                Buttons = {
                    {
                        Title = "Confirm",
                        Callback = function()
              Delays = 10; target = CFrame.new(576.453369140625, 28.434574127197266, 272.19970703125)
Tween = TweenInfo.new(Delays, Enum.EasingStyle.Linear)
local tween = game:GetService('TweenService'):Create(game.Players.LocalPlayer.Character.HumanoidRootPart,Tween,{CFrame = target})
tween:Play()
tween.Completed:Wait()
                        end
                    },
                }
            })
        end
    })
end
