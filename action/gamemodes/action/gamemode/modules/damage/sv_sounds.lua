
local BulletSound = Sound("Player.BulletHit")
local ClubSound = Sound("Player.Club")
local SlashSound = Sound("Player.Slash")
local FallSound = Sound("Player.Fall")

local SoundsFromDamageType = {
	[DMG_BULLET] = BulletSound,
	[DMG_CLUB] = ClubSound,
	[DMG_SLASH] = SlashSound,
	[DMG_FALL] = FallSound
}

hook.Add("EntityTakeDamage", "Action.VariousNoises", function(ply, dmg)
	if IsValid(ply) and ply:IsPlayer() and SoundsFromDamageType[dmg:GetDamageType()] then
		ply:EmitSound(SoundsFromDamageType[dmg:GetDamageType()])
	end
end)
