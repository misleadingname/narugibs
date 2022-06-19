local smooth = 0.1
local slowZoom = 0

hook.Add("CalcView", "ng_calc_view", function(ply, pos, ang, fov)
	if(!ply:IsPlayingTaunt()) then
		if(!ply:Alive() && !ply.gameOver) then
			slowZoom = slowZoom - 8 * FrameTime()

			local view = {
				fov = slowZoom
			}

			return view
		else
			local SpeedX, SpeedY = ply:GetVelocity():Unpack()
			local noZ = Vector(SpeedX, SpeedY, 0)

			local targetfov = math.Clamp(noZ:Length() * 0.5, 90, 160)

			local view = {
				fov = Lerp(smooth, fov, targetfov),
			}

			slowZoom = view.fov

			return view
		end
	else
		local view = {
			fov = 90,
			origin = pos - (ang:Forward() * 128),
			drawviewer = true,
		}

		return view
	end
end)