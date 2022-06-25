AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/maxofs2d/companion_doll.mdl")
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
 
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end

function ENT:OnTakeDamage(dmg)
	self:TakePhysicsDamage(dmg)
end

function ENT:Use(ply)
	if ply:IsPlayer() then
		ply:SetNWInt("ng_doll_score", ply:GetNWInt("ng_doll_score") + 1)
	end
end