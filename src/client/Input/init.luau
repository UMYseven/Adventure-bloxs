--!strict
-- Input system — keyboard/mouse + touch controls for combat + movement.
-- Lives in StarterPlayerScripts.Client.Input.Init
--
-- Sends combat intents to server via ClientToServer.
-- Default scheme (locked, COMBAT_DOC §2.1):
--   LMB / RT  = Light attack
--   RMB / LT  = Heavy attack
--   Space / A = Dodge
--   Shift    = Block (hold)
--   Q        = Parry
--   E / R     = Ability 1 / 2 (beta has 2 slots)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local Input = {}

local c2s
local lastDodge = 0
local lastParry = 0
local blocking = false

local function fire(action: string, payload: any?)
	if c2s and c2s:IsA("RemoteEvent") then
		c2s:FireServer(action, payload)
	end
end

local function onKey(input: Enum.KeyCode, processed: boolean)
	if processed then
		return
	end
	if input == Enum.KeyCode.Space then
		if os.clock() - lastDodge >= 0.3 then
			lastDodge = os.clock()
			fire("Dodge")
		end
	elseif input == Enum.KeyCode.Q then
		if os.clock() - lastParry >= 0.5 then
			lastParry = os.clock()
			fire("Parry")
		end
	elseif input == Enum.KeyCode.E then
		fire("Ability", { slot = 1 })
	elseif input == Enum.KeyCode.R then
		fire("Ability", { slot = 2 })
	end
end

local function onMouseButton(input: Enum.UserInputType, processed: boolean)
	if processed then
		return
	end
	if input == Enum.UserInputType.MouseButton1 then
		fire("LightAttack")
	elseif input == Enum.UserInputType.MouseButton2 then
		fire("HeavyAttack")
	end
end

function Input.Init()
	c2s = ReplicatedStorage:WaitForChild("ClientToServer")

	UserInputService.InputBegan:Connect(function(i: InputObject, processed: boolean)
		if i.UserInputType == Enum.UserInputType.Keyboard then
			onKey(i.KeyCode, processed)
		elseif i.UserInputType == Enum.UserInputType.MouseButton1
			or i.UserInputType == Enum.UserInputType.MouseButton2 then
			onMouseButton(i.UserInputType, processed)
		end
	end)

	-- Block hold (Shift)
	UserInputService.InputBegan:Connect(function(i: InputObject, processed: boolean)
		if not processed and i.KeyCode == Enum.KeyCode.LeftShift then
			blocking = true
			fire("BlockStart")
		end
	end)
	UserInputService.InputEnded:Connect(function(i: InputObject, _processed: boolean)
		if i.KeyCode == Enum.KeyCode.LeftShift and blocking then
			blocking = false
			fire("BlockStop")
		end
	end)

	print("[Input] initialized")
end

return Input
