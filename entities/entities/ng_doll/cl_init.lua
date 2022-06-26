include("shared.lua")

local glowUser = nil
local glowTable = {}

function ENT:Initialize()
	glowTable = {self}
end

function ENT:Draw()
	self:DrawModel()
	self:SetColor(HSVToColor(CurTime() * 100 % 360, 1, 1))
end

hook.Add("PreDrawHalos", "DrawHalos", function()
	halo.Add(glowTable, HSVToColor(CurTime() * 100 % 360, 1, 1), 8, 8, 4, true, true)
end)

net.Receive("ng_doll_grab", function()
	local ply = net.ReadEntity()

	surface.PlaySound("alertBeep.wav")
	glowUser = ply
	table.insert(glowTable, ply)

	if(ply == LocalPlayer()) then
		LocalPlayer():PrintMessage(HUD_PRINTCENTER, "You have the doll!\nYou're now highlighted for everyone, so get going!")
	else
		LocalPlayer():PrintMessage(HUD_PRINTCENTER, ply:Nick() .. " has the doll!")
	end
end)

net.Receive("ng_doll_drop", function()
	local ply = net.ReadEntity()

	glowUser = nil
	table.RemoveByValue(glowTable, ply)

	if(ply == LocalPlayer()) then
		LocalPlayer():PrintMessage(HUD_PRINTCENTER, "You have dropped the doll!")
	else
		LocalPlayer():PrintMessage(HUD_PRINTCENTER, ply:Nick() .. " has dropped the doll!")
	end
end)