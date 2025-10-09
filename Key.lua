-- ==========================
-- Panda Auth Key System Example
-- ==========================

getgenv().key = getgenv().key or "" -- ใส่คีย์ของผู้ใช้ตรงนี้ (หรือให้ผู้ใช้กรอกเอง)
local API_TOKEN = "a7afc66a5753f44c774acb36f7045fcaa91bb31301d5f7314d4b25407a765d25" -- Vanguard API Token
local VERIFY_URL = "https://api.pandadevelopment.net/v1/auth/verify" -- API ตรวจคีย์ของ Panda
local REMOTE_SCRIPT_URL = "https://raw.githubusercontent.com/Ecohub-1/Ecohub-1/refs/heads/main/money.lua"

local HttpService = game:GetService("HttpService")

-- รองรับ executor หลายแบบ
local function doRequest(req)
	local ok, res = pcall(function()
		if syn and syn.request then
			return syn.request(req)
		elseif request then
			return request(req)
		elseif http and http.request then
			return http.request(req)
		elseif HttpService.RequestAsync then
			return HttpService:RequestAsync(req)
		else
			local body = game:HttpGet(req.Url, true)
			return { Body = body, StatusCode = 200 }
		end
	end)
	if not ok or not res then
		return nil, "request_failed"
	end
	local body = res.Body or res.body
	return { body = body, status = res.StatusCode or res.Status }
end

local function tryDecodeJson(b)
	local ok, decoded = pcall(function()
		return HttpService:JSONDecode(b)
	end)
	if ok then return decoded end
	return nil
end

local function verifyKey(key)
	if key == "" then
		warn("[KeySystem] ⚠️ ไม่มีคีย์ กรุณาใส่คีย์ก่อนรันสคริปต์")
		return false
	end

	local body = HttpService:JSONEncode({ key = key })
	local req = {
		Url = VERIFY_URL,
		Method = "POST",
		Headers = {
			["Content-Type"] = "application/json",
			["Authorization"] = "Bearer " .. API_TOKEN
		},
		Body = body
	}

	print("[KeySystem] 🔍 กำลังตรวจสอบคีย์กับ Panda API ...")
	local res, err = doRequest(req)
	if not res then
		warn("[KeySystem] ❌ Request error:", err)
		return false
	end

	local decoded = tryDecodeJson(res.body)
	if decoded then
		if decoded.valid or decoded.success then
			print("[KeySystem] ✅ คีย์ถูกต้อง! ยินดีต้อนรับ")
			return true
		else
			warn("[KeySystem] ❌ คีย์ไม่ถูกต้อง:", decoded.message or "unknown reason")
		end
	else
		warn("[KeySystem] ⚠️ ไม่สามารถอ่านผลลัพธ์จาก API:", res.body)
	end
	return false
end

local function loadRemoteScript()
	local res, err = doRequest({ Url = REMOTE_SCRIPT_URL, Method = "GET" })
	if not res then
		return warn("[KeySystem] ❌ โหลดสคริปต์ไม่สำเร็จ:", err)
	end
	local fn, loadErr = loadstring(res.body)
	if not fn then
		return warn("[KeySystem] ❌ Error loadstring:", loadErr)
	end
	local success, runErr = pcall(fn)
	if not success then
		return warn("[KeySystem] ❌ Error ขณะรันสคริปต์:", runErr)
	end
	print("[KeySystem] ✅ สคริปต์หลักทำงานเรียบร้อย")
end

-- MAIN FLOW
if verifyKey(getgenv().key) then
	loadRemoteScript()
end
