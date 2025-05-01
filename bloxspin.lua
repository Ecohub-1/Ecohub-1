local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()

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
    Main = Window:AddTab({ Title = "Main", Icon = "" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

InterfaceManager:SetLibrary(Fluent)
InterfaceManager:BuildInterfaceSection(Window)

SaveManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetFolder("EcoHub/Aimbot")
SaveManager:BuildConfigSection(Window)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local aimbotEnabled = false
local fov = 100
local smoothness = 0.1
local showFovCircle = false

Tabs.Main:AddToggle("Aimbot", {
    Title = "Aimbot",
    Default = false
}):OnChanged(function(Value)
    aimbotEnabled = Value
end)

Tabs.Main:AddInput("FOV", {
    Title = "FOV",
    Default = tostring(fov),
    Placeholder = "Enter FOV",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        fov = tonumber(Value) or fov
    end
})

Tabs.Main:AddDropdown("SmoothLevel", {
    Title = "Smooth Level",
    Values = {"1", "2", "3", "4", "5"},
    Multi = false,
    Default = "2"
}):OnChanged(function(Value)
    smoothness = 0.05 * tonumber(Value)
end)

Tabs.Main:AddToggle("FOVCircle", {
    Title = "Show FOV Circle",
    Default = false
}):OnChanged(function(Value)
    showFovCircle = Value
end)

local circle = Drawing.new("Circle")
circle.Thickness = 2
circle.Filled = false
circle.Color = Color3.fromRGB(0, 255, 0)
circle.Transparency = 1
circle.Visible = false

RunService.RenderStepped:Connect(function()
    if showFovCircle then
        circle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        circle.Radius = fov
        circle.Visible = true
    else
        circle.Visible = false
    end
end)

local function getClosestTarget()
    local closestTarget = nil
    local shortestDistance = math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local head = player.Character.Head
            local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
            if onScreen then
                local distance = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)).Magnitude
                if distance < fov and distance < shortestDistance then
                    shortestDistance = distance
                    closestTarget = head
                end
            end
        end
    end

    return closestTarget
end

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

task.delay(1, function()
    SaveManager:LoadAutoloadConfig()
end)
