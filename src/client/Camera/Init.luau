--!strict
-- Camera system — default fixed behind player, opt-in lock-on.
-- Lives in StarterPlayerScripts.Client.Camera.Init
--
-- Design (per COMBAT_DOC §10):
--   * Default: fixed camera behind player (Adventure Time show style)
--   * Opt-in: lock-on (C key) — soft lock to nearest enemy
--   * FOV zoom: scroll wheel
--   * Hero Mode: slight FOV widen

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

local Camera = {}

local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera
local lockOn = false
local lockOnTarget: Model? = nil

-- Default camera settings (fixed behind player)
local DEFAULT_OFFSET = Vector3.new(0, 8, -12)
local ZOOM_MIN = 5
local ZOOM_MAX = 30
local currentZoom = 12

-- Find nearest enemy (placeholder — real enemy detection later)
local function findNearestEnemy(): Model?
	local char = player.Character
	if not char or not char.PrimaryPart then
		return nil
	end
	-- Placeholder: look for any Model with "IsEnemy" attribute (set by Spawns later)
	for _, obj in ipairs(Workspace:GetChildren()) do
		if obj:IsA("Model") and obj:GetAttribute("IsEnemy") and obj.PrimaryPart then
			return obj
		end
	end
	return nil
end

-- Toggle lock-on
local function toggleLockOn()
	lockOn = not lockOn
	if lockOn then
		lockOnTarget = findNearestEnemy()
		if not lockOnTarget then
			lockOn = false
			print("[Camera] no enemy to lock on")
		end
	else
		lockOnTarget = nil
	end
end

-- Camera update loop
local function updateCamera()
	if not camera then
		camera = Workspace.CurrentCamera
		if not camera then
			return
		end
	end

	local char = player.Character
	if not char or not char.PrimaryPart then
		return
	end

	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then
		return
	end

	if lockOn and lockOnTarget and lockOnTarget.PrimaryPart then
		-- Lock-on: look at target
		local targetPos = lockOnTarget.PrimaryPart.Position
		local camPos = hrp.Position + (hrp.CFrame.LookVector * -currentZoom) + Vector3.new(0, 5, 0)
		camera.CFrame = CFrame.lookAt(camPos, targetPos)
	else
		-- Fixed behind player
		local lookVector = hrp.CFrame.LookVector
		local camPos = hrp.Position - (lookVector * currentZoom) + Vector3.new(0, DEFAULT_OFFSET.Y, 0)
		camera.CFrame = CFrame.lookAt(camPos, hrp.Position)
	end
end

-- Handle scroll wheel zoom
local function onScroll(input: InputObject, processed: boolean)
	if processed then
		return
	end
	if input.UserInputType == Enum.UserInputType.MouseWheel then
		currentZoom = math.clamp(currentZoom - input.Position.Z * 2, ZOOM_MIN, ZOOM_MAX)
	end
end

-- Handle C key for lock-on
local function onKey(input: InputObject, processed: boolean)
	if processed then
		return
	end
	if input.KeyCode == Enum.KeyCode.C then
		toggleLockOn()
	end
end

function Camera.Init()
	-- Wait for character
	player.CharacterAdded:Connect(function()
		task.wait(0.1)
		-- Set camera type to Scriptable so we control it
		if camera then
			camera.CameraType = Enum.CameraType.Scriptable
		end
	end)

	-- If character already exists, set camera now
	if player.Character then
		camera = Workspace.CurrentCamera
		if camera then
			camera.CameraType = Enum.CameraType.Scriptable
		end
	end

	-- Scroll zoom
	UserInputService.InputChanged:Connect(onScroll)

	-- Lock-on key
	UserInputService.InputBegan:Connect(onKey)

	-- Update loop
	task.spawn(function()
		while true do
			updateCamera()
			task.wait(0.01)
		end
	end)

	print("[Camera] initialized (default fixed, C to lock-on, scroll to zoom)")
end

return Camera
