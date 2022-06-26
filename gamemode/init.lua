AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

AddCSLuaFile("cl/player.lua")
AddCSLuaFile("cl/effects.lua")
AddCSLuaFile("cl/hud.lua")

include("shared.lua")

if(!string.find(game.GetMap(), "_koth")) then
	MsgN("[narugibs] KOTH not specified, loading deathmatch")
	include("deathmatch/player.lua")
else
	MsgN("[narugibs] KOTH specified, loading King of the Hill")
	include("koth/player.lua")
end

game.ConsoleCommand("sv_airaccelerate 9999\n")

resource.AddFile("sound/le_epic_fart_lmao_gamer_sound_xdxdxdxdxd.wav")
resource.AddFile("sound/alertBeep.wav")
resource.AddFile("sound/scoreCount.wav")

MsgN("[narugibs] What's up?")