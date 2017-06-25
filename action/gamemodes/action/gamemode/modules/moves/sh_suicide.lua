
-- what

concommand.Add("kms", function(ply, cmd, args)
	ply.LastSuicide = ply.LastSuicide or 0

	if ply:Alive() and (CurTime() - ply.LastSuicide) > 4 then
		local wep = ply:GetActiveWeapon()

		if IsValid(wep) and wep.HoldType == "pistol" then
			ply.LastSuicide = CurTime()
			local snd = wep.Primary.Sound or Sound("Weapon_Pistol.Single")
			ply:SetLuaAnimation("kys_pistol")

			timer.Simple(1.5, function()
				if IsValid(ply) and ply:IsPlayer() then
					ply:EmitSound(snd)
					if SERVER then
						ply:Kill()
					end
				end
			end)
		end
	end
end)
