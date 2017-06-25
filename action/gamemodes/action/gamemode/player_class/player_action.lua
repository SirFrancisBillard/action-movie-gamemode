DEFINE_BASECLASS("player_default")

local PLAYER = {}

PLAYER.DisplayName = "Player"
PLAYER.WalkSpeed = 300
PLAYER.RunSpeed = 300

local primaries = {"weapon_ak47", "weapon_shotgun", "weapon_uzi"}
local secondaries = {"weapon_pistol", "weapon_magnum"}
local melees = {"weapon_crowbar", "weapon_knife"}

function PLAYER:Loadout()
	self.Player:StripWeapons()
	self.Player:RemoveAllAmmo()

	local primary = primaries[math.random(1, #primaries)] -- g_PrimarySlotWeapons[tostring(self.Player:GetInfo("loadout_primary"))] and g_PrimarySlotWeapons[tostring(self.Player:GetInfo("loadout_primary"))] or g_DefaultWeapons[WEAPON_TYPE_PRIMARY]
	local secondary = secondaries[math.random(1, #secondaries)] -- g_SecondarySlotWeapons[tostring(self.Player:GetInfo("loadout_secondary"))] and g_SecondarySlotWeapons[tostring(self.Player:GetInfo("loadout_secondary"))] or g_DefaultWeapons[WEAPON_TYPE_SECONDARY]
	local melee = melees[math.random(1, #melees)] -- g_MeleeSlotWeapons[tostring(self.Player:GetInfo("loadout_melee"))] and g_MeleeSlotWeapons[tostring(self.Player:GetInfo("loadout_melee"))] or g_DefaultWeapons[WEAPON_TYPE_MELEE]

	self.Player:Give(primary)
	self.Player:Give(secondary)
	self.Player:Give(melee)

	self.Player:SelectWeapon(primary)

	self.Player:SetHasPrimaryWeapon(true)
	self.Player:SetHasSecondaryWeapon(true)
	self.Player:SetHasMeleeWeapon(true)
end

-- issue: networked vars are not networked to all clients
-- this breaks using GetGrenades in cl_drawholstered.lua

function PLAYER:SetupDataTables()
	self.Player:NetworkVar("Bool", 0, "HasPrimaryWeapon")
	self.Player:NetworkVar("Bool", 1, "HasSecondaryWeapon")
	self.Player:NetworkVar("Bool", 2, "HasMeleeWeapon")
	self.Player:NetworkVar("Bool", 3, "HasEquipmentItem")

	self.Player:NetworkVar("Int", 0, "LastAttack")
	self.Player:NetworkVar("Int", 1, "LastGrenade")
	self.Player:NetworkVar("Int", 2, "LastKill")
	self.Player:NetworkVar("Int", 3, "Grenades")
	self.Player:NetworkVar("Int", 4, "Killstreak")
end

local nades = CreateConVar("action_grenade_amount", "3", FCVAR_REPLICATED, "How many grenades are given on spawn.")

function PLAYER:Spawn()
	self.Player:SetHasPrimaryWeapon(false)
	self.Player:SetHasSecondaryWeapon(false)
	self.Player:SetHasMeleeWeapon(false)
	self.Player:SetHasEquipmentItem(false)

	self.Player:SetLastAttack(0)
	self.Player:SetLastGrenade(0)
	self.Player:SetLastKill(0)
	self.Player:SetGrenades(nades:GetInt())
	self.Player:SetKillstreak(0)

	self.Player:SetCanZoom(false)
	self.Player:SetNoCollideWithTeammates(false)

	self:SetModel()

	self.Player:SetWalkSpeed(self.WalkSpeed)
	self.Player:SetRunSpeed(self.RunSpeed)
end

function PLAYER:SetModel()
	local mdl_choice = GAMEMODE.PlayerModels[math.random(1, #GAMEMODE.PlayerModels)]
	self.Player:SetModel(mdl_choice[math.random(1, #mdl_choice)])
	self.Player.model_table = mdl_choice
end

player_manager.RegisterClass("player_action", PLAYER, "player_default")
