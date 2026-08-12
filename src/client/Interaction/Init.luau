--!strict
-- Interaction system — environmental interaction: push, break, climb, hide, eat.
-- Lives in StarterPlayerScripts.Client.Interaction.Init
--
-- Design (per MVP_BETA_SCOPE §Emergent Systems):
--   * E key near interactable objects (candy people, props, NPCs)
--   * Proximity prompt shows "Eat" / "Push" / "Break" / "Climb" / "Hide" / "Talk"
--   * Candy people can be eaten (fires EatCandyPerson to server)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local Interaction = {}

local player = Players.LocalPlayer

-- Object types and their actions
local OBJECT_ACTIONS = {
	CandyPerson = { label = "Eat", action = "EatCandyPerson" },
	Crate = { label = "Push", action = "PushObject" },
	Barrel = { label = "Break", action = "BreakObject" },
	Tree = { label = "Climb", action = "ClimbObject" },
	HideSpot = { label = "Hide", action = "HideInObject" },
	NPC = { label = "Talk", action = "TalkToNPC" },
	SaveTerminal = { label = "Save", action = "UseSaveTerminal" },
	Shrine = { label = "Fast Travel", action = "UseShrine" },
	DungeonEntrance = { label = "Enter", action = "EnterDungeon" },
}

-- Create a ProximityPrompt on an object
local function addPrompt(part: BasePart, objectType: string, actionId: string)
	local prompt = Instance.new("ProximityPrompt")
	prompt.Name = "InteractionPrompt"
	prompt.ObjectText = objectType
	prompt.ActionText = OBJECT_ACTIONS[objectType] and OBJECT_ACTIONS[objectType].label or "Interact"
	prompt.HoldDuration = 0.5
	prompt.MaxActivationDistance = 10
	prompt.Parent = part

	prompt.Triggered:Connect(function(playerWhoTriggered: Player)
		if playerWhoTriggered ~= player then
			return
		end
		local c2s = ReplicatedStorage:FindFirstChild("ClientToServer")
		if c2s and c2s:IsA("RemoteEvent") then
			c2s:FireServer(actionId, { targetPosition = part.Position })
		end
	end)
end

-- Scan workspace for interactable objects and add prompts
local function scanForInteractables()
	-- Candy people (placeholder — real models tagged with "IsCandyPerson" attribute)
	for _, obj in ipairs(Workspace:GetDescendants()) do
		if obj:IsA("BasePart") then
			local parent = obj:FindFirstAncestorOfClass("Model")
			if parent then
				if parent:GetAttribute("IsCandyPerson") then
					addPrompt(obj, "CandyPerson", "EatCandyPerson")
				elseif parent:GetAttribute("IsNPC") then
					addPrompt(obj, "NPC", "TalkToNPC")
				elseif parent:GetAttribute("IsSaveTerminal") then
					addPrompt(obj, "SaveTerminal", "UseSaveTerminal")
				elseif parent:GetAttribute("IsShrine") then
					addPrompt(obj, "Shrine", "UseShrine")
				elseif parent:GetAttribute("IsDungeonEntrance") then
					addPrompt(obj, "DungeonEntrance", "EnterDungeon")
				end
			end
		end
	end
end

function Interaction.Init()
	-- Scan on join
	task.delay(1, function()
		scanForInteractables()
		print("[Interaction] initialized — proximity prompts added to interactables")
	end)
end

return Interaction
