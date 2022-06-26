AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

util.AddNetworkString("ng_doll_grab")
util.AddNetworkString("ng_doll_drop")

include("shared.lua")

function winGame(attacker, victim)
	gameOver = true

	net.Start("ng_game_end")
		net.WriteEntity(attacker)
		net.WriteEntity(victim)
		net.WriteInt(Pews, 16)
		net.Broadcast()

		//HACK: This is so the point counter displays "NO POINTS" at the beginning of the game.

		timer.Simple(30, function()
			game.CleanUpMap()
			for v, k in pairs(player.GetAll()) do
				k.gameOver = false
				k:Spawn()
			end
		end)
		net.Broadcast()
		
	for v, k in pairs(player.GetAll()) do
		if(!k:IsValid()) then continue end
		k:SetNWInt("dollPoints", 0)
		if(!k:Alive() && k ~= victim) then k:Spawn() end
		k.gameOver = true
		if(k ~= attacker) then
			k:StripWeapons()
			k:StripAmmo()
		end
	end
end

ENT.HeldBy = nil
ENT.InitPosition = nil

function ENT:Initialize()
	if(currentGamemode ~= "koth") then self:Remove() end

	self:SetModel("models/maxofs2d/companion_doll.mdl")
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
 
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end

	timer.Simple(0.1, function()
		self.InitPosition = self:GetPos()
	end)

	timer.Create("addScore", 0.25, 0, function()
		if(self.HeldBy && self:IsPlayerHolding() && self.HeldBy:GetNWInt("dollPoints") < GetConVarNumber("ng_points")) then
			self.HeldBy:SetNWInt("dollPoints", self.HeldBy:GetNWInt("dollPoints", 0) + 1)
		elseif(self.HeldBy:GetNWInt("dollPoints", 0) >= GetConVarNumber("ng_points")) then
			self:Remove()
			winGame(self.HeldBy, self.HeldBy)
		end
	end)
	timer.Stop("addScore")
end

function ENT:OnTakeDamage(dmg)
	self:TakePhysicsDamage(dmg)
end

function ENT:Use(ply) 
	if(self:IsPlayerHolding()) then return end
	self.HeldBy = ply
	ply:PickupObject(self)

	timer.Start("addScore")

	net.Start("ng_doll_grab")
		net.WriteEntity(ply)
	net.Broadcast()
end

hook.Add("OnPlayerPhysicsDrop", "ng_doll_drop", function(ply, ent)
	if(ent:GetClass() == "ng_doll") then
		ent.HeldBy = nil
		timer.Stop("addScore")
		net.Start("ng_doll_drop")
			net.WriteEntity(ply)
		net.Broadcast()
	end
end)

function ENT:Think()
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	
	if(self:GetPos()[3] < 50) then
		self:SetPos(self.InitPosition)
	end
end