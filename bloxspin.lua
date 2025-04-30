local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Eco Hub" .. Fluent.Version,
    SubTitle = "by zer09Xz",
    TabWidth = 150,
    Size = UDim2.fromOffset(580, 400),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    PVP = Window:AddTab({ Title = "PVP", Icon = "" }),
    AutoFarm = Window:AddTab({ Title = "AutoFarm", Icon = "" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- UI Elements
local fovAngle = 90
local aimEnabled = false
local wallCheckEnabled = false
local aimPart = "Head"
local smoothness = 3

local Toggle = Tabs.Main:AddToggle("Toggle", { Title = "Aimbot", Default = false })
Toggle:OnChanged(function(val) aimEnabled = val end)

local FovInput = Tabs.Main:AddInput("FOV", {
    Title = "FOV Angle",
    Default = tostring(fovAngle),
    Placeholder = "Enter FOV",
    Numeric = true,
    Finished = true,
    Callback = function(val)
        local v = tonumber(val)
        if v and v >= 1 and v <= 180 then fovAngle = v end
    end
})

local AimDropdown = Tabs.Main:AddDropdown("AimPart", {
    Title = "Aim Part",
    Values = {"Head", "HumanoidRootPart"},
    Multi = false,
    Default = 1,
})
AimDropdown:OnChanged(function(val) aimPart = val end)

local SmoothDropdown = Tabs.Main:AddDropdown("SmoothLevel", {
    Title = "Smoothness (1-5)",
    Values = {"1","2","3","4","5"},
    Multi = false,
    Default = 3,
})
SmoothDropdown:OnChanged(function(val) smoothness = tonumber(val) end)

local WallToggle = Tabs.Main:AddToggle("WallCheck", { Title = "Check Wall", Default = false })
WallToggle:OnChanged(function(val) wallCheckEnabled = val end)

-- FOV Circle Setup
local fovCircle = Drawing.new("Circle")
fovCircle.Color = Color3.fromRGB(255, 0, 0)
fovCircle.Thickness = 2
fovCircle.Transparency = 1
fovCircle.Filled = false
fovCircle.Visible = true

-- Aimbot Functions
local function isVisible(targetPart)
    if not wallCheckEnabled then return true end
    local origin = Camera.CFrame.Position
    local direction = (targetPart.Position - origin)
    local result = workspace:Raycast(origin, direction, RaycastParams.new())

    -- เช็คว่าถ้าไม่มีการชน หรือ ชนตัว target เองให้ถือว่า "มองเห็น"
    if not result then return true end
    return result.Instance:IsDescendantOf(targetPart.Parent)
end

local function isInFOV(pos)
    local dir = (pos - Camera.CFrame.Position).Unit
    local angle = math.deg(math.acos(Camera.CFrame.LookVector:Dot(dir)))
    return angle <= (fovAngle / 2)
end

local function getClosestTarget()
    local closest = nil
    local shortest = math.huge

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
            local humanoid = player.Character.Humanoid
            if humanoid and humanoid.Health > 0 then
                local part = player.Character:FindFirstChild(aimPart)
                if part and isInFOV(part.Position) and isVisible(part) then
                    local distance = (Camera.CFrame.Position - part.Position).Magnitude
                    if distance < shortest then
                        shortest = distance
                        closest = part
                    end
                end
            end
        end
    end

    return closest
end

-- Main Loop
RunService.RenderStepped:Connect(function()
    local view = Camera.ViewportSize
    fovCircle.Position = Vector2.new(view.X / 2, view.Y / 2)
    fovCircle.Radius = fovAngle
    fovCircle.Visible = true

    if aimEnabled then
        local target = getClosestTarget()
        if target then
            local current = Camera.CFrame
            local goal = CFrame.new(current.Position, target.Position)
            local factor = 1 / smoothness
            Camera.CFrame = current:Lerp(goal, factor)
        end
    end
end)

-- ESP (Extra Sensory Perception)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local function createHighlightESP(character)
    if character:FindFirstChild("ESP_Highlight") then return end
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_Highlight"
    highlight.Adornee = character
    highlight.FillColor = Color3.fromRGB(255, 255, 0)
    highlight.FillTransparency = 0.25
    highlight.OutlineTransparency = 1
    highlight.Parent = character
end

local function createESPUI(targetPlayer)
    if targetPlayer == LocalPlayer then return end

    local character = targetPlayer.Character or targetPlayer.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart")
    createHighlightESP(character)

    local screenGui = Instance.new("BillboardGui")
    screenGui.Name = "ESP_GUI"
    screenGui.AlwaysOnTop = true
    screenGui.Size = UDim2.new(0, 150, 0, 70)
    screenGui.StudsOffset = Vector3.new(0, 3.5, 0)
    screenGui.Adornee = hrp

    local bg = Instance.new("Frame", screenGui)
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundTransparency = 1

    local hpBar = Instance.new("Frame", bg)
    hpBar.Position = UDim2.new(0, 0, 0, 0)
    hpBar.Size = UDim2.new(0, 8, 1, 0)
    hpBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    hpBar.BorderSizePixel = 0

    local hpFill = Instance.new("Frame", hpBar)
    hpFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    hpFill.BorderSizePixel = 0
    hpFill.AnchorPoint = Vector2.new(0, 1)
    hpFill.Position = UDim2.new(0, 0, 1, 0)
    hpFill.Size = UDim2.new(1, 0, 1, 0)

    local nameLabel = Instance.new("TextLabel", bg)
    nameLabel.Size = UDim2.new(0, 130, 0, 18)
    nameLabel.Position = UDim2.new(0, 12, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = Color3.new(1, 1, 1)
    nameLabel.TextStrokeTransparency = 0.5
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.TextSize = 14

    local inventoryLabel = Instance.new("TextLabel", bg)
    inventoryLabel.Size = UDim2.new(0, 130, 0, 40)
    inventoryLabel.Position = UDim2.new(0, 12, 0, 20)
    inventoryLabel.BackgroundTransparency = 1
    inventoryLabel.TextColor3 = Color3.fromRGB(255, 0, 255)
    inventoryLabel.TextXAlignment = Enum.TextXAlignment.Left
    inventoryLabel.TextYAlignment = Enum.TextYAlignment.Top
    inventoryLabel.TextWrapped = true
    inventoryLabel.TextSize = 12
    inventoryLabel.Text = "Inventory:\n(กำลังโหลด...)"

    screenGui.Parent = character

    RunService.RenderStepped:Connect(function()
        if character:FindFirstChild("Humanoid") and hrp then
            local distance = (hrp.Position - Camera.CFrame.Position).Magnitude
            nameLabel.Text = targetPlayer.Name .. " | ระยะ: " .. math.floor(distance) .. "m"
            local hp = character.Humanoid.Health / character.Humanoid.MaxHealth
            hpFill.Size = UDim2.new(1, 0, math.clamp(hp, 0, 1), 0)
        end
    end)

    task.spawn(function()
        while character and character.Parent do
            if targetPlayer:FindFirstChild("Backpack") then
                local items = {}
                for _, item in ipairs(targetPlayer.Backpack:GetChildren()) do
                    table.insert(items, item.Name)
                end
                inventoryLabel.Text = "Inventory:\n" .. (#items > 0 and table.concat(items, "\n") or "ไม่มีไอเท็ม")
            end
            task.wait(1)
        end
    end)
end

local ESP = Tabs.Main:AddToggle("ESP", {Title = "ESP", Default = false})

ESP:OnChanged(function()
    if Options.MyToggle.Value then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                if player.Character then
                    createESPUI(player)
                end
                player.CharacterAdded:Connect(function()
                    wait(1)
                    createESPUI(player)
                end)
            end
        end
        Players.PlayerAdded:Connect(function(player)
            player.CharacterAdded:Connect(function()
                wait(1)
                createESPUI(player)
            end)
        end)
    else
        for _, player in ipairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("ESP_GUI") then
                player.Character.ESP_GUI:Destroy()
                if player.Character:FindFirstChild("ESP_Highlight") then
                    player.Character.ESP_Highlight:Destroy()
                end
            end
        end
    end
end)

Options.MyToggle:SetValue(false)
