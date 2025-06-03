--chore: merge this by throwing it back into the constants file at the end
local mod = FHAC
FHAC.CVSMonsters = {
	Fivehead = mod:ENT("Fivehead"),
    Sixheadtop= mod:ENT("Sixhead Top"),
    Sixheadbottom = mod:ENT("Sixhead Bottom"),
    Onehead = mod:ENT("Onehead"),
    Floater = mod:ENT("Floater"),
    Dried = mod:ENT("Dried"),
	Mutilated = FHAC:ENT("Mutilated"),
    Neutralfly = mod:ENT("Neutral Fly"),
    Patient = mod:ENT("Patient"),
    Erythorcyte = mod:ENT("Erythorcyte"),
    Erythorcytebaby = mod:ENT("Erythorcytebaby"),
    Wost = mod:ENT("Wost"),
    Schmoot = mod:ENT("Schmoot"),
    Snidge = mod:ENT("Snidge"),
    --Dangler = mod:ENT("Dangler"),
    Drosslet = mod:ENT("Drosslet"),
    PitPatSpawner = mod:ENT("Pit Pat Spawner"),
    PitPat = mod:ENT("Pit Pat"),
    MushLoom = mod:ENT("Mush Loom"),
    Pinprick = mod:ENT("Pinprick"),
    SyntheticHorf = mod:ENT("Synthetic Horf"),
    GassedFly = mod:ENT("Gassed Fly"),
    FlyveBomber = mod:ENT("Plier"),
    Pallun = mod:ENT("Pallun"),
    Silly = mod:ENT("Silly"),
    String = mod:ENT("String"),
    StickyFly = mod:ENT("Sticky Fly"),
    WispWosp = mod:ENT("Wisp Wosp"),
    Stuckpoot = mod:ENT("Stuckpoot"),
    RainMonger = mod:ENT("Rain Monger"),
    TechGrudge = mod:ENT("Tech Grudge"),
    ZapperTeller = mod:ENT("Zapper Teller"),
    Log = mod:ENT("Log"),
    Stoner = mod:ENT("Stoner"),
    LightPressurePlateEntNull = mod:ENT("Light Pressure Plate Null Entity"),
    LarryKingJr = mod:ENT("Larry King Jr."),
    Babble = mod:ENT("Babble"),
    Toast = mod:ENT("Toast"),
    TaintedSilly = mod:ENT("Tainted Silly"),
    TaintedString = mod:ENT("Tainted String"),
    andEntity = mod:ENT("&"),
    Dunglivery = mod:ENT("Dunglivery"),
    Harmoor = mod:ENT("Harmoor"),
    Cowpat = mod:ENT("Cowpat"),
    Ulig = mod:ENT("Ulig"),
    HorfOnAStick = mod:ENT("Horf On A Stick"),
    Gobbo = mod:ENT("Gobbo"),
    Sho = mod:ENT("Sho"),
    Soot = mod:ENT("Soot"),
    Jim = mod:ENT("Jim"),
    NarcissismMirror = mod:ENT("Narcissism Mirror"),
    Woodhead = mod:ENT("Woodhead"),
    NarcissismReflections = mod:ENT("Narcissism Reflections"),
    Chomblet = mod:ENT("Chomblet"),
    Trilo = mod:ENT("Trilo"),
	SmallSack = mod:ENT("Small Nest"),
	SackKid = mod:ENT("Sack Kid"),
	FearFlower = mod:ENT("Fear Flower"),
    StallCreep = mod:ENT("Stall Creep"),
    WebbedCreep = mod:ENT("Webbed Creep"),
	AngeryMan = mod:ENT("Angery Man"),
	WebbedCarcass = mod:ENT("Webbed Carcass"),
	Bewebbed = mod:ENT("Bewebbed"),
	ReHost = mod:ENT("Rehost"),
	Suckup = mod:ENT("Suck Up"),
	PottedFatty = mod:ENT("Potted Fatty")
}

FHAC.CVSEffects = {
	ZapperTellerLightning = mod:ENT("Zapper Teller Lightning"),
    ClatterTellerTarget = mod:ENT("Clatter Teller Target"),
    FearFlowerFear = mod:ENT("Fear Flower Fear Effect"),
    BlackOverlayBox = mod:ENT("BlackOverlayBox"),
    NormalTextBox = mod:ENT("Text Box"),
    DekatesseraEffect = mod:ENT("Dekatessera Effect"),
	WideWeb = mod:ENT("Large Spiderweb")
}

mod:MixTables(FHAC.Monsters, FHAC.CVSMonsters)
mod:MixTables(FHAC.Effects, FHAC.CVSEffects)

--iam stuff
FHAC:LoadScripts("scripts.iam.monsters", {
	"fivehead",
	"floater",
	"neutralfly",
	"patient",
	"dried",
	"erythorcyte",
	"wost",
	"schmoot",
	"snidge",
	"drosslet",
	"pitpat",
	"mushloom",
	"pinprick",
	"synthetichorf",
	"gassedfly",
	"fly_ve-bomber", --HAHAHAH FUCK YOU EUAN TOO
	"pallun",
	"sillystring",
	"stickyfly",
	"wispwosp",
	"stuckpoot",
	"rainmonger",
	"zapperteller",
	"techgrudge",
	"log",
	"stoner",
	"lightpressureplatenullent",
	"larrykingjr",
	"sixheadbottom",
	"sixheadtop",
	"babble",
	"toast",
	"silly&stringtainted",
	"dunglivery",
	"cowpat",
	"ulig",
	"horfonastick",
	"soot",
	"jim",
	"narcissism mirror",
	"woodhead",
	"narcissim relfections",
	"chomblet",
	"trilo",
	"fearflower",
	"sackkid",
	"mutilated",
	"stallcreep",
	"webbedcreep",
	"smallsack",
	"angeryman",
	"webbedcarcass",
	"bewebbed",
	"rehost",
	"suckup",
	"pottedfatty"
})

