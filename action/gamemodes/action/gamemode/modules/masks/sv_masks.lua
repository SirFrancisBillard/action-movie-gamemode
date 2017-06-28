
local PLAYER = FindMetaTable("Player")

function PLAYER:SetMask(mask)
	self:SetNWInt("action_mask", tonumber(mask))
end

util.AddNetworkString("action_sendmask")

net.Receive("action_sendmask", function(len, ply)
	local mask = tonumber(net.ReadInt(5))
	if type(g_MaskData[mask]) ~= "table" then
		print("MASK IS INVALID")
		return
	end
	ply:SetMask(mask)
end)

hook.Add("PlayerInitialSpawn", "Action.OpenMaskMenu", function(ply)
	if IsValid(ply) and ply:IsPlayer() then
		ply:SetMask(math.random(1, #g_MaskData))
		ply:ConCommand("action_mask")
	end
end)
