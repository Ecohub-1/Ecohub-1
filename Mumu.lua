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
            AutoFarm = Window:AddTab({ Title = "Auto Farm", Icon = "" }),
            AutoRank = Window:AddTab({ Title = "Auto Rank", Icon = "" }),
            AutoDungeon = Window:AddTab({ Title = "Dungeon", Icon = "" }),
            Teleport = Window:AddTab({ Title = "Teleport", Icon = "" }),
            Shop = Window:AddTab({ Title = "Shop", Icon = "" }),
            Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
        }
        local player = game:GetService("Players").LocalPlayer
        local Settings = player
        if Settings then
            local attributes = 
    {AutoAttack = ture, AutoArise = true, AutoDestroy = true}
            for name, default in pairs(attributes) do
        Tabs.Settings:AddToggle("AutoSettings", {Tile = "Auto Attack", Default = 
                settings:GetAttribute(name) or default)
            )}
                    toggle:OnChanged(function(Value)
                            Settings.SetAttribute(name, Value)
                    end)
            end
        end
                    local autoClickEnabled = false
        Tabs.Settings:AddToggle("AutoClick", {Title = "Auto Click", Default = false})
                    toggle:OnChanged(function(Value)
                            Callback = function(Value)
                                autoClickEnabled = not autoClickEnabled
                                player:SetAttribute("AutoClick", autoClickEnabled)
                 autoClickEnabled = Value
              
                            end
                        end)
     for i,v in pairs(game:GetService("ReplicatedStorage").__Assets.__Weapons:GetCilldren()) do
    local Shop = Tabs.Shop:Addinput({Tile ="Buy Item", Placeholder = "Item Name"})
    Shop:OnChanged(function(Value)
       if Value then
        local args = {
            [1] = {
                [1] = {
                    ["Item"] =  Value,
                    ["Shop"] = "WeaponShop1",
                    ["Event"] = "ItemShopAction",
                    ["Action"] = "Buy"
                },
                [2] = "\n"
            }
        }

        game:GetService("ReplicatedStorage").BridgeNet2.dataRemoteEvent:FireServer(unpack(args))
                    print(v.Name)
                end)
             end