FHAC:LoadScripts("scripts.iam.minibosses", {
	"narcissism", --narc!!
	"chomb"
})

FHAC:LoadScripts("scripts.iam", {
	"cvsunlocks",
	"levelreplaceshit",
	"customgrids"
})

FHAC:LoadScripts("scripts.iam.effects", {
	"zapperteller_lightning",
	"blackboxoverlay",
	"fear_flower_fear_effect",
	"dekatessera effect",
	"wideweb"
})

FHAC:LoadScripts("scripts.iam.familiars", {
	"snark",
	"marketableplushie",
	"lilana"
})

FHAC:LoadScripts("scripts.iam.items.actives", {
	"joke book",
	"straw doll",
	"corrupted file"
})

FHAC:LoadScripts("scripts.iam.items.trinkets", {
	"mystery milk",
	"the left ball"
})

FHAC:LoadScripts("scripts.iam.items.passives", {
	"stinky mushroom",
	"anal fissure",
	"big ol' bowl of sauerkraut",
	"empty death certificate",
	"stinky socks",
	"moldy bread"
})

FHAC:LoadScripts("scripts.iam.items.pickups" , {
	"bowl of sauerkraut",
	"birthday slice"
})

FHAC:LoadScripts("scripts.iam.jokes", {
	"gaprrr",
})

FHAC:LoadScripts("scripts.iam.characters", {
	"johannes",
	"johannesb",
	"pongon"
})

FHAC:LoadScripts("scripts.iam.challenges", {
	"therealbestiary",
})

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local mod = FHAC
local rng = RNG()
local game = Game()

-- functions first

function mod:DeliriumRoom()
	if #Isaac.FindByType(EntityType.ENTITY_DELIRIUM, -1, -1, false, false) > 0 then
		mod.IsDeliRoom = true
	else
		mod.IsDeliRoom = false
	end
end

function mod:getMinSec(totalSeconds)
    local minutes = math.floor(totalSeconds / 60)
    local seconds = math.floor(totalSeconds % 60)
    return minutes, seconds
end

function mod:GetClosestGridEntToPos(pos, ignorepoop, ignorehole, rocktab)
	local room = game:GetRoom()
	local imtheclosest = 9999999999999999538762658202121142272 --just a absurdly big number
	local closestgridpoint
	rocktab = rocktab or {GridEntityType.GRID_ROCK, GridEntityType.GRID_ROCKB, GridEntityType.GRID_ROCKT, GridEntityType.GRID_ROCK_ALT, 
	GridEntityType.GRID_SPIKES, GridEntityType.GRID_SPIKES_ONOFF, GridEntityType.GRID_LOCK, GridEntityType.GRID_TNT,
	GridEntityType.GRID_POOP, GridEntityType.GRID_WALL, GridEntityType.GRID_DOOR, GridEntityType.GRID_STAIRS, GridEntityType.GRID_STATUE, GridEntityType.GRID_ROCK_SS,
	GridEntityType.GRID_PILLAR, GridEntityType.GRID_ROCK_SPIKED, GridEntityType.GRID_ROCK_ALT2, GridEntityType.GRID_ROCK_GOLD, GridEntityType.GRID_FIREPLACE}
	for i = 0, room:GetGridSize() do
		local grid = room:GetGridEntity(i)
		if grid then
			local gridpoint = room:GetGridPosition(i)
			if mod:CheckTableContents(rocktab, grid:GetType()) then
				if gridpoint:Distance(pos) < imtheclosest and grid.CollisionClass ~= 0 then
					imtheclosest = gridpoint:Distance(pos)
					closestgridpoint = grid
				end
			end
		end
	end
	return closestgridpoint
end


function mod:GetClosestGridEntAlongAxis(pos, axis, ignorepoop, ignorehole, rocktab)
	local room = game:GetRoom()
	local imtheclosest = 9999999999999999538762658202121142272 --just a absurdly big number
	local closestgridpoint
	rocktab = rocktab or {GridEntityType.GRID_ROCK, GridEntityType.GRID_ROCKB, GridEntityType.GRID_ROCKT, GridEntityType.GRID_ROCK_ALT, 
	GridEntityType.GRID_SPIKES, GridEntityType.GRID_SPIKES_ONOFF, GridEntityType.GRID_LOCK, GridEntityType.GRID_TNT,
	GridEntityType.GRID_POOP, GridEntityType.GRID_WALL, GridEntityType.GRID_DOOR, GridEntityType.GRID_STAIRS, GridEntityType.GRID_STATUE, GridEntityType.GRID_ROCK_SS,
	GridEntityType.GRID_PILLAR, GridEntityType.GRID_ROCK_SPIKED, GridEntityType.GRID_ROCK_ALT2, GridEntityType.GRID_ROCK_GOLD, GridEntityType.GRID_FIREPLACE}
	for i = 0, room:GetGridSize() do
		local grid = room:GetGridEntity(i)
		if grid then
			local gridpoint = room:GetGridPosition(i)
			if axis == "X" then 
				if math.abs(gridpoint.Y - pos.Y) < 20 then
					if mod:CheckTableContents(rocktab, grid:GetType()) then
						if gridpoint:Distance(pos) < imtheclosest  and grid.CollisionClass ~= 0 then
							imtheclosest = gridpoint:Distance(pos)
							closestgridpoint = grid
						end
					end	
				end
			end
			if axis == "Y" then 
				if math.abs(gridpoint.X - pos.X) < 20 then
					if mod:CheckTableContents(rocktab, grid:GetType()) then
						if gridpoint:Distance(pos) < imtheclosest and grid.CollisionClass ~= 0 then
							imtheclosest = gridpoint:Distance(pos)
							closestgridpoint = grid
						end
					end
				end
			end
		end
	end
	--if closestgridpoint == nil then return mod:GetClosestGridEntToPos(pos) end
	return closestgridpoint or error("no grid given")
