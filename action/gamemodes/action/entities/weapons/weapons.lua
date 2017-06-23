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

local TypeToBase = {
	[WEAPON_TYPE_GUN] = "weapon_basegun",
	[WEAPON_TYPE_MELEE] = "weapon_basemelee"
}

local function GenerateWeaponTable(type)
	return weapons.Get(TypeToBase[type])
end

function AddNewWeapon(slot, type, tab, cls)
	local new = GenerateWeaponTable(type)

	game.AddAmmoType({name = "ammotype_" .. cls})
	if CLIENT then
		language.Add("ammotype_" .. cls .. "_ammo", "Bullets")
	end

	for k, v in pairs(tab) do
		if new[k] then
			new[k] = v
		end
	end

	if not g_DefaultWeapons[type] then
		g_DefaultWeapons[type] = cls
	end

	weapons.Register(new, cls)
end

local Wep = {Primary = {}}
Wep.PrintName = "AK-47"
Wep.HoldType = "ar2"
Wep.ViewModel = Model("models/weapons/cstrike/c_rif_ak47.mdl")
Wep.WorldModel = Model("models/weapons/w_rif_ak47.mdl")
Wep.Slot = 0
Wep.Primary.DefaultClip = 30
Wep.Primary.Automatic = true
Wep.Primary.Sound = Sound("Weapon_AK47.Single")
Wep.Primary.Damage = 120
Wep.Primary.Delay = 0.1
Wep.Primary.Recoil = 1
Wep.Primary.Cone = 0.03
Wep.Primary.NumShots = 1
AddNewWeapon(WEAPON_SLOT_PRIMARY, WEAPON_TYPE_GUN, Wep, "weapon_ak47")

Wep = {Primary = {}}
Wep.PrintName = "Shotgun"
Wep.HoldType = "shotgun"
Wep.ViewModel = Model("models/weapons/c_shotgun.mdl")
Wep.WorldModel = Model("models/weapons/w_shotgun.mdl")
Wep.Slot = 0
Wep.CrosshairType = "circle"
Wep.CrosshairRadius = 12
Wep.Primary.DefaultClip = 6
Wep.Primary.Automatic = false
Wep.Primary.Sound = Sound("Weapon_XM1014.Single")
Wep.Primary.Damage = 60
Wep.Primary.Delay = 0.6
Wep.Primary.Recoil = 4
Wep.Primary.Cone = 0.1
Wep.Primary.NumShots = 6
AddNewWeapon(WEAPON_SLOT_PRIMARY, WEAPON_TYPE_GUN, Wep, "weapon_shotgun")

Wep = {Primary = {}}
Wep.PrintName = "Uzi"
Wep.HoldType = "pistol"
Wep.ViewModel = Model("models/weapons/cstrike/c_smg_mac10.mdl")
Wep.WorldModel = Model("models/weapons/w_smg_mac10.mdl")
Wep.Slot = 0
Wep.Primary.DefaultClip = 30
Wep.Primary.Automatic = true
Wep.Primary.Sound = Sound("Weapon_MAC10.Single")
Wep.Primary.Damage = 60
Wep.Primary.Delay = 0.05
Wep.Primary.Recoil = 0.3
Wep.Primary.Cone = 0.1
Wep.Primary.NumShots = 1
AddNewWeapon(WEAPON_SLOT_PRIMARY, WEAPON_TYPE_GUN, Wep, "weapon_uzi")

