local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Eco Hub  V1.0" ,
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

local Monsters = {
    Igris = { Name = "Vermillion", HP = 50000 },
    SL4 = { Name = "LongIn", HP = 10000 },
    JBB2 = { Name = "Gosuke", HP = 2000000000000000 },
    JJ3 = { Name = "Ant Queen", HP = 150000 },
    JJ2 = { Name = "Royal Red Ant", HP = 135000 },
    SLB5 = { Name = "Anders", HP = 50000 },
    OPB2 = { Name = "Eminel", HP = 5000000000 },
    CH3 = { Name = "Ika", HP = 65000000000000 },
    CHB2 = { Name = "Zere", HP = 320000000000000 },
    SLB2 = { Name = "Gonshee", HP = 50000 },
    JinWoo = { Name = "Monarch", HP = 5000000000 },
    CHB1 = { Name = "Heaven", HP = 320000000000000 },
    NRB2 = { Name = "Blossom", HP = 15000000 },
    BC2 = { Name = "Michille", HP = 5000000000000 },
    Pucci = { Name = "Gucci", HP = 2000000000000000 },
    Denji = { Name = "Chainsaw", HP = 320000000000000 },
    Julius = { Name = "Time King", HP = 50000000000000 },
    Ulquiorra = { Name = "Murcielago", HP = 6000000000000 },
    Mihalk = { Name = "Mifalcon", HP = 5000000000 },
    Pain = { Name = "Dor", HP = 15000000 },
    JJ4 = { Name = "Ant King", HP = 450000 },
    JBB3 = { Name = "Golyne", HP = 2000000000000000 },
    BL3 = { Name = "Genji", HP = 98500000000 },
    JBB1 = { Name = "Diablo", HP = 2000000000000000 },
    BLB2 = { Name = "Fyakuya", HP = 600000000000 },
    SLB4 = { Name = "LongIn", HP = 50000 },
    BC1 = { Name = "Sortudo", HP = 900000000000 },
    NRB1 = { Name = "Snake Man", HP = 15000000 },
    JB1 = { Name = "Diablo", HP = 150000000000000 },
    NR3 = { Name = "Black Crow", HP = 3000000 },
    CHB3 = { Name = "Ika", HP = 320000000000000 },
    BL2 = { Name = "Fyakuya", HP = 38500000000 },
    NRB3 = { Name = "Black Crow", HP = 15000000 },
    JJ1 = { Name = "Red Ant", HP = 50000 },
    SLB6 = { Name = "Largalgan", HP = 50000 },
    SLB3 = { Name = "Daek", HP = 50000 },
    NR2 = { Name = "Blossom", HP = 300000 },
    BCB2 = { Name = "Michille", HP = 35000000000000 },
    BC3 = { Name = "Wind", HP = 13000000000000 },
    SL3 = { Name = "Daek", HP = 5000 },
    OP3 = { Name = "Light Admiral", HP = 1800000000 },
    OPB1 = { Name = "Shark Man", HP = 5000000000 },
    SLB1 = { Name = "Soondoo", HP = 50000 },
    CH1 = { Name = "Heaven", HP = 23000000000000 },
    SL6 = { Name = "Largalgan", HP = 30000 },
    JB3 = { Name = "Golyne", HP = 1000000000000000 },
    SL2 = { Name = "Gonshee", HP = 500 },
    NR1 = { Name = "Snake Man", HP = 55000 },
    BLB3 = { Name = "Genji", HP = 600000000000 },
    OP2 = { Name = "Eminel", HP = 180000000 },
    BCB1 = { Name = "Sortudo", HP = 35000000000000 },
    CH2 = { Name = "Zere", HP = 40000000000000 },
    JB2 = { Name = "Gosuke", HP = 500000000000000 },
    SL1 = { Name = "Soondoo", HP = 50 },
    BLB1 = { Name = "Luryu", HP = 600000000000 },
    SL5 = { Name = "Anders", HP = 15000 },
    BL1 = { Name = "Luryu", HP = 8500000000 },
    OPB3 = { Name = "Light Admiral", HP = 5000000000 },
    OP1 = { Name = "Shark Man", HP = 18000000 },
    BCB3 = { Name = "Wind", HP = 35000000000000 }
}
local TS = game:GetService("TweenService")
local P = game:GetService("Players")
local lp = P.LocalPlayer
local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")

-- Use getfenv to create a local environment for global variables
local env = {}
env.F = false

local suff = {
    [1e3] = "K",
    [1e6] = "M",
    [1e9] = "B",
    [1e12] = "T",
    [1e15] = "Qa",
    [1e18] = "Qi",
    [1e21] = "Sx",
    [1e24] = "Sp",
    [1e27] = "Oc",
    [1e30] = "No",
    [1e33] = "Dc"
}

local suffList = {}
for k, v in pairs(suff) do
    table.insert(suffList, {val = k, suf = v})
end
table.sort(suffList, function(a, b)
    return a.val > b.val
end)

local function fmt(n)
    for _, s in pairs(suffList) do
        if n >= s.val then
            return string.format("%.2f%s +", n / s.val, s.suf)
        end
    end
    return tostring(n)
end

