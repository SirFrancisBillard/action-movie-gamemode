
-- lmao hotline miami ripoff

local i = 0

local function enum()
	i = i + 1
	return i
end

MASK_BEAR = enum()
MASK_DOG = enum()
MASK_EAGLE = enum()
MASK_MONKEY = enum()
MASK_PANDA = enum()
MASK_PIG = enum()
MASK_RAM = enum()

MASK_BUSH = enum()
MASK_CLINTON = enum()
MASK_NIXON = enum()
MASK_OBAMA = enum()

g_MaskData = {
	[MASK_BEAR] = {
		Name = "Mark",
		Desc = [[Deadly fists]],
		Image = "mark.png",
		Model = "models/snowzgmod/payday2/masks/maskmark.mdl",
		Init = function()
			hook.Add("EntityTakeDamage", "Action.Mask.Mark", function(ent, dmg)
				local atk = dmg:GetAttacker()
				if IsValid(ent) and ent:IsPlayer() and IsValid(atk) and atk:IsPlayer() and atk:GetMask() == MASK_BEAR then
					local wep = atk:GetActiveWeapon()
					if IsValid(wep) and wep:GetClass() == "weapon_fists" then
						dmg:ScaleDamage(2)
					end
				end
			end)
		end,
		OnEquip = function(ply) end,
		OnHolster = function(ply) end
	},
	[MASK_DOG] = {
		Name = "Arnold",
		Desc = [[]],
		Image = "arnold.png",
		Model = "models/snowzgmod/payday2/masks/maskarnold.mdl",
		Init = function() end,
		OnEquip = function(ply) end,
		OnHolster = function(ply) end
	},
	[MASK_EAGLE] = {
		Name = "Chuck",
		Desc = [[]],
		Image = "chuck.png",
		Model = "models/snowzgmod/payday2/masks/maskchuck.mdl",
		Init = function() end,
		OnEquip = function(ply) end,
		OnHolster = function(ply) end
	},
	[MASK_MONKEY] = {
		Name = "Tayte",
		Desc = [[]],
		Image = "tayte.png",
		Model = "models/snowzgmod/payday2/masks/maskmonkeybusiness.mdl",
		Init = function() end,
		OnEquip = function(ply) end,
		OnHolster = function(ply) end
	},
	[MASK_PANDA] = {
		Name = "Jean Claude",
		Desc = [[]],
		Image = "jeanclaude.png",
		Model = "models/snowzgmod/payday2/masks/maskjeanclaude.mdl",
		Init = function() end,
		OnEquip = function(ply) end,
		OnHolster = function(ply) end
	},
	[MASK_PIG] = {
		Name = "Devin",
		Desc = [[]],
		Image = "devin.png",
		Model = "models/snowzgmod/payday2/masks/maskthehog.mdl",
		Init = function() end,
		OnEquip = function(ply) end,
		OnHolster = function(ply) end
	},
	[MASK_RAM] = {
		Name = "Dolph",
		Desc = [[]],
		Image = "dolph.png",
		Model = "models/snowzgmod/payday2/masks/maskdolph.mdl",
		Init = function() end,
		OnEquip = function(ply) end,
		OnHolster = function(ply) end
	},
	[MASK_BUSH] = {
		Name = "George W. Bush",
		Desc = [[Oil profits]],
		Image = "bush.png",
		Model = "models/snowzgmod/payday2/masks/maskthe43rd.mdl",
		Init = function()
			hook.Add("DoPlayerDeath", "Action.Masks.Bush", function(ply)
				if IsValid(ply) and ply:IsPlayer() and ply:GetMask() == MASK_BUSH then
					local pos = ply:GetPos()

					timer.Simple(2, function()
						local boom = EffectData()
						boom:SetOrigin(pos)
						util.Effect("Explosion", boom, true, true)

						util.BlastDamage(ply or NULL, ply or NULL, pos, 250, 150)
					end)
				end
			end)
		end,
		OnEquip = function(ply) end,
		OnHolster = function(ply) end
	},
	[MASK_CLINTON] = {
		Name = "Bill Clinton",
		Desc = [[Sexual relations]],
		Image = "clinton.png",
		Model = "models/snowzgmod/payday2/masks/maskthe42nd.mdl",
		Init = function() end,
		OnEquip = function(ply) end,
		OnHolster = function(ply) end
	},
	[MASK_NIXON] = {
		Name = "Richard Nixon",
		Desc = [[Cover it up]],
		Image = "nixon.png",
		Model = "models/snowzgmod/payday2/masks/maskthe37th.mdl",
		Init = function() end,
		OnEquip = function(ply) end,
		OnHolster = function(ply) end
	},
	[MASK_OBAMA] = {
		Name = "Barack Obama",
		Desc = [[Free healthcare]],
		Image = "obama.png",
		Model = "models/snowzgmod/payday2/masks/maskthe44th.mdl",
		Init = function()
			timer.Create("Action.Masks.Obama", 2, 0, function()
				for k, v in pairs(player.GetAll()) do
					if IsValid(v) and v:IsPlayer() and v:GetMask() == MASK_OBAMA and v:Health() < v:GetMaxHealth() then
						v:SetHealth(math.min(v:Health() + 5, v:GetMaxHealth()))
					end
				end
			end)
		end,
		OnEquip = function(ply) end,
		OnHolster = function(ply) end
	}
}

local PLAYER = FindMetaTable("Player")

function PLAYER:GetMask()
	return self:GetNWInt("action_mask", math.random(1, #g_MaskData))
end

for k, v in pairs(g_MaskData) do
	if isfunction(v.Init) then
		v.Init()
	end
end
