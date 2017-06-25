AddCSLuaFile()

g_PrimarySlotWeapons = {}
g_SecondarySlotWeapons = {}
g_MeleeSlotWeapons = {}

g_GunTypeWeapons = {}
g_MeleeTypeWeapons = {}

WEAPON_SLOT_PRIMARY = 1
WEAPON_SLOT_SECONDARY = 2
WEAPON_SLOT_MELEE = 3

WEAPON_TYPE_GUN = 1
WEAPON_TYPE_MELEE = 2

g_DefaultWeapons = {
	[WEAPON_SLOT_PRIMARY] = "weapon_ak47",
	[WEAPON_SLOT_SECONDARY] = "weapon_pistol",
	[WEAPON_SLOT_MELEE] = "weapon_crowbar"
}

local SlotToTable = {
	[WEAPON_SLOT_PRIMARY] = "g_PrimarySlotWeapons",
	[WEAPON_SLOT_SECONDARY] = "g_SecondarySlotWeapons",
	[WEAPON_SLOT_MELEE] = "g_MeleeSlotWeapons"
}

local TypeToTable = {
	[WEAPON_TYPE_GUN] = "g_GunTypeWeapons",
	[WEAPON_TYPE_MELEE] = "g_MeleeTypeWeapons"
}

local TypeToBase = {
	[WEAPON_TYPE_GUN] = "weapon_basegun",
	[WEAPON_TYPE_MELEE] = "weapon_basemelee"
}

local function GenerateWeaponTable(type)
	return weapons.Get(TypeToBase[type])
end

if CLIENT then
	surface.CreateFont("CSTypeDeath",
	{
		font = "csd",
		size = ScreenScale(20),
		antialias = true,
		weight = 300
	})
end

local killicon_color = Color(255, 80, 0, 255)

function AddNewWeapon(slot, typ, tab, cls, icon)
	local new = GenerateWeaponTable(typ)

	_G[SlotToTable[slot]][cls] = true
	_G[TypeToTable[typ]][cls] = true

	game.AddAmmoType({name = "ammotype_" .. cls})
	if CLIENT then
		language.Add("ammotype_" .. cls .. "_ammo", "Bullets")
	end

	for k, v in pairs(tab) do
		new[k] = v
	end

	new.Primary.ClipSize = -1
	new.Primary.Ammo = "ammotype_" .. cls
	new.Primary.Automatic = true

	if typ == WEAPON_TYPE_MELEE then
		new.Primary.DefaultClip = -1
	end

	new.Secondary.Automatic = true

	if not g_DefaultWeapons[typ] then
		g_DefaultWeapons[typ] = cls
	end

	weapons.Register(new, cls)

	if CLIENT and type(icon) == "table" then
		killicon.AddFont(cls, icon.font, icon.letter, killicon_color)
	end
end

local Wep = {Primary = {}}
Wep.PrintName = "AK-47"
Wep.HoldType = "ar2"
Wep.ViewModel = Model("models/weapons/cstrike/c_rif_ak47.mdl")
Wep.WorldModel = Model("models/weapons/w_rif_ak47.mdl")
Wep.Slot = 0
Wep.Primary.DefaultClip = 30
Wep.Primary.Sound = Sound("Weapon_AK47.Single")
Wep.Primary.Damage = 120
Wep.Primary.Delay = 0.1
Wep.Primary.Recoil = 1
Wep.Primary.Cone = 0.02
Wep.Primary.NumShots = 1
AddNewWeapon(WEAPON_SLOT_PRIMARY, WEAPON_TYPE_GUN, Wep, "weapon_ak47", {font = "CSTypeDeath", letter = "b"})

Wep = {Primary = {}}
Wep.PrintName = "Shotgun"
Wep.HoldType = "shotgun"
Wep.ViewModel = Model("models/weapons/c_shotgun.mdl")
Wep.WorldModel = Model("models/weapons/w_shotgun.mdl")
Wep.Slot = 0
Wep.CrosshairType = "circle"
Wep.CrosshairRadius = 12
Wep.Primary.DefaultClip = 6
Wep.Primary.Sound = Sound("Weapon_XM1014.Single")
Wep.Primary.Damage = 60
Wep.Primary.Delay = 0.6
Wep.Primary.Recoil = 4
Wep.Primary.Cone = 0.1
Wep.Primary.NumShots = 6
AddNewWeapon(WEAPON_SLOT_PRIMARY, WEAPON_TYPE_GUN, Wep, "weapon_shotgun", {font = "HL2MPTypeDeath", letter = "0"})

