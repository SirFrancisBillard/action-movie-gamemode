AddCSLuaFile()

SWEP.Base = "weapon_basegun"

SWEP.PrintName = "Base Melee"

SWEP.ViewModel = "models/weapons/cstrike/c_knife_t.mdl"
SWEP.WorldModel = "models/weapons/w_knife_t.mdl"
SWEP.UseHands = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.AmmoType = "none"

SWEP.Primary.Delay = 0.4
SWEP.Primary.Damage = 30
SWEP.Primary.Range = 30
SWEP.Primary.Sound = Sound("Weapon_Knife.Slash")
SWEP.Primary.SoundMiss = Sound("Weapon_Crowbar.Single")

SWEP.Slot = 2
SWEP.DrawAmmo = false

SWEP.CanDrop = true
SWEP.HoldType = "knife"

function SWEP:CanPrimaryAttack()
	return true
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	self.Owner:SetAnimation(PLAYER_ATTACK1)

	if not IsValid(self.Owner) then return end

	if self.Owner.LagCompensation then -- for some reason not always true
		self.Owner:LagCompensation(true)
	end

	local spos = self.Owner:GetShootPos()
	local sdest = spos + (self.Owner:GetAimVector() * self.Primary.Range)

	local tr_main = util.TraceLine({start = spos, endpos = sdest, filter = self.Owner, mask = MASK_SHOT_HULL})
	local hitEnt = tr_main.Entity

	if IsValid(hitEnt) or tr_main.HitWorld then
		self:EmitSound(self.Primary.Sound)
		self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)

		if not (CLIENT and (not IsFirstTimePredicted())) then
			local edata = EffectData()
			edata:SetStart(spos)
			edata:SetOrigin(tr_main.HitPos)
			edata:SetNormal(tr_main.Normal)
			edata:SetSurfaceProp(tr_main.SurfaceProps)
			edata:SetHitBox(tr_main.HitBox)
			edata:SetEntity(hitEnt)

			if hitEnt:IsPlayer() or hitEnt:GetClass() == "prop_ragdoll" then
				util.Effect("BloodImpact", edata)
				self.Owner:LagCompensation(false)
				self.Owner:FireBullets({Num = 1, Src = spos, Dir = self.Owner:GetAimVector(), Spread = Vector(0, 0, 0), Tracer = 0, Force = 1, Damage = 0})
			else
				util.Effect("Impact", edata)
			end
		end
	else
		-- miss
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
		self:EmitSound(self.Primary.SoundMiss)
	end


	if SERVER and hitEnt and hitEnt:IsValid() then
		-- do another trace that sees nodraw stuff like func_button
		-- local tr_all = util.TraceLine({start = spos, endpos = sdest, filter = self.Owner})

		local dmg = DamageInfo()
		dmg:SetDamage(self.Primary.Damage)
		dmg:SetAttacker(self.Owner)
		dmg:SetInflictor(self)
		dmg:SetDamageForce(self.Owner:GetAimVector() * 1500)
		dmg:SetDamagePosition(self.Owner:GetPos())
		dmg:SetDamageType(DMG_SLASH)

		hitEnt:DispatchTraceAttack(dmg, spos + (self.Owner:GetAimVector() * 3), sdest)
	end

	if self.Owner.LagCompensation then
		self.Owner:LagCompensation(false)
	end
end

function SWEP:Reload() end

function SWEP:CanSecondaryAttack()
	-- temp workaround
	return self.CanDrop -- and not self:GetClass() == "weapon_fists"
end

local ThrowSound = Sound("Weapon_Crowbar.Single")

function SWEP:SecondaryAttack()
	if not self:CanSecondaryAttack() then return end
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	self:EmitSound(ThrowSound)
	self.Owner:ViewPunch(Angle(10, 0, 0))

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

		self.Owner:Give("weapon_fists")
		self.Owner:SelectWeapon("weapon_fists")
		self.Owner:StripWeapon(self.ClassName)
	end
end

local EquipSound = Sound("Item.PickupMelee")

if SERVER then
	function SWEP:Equip(ply)
		ply:EmitSound(EquipSound)
	end
end
