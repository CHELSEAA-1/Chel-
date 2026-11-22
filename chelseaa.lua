--// =========================================================================
--// CHELSEAA SYSTEM V12 (EXPANDED CLEAN FEATURES + NO NUMBERS + LIVE SEARCH)
--// Key Gate -> Discord Key System | ADMIN ONLY | DEVOLOPER MODE
--// =========================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local GuiService = game:GetService("GuiService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")
local Stats = game:GetService("Stats")
local StarterGui = game:GetService("StarterGui")

local VirtualInputManager = nil
pcall(function() VirtualInputManager = game:GetService("VirtualInputManager") end)
local VirtualUser = nil
pcall(function() VirtualUser = game:GetService("VirtualUser") end)

local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
	Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
	LocalPlayer = Players.LocalPlayer
end

local function GetDeltaGuiParent()
	local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
	if pg then return pg end
	local ok, core = pcall(function() return game:GetService("CoreGui") end)
	if ok and core then return core end
	return LocalPlayer:WaitForChild("PlayerGui")
end

local GuiParent = GetDeltaGuiParent()

for _, name in ipairs({ "ChelseaaDeltaV12", "ChelseaaDeltaKeyGate", "ChelseaaSystemV12", "ChelseaaKeyGate" }) do
	local old = GuiParent:FindFirstChild(name)
	if old then old:Destroy() end
end

--// KONFIGURASI
local KeyConfig = {
	DiscordInvite = "https://discord.gg/HXDusYcjd",
	WallpaperUrl = "https://files.catbox.moe/5kbgpx.jpg",
	BubbleIconUrl = "https://files.catbox.moe/u6aqfz.jpg",
	ValidKeys = {
		["CHELSEAACUTIE"] = "CUTIE ACCESS",
		["CHELSEAA-VIP-2026"] = "VIP ACCESS",
		["MADEBYCHELSEAA"] = "MEMBER ACCESS",
		["CHELSEAA-2026"] = "STANDARD ACCESS",
	},
	AdminKeys = {
		["LYZZ DEV"] = "ADMIN ONLY",
		["LYZZDEV"] = "ADMIN ONLY",
	},
}

local function NormKey(s)
	s = string.upper(tostring(s or ""))
	s = string.gsub(s, "^%s+", "")
	s = string.gsub(s, "%s+$", "")
	return s
end

local function SafeCopy(txt)
	pcall(function()
		if type(setclipboard) == "function" then
			setclipboard(tostring(txt))
		elseif type(toclipboard) == "function" then
			toclipboard(tostring(txt))
		end
	end)
end

-- Helper muat turun gambar async (aman di Delta tablet, tidak blocking)
local function LoadAsyncImage(imgObj, url, cacheName)
	if not imgObj or not url or url == "" then return end
	task.spawn(function()
		pcall(function()
			if type(getcustomasset) == "function" and type(writefile) == "function" then
				local fname = cacheName or "chelseaa_cached_img.jpg"
				local exists = (type(isfile) == "function") and pcall(isfile, fname) and isfile(fname)
				if not exists then
					local okHttp, body = pcall(function() return game:HttpGet(url, true) end)
					if okHttp and type(body) == "string" and #body > 100 then
						pcall(writefile, fname, body)
						exists = true
					end
				end
				if exists then
					local okAsset, assetId = pcall(getcustomasset, fname)
					if okAsset and assetId and assetId ~= "" then
						imgObj.Image = assetId
						return
					end
				end
			end
			imgObj.Image = url
		end)
	end)
end

-- Helper gambar latar 16:9
local function Apply16x9Wallpaper(targetFrame, url, transparency)
	if not targetFrame or not url or url == "" then return end
	local img = Instance.new("ImageLabel")
	img.Name = "Chelseaa16x9Bg"
	img.Size = UDim2.new(1, 0, 1, 0)
	img.Position = UDim2.new(0, 0, 0, 0)
	img.BackgroundTransparency = 1
	img.ImageTransparency = transparency or 0.55
	img.ScaleType = Enum.ScaleType.Crop
	img.ZIndex = 1
	img.Parent = targetFrame

	local aspect = Instance.new("UIAspectRatioConstraint")
	aspect.AspectRatio = 16 / 9
	aspect.AspectType = Enum.AspectType.ScaleWithParentSize
	aspect.DominantAxis = Enum.DominantAxis.Width
	aspect.Parent = img

	LoadAsyncImage(img, url, "chelseaa_5kbgpx_16x9.jpg")
	return img
end

--// KEY GATE UTAMA
local MainUnlocked = false
local MainRole = "USER"

do
	local GateGui = Instance.new("ScreenGui")
	GateGui.Name = "ChelseaaDeltaKeyGate"
	GateGui.ResetOnSpawn = false
	GateGui.DisplayOrder = 9999
	GateGui.IgnoreGuiInset = true
	GateGui.Parent = GuiParent

	local Backdrop = Instance.new("Frame")
	Backdrop.Size = UDim2.new(1, 0, 1, 0)
	Backdrop.BackgroundColor3 = Color3.fromRGB(6, 6, 10)
	Backdrop.BackgroundTransparency = 0.25
	Backdrop.Parent = GateGui

	Apply16x9Wallpaper(Backdrop, KeyConfig.WallpaperUrl, 0.55)

	local Box = Instance.new("Frame")
	Box.Size = UDim2.new(0, 386, 0, 214)
	Box.Position = UDim2.new(0.5, -193, 0.5, -107)
	Box.BackgroundColor3 = Color3.fromRGB(14, 14, 22)
	Box.BackgroundTransparency = 0.08
	Box.ZIndex = 5
	Box.Parent = GateGui
	Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 10)
	local st = Instance.new("UIStroke", Box)
	st.Color = Color3.fromRGB(220, 38, 68)
	st.Thickness = 1.6

	local Title = Instance.new("TextLabel")
	Title.Size = UDim2.new(1, -20, 0, 26)
	Title.Position = UDim2.new(0, 10, 0, 10)
	Title.BackgroundTransparency = 1
	Title.Text = "CHELSEAA SYSTEM — KEY SYSTEM"
	Title.Font = Enum.Font.GothamBlack
	Title.TextSize = 14
	Title.TextColor3 = Color3.fromRGB(255, 255, 255)
	Title.ZIndex = 6
	Title.Parent = Box

	local Sub = Instance.new("TextLabel")
	Sub.Size = UDim2.new(1, -20, 0, 18)
	Sub.Position = UDim2.new(0, 10, 0, 34)
	Sub.BackgroundTransparency = 1
	Sub.Text = "Tekan Key System untuk salin link Discord & ambil key"
	Sub.Font = Enum.Font.Gotham
	Sub.TextSize = 10
	Sub.TextColor3 = Color3.fromRGB(56, 189, 248)
	Sub.ZIndex = 6
	Sub.Parent = Box

	local Input = Instance.new("TextBox")
	Input.Size = UDim2.new(1, -28, 0, 34)
	Input.Position = UDim2.new(0, 14, 0, 62)
	Input.BackgroundColor3 = Color3.fromRGB(22, 22, 34)
	Input.PlaceholderText = "Masukkan key anda di sini..."
	Input.Text = ""
	Input.ClearTextOnFocus = false
	Input.Font = Enum.Font.GothamBold
	Input.TextSize = 12
	Input.TextColor3 = Color3.fromRGB(255, 255, 255)
	Input.ZIndex = 6
	Input.Parent = Box
	Instance.new("UICorner", Input).CornerRadius = UDim.new(0, 6)

	local KeySysBtn = Instance.new("TextButton")
	KeySysBtn.Size = UDim2.new(0, 176, 0, 28)
	KeySysBtn.Position = UDim2.new(0, 14, 0, 106)
	KeySysBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 44)
	KeySysBtn.Text = "KEY SYSTEM (COPY DISCORD)"
	KeySysBtn.Font = Enum.Font.GothamBold
	KeySysBtn.TextSize = 10
	KeySysBtn.TextColor3 = Color3.fromRGB(56, 189, 248)
	KeySysBtn.ZIndex = 6
	KeySysBtn.Parent = Box
	Instance.new("UICorner", KeySysBtn).CornerRadius = UDim.new(0, 6)

	local ClearKeyBtn = Instance.new("TextButton")
	ClearKeyBtn.Size = UDim2.new(0, 174, 0, 28)
	ClearKeyBtn.Position = UDim2.new(0, 198, 0, 106)
	ClearKeyBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 44)
	ClearKeyBtn.Text = "BERSIHKAN KOLOM"
	ClearKeyBtn.Font = Enum.Font.GothamBold
	ClearKeyBtn.TextSize = 10
	ClearKeyBtn.TextColor3 = Color3.fromRGB(244, 114, 182)
	ClearKeyBtn.ZIndex = 6
	ClearKeyBtn.Parent = Box
	Instance.new("UICorner", ClearKeyBtn).CornerRadius = UDim.new(0, 6)

	local StatusLbl = Instance.new("TextLabel")
	StatusLbl.Size = UDim2.new(1, -28, 0, 18)
	StatusLbl.Position = UDim2.new(0, 14, 0, 184)
	StatusLbl.BackgroundTransparency = 1
	StatusLbl.Text = "Status: Menunggu verifikasi key..."
	StatusLbl.Font = Enum.Font.GothamBold
	StatusLbl.TextSize = 10
	StatusLbl.TextColor3 = Color3.fromRGB(200, 205, 220)
	StatusLbl.ZIndex = 6
	StatusLbl.Parent = Box

	local VerifyBtn = Instance.new("TextButton")
	VerifyBtn.Size = UDim2.new(1, -28, 0, 32)
	VerifyBtn.Position = UDim2.new(0, 14, 0, 144)
	VerifyBtn.BackgroundColor3 = Color3.fromRGB(220, 38, 68)
	VerifyBtn.Text = "VERIFY & BUKA MENU"
	VerifyBtn.Font = Enum.Font.GothamBlack
	VerifyBtn.TextSize = 11
	VerifyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	VerifyBtn.ZIndex = 6
	VerifyBtn.Parent = Box
	Instance.new("UICorner", VerifyBtn).CornerRadius = UDim.new(0, 6)

	KeySysBtn.MouseButton1Click:Connect(function()
		SafeCopy(KeyConfig.DiscordInvite)
		StatusLbl.TextColor3 = Color3.fromRGB(56, 189, 248)
		StatusLbl.Text = "Link Discord disalin: " .. KeyConfig.DiscordInvite
	end)

	ClearKeyBtn.MouseButton1Click:Connect(function()
		Input.Text = ""
		StatusLbl.TextColor3 = Color3.fromRGB(200, 205, 220)
		StatusLbl.Text = "Kolom key dikosongkan."
	end)

	VerifyBtn.MouseButton1Click:Connect(function()
		local k = NormKey(Input.Text)
		if KeyConfig.ValidKeys[k] then
			MainRole = KeyConfig.ValidKeys[k]
			StatusLbl.TextColor3 = Color3.fromRGB(34, 197, 94)
			StatusLbl.Text = "Berhasil! Membuka menu..."
			task.wait(0.18)
			MainUnlocked = true
			GateGui:Destroy()
		else
			StatusLbl.TextColor3 = Color3.fromRGB(244, 63, 94)
			StatusLbl.Text = "Key tidak sah! Tekan KEY SYSTEM untuk ke Discord."
		end
	end)

	while not MainUnlocked and GateGui.Parent do
		task.wait(0.1)
	end
	if not MainUnlocked then return end
end

--// =========================================================================
--// STATE & ENGINE FITUR LENGKAP
--// =========================================================================
local State = {
	WalkSpeed = 16,
	WalkSpeedLock = false,
	JumpPower = 50,
	JumpPowerLock = false,
	InfJump = false,
	BunnyHop = false,
	ClickTP = false,
	MoonWalk = false,
	ShiftLockHelper = false,
	Noclip = false,
	Fly = false,
	FlySpeed = 85,
	TweenSpeed = 250,
	SyncTweenToWS = false,
	ActiveTween = nil,
	Waypoints = {},

	OrbitPlayer = false,
	OrbitAngle = 0,
	AirWalk = false,
	AntiFling = false,
	SpiderClimb = false,
	AntiVoid = false,
	InstantRespawn = false,
	FreezeChar = false,
	SpinMode = false,
	SwimInAir = false,
	NoRagdoll = false,
	OrigHipHeight = nil,

	Freecam = false,
	FreecamPos = Vector3.zero,
	TopDownView = false,
	SpectateIndex = 0,

	AutoTrain = false,
	AutoTrainFilter = "2X_PLUS",
	ClickCooldownMs = 75,
	LastClickTick = 0,
	TrainClicks = 0,
	LastHit = "None",

	AutoPrompt = false,
	AutoTouch = false,
	TycoonCollect = false,
	TycoonBuy = false,

	Aimbot = false,
	AimbotSmoothness = 0.28,
	AimbotPart = "Head",
	SilentAim = false,
	SilentAimPart = "Head",
	CombatFOV = 180,
	TeamCheck = false,
	WallCheck = false,

	AutoTiming = false,
	TimingDist = 14,
	TimingCooldown = 0.14,
	LastTimingTick = 0,

	ESP = false,
	Tracers = false,
	Nametags = false,
	XRay = false,
	RainbowBody = false,
	Headless = false,
	Korblox = false,
	HideOthers = false,
	Crosshair = false,
	LiveStats = false,

	DevClickInspect = false,
	DevClickDelete = false,
	DeletedParts = {},

	AdminUnlocked = false,
	Status = "Ready (" .. MainRole .. ")",
}

local SpawnedParts = {}
local AirFloorPart = nil
local RainbowHue = 0
local LastPromptTick = 0
local LastTouchTick = 0
local LastStatsTick = 0
local TracerLines = {}
local NametagGuis = {}

local function GetChar() return LocalPlayer.Character end
local function GetHum() local c = GetChar() return c and c:FindFirstChildOfClass("Humanoid") end
local function GetRoot() local c = GetChar() return c and (c:FindFirstChild("HumanoidRootPart") or c.PrimaryPart) end

local StatusBar = nil
local function SetMsg(m)
	State.Status = m
	if StatusBar and StatusBar.Parent then
		StatusBar.Text = "Status: " .. m
	end
end

local function GetTweenSpd()
	if State.SyncTweenToWS then
		return math.max(15, State.WalkSpeed * 2)
	end
	return math.max(15, State.TweenSpeed)
end

local function StopTween()
	if State.ActiveTween then
		pcall(function() State.ActiveTween:Cancel() end)
		State.ActiveTween = nil
	end
end

