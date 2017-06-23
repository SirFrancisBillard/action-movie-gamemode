
function GM:PlayerInitialSpawn(ply)
	player_manager.SetPlayerClass(ply, "player_action")
	ply:SetTeam(TEAM_ACTION)
	ply:Spawn()
end
