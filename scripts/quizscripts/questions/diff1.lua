--this is the beginner easy file

local Tab = {
    {
        Question = "In which file are entities made?",
	    An1 = "entities2.xml",
	    An2 = "entities.xml",
	    An3="Entities.xml",
	    An4="itempools.xml",
	    RightAn = 1
    },
	{
		Question =  "How do you load another file?",
		An1 = "include(v)",
		An2 = "load(v)",
		An3 = "io.open(v)",
		An4 = "io.include(v)",
		RightAn = 1
	},
	{
		Question =  "How do you get a entity’s data?",
		An1 = "entity.Data",
		An2 = "entity:ReturnData()",
		An3 = "entity:GetData()",
		An4 = "entity:ToENT():GetData()",
		RightAn = 3
	},
	{
		Question =  "How do you alter an entity's velocity?",
		An1 = "entity:MoveFoward()",
		An2 = "entity:MoveFoward(entity.Velocity)",
		An3 = "entity.Velocity + Vector()",
		RightAn = 3
	},
	{
		Question =  "How would you make an entity take damage?",
		An1 = "entity.TakeDamage()",
		An2 = "entity:TakeDamage()",
		An3 = "entity:RemoveHP()",
		An4 = "entity:RemoveHealth()",
		RightAn = 2
	}

}

return Tab