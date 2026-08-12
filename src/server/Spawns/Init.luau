--!strict
-- Spawns system — builds placeholder world geometry + spawns mobs on server start.
-- Lives in ServerScriptService.Server.Spawns.Init
--
-- For beta, geometry is built from parts. Real models swapped in later.

local Spawns = {}

function Spawns.Init()
	local CandyKingdomGeo = require(script:WaitForChild("CandyKingdomGeo"))
	local GrasslandsGeo = require(script:WaitForChild("GrasslandsGeo"))
	local MobSpawner = require(script:WaitForChild("MobSpawner"))

	CandyKingdomGeo.Build()
	GrasslandsGeo.Build()
	MobSpawner.SpawnAll()

	print("[Spawns] initialized")
end

return Spawns
