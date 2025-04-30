
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
    Main = Window:AddTab({ Title = "Main", Icon = "" }),
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
local smoothness = 10

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
    Title = "Smoothness (1-10)",
    Values = {"1","2","3","4","5","6","7","8","9","10"},
    Multi = false,
    Default = 10,
})
SmoothDropdown:OnChanged(function(val) smoothness = tonumber(val) end)

local WallToggle = Tabs.Main:AddToggle("WallCheck", { Title = "Check Wall", Default = false })
WallToggle:OnChanged(function(val) wallCheckEnabled = val end)

-- FOV Circle Setup
local fovCircle = Drawing.new("Circle")
fovCircle.Color = Color3.fromRGB(255, 0, 0)
fovCircle.Radius = fovAngle
fovCircle.Thickness = 2
fovCircle.Transparency = 1
fovCircle.Filled = false
fovCircle.Visible = true

-- Aimbot functions
local function isVisible(pos)
    if not wallCheckEnabled then return true end
    local origin = Camera.CFrame.Position
    local direction = (pos - origin).Unit * 500
    local result = workspace:Raycast(origin, direction, {LocalPlayer.Character})
    return result == nil or (result and result.Instance:IsDescendantOf(workspace:FindFirstChildWhichIsA("Model")))
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
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if humanoid and humanoid.Health > 0 then
                local part = player.Character:FindFirstChild(aimPart)
                if part and isInFOV(part.Position) and isVisible(part.Position) then
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

-- Main loop
RunService.RenderStepped:Connect(function()
    -- Update FOV circle
    local view = Camera.ViewportSize
    fovCircle.Position = Vector2.new(view.X / 2, view.Y / 2)
    fovCircle.Radius = fovAngle
    fovCircle.Visible = true

    if aimEnabled then
        local target = getClosestTarget()
        if target then
            local current = Camera.CFrame
            local goal = CFrame.new(current.Position, target.Position)
            local factor = (11 - smoothness) / 10
            Camera.CFrame = current:Lerp(goal, factor)
        end
    end
end)
