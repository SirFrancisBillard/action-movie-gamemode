DEFINE_BASECLASS("player_default")

local PLAYER = {}

PLAYER.DisplayName = "Player"
PLAYER.WalkSpeed = 250
PLAYER.RunSpeed = 250

function PLAYER:Loadout()
	self.Player:StripWeapons()
	self.Player:RemoveAllAmmo()

	local primary = g_PrimarySlotWeapons[tostring(self.Player:GetInfo("loadout_primary"))] or g_DefaultWeapons[WEAPON_TYPE_PRIMARY]
	local secondary = g_SecondarySlotWeapons[tostring(self.Player:GetInfo("loadout_secondary"))] or g_DefaultWeapons[WEAPON_TYPE_SECONDARY]
	local melee = g_MeleeSlotWeapons[tostring(self.Player:GetInfo("loadout_melee"))] or g_DefaultWeapons[WEAPON_TYPE_MELEE]

	self.Player:Give(primary)
	self.Player:Give(secondary)
	self.Player:Give(melee)

	self.Player:SelectWeapon(primary)
end

function PLAYER:SetupDataTables()
	self.Player:NetworkVar("Int", 0, "LastAttack")
	self.Player:NetworkVar("Int", 1, "Kevlar")
	self.Player:NetworkVar("Int", 2, "Killstreak")
end

function PLAYER:Spawn()
	self.Player:SetLastAttack(0)
	self.Player:SetKevlar(0)
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