local function TweenToCF(cf)
	local r = GetRoot()
	if not r then return nil end
	StopTween()
	local spd = GetTweenSpd()
	local dist = (cf.Position - r.Position).Magnitude
	local dur = math.max(0.05, dist / spd)
	local tw = TweenService:Create(r, TweenInfo.new(dur, Enum.EasingStyle.Linear), { CFrame = cf })
	State.ActiveTween = tw
	tw:Play()
	SetMsg(string.format("Tween %.0f studs", dist))
	return tw
end

local function FindNearestRoot()
	local r = GetRoot()
	if not r then return nil, nil, math.huge end
	local bestR, bestP, bestD = nil, nil, math.huge
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and p.Character then
			local hrp = p.Character:FindFirstChild("HumanoidRootPart")
			if hrp then
				local d = (hrp.Position - r.Position).Magnitude
				if d < bestD then
					bestD = d
					bestR = hrp
					bestP = p
				end
			end
		end
	end
	return bestR, bestP, bestD
end

local function SpawnPart(size, cf, col, mat, trans, bounce)
	local r = GetRoot()
	if not r then return nil end
	local p = Instance.new("Part")
	p.Name = "ChelseaaSpawned"
	p.Size = size
	p.Anchored = true
	p.CanCollide = true
	p.Material = mat or Enum.Material.Neon
	p.Color = col or Color3.fromRGB(220, 38, 68)
	p.Transparency = trans or 0.25
	p.CFrame = r.CFrame * cf
	if bounce then
		p.Touched:Connect(function(hit)
			if hit and hit.Parent == GetChar() then
				local hrp = GetRoot()
				if hrp then
					hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, bounce, hrp.AssemblyLinearVelocity.Z)
				end
			end
		end)
	end
	p.Parent = Workspace
	table.insert(SpawnedParts, p)
	return p
end

local function ClearSpawned()
	for _, p in ipairs(SpawnedParts) do
		if p and p.Parent then p:Destroy() end
	end
	SpawnedParts = {}
end

local function SetESP(on)
	State.ESP = on
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and p.Character then
			local h = p.Character:FindFirstChild("ChelseaaESP")
			if on then
				if not h then
					h = Instance.new("Highlight")
					h.Name = "ChelseaaESP"
					h.FillColor = Color3.fromRGB(220, 38, 68)
					h.OutlineColor = Color3.fromRGB(56, 189, 248)
					h.FillTransparency = 0.5
					h.Parent = p.Character
				end
			elseif h then
				h:Destroy()
			end
		end
	end
end

local function ClearVisualOverlays()
	for _, ln in pairs(TracerLines) do
		if ln and ln.Parent then ln:Destroy() end
	end
	TracerLines = {}
	for _, bb in pairs(NametagGuis) do
		if bb and bb.Parent then bb:Destroy() end
	end
	NametagGuis = {}
end

local function SetXRay(on)
	State.XRay = on
	for _, v in ipairs(Workspace:GetDescendants()) do
		if v:IsA("BasePart") and not v:IsDescendantOf(GetChar() or Instance.new("Folder")) then
			if on then
				if v:GetAttribute("CSOrigT") == nil and v.Transparency < 0.5 and v.CanCollide then
					v:SetAttribute("CSOrigT", v.Transparency)
					v.Transparency = 0.65
				end
			else
				local orig = v:GetAttribute("CSOrigT")
				if orig ~= nil then
					v.Transparency = orig
					v:SetAttribute("CSOrigT", nil)
				end
			end
		end
	end
end

local function SetHideOthers(on)
	State.HideOthers = on
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and p.Character then
			for _, obj in ipairs(p.Character:GetDescendants()) do
				if obj:IsA("BasePart") or obj:IsA("Decal") or obj:IsA("Texture") then
					if on then
						if obj:GetAttribute("CSHideOrig") == nil then
							obj:SetAttribute("CSHideOrig", obj.Transparency)
							obj.Transparency = 1
						end
					else
						local orig = obj:GetAttribute("CSHideOrig")
						if orig ~= nil then
							obj.Transparency = orig
							obj:SetAttribute("CSHideOrig", nil)
						end
					end
				end
			end
		end
	end
end

local function SetSelfGhost(on)
	local c = GetChar()
	if not c then return end
	for _, obj in ipairs(c:GetDescendants()) do
		if obj:IsA("BasePart") and obj.Name ~= "HumanoidRootPart" then
			obj.Transparency = on and 0.65 or 0
		end
	end
end

local function SetFreecam(on)
	State.Freecam = on
	local cam = Workspace.CurrentCamera
	local r = GetRoot()
	if not cam then return end
	if on then
		State.TopDownView = false
		State.FreecamPos = cam.CFrame.Position
		cam.CameraType = Enum.CameraType.Scriptable
		if r then r.Anchored = true end
	else
		cam.CameraType = Enum.CameraType.Custom
		local h = GetHum()
		if h then cam.CameraSubject = h end
		if r and not State.FreezeChar then r.Anchored = false end
	end
end

local function SetTopDown(on)
	State.TopDownView = on
	local cam = Workspace.CurrentCamera
	if not cam then return end
	if on then
		if State.Freecam then SetFreecam(false) end
		cam.CameraType = Enum.CameraType.Scriptable
	else
		cam.CameraType = Enum.CameraType.Custom
		local h = GetHum()
		if h then cam.CameraSubject = h end
	end
end

local function SetNoRagdoll(on)
	State.NoRagdoll = on
	local h = GetHum()
	if h then
		pcall(function()
			h:SetStateEnabled(Enum.HumanoidStateType.FallingDown, not on)
			h:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, not on)
		end)
	end
end

local function SetFPSBooster(on)
	pcall(function()
		Lighting.GlobalShadows = not on
		Lighting.FogEnd = on and 1000000 or 10000
		for _, v in ipairs(Workspace:GetDescendants()) do
			if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
				if on then
					if v:GetAttribute("CSFxOrig") == nil then
						v:SetAttribute("CSFxOrig", v.Enabled)
						v.Enabled = false
					end
				else
					local orig = v:GetAttribute("CSFxOrig")
					if orig ~= nil then
						v.Enabled = orig
						v:SetAttribute("CSFxOrig", nil)
					end
				end
			end
		end
	end)
end

local function SetHeadless(on)
	State.Headless = on
	local c = GetChar()
	local head = c and c:FindFirstChild("Head")
	if head and head:IsA("BasePart") then
		head.Transparency = on and 1 or 0
		for _, d in ipairs(head:GetChildren()) do
			if d:IsA("Decal") or d:IsA("Texture") then d.Transparency = on and 1 or 0 end
		end
	end
end

local function SetKorblox(on)
	State.Korblox = on
	local c = GetChar()
	if not c then return end
	local old = c:FindFirstChild("ChelseaaKorbloxLeg")
	if old then old:Destroy() end
	local r15 = { "RightUpperLeg", "RightLowerLeg", "RightFoot" }
	local r6 = c:FindFirstChild("Right Leg")
	local anchor = c:FindFirstChild("RightUpperLeg") or r6
	if on then
		for _, n in ipairs(r15) do local p = c:FindFirstChild(n) if p and p:IsA("BasePart") then p.Transparency = 1 end end
		if r6 and r6:IsA("BasePart") then r6.Transparency = 1 end
		if anchor and anchor:IsA("BasePart") then
			local kp = Instance.new("Part")
			kp.Name = "ChelseaaKorbloxLeg"
			kp.Size = Vector3.new(1, 2, 1)
			kp.CanCollide = false
			kp.Massless = true
			kp.Color = Color3.fromRGB(45, 52, 68)
			kp.CFrame = anchor.CFrame * CFrame.new(0, -0.35, 0)
			kp.Parent = c
			local m = Instance.new("SpecialMesh", kp)
			m.MeshType = Enum.MeshType.FileMesh
			m.MeshId = "rbxassetid://101851696"
			m.TextureId = "rbxassetid://101851254"
			local w = Instance.new("WeldConstraint", kp)
			w.Part0 = anchor
			w.Part1 = kp
		end
	else
		for _, n in ipairs(r15) do local p = c:FindFirstChild(n) if p and p:IsA("BasePart") then p.Transparency = 0 end end
		if r6 and r6:IsA("BasePart") then r6.Transparency = 0 end
	end
end

local function TapScreen(x, y, btnObj)
	local now = os.clock()
	if (now - State.LastClickTick) * 1000 < State.ClickCooldownMs then return false end
	State.LastClickTick = now
	State.TrainClicks += 1
	local inset = GuiService:GetGuiInset()
	local fx, fy = math.floor(x + inset.X), math.floor(y + inset.Y)
	local ok = false
	if VirtualInputManager then
		ok = pcall(function()
			VirtualInputManager:SendMouseButtonEvent(fx, fy, 0, true, game, 1)
			task.defer(function()
				pcall(function() VirtualInputManager:SendMouseButtonEvent(fx, fy, 0, false, game, 1) end)
			end)
		end)
	end
	if btnObj and (btnObj:IsA("TextButton") or btnObj:IsA("ImageButton")) and type(firesignal) == "function" then
		pcall(function() firesignal(btnObj.MouseButton1Click) end)
	end
	if not ok and VirtualUser then
		pcall(function() VirtualUser:CaptureController() VirtualUser:ClickButton1(Vector2.new(fx, fy)) end)
	end
	return true
end

local function MatchMult(txt)
	if not txt or txt == "" or #txt > 18 then return nil, 0 end
	local s = string.lower(string.gsub(txt, "%s+", ""))
	if string.find(s, "2%.30*x") or string.find(s, "2%.3x") then return "2.30x", 2.3 end
	for _, tag in ipairs({ "4x", "3x", "2x", "1x" }) do
		local n = string.sub(tag, 1, 1)
		if string.find(s, "^" .. n .. "%.?0*x$") or string.find(s, "%f[%d]" .. n .. "%.?0*x%f[%A]") then
			return tag, tonumber(n)
		end
	end
	return nil, 0
end

local function AllowMult(tag, val)
	if State.AutoTrainFilter == "ALL" then return true
	elseif State.AutoTrainFilter == "2X_PLUS" then return val >= 2.0
	elseif State.AutoTrainFilter == "MAX_ONLY" then return val >= 2.3
	elseif State.AutoTrainFilter == "2X_ONLY" then return tag == "2x" or tag == "2.30x"
	end
	return true
end

local function StepAutoTrain()
	local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
	if not pg then return end
	for _, g in ipairs(pg:GetChildren()) do
		if g:IsA("ScreenGui") and g.Enabled and g.Name ~= "ChelseaaDeltaV12" then
			for _, d in ipairs(g:GetDescendants()) do
				if (d:IsA("TextLabel") or d:IsA("TextButton")) and d.Visible and d.AbsoluteSize.X >= 4 then
					local tag, val = MatchMult(d.Text)
					if tag and AllowMult(tag, val) then
						local cx = d.AbsolutePosition.X + d.AbsoluteSize.X * 0.5
						local cy = d.AbsolutePosition.Y + d.AbsoluteSize.Y * 0.5
						if TapScreen(cx, cy, d:IsA("TextButton") and d or nil) then
							State.LastHit = tag
							return
						end
					end
				end
			end
		end
	end
end

local function GetClosestTarget(partName)
	local cam = Workspace.CurrentCamera
	if not cam then return nil end
	local center = Vector2.new(cam.ViewportSize.X * 0.5, cam.ViewportSize.Y * 0.5)
	local bestPart, bestDist = nil, State.CombatFOV
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and not (State.TeamCheck and p.Team and LocalPlayer.Team and p.Team == LocalPlayer.Team) then
			local c = p.Character
			local h = c and c:FindFirstChildOfClass("Humanoid")
			local pt = c and (c:FindFirstChild(partName) or c:FindFirstChild("HumanoidRootPart"))
			if h and h.Health > 0 and pt then
				local sp, onScr = cam:WorldToViewportPoint(pt.Position)
				if onScr and sp.Z > 0 then
					local d = (Vector2.new(sp.X, sp.Y) - center).Magnitude
					if d <= bestDist then
						if not State.WallCheck then
							bestDist = d
							bestPart = pt
						else
							local rp = RaycastParams.new()
							rp.FilterType = Enum.RaycastFilterType.Exclude
							rp.FilterDescendantsInstances = { GetChar(), c }
							if Workspace:Raycast(cam.CFrame.Position, pt.Position - cam.CFrame.Position, rp) == nil then
								bestDist = d
								bestPart = pt
							end
						end
					end
				end
			end
		end
	end
	return bestPart
end

pcall(function()
	if type(hookmetamethod) ~= "function" then return end
	local wrap = type(newcclosure) == "function" and newcclosure or function(f) return f end
	local oldNC
	oldNC = hookmetamethod(game, "__namecall", wrap(function(self, ...)
		local m = getnamecallmethod()
		if State.SilentAim and not checkcaller() then
			local pt = GetClosestTarget(State.SilentAimPart)
			if pt and m == "Raycast" and self == Workspace then
				local args = { ... }
				if typeof(args[1]) == "Vector3" then
					local dist = typeof(args[2]) == "Vector3" and math.max(args[2].Magnitude, 500) or 1000
					args[2] = (pt.Position - args[1]).Unit * dist
					return oldNC(self, unpack(args))
				end
			end
		end
		return oldNC(self, ...)
	end))
end)

local function StepTycoon()
	local r = GetRoot()
	if not r or type(firetouchinterest) ~= "function" then return end
	local folder = Workspace:FindFirstChild("Tycoons") or Workspace:FindFirstChild("Bases")
	if not folder then return end
	for _, ty in ipairs(folder:GetChildren()) do
		local own = ty:FindFirstChild("Owner") or ty:GetAttribute("Owner")
		if own == LocalPlayer or own == LocalPlayer.Name or own == LocalPlayer.UserId then
			if State.TycoonCollect then
				local col = ty:FindFirstChild("Collector", true) or ty:FindFirstChild("CashPad", true)
				if col and col:IsA("BasePart") then
					pcall(function()
						firetouchinterest(r, col, 0)
						task.wait(0.03)
						firetouchinterest(r, col, 1)
					end)
				end
			end
			if State.TycoonBuy then
				local btns = ty:FindFirstChild("Buttons") or ty:FindFirstChild("Upgrades")
				if btns then
					for _, b in ipairs(btns:GetChildren()) do
						local hd = b:FindFirstChild("Head") or (b:IsA("BasePart") and b)
						if hd and hd:IsA("BasePart") and hd.Transparency < 1 then
							pcall(function()
								firetouchinterest(r, hd, 0)
								task.wait(0.03)
								firetouchinterest(r, hd, 1)
							end)
						end
					end
				end
			end
		end
	end
end

