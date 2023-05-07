// All credit goes to AlexYeahNot https://github.com/AlexYeahNot/asl-scripts for the original script.
// This is just a simplified version of his script.

state("farcry3_d3d11", "DirectX11")
{
	int passedMissions : "FC3_d3d11.dll", 0x01F082E8, 0x2AC, 0x10, 0x1C, 0x50, 0x10;
	int lastQteGood: "FC3_d3d11.dll", 0x01E38864, 0x20, 0x80, 0x29C, 0x90, 0x4;
	int loading : "FC3_d3d11.dll", 0x01E718FC, 0x14, 0x1C, 0x16C, 0xF8;

	int towers : "FC3_d3d11.dll", 0x01F082E8, 0x2C4, 0x10, 0x1C, 0x50, 0x30;
	int quests : "FC3_d3d11.dll", 0x01F082E8, 0x248, 0x10, 0x1C, 0x50, 0x20;
}

startup
{
	settings.Add("missions", true, "Split on Story Missions");
	settings.Add("towers", false, "Split on Towers");
	settings.Add("quests", false, "Split on Side Quests");
}

onStart
{
    // This is part of a "cycle fix", makes sure the timer always starts at 0.00
    timer.IsGameTimePaused = true;
}

start
{
	// Start when first Mission loads
	return (old.loading == 0 && current.loading == 2 && current.passedMissions > 38);
}

split
{
	// Split on Missions and last QTE (Good Ending only)
	if ((current.passedMissions == old.passedMissions + 1 ||
		(current.lastQteGood == 2 && old.lastQteGood == 1) && (current.passedMissions == 36 || current.passedMissions == 37)) &&
		settings["missions"])
		return true;
	
	// Split on Towers
	if (current.towers == old.towers + 1 && current.loading != 2 && settings["towers"])
		return true;

	// Split on Side Quests
	return current.quests == old.quests + 1 && current.loading != 2 && settings["quests"]
}

isLoading
{
	return current.loading == 2;
}
