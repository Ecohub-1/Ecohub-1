local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- Window
local Window = Fluent:CreateWindow({
    Title = "Eco Hub" .. Fluent.Version,
    SubTitle = " | Bloxspin",
    TabWidth = 150,
    Size = UDim2.fromOffset(580, 400),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- Tabs
local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-- Aimbot Toggle
local aimbotEnabled = false
local Aimbot = Tabs.Main:AddToggle("Aimbot", {
    Title = "Aimbot",
    Default = false
})
Aimbot:OnChanged(function()
    aimbotEnabled = Aimbot.Value
end)

-- FOV Input
local fov = 60
local Fov = Tabs.Main:AddInput("FOV", {
    Title = "FOV",
    Default = tostring(fov),
    Placeholder = "Enter FOV value",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        fov = tonumber(Value) or fov
    end
})
Fov:OnChanged(function()
    fov = tonumber(Fov.Value) or fov
end)

-- Smooth Dropdown
local smoothLevel = 0.1
local SmoothDropdown = Tabs.Main:AddDropdown("SmoothLevel", {
    Title = "Smooth Level",
    Values = {"1", "2", "3", "4", "5"},
    Multi = true,
    Default = {"3"}
})
SmoothDropdown:OnChanged(function(Value)
    local levels = {}
    for k, v in pairs(Value) do
        if v then table.insert(levels, tonumber(k)) end
    end
    if #levels > 0 then
        local max = math.max(unpack(levels))
        smoothLevel = 0.05 * max
    end
end)

-- FOV Circle Toggle
local fovCircleEnabled = false
local FovCircleToggle = Tabs.Main:AddToggle("FOVCircle", {
    Title = "Show FOV Circle",
    Default = false
})
FovCircleToggle:OnChanged(function()
    fovCircleEnabled = FovCircleToggle.Value
    if not fovCircleEnabled then
        fovCircle.Visible = false
    end
end)

-- Drawing Circle
local fovCircle = Drawing.new("Circle")
fovCircle.Color = Color3.fromRGB(0, 255, 0)
fovCircle.Thickness = 2
fovCircle.Transparency = 1
fovCircle.Filled = false
fovCircle.Visible = false

-- Update Circle Every Frame
RunService.RenderStepped:Connect(function()
    if fovCircleEnabled then
        local cam = workspace.CurrentCamera
        local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
        fovCircle.Position = center
        fovCircle.Radius = fov
        fovCircle.Visible = true
    else
        fovCircle.Visible = false
    end
end)

-- Get Closest Target
local function getClosestTarget()
    local lp = game.Players.LocalPlayer
    local char = lp.Character
    if not char or not char:FindFirstChild("Head") then return nil end

    local closest = nil
    local shortest = math.huge
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj.Humanoid.Health > 0 and obj ~= char then
            local head = obj:FindFirstChild("Head")
            if head then
                local distance = (workspace.CurrentCamera.CFrame.Position - head.Position).Magnitude
                local screenPos, onScreen = workspace.CurrentCamera:WorldToScreenPoint(head.Position)
                if onScreen and distance < shortest and distance <= fov then
                    closest = head
                    shortest = distance
                end
            end
        end
    end
    return closest
end

-- Smooth Aimbot
local function smoothAimbot(target)
    local cam = workspace.CurrentCamera
    local goal = CFrame.lookAt(cam.CFrame.Position, target.Position)
    local tweenInfo = TweenInfo.new(smoothLevel, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
    local tween = TweenService:Create(cam, tweenInfo, {CFrame = goal})
    tween:Play()
end

-- Run Aimbot
task.spawn(function()
    while task.wait(0.1) do
        if aimbotEnabled then
            local target = getClosestTarget()
            if target then
                smoothAimbot(target)
            end
        end
    end
end)
