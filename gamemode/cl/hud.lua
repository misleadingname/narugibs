local introText = "なるgibs is a simple enough gamemode to learn but hard to master.\nTo bhop; simply hold spacebar, you'll see your speed go up with every jump by 100u/s.\nThe railgun is the main attraction of this gamemode, to use it, just simply left click at someone to fire it.\nDashing is a pretty simple mechanic to learn, but hard to master. In mid air, press secondary fire to dash.\nIf you manage to kill someone in air after dashing, you regain your dash."

local GC_KillfeedTable = {}

function GC_InsertKillfeed(victim, inflictor, attacker)
	if #GC_KillfeedTable > 0 then
		for k, v in ipairs(GC_KillfeedTable) do
			if ispanel(v.Frame) then
				v.Frame:MoveTo(ScrW() - (ScrW()*0.01) - v.Frame:GetWide(), (ScrW()*0.01) + ((v.Frame:GetTall() + 5) * ((#GC_KillfeedTable + 1) - k)), 0.3, 0, -1, function(tbl, pnl) end)
			end
		end
	end
	
	local killfeed = {}
	killfeed.Frame = vgui.Create("DPanel")
	killfeed.Frame:SetBackgroundColor(Color(0, 0, 0, 175))
	killfeed.Frame:SetAlpha(0)
	killfeed.Frame:AlphaTo(255, 0.5, 0, function(tbl, pnl) end)
	killfeed.Frame:AlphaTo(0, 0.5, 4, function(tbl, pnl) end)

	if attacker != NULL && attacker:IsPlayer() && attacker != victim  then
		killfeed.Attacker = killfeed.Frame:Add("DLabel")
		killfeed.Attacker:Dock(LEFT)
		killfeed.Attacker:SetText(attacker:GetName())
		killfeed.Attacker:SetColor(Color(255, 255, 255))

		killfeed.Attacker:SizeToContentsX()
		killfeed.Attacker:DockMargin(5, 0, 5, 0)
	
		killfeed.Inflictor = killfeed.Frame:Add("DLabel")
		killfeed.Inflictor:Dock(LEFT)
		if inflictor != NULL && inflictor:GetClass() == "player" then
			killfeed.Inflictor:SetText("[" .. attacker:GetActiveWeapon():GetPrintName() .. "]")
			killfeed.Inflictor:SetColor(Color(255,255,255,255)) 
		elseif inflictor != NULL && !inflictor:IsNPC() then
			killfeed.Inflictor:SetText("[" .. inflictor:GetClass() .. "]") 
			killfeed.Inflictor:SetColor(Color(255,255,255,255))
		else
			killfeed.Inflictor:SetText("[KILLED]") 
			killfeed.Inflictor:SetColor(Color(255,255,255,255))
			
		end
		killfeed.Inflictor:SizeToContentsX()
		killfeed.Inflictor:DockMargin(5, 0, 5, 0)

	elseif attacker != NULL && attacker:GetClass() == "prop_physics" then
		local ply, plyid = attacker:CPPIGetOwner()

		if ply != nil then
			if ply != victim then
				killfeed.Attacker = killfeed.Frame:Add("DLabel")
				killfeed.Attacker:Dock(LEFT)

				killfeed.Attacker:SetText(ply:GetName())
				killfeed.Attacker:SetColor(Color(255, 255, 255))

				killfeed.Attacker:SizeToContentsX()
				killfeed.Attacker:DockMargin(5, 0, 5, 0)

				killfeed.Inflictor = killfeed.Frame:Add("DLabel")
				killfeed.Inflictor:Dock(LEFT)
				killfeed.Inflictor:SetText("[KILLED]") 
				killfeed.Inflictor:SetColor(Color(255,255,255,255))
				killfeed.Inflictor:SizeToContentsX()
				killfeed.Inflictor:DockMargin(5, 0, 5, 0) 
			end
		else
			killfeed.Attacker = killfeed.Frame:Add("DLabel")
			killfeed.Attacker:Dock(LEFT)

			killfeed.Attacker:SetText(attacker:GetClass())
			killfeed.Attacker:SetColor(Color(255, 255, 255))

			killfeed.Attacker:SizeToContentsX()
			killfeed.Attacker:DockMargin(5, 0, 5, 0)

			killfeed.Inflictor = killfeed.Frame:Add("DLabel")
			killfeed.Inflictor:Dock(LEFT)
			killfeed.Inflictor:SetText("[KILLED]") 
			killfeed.Inflictor:SetColor(Color(255,255,255,255))
			killfeed.Inflictor:SizeToContentsX()
			killfeed.Inflictor:DockMargin(5, 0, 5, 0)
		end
	end

	killfeed.Victim = killfeed.Frame:Add("DLabel")
	killfeed.Victim:Dock(LEFT)
	killfeed.Victim:SetColor(Color(255, 255, 255))
	killfeed.Victim:SetText(victim:GetName())
	killfeed.Victim:SizeToContentsX()
	killfeed.Victim:DockMargin(5, 0, 5, 0)

	if ispanel(killfeed.Attacker) && ispanel(killfeed.Inflictor) then
		killfeed.Frame:SetPos(ScrW() - (ScrW()*0.01) - killfeed.Attacker:GetWide() - killfeed.Inflictor:GetWide() - killfeed.Victim:GetWide() - 30, (ScrW()*0.01))  
		killfeed.Frame:SetSize(killfeed.Attacker:GetWide() + killfeed.Inflictor:GetWide() + killfeed.Victim:GetWide() + 30, ScrH()*0.025)
	else
		killfeed.Frame:SetPos(ScrW() - (ScrW()*0.01) - killfeed.Victim:GetWide() - 10, (ScrW()*0.01))  
		killfeed.Frame:SetSize(killfeed.Victim:GetWide() + 10, ScrH()*0.025)
	end
	
	timer.Simple(5, function()
		if #GC_KillfeedTable > 0 then
			GC_KillfeedTable[1].Frame:Remove()
			table.remove(GC_KillfeedTable, 1)
		end
	end)

	table.insert(GC_KillfeedTable, killfeed)
end

local function createFonts()
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

	surface.CreateFont("SmlFont", {
		font = "Tahoma",
		size = ScreenScale(8),
		weight = 500,
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
		local welcomePanel = vgui.Create("DFrame")
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
		end
	end
end

net.Receive("ng_player_death", function()
	local victim = net.ReadEntity()
	local attacker = net.ReadEntity()
	local inflictor = net.ReadEntity()
	
	if(!IsValid(victim)) then return end
	if(LocalPlayer().gameOver) then return end
	
	if(victim == LocalPlayer() || !attacker:IsPlayer()) then
		surface.PlaySound("buttons/combine_button2.wav")

		victim:ScreenFade(SCREENFADE.OUT, Color(0, 0, 0, 255), 4, 1)

		local deathPanel = vgui.Create("DPanel")
		deathPanel:SetSize(ScrW() * 0.25, ScrH() * 0.125)
		deathPanel:Center()
		deathPanel:SetY(ScrH() * 0.75)
		deathPanel.Paint = function(self, w, h)
			draw.RoundedBox(10, 0, 0, w, h, Color(0, 0, 0, 100))
			draw.DrawText("Respawn in " .. string.FormattedTime(timer.TimeLeft("respawnTimer"), "%i%i:%02is"), "MedFont", w / 2, h / 1.85, Color(255, 220, 0, 255), TEXT_ALIGN_CENTER)
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

		timer.Create("respawnTimer", 5, 1, function()
			MsgN("enjoy your respawn fag")
			deathPanel:Remove()
		end)

	elseif(attacker == LocalPlayer()) then
		surface.PlaySound("plats/elevbell1.wav")

		if(LocalPlayer():Frags() < GetConVar("ng_frags"):GetInt()) then
			local fragPanel = vgui.Create("DPanel")
			fragPanel:SetSize(ScrW() * 0.25, ScrH() * 0.125)
			fragPanel:Center()
			fragPanel:SetY(ScrH() * 0.75)
			fragPanel.Paint = function(self, w, h)
				draw.RoundedBox(10, 0, 0, w, h, Color(0, 0, 0, 100))
				draw.DrawText("You fragged", "SmlFont", w / 2, h / 6, Color(255, 220, 0, 255), TEXT_ALIGN_CENTER)
				draw.DrawText(victim:Nick(), "BigFont", w / 2, h / 2.7, Color(255, 220, 0, 255), TEXT_ALIGN_CENTER)
			end

			timer.Simple(1.5, function()
				fragPanel:Remove()
			end)
		end
	end

	GC_InsertKillfeed(victim, inflictor, attacker)
end)

net.Receive("ng_player_spawn", function()
	surface.PlaySound("hl1/fvox/bell.wav")
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

	local endGamePanel = vgui.Create("DPanel")
	endGamePanel:SetSize(ScrW() * 0.25, ScrH() * 0.125)
	endGamePanel:Center()
	endGamePanel:SetY(ScrH() * 0.75)
	endGamePanel.Paint = function(self, w, h)
		draw.RoundedBox(10, 0, 0, w, h, Color(0, 0, 0, 100))
		local text = "New game in " .. math.floor(timer.TimeLeft("newGameCounter") or 0)  .. "s"
		draw.DrawText(text, "MedFont", w / 2, h / 2.65, Color(255, 220, 0, 255), TEXT_ALIGN_CENTER)
	end

	timer.Create("newGameCounter", 30, 1, function()
		if(endGamePanel) then
			endGamePanel:Remove()
		end
	end)

	local winPanel = vgui.Create("DFrame")
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