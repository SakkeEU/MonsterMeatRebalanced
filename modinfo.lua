name = "Monster Meat Rebalanced"
description = "This mod balance the monster meat by reducing its usefulness in the following ways: removes it from the top tier crockpot recipes (Meatballs/Bacon and Eggs/Perogies), reduces the werepigs loot, limits the number of times birds in the birdcage can eat it each day without consequenses."
author = "SakkeEU"
version = "1.0"

forumthread = ""

api_version = 10

dont_starve_compatible = false
reign_of_giants_compatible = false
shipwrecked_compatible = false
dst_compatible = true

all_clients_require_mod = false
client_only_mod = false

server_filter_tags = {"balanced", "hard", "hardcore", "food"}

priority = 0

icon_atlas = "monstermeat.xml"
icon = "monstermeat.tex"

configuration_options =
{
	{
		name = "recipesnerf",
		label = "Recipes balance",
		hover = "further balance Meatballs/Bacon and Eggs/Perogies by reducing their effectiveness.",
		options =	{
						{description = "No", data = 0},
						{description = "Yes", data = 1},
					},
		default = 0,
	}
}
