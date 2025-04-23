local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Eco Hub 1.0" ,
    SubTitle = " | by zer09Xz",
    TabWidth = 150,
    Size = UDim2.fromOffset(580, 400),
    Acrylic = true, 
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl 
})

local Tabs = {
    Main = Window:AddTab({ Title = "Auto Farm", Icon = "earth" }),
    Game = Window:AddTab({ Title = "Game", Icon = "gamepad-2" }),
    other = Window:AddTab({ Title = "other", Icon = "chart-column-decreasing" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" }),
}

local replicatedStorage = game:GetService("ReplicatedStorage")
local autoPlayRemote = replicatedStorage.Remote.Server.Units.AutoPlay


local AutoPlay = Tabs.Game:AddToggle("AutoPlayToggle", {
    Title = "AutoPlay",
    Default = false
})

Toggle:OnChanged(function(value)
    if value then
        autoPlayRemote:FireServer()
    else
        -- ถ้ามี Remote สำหรับปิด AutoPlay ให้ใส่ตรงนี้
        -- ตัวอย่าง: replicatedStorage.Remote.Server.Units.StopAutoPlay:FireServer()
    end
end)

Options.AutoPlayToggle:SetValue(true)

