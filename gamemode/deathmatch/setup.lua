cvars.AddChangeCallback("ng_bhop", function(cvar, old, new)
	if(GetConVarNumber("ng_bhop") == 0) then
		SetGlobalBool("ng_autojump", false)
	else
		SetGlobalBool("ng_autojump", true)
	end
end)

cvars.AddChangeCallback("ng_dash", function()
	if(GetConVarNumber("ng_dash") == 0) then
		SetGlobalBool("ng_dash", false)
	else
		SetGlobalBool("ng_dash", true)
	end
end)