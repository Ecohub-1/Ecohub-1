local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Eco Hub " .. Fluent.Version,
    SubTitle = "by zer09Xz",
    TabWidth = 150,
    Size = UDim2.fromOffset(580, 400),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "" }),
    AutoFarm = Window:AddTab({ Title = "AutoFarm", Icon = "" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}
Tabs.Main:AddSection("Aimbot")

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local camera = game.Workspace.CurrentCamera
local fov = 60
local aimbotEnabled = false

local Aimbot = Tabs.Main:AddToggle("Aimbot", {Title = "Aimbot", Default = false})

Aimbot:OnChanged(function()
    aimbotEnabled = Aimbot.Value
end)

local Fov = Tabs.Main:AddInput("Fov", {
    Title = "Adjust FOV",
    Default = tostring(fov),
    Placeholder = "Enter FOV value",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        fov = tonumber(Value) or fov
    end
})

Fov:OnChanged(function()
    fov = tonumber(Input.Value) or fov
end)

local function drawFOVCircle()
    local screenCenter = camera:WorldToScreenPoint(camera.CFrame.Position)
    local fovCircle = Instance.new("Part")
    fovCircle.Shape = Enum.PartType.Ball
    fovCircle.Size = Vector3.new(fov, fov, fov)
    fovCircle.Position = camera.CFrame.Position
    fovCircle.Color = Color3.fromRGB(255, 0, 0)
    fovCircle.Anchored = true
    fovCircle.CanCollide = false
    fovCircle.Transparency = 0.5
    fovCircle.Parent = workspace

    game:GetService("Debris"):AddItem(fovCircle, 0.5)
end

local function getClosestTarget()
    local closestTarget = nil
    local shortestDistance = math.huge

    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj.Humanoid.Health > 0 then
            local head = obj:FindFirstChild("Head")
            if head then
                local distance = (camera.CFrame.Position - head.Position).magnitude
                local screenPos, onScreen = camera:WorldToScreenPoint(head.Position)

                if onScreen then
                    if distance < shortestDistance and distance < fov then
                        closestTarget = head
                        shortestDistance = distance
                    end
                end
            end
        end
    end
    return closestTarget
end

local function aimbot()
    while true do
        if aimbotEnabled then
            local target = getClosestTarget()

            if target then
                local targetPosition = target.Position
                local direction = (targetPosition - camera.CFrame.Position).unit
                local newCFrame = CFrame.lookAt(camera.CFrame.Position, targetPosition)
                camera.CFrame = newCFrame
            end
        end
        wait(0.1)
    end
end

spawn(aimbot)

while true do
    drawFOVCircle()
    wait(0.1)
end
