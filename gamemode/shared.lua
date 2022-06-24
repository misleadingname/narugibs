GM.Name = "なるgibs"
GM.Author = "@japannt"
GM.Email = "contact.japan@aol.com"
GM.Website = "http://japannt.tk"

DeriveGamemode("base")

if(#ents.FindByClass("ng_doll") == 0) then
	currentGamemode = "deathmatch"
else
	currentGamemode = "koth"
end