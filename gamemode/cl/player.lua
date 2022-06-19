LocalPlayer().gameOver = false

hook.Add("CreateMove", "bunnyhop", function(uc)
	local lp = LocalPlayer()

	if(lp:IsPlayingTaunt()) then
		uc:ClearMovement()
		uc:ClearButtons()

		return false
	end

	if(GetGlobalBool("ng_autojump", true)) then
		local band = bit.band
		local bhstop = 0xFFFF - IN_JUMP
		
		if lp:WaterLevel() < 2 and lp:Alive() and lp:GetMoveType() == MOVETYPE_WALK then
			if !lp:InVehicle() and band(uc:GetButtons(), IN_JUMP) > 0 then
				if lp:IsOnGround() then
					uc:SetButtons(uc:GetButtons() or IN_JUMP)
					net.Start("ng_bhop_landing", true)
					net.SendToServer()
				else
					uc:SetButtons(band(uc:GetButtons(), bhstop))
				end
			end
		end
	end
end)

function GM:PreCleanupMap()
	LocalPlayer().gameOver = false

	if(winPanel) then
		winPanel:Remove()
		winPanel = nil
	end
	
	if(mapVotePanel) then
		mapVotePanel:Remove()
		mapVotePanel = nil
	end
	
	if(voteButton) then
		voteButton:Remove()
		voteButton = nil
	end
end