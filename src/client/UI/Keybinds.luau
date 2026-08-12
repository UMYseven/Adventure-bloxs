--!strict
-- Keybinds — UI key bindings (M = map, I = inventory, J = quest log, K = talent tree, Esc = pause, F = settings).
-- Lives in StarterPlayerScripts.Client.UI.Keybinds
--
-- Combat keys (LMB/RMB/Space/Shift/Q/E/R) are handled in Input/Init, NOT here.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local Keybinds = {}

function Keybinds.Init()
	local openEvent = ReplicatedStorage:FindFirstChild("OpenUIScreen")
	if not openEvent or not openEvent:IsA("BindableEvent") then
		-- Create it if missing (UI Init also creates it, but defensive)
		local ev = Instance.new("BindableEvent")
		ev.Name = "OpenUIScreen"
		ev.Parent = ReplicatedStorage
		openEvent = ev
	end

	UserInputService.InputBegan:Connect(function(i: InputObject, processed: boolean)
		if processed then
			return
		end
		if i.UserInputType ~= Enum.UserInputType.Keyboard then
			return
		end

		local key = i.KeyCode
		if key == Enum.KeyCode.M then
			openEvent:Fire("Map")
		elseif key == Enum.KeyCode.I then
			openEvent:Fire("Inventory")
		elseif key == Enum.KeyCode.J then
			openEvent:Fire("QuestLog")
		elseif key == Enum.KeyCode.F then
			openEvent:Fire("Settings")
		elseif key == Enum.KeyCode.K then
			openEvent:Fire("TalentTree")
		elseif key == Enum.KeyCode.P then
			openEvent:Fire("Founder")
		end
	end)

	print("[Keybinds] initialized — M=Map, I=Inventory, J=QuestLog, F=Settings, K=Talents, P=Founder, Esc=Pause")
end

return Keybinds
