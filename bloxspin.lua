local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Eco Hub" .. Fluent.Version,
    SubTitle = " | Bloxspin",
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

local aimbotEnabled = false
local Aimbot = Tabs.Main:AddToggle("Aimbot", {
    Title = "Aimbot",
    Default = false
})

Aimbot:OnChanged(function()
    aimbotEnabled = Aimbot.Value
end)

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

local function drawFOVCircle()
    local screenCenter = game.Workspace.CurrentCamera:WorldToScreenPoint(game.Workspace.CurrentCamera.CFrame.Position)
    local fovCircle = Instance.new("ImageLabel")
    fovCircle.Size = UDim2.new(0, fov * 2, 0, fov * 2)
    fovCircle.Position = UDim2.new(0.5, -fov, 0.5, -fov)
    fovCircle.BackgroundTransparency = 1
    fovCircle.Image = "rbxassetid://12345678"
    fovCircle.Parent = game.CoreGui

    game:GetService("Debris"):AddItem(fovCircle, 0.1)
end

local function getClosestTarget()
    local closestTarget = nil
    local shortestDistance = math.huge

    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj.Humanoid.Health > 0 then
            local head = obj:FindFirstChild("Head")
            if head then
                local distance = (game.Workspace.CurrentCamera.CFrame.Position - head.Position).magnitude
                local screenPos, onScreen = game.Workspace.CurrentCamera:WorldToScreenPoint(head.Position)

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
                local newCFrame = CFrame.lookAt(game.Workspace.CurrentCamera.CFrame.Position, targetPosition)
                game.Workspace.CurrentCamera.CFrame = newCFrame
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
