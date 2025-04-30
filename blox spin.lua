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
    Main = Window:AddTab({ Title = "Main", Icon = "" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local fovRadius = 150
local fovAngle = 45
local aimbotEnabled = false
local showFOV = true
local smoothness = 10
local aimPart = "Head"

local circle = Drawing.new("Circle")
circle.Color = Color3.fromRGB(255, 0, 0)
circle.Thickness = 2
circle.Radius = fovRadius
circle.Filled = false
circle.Transparency = 1
circle.Visible = showFOV

local ToggleAimbot = Tabs.Main:AddToggle("ToggleAimbot", {Title = "Aimbot", Default = false})
ToggleAimbot:OnChanged(function(Value)
    aimbotEnabled = Value
end)

local ToggleFOV = Tabs.Main:AddToggle("ToggleFOV", {Title = "Show FOV", Default = true})
ToggleFOV:OnChanged(function(Value)
    showFOV = Value
    circle.Visible = Value
end)

local InputFOV = Tabs.Main:AddInput("InputFOV", {
    Title = "FOV Angle",
    Default = tostring(fovAngle),
    Placeholder = "Enter FOV Angle",
    Numeric = true,
    Finished = true,
    Callback = function(Value)
        local angle = tonumber(Value)
        if angle and angle >= 1 and angle <= 180 then
            fovAngle = angle
        end
    end
})

local InputRadius = Tabs.Main:AddInput("InputRadius", {
    Title = "FOV Radius",
    Default = tostring(fovRadius),
    Placeholder = "Enter FOV Radius",
    Numeric = true,
    Finished = true,
    Callback = function(Value)
        local radius = tonumber(Value)
        if radius then
            fovRadius = radius
            circle.Radius = radius
        end
    end
})

local SmoothDropdown = Tabs.Main:AddDropdown("SmoothDropdown", {
    Title = "Smoothness",
    Values = {"1","2","3","4","5","6","7","8","9","10"},
    Multi = false,
    Default = "10"
})
SmoothDropdown:OnChanged(function(Value)
    smoothness = tonumber(Value)
end)

local AimDropdown = Tabs.Main:AddDropdown("AimDropdown", {
    Title = "Aim Part",
    Values = {"Head", "HumanoidRootPart"},
    Multi = false,
    Default = "Head"
})
AimDropdown:OnChanged(function(Value)
    aimPart = Value
end)

local function isInFOV(targetPos)
    local cam = workspace.CurrentCamera
    local camDir = cam.CFrame.LookVector
    local toTarget = (targetPos - cam.CFrame.Position).Unit
    local angle = math.deg(math.acos(camDir:Dot(toTarget)))
    return angle <= (fovAngle / 2)
end

local function getTarget()
    local players = game:GetService("Players"):GetPlayers()
    local camPos = workspace.CurrentCamera.CFrame.Position
    local closest, minDist = nil, math.huge

    for _, player in ipairs(players) do
        if player ~= game.Players.LocalPlayer then
            local char = player.Character
            if char and char:FindFirstChild(aimPart) then
                local part = char[aimPart]
                if isInFOV(part.Position) and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
                    local dist = (part.Position - camPos).Magnitude
                    if dist < minDist then
                        minDist = dist
                        closest = part
                    end
                end
            end
        end
    end
    return closest
end

local function lerp(a, b, t)
    return a + (b - a) * t
end

game:GetService("RunService").RenderStepped:Connect(function()
    local cam = workspace.CurrentCamera
    local viewport = cam.ViewportSize
    circle.Position = Vector2.new(viewport.X / 2, viewport.Y / 2)
    circle.Visible = showFOV

    if aimbotEnabled then
        local target = getTarget()
        if target then
            local current = cam.CFrame.Position
            local newCF = CFrame.new(current, target.Position)
            local lerped = cam.CFrame:Lerp(newCF, smoothness / 100)
            cam.CFrame = lerped
        end
    end
end)

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("EcoHub")
SaveManager:SetFolder("EcoHub")
SaveManager:BuildConfigSection(Tabs.Settings)
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