task.spawn(function()
	while true do
		if State.TycoonCollect or State.TycoonBuy then
			pcall(StepTycoon)
		end
		task.wait(0.55)
	end
end)

--// =========================================================================
--// CLEAN FEATURE REGISTRY (SIFAR NOMBOR DALAM MENU)
--// =========================================================================
local Registry = {}
local Lookup = {}

local function Reg(name, cat, desc, fn)
	local item = {
		name = name,
		cat = cat,
		desc = desc,
		run = function()
			pcall(fn)
			SetMsg(string.format("[%s] %s — %s", cat, name, desc))
		end,
	}
	table.insert(Registry, item)
	Lookup[string.lower(name)] = item
end

-- Movement & Physics Features
Reg("WalkSpeed Lock", "Movement", "Kunci nilai WalkSpeed semasa", function() State.WalkSpeedLock = not State.WalkSpeedLock end)
Reg("Reset WalkSpeed", "Movement", "Kembalikan WalkSpeed normal", function() State.WalkSpeed = 16 State.WalkSpeedLock = false local h = GetHum() if h then h.WalkSpeed = 16 end end)
Reg("JumpPower Lock", "Movement", "Kunci nilai JumpPower semasa", function() State.JumpPowerLock = not State.JumpPowerLock end)
Reg("Reset JumpPower", "Movement", "Kembalikan JumpPower normal", function() State.JumpPower = 50 State.JumpPowerLock = false local h = GetHum() if h then h.UseJumpPower = true h.JumpPower = 50 end end)
Reg("Infinite Jump", "Movement", "Lompat tanpa had di udara", function() State.InfJump = not State.InfJump end)
Reg("Bunny Hop", "Movement", "Lompat automatik berterusan semasa bergerak", function() State.BunnyHop = not State.BunnyHop end)
Reg("Click Teleport Tool", "Movement", "Ketik mana-mana permukaan untuk teleport", function() State.ClickTP = not State.ClickTP end)
Reg("Moon Walk Mode", "Movement", "Berjalan menghadap arah bertentangan", function() State.MoonWalk = not State.MoonWalk end)
Reg("ShiftLock Helper", "Movement", "Karakter sentiasa menghadap arah kamera", function() State.ShiftLockHelper = not State.ShiftLockHelper end)
Reg("Noclip Walk", "Movement", "Tembus dinding & halangan", function() State.Noclip = not State.Noclip end)
Reg("Fly Mode", "Movement", "Terbang bebas ikut arah kamera", function() State.Fly = not State.Fly end)
Reg("Increase Fly Speed", "Movement", "Naikkan kelajuan terbang", function() State.FlySpeed = math.min(500, State.FlySpeed + 35) end)
Reg("Decrease Fly Speed", "Movement", "Turunkan kelajuan terbang", function() State.FlySpeed = math.max(15, State.FlySpeed - 35) end)
Reg("Air Walk Platform", "Movement", "Lantai halimunan di bawah kaki", function() State.AirWalk = not State.AirWalk end)
Reg("Spider Wall Climb", "Movement", "Panjat dinding secara automatik", function() State.SpiderClimb = not State.SpiderClimb end)
Reg("Anti-Fling Guard", "Movement", "Halang karakter terpelanting jauh", function() State.AntiFling = not State.AntiFling end)
Reg("Anti-Void Rescue", "Movement", "Selamatkan karakter jika jatuh bawah peta", function() State.AntiVoid = not State.AntiVoid end)
Reg("Orbit Nearest Player", "Movement", "Pusing mengelilingi pemain terdekat", function() State.OrbitPlayer = not State.OrbitPlayer end)
Reg("Forward Dash", "Movement", "Luncur pantas ke hadapan", function() local r = GetRoot() if r then r.CFrame = r.CFrame * CFrame.new(0, 0, -25) end end)
Reg("Long Dash", "Movement", "Luncur jarak jauh ke hadapan", function() local r = GetRoot() if r then r.CFrame = r.CFrame * CFrame.new(0, 0, -60) end end)
Reg("Instant Stop Motion", "Movement", "Hentikan semua momentum karakter", function() local r = GetRoot() if r then r.AssemblyLinearVelocity = Vector3.zero r.AssemblyAngularVelocity = Vector3.zero end end)
Reg("Zero Gravity Float", "Movement", "Apungkan dunia tanpa tarikan graviti", function() Workspace.Gravity = 0 end)
Reg("Low Gravity", "Movement", "Kurangkan graviti dunia", function() Workspace.Gravity = 65 end)
Reg("High Gravity Drop", "Movement", "Tingkatkan graviti untuk turun pantas", function() Workspace.Gravity = 450 end)
Reg("Normal Gravity", "Movement", "Pulihkan graviti asal", function() Workspace.Gravity = 196.2 end)
Reg("Slippery Ice Walk", "Movement", "Tukar lantai menjadi licin seperti ais", function()
	local c = GetChar()
	if c then
		for _, pt in ipairs(c:GetDescendants()) do
			if pt:IsA("BasePart") then pt.CustomPhysicalProperties = PhysicalProperties.new(0.7, 0.01, 0.5, 100, 1) end
		end
	end
end)
Reg("Reset Physics", "Movement", "Pulihkan geseran kaki & graviti asal", function()
	Workspace.Gravity = 196.2
	local c = GetChar()
	if c then
		for _, pt in ipairs(c:GetDescendants()) do
			if pt:IsA("BasePart") then pt.CustomPhysicalProperties = nil end
		end
	end
end)
Reg("Freeze Character", "Movement", "Kunci kedudukan karakter di tempat", function() local r = GetRoot() if r then State.FreezeChar = not State.FreezeChar r.Anchored = State.FreezeChar end end)
Reg("HipHeight Float", "Movement", "Tinggikan kedudukan badan atas tanah", function() local h = GetHum() if h then if State.OrigHipHeight == nil then State.OrigHipHeight = h.HipHeight end h.HipHeight = State.OrigHipHeight + 4 end end)
Reg("Reset HipHeight", "Movement", "Pulihkan ketinggian badan asal", function() local h = GetHum() if h and State.OrigHipHeight ~= nil then h.HipHeight = State.OrigHipHeight end end)
Reg("Spin Mode", "Movement", "Putar karakter secara berterusan", function() State.SpinMode = not State.SpinMode end)
Reg("Swim In Air", "Movement", "Aktifkan mod berenang di udara", function() State.SwimInAir = not State.SwimInAir end)
Reg("No Fall Ragdoll", "Movement", "Elak karakter terjatuh atau ragdoll", function() SetNoRagdoll(not State.NoRagdoll) end)
Reg("Sit Character", "Movement", "Dudukkan karakter di tempat semasa", function() local h = GetHum() if h then h.Sit = true end end)

