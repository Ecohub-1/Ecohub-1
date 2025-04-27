
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
Main = Window:AddTab({ Title = "Main", Icon = "bookmark" }),
Autoboss = Window:AddTab({ Title = "Boss", Icon = "cat" }),
Dungeon = Window:AddTab({ Title = "Dungeon", Icon = "earth" }),
Settings = Window:AddTab({ Title = "Settings", Icon = "settings" }),
Other = Window:AddTab({ Title = "Other", Icon = "banana" })
}

local search = {
    Values = {}
}

for _, v in pairs(game:GetService("Workspace").mob:GetChildren()) do
    table.insert(search.Values, v.Name)
end

local searchDropdown = Tabs.Main:AddDropdown({
    Name = "search",
    Title = "Search Mob",
    Values = search.Values,
    Multi = false,
    AllowNull = true,
    Callback = function(v)
        search.Value = v
    end
})

local AutoFarm = Tabs.Main:AddToggle({
    Name = "AutoFarm",
    Title = "AutoFarm",
    Default = false
})
 if AutoFarm.Values then
  for _, h in pairs(game:GetService("Workspace").mob:GetChildren()) do
    if h.Name == Search.mob and h:FindFirstChild("HumanoidRootPart") then
      local humanoid = h:FindFirstChild("Humanoid")
        if humanoid.Helth <= 0 then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = h.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0)
        end
      end  
     task.wait(0.05)
   end
end
