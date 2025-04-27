
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
Title = "Eco Hub",
SubTitle = " | Rock Fruit",
TabWidth = 150,
Size = UDim2.fromOffset(580, 400),
Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
Theme = "Dark",
MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
})

local Tabs = {
Main = Window:AddTab({ Title = "Main", Icon = "" }),
Autoboss = Window:AddTab({ Title = "Boss", Icon = "" }),
Dungeon = Window:AddTab({ Title = "Dungeon", Icon = "" }),
Misc = Window:AddTab({ Title = "Settings", Icon = "" }),
Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Searchmon = {
    mob {}
}

 for _, n in pairs(game:GetService("Workspace").mob:GetChildren()) do
    table.insert(Searchmon.mob, n.Name)
end
local Searchmob = Tabs.Maim:AddDropDown({Name = "search",
  Title = "Search Mob",
  Values = search.Values,
  Multi = false,
  AllowNull = true,
  Callback = function(n)
      Searchmon.mob = n
    end
  })

local AutoFarm = Tabs.Main:AddToggle({
    Name = "AutoFarm",
    Title = "AutoFarm",
    Default = false
})
 if AutoFarm.mob then
  for _, h in pairs(game:GetService("Workspace").mob:GetChildren()) do
    if h.Name == Searchmon.mob and h:FindFirstChild("HumanoidRootPart") then
      local humanoid = h:FindFirstChild("Humanoid")
        if humanoid.Helth <= 0 then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = h.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0)
        end
      end  
     task.wait(0.05)
   end
end
