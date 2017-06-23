
function GM:PlayerCanPickupWeapon(ply, wep)
	local cls = wep:GetClass()

	-- cleanup
	if g_PrimarySlotWeapons[cls] and not ply:GetHasPrimaryWeapon() then
		ply:SetHasPrimaryWeapon(true)
		return true
	elseif g_SecondarySlotWeapons[cls] and not ply:GetHasSecondaryWeapon() then
		ply:SetHasSecondaryWeapon(true)
		return true
	elseif g_MeleeSlotWeapons[cls] and not ply:GetHasMeleeWeapon() then
		ply:SetHasMeleeWeapon(true)
		return true
	end

	return false
end
