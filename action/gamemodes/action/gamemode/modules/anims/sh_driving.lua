
function GM:HandlePlayerDriving( ply )

	if ( !ply:InVehicle() ) then return false end

	local pVehicle = ply:GetVehicle()

	if ( !pVehicle.HandleAnimation && pVehicle.GetVehicleClass ) then
		local c = pVehicle:GetVehicleClass()
		local t = list.Get( "Vehicles" )[ c ]
		if ( t && t.Members && t.Members.HandleAnimation ) then
			pVehicle.HandleAnimation = t.Members.HandleAnimation
		else
			pVehicle.HandleAnimation = true -- Prevent this if block from trying to assign HandleAnimation again.
		end
	end

	local class = pVehicle:GetClass()

	if ( isfunction( pVehicle.HandleAnimation ) ) then
		local seq = pVehicle:HandleAnimation( ply )
		if ( seq != nil ) then
			ply.CalcSeqOverride = seq
		end
	end

	if ( ply.CalcSeqOverride == -1 ) then -- pVehicle.HandleAnimation did not give us an animation
		if ( class == "prop_vehicle_jeep" ) then
			ply.CalcSeqOverride = ply:LookupSequence( "drive_jeep" )
		elseif ( class == "prop_vehicle_airboat" ) then
			ply.CalcSeqOverride = ply:LookupSequence( "drive_airboat" )
		elseif ( class == "prop_vehicle_prisoner_pod" && pVehicle:GetModel() == "models/vehicles/prisoner_pod_inner.mdl" ) then
			-- HACK!!
			ply.CalcSeqOverride = ply:LookupSequence( "drive_pd" )
		else
			ply.CalcSeqOverride = ply:LookupSequence( "sit_rollercoaster" )
		end
	end
	
	local use_anims = ( ply.CalcSeqOverride == ply:LookupSequence( "sit_rollercoaster" ) || ply.CalcSeqOverride == ply:LookupSequence( "sit" ) )
	if ( use_anims && ply:GetAllowWeaponsInVehicle() && IsValid( ply:GetActiveWeapon() ) ) then
		local holdtype = ply:GetActiveWeapon():GetHoldType()
		if ( holdtype == "smg" ) then holdtype = "smg1" end

		local seqid = ply:LookupSequence( "sit_" .. holdtype )
		if ( seqid != -1 ) then
			ply.CalcSeqOverride = seqid
		end
	end

	return true
end
