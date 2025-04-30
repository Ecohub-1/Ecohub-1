local player = game.Players.LocalPlayer
local character = player.Character
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local destination = CFrame.new(-235.3751220703125, 256.3490295410156, 340.40240478515625)

-- ฟังก์ชันหาทางไปยังตำแหน่งที่ต้องการ
local function moveToDestination(destinationPosition)
    local pathfindingService = game:GetService("PathfindingService")
    local humanoid = character:WaitForChild("Humanoid")

    -- สร้าง path จากตำแหน่งปัจจุบันไปยังตำแหน่งที่ต้องการ
    local path = pathfindingService:CreatePath({
        AgentRadius = 2, -- ขนาดตัวละคร
        AgentHeight = 5, -- ความสูงของตัวละคร
        AgentCanJump = true, -- สามารถกระโดดได้
        AgentJumpHeight = 10, -- ความสูงที่สามารถกระโดดได้
        AgentMaxSlope = 45, -- มุมที่สามารถเดินได้
    })
    
    -- กำหนดเป้าหมายของ path
    path:ComputeAsync(humanoidRootPart.Position, destinationPosition)

    -- รอให้ path หาทางเสร็จ
    path.StatusChanged:Connect(function(status)
        if status == Enum.PathStatus.Complete then
            -- เมื่อ path หาทางเสร็จแล้ว ทำการ tween ไปยังตำแหน่ง
            local tweenService = game:GetService("TweenService")
            local tweenInfo = TweenInfo.new(path.Status == Enum.PathStatus.Complete and 4 or 2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
            local tweenGoal = {CFrame = destinationPosition}
            local tween = tweenService:Create(humanoidRootPart, tweenInfo, tweenGoal)
            tween:Play()
        elseif status == Enum.PathStatus.Error then
            print("เกิดข้อผิดพลาดในการหาทาง")
        end
    end)

    -- เริ่มต้นการเคลื่อนไหว
    path:MoveTo(humanoidRootPart)
end

-- ฟังก์ชันเพื่อให้ตัวละครไปยังตำแหน่งที่ต้องการ
local function navigateToPosition()
    -- เรียกใช้ PathfindingService เพื่อหาทางไปยังตำแหน่ง
    moveToDestination(destination.Position)
end

-- เรียกฟังก์ชันเพื่อให้ตัวละครไปยังตำแหน่งที่ต้องการ
navigateToPosition()