-- ทำให้ชื่อไม่ซ้ำ
    local name = m.Name
    local count = 1
    while monNames[name .. " [ HP " .. fHP .. " ]"] do
        count += 1
        name = m.Name .. " [" .. count .. "]"
    end

    local disp = name .. " [ HP " .. fHP .. " ]"
    monNames[disp] = true  -- จดจำว่าชื่อนี้ถูกใช้แล้ว
    table.insert(mons, { ID = id, Name = name, Disp = disp })
--=================--
local mons = {}
local monNames = {}

for id, m in pairs(Monsters) do
    local fHP = fmt(m.HP)
    local disp = m.Name .. " [ HP " .. fHP .. " ]"
    table.insert(mons, { ID = id, Name = m.Name, Disp = disp })
end

table.sort(mons, function(a, b)
    return a.Name < b.Name
end)

for _, m in ipairs(mons) do
    table.insert(monNames, m.Disp)
end

Tabs.Main:AddSection("EnemiesFarmSection", {
    Title = "Enemies Farm"
})

local selMon = nil
local tgt = nil

local function updTgt(t)
    if t then
        local maxHP = t:GetAttribute("MaxHP") or "N/A"
        local lvl = t:GetAttribute("Level") or "N/A"
        local name = selMon or "Unknown"
        name = string.match(name, "^(.-)%s*%[") or name
        local titleText = string.format("Target: %s", name)
        local contentText = string.format("Level: %s\nMaxHP: %s", lvl, maxHP)
        tgtInfo:SetTitle(titleText)
        tgtInfo:SetDesc(contentText)
    else
        tgtInfo:SetTitle("Target Info")
        tgtInfo:SetDesc("")
    end
end

local DD = Tabs.Main:AddDropdown("SelectEnemies", {
    Title = "Select Enemies",
    Description = "",
    Values = monNames,
    Multi = false,
    Default = nil,
})

local Dropdown = script.Parent:WaitForChild("Dropdown")
Dropdown.OnChanged:Connect(function(value)
    selMon = value
end)

local function isDead(enemy)
    local hpBar = enemy:FindFirstChild("HealthBar")
    if hpBar then
        local main = hpBar:FindFirstChild("Main")
        if main then
            local bar = main:FindFirstChild("Bar")
            if bar then
                local amt = bar:FindFirstChild("Amount")
                if amt and amt:IsA("TextLabel") and amt.ContentText == "0 HP" then
                    return true
                end
            end
        end
    end
    return false
end

local isTweening = false
local function To(target)
    if not isTweening and target and hrp then
        isTweening = true
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Linear)
        local tween = TS:Create(hrp, tweenInfo, {CFrame = target.CFrame * CFrame.new(0, 5, 5)})
        tween:Play()
        tween.Completed:Connect(function()
            isTweening = false
        end)
    end
end

local Toggle = Tabs.Window:AddToggle("AutoFarm", {
  Title = "Auto Farm",
  Default = false,
})

Toggle:OnChanged(function()
  env.A = Options.AutoFarm.Value
  spawn(function()
      while env.A do
          if selMon then
              if tgt and tgt:GetAttribute("HP") and tgt:GetAttribute("HP") > 0 then
                  To(tgt)
              else
                  h = false
                  local found = false
                  for _, m in ipairs(mons) do
                      if m.Disp == selMon then
                          local tgtID = m.ID
                          local serverFolder = workspace.__Main.__Enemies.Server
                          local clientFolder = workspace.__Main.__Enemies.Client

                          for _, folder in pairs(serverFolder:GetChildren()) do
                              if found then break end
                              for _, e in ipairs(folder:GetChildren()) do
                                  if e:GetAttribute("Id") == tgtID and e:GetAttribute("HP") and e:GetAttribute("HP") > 0 then
                                      tgt = e
                                      updTgt(tgt)
                                      To(e)

                                      if env.Arise1 or env.Destroy then
                                          repeat task.wait(0.2)
                                          until e:GetAttribute("HP") and e:GetAttribute("HP") <= 0

                                          env.Attck = false
                                          task.wait(1.50)

                                          local clientTarget = nil
                                          for _, cf in ipairs(clientFolder:GetChildren()) do
                                              for _, ce in ipairs(cf:GetChildren()) do
                                                  if ce:GetAttribute("Id") == tgtID then
                                                      clientTarget = ce
                                                      break
                                                  end
                                              end
                                              if clientTarget then break end
                                          end

                                          if clientTarget then
                                              local root = clientTarget:FindFirstChild("HumanoidRootPart")
                                              local ap = root and root:FindFirstChild("ArisePrompt")

                                              if ap then
                                                  task.wait(1.50)
                                                  print("Arise Prompt found!")
                                                  repeat
                                                      task.wait(0.2)
                                                      ap = root and root:FindFirstChild("ArisePrompt")
                                                  until not ap
                                              end
                                          end

                                          env.Attck = true
                                      end

                                      found = true
                                      break
                                  end
                              end
                          end
                      end
                  end
              end
          end
          task.wait(0.5)
      end
  end)
end)

Tabs.Main:AddButton({
  Title = "Reset Target",
  Description = "Clear current target info",
  Callback = function()
      tgt = nil
      updTgt(nil)
      env.F = false
  end,
})
