AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("deathmatch/cl/player.lua")
AddCSLuaFile("deathmatch/cl/effects.lua")
AddCSLuaFile("deathmatch/cl/hud.lua")

include("shared.lua")

if(#ents.FindByClass("ng_doll") == 0) then
	MsgN("[narugibs] No dolls found, loading deathmatch")
	include("deathmatch/sv/player.lua")
else
	MsgN("[narugibs] Doll(s) found, loading King of the Hill")
	include("koth/sv/player.lua")
	include("koth/sv/effects.lua")
end

resource.AddFile("sound/le_epic_fart_lmao_gamer_sound_xdxdxdxdxd.wav")

MsgN("[narugibs] What's up?")