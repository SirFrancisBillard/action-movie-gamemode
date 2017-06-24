
function GM:KeyRelease(ply, key)
	if key == IN_ZOOM and ply:Alive() and ply:GetGrenades() > 0 and (CurTime() - ply:GetLastGrenade()) > 1 then
		ply:SetLastGrenade(CurTime())
		ply:SetGrenades(ply:GetGrenades() - 1)
		ply:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_HL2MP_GESTURE_RANGE_ATTACK_FIST, true)

		if SERVER then
			local nade = ents.Create("ent_throwngrenade")

			if not IsValid(nade) then return end

			nade:SetOwner(ply)
			nade:SetPos(ply:EyePos())
			nade:SetAngles(ply:EyeAngles())
			nade:Spawn()

			local phys = nade:GetPhysicsObject()
			if not IsValid(phys) then nade:Remove() return end

			local velocity = ply:GetAimVector()
			velocity = velocity * 1200
			phys:ApplyForceCenter(velocity)
		end
	end
end