Wep = {Primary = {}}
Wep.PrintName = "Uzi"
Wep.HoldType = "pistol"
Wep.ViewModel = Model("models/weapons/cstrike/c_smg_mac10.mdl")
Wep.WorldModel = Model("models/weapons/w_smg_mac10.mdl")
Wep.Slot = 0
Wep.CrosshairType = "circle"
Wep.CrosshairRadius = 8
Wep.Primary.DefaultClip = 30
Wep.Primary.Sound = Sound("Weapon_MAC10.Single")
Wep.Primary.Damage = 60
Wep.Primary.Delay = 0.05
Wep.Primary.Recoil = 0.3
Wep.Primary.Cone = 0.05
Wep.Primary.NumShots = 1
AddNewWeapon(WEAPON_SLOT_PRIMARY, WEAPON_TYPE_GUN, Wep, "weapon_uzi", {font = "CSTypeDeath", letter = "l"})

Wep = {Primary = {}}
Wep.PrintName = "Pistol"
Wep.HoldType = "pistol"
Wep.ViewModel = Model("models/weapons/cstrike/c_pist_usp.mdl")
Wep.WorldModel = Model("models/weapons/w_pist_usp_silencer.mdl")
Wep.Slot = 1
Wep.Primary.DefaultClip = 13
Wep.Primary.Sound = Sound("Weapon_USP.SilencedShot")
Wep.Primary.Damage = 60
Wep.Primary.Delay = 0.3
Wep.Primary.Recoil = 1
Wep.Primary.Cone = 0.01
Wep.Primary.NumShots = 1
AddNewWeapon(WEAPON_SLOT_SECONDARY, WEAPON_TYPE_GUN, Wep, "weapon_pistol", {font = "CSTypeDeath", letter = "a"})

Wep = {Primary = {}}
Wep.PrintName = "Magnum"
Wep.HoldType = "revolver"
Wep.ViewModel = Model("models/weapons/c_357.mdl")
Wep.WorldModel = Model("models/weapons/w_357.mdl")
Wep.Slot = 1
Wep.Primary.DefaultClip = 6
Wep.Primary.Sound = Sound("Weapon_357.Single")
Wep.Primary.Damage = 120
Wep.Primary.Delay = 0.5
Wep.Primary.Recoil = 1
Wep.Primary.Cone = 0.01
Wep.Primary.NumShots = 1
AddNewWeapon(WEAPON_SLOT_SECONDARY, WEAPON_TYPE_GUN, Wep, "weapon_magnum", {font = "HL2MPTypeDeath", letter = "."})

Wep = {Primary = {}}
Wep.PrintName = "Fists"
Wep.HoldType = "fist"
Wep.ViewModel = Model("models/weapons/c_hands.mdl")
Wep.WorldModel = ""
Wep.Slot = 2
Wep.CanDrop = false
Wep.Primary.Sound = Sound("Weapon_Knife.Slash")
Wep.Primary.SoundMiss = Sound("Weapon_Crowbar.Single")
Wep.Primary.Range = 64
Wep.Primary.Damage = 40
Wep.Primary.Delay = 0.4
function Wep:SecondaryAttack()
	if not self:CanPrimaryAttack() then return end
	self:SetNextSecondaryFire(CurTime() + 0.6)

	self.Owner:SetLuaAnimation("kick_right")

	if not IsValid(self.Owner) then return end

	if self.Owner.LagCompensation then -- for some reason not always true
		self.Owner:LagCompensation(true)
	end

	local spos = self.Owner:GetShootPos()
	local sdest = spos + (self.Owner:GetAimVector() * 128)

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
		dmg:SetDamage(80)
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
AddNewWeapon(WEAPON_SLOT_MELEE, WEAPON_TYPE_MELEE, Wep, "weapon_fists", {font = "CSTypeDeath", letter = "H"})

Wep = {Primary = {}}
Wep.PrintName = "Knife"
Wep.HoldType = "knife"
Wep.ViewModel = Model("models/weapons/cstrike/c_knife_t.mdl")
Wep.WorldModel = Model("models/weapons/w_knife_t.mdl")
Wep.Slot = 2
Wep.Primary.Sound = Sound("Weapon_Knife.Slash")
Wep.Primary.SoundMiss = Sound("Weapon_Crowbar.Single")
Wep.Primary.Range = 64
Wep.Primary.Damage = 120
Wep.Primary.Delay = 0.4
AddNewWeapon(WEAPON_SLOT_MELEE, WEAPON_TYPE_MELEE, Wep, "weapon_knife", {font = "CSTypeDeath", letter = "j"})

Wep = {Primary = {}}
Wep.PrintName = "Crowbar"
Wep.HoldType = "melee"
Wep.ViewModel = Model("models/weapons/c_crowbar.mdl")
Wep.WorldModel = Model("models/weapons/w_crowbar.mdl")
Wep.Slot = 2
Wep.Primary.Sound = Sound("Weapon_Knife.Slash")
Wep.Primary.SoundMiss = Sound("Weapon_Crowbar.Single")
Wep.Primary.Range = 128
Wep.Primary.Damage = 120
Wep.Primary.Delay = 0.8
AddNewWeapon(WEAPON_SLOT_MELEE, WEAPON_TYPE_MELEE, Wep, "weapon_crowbar", {font = "HL2MPTypeDeath", letter = "6"})
