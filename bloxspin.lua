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
    Weapon = Window:AddTab({ Title = "Weapon", Icon = "" }),
    ESP = Window:AddTab({ Title = "ESP", Icon = "" }),
    Player = Window:AddTab({ Title = "Player", Icon = "" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- ค่าตั้งต้น
local SilentAimEnabled = false
local SilentAimPart = "Head"
local FOVAngle = 90
local ShowFOV = true
local SelectedTarget = nil
local SelectingTarget = false

-- UI Toggle: เปิด/ปิด Silent Aim
local Toggle = Tabs.Main:AddToggle("SilentAimToggle", {
    Title = "Enable Silent Aim",
    Default = false
})
Toggle:OnChanged(function()
    SilentAimEnabled = Toggle.Value
end)

-- Dropdown: เลือก Head หรือ Body
local Dropdown = Tabs.Main:AddDropdown("SilentAimPartDropdown", {
    Title = "Select Aim Part",
    Values = {"Head", "Body"},
    Multi = false,
    Default = 1
})
Dropdown:OnChanged(function(Value)
    SilentAimPart = Value
end)

-- Input: ปรับค่า FOV
local Input = Tabs.Main:AddInput("FOVInput", {
    Title = "FOV",
    Default = "90",
    Placeholder = "Enter FOV",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        local val = tonumber(Value)
        if val then
            FOVAngle = val
            Camera.FieldOfView = val
        end
    end
})
Input:OnChanged(function()
    local val = tonumber(Input.Value)
    if val then
        FOVAngle = val
        Camera.FieldOfView = val
    end
end)

-- Toggle: เปิด/ปิดวงกลม FOV
local ShowFOVToggle = Tabs.Main:AddToggle("ShowFOVToggle", {
    Title = "Show FOV Circle",
    Default = true
})
ShowFOVToggle:OnChanged(function()
    ShowFOV = ShowFOVToggle.Value
    FOVCircle.Visible = ShowFOV
end)

-- ปุ่ม: เลือกเป้าด้วยเมาส์หรือสัมผัส
local SelectTargetButton = Tabs.Main:AddButton("SelectTargetButton", {
    Title = "Select Target (Click/Touch)",
    Description = "Click or touch a player to select as Silent Aim target.",
    Callback = function()
        SelectingTarget = true
    end
})

-- ตรวจจับการคลิกเลือกเป้าหมาย
UserInputService.InputBegan:Connect(function(input)
    if SelectingTarget and input.UserInputType == Enum.UserInputType.MouseButton1 then
        local mouse = LocalPlayer:GetMouse()
        local target = mouse.Target
        if target and target.Parent then
            local model = target:FindFirstAncestorOfClass("Model")
            if model and model:FindFirstChild("Humanoid") and model ~= LocalPlayer.Character then
                SelectedTarget = model
                SelectingTarget = false
            end
        end
    end
end)

-- การตรวจสอบว่าเป้าหมายยังคงมีชีวิตหรือไม่
local function IsTargetAlive(target)
    local humanoid = target:FindFirstChild("Humanoid")
    return humanoid and humanoid.Health > 0
end

-- ฟังก์ชันตรวจสอบการอยู่ใน FOV
local function IsInFOV(target)
    local screenCenter = Camera.ViewportSize / 2
    local screenPos, onScreen = Camera:WorldToViewportPoint(target.Position)
    local distanceFromCenter = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
    return onScreen and distanceFromCenter <= FOVAngle
end

-- ฟังก์ชันหาเป้าหมายใหม่
local function GetNewTarget()
    local target = GetTarget() -- ฟังก์ชันเดิมที่เลือกเป้าหมาย
    -- ถ้าเป้าหมายตายหรือนอก FOV ให้หาคนใหม่
    if not target or not IsTargetAlive(target) or not IsInFOV(target) then
        return GetClosestEnemy() -- หาเป้าหมายใหม่อัตโนมัติ
    end
    return target
end

-- Drawing: วงกลม FOV
local FOVCircle = Drawing.new("Circle")
FOVCircle.Color = Color3.fromRGB(0, 255, 0)
FOVCircle.Thickness = 1
FOVCircle.Radius = FOVAngle
FOVCircle.Filled = false
FOVCircle.Transparency = 1
FOVCircle.Visible = ShowFOV
FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

-- Drawing: เส้นโยงเป้า
local AimLine = Drawing.new("Line")
AimLine.Color = Color3.fromRGB(255, 0, 0)
AimLine.Thickness = 1
AimLine.Transparency = 1
AimLine.Visible = false

-- หาเป้าหมายใกล้สุดใน FOV
local function GetClosestEnemy()
    local closest = nil
    local closestDist = math.huge
    local screenCenter = Camera.ViewportSize / 2

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Team ~= LocalPlayer.Team and player.Character then
            local part = player.Character:FindFirstChild(SilentAimPart)
            if part then
                local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                    if dist <= FOVAngle and dist < closestDist then
                        closest = part
                        closestDist = dist
                    end
                end
            end
        end
    end
    return closest
end

-- ดึงเป้าหมายที่ใช้ยิง
local function GetTarget()
    if SelectedTarget and SelectedTarget:FindFirstChild(SilentAimPart) then
        return SelectedTarget[SilentAimPart]
    else
        return GetClosestEnemy()
    end
end

-- อัปเดตวงกลมและเส้นโยง
RunService.RenderStepped:Connect(function()
    local center = Camera.ViewportSize / 2
    FOVCircle.Position = center
    FOVCircle.Radius = FOVAngle
    FOVCircle.Visible = ShowFOV

    if SilentAimEnabled then
        local target = GetNewTarget()
        if target then
            local pos, onScreen = Camera:WorldToViewportPoint(target.Position)
            if onScreen then
                AimLine.Visible = true
                AimLine.From = center
                AimLine.To = Vector2.new(pos.X, pos.Y)
                return
            end
        end
    end
    AimLine.Visible = false
end)

-- Hook ยิง: แก้ทิศทางกระสุนไปยังเป้า
local __namecall
__namecall = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    if not checkcaller() and SilentAimEnabled then
        if method == "FireServer" and args[2] == "shoot_gun" then
            local target = GetNewTarget()  -- ใช้ GetNewTarget() ที่ตรวจสอบแล้ว
            if target then
                args[4] = CFrame.new(target.Position)
                return __namecall(self, unpack(args))
            end
        end
    end
    return __namecall(self, ...)
end)
