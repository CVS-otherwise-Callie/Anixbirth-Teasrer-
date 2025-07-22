--this is the beginner medium file

local Tab = {
	--[[{
		Question =  {"How would you use DamageFlags? /", "Where do you check damageflags?"},
		An1 = "In MC_TAKE_DAMAGE, checking what type",
		An2 = "In a entity, checking how it deals damage",
		An3 = "In the player, checking how it deals damage",
		An4 = "In MC_DEAL_DAMAGE, checking what type",
		RightAn = 1
	},]]
	{
		Question =  "How do you find entities within a given radius?",
		An1 = "Isaac.FindEntitiesInRange()",
		An2 = "Isaac.FindByType()",
		An3 = "Isaac.FindInRadius()",
		RightAn = 3
	},
	{
		Question =  {"Which variables of a cord do you", "use to connect it to two entities?", "(in order)"},
		An1 = "SpawnerEntity, Child",
		An2 = "SpawnerEntity, Target",
		An3 = "Parent, Target",
		An4 = "Parent, Child",
		RightAn = 3
	},

}

return Tab