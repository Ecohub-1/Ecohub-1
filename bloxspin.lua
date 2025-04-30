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
    PVP = Window:AddTab({ Title = "PVP", Icon = "" }),
    AutoFarm = Window:AddTab({ Title = "AutoFarm", Icon = "" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}
Tabs.PVP:AddSection("Aimbot")

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Variables
local fovAngle, aimEnabled, wallCheckEnabled, aimPart, smoothness = 90, false, false, "Head", 3

-- UI: Aimbot
local Toggle = Tabs.PVP:AddToggle("AimbotToggle", { Title = "Aimbot", Default = false })
Toggle:OnChanged(function(val) aimEnabled = val end)

Tabs.PVP:AddInput("FOVInput", {
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

Tabs.PVP:AddDropdown("AimPart", {
    Title = "Aim Part",
    Values = {"Head", "HumanoidRootPart"},
    Multi = false,
    Default = 1,
    Callback = function(val) aimPart = val end
})

Tabs.PVP:AddDropdown("SmoothLevel", {
    Title = "Smoothness (1-5)",
    Values = {"1","2","3","4","5"},
    Multi = false,
    Default = 3,
    Callback = function(val) smoothness = tonumber(val) end
})

Tabs.PVP:AddToggle("WallCheck", { Title = "Check Wall", Default = false })
:OnChanged(function(val) wallCheckEnabled = val end)

-- FOV Circle
local fovCircle = Drawing.new("Circle")
fovCircle.Color = Color3.fromRGB(255, 0, 0)
fovCircle.Thickness = 2
fovCircle.Transparency = 1
fovCircle.Filled = false
fovCircle.Visible = false -- วงกลมจะเริ่มต้นไม่แสดง

-- Aimbot Logic
local function isVisible(targetPart)
    if not wallCheckEnabled then return true end
    local origin = Camera.CFrame.Position
    local direction = (targetPart.Position - origin)
    local result = workspace:Raycast(origin, direction, RaycastParams.new())
    return not result or result.Instance:IsDescendantOf(targetPart.Parent)
end

local function isInFOV(pos)
    local dir = (pos - Camera.CFrame.Position).Unit
    local angle = math.deg(math.acos(Camera.CFrame.LookVector:Dot(dir)))
    return angle <= (fovAngle / 2)
end

local function getClosestTarget()
    local closest, shortest = nil, math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
            local humanoid = player.Character.Humanoid
            if humanoid.Health > 0 then
                local part = player.Character:FindFirstChild(aimPart)
                if part and isInFOV(part.Position) and isVisible(part) then
                    local distance = (Camera.CFrame.Position - part.Position).Magnitude
                    if distance < shortest then
                        shortest, closest = distance, part
                    end
                end
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    local view = Camera.ViewportSize
    fovCircle.Position = Vector2.new(view.X / 2, view.Y / 2)
    fovCircle.Radius = fovAngle
    fovCircle.Visible = aimEnabled -- วงกลมจะแสดงเมื่อเปิด Aimbot

    if aimEnabled then
        local target = getClosestTarget()
        if target then
            local current = Camera.CFrame
            local goal = CFrame.new(current.Position, target.Position)
            Camera.CFrame = current:Lerp(goal, 1 / smoothness)
        end
    end
end)

Tabs.PVP:AddSection("Setting")

-- SMR (Stamina Regen)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function getCharacter()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    repeat task.wait() until character:FindFirstChild("Humanoid")
    return character
end

local SMR = Tabs.PVP:AddInput("SMR", {
    Title = "Stamina Regen",
    Default = "10",
    Placeholder = "Enter StaminaRegen value",
    Numeric = true,
    Finished = false
})

SMR:OnChanged(function(val)
    local numberValue = tonumber(val)
    if not numberValue then return end

    local character = getCharacter()
    local staminaRegenAttribute = "StaminaRegen"

    if character:GetAttribute(staminaRegenAttribute) ~= nil then
        character:SetAttribute(staminaRegenAttribute, numberValue)
    else
        character:SetAttribute(staminaRegenAttribute, numberValue)
    end
end)
