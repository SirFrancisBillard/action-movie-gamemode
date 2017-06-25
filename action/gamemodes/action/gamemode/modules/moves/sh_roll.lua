
local RollSound = Sound("Player.Roll")

local KeyToAnim = {
	[IN_FORWARD] = "roll",
	[IN_MOVELEFT] = "roll_left",
	[IN_MOVERIGHT] = "roll_right",
	[IN_BACK] = "roll_back"
}

hook.Add("KeyPress", "Action.HandleRolling", function(ply, key)
	ply.LastRoll = ply.LastRoll or 0

	if ply:Alive() and key == IN_SPEED and (CurTime() - ply.LastRoll) > 0.9 and not ply.Rolling then
		ply.LastRoll = CurTime()

		local anim = "roll"
		for k, v in pairs(KeyToAnim) do
			if ply:KeyDown(k) then
				anim = v
				break
			end
		end

		ply:SetLuaAnimation(anim)
		ply:EmitSound(RollSound)
		ply.Rolling = anim

		timer.Simple(0.5, function()
			if IsValid(ply) and ply:IsPlayer() then
				ply.Rolling = nil
			end
		end)
	end
end)

local speed = CreateConVar("action_roll_speed", "10000", FCVAR_REPLICATED, "How fast combat rolls are.")

local AnimToMove = {
	["roll"] = function(mv, cmd)
		mv:SetForwardSpeed(speed:GetInt())
		cmd:SetForwardMove(speed:GetInt())
	end,
	["roll_left"] = function(mv, cmd)
		mv:SetSideSpeed(-speed:GetInt())
		cmd:SetSideMove(-speed:GetInt())
	end,
	["roll_right"] = function(mv, cmd)
		mv:SetSideSpeed(speed:GetInt())
		cmd:SetSideMove(speed:GetInt())
	end,
	["roll_back"] = function(mv, cmd)
		mv:SetForwardSpeed(-speed:GetInt())
		cmd:SetForwardMove(-speed:GetInt())
	end
}

hook.Add("SetupMove", "Action.HandleRolling", function(ply, mv, cmd)
	if ply.Rolling ~= nil and AnimToMove[ply.Rolling] then
		AnimToMove[ply.Rolling](mv, cmd)
	end
end)
