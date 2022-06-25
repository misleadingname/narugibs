if(SERVER) then
	AddCSLuaFile("shared.lua");

	function ENT:Initialize()
		self:SetModel("models/maxofs2d/companion_doll.mdl")

		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)

		local phys = self:GetPhysicsObject()
		if(phys:IsValid()) then
			phys:Wake()
		end
	end
elseif(CLIENT) then
	function ENT:Draw(flags)
		self:DrawModel()
	end
end

ENT.Type = "anim"
ENT.Base = "base_gmodenity"
ENT.PrintName = "ScoreBall"
ENT.Spawnable = true
