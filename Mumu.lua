local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Eco Hub : Beaks" ,
    SubTitle = " | by zer09Xz",
    TabWidth = 150,
    Size = UDim2.fromOffset(580, 400),
    Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local ATE = Tabs.Main:AddToggle("AutoEquip", {
    Title = "Auto Equip",
    Default = false
})

ATE:OnChanged(function()
    while true do
        local tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if tool and tool.Name:match("Rifle") then
            game.Players.LocalPlayer.Character.Humanoid:EquipTool(tool)
        end
        wait(0.1)
    end
end)

local tools = {}
local player = game.Players.LocalPlayer

for _, item in ipairs(player.Character:GetChildren()) do
    if item:IsA("Tool") then
        table.insert(tools, item.Name)
    end
end

local AUF = Tabs.Main:AddToggle("AutoFarm", {
    Title = "Auto Farm",
    Default = false
})

AUF:OnChanged(function(Vo)
        while Vo do
            local remote = game:GetService("ReplicatedStorage").Util.Net:FindFirstChild("RE/GunShootEvent")

            remote.OnServerEvent:Connect(function(player, action)
                if action ~= "BulletFired" then return end

                local gun = item.Name
                if not gun then return end

                local targetPosition = nil

                local ammoType = gun:GetAttribute("AmmoType") or "DefaultAmmo"
            end)
