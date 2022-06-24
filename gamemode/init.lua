AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

AddCSLuaFile("cl/player.lua")
AddCSLuaFile("cl/effects.lua")
AddCSLuaFile("cl/hud.lua")

include("shared.lua")

if(#ents.FindByClass("ng_doll") == 0) then
	MsgN("[narugibs] No dolls found, loading deathmatch")
	include("deathmatch/sv/player.lua")
else
	MsgN("[narugibs] Doll(s) found, loading King of the Hill")
	include("koth/sv/player.lua")
end

resource.AddFile("sound/le_epic_fart_lmao_gamer_sound_xdxdxdxdxd.wav")

MsgN("[narugibs] What's up?")