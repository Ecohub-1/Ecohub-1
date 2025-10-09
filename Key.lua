local HttpService = game:GetService("HttpService")

-- 🟢 ใส่ Key ของผู้ใช้ก่อนรัน
local userKey = getgenv().key or ""
if userKey == "" then
    return warn("❌ โปรดใส่คีย์ให้ถูกต้อง")
end

-- 🟢 ตั้งค่า Service และ API Key
local serviceName = "MyRobloxService"
local apiKey = "4d6360878bd4d246723b4cbd40636852575ffde272cad24d348c37170e45c74e"

-- 🟢 URL สำหรับ validate Key (ไม่จำกัดผู้ใช้)
local url = string.format(
    "https://api.pandadevelopment.net/validate?service=%s&key=%s&api=%s",
    serviceName,
    userKey,
    apiKey
)

-- 🔹 ส่ง request
local success, response = pcall(function()
    return game:HttpGet(url)
end)
if not success then
    return warn("❌ ไม่สามารถเชื่อม Panda API ได้: "..tostring(response))
end

-- 🔹 แปลง response / รองรับ JSON หรือ plain text
local result
local ok = pcall(function()
    result = HttpService:JSONDecode(response)
end)
if not ok or type(result) ~= "table" then
    result = {}
    result.status = (response:lower():find("valid") and "valid") or "invalid"
    result.message = response
end

-- 🔹 ตรวจสอบ Key
if result.status == "valid" end
    print("✅ Key ถถูกต้อง!")
    local code = game:HttpGet("https://raw.githubusercontent.com/Ecohub-1/Ecohub-1/refs/heads/main/money.lua")
    loadstring(code)()
else
    -- ❌ Key ผิด / หมดอายุ แต่ไม่ kick
    warn("❌ Key ไม่ถูกต้อง / หมดอายุ: ")
    -- คุณสามารถใส่ UI ให้กรอก Key ใหม่ได้ที่นี่
end
