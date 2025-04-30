
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Eco Hub",
    SubTitle = " | Arise Crossover",
    TabWidth = 150,
    Size = UDim2.fromOffset(580, 400),
    Acrylic = true, 
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl 
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Monsters = {
  Igris = { Name = "Vermillion" },
  SL4 = { Name = "LongIn" },
  JBB2 = { Name = "Gosuke" },
  JJ3 = { Name = "Ant Queen" },
  JJ2 = { Name = "Royal Red Ant" },
  SLB5 = { Name = "Anders" },
  OPB2 = { Name = "Eminel" },
  CH3 = { Name = "Ika" },
  CHB2 = { Name = "Zere" },
  SLB2 = { Name = "Gonshee" },
  JinWoo = { Name = "Monarch" },
  CHB1 = { Name = "Heaven" },
  NRB2 = { Name = "Blossom" },
  BC2 = { Name = "Michille" },
  Pucci = { Name = "Gucci" },
  Denji = { Name = "Chainsaw" },
  Julius = { Name = "Time King" },
  Ulquiorra = { Name = "Murcielago" },
  Mihalk = { Name = "Mifalcon" },
  Pain = { Name = "Dor" },
  JJ4 = { Name = "Ant King" },
  JBB3 = { Name = "Golyne" },
  BL3 = { Name = "Genji" },
  JBB1 = { Name = "Diablo" },
  BLB2 = { Name = "Fyakuya" },
  SLB4 = { Name = "LongIn" },
  BC1 = { Name = "Sortudo" },
  NRB1 = { Name = "Snake Man" },
  JB1 = { Name = "Diablo" },
  NR3 = { Name = "Black Crow" },
  CHB3 = { Name = "Ika" },
  BL2 = { Name = "Fyakuya" },
  NRB3 = { Name = "Black Crow" },
  JJ1 = { Name = "Red Ant" },
  SLB6 = { Name = "Largalgan" },
  SLB3 = { Name = "Daek" },
  NR2 = { Name = "Blossom" },
  BCB2 = { Name = "Michille" },
  BC3 = { Name = "Wind" },
  SL3 = { Name = "Daek" },
  OP3 = { Name = "Light Admiral" },
  OPB1 = { Name = "Shark Man" },
  SLB1 = { Name = "Soondoo" },
  CH1 = { Name = "Heaven" },
  SL6 = { Name = "Largalgan" },
  JB3 = { Name = "Golyne" },
  SL2 = { Name = "Gonshee" },
  NR1 = { Name = "Snake Man" },
  BLB3 = { Name = "Genji" },
  OP2 = { Name = "Eminel" },
  BCB1 = { Name = "Sortudo" },
  CH2 = { Name = "Zere" },
  JB2 = { Name = "Gosuke" },
  SL1 = { Name = "Soondoo" },
  BLB1 = { Name = "Luryu" },
  SL5 = { Name = "Anders" },
  BL1 = { Name = "Luryu" },
  OPB3 = { Name = "Light Admiral" },
  OP1 = { Name = "Shark Man" },
  BCB3 = { Name = "Wind" }
}
local TS = game:GetService("TweenService")
local P = game:GetService("Players")
local lp = P.LocalPlayer
local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")

local mons = {}
local monNames = {}

for i,v in pairs(Monsters) do
  table.insert(Monsters, v.Name)
  table.insert(mons, { ID = id, Name = m.Name, Disp = disp })
  end

  table.sort(mons, function(a, b)
    return a.Name < b.Name
  end)

  for _, m in ipairs(mons) do
    table.insert(monNames, m.Disp)
  end
 local DD = Tabs.Main:Dropdown("DD" Title = "Select Monster" List = monNames,
    Value = '',
    Callback = function(v)
      selMon = v
    end,
  })

  local function isDead(e)
    local hpBar = e:FindFirstChild("HealthBar")
    if hpBar and hpBar:FindFirstChild("Main") and hpBar.Main:FindFirstChild("Bar") then
      local amt = hpBar.Main.Bar:FindFirstChild("Amount")
      if amt and amt:IsA("TextLabel") and amt.ContentText == "0 HP" then
        return true
      end
    end
    return false
  end
  local h = false

  local function To(t)
    if not h then
      h = true
      local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Linear)
      local tween = TS:Create(hrp, tweenInfo, {CFrame = t.CFrame * CFrame.new(0, 5, 5)})
      tween:Play()
    end
  end
local Atk = Tabs.Main:Toggle("Atk" Title = "AutoFarm", Value = false,Callback = function(v)
    env.A = v
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
  end,
})
local resetBtn = Tabs.Main:AddButton("Reset" Tilte = "ResetTaget",
  Callback = function(v)
   tgt = nil
   updTgt(nil)
   env.F = false
end,
)
Fluent:Notify({
    Title = "Notify",
    Content = "Loading",
    SubContent = "wait for Loading",
    Duration = 4
}) 
wait(4)
Fluent:Notify({
    Title = "Notify",
    Content = "succeed",
    SubContent = "Thx for play",
    Duration = 4
}) 