-- Tween & Waypoint Features
Reg("Sync Tween Double WS", "Tween", "Selaraskan laju Tween dengan gandaan WalkSpeed", function() State.SyncTweenToWS = not State.SyncTweenToWS end)
Reg("Save Waypoint Alpha", "Tween", "Simpan lokasi ke Waypoint Alpha", function() local r = GetRoot() if r then State.Waypoints["Alpha"] = r.CFrame end end)
Reg("Tween Waypoint Alpha", "Tween", "Tween ke lokasi Waypoint Alpha", function() if State.Waypoints["Alpha"] then TweenToCF(State.Waypoints["Alpha"]) end end)
Reg("Instant TP Waypoint Alpha", "Tween", "Teleport terus ke Waypoint Alpha", function() local r = GetRoot() if r and State.Waypoints["Alpha"] then r.CFrame = State.Waypoints["Alpha"] end end)
Reg("Save Waypoint Beta", "Tween", "Simpan lokasi ke Waypoint Beta", function() local r = GetRoot() if r then State.Waypoints["Beta"] = r.CFrame end end)
Reg("Tween Waypoint Beta", "Tween", "Tween ke lokasi Waypoint Beta", function() if State.Waypoints["Beta"] then TweenToCF(State.Waypoints["Beta"]) end end)
Reg("Save Waypoint Gamma", "Tween", "Simpan lokasi ke Waypoint Gamma", function() local r = GetRoot() if r then State.Waypoints["Gamma"] = r.CFrame end end)
Reg("Tween Waypoint Gamma", "Tween", "Tween ke lokasi Waypoint Gamma", function() if State.Waypoints["Gamma"] then TweenToCF(State.Waypoints["Gamma"]) end end)
Reg("Save Waypoint Delta", "Tween", "Simpan lokasi ke Waypoint Delta", function() local r = GetRoot() if r then State.Waypoints["Delta"] = r.CFrame end end)
Reg("Tween Waypoint Delta", "Tween", "Tween ke lokasi Waypoint Delta", function() if State.Waypoints["Delta"] then TweenToCF(State.Waypoints["Delta"]) end end)
Reg("Save Waypoint Omega", "Tween", "Simpan lokasi ke Waypoint Omega", function() local r = GetRoot() if r then State.Waypoints["Omega"] = r.CFrame end end)
Reg("Tween Waypoint Omega", "Tween", "Tween ke lokasi Waypoint Omega", function() if State.Waypoints["Omega"] then TweenToCF(State.Waypoints["Omega"]) end end)
Reg("Save Waypoint SafeZone", "Tween", "Simpan lokasi ke SafeZone", function() local r = GetRoot() if r then State.Waypoints["SafeZone"] = r.CFrame end end)
Reg("Tween Waypoint SafeZone", "Tween", "Tween ke lokasi SafeZone", function() if State.Waypoints["SafeZone"] then TweenToCF(State.Waypoints["SafeZone"]) end end)
Reg("Step Forward Short", "Tween", "Anjak sedikit ke hadapan tembus dinding nipis", function() local r = GetRoot() if r then r.CFrame = r.CFrame * CFrame.new(0, 0, -6) end end)
Reg("Step Upward Roof", "Tween", "Naik terus ke tingkat atas / bumbung", function() local r = GetRoot() if r then r.CFrame = r.CFrame + Vector3.new(0, 22, 0) end end)
Reg("Drop Downward Floor", "Tween", "Turun terus ke tingkat bawah", function() local r = GetRoot() if r then r.CFrame = r.CFrame - Vector3.new(0, 22, 0) end end)
Reg("Tween Sky High", "Tween", "Tween naik tinggi ke langit", function() local r = GetRoot() if r then TweenToCF(r.CFrame + Vector3.new(0, 500, 0)) end end)
Reg("TP to SpawnLocation", "Tween", "Teleport ke titik Spawn utama peta", function()
	local r = GetRoot()
	local sp = Workspace:FindFirstChildWhichIsA("SpawnLocation", true)
	if r and sp then r.CFrame = sp.CFrame + Vector3.new(0, 4, 0) end
end)
Reg("TP Random Player", "Tween", "Teleport ke pemain rawak dalam pelayan", function()
	local r = GetRoot()
	local list = {}
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
			table.insert(list, p.Character.HumanoidRootPart)
		end
	end
	if r and #list > 0 then
		local target = list[math.random(1, #list)]
		r.CFrame = target.CFrame * CFrame.new(0, 0, 3)
	end
end)
Reg("Stop Active Tween", "Tween", "Hentikan pergerakan Tween semasa", function() StopTween() end)

-- Auto Farm & Interaction Features
Reg("Auto Train Cursor", "Auto", "Klik pengganda latihan secara automatik", function() State.AutoTrain = not State.AutoTrain end)
Reg("Train Filter: All Multipliers", "Auto", "Terima semua pengganda latihan", function() State.AutoTrainFilter = "ALL" end)
Reg("Train Filter: High Only", "Auto", "Fokus pengganda tertinggi sahaja", function() State.AutoTrainFilter = "MAX_ONLY" end)
Reg("Train Filter: Standard Plus", "Auto", "Fokus pengganda sederhana & tinggi", function() State.AutoTrainFilter = "2X_PLUS" end)
Reg("Auto Click: Fast Mode", "Auto", "Mod klik pantas tanpa lengah", function() State.ClickCooldownMs = 45 end)
Reg("Auto Click: Balanced Mode", "Auto", "Mod klik seimbang & stabil", function() State.ClickCooldownMs = 85 end)
Reg("Auto Click: Safe Mode", "Auto", "Mod klik perlahan anti-kesan", function() State.ClickCooldownMs = 140 end)
Reg("Auto ProximityPrompt", "Auto", "Aktifkan semua prompt berdekatan", function() State.AutoPrompt = not State.AutoPrompt end)
Reg("Auto Touch Collect", "Auto", "Kutip item sentuhan secara automatik", function() State.AutoTouch = not State.AutoTouch end)
Reg("Tycoon Auto Collect", "Auto", "Kutip wang tycoon secara automatik", function() State.TycoonCollect = not State.TycoonCollect end)
Reg("Tycoon Auto Buy", "Auto", "Beli naik taraf tycoon automatik", function() State.TycoonBuy = not State.TycoonBuy end)
Reg("Auto Perfect Timing", "Auto", "Tepis / klik tepat pada masa objek datang", function() State.AutoTiming = not State.AutoTiming end)
Reg("Timing Range: Wide", "Auto", "Luaskan jarak pengesanan timing", function() State.TimingDist = 20 end)
Reg("Timing Range: Close", "Auto", "Rapatkan jarak pengesanan timing", function() State.TimingDist = 11 end)
Reg("Center Screen Tap", "Auto", "Hantar sentuhan di tengah skrin", function() local vp = Workspace.CurrentCamera and Workspace.CurrentCamera.ViewportSize or Vector2.new(500, 500) TapScreen(vp.X * 0.5, vp.Y * 0.5, nil) end)

-- Combat & Targeting Features
Reg("Camera Aimbot", "Combat", "Kunci kamera ke sasaran terdekat", function() State.Aimbot = not State.Aimbot end)
Reg("Aimbot Target: Head", "Combat", "Fokus Aimbot pada kepala", function() State.AimbotPart = "Head" end)
Reg("Aimbot Target: Torso", "Combat", "Fokus Aimbot pada badan", function() State.AimbotPart = "HumanoidRootPart" end)
Reg("Aimbot Smooth: Snap", "Combat", "Kunci kamera dengan pantas", function() State.AimbotSmoothness = 0.65 end)
Reg("Aimbot Smooth: Legit", "Combat", "Pergerakan kamera semula jadi", function() State.AimbotSmoothness = 0.18 end)
Reg("Silent Aim Raycast", "Combat", "Halakan tembakan raycast ke sasaran", function() State.SilentAim = not State.SilentAim end)
Reg("Silent Target: Head", "Combat", "Fokus Silent Aim pada kepala", function() State.SilentAimPart = "Head" end)
Reg("Silent Target: Torso", "Combat", "Fokus Silent Aim pada badan", function() State.SilentAimPart = "HumanoidRootPart" end)
Reg("Combat FOV: Small", "Combat", "Kecilkan bulatan sasaran", function() State.CombatFOV = 120 end)
Reg("Combat FOV: Medium", "Combat", "Sederhanakan bulatan sasaran", function() State.CombatFOV = 220 end)
Reg("Combat FOV: Wide", "Combat", "Luaskan bulatan sasaran", function() State.CombatFOV = 420 end)
Reg("Team Check", "Combat", "Abaikan rakan sepasukan", function() State.TeamCheck = not State.TeamCheck end)
Reg("Wall Check", "Combat", "Jangan kunci sasaran di sebalik dinding", function() State.WallCheck = not State.WallCheck end)
Reg("TP Nearest Player", "Combat", "Teleport terus ke pemain terdekat", function() local r = GetRoot() local nr = FindNearestRoot() if r and nr then r.CFrame = nr.CFrame * CFrame.new(0, 0, 3) end end)
Reg("Tween Nearest Player", "Combat", "Tween lancar ke pemain terdekat", function() local nr = FindNearestRoot() if nr then TweenToCF(nr.CFrame * CFrame.new(0, 0, 3)) end end)
Reg("TP Behind Nearest", "Combat", "Teleport ke belakang pemain terdekat", function() local r = GetRoot() local nr = FindNearestRoot() if r and nr then r.CFrame = nr.CFrame * CFrame.new(0, 0, 5) end end)
Reg("TP Above Nearest", "Combat", "Teleport di atas pemain terdekat", function() local r = GetRoot() local nr = FindNearestRoot() if r and nr then r.CFrame = nr.CFrame * CFrame.new(0, 12, 0) end end)

-- Visual, Camera, Lighting & Avatar Features
Reg("Player ESP", "Visual", "Serlahkan kedudukan semua pemain", function() SetESP(not State.ESP) end)
Reg("Player Tracer Lines", "Visual", "Papar garisan penunjuk ke pemain lain", function() State.Tracers = not State.Tracers if not State.Tracers then for _, l in pairs(TracerLines) do if l then l.Visible = false end end end end)
Reg("Distance Nametags", "Visual", "Papar nama & jarak pemain di atas kepala", function() State.Nametags = not State.Nametags if not State.Nametags then for _, b in pairs(NametagGuis) do if b then b.Enabled = false end end end end)
Reg("X-Ray Walls", "Visual", "Lutsinarkan dinding di seluruh peta", function() SetXRay(not State.XRay) end)
Reg("Rainbow Body", "Visual", "Tukar warna badan kepada pelangi", function() State.RainbowBody = not State.RainbowBody end)
Reg("Self Ghost Aura", "Visual", "Jadikan karakter sendiri lutsinar bayang", function() SetSelfGhost(true) end)
Reg("Solid Avatar Reset", "Visual", "Pulihkan kelegapan karakter sendiri", function() SetSelfGhost(false) end)
Reg("Hide Other Players", "Visual", "Sembunyikan pemain lain secara lokal", function() SetHideOthers(not State.HideOthers) end)
Reg("Center Crosshair", "Visual", "Papar tanda sasaran di tengah skrin", function() State.Crosshair = not State.Crosshair end)
Reg("Headless Mode", "Avatar", "Sembunyikan kepala karakter", function() SetHeadless(not State.Headless) end)
Reg("Korblox Leg", "Avatar", "Pasang gaya kaki Korblox", function() SetKorblox(not State.Korblox) end)
Reg("Fullbright & NoFog", "Visual", "Terangkan peta & buang kabus", function() Lighting.Brightness = 3 Lighting.ClockTime = 14 Lighting.FogEnd = 1000000 Lighting.GlobalShadows = false end)
Reg("Cyberpunk Neon Sky", "Visual", "Tukar pencahayaan kepada neon ungu-biru", function() Lighting.ClockTime = 21 Lighting.Brightness = 1.8 Lighting.Ambient = Color3.fromRGB(65, 25, 110) Lighting.OutdoorAmbient = Color3.fromRGB(35, 95, 145) end)
Reg("Golden Hour Glow", "Visual", "Tukar pencahayaan kepada cahaya keemasan", function() Lighting.ClockTime = 17.5 Lighting.Brightness = 2.4 Lighting.Ambient = Color3.fromRGB(140, 95, 50) Lighting.OutdoorAmbient = Color3.fromRGB(165, 115, 65) end)
Reg("Crimson Blood Moon", "Visual", "Tukar atmosfera kepada tema merah gelap", function() Lighting.ClockTime = 1 Lighting.Brightness = 1.3 Lighting.Ambient = Color3.fromRGB(115, 20, 35) Lighting.OutdoorAmbient = Color3.fromRGB(90, 15, 25) end)
Reg("No Blur & Bloom", "Visual", "Buang kesan silau dan kabur skrin", function() for _, fx in ipairs(Lighting:GetChildren()) do if fx:IsA("BlurEffect") or fx:IsA("BloomEffect") or fx:IsA("SunRaysEffect") or fx:IsA("DepthOfFieldEffect") then fx.Enabled = false end end end)
Reg("Remove Fog Only", "Visual", "Buang kabus jarak jauh sahaja", function() Lighting.FogEnd = 1000000 end)
Reg("Clear Skybox", "Visual", "Padam langit tersuai peta", function() for _, s in ipairs(Lighting:GetChildren()) do if s:IsA("Sky") then s:Destroy() end end end)
Reg("Midnight Sky", "Visual", "Tukar suasana kepada waktu malam", function() Lighting.ClockTime = 0 Lighting.Brightness = 1 end)
Reg("Sunset Sky", "Visual", "Tukar suasana kepada waktu senja", function() Lighting.ClockTime = 18.25 Lighting.Brightness = 1.6 end)
Reg("Restore Lighting", "Visual", "Pulihkan pencahayaan asal peta", function() Lighting.Brightness = 2 Lighting.ClockTime = 14 Lighting.FogEnd = 10000 Lighting.Ambient = Color3.fromRGB(127, 127, 127) Lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127) Lighting.GlobalShadows = true end)

-- Camera Features
Reg("Freecam Mode", "Camera", "Gerakkan kamera secara bebas di peta", function() SetFreecam(not State.Freecam) end)
Reg("Top Down View", "Camera", "Pandangan kamera dari atas mengikuti pemain", function() SetTopDown(not State.TopDownView) end)
Reg("Lock First Person", "Camera", "Kunci kamera sudut pandang pertama", function() LocalPlayer.CameraMode = Enum.CameraMode.LockFirstPerson end)
Reg("Unlock Third Person", "Camera", "Bebaskan kamera sudut pandang ketiga", function() LocalPlayer.CameraMode = Enum.CameraMode.Classic end)
Reg("Camera Shake Reset", "Camera", "Hentikan gegaran offset kamera", function() local h = GetHum() if h then h.CameraOffset = Vector3.zero end end)
Reg("Spectate Next Player", "Camera", "Tonton pandangan pemain lain", function()
	local list = {}
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and p.Character and p.Character:FindFirstChildOfClass("Humanoid") then
			table.insert(list, p)
		end
	end
	if #list > 0 then
		State.SpectateIndex = (State.SpectateIndex % #list) + 1
		local target = list[State.SpectateIndex]
		local cam = Workspace.CurrentCamera
		if cam and target.Character then
			cam.CameraSubject = target.Character:FindFirstChildOfClass("Humanoid")
			SetMsg("Spectating: " .. target.Name)
		end
	end
end)
Reg("Stop Spectating", "Camera", "Kembalikan kamera ke karakter sendiri", function()
	local cam = Workspace.CurrentCamera
	local h = GetHum()
	if cam and h then cam.CameraSubject = h end
end)
Reg("Max Camera Zoom", "Camera", "Buka had zoom kamera jauh", function() LocalPlayer.CameraMaxZoomDistance = 1000 end)
Reg("Reset Camera Zoom", "Camera", "Pulihkan jarak zoom kamera asal", function() LocalPlayer.CameraMaxZoomDistance = 128 end)
Reg("Camera FOV: Default", "Camera", "Pulihkan jarak pandang kamera asal", function() local c = Workspace.CurrentCamera if c then c.FieldOfView = 70 end end)
Reg("Camera FOV: Wide", "Camera", "Luaskan sudut pandang kamera", function() local c = Workspace.CurrentCamera if c then c.FieldOfView = 95 end end)
Reg("Camera FOV: Ultra", "Camera", "Sudut pandang kamera maksimum", function() local c = Workspace.CurrentCamera if c then c.FieldOfView = 115 end end)

-- World Builder Features
Reg("Spawn Neon Pad", "World", "Cipta lantai neon di bawah kaki", function() SpawnPart(Vector3.new(16, 1, 16), CFrame.new(0, -3.5, 0), Color3.fromRGB(220, 38, 68), Enum.Material.Neon, 0.3) end)
Reg("Spawn Floating Ring", "World", "Cipta platform silinder bercahaya di bawah kaki", function()
	local p = SpawnPart(Vector3.new(1, 22, 22), CFrame.new(0, -3.5, 0) * CFrame.Angles(0, 0, math.rad(90)), Color3.fromRGB(56, 189, 248), Enum.Material.Neon, 0.25)
	if p then p.Shape = Enum.PartType.Cylinder end
end)
Reg("Spawn Glass Wall", "World", "Cipta dinding kaca lutsinar di hadapan", function() SpawnPart(Vector3.new(20, 12, 1), CFrame.new(0, 3, -8), Color3.fromRGB(180, 230, 255), Enum.Material.Glass, 0.45) end)
Reg("Spawn Stairway Ramp", "World", "Cipta tangga condong untuk memanjat tinggi", function() SpawnPart(Vector3.new(10, 1, 42), CFrame.new(0, 8, -22) * CFrame.Angles(math.rad(28), 0, 0), Color3.fromRGB(168, 85, 247), Enum.Material.Neon, 0.3) end)
Reg("Spawn Sky Base", "World", "Cipta & naik ke markas langit", function() local p = SpawnPart(Vector3.new(36, 1.5, 36), CFrame.new(0, 350, 0), Color3.fromRGB(244, 114, 182), Enum.Material.Neon, 0.25) local r = GetRoot() if p and r then r.CFrame = p.CFrame * CFrame.new(0, 4, 0) end end)
Reg("Spawn Bounce Pad", "World", "Cipta pad lompatan tinggi", function() SpawnPart(Vector3.new(14, 1, 14), CFrame.new(0, -3.5, -8), Color3.fromRGB(56, 189, 248), Enum.Material.Neon, 0.2, 130) end)
Reg("Spawn Safe Bridge", "World", "Cipta jambatan panjang di hadapan", function() SpawnPart(Vector3.new(10, 1, 60), CFrame.new(0, -3.5, -32), Color3.fromRGB(34, 197, 94), Enum.Material.SmoothPlastic, 0.35) end)
Reg("Spawn Safety Cage", "World", "Cipta sangkar perlindungan sekeliling", function()
	SpawnPart(Vector3.new(14, 1, 14), CFrame.new(0, -3.5, 0), Color3.fromRGB(56, 189, 248), Enum.Material.ForceField, 0.35)
	SpawnPart(Vector3.new(14, 1, 14), CFrame.new(0, 7.5, 0), Color3.fromRGB(56, 189, 248), Enum.Material.ForceField, 0.35)
	SpawnPart(Vector3.new(14, 11, 1), CFrame.new(0, 2, -7), Color3.fromRGB(56, 189, 248), Enum.Material.ForceField, 0.35)
	SpawnPart(Vector3.new(14, 11, 1), CFrame.new(0, 2, 7), Color3.fromRGB(56, 189, 248), Enum.Material.ForceField, 0.35)
	SpawnPart(Vector3.new(1, 11, 14), CFrame.new(-7, 2, 0), Color3.fromRGB(56, 189, 248), Enum.Material.ForceField, 0.35)
	SpawnPart(Vector3.new(1, 11, 14), CFrame.new(7, 2, 0), Color3.fromRGB(56, 189, 248), Enum.Material.ForceField, 0.35)
end)
Reg("Remove Terrain Water", "World", "Kosongkan air di dalam terrain peta", function() if Workspace.Terrain then Workspace.Terrain:Clear() end end)
Reg("Clear Spawned Parts", "World", "Padam semua binaan yang dicipta", function() ClearSpawned() end)

-- Server, Performance, Character & Developer Utility Features
Reg("FPS Booster Low Graphics", "Utility", "Kurangkan kesan grafik untuk naikkan FPS", function() SetFPSBooster(true) end)
Reg("Restore Graphics", "Utility", "Pulihkan semula bayang & kesan partikel", function() SetFPSBooster(false) end)
Reg("Live Stats HUD", "Utility", "Papar bar FPS, Ping & Koordinat di skrin", function() State.LiveStats = not State.LiveStats end)
Reg("Mute Game Sounds", "Utility", "Senyapkan semua bunyi aktif permainan", function()
	for _, s in ipairs(game:GetDescendants()) do
		if s:IsA("Sound") and s.Volume > 0 then
			s:SetAttribute("CSOrigVol", s.Volume)
			s.Volume = 0
		end
	end
end)
Reg("Unmute Game Sounds", "Utility", "Pulihkan semula bunyi permainan", function()
	for _, s in ipairs(game:GetDescendants()) do
		if s:IsA("Sound") then
			local ov = s:GetAttribute("CSOrigVol")
			if ov ~= nil then s.Volume = ov s:SetAttribute("CSOrigVol", nil) end
		end
	end
end)
Reg("Unlock Inventory UI", "Utility", "Paksa paparkan semula Backpack & PlayerList", function()
	pcall(function() StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true) end)
	pcall(function() StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, true) end)
end)
Reg("List All Players", "Utility", "Papar senarai pemain dalam pelayan", function()
	local names = {}
	for _, p in ipairs(Players:GetPlayers()) do table.insert(names, p.Name) end
	SetMsg("Pemain: " .. table.concat(names, ", "))
end)
Reg("Copy Place ID", "Utility", "Salin ID permainan semasa", function() SafeCopy(tostring(game.PlaceId)) end)
Reg("Copy Server Job ID", "Utility", "Salin ID pelayan semasa", function() SafeCopy(tostring(game.JobId)) end)
Reg("Rejoin Server", "Server", "Masuk semula ke pelayan semasa", function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer) end)
Reg("Server Hop", "Server", "Tukar ke pelayan awam lain", function()
	pcall(function()
		local raw = game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")
		local data = HttpService:JSONDecode(raw)
		if data and data.data then
			for _, s in ipairs(data.data) do
				if s.id ~= game.JobId and s.playing < s.maxPlayers then
					TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, LocalPlayer)
					break
				end
			end
		end
	end)
