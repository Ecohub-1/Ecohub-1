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

_G.AutoFarm = false
local selectedMob = nil
local selectedDirection = "upstairs"
local attackDistance = 10

local function GetSortedUniqueMobNames()
    local mobFolder = game:GetService("Workspace"):FindFirstChild("mob")
    local mobNameSet = {}
    if mobFolder then
        for _, mob in pairs(mobFolder:GetChildren()) do
            if mob:IsA("Model") and mob:FindFirstChild("Humanoid") then
                mobNameSet[mob.Name] = true
            end
        end
    end
    local uniqueNames = {}
    for name, _ in pairs(mobNameSet) do
        table.insert(uniqueNames, name)
    end
    table.sort(uniqueNames)
    return uniqueNames
end

local function SetNoClip(state)
    local char = game.Players.LocalPlayer.Character
    if not char then return end
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = not state
        end
    end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        if state then
            humanoid:ChangeState(11)
        else
            humanoid:ChangeState(8)
        end
    end
end

local mobList = GetSortedUniqueMobNames()
local MobDropdown = Tabs.AutoFarm:AddDropdown("MobDropdown", {
    Title = "Search Mob",
    Values = mobList,
    Multi = false,
    Default = 1
})

MobDropdown:OnChanged(function(Value)
    selectedMob = Value
end)

selectedMob = mobList[1] or nil

local Toggle = Tabs.AutoFarm:AddToggle("MyToggle", {
    Title = "AutoFarm",
    Default = false
})

Toggle:OnChanged(function()
    _G.AutoFarm = Toggle.Value
    if _G.AutoFarm then
        SetNoClip(true)
        StartAutoFarm()
    else
        SetNoClip(false)
    end
end)

Tabs.Settings:AddSection("Auto Farm setting")

local DirectionDropdown = Tabs.AutoFarm:AddDropdown("DirectionDropdown", {
    Title = "Direction",
    Values = {"behind", "upstairs", "below"},
    Multi = false,
    Default = 2
})

DirectionDropdown:OnChanged(function(Value)
    selectedDirection = Value
end)

local DistanceSlider = Tabs.AutoFarm:AddSlider("DistanceSlider", {
    Title = "Distance",
    Default = 10,
    Min = 1,
    Max = 120,
    Rounding = 1
})

DistanceSlider:OnChanged(function(Value)
    attackDistance = Value
end)

local function MoveTowardsMob(mob)
    local char = game.Players.LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local pos = mob.HumanoidRootPart.Position
    if selectedDirection == "behind" then
        pos = pos + Vector3.new(attackDistance, 0, 0)
    elseif selectedDirection == "upstairs" then
        pos = pos + Vector3.new(0, attackDistance, 0)
    elseif selectedDirection == "below" then
        pos = pos + Vector3.new(0, -attackDistance, 0)
    end
    char.HumanoidRootPart.CFrame = CFrame.new(pos)
end

function StartAutoFarm()
    task.spawn(function()
        while _G.AutoFarm do
            local mobs = game:GetService("Workspace"):FindFirstChild("mob")
            if mobs then
                for _, v in pairs(mobs:GetChildren()) do
                    if v.Name == selectedMob and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        MoveTowardsMob(v)
                        break
                    end
                end
            end
            task.wait(0.5)
        end
    end)
end