end

function mod:GetClosestGridEntAlongAxisDirection(pos, axis, ignorepoop, ignorehole, dir, rocktab, dist, room)
	local room = room or game:GetRoom()
	local imtheclosest = 9999999999999999538762658202121142272 --just a absurdly big number
	dist = dist or 0
	local closestgridpoint
	rocktab = rocktab or {GridEntityType.GRID_ROCK, GridEntityType.GRID_ROCKB, GridEntityType.GRID_ROCKT, GridEntityType.GRID_ROCK_ALT, 
	GridEntityType.GRID_SPIKES, GridEntityType.GRID_SPIKES_ONOFF, GridEntityType.GRID_LOCK, GridEntityType.GRID_TNT,
	GridEntityType.GRID_POOP, GridEntityType.GRID_WALL, GridEntityType.GRID_DOOR, GridEntityType.GRID_STAIRS, GridEntityType.GRID_STATUE, GridEntityType.GRID_ROCK_SS,
	GridEntityType.GRID_PILLAR, GridEntityType.GRID_ROCK_SPIKED, GridEntityType.GRID_ROCK_ALT2, GridEntityType.GRID_ROCK_GOLD, GridEntityType.GRID_FIREPLACE}
	for i = 0, room:GetGridSize() do
		local grid = room:GetGridEntity(i)
		if grid then
			local gridpoint = room:GetGridPosition(i)
			local function UpdatePos(gridpoint)
				if mod:CheckTableContents(rocktab, grid:GetType()) then
					if gridpoint:Distance(pos) < imtheclosest and gridpoint:Distance(pos) > dist and grid.CollisionClass ~= 0 then
						imtheclosest = gridpoint:Distance(pos)
						closestgridpoint = grid
					end
				end
			end
			if axis == "X" then
				if math.abs(gridpoint.Y - pos.Y) <= 25 then
					if dir == 90 or dir == -90 and gridpoint.X > pos.X then
						UpdatePos(gridpoint)
					elseif dir == 180 or dir == -270 and gridpoint.X < pos.X then
						UpdatePos(gridpoint)
					end
				end
			end
			if axis == "Y" then
				if math.abs(gridpoint.X - pos.X) <= 25 then
					if dir == 0 or dir == -180 and gridpoint.Y < pos.Y then
						UpdatePos(gridpoint)
					elseif dir == 180 or dir == -360 and gridpoint.Y > pos.Y then
						UpdatePos(gridpoint)
					end
				end
			end
		end
	end
	--if closestgridpoint == nil then return mod:GetClosestGridEntToPos(pos) end
	return closestgridpoint or mod:GetClosestGridEntAlongAxis(pos, axis, ignorepoop, ignorehole, rocktab)
end

function mod:RemoveEntFromRoom(npc)

	AnixbirthSaveManager.GetFloorSave().anixbirthsaveData = AnixbirthSaveManager.GetFloorSave().anixbirthsaveData or {}
	local ta = AnixbirthSaveManager.GetFloorSave().anixbirthsaveData
	ta.PreSavedEnts = ta.PreSavedEnts or {}

	if ta.PreSavedEnts[tostring(npc.InitSeed)] then
		ta.PreSavedEnts[tostring(npc.InitSeed)] = nil
	end
	
end

function mod:SaveEntToRoom(npc, removeondeath)

	removeondeath = removeondeath or false

	AnixbirthSaveManager.GetFloorSave().anixbirthsaveData = AnixbirthSaveManager.GetFloorSave().anixbirthsaveData or {}
	local ta = AnixbirthSaveManager.GetFloorSave().anixbirthsaveData
	ta.PreSavedEnts = ta.PreSavedEnts or {}

	if (npc:IsDead() and removeondeath) then
		ta.PreSavedEnts[tostring(npc.InitSeed)] = nil
		return
	end

	if not ta.PreSavedEnts[tostring(npc.InitSeed)] then
		local tab = {}
		tab.Room = game:GetLevel():GetCurrentRoomDesc().Data
		tab.ListIndex = game:GetLevel():GetCurrentRoomDesc().ListIndex
		tab.RoomVar = game:GetLevel():GetCurrentRoomDesc().Variant
		tab.Level = game:GetLevel():GetAbsoluteStage()
		tab.Stage = game:GetLevel():GetStage()
		ta.PreSavedEnts[tostring(npc.InitSeed)] = tab
	end


	local tab = {
		Type = npc.Type,
		Variant = npc.Variant,
		Subtype = npc.SubType,
		PositionX = npc.Position.X,
		PositionY = npc.Position.Y,
		VelocityX = npc.Velocity.X,
		VelocityY = npc.Velocity.Y,
		Spanwner = npc.Spawner,
	}

	if npc:GetData() then
		tab.Data = npc:GetData()
	end

	for k, v in pairs(tab) do
		ta.PreSavedEnts[tostring(npc.InitSeed)][k] = v
	end

	ta.PreSavedEnts[tostring(npc.InitSeed)].NPC = npc

