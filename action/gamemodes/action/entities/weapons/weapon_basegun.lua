AddCSLuaFile()

SWEP.PrintName = "Base Gun"

SWEP.ViewModel = "models/weapons/c_357.mdl"
SWEP.WorldModel = "models/weapons/w_357.mdl"
SWEP.UseHands = true

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 6
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pistol"

SWEP.Primary.Damage = 120
SWEP.Primary.Recoil = 2
SWEP.Primary.Cone = 0.05
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.6
SWEP.Primary.Sound = Sound("Weapon_357.Single")
SWEP.Primary.Force = 40
SWEP.Primary.Tracer = 1
SWEP.Primary.TracerType = "Pistol"
SWEP.Primary.Distance = 56756
SWEP.Primary.SoundFadeDistance = 3000

SWEP.CrosshairType = "circle"
SWEP.CrosshairRadius = 4
SWEP.CrosshairColor = Color(0, 255, 0, 255)

local SnapSound = Sound("Bullet.Snap")

SWEP.Primary.Callback = function(ply, tr, dmg)
	sound.Play(SnapSound, tr.HitPos)
end

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.Secondary.Delay = 0.2

SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 0
SWEP.SlotPos = 1
SWEP.DrawAmmo = true
SWEP.DrawCrosshair = false

SWEP.HoldType = "pistol"

SWEP.CSMuzzleFlashes = true
SWEP.CSMuzzleX = true

SWEP.CanDrop = true
SWEP.ReloadRate = 1

SWEP.CrosshairFunctions = {
	["circle"] = function(size, color)
		surface.DrawCircle(ScrW() / 2, ScrH() / 2, size, color)
	end,
	["default"] = function(size, color)
		local length = 8
		local both = size + length + 16
		local w = ScrW()
		local h = ScrH()
		local HalfW = w / 2
		local HalfH = h / 2
		surface.SetDrawColor(color)
		surface.DrawLine(HalfW + size, h, HalfW + both, h) -- right line
		surface.DrawLine(HalfW - size, h, HalfW - both, h) -- left line
		surface.DrawLine(w, HalfH + size, w , HalfH + both) -- top line
		surface.DrawLine(w, HalfH - size, w , HalfH - both) -- bottom line
	end,
	["kobra"] = function(size, color)
		local length = 8
		local both = size + length
		local w = ScrW()
		local h = ScrH()
		local HalfW = w / 2
		local HalfH = h / 2
		surface.SetDrawColor(color)
		surface.DrawLine(HalfW + size, h, HalfW + both, h) -- right line
		surface.DrawLine(HalfW - size, h, HalfW - both, h) -- left line
		-- surface.DrawLine(w, HalfH + size, w , HalfH + both) -- top line
		surface.DrawLine(w, HalfH - size, w , HalfH - both) -- bottom line
	end
}

function SWEP:SetupDataTables()
	self:NetworkVar("Bool", 0, "Reloading")
	self:NetworkVar("Bool", 1, "NeedsReload")
	self:NetworkVar("Int", 0, "ReloadTimer")
end

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)

	self:SetReloading(false)
	self:SetNeedsReload(false)
	self:SetReloadTimer(0)
end

function SWEP:CanPrimaryAttack()
	return self.Owner:GetAmmoCount(self.Primary.Ammo) > 0 and not self:GetReloading()
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	if self.Owner.SetLastAttack then
		self.Owner:SetLastAttack(CurTime())
	end

	self:ShootEffects()
	self:EmitSound(self.Primary.Sound)

	local bullet = {}
	bullet.Num = self.Primary.NumShots
	bullet.Src = self.Owner:GetShootPos()
	bullet.Dir = self.Owner:GetAimVector()
	bullet.Tracer = self.Primary.Tracer
	bullet.Force = self.Primary.Force
	bullet.Damage = self.Primary.Damage
	bullet.AmmoType = self.Primary.TracerType
	bullet.Spread = Vector(self.Primary.Cone, self.Primary.Cone, 0)
	bullet.Distance = self.Primary.Distance
	bullet.Callback = self.Primary.Callback

	self.Owner:FireBullets(bullet)
	self.Owner:ViewPunch(Angle(math.Rand(-0.2, -0.1) * self.Primary.Recoil, math.Rand(-0.1, 0.1) * self.Primary.Recoil, 0))

	if SERVER then
		local eyeang = self.Owner:EyeAngles()
		eyeang.pitch = eyeang.pitch - self.Primary.Recoil
		self.Owner:SetEyeAngles(eyeang)
	end

	if self.Owner:GetAmmoCount(self.Primary.Ammo) > self.Primary.DefaultClip then
		self.Owner:SetAmmo(self.Primary.DefaultClip, self.Primary.Ammo)
	end

	self.Owner:RemoveAmmo(1, self.Primary.Ammo)

	if self.Owner:GetAmmoCount(self.Primary.Ammo) < 1 then
		self:SetNeedsReload(true)
	end
