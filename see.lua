
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Eco Hub",
    SubTitle = " | Rock Fruit",
    TabWidth = 150,
    Size = UDim2.fromOffset(580, 400),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "" }),
    Autoboss = Window:AddTab({ Title = "Boss", Icon = "" }),
    Dungeon = Window:AddTab({ Title = "Dungeon", Icon = "" }),
    Misc = Window:AddTab({ Title = "Settings", Icon = "" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local search = {
    Values = {}
}

for _, v in pairs(game:GetService("Workspace").mob:GetChildren()) do
    table.insert(search.Values, v.Name)
end

local searchDropdown = Tabs.Main:AddDropdown({
    Name = "search",
    Title = "Search Mob",
    Values = search.Values,
    Multi = false,
    AllowNull = true,
    Callback = function(v)
        search.Value = v
    end
})
local function lookAtTarget(character, targetPosition)
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end

    local direction = (targetPosition - rootPart.Position).Unit

    
    rootPart.CFrame = CFrame.lookAt(rootPart.Position, rootPart.Position + Vector3.new(direction.X, 0, direction.Z))
end

local AutoFarm = Tabs.Main:AddToggle({
    Name = "AutoFarm",
    Title = "Auto Farm",
    Default = false
})

game:GetService("RunService").Heartbeat:Connect(function()
    if AutoFarm.Value then
        for _, mob in pairs(game:GetService("Workspace").mob:GetChildren()) do
            if mob.Name == search.Value and mob:FindFirstChild("Humanoid") then
                local humanoid = mob:FindFirstChild("Humanoid")
                if humanoid.Health > 0 then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = 
                    mob.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0)
                end
            end
        end
    end
end)
