--!strict
-- Client bootstrap — controls the full join flow:
--   1. Debug overlay shows immediately (proves this script is running)
--   2. LoadingScreen shows + ContentProvider preloads all assets (5s hard cap)
--   3. LoadingScreen hides
--   4. RNG character creation shows (if firstSpawn)
--   5. Player confirms → spawns in Candy Kingdom → all other systems init
--
-- Lives in StarterPlayerScripts.Core.Bootstrap

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- ---------------------------------------------------------------------------
-- Debug overlay — created BEFORE any require so a broken module can never
-- leave the player staring at a blank screen. Green = running, red = error.
-- ---------------------------------------------------------------------------
local debugLabel: TextLabel? = nil
do
	local ok, err = pcall(function()
		local gui = Instance.new("ScreenGui")
		gui.Name = "BootstrapDebug"
		gui.ResetOnSpawn = false
		gui.DisplayOrder = 1000 -- above everything, including LoadingScreen

		local label = Instance.new("TextLabel")
		label.Name = "Status"
		label.Size = UDim2.new(0, 360, 0, 24)
		label.Position = UDim2.new(0, 8, 0, 8)
		label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		label.BackgroundTransparency = 0.3
		label.BorderSizePixel = 0
		label.Font = Enum.Font.Code
		label.TextSize = 14
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.TextColor3 = Color3.fromRGB(80, 255, 80)
		label.Text = "CLIENT BOOTSTRAP RUNNING"
		label.Parent = gui

		gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui", 10)
		debugLabel = label
	end)
	if not ok then
		warn("[Client Bootstrap] debug overlay failed: " .. tostring(err))
	end
end

local function setDebug(text: string, isError: boolean?)
	if debugLabel then
		debugLabel.Text = "BOOTSTRAP: " .. text
		debugLabel.TextColor3 = if isError then Color3.fromRGB(255, 80, 80) else Color3.fromRGB(80, 255, 80)
	end
	print("[Client Bootstrap] " .. text)
end

-- ---------------------------------------------------------------------------
-- Loading screen (pcall'd — a broken LoadingScreen must not kill the client)
-- ---------------------------------------------------------------------------
local LoadingScreen: any = nil
do
	local ok, result = pcall(function()
		return require(script.Parent.Parent:WaitForChild("UI"):WaitForChild("LoadingScreen"))
	end)
	if ok then
		LoadingScreen = result
	else
		warn("[Client Bootstrap] LoadingScreen require failed: " .. tostring(result))
		setDebug("LoadingScreen module failed — continuing without it", true)
	end
end

local function safeShowLoading()
	if LoadingScreen then
		pcall(function()
			-- Build with the default Figma variant before first show
			if type(LoadingScreen.Init) == "function" then
				LoadingScreen.Init("B")
			end
			LoadingScreen.Show()
		end)
	end
end

local function safeHideLoading()
	if LoadingScreen then
		pcall(function()
			LoadingScreen.Hide()
		end)
	end
end

-- ---------------------------------------------------------------------------
-- System loading
-- ---------------------------------------------------------------------------
local SYSTEMS = {
	"Input",
	"Camera",
	"Combat",
	"HUD",
	"UI",
	"Interaction",
}

local systemsLoaded = false

local function loadSystems()
	if systemsLoaded then
		return
	end
	systemsLoaded = true

	-- Systems are siblings of Core (which holds this Bootstrap), so look in script.Parent.Parent (StarterPlayerScripts)
	for _, name in ipairs(SYSTEMS) do
		local systemScript = script.Parent.Parent:FindFirstChild(name)
		if not systemScript then
			warn(("[Client Bootstrap] system folder missing: %s"):format(name))
			setDebug(name .. " MISSING", true)
			continue
		end

		-- With Rojo, a folder containing init.luau syncs AS a ModuleScript (the folder
		-- itself is the module). Fall back to a child Init only if it stayed a Folder.
		local initModule: Instance?
		if systemScript:IsA("ModuleScript") then
			initModule = systemScript
		else
			initModule = systemScript:FindFirstChild("init") or systemScript:FindFirstChild("Init")
		end
		if not initModule then
			warn(("[Client Bootstrap] %s missing init module"):format(name))
			setDebug(name .. " missing init", true)
			continue
		end

		local ok, result = pcall(function()
			return require(initModule :: ModuleScript)
		end)
		if not ok then
			warn(("[Client Bootstrap] %s require error: %s"):format(name, tostring(result)))
			setDebug(name .. " REQUIRE FAILED", true)
			continue
		end

		if type(result) == "table" and type(result.Init) == "function" then
			local initOk, initErr = pcall(function()
				result:Init()
			end)
			if not initOk then
				warn(("[Client Bootstrap] %s Init error: %s"):format(name, tostring(initErr)))
				setDebug(name .. " INIT FAILED", true)
				continue
			end
			print(("[Client Bootstrap] %s initialized"):format(name))
		end
	end

	setDebug("READY — all systems loaded")
end

-- ---------------------------------------------------------------------------
-- Main flow: preload (5s hard cap) → request data → load systems
-- ---------------------------------------------------------------------------
local function main()
	setDebug("starting...")
	safeShowLoading()

	-- Hard timeout: whatever happens, the loading screen can never block for
	-- more than 5 seconds. After that we force-hide it and load everything.
	local preloadFinished = false
	local function finishPreload()
		if preloadFinished then
			return
		end
		preloadFinished = true
		safeHideLoading()
		setDebug("preload done")

		-- Failsafe: if server doesn't respond in 10s, load systems anyway
		local serverResponded = false
		task.delay(10, function()
			if not serverResponded then
				warn("[Client Bootstrap] server didn't respond in 10s — loading systems anyway")
				loadSystems()
			end
		end)

		-- Check if we're already past character creation (returning player).
		-- First spawn → RNG screen shows via UI Init once systems are loaded.
		local requestFn = ReplicatedStorage:FindFirstChild("RequestPlayerData")
		if requestFn and requestFn:IsA("RemoteFunction") then
			task.spawn(function()
				local ok, result = pcall(function()
					return requestFn:InvokeServer()
				end)
				serverResponded = true
				if not ok then
					warn("[Client Bootstrap] RequestPlayerData failed: " .. tostring(result))
				end
				loadSystems()
			end)
		else
			serverResponded = true
			loadSystems()
		end
	end

	task.delay(5, function()
		if not preloadFinished then
			warn("[Client Bootstrap] loading screen timed out after 5s — forcing through")
			finishPreload()
		end
	end)

	if LoadingScreen then
		local ok, err = pcall(function()
			LoadingScreen.PreloadAll(finishPreload)
		end)
		if not ok then
			warn("[Client Bootstrap] PreloadAll error: " .. tostring(err))
			finishPreload()
		end
	else
		finishPreload()
	end
end

main()
