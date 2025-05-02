-- โหลด Fluent UI
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- สร้างหน้าต่าง
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
    AutoFarm = Window:AddTab({ Title = "AutoFarm", Icon = "" }),
    Aimbot = Window:AddTab({ Title = "Aimbot", Icon = "" }),
    Weapon = Window:AddTab({ Title = "Weapon", Icon = "" }),
    ESP = Window:AddTab({ Title = "ESP", Icon = "" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local SelectedItemName = nil
local lockMode = "Mouse"  -- เริ่มต้นเลือกเป็น Mouse Lock (PC)

-- สร้าง Dropdown สำหรับเลือก Lock
local LockOptionDropdown = Tabs.Aimbot:AddDropdown("LockOptionDropdown", {
    Title = "Select Lock Option",
    Values = {"Mouse Lock (PC)", "Center Lock (Mobile)", "Lock to Head", "Lock to Body"},
    Multi = false,
    Default = 1,
})

LockOptionDropdown:SetValue("Mouse Lock (PC)")  -- ตั้งค่าเริ่มต้นให้เลือก "Mouse Lock (PC)"

LockOptionDropdown:OnChanged(function(Value)
    print("Lock option changed:", Value)
    if Value == "Mouse Lock (PC)" then
        lockMode = "Mouse"
    elseif Value == "Center Lock (Mobile)" then
        lockMode = "Center"
    elseif Value == "Lock to Head" then
        lockMode = "Head"
    elseif Value == "Lock to Body" then
        lockMode = "Body"
    end
end)

-- ฟังก์ชันสร้างวงกลม FOV
local function createFovCircle(radius)
    local screenGui = Instance.new("ScreenGui", game.Players.LocalPlayer.PlayerGui)
    local circle = Instance.new("Frame", screenGui)
    circle.AnchorPoint = Vector2.new(0.5, 0.5)
    circle.Position = UDim2.new(0.5, 0, 0.5, 0)
    circle.Size = UDim2.new(0, radius * 2, 0, radius * 2)
    circle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    circle.BackgroundTransparency = 0.5
    circle.BorderSizePixel = 0
    circle.Shape = Enum.UICornerRadius.ZERO

    return circle
end

-- ฟังก์ชันวาดเส้นกลาง FOV
local function drawFovLine(targetPosition)
    local player = game.Players.LocalPlayer
    local character = player.Character
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local camera = workspace.CurrentCamera

    local startPosition = camera.WorldToScreenPoint(humanoidRootPart.Position)
    local endPosition = camera.WorldToScreenPoint(targetPosition)
    
    local line = Instance.new("Line", game:GetService("CoreGui"))
    line.StartPosition = startPosition
    line.EndPosition = endPosition
    line.Thickness = 2
    line.Color = Color3.fromRGB(255, 0, 0)
end

-- ฟังก์ชัน Silent Aim
local function silentAim()
    local character = game.Players.LocalPlayer.Character
    if not character then return end
    local mouse = game.Players.LocalPlayer:GetMouse()
    
    local fovRadius = 200
    createFovCircle(fovRadius)  -- สร้างวงกลม FOV
    
    local targetPosition
    if lockMode == "Mouse" then
        targetPosition = mouse.Hit.p
    elseif lockMode == "Center" then
        targetPosition = workspace.CurrentCamera.CFrame.p
    elseif lockMode == "Head" then
        targetPosition = character:WaitForChild("Head").Position
    elseif lockMode == "Body" then
        targetPosition = character:WaitForChild("HumanoidRootPart").Position
    end
    
    drawFovLine(targetPosition)  -- วาดเส้นกลาง FOV
    
    -- ใช้ Raycast เพื่อยิงไปยังตำแหน่งที่เลือก
    local rayOrigin = character.HumanoidRootPart.Position
    local direction = (targetPosition - rayOrigin).unit * 1000
    local raycastResult = workspace:Raycast(rayOrigin, direction)
    
    if raycastResult then
        print("ยิงไปที่: " .. raycastResult.Position)
    end
end

-- ตั้งค่าการยิงเมื่อคลิก
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessedEvent)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and not gameProcessedEvent then
        silentAim()
    end
end)

-- กำหนดค่าต่างๆ ของอาวุธ
local RangeInput = Tabs.Weapon:AddInput("RangeInput", {
    Title = "Range Value",
    Default = "",
    Placeholder = "Enter range",
    Numeric = true,
    Finished = true,
})

local SpeedWeapon = Tabs.Weapon:AddInput("SpeedWeapon", {
    Title = "Speed Weapon",
    Default = "10",
    Placeholder = "Enter speed",
    Numeric = true,
    Finished = true,
})

RangeInput:OnChanged(function()
    local val = tonumber(RangeInput.Value)
    if SelectedItemName and val then
        val = math.min(val, 50)
        local item = findItem(SelectedItemName)
        if item then
            item:SetAttribute("Range", val)
        end
    end
end)

SpeedWeapon:OnChanged(function()
    local val = tonumber(SpeedWeapon.Value)
    if SelectedItemName and val then
        val = math.min(val, 10)
        local item = findItem(SelectedItemName)
        if item then
            item:SetAttribute("Speed", val)
        end
    end
end)

-- ฟังก์ชันค้นหาอาวุธ
local function findItem(name)
    for _, item in ipairs(LocalPlayer.Backpack:GetChildren()) do
        if item:IsA("Tool") and item.Name == name then
            return item
        end
    end
    if LocalPlayer.Character then
        for _, item in ipairs(LocalPlayer.Character:GetChildren()) do
            if item:IsA("Tool") and item.Name == name then
                return item
            end
        end
    end
    return nil
end
