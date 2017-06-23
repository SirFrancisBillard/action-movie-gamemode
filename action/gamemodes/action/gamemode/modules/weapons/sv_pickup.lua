
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
		if ply:HasWeapon("weapon_fists") then
			ply:StripWeapon("weapon_fists")
		end
		ply:SetHasMeleeWeapon(true)
		return true
	end

	return true
end
