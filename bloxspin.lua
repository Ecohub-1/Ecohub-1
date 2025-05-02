-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Settings
local FOV_RADIUS = 100
local SilentAim = true

-- Create FOV Circle
local circle = Drawing.new("Circle")
circle.Color = Color3.fromRGB(255, 255, 255)
circle.Thickness = 1
circle.NumSides = 100
circle.Radius = FOV_RADIUS
circle.Filled = false
circle.Transparency = 1

-- Update FOV circle position
RunService.RenderStepped:Connect(function()
    circle.Position = Vector2.new(Mouse.X, Mouse.Y)
end)

-- หาเป้าหมายใกล้สุดในวง FOV
local function GetClosestInFOV()
    local closest = nil
    local shortestDistance = FOV_RADIUS

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local pos, onScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
            local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude

            if onScreen and dist < shortestDistance then
                shortestDistance = dist
                closest = player
            end
        end
    end

    return closest
end

-- Hook Raycasts
local mt = getrawmetatable(game)
setreadonly(mt, false)
local oldNamecall = mt.__namecall

mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()

    if SilentAim and tostring(method) == "FindPartOnRayWithIgnoreList" then
        local target = GetClosestInFOV()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            local origin = Camera.CFrame.Position
            local direction = (target.Character.Head.Position - origin).Unit * 1000
            args[1] = Ray.new(origin, direction)
            return oldNamecall(self, unpack(args))
        end
    end

    return oldNamecall(self, ...)
end)
setreadonly(mt, true)ฃ