end)
Reg("Reset Character", "Character", "Hidupkan semula karakter", function() local h = GetHum() if h then h.Health = 0 end end)
Reg("Instant Respawn", "Character", "Muat semula karakter serta-merta apabila mati", function() State.InstantRespawn = not State.InstantRespawn end)
Reg("Copy Position", "Utility", "Salin koordinat semasa", function() local r = GetRoot() if r then SafeCopy(string.format("%.1f, %.1f, %.1f", r.Position.X, r.Position.Y, r.Position.Z)) end end)
Reg("Copy Discord Invite", "Utility", "Salin pautan jemputan Discord", function() SafeCopy(KeyConfig.DiscordInvite) end)
Reg("Anti-AFK Bypass", "Utility", "Elak ditendang keluar ketika melahu", function() LocalPlayer.Idled:Connect(function() if VirtualUser then VirtualUser:CaptureController() VirtualUser:ClickButton2(Vector2.new()) end end) end)
Reg("Check FPS & Ping", "Utility", "Papar status prestasi FPS & Ping", function()
	local fps = math.floor(1 / math.max(RunService.RenderStepped:Wait(), 0.001))
	local ping = 0
	pcall(function() ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
	SetMsg(string.format("FPS: %d | Ping: %d ms", fps, ping))
end)
Reg("Dev Click-Inspect", "Dev", "Klik objek di dunia untuk salin laluan penuh", function() State.DevClickInspect = not State.DevClickInspect if State.DevClickInspect then State.DevClickDelete = false end end)
Reg("Dev Click-Delete", "Dev", "Klik objek di dunia untuk padam secara lokal", function() State.DevClickDelete = not State.DevClickDelete if State.DevClickDelete then State.DevClickInspect = false end end)
Reg("Undo Deleted Part", "Dev", "Kembalikan objek terakhir yang dipadam", function() local item = table.remove(State.DeletedParts) if item and item.part and item.parent then item.part.Parent = item.parent end end)

-- Expose global helper (carian mengikut nama feature)
pcall(function()
	getgenv().ChelseaaSystem = {
		Run = function(q)
			local key = string.lower(tostring(q or ""))
			local it = Lookup[key]
			if not it and key ~= "" then
				for _, entry in ipairs(Registry) do
					if string.find(string.lower(entry.name), key, 1, true) then
						it = entry
						break
					end
				end
			end
			if it then it.run() end
		end,
	}
end)

--// =========================================================================
--// MAIN UI (DELTA TABLET + 16:9 WALLPAPER + SIFAR NOMBOR PADA MENU)
--// =========================================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ChelseaaDeltaV12"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = GuiParent

local OverlayLayer = Instance.new("Folder")
OverlayLayer.Name = "ChelseaaVisualOverlays"
OverlayLayer.Parent = ScreenGui

-- Crosshair Overlay (Tengah Skrin)
local CrosshairFrame = Instance.new("Frame")
CrosshairFrame.Name = "ChelseaaCrosshair"
CrosshairFrame.Size = UDim2.new(0, 20, 0, 20)
CrosshairFrame.Position = UDim2.new(0.5, -10, 0.5, -10)
CrosshairFrame.BackgroundTransparency = 1
CrosshairFrame.Visible = false
CrosshairFrame.ZIndex = 40
CrosshairFrame.Parent = ScreenGui

local chH = Instance.new("Frame", CrosshairFrame)
chH.Size = UDim2.new(0, 16, 0, 2)
chH.Position = UDim2.new(0.5, -8, 0.5, -1)
chH.BackgroundColor3 = Color3.fromRGB(56, 189, 248)
chH.BorderSizePixel = 0

local chV = Instance.new("Frame", CrosshairFrame)
chV.Size = UDim2.new(0, 2, 0, 16)
chV.Position = UDim2.new(0.5, -1, 0.5, -8)
chV.BackgroundColor3 = Color3.fromRGB(56, 189, 248)
chV.BorderSizePixel = 0

-- Live Stats HUD Overlay
local StatsHud = Instance.new("TextLabel")
StatsHud.Name = "ChelseaaStatsHud"
StatsHud.Size = UDim2.new(0, 320, 0, 24)
StatsHud.Position = UDim2.new(0.5, -160, 0, 8)
StatsHud.BackgroundColor3 = Color3.fromRGB(12, 12, 20)
StatsHud.BackgroundTransparency = 0.2
StatsHud.Text = "FPS: -- | Ping: -- ms | Pos: --"
StatsHud.Font = Enum.Font.GothamBold
StatsHud.TextSize = 10
StatsHud.TextColor3 = Color3.fromRGB(56, 189, 248)
StatsHud.Visible = false
StatsHud.ZIndex = 45
StatsHud.Parent = ScreenGui
Instance.new("UICorner", StatsHud).CornerRadius = UDim.new(0, 6)
local shStroke = Instance.new("UIStroke", StatsHud)
shStroke.Color = Color3.fromRGB(220, 38, 68)
shStroke.Thickness = 1

-- Ikon Minimize Petak Berbucu Bulat (Rounded Square, Jelas, Besar)
local Bubble = Instance.new("ImageButton")
Bubble.Name = "ChelseaaMinimizeIcon"
Bubble.Size = UDim2.new(0, 64, 0, 64)
Bubble.Position = UDim2.new(0, 14, 0.5, -32)
Bubble.BackgroundColor3 = Color3.fromRGB(16, 20, 32)
Bubble.BackgroundTransparency = 0
Bubble.ImageTransparency = 0
Bubble.ScaleType = Enum.ScaleType.Crop
Bubble.ClipsDescendants = true
Bubble.Visible = false
Bubble.Active = true
Bubble.Draggable = true
Bubble.ZIndex = 50
Bubble.Parent = ScreenGui
Instance.new("UICorner", Bubble).CornerRadius = UDim.new(0, 14)

local bAspect = Instance.new("UIAspectRatioConstraint")
bAspect.AspectRatio = 1
bAspect.Parent = Bubble

local bStroke = Instance.new("UIStroke", Bubble)
bStroke.Color = Color3.fromRGB(56, 189, 248)
bStroke.Thickness = 1.8

LoadAsyncImage(Bubble, KeyConfig.BubbleIconUrl, "chelseaa_u6aqfz_icon.jpg")

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 592, 0, 336)
Main.Position = UDim2.new(0.5, -296, 0.5, -168)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 16)
Main.BackgroundTransparency = 0.08
Main.ClipsDescendants = true
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
local mStroke = Instance.new("UIStroke", Main)
mStroke.Color = Color3.fromRGB(220, 38, 68)
mStroke.Thickness = 1.5

local MainBgImg = Apply16x9Wallpaper(Main, KeyConfig.WallpaperUrl, 0.72)

local Top = Instance.new("Frame")
Top.Size = UDim2.new(1, -12, 0, 34)
Top.Position = UDim2.new(0, 6, 0, 6)
Top.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
Top.BackgroundTransparency = 0.15
Top.ZIndex = 4
Top.Parent = Main
Instance.new("UICorner", Top).CornerRadius = UDim.new(0, 8)

local TopTitle = Instance.new("TextLabel")
TopTitle.Size = UDim2.new(0, 214, 1, 0)
TopTitle.Position = UDim2.new(0, 10, 0, 0)
TopTitle.BackgroundTransparency = 1
TopTitle.Text = "CHELSEAA SYSTEM"
TopTitle.Font = Enum.Font.GothamBlack
TopTitle.TextSize = 11
TopTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
TopTitle.TextXAlignment = Enum.TextXAlignment.Left
TopTitle.ZIndex = 5
TopTitle.Parent = Top

local AdminBtn = Instance.new("TextButton")
AdminBtn.Size = UDim2.new(0, 88, 0, 24)
AdminBtn.Position = UDim2.new(1, -270, 0.5, -12)
AdminBtn.BackgroundColor3 = Color3.fromRGB(62, 20, 46)
AdminBtn.Text = "ADMIN ONLY"
AdminBtn.Font = Enum.Font.GothamBlack
AdminBtn.TextSize = 9
AdminBtn.TextColor3 = Color3.fromRGB(244, 114, 182)
AdminBtn.ZIndex = 5
AdminBtn.Parent = Top
Instance.new("UICorner", AdminBtn).CornerRadius = UDim.new(0, 6)

local DevBtn = Instance.new("TextButton")
DevBtn.Size = UDim2.new(0, 98, 0, 24)
DevBtn.Position = UDim2.new(1, -176, 0.5, -12)
DevBtn.BackgroundColor3 = Color3.fromRGB(18, 42, 58)
DevBtn.Text = "DEVOLOPER MODE"
DevBtn.Font = Enum.Font.GothamBlack
DevBtn.TextSize = 9
DevBtn.TextColor3 = Color3.fromRGB(56, 189, 248)
DevBtn.ZIndex = 5
DevBtn.Parent = Top
Instance.new("UICorner", DevBtn).CornerRadius = UDim.new(0, 6)

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 30, 0, 24)
MinBtn.Position = UDim2.new(1, -72, 0.5, -12)
MinBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 40)
MinBtn.Text = "-"
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 15
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.ZIndex = 5
MinBtn.Parent = Top
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 6)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 24)
CloseBtn.Position = UDim2.new(1, -36, 0.5, -12)
CloseBtn.BackgroundColor3 = Color3.fromRGB(58, 18, 28)
CloseBtn.Text = "X"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 11
CloseBtn.TextColor3 = Color3.fromRGB(220, 38, 68)
CloseBtn.ZIndex = 5
CloseBtn.Parent = Top
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, -12, 0, 26)
TabBar.Position = UDim2.new(0, 6, 0, 44)
TabBar.BackgroundColor3 = Color3.fromRGB(16, 16, 24)
TabBar.BackgroundTransparency = 0.15
TabBar.ZIndex = 4
TabBar.Parent = Main
Instance.new("UICorner", TabBar).CornerRadius = UDim.new(0, 7)

local Body = Instance.new("ScrollingFrame")
Body.Size = UDim2.new(1, -12, 1, -104)
Body.Position = UDim2.new(0, 6, 0, 74)
Body.BackgroundTransparency = 1
Body.ScrollBarThickness = 3
Body.AutomaticCanvasSize = Enum.AutomaticSize.Y
Body.CanvasSize = UDim2.new(0, 0, 0, 0)
Body.ZIndex = 4
Body.Parent = Main

StatusBar = Instance.new("TextLabel")
StatusBar.Size = UDim2.new(1, -12, 0, 22)
StatusBar.Position = UDim2.new(0, 6, 1, -26)
StatusBar.BackgroundColor3 = Color3.fromRGB(16, 16, 24)
StatusBar.BackgroundTransparency = 0.15
StatusBar.Text = "Status: " .. State.Status
StatusBar.Font = Enum.Font.GothamBold
StatusBar.TextSize = 10
StatusBar.TextColor3 = Color3.fromRGB(56, 189, 248)
StatusBar.ZIndex = 4
StatusBar.Parent = Main
Instance.new("UICorner", StatusBar).CornerRadius = UDim.new(0, 6)

-- UI Theme & Glass Features (didaftarkan selepas Main, mStroke & StatusBar wujud)
Reg("UI Glass Mode", "Theme", "Jadikan menu lutsinar untuk wallpaper", function()
	Main.BackgroundTransparency = 0.35
	if MainBgImg then MainBgImg.ImageTransparency = 0.45 end
end)
Reg("UI Ultra Transparent", "Theme", "Paparkan gambar latar penuh dengan jelas", function()
	Main.BackgroundTransparency = 0.55
	if MainBgImg then MainBgImg.ImageTransparency = 0.25 end
end)
Reg("UI Solid Dark Mode", "Theme", "Kembalikan latar gelap kontras tinggi", function()
	Main.BackgroundTransparency = 0.08
	if MainBgImg then MainBgImg.ImageTransparency = 0.72 end
end)
Reg("Theme: Cyber Cyan", "Theme", "Tukar garisan tema UI kepada biru cyan", function()
	mStroke.Color = Color3.fromRGB(56, 189, 248)
	bStroke.Color = Color3.fromRGB(56, 189, 248)
end)
Reg("Theme: Crimson Rose", "Theme", "Tukar garisan tema UI kepada merah crimson", function()
	mStroke.Color = Color3.fromRGB(220, 38, 68)
	bStroke.Color = Color3.fromRGB(220, 38, 68)
end)
Reg("Theme: Royal Violet", "Theme", "Tukar garisan tema UI kepada ungu diraja", function()
	mStroke.Color = Color3.fromRGB(168, 85, 247)
	bStroke.Color = Color3.fromRGB(168, 85, 247)
end)
Reg("Theme: Emerald Matrix", "Theme", "Tukar garisan tema UI kepada hijau zamrud", function()
	mStroke.Color = Color3.fromRGB(34, 197, 94)
	bStroke.Color = Color3.fromRGB(34, 197, 94)
end)
Reg("Theme: Solar Gold", "Theme", "Tukar garisan tema UI kepada emas terang", function()
	mStroke.Color = Color3.fromRGB(250, 204, 21)
	bStroke.Color = Color3.fromRGB(250, 204, 21)
end)
Reg("Hide Status Bar", "Theme", "Sembunyikan bar status bawah", function()
	StatusBar.Visible = false
	Body.Size = UDim2.new(1, -12, 1, -80)
end)
Reg("Show Status Bar", "Theme", "Paparkan semula bar status bawah", function()
	StatusBar.Visible = true
	Body.Size = UDim2.new(1, -12, 1, -104)
end)

MinBtn.MouseButton1Click:Connect(function()
	Main.Visible = false
	Bubble.Visible = true
end)
Bubble.MouseButton1Click:Connect(function()
	Bubble.Visible = false
	Main.Visible = true
end)
CloseBtn.MouseButton1Click:Connect(function()
	StopTween()
	ClearSpawned()
	ClearVisualOverlays()
	if State.Freecam then SetFreecam(false) end
	if State.TopDownView then SetTopDown(false) end
	if State.HideOthers then SetHideOthers(false) end
	if AirFloorPart then AirFloorPart:Destroy() end
	ScreenGui:Destroy()
end)

local Panels = {}
local TabBtns = {}

local function ShowPanel(name)
	for k, p in pairs(Panels) do p.Visible = (k == name) end
	for k, b in pairs(TabBtns) do
		b.BackgroundColor3 = (k == name) and Color3.fromRGB(220, 38, 68) or Color3.fromRGB(24, 24, 36)
		b.TextColor3 = Color3.fromRGB(255, 255, 255)
	end
	Body.CanvasPosition = Vector2.new(0, 0)
