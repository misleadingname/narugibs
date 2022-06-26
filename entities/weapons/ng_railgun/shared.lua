if(SERVER) then
	AddCSLuaFile("shared.lua")
 
	SWEP.Weight = 5

	Pews = 0
	
	SWEP.AutoSwitchTo = false
	SWEP.AutoSwitchFrom = false
	
elseif(CLIENT) then
	SWEP.PrintName = "f(r)agger"

	SWEP.Slot = 1
	SWEP.SlotPos = 1
	
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
end

delayBetweenShots = 0.25
SWEP.Primary.Automatic = false

SWEP.Purpose = "Obliterates faggots."
SWEP.Instructions = "pow pow"

SWEP.Category = "narugibs"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.ViewModel = "models/weapons/c_superphyscannon.mdl"
SWEP.WorldModel = "models/weapons/w_physics.mdl"
SWEP.HoldType = "physgun"

SWEP.Primary.Ammo = "none"
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false

SWEP.UseHands = true

local powSound = Sound("weapons/ar2/npc_ar2_altfire.wav") 

function SWEP:Initialize()
	self.cantDash = 0
	self:SetHoldType("physgun")
end

function SWEP:Reload()
end

function SWEP:Think()
	if(self.Owner:OnGround()) then
		self.Owner.floorDashed = false
	end
end

function SWEP:PrimaryAttack()
	if(!self.Owner.lastShoot) then self.Owner.lastShoot = 0 end

	if(gameOver) then
		self.Primary.Automatic = true
		delayBetweenShots = 0.1
	else
		self.Primary.Automatic = false
		delayBetweenShots = 0.25
	end

	if(CurTime() - self.Owner.lastShoot >= delayBetweenShots) then
		local bullet = {}
		bullet.Src 	= self.Owner:GetShootPos()
		bullet.Dir 	= self.Owner:GetAimVector()
		bullet.Tracer	= 1
		bullet.TracerName = "ToolTracer"
		bullet.Spread 	= Vector(0, 0, 0)
		bullet.Num 	= 1
		bullet.Force	= 9999
		bullet.Damage	= 10000
		
		self.Owner.lastShoot = CurTime()
		self:EmitSound(powSound)
		self.Owner:FireBullets( bullet )
		self:ShootEffects()

		if(SERVER) then
			Pews = Pews + 1
		end
	end
end
 
function SWEP:SecondaryAttack()
	if(self.Owner:OnGround()) then
		self.Owner.floorDashed = false
	end

	if(!self.Owner:OnGround() && !self.Owner.floorDashed) then
		self.Owner:SetVelocity(self.Owner:EyeAngles():Forward() * 700)
		self.Owner:EmitSound("/vehicles/airboat/pontoon_impact_hard" .. math.random(1, 2) .. ".wav")
		self.Owner.floorDashed = true
	else
		if(CLIENT) then
			self.cantDash = self.cantDash + 1
			if(self.cantDash == 10) then
				notification.AddLegacy("To dash, you need to be mid air or not already be dashing.", NOTIFY_HINT, 5)
				self.cantDash = 0
			end
		end
	end
end

function SWEP:DrawHUD()
	if(!self.Owner.gameOver) then	
		draw.RoundedBox(5, ScrW() * 0.0175, ScrH() * 0.9, ScrW() * 0.12, ScrH() * 0.075, Color(0, 0, 0, 150))
		draw.DrawText("FRAGS", "HUDFont", ScrW() * 0.0285, ScrH() * 0.94, Color(255, 220, 0, 255), TEXT_ALIGN_LEFT)
		draw.DrawText(LocalPlayer():Frags(), "numbersFont", ScrW() * 0.07635, ScrH() * 0.905, Color(255, 220, 0, 255), TEXT_ALIGN_LEFT)

		if(currentGamemode == "koth") then
			draw.RoundedBox(5, ScrW() * 0.0175, ScrH() * 0.85, ScrW() * 0.12, ScrH() * 0.04, Color(0, 0, 0, 150))
			draw.DrawText("SCORE:", "HUDFont", ScrW() * 0.0285, ScrH() * 0.86, Color(255, 220, 0, 255), TEXT_ALIGN_LEFT)
			if(LocalPlayer():GetNWInt("dollPoints", 0) ~= 0) then
				draw.DrawText(LocalPlayer():GetNWInt("dollPoints", "NO POINTS"), "HUDFont", ScrW() * 0.095, ScrH() * 0.86, Color(255, 220, 0, 255), TEXT_ALIGN_CENTER)
			else
				draw.DrawText("NO POINTS", "HUDFont", ScrW() * 0.095, ScrH() * 0.86, Color(255, 220, 0, 255), TEXT_ALIGN_CENTER)
			end
		end

		draw.RoundedBox(5, ScrW() * 0.15, ScrH() * 0.9, ScrW() * 0.12, ScrH() * 0.075, Color(0, 0, 0, 150))
		draw.DrawText("SPEED", "HUDFont", ScrW() * 0.1595, ScrH() * 0.94, Color(255, 220, 0, 255), TEXT_ALIGN_LEFT)
		draw.DrawText(math.Round(self.Owner:GetVelocity():Length()), "numbersFont", ScrW() * 0.225, ScrH() * 0.905, Color(255, 220, 0, 255), TEXT_ALIGN_CENTER)

		surface.SetDrawColor(255, 0, 0)
		x, y = ScrW() / 2, ScrH() / 2
		local scale = 1
		local gap = 5
		local length = gap + 20
		surface.DrawLine( x - length, y, x - gap, y )
		surface.DrawLine( x + length, y, x + gap, y )
		surface.DrawLine( x, y - length, x, y - gap )
		surface.DrawLine( x, y + length, x, y + gap )
	end
end