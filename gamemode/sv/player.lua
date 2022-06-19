gameOver = false

game.AddParticles("particles/GRENADE_FX.pcf")
PrecacheParticleSystem("grenade_explosion_01")


util.AddNetworkString("ng_bhop_landing")
util.AddNetworkString("ng_dash_move")

util.AddNetworkString("ng_player_death")
util.AddNetworkString("ng_player_spawn")

util.AddNetworkString("ng_game_end")

net.Receive("ng_bhop_landing", function(len, ply)
	ply:SetVelocity(ply:GetForward() * 25)
end)

function GM:PlayerSpawn(ply)
	ply:SetMaxHealth(250)
	ply:SetHealth(100)

	ply:SetSlowWalkSpeed(480)
	ply:SetWalkSpeed(480)
	ply:SetRunSpeed(480)
	ply:SetJumpPower(275)

	ply:AllowFlashlight(true)

	-- random playermodels go wheee
	if(math.random(1, 2) == 1) then
		ply:SetModel("models/player/group01/Male_0" .. math.random(1, 9) .. ".mdl")
	else
		ply:SetModel("models/player/group01/Female_0" .. math.random(1, 6) .. ".mdl")
	end
	ply:SetupHands()

	ply:SetPlayerColor(Vector(HSVToColor(math.random(0, 365), 1, 1).r / 1, HSVToColor(math.random(0, 365), 1, 1).g / 1, HSVToColor(math.random(0, 365), 1, 1).b / 1))
	ply:SetWeaponColor(Vector(HSVToColor(math.random(0, 365), 1, 0.015625).r / 1, HSVToColor(math.random(0, 365), 1, 0.015625).g / 1, HSVToColor(math.random(0, 365), 1, 0.015625).b / 1))

	if(!ply.gameOver) then ply:Give("ng_railgun") end

	ply.floorDashed = false
	ply.lastShoot = 0

	net.Start("ng_player_spawn")
	net.Send(ply)
end

function GM:GetFallDamage()
	return false
end

function GM:PlayerDeath(victim, inflictor, attacker)
	if(!IsValid(victim) or !IsValid(attacker)) then return end

	if(attacker:Frags() >= GetConVarNumber("ng_frags") && attacker:IsPlayer() && !gameOver) then
		gameOver = true

		net.Start("ng_game_end")
			net.WriteEntity(attacker)
			net.WriteEntity(victim)
			net.WriteInt(Pews, 16)
			net.Broadcast()

			timer.Simple(30, function()
				game.CleanUpMap()
				for v, k in pairs(player.GetAll()) do
					k.gameOver = false
					k:Spawn()
				end
			end)
		net.Broadcast()

		for v, k in pairs(player.GetAll()) do
			if(!k:Alive()) && k ~= victim then k:Spawn() end
			k.gameOver = true
			if(k ~= attacker) then
				k:StripWeapons()
				k:StripAmmo()
			end
		end
	end

	attacker.floorDashed = false
	net.Start("ng_player_death")
		net.WriteEntity(victim)
		net.WriteEntity(attacker)
	net.Send({victim, attacker})

	if(attacker == victim) then
		ParticleEffect("grenade_explosion_01", victim:GetPos() + Vector(0, 0, 50), Angle(0, 0, 0))
		victim:EmitSound("le_epic_fart_lmao_gamer_sound_xdxdxdxdxd.wav")
	end

	if(!victim.gameOver) then
		timer.Simple(5, function()
			if(!victim:Alive()) then
				victim:Spawn()
			end
		end)
	end
end

function GM:PlayerDeathThink(ply)
	return false
end

function GM:PreCleanupMap()
	Pews = 0
	gameOver = false
	for v, k in pairs(player.GetAll()) do
		k:SetFrags(0)
		k:SetDeaths(0)
	end
end

function GM:PlayerStartTaunt(ply, act, length)
	ply:EmitSound("misc/rubberglove_snap.wav")
end