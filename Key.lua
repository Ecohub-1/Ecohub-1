local HttpService = game:GetService("HttpService")

-- 🟢 ใส่ Key ของผู้ใช้ก่อนรัน
local userKey = getgenv().key or ""
if userKey == "" then return warn("❌ โปรดตั้งค่า getgenv().key ก่อนรันสคริปต์") end

-- 🟢 ตั้งค่า Service และ API Key
local serviceName = "MyRobloxService"
local apiKey = "4d6360878bd4d246723b4cbd40636852575ffde272cad24d348c37170e45c74e"

-- 🟢 URL สำหรับ validate key (ไม่ใช้ UserId)
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
if not success then return warn("❌ ไม่สามารถเชื่อม Panda API ได้: "..tostring(response)) end

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

-- 🔹 ตรวจสอบผล
if result.status == "valid" then
    print("✅ Key ถูกต้อง! โหลด money.lua …")
    local code = game:HttpGet("https://raw.githubusercontent.com/Ecohub-1/Ecohub-1/refs/heads/main/money.lua")
    loadstring(code)()
else
    warn("❌ Key ไม่ถูกต้อง หรือถูกใช้งานแล้ว: "..(result.message or "unknown"))
end