end


function mod:LoadSavedRoomEnts()

	local tab = AnixbirthSaveManager.GetFloorSave().anixbirthsaveData

	if not tab then return end
	if not tab.PreSavedEnts then return end

	local function CheckNPCInitDat(npc)
		for k, v in ipairs(Isaac.GetRoomEntities()) do
			if v.Position:Distance(Vector(npc.PositionX, npc.PositionY)) == 0 and not v:GetData().isanixbirthCopy and npc.InitSeed ~= v.InitSeed then
				return false
			end
		end
		return true
	end

	for k, v in pairs(tab.PreSavedEnts) do
		if v.RoomVar == game:GetLevel():GetCurrentRoomDesc().Variant and
		v.ListIndex == game:GetLevel():GetCurrentRoomDesc().ListIndex and 
		v.Stage == game:GetLevel():GetStage() and v.Type and v.Variant and v.Subtype and CheckNPCInitDat(v) then
			tab.PreSavedEnts[k] = nil
			local ent = Isaac.Spawn(v.Type, v.Variant, v.Subtype, Vector(v.PositionX, v.PositionY), Vector(v.VelocityX, v.VelocityY), nil)
			local d = ent:GetData()
			for h, i in pairs(v.Data) do
				if not d[h] then
					d[h] = i
				end
			end
			d.isanixbirthCopy = true
			ent:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			d.init = false
		elseif not CheckNPCInitDat(v) then
			tab.PreSavedEnts[k] = nil
		end
	end
end


