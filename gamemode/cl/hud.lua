if(winPanel) then
	winPanel:Remove()
	winPanel = nil
end

if(mapVotePanel) then
	mapVotePanel:Remove()
	mapVotePanel = nil
end

if(deathPanel) then
	deathPanel:Remove()
	deathPanel = nil
end

local introText = "なるgibs is a simple enough gamemode to learn but hard to master.\nTo bhop; simply hold spacebar, you'll see your speed go up with every jump by 100u/s.\nThe railgun is the main attraction of this gamemode, to use it, just simply left click at someone to fire it.\nDashing is a pretty simple mechanic to learn, but hard to master. In mid air, press secondary fire to dash.\nIf you manage to kill someone in air after dashing, you regain your dash."

function createFonts()
	surface.CreateFont("SmallFont", {
		font = "Tahoma",
		size = ScreenScale(10),
		weight = 500,
		antialias = true,
		additive = true,
	})
	
	surface.CreateFont("HUDFont", {
		font = "Tahoma",
		size = ScreenScale(7),
		weight = 700,
		antialias = true,
		additive = true,
	})
	
	surface.CreateFont("MedFontBO", {
		font = "Tahoma",
		size = ScreenScale(12),
		weight = 1000,
		antialias = true,
		additive = true,
	})

	surface.CreateFont("MedFont", {
		font = "Tahoma",
		size = ScreenScale(12),
		weight = 500,
		antialias = true,
		additive = true,
	})

	surface.CreateFont("BigFontBO", {
		font = "Tahoma",
		size = ScreenScale(24),
		weight = 1000,
		antialias = true,
	})
	
	surface.CreateFont("BigFont", {
		font = "Tahoma",
		size = ScreenScale(24),
		weight = 500,
		antialias = true,
		additive = true,
	})
	 
	surface.CreateFont("numbersFont", {
		font = "HalfLife2",
		size = ScreenScale(24),
		weight = 500,
		antialias = true,
		additive = true,
	})
end

createFonts()

function GM:OnScreenSizeChanged()
	createFonts()
end

function GM:Initialize()
	MsgN("[narugibs] Should be initialized")
	if(!welcomePanel) then
		welcomePanel = vgui.Create("DFrame")
		welcomePanel:SetSize(ScrW() * 0.65, ScrH() * 0.5)
		welcomePanel:ShowCloseButton(false)
		welcomePanel:SetDraggable(false)
		welcomePanel:SetTitle("")
		welcomePanel:MakePopup()
		welcomePanel:Center()
		welcomePanel.Paint = function(self, w, h)
			draw.RoundedBox(10, 0, 0, w, h, Color(0, 0, 0, 175))
			draw.DrawText("Welcome to なるgibs!", "BigFontBO", w * 0.5, h * 0.105, Color(255, 220, 0, 255), TEXT_ALIGN_CENTER)
			draw.DrawText("We are currently playing " .. currentGamemode .. ", on " .. game.GetMap() .. "!", "SmallFont", w * 0.5, h * 0.9, Color(255, 220, 0, 255), TEXT_ALIGN_CENTER)
			
			surface.SetFont("SmallFont")
			local x, y = surface.GetTextSize(introText)

			draw.DrawText(introText, "SmallFont", w * 0.5, h * 0.5 - y * 0.5, Color(255, 220, 0, 255), TEXT_ALIGN_CENTER)
		end
	
		local welcomePanelCloseButton = vgui.Create("DButton", welcomePanel)
		welcomePanelCloseButton:SetFont("MedFontBO")
		welcomePanelCloseButton:SetColor(Color(255, 220, 0, 255))
		welcomePanelCloseButton:SetText("Let's go!")
		welcomePanelCloseButton:SizeToContents()
		welcomePanelCloseButton:SetSize(welcomePanelCloseButton:GetWide() + 40, welcomePanelCloseButton:GetTall() + 20)
		welcomePanelCloseButton:Center()

		surface.SetFont("SmallFont")
		local x, y = surface.GetTextSize("We are currently playing " .. currentGamemode .. ", on " .. game.GetMap() .. "!")

		welcomePanelCloseButton:SetY((welcomePanel:GetTall() * 0.8) - (welcomePanelCloseButton:GetTall() * 0.5) - y * 0.5)
		
		welcomePanelCloseButton.Paint = function(self, w, h)
			draw.RoundedBox(10, 0, 0, w, h, Color(0, 0, 0, 100))
		end

		welcomePanelCloseButton.DoClick = function()
			welcomePanel:Remove()
			welcomePanelCloseButton:Remove()
			welcomePanel = nil
			welcomePanelCloseButton = nil
		end
	end
end