end

function SWEP:CanSecondaryAttack()
	return self.CanDrop
end

local ThrowSound = Sound("Weapon_Crowbar.Single")

function SWEP:SecondaryAttack()
	if not self:CanSecondaryAttack() then return end
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	self:EmitSound(ThrowSound)
	self.Owner:ViewPunch(Angle(10, 0, 0))

	ply:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_HL2MP_GESTURE_RANGE_ATTACK_FIST, true)

	if SERVER then
		local gun = ents.Create("ent_droppedweapon")

		if not IsValid(gun) then return end

		gun:SetOwner(self.Owner)
		gun:SetPos(self.Owner:EyePos())
		gun:SetAngles(self.Owner:EyeAngles())
		gun:Spawn()

		local phys = gun:GetPhysicsObject()
		if not IsValid(phys) then gun:Remove() return end

		local velocity = self.Owner:GetAimVector()
		velocity = velocity * 1200
		phys:ApplyForceCenter(velocity)

		gun:SetModel(self.WorldModel)

		gun.Ammo = self.Owner:GetAmmoCount(self.Primary.Ammo)
		gun.Class = self.ClassName
		gun.Thrower = self.Owner

		-- cleanup
		if g_PrimarySlotWeapons[self.ClassName] then
			self.Owner:SetHasPrimaryWeapon(false)
		elseif g_SecondarySlotWeapons[self.ClassName] then
			self.Owner:SetHasSecondaryWeapon(false)
		elseif g_MeleeSlotWeapons[self.ClassName] then
			self.Owner:SetHasMeleeWeapon(false)
		end

		self.Owner:ConCommand("lastinv")
		self.Owner:StripWeapon(self.ClassName)
	end
end

function SWEP:Reload()
	if not IsFirstTimePredicted() or self.Owner:GetAmmoCount(self.Primary.Ammo) >= self.Primary.DefaultClip or self:GetReloading() then return false end

	self:SendWeaponAnim(ACT_VM_RELOAD)
	self.Owner:SetAnimation(PLAYER_RELOAD)

	self:SetReloadTimer(CurTime() + 2)
	self:SetReloading(true)

	return true
end

function SWEP:Think()
	if self:GetNeedsReload() then
		self:SetNeedsReload(false)
		self:Reload()
	end

	if self:GetReloading() and self:GetReloadTimer() <= CurTime() then
		self:SetReloading(false)
		self:SetReloadTimer(0)

		self.Owner:SetAmmo(self.Primary.DefaultClip, self.Primary.Ammo)
	end
end

function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_DRAW)

	self:SetReloading(false)
	self:SetReloadTimer(0)
end

local EquipSound = Sound("Item.PickupGun")

if CLIENT then
	function SWEP:DrawHUD()
		self.CrosshairFunctions[self.CrosshairType](self.CrosshairRadius, self.CrosshairColor)
	end
else
	function SWEP:Equip(ply)
		ply:EmitSound(EquipSound)

		if g_PrimarySlotWeapons[self.ClassName] and not ply:GetHasPrimaryWeapon() then
			ply:SetHasPrimaryWeapon(true)
		elseif g_SecondarySlotWeapons[self.ClassName] and not ply:GetHasSecondaryWeapon() then
			ply:SetHasSecondaryWeapon(true)
		elseif g_MeleeSlotWeapons[self.ClassName] and not ply:GetHasMeleeWeapon() then
			if ply:HasWeapon("weapon_fists") then
				ply:StripWeapon("weapon_fists")
			end

			ply:SetHasMeleeWeapon(true)
		end
	end
end
