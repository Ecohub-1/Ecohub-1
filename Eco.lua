--=========================== -- Eco Hub Script by zer09Xz --===========================

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))() local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))() local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({ Title = "Eco Hub " .. Fluent.Version, SubTitle = "| by zer09Xz", TabWidth = 150, Size = UDim2.fromOffset(580, 400), Acrylic = true, Theme = "Dark", MinimizeKey = Enum.KeyCode.LeftControl })

local Tabs = { Credits = Window:AddTab({ Title = "Credits", Icon = "award" }), Main = Window:AddTab({ Title = "Main", Icon = "gamepad-2" }), Dungeon = Window:AddTab({ Title = "Auto Dungeon", Icon = "globe" }), Settings = Window:AddTab({ Title = "Settings", Icon = "settings" }), misc = Window:AddTab({ Title = "misc", Icon = "align-justify" }) }

local Players = game:GetService("Players") local player = Players.LocalPlayer local backpack = player:WaitForChild("Backpack")

SaveManager:SetLibrary(Fluent) InterfaceManager:SetLibrary(Fluent) SaveManager:IgnoreThemeSettings() SaveManager:SetIgnoreIndexes({}) InterfaceManager:SetFolder("FluentScriptHub") SaveManager:SetFolder("FluentScriptHub/specific-game") InterfaceManager:BuildInterfaceSection(Tabs.misc) SaveManager:BuildConfigSection(Tabs.misc)

--=============== NoClip Functions ===============-- local function enableNoClip() local character = player.Character for _, part in pairs(character:GetChildren()) do if part:IsA("BasePart") then part.CanCollide = false end end end

local function disableNoClip() local character = player.Character for _, part in pairs(character:GetChildren()) do if part:IsA("BasePart") then part.CanCollide = true end end end

--=============== Auto Equip Section ===============-- Tabs.Settings:AddSection("Auto Equip") local autoEquipRunning, selectedOption = false, "Melee"

Tabs.Settings:AddDropdown("TypeDropdown", { Title = "Auto Equip", Values = { "Melee", "Sword", "DevilFruit", "Special" }, Default = 1, Callback = function(value) selectedOption = value if autoEquipRunning then autoEquip() end end })

local function autoEquip() if autoEquipRunning then for _, tool in ipairs(backpack:GetChildren()) do if tool:IsA("Tool") and tool:GetAttribute("Type") == selectedOption then tool.Parent = player.Character if selectedOption == "Melee" then break end end end end end

Tabs.Settings:AddToggle("AutoEquipToggle", { Title = "Auto Equip", Default = false, OnChanged = function(value) autoEquipRunning = value if autoEquipRunning then autoEquip() end end })

backpack.ChildAdded:Connect(function(child) if child:IsA("Tool") and autoEquipRunning and child:GetAttribute("Type") == selectedOption then child.Parent = player.Character end end)

player.CharacterAdded:Connect(function() if autoEquipRunning then autoEquip() end end)

--=============== Auto Click Section ===============-- Tabs.Settings:AddSection("Auto Click") local autoClicking = false local clickDelay = 0.1

Tabs.Settings:AddToggle("AutoClickToggle", { Title = "Auto Click", Default = false }):OnChanged(function(value) autoClicking = value end)

Tabs.Settings:AddInput("ClickDelayInput", { Title = "Click Delay", Default = "0.1", Placeholder = "Enter delay in seconds", Numeric = true, Callback = function(text) local num = tonumber(text) if num and num > 0 then clickDelay = num else Fluent:Notify({ Title = "Eco Hub", Content = "Please enter a number greater than 0.", Duration = 5 }) end end })

task.spawn(function() while true do if autoClicking then local tool = player.Character and player.Character:FindFirstChildOfClass("Tool") if tool then pcall(function() tool:Activate() end) end task.wait(clickDelay) else task.wait(0.1) end end end)

