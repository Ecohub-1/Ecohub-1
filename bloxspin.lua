local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Eco Hub" .. Fluent.Version,
    SubTitle = " | by zer09Xz",
    TabWidth = 150,
    Size = UDim2.fromOffset(580, 400),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Aimbot = Window:AddTab({ Title = "Aimbot", Icon = "" }),
    Weapon = Window:AddTab({ Title = "Weapon", Icon = "" }),
    ESP = Window:AddTab({ Title = "ESP", Icon = "" }),
    Player = Window:AddTab({ Title = "Player", Icon = "" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local player = game.Players.LocalPlayer
local backpack = player.Backpack

local maxRange = 50
local maxSpeed = 10

local Dropdown = Tabs.Weapon:AddDropdown("ItemDropdown", {
    Title = "Select Item",
    Values = {},
    Multi = false,
    Default = 1,
})

local EnableAdjustmentToggle = Tabs.Weapon:AddToggle("EnableAdjustmentToggle", {
    Title = "Enable Adjustments",
    Default = false,
})

local function refreshItemNames()
    local itemNames = {}
    for _, item in ipairs(backpack:GetChildren()) do
        table.insert(itemNames, item.Name)
    end
    Dropdown:SetValues(itemNames)
    if #itemNames > 0 then
        Dropdown:SetValue(itemNames[1])
    end
end

Tabs.Weapon:AddButton({
    Title = "Refresh Items",
    Callback = refreshItemNames,
})

refreshItemNames()

local RangeInput = Tabs.Weapon:AddInput("RangeInput", {
    Title = "Range",
    Default = "10",
    Placeholder = "Enter Range",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        local newRange = tonumber(Value)
        if newRange and newRange <= maxRange then
            local item = backpack:FindFirstChild(Dropdown.Value)
            if item and EnableAdjustmentToggle.Value then
                item:SetAttribute("Range", newRange)
            end
        end
    end
})

local SpeedInput = Tabs.Weapon:AddInput("SpeedInput", {
    Title = "Speed",
    Default = "5",
    Placeholder = "Enter Speed",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        local newSpeed = tonumber(Value)
        if newSpeed and newSpeed <= maxSpeed then
            local item = backpack:FindFirstChild(Dropdown.Value)
            if item and EnableAdjustmentToggle.Value then
                item:SetAttribute("Speed", newSpeed)
            end
        end
    end
})

task.spawn(function()
    while true do
        task.wait(0.5)

        if EnableAdjustmentToggle.Value then
            local selectedItem = backpack:FindFirstChild(Dropdown.Value)
            
            if selectedItem then
                local currentRange = selectedItem:GetAttribute("Range") or 10
                if currentRange < maxRange then
                    selectedItem:SetAttribute("Range", currentRange + 1)
                end
                
                local currentSpeed = selectedItem:GetAttribute("Speed") or 5
                if currentSpeed < maxSpeed then
                    selectedItem:SetAttribute("Speed", currentSpeed + 1)
                end
            end
        end
    end
end)

local NoRecoilToggle = Tabs.Weapon:AddToggle("NoRecoilToggle", {
    Title = "No Recoil",
    Default = false,
})

local NoReloadToggle = Tabs.Weapon:AddToggle("NoReloadToggle", {
    Title = "No Reload Time",
    Default = false,
})

task.spawn(function()
    while true do
        task.wait(0.5)
        local selectedItem = backpack:FindFirstChild(Dropdown.Value)
        if selectedItem then
            if NoRecoilToggle.Value then
                if selectedItem:GetAttribute("Recoil") ~= nil then
                    selectedItem:SetAttribute("Recoil", 0)
                end
            end
            
            if NoReloadToggle.Value then
                if selectedItem:GetAttribute("ReloadTime") ~= nil then
                    selectedItem:SetAttribute("ReloadTime", 0)
                end
            end
        end
    end
end)


local fovRadius = 120
local targetPart = "Head"

local FovDropdown = Tabs.Aimbot:AddDropdown("FovDropdown", {
    Title = "FOV Mode",
    Values = {"Screen Center", "Mouse-based"},
    Multi = false,
    Default = 1,
})

local TargetDropdown = Tabs.Aimbot:AddDropdown("TargetDropdown", {
    Title = "Target Part",
    Values = {"Head", "Body"},
    Multi = false,
    Default = 1,
})

FovDropdown:SetValue("Screen Center")
TargetDropdown:SetValue("Head")

FovDropdown:OnChanged(function(Value)
    -- ไม่มีการพิมพ์แสดงผล
end)

TargetDropdown:OnChanged(function(Value)
    targetPart = Value
end)

local function drawFovCircle()
    if fovCircle then
        fovCircle:Remove()
    end

    local position = Vector2.new(mouse.X, mouse.Y)
    if FovDropdown.Value == "Screen Center" then
        position = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
    end

    fovCircle = Instance.new("Frame")
    fovCircle.Size = UDim2.new(0, fovRadius * 2, 0, fovRadius * 2)
    fovCircle.Position = UDim2.new(0, position.X - fovRadius, 0, position.Y - fovRadius)
    fovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
    fovCircle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    fovCircle.BackgroundTransparency = 0.5
    fovCircle.BorderSizePixel = 0
    fovCircle.Parent = game.CoreGui
end

local function shootAtTarget(target)
    local partToShoot = targetPart == "Head" and target.Character:FindFirstChild("Head") or target.Character:FindFirstChild("HumanoidRootPart")
    if partToShoot then
        local shootFrom = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if shootFrom then
            local args = {31, "shoot_gun", game.Players.LocalPlayer.Character.Uzi, CFrame.new(shootFrom.Position, partToShoot.Position)}
            game:GetService("ReplicatedStorage").Remotes.Send:FireServer(unpack(args))
        end
    end
end

local function findAndShootEnemy()
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer and player.Character then
            local target = player.Character
            if target and target:FindFirstChild("Humanoid") and target.Humanoid.Health > 0 then
                shootAtTarget(player)
            end
        end
    end
end

game:GetService("RunService").RenderStepped:Connect(function()
    drawFovCircle()
    findAndShootEnemy()
end)
