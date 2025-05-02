local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- SETTINGS
local FOV_RADIUS = 150
local SilentAim = true

-- FOV CIRCLE
local circle = Drawing.new("Circle")
circle.Color = Color3.fromRGB(255, 0, 0)
circle.Thickness = 1
circle.NumSides = 100
circle.Radius = FOV_RADIUS
circle.Filled = false
circle.Transparency = 1

RunService.RenderStepped:Connect(function()
    circle.Position = Vector2.new(Mouse.X, Mouse.Y)
end)

-- หาเป้าหมายที่ใกล้สุดใน FOV
local function GetClosestInFOV()
    local closest = nil
    local shortest = FOV_RADIUS

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local pos, visible = Camera:WorldToViewportPoint(player.Character.Head.Position)
            local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude

            if visible and dist < shortest then
                shortest = dist
                closest = player
            end
        end
    end

    return closest
end

-- HOOK NAMECALL
local mt = getrawmetatable(game)
setreadonly(mt, false)
local old = mt.__namecall

mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()

    if SilentAim and tostring(method) == "FindPartOnRayWithIgnoreList" then
        local target = GetClosestInFOV()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            -- ตรวจสอบให้แน่ใจว่ากล้องไม่ได้ถูกล็อค
            local origin = Camera.CFrame.Position
            local direction = (target.Character.Head.Position - origin).Unit * 1000
            args[1] = Ray.new(origin, direction)
            return old(self, unpack(args))
        end
    end

    return old(self, ...)
end)

setreadonly(mt, true)
