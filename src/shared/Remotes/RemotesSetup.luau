--!strict
-- Remotes setup — creates the BindableEvent/RemoteEvent instances other systems use.
-- Lives in ReplicatedStorage.Shared.Remotes.RemotesSetup
--
-- Called once at server boot. Idempotent — safe to call multiple times.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local function ensure(parent: Instance, name: string, className: string): Instance
	local existing = parent:FindFirstChild(name)
	if existing and existing:IsA(className) then
		return existing
	end
	local inst = Instance.new(className)
	inst.Name = name
	inst.Parent = parent
	return inst
end

local function setup()
	-- BindableEvent fired when a player's data is loaded (server-only)
	ensure(ReplicatedStorage, "PlayerDataReady", "BindableEvent")

	-- BindableEvent fired when a player's RNG roll is applied (server-only)
	ensure(ReplicatedStorage, "RNGRolled", "BindableEvent")

	-- RemoteEvent for client to request its own data snapshot
	ensure(ReplicatedStorage, "RequestPlayerData", "RemoteFunction")

	-- RemoteEvent for client to server actions (combat, sugar rush, etc.) — added per-system later
	ensure(ReplicatedStorage, "ClientToServer", "RemoteEvent")
	ensure(ReplicatedStorage, "ServerToClient", "RemoteEvent")
end

return {
	setup = setup,
}
