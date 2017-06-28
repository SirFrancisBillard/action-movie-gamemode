
local enabled = CreateConVar("action_drawmasks", "1", FCVAR_REPLICATED, "Whether or not to draw masks on your character.")

local function DrawMasks(ply)
	if not enabled:GetBool() or not ply:Alive() then return end

	local ID = ply:LookupAttachment("eyes")
	local attach = ply:GetAttachment(ID)

	local model = {model = g_MaskData[ply:GetMask()].Model, pos = attach.Pos, angle = attach.Ang}

	render.Model(model)
end

hook.Add("PostPlayerDraw", "Action.DrawMasks", DrawMasks)
