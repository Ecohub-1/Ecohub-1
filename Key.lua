local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- 🟢 ตั้งค่า Key ของผู้ใช้
local userKey = getgenv().key or ""
if userKey == "" then
    return warn("❌ โปรดตั้งค่า getgenv().key ก่อนรันสคริปต์")
end

-- 🟢 UserId ของผู้เล่น
local player = Players.LocalPlayer
local userId = player.UserId

-- 🟢 ตั้งค่า Service และ Panda API Key
local serviceName = "MyRobloxService" -- แก้เป็นชื่อ Service จริง
local apiKey = "4d6360878bd4d246723b4cbd40636852575ffde272cad24d348c37170e45c74e"

-- 🟢 URL สำหรับ validate Key
local url = string.format(
    "https://api.pandadevelopment.net/validate?service=%s&key=%s&api=%s&user=%s",
    serviceName,
    userKey,
    apiKey
)

-- 🟢 ส่ง request ตรวจสอบ Key
local success, response = pcall(function()
    return game:HttpGet(url)
end)

if not success then
    return warn("❌ ไม่สามารถเชื่อม Panda API ได้: " .. tostring(response))
end

-- 🟢 แปลง response
local result
local ok = pcall(function()
    -- ลองแปลง JSON
    result = HttpService:JSONDecode(response)
end)

-- 🟢 ถ้า JSONDecode ล้มเหลว ให้ใช้ plain text
if not ok or type(result) ~= "table" then
    result = {}
    result.status = (response:lower():find("valid") and "valid") or "invalid"
    result.message = response
end

-- 🟢 ตรวจสอบผล
if result.status == "valid" then
    print("✅ Key ถูกต้อง! โหลด money.lua …")
    local code = game:HttpGet("https://raw.githubusercontent.com/Ecohub-1/Ecohub-1/refs/heads/main/money.lua")
    loadstring(code)()
else
    warn("❌ Key ไม่ถูกต้อง / ใช้งานแล้วโดยคนอื่น: " .. (result.message or "unknown"))
end