--this is a shit function use the other one
function mod:GetEntInRoom(ent, avoidnpc, npc, radius)
	radius = radius or 350
	local targets = {}
	if avoidnpc then
		for _, ent in ipairs(Isaac.GetRoomEntities()) do
			if ent:IsActiveEnemy() and ent:IsVulnerableEnemy() and not ent:IsDead()
			and not ent:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) and (ent.Position - npc.Position):Length() < radius
			and not(ent.Type == npc.Type and ent.Variant == npc.Variant)  then
				table.insert(targets, ent)
			end
		end
	else
		for _, entity in ipairs(Isaac.GetRoomEntities()) do
			if entity:IsActiveEnemy() and entity:IsVulnerableEnemy() and not entity:IsDead()
			and not entity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) and (entity.Position - npc.Position):Length() < radius  then
				table.insert(targets, ent)
			end
		end
	end
	if (#targets == 0) then
		return npc:GetPlayerTarget()
	end
	local answer = targets[math.random(1, #targets)]
	return answer
end

--the one above is a shit function use this
function mod:GetSpecificEntInRoom(myent, npc, radius)
	radius = radius or 350
	local targets = {}
	for _, ent in ipairs(Isaac.GetRoomEntities()) do
		if not ent:IsDead()
		and not ent:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) and (ent.Position - npc.Position):Length() < radius
		and ent.Type == myent.ID and ent.Variant == myent.Var and ent.SubType == 0 then
			table.insert(targets, ent)
		end
	end
	if (#targets == 0) then
		local target = npc:GetPlayerTarget()
		local targetpos = mod:confusePos(npc, target.Position, 5, nil, nil)
		npc:GetData().specificTargTypeIsPlayer = true
		return target
	else
		npc:GetData().specificTargTypeIsPlayer = false
	end
	local answer = targets[math.random(1, #targets)]
	return answer
end


function mod:GetRoomNameByType(type)
	if type == 0 then
		return "Null"
	elseif type == 1 then
		return "Normal"
	elseif type == 2 then
		return "Shop"
	elseif type == 3 then
		return "Error"
	elseif type == 4 then
		return "Treasure"
	elseif type == 5 then
		return "Boss"
	elseif type == 6 then
		return "Miniboss"
	elseif type == 7 then
		return "Secret"
	elseif type == 8 then
		return "Super Secret"
	elseif type == 9 then
		return "Arcade"
	elseif type == 10 then
		return "Curse"
	elseif type == 11 then
		return "Challenge"
	elseif type == 12 then
		return "Library"
	elseif type == 13 then
		return "Sacrifice"
	elseif type == 14 then
		return "Devil"
	elseif type == 15 then
		return "Angel"
	elseif type == 16 then
		return "Dungeon"
	elseif type == 17 then
		return "Bossrush"
	elseif type == 18 then
		return "Bedroom"
	elseif type == 19 then
		return "Barren Bedroom"
	elseif type == 20 then
		return "Chest Room"
	elseif type == 21 then
		return "Dice Room"
	elseif type == 22 then
		return "Black Market"
	elseif type == 23 then
		return "Greed Exit"
	elseif type == 24 then
		return "Planetarium"
	--[[elseif type == 25 then
		return "Teleport Room (Entrance)"
	elseif type == 26 then
		return "Teleport Room (Exit)"]]
	elseif type == 27 then
		return "Secret Exit?"
	elseif type == 28 then
		return "BLUE"
	elseif type == 29 then
		return "Ultra Secret"
	end
end


function mod:CheckForEntInRoom(npc, id, var, sub)
	local room = game:GetRoom()
	local npcsepcifics = {}
	local npcsepcificsvar = {}
	id = id or true
	var = var or true
	sub = sub or false
	local rooments = {}
	local roomentsvar = {}
	for _, ent in ipairs(Isaac.GetRoomEntities()) do
		if (not ent:HasEntityFlags(EntityFlag.FLAG_FRIENDLY)) then
			table.insert(rooments, ent.Type)
		end
	end
	local isType = mod:CheckTableContents(rooments, npc.Type)
	if var == false and sub == false then return isType end
	if var and isType then
		for _, ent in ipairs(Isaac.GetRoomEntities()) do
			if (not ent:HasEntityFlags(EntityFlag.FLAG_FRIENDLY)) then
				table.insert(roomentsvar, ent.Variant)
			end
		end
	end
	local isVar = mod:CheckTableContents(roomentsvar, npc.Variant)
	if sub and isVar then
		local npcsepcifics = {}
		local rooments = {}
		for _, ent in ipairs(Isaac.GetRoomEntities()) do
			if (ent:IsActiveEnemy() and ent:IsVulnerableEnemy() and not ent:IsDead()
			and not ent:HasEntityFlags(EntityFlag.FLAG_FRIENDLY)) then
				table.insert(rooments, ent.SubType)
			end
		end
		sub = mod:CheckTableContents(rooments, npc.SubType)
	end
	if not sub then return isVar end
	return sub
end

function mod:CheckForOnlyEntInRoom(npcs, id, var, sub)
	local room = game:GetRoom()
	local npcsepcifics = {}
	local npcsepcificsvar = {}
	id = id or true
	var = var or true
	sub = sub or false
	local rooments = {}
	local roomentsvar = {}
	for _, element in pairs(npcs) do
		table.insert(npcsepcifics, element.ID)
	end
	for _, ent in ipairs(Isaac.GetRoomEntities()) do
		if (ent:IsActiveEnemy() and ent:IsVulnerableEnemy() and not ent:IsDead()
		and not ent:HasEntityFlags(EntityFlag.FLAG_FRIENDLY)) then
			table.insert(rooments, ent.Type)
		end
	end
	local isType = mod:ValidifyTables(rooments, npcsepcifics)
	if (var == false and sub == false) or isType == false then return isType end
	if var and isType then
		for _, element in pairs(npcs) do
			table.insert(npcsepcificsvar, element.Var)
		end
		for _, ent in ipairs(Isaac.GetRoomEntities()) do
			if (ent:IsActiveEnemy() and ent:IsVulnerableEnemy() and not ent:IsDead()
			and not ent:HasEntityFlags(EntityFlag.FLAG_FRIENDLY)) then
				table.insert(roomentsvar, ent.Variant)
			end
		end
	end
	local isVar = mod:ValidifyTables(roomentsvar, npcsepcificsvar)
	if sub and isVar then
		local npcsepcifics = {}
		local rooments = {}
		for _, element in pairs(npcs) do
			table.insert(npcsepcifics, element.Sub)
		end
		for _, ent in ipairs(Isaac.GetRoomEntities()) do
			if (ent:IsActiveEnemy() and ent:IsVulnerableEnemy() and not ent:IsDead()
			and not ent:HasEntityFlags(EntityFlag.FLAG_FRIENDLY)) then
				table.insert(rooments, ent.SubType)
			end
		end
		sub = mod:ValidifyTables(rooments, npcsepcifics)
	end
	if not sub then return isVar end
	return sub
end


mod.ImInAClosetPleaseHelp = false

function mod:setUpCutscene(stage, room, noisaac, pos, music)
	noisaac = noisaac or true

	local rDD = game:GetLevel():GetCurrentRoomDesc().Data
	local useVar = rDD.Variant
	local seed = game:GetSeeds()

	if noisaac then
		seed:AddSeedEffect(SeedEffect.SEED_NO_HUD)
		seed:AddSeedEffect(SeedEffect.SEED_INVISIBLE_ISAAC)
	end

	if game:GetLevel():GetAbsoluteStage() == LevelStage.STAGE8 and useVar == 6 and mod.ImInAClosetPleaseHelp then mod.StartCutscene = true return end

	if game:GetLevel():GetAbsoluteStage() == LevelStage.STAGE8 then
		if useVar ~= 6 then
			Isaac.ExecuteCommand("goto d." .. room)
			mod.ImInAClosetPleaseHelp = false
		elseif noisaac then
			for i = 1, game:GetNumPlayers() do
				game:GetPlayer(i).Position = game:GetRoom():GetCenterPos()
				mod.ImInAClosetPleaseHelp = true
				Isaac.Spawn(162, 2901, -1, game:GetRoom():GetCenterPos(), Vector.Zero, nil)
			end
		end
	else
		Isaac.ExecuteCommand("stage " .. stage)
	end
end

function mod:MakeAllSoundsFadeOut()
	for k, entity in ipairs(Isaac:GetRoomEntities()) do
		local sfx = SFXManager()
	end
end

function mod:AltLockedClosetCutscene()

	local rDD = game:GetLevel():GetCurrentRoomDesc().Data
	local useVar = rDD.Variant
	local seed = game:GetSeeds()
	seed:AddSeedEffect(SeedEffect.SEED_NO_HUD)
	seed:AddSeedEffect(SeedEffect.SEED_INVISIBLE_ISAAC)

	local ms = MusicManager()

	if not mod.StartCutscene then
		mod.YouCanEndTheAltCutsceneNow = false
	end

	if mod.StartCutscene and ms:GetCurrentMusicID() ~= Isaac.GetMusicIdByName("ruinsecret") then
		ms:Play(Isaac.GetMusicIdByName("ruinsecret"), 1)
	end

	for k, v in ipairs(Isaac.GetRoomEntities()) do
		if v.Type == 1 or v.Type==1000 then
		else
			v:Remove()
		end
	end
	for i = 1, game:GetNumPlayers() do
		game:GetPlayer(i).Position = game:GetRoom():GetCenterPos()
		game.Challenge = 6
		game:GetPlayer(i):UpdateCanShoot()
	end

	if mod:CheckForEntInRoom({Type = mod.Monsters.LightPressurePlateEntNull.ID, Variant = mod.Monsters.LightPressurePlateEntNull.Var, SubType = 0}, true, true, false) == false then
		local ent = Isaac.Spawn(mod.Monsters.LightPressurePlateEntNull.ID, mod.Monsters.LightPressurePlateEntNull.Var, 0, Vector.Zero, Vector.Zero, nil)
		ent:GetData().wasSpawned = true
	end

	if mod.YouCanEndTheAltCutsceneNow then
		game:GetSeeds():AddSeedEffect(SeedEffect.SEED_PREVENT_ALL_CURSES) --no winning with this one
		ms:Fadeout(0.01)
		mod:FadeOutBlack(4, 3)
	end

	if game:GetLevel():GetAbsoluteStage() == LevelStage.STAGE8 and useVar == 6 and mod.ImInAClosetPleaseHelp then mod.StartCutscene = true return end

	if game:GetLevel():GetAbsoluteStage() == LevelStage.STAGE8 then
		if useVar ~= 6 then
			Isaac.ExecuteCommand("goto d.6")
			mod.ImInAClosetPleaseHelp = false
		else
			for i = 1, game:GetNumPlayers() do
				game:GetPlayer(i).Position = game:GetRoom():GetCenterPos()
				mod.ImInAClosetPleaseHelp = true
				Isaac.Spawn(162, 2901, -1, game:GetRoom():GetCenterPos(), Vector.Zero, nil)
			end
		end
	else
		Isaac.ExecuteCommand("stage 13a")
	end
end

function mod:PostDeathSegments(npc, segments, ishead)
	local d = npc:GetData()
	if not ishead and not d.FinishedEverything then
		if not segments or #segments == 0 then return end
		table.remove(segments, 1)
		local ent = segments[1]
		local dat = ent:GetData()
		for k, butt in ipairs(Isaac.FindByType(mod.Monsters.LarryKingJr.ID, mod.Monsters.LarryKingJr.Var)) do
			if HasPossibleParentSegs(butt, d) then
				npc.Parent = segments[1]
				butt:GetData().SegNumber = butt:GetData().SegNumber - 1
			end
		end
		local buttdat = segments[#segments]:GetData()
		buttdat.IsButt = true
		buttdat.name = "Butt"
		DoDataThing(d, dat)
	elseif d.IsSegment then
		for k, butt in ipairs(Isaac.FindByType(mod.Monsters.LarryKingJr.ID, mod.Monsters.LarryKingJr.Var)) do
			if HasPossibleParentSegs(butt, d) and butt:GetData().SegNumber > d.SegNumber then
				butt:GetData().SegNumber = butt:GetData().SegNumber - 1
			end
		end
	end
	d.FinishedEverything = true
end

function mod:GetAliveEntitiesInDist(npc, dist) --check if jacket made this
	local tab = {}
	for k, v in ipairs(Isaac.GetRoomEntities()) do
		if npc.Position:Distance(v.Position) > 0 and npc.Position:Distance(v.Position) < dist and v:Exists() and not v:IsDead() then
			table.insert(tab, v)
		end
	end
	return tab
end

function mod:AddTempItem(item, player, callback) --REMINDER: REWORK THESE TWO INTO ITEM WISPS!!!! THIS IS IMPORTANT!!!!
	player = player or Isaac.GetPlayer()
	local dat = AnixbirthSaveManager.GetRunSave(player).anixbirthsaveData or player:GetData()

	item = item or CollectibleType.COLLECTIBLE_SAD_ONION
	callback = callback or ModCallbacks.MC_POST_NEW_ROOM
	dat.TemporaryItems = dat.TemporaryItems or {}

	player:AddCollectible(item, 0, false, nil, 15)
	table.insert(dat.TemporaryItems, {Item = item, Player = player, Callback = callback, Num = #dat.TemporaryItems + 1})

end

function mod:RemoveTempItem(items)
	if not items or #items == 0 then return end 
	for i = 1, #items do
		local tab = items[i]
		if not tab then return end

		if tab.hasGone then return end

		tab.hasGone = true

		tab.Player = tab.Player or Isaac.GetPlayer()
		mod.scheduleCallback(function()
			if tab and tab.Num then		
				tab.Player:RemoveCollectible(tab.Item, true)
				if tab.Num <= #items then
					table.remove(items, tab.Num)
				end
			end
		end, 1, tab.Callback)
	end
end

function mod:PostUpdateRemoveTempItems(player)
	local dat = AnixbirthSaveManager.GetRunSave(player).anixbirthsaveData

	if not dat.TemporaryItems then return end
	mod:RemoveTempItem(dat.TemporaryItems)
end

function mod:ReplacePedestal(num, item, poof)
	local itemConfig = Isaac.GetItemConfig()
	poof = poof or true
	local pedestal = item:ToPickup()
	if item.Type == EntityType.ENTITY_PICKUP and item.Variant == PickupVariant.PICKUP_COLLECTIBLE then
        local itemcon = itemConfig:GetCollectible(pedestal.SubType)
        if itemcon and not itemcon:HasTags(ItemConfig.TAG_QUEST) then
			if poof then
				Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, item.Position, item.Velocity, item)
			end
			pedestal:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, num, true, true, true)
		end
	end
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local player = Isaac.GetPlayer()

mod.LuaFont = Font()
mod.LuaFont:Load("font/luaminioutlined.fnt") --:Load("mods/Anixbirth-Teasrer-/resources/font/TheFuture.fnt") --


local rng = RNG()
function mod:ShowRoomText()
	local room = StageAPI.GetCurrentRoom()
	local rDD = game:GetLevel():GetCurrentRoomDesc().Data
	local center = StageAPI.GetScreenCenterPosition()
	local bottomright = StageAPI.GetScreenBottomRight()
	local scale = 1 --make this dss changeable?
	local text = ""
	local vartext = ""
	local bcenter = Vector(center.X, bottomright.Y - 152 * 2)
	local ismodtext = false
	local useVar = rDD.Variant

	if not game:GetSeeds():HasSeedEffect(SeedEffect.SEED_NO_HUD) then

		if room and room.Layout then
			text = text .. tostring(room.Layout.Variant) .. " " .. room.Layout.Name
		else
			if useVar >= 45000 and useVar <= 60000 then
				ismodtext = true
				useVar = useVar - 44999
				text = "(HOPE) "
			end

			text = text .. rDD.Name
			vartext = tostring(useVar)
		end

		if not ismodtext then

			--dont question the process
			if rDD.Type ~= 5 then
				if text and string.find(text, "New Room") or string.find(text, "copy") or string.find(text, "Copy") or text == "" or string.find(text, "Shop") or string.find(text, "Dungeon") then
					text = game:GetLevel():GetName()
				end
			end

			if rDD.Type ~= 5 and rDD.Type ~= 6 and rDD.Type ~= 27 and rDD.Type ~= 24 and rDD.Type >= 2 then
				text = text .. ": " .. mod:GetRoomNameByType(rDD.Type)
			elseif rDD.Type == 5 then
				text = mod:removeSubstring(text, "(copy)")
			elseif rDD.Type == 6 then
				text = mod:GetRoomNameByType(rDD.Type) .. ": " .. text
			end

		end

		if Isaac.GetChallenge() == Challenge.CHALLENGE_DELETE_THIS then
			if not game:IsPaused() then
			local pastext = text
			text = ""
			for i = 0, tonumber(string.len(pastext)) do
				local letter = string.sub(pastext, i, i)
				local randint = math.random(1, 15)
				if randint == 1 then
					letter = string.char(math.random(65, 65 + 25))
				elseif randint == 2 then
					letter = string.char(math.random(65, 65 + 25)):lower()
				end
				text = text..letter
			end
			local pastext = vartext
			vartext = ""
			for i = 0, tonumber(string.len(pastext)) do
				if i ~= "-" or i ~= "" then
				local letter = string.sub(pastext, i, i)
				if math.random(1, 5) == 1 then
					letter = math.random(1, 9)
				end
				vartext = vartext..tostring(letter)
				end
			end
			if math.random(3) == 3 then
				glitchedtext = text
				glitchedvar = vartext
			end
			end
		else
			glitchedtext = nil
			glitchedvar = nil
		end

		local y = Isaac.GetScreenHeight() / 3 - 95

		if not glitchedtext then
			if text and #text ~= 0 then text = "- " .. text .. " -" end
			if vartext and #vartext ~= 0 then vartext = "- "..vartext.." -" end
		else
			if text and #text ~= 0 then text = "- "..glitchedtext.." -" end
			if vartext and #vartext ~= 0 and not StageAPI.GetCurrentRoom() then vartext = "- "..glitchedvar.." -" end
		end

		if StageAPI.GetCurrentRoom() then
			text = mod:removeSubstring(text, StageAPI:GetCurrentRoomID())
		end

		local size = mod.LuaFont:GetStringWidth(text) * scale
		local varsize = mod.LuaFont:GetStringWidth(vartext) * scale

		--bcenter = player.Position
		mod.LuaFont:DrawStringScaled(text, bcenter.X - (size/2), y, scale, scale, KColor(1,1,1,0.5), 0, false)
		mod.LuaFont:DrawStringScaled(vartext, bcenter.X - (varsize / 2), y + 10, scale, scale, KColor(1,1,1,0.5), 0, false)

	end
end

function mod:ShowFortuneDeath()
	if AnixbirthSaveManager.GetSettingsSave().fortunesonDeath and AnixbirthSaveManager.GetSettingsSave().fortunesonDeath == 1 and mod.DSSavedata.fortuneDeathChance ~= 0 and mod.DSSavedata.customFortunes == 1 then
		if math.random(mod.DSSavedata.fortuneDeathChance, 10) == 10 then 
			FHAC:ShowFortune()
		end 
	end
end

function mod:SpawnRandomDried()
	local game = Game()
    local level = game:GetLevel()
    local roomDescriptor = level:GetCurrentRoomDesc()
    local roomConfigRoom = roomDescriptor.Data
	if FHAC.DSSavedata.randomDried ~= 1 and mod.spawnedDried~=true and not mod:CheckForEntInRoom({Type = mod.Monsters.Dried.ID, Variant = mod.Monsters.Dried.Var, SubType = 0}, true, true, false) and game:GetLevel():GetCurrentRoomDesc().Data.Type == 1 and game:GetLevel():GetCurrentRoomDesc().Data.Variant <= 1151 and roomConfigRoom.StageID==2 then
		mod.driedRooms = {}
		for i = 1,  math.random(FHAC.DSSavedata.randomDried) do
			local pos = Game():GetRoom():FindFreePickupSpawnPosition(Game():GetRoom():GetRandomPosition(0), 1, true, false)
			local dried = Isaac.Spawn(mod.Monsters.Dried.ID, mod.Monsters.Dried.Var, 6, pos, Vector.Zero, nil)
            dried:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		end
	end
	mod.spawnedDried = true
end

function mod:curRoomModGFX()

	local level = game:GetLevel()
	local room = game:GetRoom()
	if level:GetStage() == LevelStage.STAGE7 then
		rng:SetSeed(room:GetDecorationSeed(), 0)
		local gridgfx = StageAPI.GridGfx()
		gridgfx.Rocks = mod.FloorGrids[rng:RandomInt(#mod.FloorGrids) + 1].Rocks
		gridgfx.PitFiles = mod.FloorGrids[rng:RandomInt(#mod.FloorGrids) + 1].PitFiles
		gridgfx.AltPitFiles = mod.FloorGrids[rng:RandomInt(#mod.FloorGrids) + 1].AltPitFiles
		return StageAPI.RoomGfx(nil, gridgfx, nil, nil)
	end

	local roomType = room:GetType()
	local backdropType = game:GetRoom():GetBackdropType()
	local existingGfx = (StageAPI.GetCurrentRoom() and StageAPI.GetCurrentRoom().Data.RoomGfx)
	if roomType == RoomType.ROOM_SECRET then
		--return mod.SecretBackdrop
	elseif roomType == RoomType.ROOM_DUNGEON then
		--return mod.CrawlspaceBackdrop
	elseif (roomType == RoomType.ROOM_CHALLENGE) and not existingGfx  then
		return mod.ChallengeBackdrop
	elseif not existingGfx then
		if backdropType == 1 then
			return mod.BasementBackdrop
		elseif backdropType == 5 then
			return mod.CatacombsBackdrop
		end
	end
end

function mod:RemoveAllSpecificItemEffects(player)
	local d = player:GetData()
	if d.AnalFissureCreep then
		player:RemoveCostume(Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_IPECAC), false)
	end
	d.JokeBookFireDelay = 0
    d.AnalFissureCreep = false
	d.AnalFissureCreepInit = false
    mod.StrawDollActiveIsActive = false
end

function mod:CVSNewRoom()

	if StageAPI then

		if mod.roomBackdrop and mod.roomBackdropFrom then
			if game:GetLevel():GetCurrentRoomDesc().ListIndex ~= mod.roomBackdropFrom 
			or StageAPI.GetCurrentRoom() ~= mod.roomBackdropFromStageAPI 
			or game:GetSeeds():GetStageSeed(game:GetLevel():GetStage()) ~= mod.roomBackdropFromLevel then
				mod.roomBackdrop = nil
				mod.roomBackdropFrom = nil
				mod.roomBackdropFromStageAPI = nil
				mod.roomBackdropFromLevel = nil
			end
		end

		local roomGfx = mod:curRoomModGFX()

		if roomGfx then
			if type(roomGfx) == "function" then
				local outGfx = roomGfx()
				if outGfx then
					--StageAPI.ChangeRoomGfx(outGfx)
				end
			else
				--StageAPI.ChangeRoomGfx(roomGfx)
			end
		end
	end

	local levelswithBlocks = {
		BackdropType.BASEMENT,
		BackdropType.CELLAR
	}


	local room = game:GetRoom()
    for i = 0, room:GetGridSize() do
        if room:GetGridEntity(i) and room:GetGridEntity(i):GetType() == GridEntityType.GRID_ROCKB and mod:CheckTableContents(levelswithBlocks, room:GetBackdropType()) then
            local sprite = room:GetGridEntity(i):GetSprite()
			sprite:ReplaceSpritesheet(0, "gfx/grid/stages/rocks_" .. room:GetBackdropType() .. ".png")
			sprite:LoadGraphics()
        end
    end
end

--thx ff

mod.CVSFamsToBeEvaluated = {
	{mod.Collectibles.Items.MarketablePlushie, mod.Familiars.MarketablePlushie.Var},
	{mod.Collectibles.Items.LilAna, mod.Familiars.LilAna.Var}
}

function mod:CVSFamiliarCheck(player, itemconfig)
	for i = 1, #mod.CVSFamsToBeEvaluated do
		player= player:ToPlayer()
		player:CheckFamiliar(mod.CVSFamsToBeEvaluated[i][2], mod.GetExpectedFamiliarNum(player, mod.CVSFamsToBeEvaluated[i][1]), player:GetCollectibleRNG(mod.CVSFamsToBeEvaluated[i][1]), itemconfig:GetCollectible(mod.CVSFamsToBeEvaluated[i][1]))
	end
end

function mod:GlobalCVSEntityStuff(npc, sprite, d)

	if d.isbeingPickedUpByDunglivery then
		npc.State = NpcState.STATE_IDLE
		return
	end

	npc:GetData().anixbirthEntitiesOrbitingNum = npc:GetData().anixbirthEntitiesOrbitingNum or 0

	d.anixbirthEntitiesOrbiting = d.anixbirthEntitiesOrbiting or {}

	if #d.anixbirthEntitiesOrbiting > 1 then
		for k, v in pairs(d.anixbirthEntitiesOrbiting) do
			if v:IsDead() or not v:Exists() then
				table.remove(d.anixbirthEntitiesOrbiting, k)
			end
		end
	end

	if d.isClatterTellerKilled then
		for i = 1, 10 do
			sprite:ReplaceSpritesheet(i-1 , "gfx/nothing.png")
			sprite:LoadGraphics()
		end
	end

end

function mod:IsAnyPlayerPongon()
    local var = false
    for i = 1, game:GetNumPlayers() do
        if Isaac.GetPlayer(i):GetPlayerType() == Isaac.GetPlayerTypeByName("Pongon") then
            return true
        end
    end
    return false
end
