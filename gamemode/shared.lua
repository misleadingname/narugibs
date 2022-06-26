GM.Name = "なるgibs"
GM.Author = "@japannt"
GM.Email = "contact.japan@aol.com"
GM.Website = "http://japannt.tk"

DeriveGamemode("base")

if(!string.find(game.GetMap(), "_koth")) then
	currentGamemode = "deathmatch"
else
	currentGamemode = "koth"
end