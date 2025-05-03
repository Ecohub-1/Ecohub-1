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
    Aimbot = Window:AddTab({ Title = "Aimbot", Icon = "" }),
    Weapon = Window:AddTab({ Title = "Weapon", Icon = "" }),
    ESP = Window:AddTab({ Title = "ESP", Icon = "" }),
    Player = Window:AddTab({ Title = "Player", Icon = "" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local player = game.Players.LocalPlayer
local backpack = player.Backpack

local maxRange = 50
local maxSpeed = 10

local Dropdown = Tabs.Weapon:AddDropdown("ItemDropdown", {
    Title = "Select Item",
    Values = {},
    Multi = false,
    Default = 1,
})

local EnableAdjustmentToggle = Tabs.Weapon:AddToggle("EnableAdjustmentToggle", {
    Title = "Enable Adjustments",
    Default = false,
})

local function refreshItemNames()
    local itemNames = {}
    for _, item in ipairs(backpack:GetChildren()) do
        table.insert(itemNames, item.Name)
    end
    Dropdown:SetValues(itemNames)
    if #itemNames > 0 then
        Dropdown:SetValue(itemNames[1])
    end
end

Tabs.Weapon:AddButton({
    Title = "Refresh Items",
    Callback = refreshItemNames,
})

refreshItemNames()

local RangeInput = Tabs.Weapon:AddInput("RangeInput", {
    Title = "Range",
    Default = "10",
    Placeholder = "Enter Range",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        local newRange = tonumber(Value)
        if newRange and newRange <= maxRange then
            local item = backpack:FindFirstChild(Dropdown.Value)
            if item and EnableAdjustmentToggle.Value then
                item:SetAttribute("Range", newRange)
            end
        end
    end
})

local SpeedInput = Tabs.Weapon:AddInput("SpeedInput", {
    Title = "Speed",
    Default = "5",
    Placeholder = "Enter Speed",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        local newSpeed = tonumber(Value)
        if newSpeed and newSpeed <= maxSpeed then
            local item = backpack:FindFirstChild(Dropdown.Value)
            if item and EnableAdjustmentToggle.Value then
                item:SetAttribute("Speed", newSpeed)
            end
        end
    end
})

task.spawn(function()
    while true do
        task.wait(0.5)

        if EnableAdjustmentToggle.Value then
            local selectedItem = backpack:FindFirstChild(Dropdown.Value)
            
            if selectedItem then
                local currentRange = selectedItem:GetAttribute("Range") or 10
                if currentRange < maxRange then
                    selectedItem:SetAttribute("Range", currentRange + 1)
                end
                
                local currentSpeed = selectedItem:GetAttribute("Speed") or 5
                if currentSpeed < maxSpeed then
                    selectedItem:SetAttribute("Speed", currentSpeed + 1)
                end
            end
        end
    end
end)

local NoRecoilToggle = Tabs.Weapon:AddToggle("NoRecoilToggle", {
    Title = "No Recoil",
    Default = false,
})

local NoReloadToggle = Tabs.Weapon:AddToggle("NoReloadToggle", {
    Title = "No Reload Time",
    Default = false,
})

task.spawn(function()
    while true do
        task.wait(0.5)
        local selectedItem = backpack:FindFirstChild(Dropdown.Value)
        if selectedItem then
            if NoRecoilToggle.Value then
                if selectedItem:GetAttribute("Recoil") ~= nil then
                    selectedItem:SetAttribute("Recoil", 0)
                end
            end
            
            if NoReloadToggle.Value then
                if selectedItem:GetAttribute("ReloadTime") ~= nil then
                    selectedItem:SetAttribute("ReloadTime", 0)
                end
            end
        end
    end
end)

local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "PlayerUI"
gui.ResetOnSpawn = false
gui.Enabled = false  -- ปิด UI เริ่มต้น

local function makeRound(instance, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = instance
end

-- UI Colors
local bgColor = Color3.fromRGB(245, 250, 255)
local darkColor = Color3.fromRGB(45, 45, 55)

-- Player List Panel
local listFrame = Instance.new("Frame", gui)
listFrame.Size = UDim2.new(0, 220, 0, 300)
listFrame.Position = UDim2.new(0, 20, 0.5, -150)
listFrame.BackgroundColor3 = bgColor
listFrame.BorderSizePixel = 0
makeRound(listFrame, 12)

-- Header
local listHeader = Instance.new("TextLabel", listFrame)
listHeader.Size = UDim2.new(1, -20, 0, 35)
listHeader.Position = UDim2.new(0, 10, 0, 10)
listHeader.BackgroundColor3 = darkColor
listHeader.Text = "Player List"
listHeader.Font = Enum.Font.GothamBold
listHeader.TextColor3 = Color3.new(1, 1, 1)
listHeader.TextSize = 18
listHeader.BorderSizePixel = 0
makeRound(listHeader, 8)

-- Scrollable Player List
local scroll = Instance.new("ScrollingFrame", listFrame)
scroll.Size = UDim2.new(1, -20, 1, -60)
scroll.Position = UDim2.new(0, 10, 0, 50)
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.ScrollBarThickness = 6
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0

local padding = Instance.new("UIPadding", scroll)
padding.PaddingTop = UDim.new(0, 6)
padding.PaddingBottom = UDim.new(0, 6)

-- Detail Frame
local detailFrame = Instance.new("Frame", gui)
detailFrame.Size = UDim2.new(0, 320, 0, 220)
detailFrame.Position = UDim2.new(0.5, -160, 0.5, -110)
detailFrame.BackgroundColor3 = bgColor
detailFrame.Visible = false
detailFrame.Active = true
detailFrame.Draggable = true
makeRound(detailFrame, 12)

-- Close Button
local closeButton = Instance.new("TextButton", detailFrame)
closeButton.Size = UDim2.new(0, 28, 0, 28)
closeButton.Position = UDim2.new(1, -36, 0, 8)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
closeButton.Text = "X"
closeButton.Font = Enum.Font.GothamBold
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.TextSize = 14
makeRound(closeButton, 8)

closeButton.MouseButton1Click:Connect(function()
    detailFrame.Visible = false
end)

-- Name Label
local nameLabel = Instance.new("TextLabel", detailFrame)
nameLabel.Size = UDim2.new(1, -80, 0, 28)
nameLabel.Position = UDim2.new(0, 16, 0, 8)
nameLabel.BackgroundTransparency = 1
nameLabel.Text = ""
nameLabel.Font = Enum.Font.GothamBold
nameLabel.TextColor3 = darkColor
nameLabel.TextSize = 18
nameLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Item Display Frame
local itemFrame = Instance.new("Frame", detailFrame)
itemFrame.Size = UDim2.new(1, -32, 0, 160)
itemFrame.Position = UDim2.new(0, 16, 0, 50)
itemFrame.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
makeRound(itemFrame, 12)

local grid = Instance.new("UIGridLayout", itemFrame)
grid.CellSize = UDim2.new(0, 60, 0, 60)
grid.CellPadding = UDim2.new(0, 8, 0, 8)

-- Show multiple items from Backpack (All items)
local function showItemFromBackpack(targetPlayer)
    -- Clear existing items
    for _, child in ipairs(itemFrame:GetChildren()) do
        if not child:IsA("UIGridLayout") then
            child:Destroy()
        end
    end

    local backpack = targetPlayer:FindFirstChild("Backpack")
    if backpack then
        for _, item in ipairs(backpack:GetChildren()) do
            if item:IsA("Tool") then
                local image = Instance.new("ImageLabel", itemFrame)
                image.Size = UDim2.new(0, 60, 0, 60)
                image.BackgroundTransparency = 1
                makeRound(image, 6)

                -- Check if the item has a valid TextureId
                local textureId = item.TextureId
                if textureId and textureId ~= "" then
                    -- Try to extract the numeric ID from the TextureId string
                    local id = textureId:match("%d+")
                    if id then
                        image.Image = "rbxassetid://" .. id
                    else
                        -- Show "bug" message if the TextureId is invalid
                        local bugMessage = Instance.new("TextLabel", itemFrame)
                        bugMessage.Size = UDim2.new(1, 0, 1, 0)
                        bugMessage.BackgroundTransparency = 1
                        bugMessage.Text = "Bug: No valid Image"
                        bugMessage.TextColor3 = Color3.fromRGB(255, 0, 0)
                        bugMessage.Font = Enum.Font.GothamBold
                        bugMessage.TextSize = 12
                        bugMessage.TextAlign = Enum.TextXAlignment.Center
                        makeRound(bugMessage, 6)
                    end
                else
                    -- Show "bug" message if there is no TextureId
                    local bugMessage = Instance.new("TextLabel", itemFrame)
                    bugMessage.Size = UDim2.new(1, 0, 1, 0)
                    bugMessage.BackgroundTransparency = 1
                    bugMessage.Text = "Bug: No Image"
                    bugMessage.TextColor3 = Color3.fromRGB(255, 0, 0)
                    bugMessage.Font = Enum.Font.GothamBold
                    bugMessage.TextSize = 12
                    bugMessage.TextAlign = Enum.TextXAlignment.Center
                    makeRound(bugMessage, 6)
                end
            end
        end
    end
end

-- Show Player Detail
local currentTarget = nil
local function showPlayerDetail(targetPlayer)
    if currentTarget == targetPlayer then
        detailFrame.Visible = false
        currentTarget = nil
    else
        currentTarget = targetPlayer
        nameLabel.Text = targetPlayer.Name
        showItemFromBackpack(targetPlayer)
        detailFrame.Visible = true
    end
end

-- Refresh Button
local refreshButton = Instance.new("TextButton", listFrame)
refreshButton.Size = UDim2.new(0, 28, 0, 28)
refreshButton.Position = UDim2.new(1, -36, 0, 10)
refreshButton.BackgroundColor3 = Color3.fromRGB(80, 180, 255)
refreshButton.Text = "⟳"
refreshButton.Font = Enum.Font.GothamBold
refreshButton.TextColor3 = Color3.new(1, 1, 1)
refreshButton.TextSize = 16
makeRound(refreshButton, 8)

-- Update Player List
local function updatePlayerList()
    scroll:ClearAllChildren()
    local yPos = 0

    for _, plr in ipairs(game.Players:GetPlayers()) do
        if plr ~= player then
            local btn = Instance.new("TextButton", scroll)
            btn.Size = UDim2.new(1, -10, 0, 36)
            btn.Position = UDim2.new(0, 5, 0, yPos)
            btn.BackgroundColor3 = darkColor
            btn.Text = plr.Name
            btn.Font = Enum.Font.Gotham
            btn.TextColor3 = Color3.new(1, 1, 1)
            btn.TextSize = 14
            btn.BorderSizePixel = 0
            makeRound(btn, 8)

            btn.MouseButton1Click:Connect(function()
                showPlayerDetail(plr)
            end)

            yPos += 45
        end
    end

    scroll.CanvasSize = UDim2.new(0, 0, 0, yPos)
end

refreshButton.MouseButton1Click:Connect(updatePlayerList)

-- Toggle UI
local Toggle = Tabs.Main:AddToggle("MyToggle", {Title = "Toggle", Default = false })

-- เพิ่มการควบคุม Toggle
Toggle:OnChanged(function()
    if Toggle.Value then
        gui.Enabled = true  -- เปิด UI เมื่อ Toggle ถูกคลิก
    else
        gui.Enabled = false  -- ปิด UI เมื่อ Toggle ถูกคลิก
    end
end)

-- ตั้งค่าเริ่มต้นของ Toggle ให้เป็น false (ปิด UI)
Toggle:SetValue(false)

-- Hook Player Events
updatePlayerList()
game.Players.PlayerAdded:Connect(updatePlayerList)
game.Players.PlayerRemoving:Connect(updatePlayerList)
