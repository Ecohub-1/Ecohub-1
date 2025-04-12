local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Backpack = Player:WaitForChild("Backpack")
local Remotes = ReplicatedStorage:WaitForChild("remotes")
local InventoryRemote = Remotes:WaitForChild("inventory")

-- 1. ขอ Orb Dungeon
InventoryRemote:FireServer("Orb Dungeon")

-- 2. รอจนกว่าจะได้ไอเท็ม
local function WaitForItem(name)
  while not Backpack:FindFirstChild(name) do
    wait(0.5)
  end
end

WaitForItem("Orb Dungeon")

-- 3. วาร์ปไปที่ NPC (และยืนสูงขึ้น 2 หน่วย)
local HRP = Character:WaitForChild("HumanoidRootPart")
HRP.CFrame = Workspace.npcCilck.Raid.Parent.CFrame + Vector3.new(0, 2, 0)

task.wait(1)

-- 4. กด Prompt
fireproximityprompt(Workspace.npcCilck.Raid.Prompt)

-- 5. รอจนกว่าจะเจอ DungeonRing.AE แล้ววาร์ปไป
local function WaitAndTeleportToAE()
  local AE
  repeat
    AE = Workspace:FindFirstChild("DungeonRing") and Workspace.DungeonRing:FindFirstChild("AE")
    wait(0.5)
  until AE

  -- ถ้าเจอ AE แล้ววาร์ปไปที่มัน
  Character:MoveTo(AE.Position + Vector3.new(0, 5, 0))
end

WaitAndTeleportToAE()
