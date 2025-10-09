-- 🔹 ตั้งค่า Key ของผู้ใช้ก่อนรัน
-- ตัวอย่าง: getgenv().key = "KEY_FROM_PANDA_USER"
local userKey = getgenv().key or ""
if userKey == "" then
    return warn("❌ โปรดตั้งค่า getgenv().key ก่อนรันสคริปต์")
end

-- 🔹 ดึง UserId ของผู้เล่น
local player = game.Players.LocalPlayer
local userId = player.UserId

-- 🔹 ตั้งค่า Service และ Panda API Key
local serviceName = "MyRobloxService" -- แก้เป็นชื่อ Service จริง
local apiKey = "4d6360878bd4d246723b4cbd40636852575ffde272cad24d348c37170e45c74e"

-- 🔹 URL สำหรับ validate key และผูกกับ UserId
local url = string.format(
    "https://api.pandadevelopment.net/validate?service=%s&key=%s&api=%s&user=%s",
    serviceName,
    userKey,
    apiKey,
    userId
)

-- 🔹 ส่ง request ตรวจสอบ key
local success, response = pcall(function()
    return game:HttpGet(url)
end)

if not success then
    return warn("❌ ไม่สามารถเชื่อม Panda API ได้: " .. tostring(response))
end

-- 🔹 แปลง JSON response เป็น table
local ok, result = pcall(function()
    return game:GetService("HttpService"):JSONDecode(response)
end)

if not ok then
    return warn("❌ แปลง JSON ไม่ได้: " .. tostring(result))
end

-- 🔹 ตรวจสอบผล
if result.status == "valid" then
    print("✅ Key ถูกต้อง! โหลดสคริปต์ money.lua …")
    local code = game:HttpGet("https://raw.githubusercontent.com/Ecohub-1/Ecohub-1/refs/heads/main/money.lua")
    loadstring(code)()
else
    warn("❌ Key ไม่ถูกต้อง / ใช้งานแล้วโดยคนอื่น: " .. (result.message or "unknown"))
end
