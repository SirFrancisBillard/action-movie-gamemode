function GM:CreateTeams()
	TEAM_ACTION = 1
	team.SetUp(TEAM_ACTION, "Players", Color(255, 0, 0))
	team.SetClass(TEAM_ACTION, "player_action")

	team.SetSpawnPoint(TEAM_SPECTATOR, "worldspawn")
end
