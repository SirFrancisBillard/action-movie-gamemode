
function HandlePlayerKillstreak(ply, ks)
	if ks % 5 == 0 then
		ply:ChatPrint("Killstreak: " .. ks)
		ply:ConCommand("play music/killstreak.wav")
	end
end

hook.Add("DoPlayerDeath", "Action.Killstreaks", function(ply, atk, dmg)
	if IsValid(atk) and atk:IsPlayer() then
		atk:SetKillstreak(atk:GetKillstreak() + 1)
		HandlePlayerKillstreak(atk, atk:GetKillstreak())
	end
end)
