local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Eco Hub" .. Fluent.Version,
    SubTitle = " | Bloxspin",
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
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- ฟังก์ชันหารถที่ผู้เล่นนั่ง
local function getCurrentVehicle()
	for _, vehicle in pairs(workspace.Vehicles:GetChildren()) do
		local seat = vehicle:FindFirstChild("DriverSeat")
		if seat and seat:IsA("VehicleSeat") and seat.Occupant then
			local humanoid = seat.Occupant
			if humanoid.Parent == LocalPlayer.Character then
				return vehicle
			end
		end
	end
	return nil
end

-- Paragraph แสดงชื่อรถและค่า Attributes
local InfoParagraph = Tabs.Main:AddParagraph({
	Title = "Vehicle Info",
	Content = "Not in a vehicle"
})

-- ฟังก์ชันอัปเดต Paragraph
local function updateVehicleInfo()
	local vehicle = getCurrentVehicle()
	if not vehicle then
		InfoParagraph:SetContent("Not in a vehicle")
		return
	end

	local motors = vehicle:FindFirstChild("Motors")
	if not motors then
		InfoParagraph:SetContent(vehicle.Name .. "\n(No Motors found)")
		return
	end

	local content = "Vehicle: " .. vehicle.Name .. "\n\n"
	for attrName, value in pairs(motors:GetAttributes()) do
		content = content .. attrName .. ": " .. tostring(value) .. "\n"
	end
	InfoParagraph:SetContent(content)
end

-- เริ่มอัปเดต Paragraph ทุก 1 วินาที
task.spawn(function()
	while true do
		updateVehicleInfo()
		task.wait(1)
	end
end)

-- ฟังก์ชันสร้าง Input อัตโนมัติและเซ็ต Attribute ทันที
local function createAutoInput(id, title)
	return Tabs.Main:AddInput(id, {
		Title = title,
		Default = "0",
		Placeholder = "Enter " .. title,
		Numeric = true,
		Callback = function(value)
			local number = tonumber(value)
			if not number then return end

			local vehicle = getCurrentVehicle()
			if not vehicle then return end

			local motors = vehicle:FindFirstChild("Motors")
			if not motors then return end

			if motors:GetAttribute(title) ~= nil then
				motors:SetAttribute(title, number)
				print("Set", title, "to", number)
			end
		end
	})
end

-- สร้าง Inputs ทั้ง 9 ค่า
createAutoInput("BrakingInput", "Braking")
createAutoInput("DecelerationInput", "Deceleration")
createAutoInput("ForwardMaxSpeedInput", "ForwardMaxSpeed")
createAutoInput("MaxSpeedTorqueInput", "MaxSpeedTorque")
createAutoInput("HandBrakeTorqueInput", "HandBrakeTorque")
createAutoInput("MinSpeedTorqueInput", "MinSpeedTorque")
createAutoInput("ReverseMaxSpeedInput", "ReverseMaxSpeed")
createAutoInput("NitroTorqueInput", "NitroTorque")
createAutoInput("NitroTimeInput", "NitroTime")