end

local tabDefs = {
	{ id = "Move", label = "Move & Tween" },
	{ id = "Auto", label = "Auto & Combat" },
	{ id = "Visual", label = "Visual & FX" },
	{ id = "AllFeatures", label = "All Features" },
}
for i, td in ipairs(tabDefs) do
	local tb = Instance.new("TextButton")
	tb.Size = UDim2.new(0.242, 0, 0, 20)
	tb.Position = UDim2.new(0.006 + (i - 1) * 0.248, 0, 0.5, -10)
	tb.Font = Enum.Font.GothamBold
	tb.TextSize = 10
	tb.Text = td.label
	tb.ZIndex = 5
	tb.Parent = TabBar
	Instance.new("UICorner", tb).CornerRadius = UDim.new(0, 5)
	TabBtns[td.id] = tb
	tb.MouseButton1Click:Connect(function() ShowPanel(td.id) end)

	local pf = Instance.new("Frame")
	pf.Size = UDim2.new(1, 0, 0, 260)
	pf.BackgroundTransparency = 1
	pf.Visible = (i == 1)
	pf.ZIndex = 5
	pf.Parent = Body
	Panels[td.id] = pf
end

Panels["Admin"] = Instance.new("Frame")
Panels["Admin"].Size = UDim2.new(1, 0, 0, 260)
Panels["Admin"].BackgroundTransparency = 1
Panels["Admin"].Visible = false
Panels["Admin"].ZIndex = 5
Panels["Admin"].Parent = Body

Panels["Dev"] = Instance.new("Frame")
Panels["Dev"].Size = UDim2.new(1, 0, 0, 260)
Panels["Dev"].BackgroundTransparency = 1
Panels["Dev"].Visible = false
Panels["Dev"].ZIndex = 5
Panels["Dev"].Parent = Body

ShowPanel("Move")

local function MakeToggle(parent, x, y, w, h, label, getter, setter)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0, w, 0, h)
	b.Position = UDim2.new(0, x, 0, y)
	b.Font = Enum.Font.GothamBold
	b.TextSize = 10
	b.ZIndex = 6
	b.Parent = parent
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
	local function Ref()
		local v = getter()
		b.BackgroundColor3 = v and Color3.fromRGB(34, 197, 94) or Color3.fromRGB(24, 24, 36)
		b.TextColor3 = v and Color3.fromRGB(10, 10, 14) or Color3.fromRGB(245, 245, 255)
		b.Text = label .. (v and ": ON" or ": OFF")
	end
	Ref()
	b.MouseButton1Click:Connect(function()
		setter(not getter())
		Ref()
	end)
	return b
end

local function MakeAction(parent, x, y, w, h, text, fn, col)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0, w, 0, h)
	b.Position = UDim2.new(0, x, 0, y)
	b.BackgroundColor3 = col or Color3.fromRGB(28, 28, 42)
	b.Text = text
	b.Font = Enum.Font.GothamBold
	b.TextSize = 10
	b.TextColor3 = Color3.fromRGB(255, 255, 255)
	b.ZIndex = 6
	b.Parent = parent
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
	b.MouseButton1Click:Connect(fn)
	return b
end

--// PANEL MOVE & TWEEN
do
	local p = Panels["Move"]
	local wsBox = Instance.new("TextBox")
	wsBox.Size = UDim2.new(0, 84, 0, 28)
	wsBox.Position = UDim2.new(0, 4, 0, 4)
	wsBox.BackgroundColor3 = Color3.fromRGB(22, 22, 34)
	wsBox.Text = tostring(State.WalkSpeed)
	wsBox.Font = Enum.Font.GothamBold
	wsBox.TextSize = 11
	wsBox.TextColor3 = Color3.fromRGB(56, 189, 248)
	wsBox.ZIndex = 6
	wsBox.Parent = p
	Instance.new("UICorner", wsBox).CornerRadius = UDim.new(0, 6)

	MakeAction(p, 92, 4, 86, 28, "SET WS", function()
		local n = tonumber(wsBox.Text)
		if n then
			State.WalkSpeed = math.clamp(n, 1, 5000)
			State.WalkSpeedLock = true
			local h = GetHum() if h then h.WalkSpeed = State.WalkSpeed end
			SetMsg("WalkSpeed: " .. State.WalkSpeed)
		end
	end, Color3.fromRGB(220, 38, 68))

	local jpBox = Instance.new("TextBox")
	jpBox.Size = UDim2.new(0, 84, 0, 28)
	jpBox.Position = UDim2.new(0, 184, 0, 4)
	jpBox.BackgroundColor3 = Color3.fromRGB(22, 22, 34)
	jpBox.Text = tostring(State.JumpPower)
	jpBox.Font = Enum.Font.GothamBold
	jpBox.TextSize = 11
	jpBox.TextColor3 = Color3.fromRGB(56, 189, 248)
	jpBox.ZIndex = 6
	jpBox.Parent = p
	Instance.new("UICorner", jpBox).CornerRadius = UDim.new(0, 6)

	MakeAction(p, 272, 4, 86, 28, "SET JP", function()
		local n = tonumber(jpBox.Text)
		if n then
			State.JumpPower = math.clamp(n, 10, 5000)
			State.JumpPowerLock = true
			local h = GetHum() if h then h.UseJumpPower = true h.JumpPower = State.JumpPower end
			SetMsg("JumpPower: " .. State.JumpPower)
		end
	end, Color3.fromRGB(220, 38, 68))

	local twBox = Instance.new("TextBox")
	twBox.Size = UDim2.new(0, 88, 0, 28)
	twBox.Position = UDim2.new(0, 364, 0, 4)
	twBox.BackgroundColor3 = Color3.fromRGB(22, 22, 34)
	twBox.Text = tostring(State.TweenSpeed)
	twBox.Font = Enum.Font.GothamBold
	twBox.TextSize = 11
	twBox.TextColor3 = Color3.fromRGB(56, 189, 248)
	twBox.ZIndex = 6
	twBox.Parent = p
	Instance.new("UICorner", twBox).CornerRadius = UDim.new(0, 6)

	MakeAction(p, 456, 4, 114, 28, "SET TWEEN SPD", function()
		local n = tonumber(twBox.Text)
		if n then
			State.TweenSpeed = math.clamp(n, 15, 15000)
			SetMsg("Tween Speed: " .. State.TweenSpeed)
		end
	end, Color3.fromRGB(220, 38, 68))

	MakeToggle(p, 4, 38, 140, 28, "Inf Jump", function() return State.InfJump end, function(v) State.InfJump = v SetMsg("Inf Jump: " .. tostring(v)) end)
	MakeToggle(p, 148, 38, 140, 28, "Noclip", function() return State.Noclip end, function(v) State.Noclip = v SetMsg("Noclip: " .. tostring(v)) end)
	MakeToggle(p, 292, 38, 140, 28, "Fly Mode", function() return State.Fly end, function(v) State.Fly = v SetMsg("Fly: " .. tostring(v)) end)
	MakeToggle(p, 436, 38, 134, 28, "Orbit Nearest", function() return State.OrbitPlayer end, function(v) State.OrbitPlayer = v SetMsg("Orbit: " .. tostring(v)) end)

	MakeToggle(p, 4, 72, 140, 28, "Air Walk", function() return State.AirWalk end, function(v) State.AirWalk = v SetMsg("Air Walk: " .. tostring(v)) end)
	MakeToggle(p, 148, 72, 140, 28, "Anti-Fling", function() return State.AntiFling end, function(v) State.AntiFling = v SetMsg("Anti-Fling: " .. tostring(v)) end)
	MakeToggle(p, 292, 72, 140, 28, "Click TP", function() return State.ClickTP end, function(v) State.ClickTP = v SetMsg("Click TP: " .. tostring(v)) end)
	MakeToggle(p, 436, 72, 134, 28, "Sync Tween", function() return State.SyncTweenToWS end, function(v) State.SyncTweenToWS = v SetMsg("Sync Tween: " .. tostring(v)) end)

	MakeAction(p, 4, 106, 140, 28, "Save Waypoint Alpha", function() Lookup["save waypoint alpha"].run() end)
	MakeAction(p, 148, 106, 140, 28, "Tween Waypoint Alpha", function() Lookup["tween waypoint alpha"].run() end)
	MakeAction(p, 292, 106, 140, 28, "Tween Nearest", function() Lookup["tween nearest player"].run() end)
	MakeAction(p, 436, 106, 134, 28, "Stop Tween", function() Lookup["stop active tween"].run() end, Color3.fromRGB(58, 18, 28))

	MakeAction(p, 4, 140, 186, 28, "Tween Sky High", function() Lookup["tween sky high"].run() end)
	MakeAction(p, 194, 140, 186, 28, "TP Nearest Player", function() Lookup["tp nearest player"].run() end)
	MakeAction(p, 384, 140, 186, 28, "Spawn Neon Pad", function() Lookup["spawn neon pad"].run() end)
end

--// PANEL AUTO & COMBAT
do
	local p = Panels["Auto"]
	MakeToggle(p, 4, 4, 186, 28, "Auto Train", function() return State.AutoTrain end, function(v) State.AutoTrain = v SetMsg("Auto Train: " .. tostring(v)) end)
	MakeToggle(p, 194, 4, 186, 28, "Aimbot", function() return State.Aimbot end, function(v) State.Aimbot = v SetMsg("Aimbot: " .. tostring(v)) end)
	MakeToggle(p, 384, 4, 186, 28, "Silent Aim", function() return State.SilentAim end, function(v) State.SilentAim = v SetMsg("Silent Aim: " .. tostring(v)) end)

	MakeToggle(p, 4, 38, 186, 28, "Perfect Timing", function() return State.AutoTiming end, function(v) State.AutoTiming = v SetMsg("Perfect Timing: " .. tostring(v)) end)
	MakeToggle(p, 194, 38, 186, 28, "Tycoon Collect", function() return State.TycoonCollect end, function(v) State.TycoonCollect = v SetMsg("Tycoon Collect: " .. tostring(v)) end)
	MakeToggle(p, 384, 38, 186, 28, "Tycoon Auto-Buy", function() return State.TycoonBuy end, function(v) State.TycoonBuy = v SetMsg("Tycoon Buy: " .. tostring(v)) end)

	MakeToggle(p, 4, 72, 186, 28, "Auto Prompt", function() return State.AutoPrompt end, function(v) State.AutoPrompt = v SetMsg("Auto Prompt: " .. tostring(v)) end)
	MakeToggle(p, 194, 72, 186, 28, "Auto Touch", function() return State.AutoTouch end, function(v) State.AutoTouch = v SetMsg("Auto Touch: " .. tostring(v)) end)
	MakeToggle(p, 384, 72, 186, 28, "Wall Check", function() return State.WallCheck end, function(v) State.WallCheck = v SetMsg("Wall Check: " .. tostring(v)) end)

	local filters = {
		{ "2X_PLUS", "Filter: Standard Plus" },
		{ "ALL", "Filter: All Multipliers" },
		{ "MAX_ONLY", "Filter: High Only" },
		{ "2X_ONLY", "Filter: Medium Only" },
	}
	for i, f in ipairs(filters) do
		MakeAction(p, 4 + (i - 1) * 142, 108, 138, 26, f[2], function()
			State.AutoTrainFilter = f[1]
			SetMsg("Auto Train " .. f[2])
		end)
	end
end

--// PANEL VISUAL & FX
do
	local p = Panels["Visual"]
	MakeToggle(p, 4, 4, 186, 28, "Player ESP", function() return State.ESP end, function(v) SetESP(v) SetMsg("ESP: " .. tostring(v)) end)
	MakeToggle(p, 194, 4, 186, 28, "Tracer Lines", function() return State.Tracers end, function(v) State.Tracers = v SetMsg("Tracers: " .. tostring(v)) end)
	MakeToggle(p, 384, 4, 186, 28, "Nametags", function() return State.Nametags end, function(v) State.Nametags = v SetMsg("Nametags: " .. tostring(v)) end)

	MakeToggle(p, 4, 38, 186, 28, "X-Ray Walls", function() return State.XRay end, function(v) SetXRay(v) SetMsg("X-Ray: " .. tostring(v)) end)
	MakeToggle(p, 194, 38, 186, 28, "Headless", function() return State.Headless end, function(v) SetHeadless(v) SetMsg("Headless: " .. tostring(v)) end)
	MakeToggle(p, 384, 38, 186, 28, "Korblox Leg", function() return State.Korblox end, function(v) SetKorblox(v) SetMsg("Korblox: " .. tostring(v)) end)

	MakeToggle(p, 4, 72, 186, 28, "Freecam Mode", function() return State.Freecam end, function(v) SetFreecam(v) SetMsg("Freecam: " .. tostring(v)) end)
	MakeToggle(p, 194, 72, 186, 28, "Live Stats HUD", function() return State.LiveStats end, function(v) State.LiveStats = v SetMsg("Live Stats HUD: " .. tostring(v)) end)
	MakeToggle(p, 384, 72, 186, 28, "Center Crosshair", function() return State.Crosshair end, function(v) State.Crosshair = v SetMsg("Crosshair: " .. tostring(v)) end)

	MakeAction(p, 4, 106, 186, 28, "Fullbright & NoFog", function() Lookup["fullbright & nofog"].run() end)
	MakeAction(p, 194, 106, 186, 28, "FPS Booster", function() Lookup["fps booster low graphics"].run() end)
	MakeAction(p, 384, 106, 186, 28, "Server Hop", function() Lookup["server hop"].run() end)
end

