
function HandlePlayerKillstreak(ply, ks)
	if ks % 5 == 0 then
		timer.Simple(0.1, function()
			if not IsValid(ply) or not ply:IsPlayer() then return end
			ply:ChatPrint("Killstreak: " .. ks)
			ply:ConCommand("play music/killstreak.wav")
		end)
	end
end

hook.Add("DoPlayerDeath", "Action.Killstreaks", function(ply, atk, dmg)
	if IsValid(atk) and atk:IsPlayer() and atk ~= ply then
		atk:SetKillstreak(atk:GetKillstreak() + 1)
		HandlePlayerKillstreak(atk, atk:GetKillstreak())
	end
end)
