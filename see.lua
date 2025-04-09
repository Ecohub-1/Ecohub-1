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
    Description = "All credits go to the mentioned people."
})
Tabs.AutoFarm:AddSection("Auto Farm")

_G.AutoFarm = false
_G.SelectedMob = nil

local player = game.Players.LocalPlayer
local mobFolder = workspace:WaitForChild("mob")
local mobNames = {"search mob"}
local nameSet = {}

-- สร้าง Dropdown Mob
for _, mob in ipairs(mobFolder:GetChildren()) do
    if mob:IsA("Model") and not nameSet[mob.Name] then
        table.insert(mobNames, mob.Name)
        nameSet[mob.Name] = true
    end
end

local Dropdown = Tabs.AutoFarm:AddDropdown("MobDropdown", {
    Title = "Search mob",
    Values = mobNames,
    Multi = false,
    Default = "search mob",
})

Dropdown:OnChanged(function(Value)
    if Value ~= "search mob" then
        _G.SelectedMob = Value
        if _G.AutoFarm then
            StartAutoFarm()
        end
    end
end)

local Toggle = Tabs.AutoFarm:AddToggle("AutoFarmToggle", {
    Title = "Auto Farm",
    Default = false
})

Toggle:OnChanged(function(value)
    _G.AutoFarm = value
    if value and _G.SelectedMob then
        StartAutoFarm()
    end
end)

function StartAutoFarm()
    task.spawn(function()
        while _G.AutoFarm and _G.SelectedMob do
            pcall(function()
                for _, v in pairs(mobFolder:GetChildren()) do
                    if v.Name == _G.SelectedMob and v:FindFirstChild("Humanoid") then
                        local humanoid = v.Humanoid
                        if humanoid.Health > 0 then
                            local char = player.Character
                            if char and char:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("HumanoidRootPart") then
                                local mobHRP = v.HumanoidRootPart
                                local playerHRP = char.HumanoidRootPart
                                local targetPosition = mobHRP.Position + Vector3.new(0, 25, 0)
                                playerHRP.CFrame = CFrame.new(targetPosition, mobHRP.Position)
                            end
                        end
                    end
                end
            end)
            task.wait(1)
        end
    end)
end