net.Receive("ng_player_death", function()
	local victim = net.ReadEntity()
	local attacker = net.ReadEntity()
	
	if(!IsValid(victim)) then return end
	if(LocalPlayer().gameOver) then return end
	
	if(victim == LocalPlayer() || !attacker:IsPlayer()) then
		surface.PlaySound("buttons/combine_button2.wav")

		victim:ScreenFade(SCREENFADE.OUT, Color(0, 0, 0, 255), 4, 1)

		timer.Create("respawnTimer", 5, 1, function() MsgN("enjoy your respawn fag") end)

		if(!deathPanel) then
			deathPanel = vgui.Create("DPanel")
			deathPanel:SetSize(ScrW() * 0.25, ScrH() * 0.125)
			deathPanel:Center()
			deathPanel:SetY(ScrH() * 0.75)
			deathPanel.Paint = function(self, w, h)
				draw.RoundedBox(10, 0, 0, w, h, Color(0, 0, 0, 100))
				draw.DrawText("Respawn in " .. string.FormattedTime(timer.TimeLeft("respawnTimer"), "%i%i:%02is"), "MedFont", w / 2, h / 1.85, Color(255, 220, 0, 255), TEXT_ALIGN_CENTER)
			end
		else
			deathPanel:Remove()
			deathPanel = nil
		end

		local deathText = vgui.Create("DLabel", deathPanel)
		deathText:SetFont("MedFont")
		deathText:SetColor(Color(255, 220, 0, 255))
		if(attacker == LocalPlayer() || !attacker:IsPlayer()) then
			deathText:SetText("You commited suicide")
		else
			deathText:SetText("You were fragged by " .. attacker:Nick())
		end
		deathText:SizeToContents()
		deathText:Center()
		deathText:SetY(deathText:GetY() - 16)
	elseif(attacker == LocalPlayer()) then
		surface.PlaySound("plats/elevbell1.wav")
	end
end)

net.Receive("ng_player_spawn", function()
	if(deathPanel) then
		deathPanel:Remove()
		deathPanel = nil
	end
end)

net.Receive("ng_game_end", function()
	local lastAttacker = net.ReadEntity()
	local lastVictim = net.ReadEntity()
	local pewCount = net.ReadInt(16)

	LocalPlayer().gameOver = true

	LocalPlayer():ScreenFade(SCREENFADE.IN, Color(255, 255, 255), 3, 0.5)
	surface.PlaySound("misc/freeze_cam_snapshot.wav")

	if(#lastAttacker:Nick() > 5) then
		attackerName = string.upper(string.Left(lastAttacker:Nick(), 4) .. ".." .. string.Right(lastAttacker:Nick(), 4))
	else
		attackerName = string.upper(lastAttacker:Nick())
	end

	if(#lastVictim:Nick() > 7) then
		victimName = string.Left(lastVictim:Nick(), 6) .. ".." .. string.Right(lastVictim:Nick(), 6)
	else
		victimName = lastVictim:Nick()
	end

	timer.Create("newGameCounter", 30, 1, function()
		if(deathPanel) then
			deathPanel:Remove()
			deathPanel = nil
		end
	end)

	if(!deathPanel) then
		deathPanel = vgui.Create("DPanel")
		deathPanel:SetSize(ScrW() * 0.25, ScrH() * 0.125)
		deathPanel:Center()
		deathPanel:SetY(ScrH() * 0.75)
		deathPanel.Paint = function(self, w, h)
			draw.RoundedBox(10, 0, 0, w, h, Color(0, 0, 0, 100))
			local xs, xy = surface.GetTextSize("New game in " .. math.floor(timer.TimeLeft("newGameCounter")) .. "s")
			draw.DrawText("New game in " .. math.floor(timer.TimeLeft("newGameCounter")) .. "s", "MedFont", w / 2, h / 2 - (xy / 2), Color(255, 220, 0, 255), TEXT_ALIGN_CENTER)
		end
	else
		deathPanel:Remove()
		deathPanel = nil
	end

	if(!winPanel) then
		winPanel = vgui.Create("DFrame")
		winPanel:SetSize( ScrW() * 0.45, ScrH() * 0.35 )
		winPanel:Center()
		winPanel:SetTitle("")
		winPanel:SetDraggable(false)
		winPanel:MakePopup()
		winPanel.Paint = function(self, w, h)
			draw.RoundedBox(10, 0, 0, w, h, Color(0, 0, 0, 100))
			draw.DrawText(attackerName .. " WON THE GAME", "BigFont", w / 2, h / 8, Color(255, 220, 0, 255), TEXT_ALIGN_CENTER)
			draw.DrawText("Honourable mention goes to " .. victimName .. " for dying last.", "MedFont", w / 2, h / 3.5, Color(255, 220, 0, 255), TEXT_ALIGN_CENTER)

			draw.DrawText("Did you know that...", "MedFont", w / 2, h / 1.3125, Color(255, 220, 0, 255), TEXT_ALIGN_CENTER)
			draw.DrawText("This game the railgun was shot " .. pewCount .. " times?", "SmallFont", w / 2, h / 1.15, Color(255, 220, 0, 255), TEXT_ALIGN_CENTER)
		end

		local voteButton = vgui.Create("DButton", winPanel)
		voteButton:SetFont("MedFont")
		voteButton:SetColor(Color(255, 220, 0, 255))
		voteButton:SetText("Vote for a new map")
		voteButton:SizeToContents()
		voteButton:SetSize(voteButton:GetWide() + 40, voteButton:GetTall() + 20)
		voteButton:Center()
		voteButton:SetY(winPanel:GetTall() / 2)
		voteButton.Paint = function(self, w, h)
			draw.RoundedBox(10, 0, 0, w, h, Color(0, 0, 0, 100))
		end

		voteButton.DoClick = function()
			Derma_Message("Not implemented (yet!)", "TODO", "lol ok")
		end
	else
		winPanel:Remove()
		winPanel = nil
	end
end)

// https://wiki.facepunch.com/gmod/GM:HUDShouldDraw
local hide = {
	["CHudHealth"] = true,
	["CHudBattery"] = true,
	["CHudCrosshair"] = true,

}

hook.Add("HUDShouldDraw", "HideHUD", function(name)
	if(hide[name]) then
		return false
	end
end)