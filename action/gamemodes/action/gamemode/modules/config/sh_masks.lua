
-- lmao hotline miami ripoff

local i = 0

local function enum()
	i = i + 1
	return i
end

MASK_A = enum()

g_MaskData = {
	[MASK_A] = {
		Name = "Alex",
		Model = "models/melon.mdl",
		Init = function() end,
		OnEquip = function(ply) end,
		OnHolster = function(ply) end
	}
}
