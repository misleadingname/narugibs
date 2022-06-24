include("shared.lua")

if(#ents.FindByClass("ng_doll") == 0) then
	include("deathmatch/cl/player.lua")
	include("deathmatch/cl/effects.lua")
else
	include("koth/cl/player.lua")
	include("koth/cl/effects.lua")
end


include("deathmatch/cl/hud.lua")