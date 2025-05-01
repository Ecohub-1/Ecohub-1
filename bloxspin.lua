-- โหลด Fluent UI
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local Window = Fluent:CreateWindow({
    Title = "Eco Hub" .. Fluent.Version,
    SubTitle = " | Aimbot",
    TabWidth = 150,
    Size = UDim2.fromOffset(580, 400),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})
local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "" })
}

-- ตั้งค่าเริ่มต้น
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local fov = 100
local smoothness = 0.1
local aimbotEnabled = false
local circleEnabled = false

-- UI: Aimbot Toggle
local Aimbot = Tabs.Main:AddToggle("Aimbot", { Title = "Aimbot", Default = false })
Aimbot:OnChanged(function(Value)
    aimbotEnabled = Value
end)

-- UI: FOV Input
local FovInput = Tabs.Main:AddInput("FOV", {
    Title = "FOV",
    Default = tostring(fov),
    Placeholder = "Enter FOV",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        fov = tonumber(Value) or fov
    end
})

-- UI: Smoothness Dropdown (1-5)
local SmoothDropdown = Tabs.Main:AddDropdown("SmoothLevel", {
    Title = "Smooth Level",
    Values = {"1", "2", "3", "4", "5"},
    Multi = false,
    Default = "2"
})
SmoothDropdown:OnChanged(function(Value)
    smoothness = 0.05 * tonumber(Value)
end)

-- UI: FOV Circle Toggle
local FovCircleToggle = Tabs.Main:AddToggle("ShowCircle", { Title = "Show FOV Circle", Default = false })
FovCircleToggle:OnChanged(function(Value)
    circleEnabled = Value
end)

-- Drawing Circle
local circle = Drawing.new("Circle")
circle.Radius = fov
circle.Thickness = 2
circle.Filled = false
circle.Color = Color3.fromRGB(0, 255, 0)
circle.Visible = false

-- Update circle position
RunService.RenderStepped:Connect(function()
    if circleEnabled then
        circle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        circle.Radius = fov
        circle.Visible = true
    else
        circle.Visible = false
    end
end)

-- ค้นหาเป้าหมายที่ใกล้ที่สุดใน FOV
local function getClosestTarget()
    local closest, shortest = nil, math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local head = player.Character.Head
            local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
            local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
            if onScreen and dist < fov and dist < shortest then
                closest = head
                shortest = dist
            end
        end
    end
    return closest
end

-- Aimbot update
RunService.RenderStepped:Connect(function()
    if aimbotEnabled then
        local target = getClosestTarget()
        if target then
            local camCF = Camera.CFrame
            local direction = (target.Position - camCF.Position).Unit
            local newCF = CFrame.new(camCF.Position, camCF.Position + direction)
            Camera.CFrame = camCF:Lerp(newCF, smoothness)
        end
    end
end)
