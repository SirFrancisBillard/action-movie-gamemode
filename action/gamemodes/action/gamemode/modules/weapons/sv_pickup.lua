
function GM:PlayerCanPickupWeapon(ply, wep)
	local cls = wep:GetClass()

	-- cleanup
	if g_PrimarySlotWeapons[cls] and not ply:GetHasPrimaryWeapon() then
		return true
	elseif g_SecondarySlotWeapons[cls] and not ply:GetHasSecondaryWeapon() then
		return true
	elseif g_MeleeSlotWeapons[cls] and not ply:GetHasMeleeWeapon() then
		return true
	end

	return wep:GetClass() == "weapon_fists"
end