--// PANEL ALL FEATURES + LIVE SEARCH BAR (SIFAR NOMBOR)
do
	local p = Panels["AllFeatures"]

	local searchBox = Instance.new("TextBox")
	searchBox.Size = UDim2.new(0, 382, 0, 28)
	searchBox.Position = UDim2.new(0, 4, 0, 4)
	searchBox.BackgroundColor3 = Color3.fromRGB(22, 22, 34)
	searchBox.PlaceholderText = "Search feature / kategori (cth: Freecam, Tracer, Theme, Fly)..."
	searchBox.Text = ""
	searchBox.ClearTextOnFocus = false
	searchBox.Font = Enum.Font.GothamBold
	searchBox.TextSize = 10
	searchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	searchBox.ZIndex = 6
	searchBox.Parent = p
	Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0, 6)
	local sbStroke = Instance.new("UIStroke", searchBox)
	sbStroke.Color = Color3.fromRGB(56, 189, 248)
	sbStroke.Thickness = 1

	local statusTag = Instance.new("TextLabel")
	statusTag.Size = UDim2.new(0, 108, 0, 28)
	statusTag.Position = UDim2.new(0, 390, 0, 4)
	statusTag.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
	statusTag.Text = "ALL READY"
	statusTag.Font = Enum.Font.GothamBold
	statusTag.TextSize = 10
	statusTag.TextColor3 = Color3.fromRGB(56, 189, 248)
	statusTag.ZIndex = 6
	statusTag.Parent = p
	Instance.new("UICorner", statusTag).CornerRadius = UDim.new(0, 6)

	local gridFrame = Instance.new("Frame")
	gridFrame.Size = UDim2.new(1, 0, 0, 200)
	gridFrame.Position = UDim2.new(0, 0, 0, 38)
	gridFrame.BackgroundTransparency = 1
	gridFrame.ZIndex = 5
	gridFrame.Parent = p

	local emptyLbl = Instance.new("TextLabel")
	emptyLbl.Size = UDim2.new(1, -8, 0, 40)
	emptyLbl.Position = UDim2.new(0, 4, 0, 6)
	emptyLbl.BackgroundTransparency = 1
	emptyLbl.Text = "Tiada feature sepadan dengan carian tersebut."
	emptyLbl.Font = Enum.Font.GothamBold
	emptyLbl.TextSize = 11
	emptyLbl.TextColor3 = Color3.fromRGB(244, 114, 182)
	emptyLbl.Visible = false
	emptyLbl.ZIndex = 6
	emptyLbl.Parent = gridFrame

	local function RenderFeatures(query)
		for _, child in ipairs(gridFrame:GetChildren()) do
			if child:IsA("TextButton") then
				child:Destroy()
			end
		end

		local q = string.lower(string.gsub(tostring(query or ""), "^%s+", ""))
		q = string.gsub(q, "%s+$", "")

		local matched = {}
		for _, item in ipairs(Registry) do
			if q == ""
				or string.find(string.lower(item.name), q, 1, true)
				or string.find(string.lower(item.cat), q, 1, true)
				or string.find(string.lower(item.desc), q, 1, true)
			then
				table.insert(matched, item)
			end
		end

		statusTag.Text = (#matched == 0) and "NO MATCH" or (q == "" and "ALL READY" or "FILTERED")
		emptyLbl.Visible = (#matched == 0)

		for idx, item in ipairs(matched) do
			local row = math.floor((idx - 1) / 2)
			local col = (idx - 1) % 2
			local label = string.format("[%s] %s", item.cat, item.name)
			MakeAction(gridFrame, 4 + col * 286, row * 32, 282, 28, label, item.run)
		end

		local totalRows = math.max(1, math.ceil(#matched / 2))
		local gridH = totalRows * 32 + 8
		gridFrame.Size = UDim2.new(1, 0, 0, gridH)
		p.Size = UDim2.new(1, 0, 0, gridH + 42)
	end

	MakeAction(p, 502, 4, 68, 28, "CLEAR", function()
		searchBox.Text = ""
		RenderFeatures("")
	end, Color3.fromRGB(58, 18, 28))

	searchBox:GetPropertyChangedSignal("Text"):Connect(function()
		RenderFeatures(searchBox.Text)
	end)

	RenderFeatures("")
end

--// PANEL ADMIN ONLY
do
	local p = Panels["Admin"]
	local hdr = Instance.new("TextLabel")
	hdr.Size = UDim2.new(1, -120, 0, 22)
	hdr.Position = UDim2.new(0, 4, 0, 2)
	hdr.BackgroundTransparency = 1
	hdr.Text = "ADMIN ONLY — FITUR PENTING"
	hdr.Font = Enum.Font.GothamBlack
	hdr.TextSize = 11
	hdr.TextColor3 = Color3.fromRGB(244, 114, 182)
	hdr.TextXAlignment = Enum.TextXAlignment.Left
	hdr.ZIndex = 6
	hdr.Parent = p

	MakeAction(p, 460, 2, 110, 22, "< BACK MOVE", function() ShowPanel("Move") end, Color3.fromRGB(220, 38, 68))

	MakeToggle(p, 4, 28, 186, 28, "Anti-Void Rescue", function() return State.AntiVoid end, function(v) State.AntiVoid = v SetMsg("Anti-Void: " .. tostring(v)) end)
	MakeToggle(p, 194, 28, 186, 28, "Instant Respawn", function() return State.InstantRespawn end, function(v) State.InstantRespawn = v SetMsg("Instant Respawn: " .. tostring(v)) end)
	MakeToggle(p, 384, 28, 186, 28, "ESP All Players", function() return State.ESP end, function(v) SetESP(v) SetMsg("ESP: " .. tostring(v)) end)

	MakeToggle(p, 4, 62, 186, 28, "Auto Touch Collect", function() return State.AutoTouch end, function(v) State.AutoTouch = v SetMsg("Auto Touch: " .. tostring(v)) end)
	MakeToggle(p, 194, 62, 186, 28, "Auto Prompt Spam", function() return State.AutoPrompt end, function(v) State.AutoPrompt = v SetMsg("Auto Prompt: " .. tostring(v)) end)
	MakeToggle(p, 384, 62, 186, 28, "Noclip Walk", function() return State.Noclip end, function(v) State.Noclip = v SetMsg("Noclip: " .. tostring(v)) end)

	MakeAction(p, 4, 96, 186, 28, "Spawn Sky Base", function() Lookup["spawn sky base"].run() end)
	MakeAction(p, 194, 96, 186, 28, "TP Nearest Player", function() Lookup["tp nearest player"].run() end)
	MakeAction(p, 384, 96, 186, 28, "Fullbright & NoFog", function() Lookup["fullbright & nofog"].run() end)

	MakeAction(p, 4, 130, 186, 28, "Server Hop", function() Lookup["server hop"].run() end)
	MakeAction(p, 194, 130, 186, 28, "Rejoin Server", function() Lookup["rejoin server"].run() end)
	MakeAction(p, 384, 130, 186, 28, "Clear Spawned", function() Lookup["clear spawned parts"].run() end)

	local cmdBox = Instance.new("TextBox")
	cmdBox.Size = UDim2.new(0, 448, 0, 28)
	cmdBox.Position = UDim2.new(0, 4, 0, 164)
	cmdBox.BackgroundColor3 = Color3.fromRGB(22, 22, 34)
	cmdBox.PlaceholderText = "Quick Command (taip nama feature, cth: Fly Mode / Freecam Mode)..."
	cmdBox.Text = ""
	cmdBox.ClearTextOnFocus = false
	cmdBox.Font = Enum.Font.GothamBold
	cmdBox.TextSize = 10
	cmdBox.TextColor3 = Color3.fromRGB(244, 114, 182)
	cmdBox.ZIndex = 6
	cmdBox.Parent = p
	Instance.new("UICorner", cmdBox).CornerRadius = UDim.new(0, 6)

	MakeAction(p, 458, 164, 112, 28, "RUN CMD", function()
		local q = string.lower(string.gsub(cmdBox.Text, "^%s+", ""))
		q = string.gsub(q, "%s+$", "")
		local found = Lookup[q]
		if not found and q ~= "" then
			for _, it in ipairs(Registry) do
				if string.find(string.lower(it.name), q, 1, true) then found = it break end
			end
		end
		if found then found.run() else SetMsg("Nama feature tidak ditemukan.") end
	end, Color3.fromRGB(244, 114, 182))
end

--// PANEL DEVOLOPER MODE
do
	local p = Panels["Dev"]
	local hdr = Instance.new("TextLabel")
	hdr.Size = UDim2.new(1, -120, 0, 22)
	hdr.Position = UDim2.new(0, 4, 0, 2)
	hdr.BackgroundTransparency = 1
	hdr.Text = "DEVOLOPER MODE — CHELSEAA"
	hdr.Font = Enum.Font.GothamBlack
	hdr.TextSize = 11
	hdr.TextColor3 = Color3.fromRGB(56, 189, 248)
	hdr.TextXAlignment = Enum.TextXAlignment.Left
	hdr.ZIndex = 6
	hdr.Parent = p

	MakeAction(p, 460, 2, 110, 22, "< BACK MOVE", function() ShowPanel("Move") end, Color3.fromRGB(220, 38, 68))

	local luaBox = Instance.new("TextBox")
	luaBox.Size = UDim2.new(0, 448, 0, 56)
	luaBox.Position = UDim2.new(0, 4, 0, 28)
	luaBox.BackgroundColor3 = Color3.fromRGB(20, 20, 32)
	luaBox.PlaceholderText = "-- Ketik kode Luau lalu tekan RUN LUA..."
	luaBox.Text = ""
	luaBox.MultiLine = true
	luaBox.ClearTextOnFocus = false
	luaBox.Font = Enum.Font.Code
	luaBox.TextSize = 10
	luaBox.TextColor3 = Color3.fromRGB(56, 189, 248)
	luaBox.TextXAlignment = Enum.TextXAlignment.Left
	luaBox.TextYAlignment = Enum.TextYAlignment.Top
	luaBox.ZIndex = 6
	luaBox.Parent = p
	Instance.new("UICorner", luaBox).CornerRadius = UDim.new(0, 6)

	MakeAction(p, 458, 28, 112, 26, "RUN LUA", function()
		if luaBox.Text == "" then return end
		local fn, err = loadstring(luaBox.Text)
		if not fn then SetMsg("Syntax Err: " .. tostring(err)) return end
		task.spawn(function()
			local ok, rErr = pcall(fn)
			SetMsg(ok and "Lua dijalankan!" or ("Run Err: " .. tostring(rErr)))
		end)
	end, Color3.fromRGB(34, 197, 94))

	MakeAction(p, 458, 58, 112, 26, "CLEAR LUA", function()
		luaBox.Text = ""
		SetMsg("Console cleared")
	end)

	MakeToggle(p, 4, 92, 186, 28, "Click-Inspect", function() return State.DevClickInspect end, function(v) State.DevClickInspect = v if v then State.DevClickDelete = false end end)
	MakeToggle(p, 194, 92, 186, 28, "Click-Delete", function() return State.DevClickDelete end, function(v) State.DevClickDelete = v if v then State.DevClickInspect = false end end)
	MakeAction(p, 384, 92, 186, 28, "Undo Deleted", function() Lookup["undo deleted part"].run() end)

	MakeAction(p, 4, 126, 186, 28, "Copy Position", function() Lookup["copy position"].run() end)
	MakeAction(p, 194, 126, 186, 28, "Reset Character", function() Lookup["reset character"].run() end)
	MakeAction(p, 384, 126, 186, 28, "Anti-AFK Bypass", function() Lookup["anti-afk bypass"].run() end)
end

--// GATE KEY KHUSUS ADMIN ONLY
local AdminGate = Instance.new("Frame")
AdminGate.Size = UDim2.new(0, 366, 0, 178)
AdminGate.Position = UDim2.new(0.5, -183, 0.5, -89)
AdminGate.BackgroundColor3 = Color3.fromRGB(16, 16, 26)
AdminGate.Visible = false
AdminGate.ZIndex = 20
AdminGate.Parent = Main
Instance.new("UICorner", AdminGate).CornerRadius = UDim.new(0, 10)
local agStroke = Instance.new("UIStroke", AdminGate)
agStroke.Color = Color3.fromRGB(244, 114, 182)
agStroke.Thickness = 1.6

local agTitle = Instance.new("TextLabel")
agTitle.Size = UDim2.new(1, -16, 0, 22)
agTitle.Position = UDim2.new(0, 8, 0, 8)
agTitle.BackgroundTransparency = 1
agTitle.Text = "ADMIN ONLY — KEY VERIFICATION"
agTitle.Font = Enum.Font.GothamBlack
agTitle.TextSize = 12
agTitle.TextColor3 = Color3.fromRGB(244, 114, 182)
agTitle.ZIndex = 21
agTitle.Parent = AdminGate

local agBox = Instance.new("TextBox")
agBox.Size = UDim2.new(1, -24, 0, 32)
agBox.Position = UDim2.new(0, 12, 0, 36)
agBox.BackgroundColor3 = Color3.fromRGB(26, 26, 40)
agBox.PlaceholderText = "Masukkan admin key..."
agBox.Text = ""
agBox.ClearTextOnFocus = false
agBox.Font = Enum.Font.GothamBold
agBox.TextSize = 12
agBox.TextColor3 = Color3.fromRGB(255, 255, 255)
agBox.ZIndex = 21
agBox.Parent = AdminGate
Instance.new("UICorner", agBox).CornerRadius = UDim.new(0, 6)

local agStatus = Instance.new("TextLabel")
agStatus.Size = UDim2.new(1, -24, 0, 18)
agStatus.Position = UDim2.new(0, 12, 0, 148)
agStatus.BackgroundTransparency = 1
agStatus.Text = "Masukkan admin key untuk membuka panel"
agStatus.Font = Enum.Font.GothamBold
agStatus.TextSize = 10
agStatus.TextColor3 = Color3.fromRGB(56, 189, 248)
agStatus.ZIndex = 21
agStatus.Parent = AdminGate

local agFill = Instance.new("TextButton")
agFill.Size = UDim2.new(0, 164, 0, 26)
agFill.Position = UDim2.new(0, 12, 0, 74)
agFill.BackgroundColor3 = Color3.fromRGB(32, 32, 48)
agFill.Text = "KEY SYSTEM (DISCORD)"
agFill.Font = Enum.Font.GothamBold
agFill.TextSize = 10
agFill.TextColor3 = Color3.fromRGB(56, 189, 248)
agFill.ZIndex = 21
agFill.Parent = AdminGate
Instance.new("UICorner", agFill).CornerRadius = UDim.new(0, 6)
agFill.MouseButton1Click:Connect(function()
	SafeCopy(KeyConfig.DiscordInvite)
	agStatus.TextColor3 = Color3.fromRGB(56, 189, 248)
	agStatus.Text = "Link Discord disalin: " .. KeyConfig.DiscordInvite
end)

local agOk = Instance.new("TextButton")
agOk.Size = UDim2.new(0, 164, 0, 30)
agOk.Position = UDim2.new(0, 12, 0, 108)
agOk.BackgroundColor3 = Color3.fromRGB(244, 114, 182)
agOk.Text = "BUKA ADMIN ONLY"
agOk.Font = Enum.Font.GothamBlack
agOk.TextSize = 10
agOk.TextColor3 = Color3.fromRGB(10, 10, 16)
agOk.ZIndex = 21
agOk.Parent = AdminGate
Instance.new("UICorner", agOk).CornerRadius = UDim.new(0, 6)

local agCancel = Instance.new("TextButton")
agCancel.Size = UDim2.new(0, 168, 0, 30)
agCancel.Position = UDim2.new(1, -180, 0, 108)
agCancel.BackgroundColor3 = Color3.fromRGB(32, 32, 48)
agCancel.Text = "BATAL"
agCancel.Font = Enum.Font.GothamBold
agCancel.TextSize = 10
agCancel.TextColor3 = Color3.fromRGB(255, 255, 255)
agCancel.ZIndex = 21
agCancel.Parent = AdminGate
Instance.new("UICorner", agCancel).CornerRadius = UDim.new(0, 6)
agCancel.MouseButton1Click:Connect(function()
	AdminGate.Visible = false
end)

agOk.MouseButton1Click:Connect(function()
	local k = NormKey(agBox.Text)
	if KeyConfig.AdminKeys[k] then
		State.AdminUnlocked = true
		AdminGate.Visible = false
		ShowPanel("Admin")
		SetMsg("ADMIN ONLY aktif")
	else
		agStatus.TextColor3 = Color3.fromRGB(244, 63, 94)
		agStatus.Text = "Admin key tidak sah!"
	end
end)

AdminBtn.MouseButton1Click:Connect(function()
	if State.AdminUnlocked then
		ShowPanel("Admin")
		SetMsg("ADMIN ONLY aktif")
	else
		AdminGate.Visible = true
	end
end)

DevBtn.MouseButton1Click:Connect(function()
	AdminGate.Visible = false
	ShowPanel("Dev")
	SetMsg("DEVOLOPER MODE aktif")
end)

--// LOOP & EVENT RUNTIME
local Mouse = LocalPlayer:GetMouse()
Mouse.Button1Down:Connect(function()
	if State.ClickTP and Mouse.Hit then
		local r = GetRoot()
		if r then
			r.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3.5, 0))
		end
	end
	if not State.DevClickInspect and not State.DevClickDelete then return end
	local t = Mouse.Target
	if not t or t:IsDescendantOf(GetChar() or Instance.new("Folder")) then return end
	if State.DevClickInspect then
		SafeCopy(t:GetFullName())
		SetMsg("Inspect: " .. t.Name .. " (" .. t.ClassName .. ")")
	elseif State.DevClickDelete and t:IsA("BasePart") then
		table.insert(State.DeletedParts, { part = t, parent = t.Parent })
		t.Parent = nil
		SetMsg("Deleted: " .. t.Name)
	end
end)

UserInputService.JumpRequest:Connect(function()
	if State.InfJump then
		local h = GetHum() if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
	end
end)

LocalPlayer.CharacterAdded:Connect(function(char)
	local h = char:WaitForChild("Humanoid", 5)
	if h then
		if State.WalkSpeedLock then h.WalkSpeed = State.WalkSpeed end
		if State.JumpPowerLock then h.UseJumpPower = true h.JumpPower = State.JumpPower end
		if State.NoRagdoll then SetNoRagdoll(true) end
		h.Died:Connect(function()
			if State.InstantRespawn then
				task.delay(0.2, function() pcall(function() LocalPlayer:LoadCharacter() end) end)
			end
		end)
	end
	task.delay(0.15, function()
		if State.Headless then SetHeadless(true) end
		if State.Korblox then SetKorblox(true) end
	end)
end)

Players.PlayerRemoving:Connect(function(plr)
	if TracerLines[plr] then
		TracerLines[plr]:Destroy()
		TracerLines[plr] = nil
	end
	if NametagGuis[plr] then
		NametagGuis[plr]:Destroy()
		NametagGuis[plr] = nil
	end
end)

RunService.RenderStepped:Connect(function(dt)
	local cam = Workspace.CurrentCamera
	local r = GetRoot()

	if State.Freecam and cam then
		local h = GetHum()
		local rot = cam.CFrame - cam.CFrame.Position
		if h and h.MoveDirection.Magnitude > 0 then
			local flatLook = Vector3.new(cam.CFrame.LookVector.X, 0, cam.CFrame.LookVector.Z)
			local flatRight = Vector3.new(cam.CFrame.RightVector.X, 0, cam.CFrame.RightVector.Z)
			local fwd = flatLook.Magnitude > 0.01 and flatLook.Unit or Vector3.new(0, 0, -1)
			local rgt = flatRight.Magnitude > 0.01 and flatRight.Unit or Vector3.new(1, 0, 0)
			local forwardInput = -h.MoveDirection:Dot(fwd)
			local rightInput = h.MoveDirection:Dot(rgt)
			local moveVec = (cam.CFrame.LookVector * -forwardInput) + (cam.CFrame.RightVector * rightInput)
			State.FreecamPos = State.FreecamPos + moveVec * (State.FlySpeed * dt)
		end
		cam.CFrame = rot + State.FreecamPos
	elseif State.TopDownView and cam and r then
		local topPos = r.Position + Vector3.new(0, 55, 2)
		cam.CFrame = CFrame.lookAt(topPos, r.Position)
	elseif State.Aimbot then
		local pt = GetClosestTarget(State.AimbotPart)
		if pt and cam then
			cam.CFrame = cam.CFrame:Lerp(CFrame.lookAt(cam.CFrame.Position, pt.Position), State.AimbotSmoothness)
		end
	end

	-- Update Tracer Lines & Distance Nametags
	if cam then
		local origin = Vector2.new(cam.ViewportSize.X * 0.5, cam.ViewportSize.Y * 0.5)
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= LocalPlayer then
				local pc = p.Character
				local phrp = pc and pc:FindFirstChild("HumanoidRootPart")
				local phead = pc and pc:FindFirstChild("Head")

				-- Tracer
				if State.Tracers and phrp then
					local ln = TracerLines[p]
					if not ln then
						ln = Instance.new("Frame")
						ln.AnchorPoint = Vector2.new(0.5, 0.5)
						ln.BackgroundColor3 = Color3.fromRGB(56, 189, 248)
						ln.BorderSizePixel = 0
						ln.ZIndex = 10
						ln.Parent = OverlayLayer
						TracerLines[p] = ln
					end
					local sp, onScr = cam:WorldToViewportPoint(phrp.Position)
					if onScr and sp.Z > 0 then
						local targetPt = Vector2.new(sp.X, sp.Y)
						local diff = targetPt - origin
						local mid = origin + diff * 0.5
						ln.Position = UDim2.fromOffset(mid.X, mid.Y)
						ln.Size = UDim2.fromOffset(diff.Magnitude, 1.5)
						ln.Rotation = math.deg(math.atan2(diff.Y, diff.X))
						ln.Visible = true
					else
						ln.Visible = false
					end
				elseif TracerLines[p] then
					TracerLines[p].Visible = false
				end

				-- Distance Nametag
				if State.Nametags and phead and phrp then
					local bb = NametagGuis[p]
					if not bb then
						bb = Instance.new("BillboardGui")
						bb.Size = UDim2.new(0, 140, 0, 26)
						bb.StudsOffset = Vector3.new(0, 2.6, 0)
						bb.AlwaysOnTop = true
						bb.Parent = OverlayLayer
						local tl = Instance.new("TextLabel", bb)
						tl.Name = "TagLbl"
						tl.Size = UDim2.new(1, 0, 1, 0)
						tl.BackgroundTransparency = 1
						tl.Font = Enum.Font.GothamBold
						tl.TextSize = 11
						tl.TextColor3 = Color3.fromRGB(244, 114, 182)
						tl.TextStrokeTransparency = 0.3
						NametagGuis[p] = bb
					end
					bb.Adornee = phead
					bb.Enabled = true
					local dist = r and math.floor((phrp.Position - r.Position).Magnitude) or 0
					bb.TagLbl.Text = string.format("%s [%d]", p.Name, dist)
				elseif NametagGuis[p] then
					NametagGuis[p].Enabled = false
				end
			end
		end
	end
end)

RunService.Heartbeat:Connect(function(dt)
	local c = GetChar()
	local h = GetHum()
	local r = GetRoot()
	local cam = Workspace.CurrentCamera

	CrosshairFrame.Visible = State.Crosshair
	StatsHud.Visible = State.LiveStats
	if State.LiveStats and (os.clock() - LastStatsTick) >= 0.25 then
		LastStatsTick = os.clock()
		local fps = math.floor(1 / math.max(dt, 0.001))
		local ping = 0
		pcall(function() ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
		local posStr = r and string.format("%.0f, %.0f, %.0f", r.Position.X, r.Position.Y, r.Position.Z) or "0, 0, 0"
		StatsHud.Text = string.format("FPS: %d | Ping: %d ms | Pos: %s", fps, ping, posStr)
	end

	if h then
		if State.WalkSpeedLock and h.WalkSpeed ~= State.WalkSpeed then h.WalkSpeed = State.WalkSpeed end
		if State.JumpPowerLock then h.UseJumpPower = true if h.JumpPower ~= State.JumpPower then h.JumpPower = State.JumpPower end end
		if State.SwimInAir then h:ChangeState(Enum.HumanoidStateType.Swimming) end
		if State.BunnyHop and h.MoveDirection.Magnitude > 0 and h.FloorMaterial ~= Enum.Material.Air then
			h:ChangeState(Enum.HumanoidStateType.Jumping)
		end
		if State.MoonWalk and r and h.MoveDirection.Magnitude > 0.05 then
			h.AutoRotate = false
			local backDir = -Vector3.new(h.MoveDirection.X, 0, h.MoveDirection.Z)
			if backDir.Magnitude > 0.01 then
				r.CFrame = CFrame.lookAt(r.Position, r.Position + backDir)
			end
		elseif State.ShiftLockHelper and r and cam then
			h.AutoRotate = false
			local look = Vector3.new(cam.CFrame.LookVector.X, 0, cam.CFrame.LookVector.Z)
			if look.Magnitude > 0.01 then
				r.CFrame = CFrame.lookAt(r.Position, r.Position + look)
			end
		else
			h.AutoRotate = true
		end
	end

	if State.SpinMode and r then
		r.CFrame = r.CFrame * CFrame.Angles(0, math.rad(18), 0)
	end

	if State.Noclip and c then
		for _, pt in ipairs(c:GetDescendants()) do
			if pt:IsA("BasePart") and pt.CanCollide then pt.CanCollide = false end
		end
	end

	if State.Fly and r and h and not State.Freecam then
		if cam then
			r.AssemblyLinearVelocity = (h.MoveDirection.Magnitude > 0) and (cam.CFrame.LookVector * h.MoveDirection.Magnitude * State.FlySpeed) or Vector3.zero
		end
	end

	if State.SpiderClimb and r and h and h.MoveDirection.Magnitude > 0 then
		local rp = RaycastParams.new()
		rp.FilterType = Enum.RaycastFilterType.Exclude
		rp.FilterDescendantsInstances = { c }
		if Workspace:Raycast(r.Position, h.MoveDirection * 2.5, rp) then
			r.AssemblyLinearVelocity = Vector3.new(r.AssemblyLinearVelocity.X, 34, r.AssemblyLinearVelocity.Z)
		end
	end

	if State.OrbitPlayer and r then
		local nr = FindNearestRoot()
		if nr then
			State.OrbitAngle = (State.OrbitAngle + dt * 3.2) % (math.pi * 2)
			local off = Vector3.new(math.cos(State.OrbitAngle) * 7, 0, math.sin(State.OrbitAngle) * 7)
			r.CFrame = CFrame.lookAt(nr.Position + off, nr.Position)
		end
	end

	if State.AntiFling and r then
		if r.AssemblyLinearVelocity.Magnitude > 180 then r.AssemblyLinearVelocity = Vector3.zero end
		if r.AssemblyAngularVelocity.Magnitude > 50 then r.AssemblyAngularVelocity = Vector3.zero end
	end

	if State.AntiVoid and r and r.Position.Y < -50 then
		r.AssemblyLinearVelocity = Vector3.zero
		r.CFrame = CFrame.new(0, 80, 0)
		SetMsg("Anti-Void menyelamatkan karakter!")
	end

	if State.AirWalk and r then
		if not AirFloorPart or not AirFloorPart.Parent then
			AirFloorPart = Instance.new("Part")
			AirFloorPart.Size = Vector3.new(12, 1, 12)
			AirFloorPart.Anchored = true
			AirFloorPart.Transparency = 1
			AirFloorPart.Parent = Workspace
		end
		AirFloorPart.CFrame = CFrame.new(r.Position.X, r.Position.Y - 3.5, r.Position.Z)
	elseif AirFloorPart then
		AirFloorPart:Destroy()
		AirFloorPart = nil
	end

	if State.RainbowBody and c then
		RainbowHue = (RainbowHue + dt * 0.35) % 1
		local col = Color3.fromHSV(RainbowHue, 0.85, 1)
		for _, pt in ipairs(c:GetDescendants()) do if pt:IsA("BasePart") then pt.Color = col end end
	end

	if State.AutoTrain then StepAutoTrain() end

	if State.AutoTiming and r and (os.clock() - State.LastTimingTick) >= State.TimingCooldown then
		for _, obj in ipairs(Workspace:GetDescendants()) do
			if obj:IsA("BasePart") and not obj.Anchored and not obj:IsDescendantOf(c or Instance.new("Folder")) then
				if (obj.Position - r.Position).Magnitude <= State.TimingDist and obj.AssemblyLinearVelocity.Magnitude > 8 then
					State.LastTimingTick = os.clock()
					local vp = cam and cam.ViewportSize or Vector2.new(500, 500)
					TapScreen(vp.X * 0.5, vp.Y * 0.5, nil)
					break
				end
			end
		end
	end

	if State.AutoPrompt and r and (os.clock() - LastPromptTick) > 0.25 and type(fireproximityprompt) == "function" then
		LastPromptTick = os.clock()
		for _, obj in ipairs(Workspace:GetDescendants()) do
			if obj:IsA("ProximityPrompt") and obj.Enabled then
				local pp = obj.Parent and (obj.Parent:IsA("BasePart") and obj.Parent or obj.Parent:FindFirstChildWhichIsA("BasePart"))
				if pp and (pp.Position - r.Position).Magnitude <= (obj.MaxActivationDistance + 8) then
					pcall(fireproximityprompt, obj)
				end
			end
		end
	end

	if State.AutoTouch and r and (os.clock() - LastTouchTick) > 0.3 and type(firetouchinterest) == "function" then
		LastTouchTick = os.clock()
		for _, obj in ipairs(Workspace:GetDescendants()) do
			if obj:IsA("TouchTransmitter") and obj.Parent and obj.Parent:IsA("BasePart") then
				if (obj.Parent.Position - r.Position).Magnitude <= 35 then
					pcall(firetouchinterest, r, obj.Parent, 0)
					pcall(firetouchinterest, r, obj.Parent, 1)
				end
			end
		end
	end
end)

SetMsg("CHELSEAA SYSTEM Ready — All Features Active")
