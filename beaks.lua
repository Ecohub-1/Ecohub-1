local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Eco Hub" .. Fluent.Version,
    SubTitle = " | by zer09Xz",
    TabWidth = 150,
    Size = UDim2.fromOffset(580, 400),
    Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local backpack = player:WaitForChild("Backpack")
local gunRemote = ReplicatedStorage:WaitForChild("Util"):WaitForChild("Net"):FindFirstChild("RE/GunSE")
local RegionsFolder = workspace:WaitForChild("Regions")

-- หาอาวุธประเภทปืน
local weapon
for _, item in ipairs(backpack:GetChildren()) do
    if item:IsA("Tool") and item.Name:match("^Rifle") then
        weapon = item
        break
    end
end

-- Toggle เปิด/ปิด Kill Aura
local Toggle = Tabs.Main:AddToggle("MyToggle", {
    Title = "Kill Aura",
    Default = false,
})

Toggle:OnChanged(function()
    print("Kill Aura toggle changed:", Options.MyToggle.Value)
end)

-- Dropdown รายชื่อโซน
local regionNames = {}
for _, child in ipairs(RegionsFolder:GetChildren()) do
    table.insert(regionNames, child.Name)
end

local Dropdown = Tabs.Main:AddDropdown("RegionDropdown", {
    Title = "Select Region",
    Values = regionNames,
    Multi = false,
    Default = regionNames[1] or "",
})

local currentBirdFolder = nil

-- เมื่อเลือกโซน
Dropdown:OnChanged(function(Value)
    local selectedRegion = RegionsFolder:FindFirstChild(Value)
    if selectedRegion and selectedRegion:FindFirstChild("ClientBirds") then
        currentBirdFolder = selectedRegion.ClientBirds
        print("Selected region:", Value)
    else
        currentBirdFolder = nil
        warn("Selected region has no ClientBirds folder")
    end
end)

-- Kill Aura ทำงานเมื่อ Toggle ถูกเปิด
local range = 100

RunService.RenderStepped:Connect(function()
    if Options.MyToggle.Value and weapon and currentBirdFolder and character and character:FindFirstChild("HumanoidRootPart") then
        for _, bird in ipairs(currentBirdFolder:GetChildren()) do
            if bird:IsA("Model") and bird:FindFirstChild("HumanoidRootPart") then
                local hrp = bird.HumanoidRootPart
                local distance = (hrp.Position - character.HumanoidRootPart.Position).Magnitude
                if distance <= range then
                    local args = {
                        [1] = "BulletFired",
                        [2] = weapon,
                        [3] = hrp.Position,
                        [4] = "Dart"
                    }
                    gunRemote:FireServer(unpack(args))
                end
            end
        end
    end
end)
