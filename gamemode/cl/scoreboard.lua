local scoreboardPanel

function GM:ScoreboardShow()
	if(!scoreboardPanel) then
		scoreboardPanel = vgui.Create("DPanel")
		scoreboardPanel:SetSize(ScrW() * 0.65, ScrH() * 0.8)
		scoreboardPanel:Center()
		scoreboardPanel.Paint = function(self, w, h)
			draw.RoundedBox(32, 0, 0, w, h, Color(0, 0, 0, 200))
			draw.DrawText(GetHostName(), "MedFontBO", w * 0.5, h * 0.035, Color(255, 220, 0, 255), TEXT_ALIGN_CENTER)
			draw.DrawText("なるgibs | " .. currentGamemode, "SmlFont", w * 0.5, h * 0.08, Color(255, 220, 0, 255), TEXT_ALIGN_CENTER)
		end

		local playerScrollPanel = vgui.Create("DScrollPanel", scoreboardPanel)
		playerScrollPanel:SetSize(scoreboardPanel:GetWide() * 0.9, scoreboardPanel:GetTall() * 0.8)
		playerScrollPanel:SetPos(scoreboardPanel:GetWide() * 0.05, scoreboardPanel:GetTall() * 0.15)
	
		playerList = vgui.Create("DListLayout", playerScrollPanel)
		playerList:SetSize(playerScrollPanel:GetWide(), playerScrollPanel:GetTall())
		playerList:SetPos(0, 0)
	end

	if(scoreboardPanel) then
		playerList:Clear()

		for v, k in pairs(player.GetAll()) do
			local playerPanel = vgui.Create("DPanel", playerList)
			playerPanel:SetSize(playerList:GetWide(), 78)
			playerPanel.Paint = function(self, w, h)
				if(k:IsValid()) then
					local hh = h - 8
					local ms = "UNKNOWN"
					local steamid = "UNKNOWN"
	
					if(k:IsBot()) then
						ms = "BOT"
						steamid = "beep beep I robo"
					else
						ms = k:Ping() .. "ms"
						steamid = k:SteamID()
					end
					
					draw.RoundedBox(10, 0, 0, w, hh, Color(0, 0, 0, 200))
					draw.DrawText(k:Nick(), "MedFontBO", w * 0.07, hh * 0.04, Color(255, 220, 0, 255), TEXT_ALIGN_LEFT)
					draw.DrawText(steamid, "SmlFont", w * 0.07, hh * 0.55, Color(255, 220, 0, 255), TEXT_ALIGN_LEFT)
					
					draw.DrawText("SPEED", "SmlFont", w * 0.3, hh * 0.12, Color(255, 220, 0, 255), TEXT_ALIGN_LEFT)
					draw.DrawText(math.Round(k:GetVelocity():Length()), "MedFontBO", w * 0.3, hh * 0.39, Color(255, 220, 0, 255), TEXT_ALIGN_LEFT)
	
					draw.DrawText("FRAGS", "SmlFont", w * 0.4, hh * 0.12, Color(255, 220, 0, 255), TEXT_ALIGN_LEFT)
					draw.DrawText(k:Frags(), "MedFontBO", w * 0.4, hh * 0.39, Color(255, 220, 0, 255), TEXT_ALIGN_LEFT)
	
					if(currentGamemode == "koth") then
						draw.DrawText("POINTS", "SmlFont", w * 0.5, hh * 0.12, Color(255, 220, 0, 255), TEXT_ALIGN_LEFT)
						if(k:GetNWInt("dollPoints", 0) == 0) then
							draw.DrawText("NO POINTS", "MedFontBO", w * 0.5, hh * 0.39, Color(255, 220, 0, 255), TEXT_ALIGN_LEFT)
						else
							draw.DrawText(k:GetNWInt("dollPoints", "NO POINTS"), "MedFontBO", w * 0.5, hh * 0.39, Color(255, 220, 0, 255), TEXT_ALIGN_LEFT)
						end
					end
	
					if(!k:Alive()) then
						draw.DrawText("DED", "BigFontBO", w * 0.08, 0, Color(255, 0, 0), TEXT_ALIGN_LEFT)
					end
	
					draw.DrawText(ms, "SmlFont", w * 0.95, hh * 0.3125, Color(255, 220, 0, 255), TEXT_ALIGN_CENTER)
				else
					local hh = h - 8
					
					draw.RoundedBox(10, 0, 0, w, hh, Color(0, 0, 0, 200))
					draw.DrawText("PLAYER DISCONNECTED", "MedFontBO", w * 0.5, hh * 0.25, Color(255, 0, 0, 255), TEXT_ALIGN_CENTER)
				end
			end

			local playerAvatar = vgui.Create("AvatarImage", playerPanel)
			playerAvatar:SetSize(54, 54)
			playerAvatar:SetPos(8, 8)
			playerAvatar:SetPlayer(k, 84)
		end

		scoreboardPanel:SetVisible(true)
	end
end

function GM:ScoreboardHide()
	if(scoreboardPanel) then
		scoreboardPanel:SetVisible(false)
	end
end