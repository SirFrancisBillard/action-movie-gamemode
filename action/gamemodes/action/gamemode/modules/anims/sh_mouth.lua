
function GM:MouthMoveAnimation( ply )

	local flexes = {
		ply:GetFlexIDByName( "jaw_drop" ),
		ply:GetFlexIDByName( "left_part" ),
		ply:GetFlexIDByName( "right_part" ),
		ply:GetFlexIDByName( "left_mouth_drop" ),
		ply:GetFlexIDByName( "right_mouth_drop" )
	}

	local weight = ply:IsSpeaking() and math.Clamp( ply:VoiceVolume() * 2, 0, 2 ) or 0

	for k, v in pairs( flexes ) do

		ply:SetFlexWeight( v, weight )

	end

end
