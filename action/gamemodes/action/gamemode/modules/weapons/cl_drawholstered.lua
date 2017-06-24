
local enabled = CreateConVar("action_drawholsteredweapons", "1", FCVAR_REPLICATED, "Whether or not to draw holstered weapons on your character.")

local drawguns = {
	["weapon_ak47"] = {
		model = "models/weapons/w_rif_ak47.mdl",
		bone = "ValveBiped.Bip01_Spine2",
		pos = Vector(-1.841, 2.062, -7.473),
		ang = Angle(-24.001, 4.126, 9.432)
	},
	["weapon_uzi"] = {
		model = "models/weapons/w_smg_mac10.mdl",
		bone = "ValveBiped.Bip01_Spine2",
		pos = Vector(-3.369, 3.322, -3.161),
		ang = Angle(-43.687, 0, 0)
	},
	["weapon_shotgun"] = {
		model = "models/weapons/w_shotgun.mdl",
		bone = "ValveBiped.Bip01_Spine2",
		pos = Vector(-1.984, 3.766, 0),
		ang = Angle(-35.045, 7.276, -0.079)
	},
	["weapon_pistol"] = {
		model = "models/weapons/w_pist_usp_silencer.mdl",
		bone = "ValveBiped.Bip01_R_Thigh",
		pos = Vector(3.486, -4.626, -5.095),
		ang = Angle(0, 0, 81.879)
	},
	["weapon_magnum"] = {
		model = "models/weapons/w_357.mdl",
		bone = "ValveBiped.Bip01_R_Thigh",
		pos = Vector(0.312, -1.303, -5.095),
		ang = Angle(0, 0, 81.879)
	},
	["weapon_crowbar"] = {
		model = "models/weapons/w_crowbar.mdl",
		bone = "ValveBiped.Bip01_Spine2",
		pos = Vector(1.52, 5.071, 0),
		ang = Angle(-159.075, 0.637, 146.455)
	},
	["weapon_knife"] = {
		model = "models/weapons/w_knife_t.mdl",
		bone = "ValveBiped.Bip01_L_Thigh",
		pos = Vector(0.004, 1.648, 3.996),
		ang = Angle(0, 86.433, 89.723)
	}
}

local grenades = {
	[1] = {
		bone = "ValveBiped.Bip01_Spine",
		pos = Vector(-3.379, -7.185, 4.494),
		ang = Angle(-86.863, 14.223, 13.911)
	},
	[2] = {
		bone = "ValveBiped.Bip01_Spine",
		ppos = Vector(-3.379, -7.185, 4.494),
		ang = Angle(-86.863, 14.223, 13.911)
	},
	[3] = {
		bone = "ValveBiped.Bip01_Spine",
		pos = Vector(-3.379, -7.185, 4.494),
		ang = Angle(-86.863, 14.223, 13.911)
	}
}

local function DrawWeapons(ply)
	if not enabled:GetBool() or not ply:Alive() then return end

	for k, v in pairs(drawguns) do
		local wep = ply:GetActiveWeapon()

		if IsValid(wep) and wep:IsWeapon() and wep:GetClass() == k then continue end

		if not ply:HasWeapon(k) then continue end

		local bone = ply:LookupBone(v.bone)

		if not bone then continue end

		local pos, ang = Vector(0, 0, 0), Angle(0, 0, 0)
		local m = ply:GetBoneMatrix(bone)

		if m then
			pos, ang = m:GetTranslation(), m:GetAngles()
		end

		pos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z

		ang:RotateAroundAxis(ang:Up(), v.ang.y)
		ang:RotateAroundAxis(ang:Right(), v.ang.p)
		ang:RotateAroundAxis(ang:Forward(), v.ang.r)

		local model = {model = v.model, pos = pos, angle = ang}

		render.Model(model)
	end

	for i = 1, #grenades do
		if ply:GetGrenades() >= i then
			local bone = ply:LookupBone(grenades[i].bone)

			if not bone then continue end

			local pos, ang = Vector(0, 0, 0), Angle(0, 0, 0)
			local m = ply:GetBoneMatrix(bone)

			if m then
				pos, ang = m:GetTranslation(), m:GetAngles()
			end

			pos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z

			ang:RotateAroundAxis(ang:Up(), v.ang.y)
			ang:RotateAroundAxis(ang:Right(), v.ang.p)
			ang:RotateAroundAxis(ang:Forward(), v.ang.r)

			render.Model({model = "models/weapons/w_eq_fraggrenade.mdl", pos = pos, angle = ang})
		end
	end
end

hook.Add("PostPlayerDraw", "Action.DrawHolsteredWeapons", DrawWeapons)
