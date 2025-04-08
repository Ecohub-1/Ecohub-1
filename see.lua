local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Eco Hub" .. Fluent.Version,
    SubTitle = " | by zer09Xz",
    TabWidth = 150,
    Size = UDim2.fromOffset(580, 400),
    Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
})

local Tabs = {
    credit = Window:AddTab({ Title = "credit", Icon = "trophy" })
    Auto Farm = Window:AddTab({ Title = "Auto Farm", Icon = "gamepad" }),
    Auto boss = Window:AddTab({ Title = "Auto boss", Icon = "gamepad" }),
    Dungeon = Window:AddTab({ Title = "Dungeon", Icon = "globe" }),
    Teleport = Window:AddTab({ Title = "Teleport", Icon = "map-pinned" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}