--=============== Auto Farm Section ===============-- Tabs.Main:AddSection("Auto Farm mob") local mobNamesSet, mobNamesList = {}, {} for _, mob in pairs(workspace.Mob:GetChildren()) do if not mobNamesSet[mob.Name] then mobNamesSet[mob.Name] = true table.insert(mobNamesList, mob.Name) end end

local selectedMob = "" local distance = 50

local mobDropdown = Tabs.Main:AddDropdown("MobDropdown", { Title = "Select Mob Name", Values = mobNamesList, Default = 1, Multi = false, })

mobDropdown:OnChanged(function(Value) selectedMob = Value end)

Tabs.Main:AddSection("Auto Farm setting") local positionDropdown = Tabs.Main:AddDropdown("PositionDropdown", { Title = "Select Position", Values = {"Above", "Behind", "Below"}, Default = 1 })

Tabs.Main:AddInput("DistanceInput", { Title = "Enter Distance (1-125)", Default = "50", Callback = function(Value) local val = tonumber(Value) if val and val >= 1 and val <= 125 then distance = val else distance = 50 end end })

Tabs.Main:AddToggle("AutoFarmToggle", { Title = "Enable/Disable AutoFarm", Default = false }):OnChanged(function(toggleValue) _G.AutoFarm = toggleValue if toggleValue then enableNoClip() task.spawn(function() while _G.AutoFarm do pcall(function() if selectedMob ~= "" then for _, mob in pairs(workspace.Mob:GetChildren()) do if mob.Name == selectedMob and mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") then local humanoid = mob.Humanoid if humanoid.Health > 0 then local position = mob.HumanoidRootPart.Position local playerRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart") if not playerRoot then return end

local targetPosition
                                if positionDropdown.Value == "Above" then
                                    targetPosition = position + Vector3.new(0, distance, 0)
                                elseif positionDropdown.Value == "Behind" then
                                    targetPosition = position - mob.HumanoidRootPart.CFrame.LookVector * distance
                                elseif positionDropdown.Value == "Below" then
                                    targetPosition = position - Vector3.new(0, distance, 0)
                                end

                                playerRoot.CFrame = CFrame.new(targetPosition, mob.HumanoidRootPart.Position)

                                local tool = player.Character:FindFirstChildOfClass("Tool")
                                if not tool then
                                    local hum = player.Character:FindFirstChildOfClass("Humanoid")
                                    if hum then hum:MoveTo(mob.HumanoidRootPart.Position) end
                                end
                            end
                        end
                    end
                end
            end)
            task.wait(1)
        end
    end)
else
    disableNoClip()
end

end)

--=============== Auto Skill Section ===============-- Tabs.Settings:AddSection("Auto Skill") local VirtualInputManager = game:GetService("VirtualInputManager")

local skillKeys = { Z = "AutoSkillZ", X = "AutoSkillX", C = "AutoSkillC", V = "AutoSkillV", F = "AutoSkillF" }

for key, id in pairs(skillKeys) do local AutoSkill = false local toggle = Tabs.Settings:AddToggle(id, { Title = "Skill " .. key, Default = false })

toggle:OnChanged(function(state)
    AutoSkill = state
    if AutoSkill then
        task.spawn(function()
            while AutoSkill do
                VirtualInputManager:SendKeyEvent(true, key, false, game)
                task.wait(0.05)
                VirtualInputManager:SendKeyEvent(false, key, false, game)
                task.wait(0.1)
            end
        end)
    end
end)

end

--=============== Credits ===============-- Tabs.Credits:AddParagraph({ Title = "Credits", Content = "Owner: zer09Xz\nScript: zer09Xz\nHelper: Lucas, Dummy" })

--=============== Init ===============-- Window:SelectTab(1)

Fluent:Notify({ Title = "Eco Hub", Content = "Script Loaded", Duration = 3 })

SaveManager:LoadAutoloadConfig()

