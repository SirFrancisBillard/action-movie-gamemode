
local MatTypeToEffect = {
	[MAT_FLESH] = "BloodImpact"
}

function GM:EntityFireBullets(ent, data)
	data.Callback = function(atk, tr, dmg)
		if MatTypeToEffect[tr.MatType] then
			local effect = EffectData()
			effect:SetOrigin(tr.HitPos)
			util.Effect(MatTypeToEffect[tr.MatType], effect, true, true)
		end
	end

	return true
end
