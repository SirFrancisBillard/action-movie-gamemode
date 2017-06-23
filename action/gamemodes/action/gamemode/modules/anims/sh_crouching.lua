
function GM:HandlePlayerDucking( ply, velocity )

	if ( !ply:Crouching() ) then return false end

	if ( velocity:Length2DSqr() > 0.25 ) then
		ply.CalcIdeal = ACT_MP_CROUCHWALK
	else
		ply.CalcIdeal = ACT_MP_CROUCH_IDLE
	end

	return true

end
