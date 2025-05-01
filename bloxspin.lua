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
Tabs.PVP:AddSection("Aimbot")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- UI: Toggle Aimbot
local Toggle = Tabs.Main:AddToggle("AimbotToggle", {
    Title = "Aimbot",
    Default = false
})

-- UI: FOV Input
local Input = Tabs.Main:AddInput("AimbotFOV", {
    Title = "Aimbot FOV",
    Default = "90", -- ค่าเริ่มต้น
    Placeholder = "Enter FOV (0-180)",
    Numeric = true,
    Finished = true
})

-- UI: วงกลม FOV
local circle = Instance.new("Frame")
circle.Size = UDim2.new(0, 180, 0, 180) -- ขนาดวงกลมเริ่มต้น
circle.Position = UDim2.new(0.5, -90, 0.5, -90) -- วางวงกลมกลางหน้าจอ
circle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
circle.BackgroundTransparency = 0.5
circle.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("ScreenGui")

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(1, 0)
corner.Parent = circle

-- ฟังก์ชันเล็งไปที่หัว
local function aimAtPlayer(targetPlayer)
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Head") then
        local head = targetPlayer.Character.Head
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, head.Position)
    end
end

-- ฟังก์ชันคำนวณระยะองศาระหว่างกล้องกับตำแหน่งเป้าหมาย
local function getAngleToTarget(position)
    local direction = (position - Camera.CFrame.Position).Unit
    local cameraLook = Camera.CFrame.LookVector
    return math.deg(math.acos(cameraLook:Dot(direction)))
end

-- ฟังก์ชันเลือกผู้เล่นที่ใกล้ที่สุดใน FOV
local function getClosestPlayerInFOV(maxFOV)
    local closestPlayer = nil
    local shortestDistance = math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local headPos = player.Character.Head.Position
            local angle = getAngleToTarget(headPos)
            if angle <= maxFOV then
                local distance = (Camera.CFrame.Position - headPos).Magnitude
                if distance < shortestDistance then
                    closestPlayer = player
                    shortestDistance = distance
                end
            end
        end
    end
    return closestPlayer
end

-- การทำงานเมื่อ Toggle เปลี่ยน
local aimbotConnection
Toggle:OnChanged(function(enabled)
    if enabled then
        -- เปิดการทำงานของ Aimbot
        aimbotConnection = RunService.RenderStepped:Connect(function()
            local fovValue = tonumber(Input.Value) or 90
            local target = getClosestPlayerInFOV(fovValue)
            if target then
                aimAtPlayer(target)
            end
        end)
    else
        -- ปิดการทำงานของ Aimbot
        if aimbotConnection then
            aimbotConnection:Disconnect()
            aimbotConnection = nil
        end
    end
end)

-- ปรับขนาดวงกลมตาม FOV ที่ตั้งไว้
Input:OnChanged(function()
    local fovValue = tonumber(Input.Value) or 90
    local circleSize = fovValue * 2 -- ขนาดวงกลมปรับตาม FOV
    circle.Size = UDim2.new(0, circleSize, 0, circleSize)
end)

-- ปุ่มกด E เพื่อสลับ Aimbot
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.E then
        Options.AimbotToggle:SetValue(not Options.AimbotToggle.Value)
    end
end)

-- เริ่มต้นให้วงกลมมีขนาดตาม FOV เริ่มต้น
local initialFOV = tonumber(Input.Value) or 90
circle.Size = UDim2.new(0, initialFOV * 2, 0, initialFOV * 2)
