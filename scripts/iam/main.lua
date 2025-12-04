local mod = FHAC

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
	"pottedfatty",
	"hanger",
	"scorchedpeat",
	"facebalm",
	"spaarker",
	"embolzon",
	"cracklinghost",
	"scorchedsooter",
	"lilflash",
	"sulferer",
	"furnace",
	"hotpotato",
	"stonejohnny",
	"souwa",
	"stoneangelstatue",
	"musicbox",
	"hotato",
	"enflamedcrazyspider",
	"amekatze",
	"sheriff",
	"gunslinger",
	"huo"
})

FHAC:LoadScripts("scripts.iam.bosses", {
    "megaper"
})

FHAC:LoadScripts("scripts.iam.minibosses", {
	"narcissism", --narc!!
	"chomb",
	"sam"
})

FHAC:LoadScripts("scripts.iam", {
	"cvsunlocks",
	"levelreplaceshit",
	"customgrids",
	"cvserrorrooms"
})

FHAC:LoadScripts("scripts.iam.effects", {
	"zapperteller_lightning",
	"blackboxoverlay",
	"fear_flower_fear_effect",
	"dekatessera effect",
	"wideweb",
	"cvsfire",
	"raingrideffect",
	"textbox",
	"gunslinger gun"
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
	"the left ball",
	"happy heart toy"
})

FHAC:LoadScripts("scripts.iam.items.passives", {
	"stinky mushroom",
	"big ol' bowl of sauerkraut",
	"stinky socks",
	"moldy bread",
	"letter to myself",
	"gros michel",
	"tums",
	"traveler's bag",
	"unwound cassete",
	"bawled reef"
})

FHAC:LoadScripts("scripts.iam.items.pickups" , {
	"bowl of sauerkraut",
	"birthday slice",
})

FHAC:LoadScripts("scripts.iam.jokes", {
	"gaprrr",
})

FHAC:LoadScripts("scripts.iam.projectiles", {
	"ember_proj",
})

FHAC:LoadScripts("scripts.iam.tears", {
	"coralshard",
})

FHAC:LoadScripts("scripts.iam.characters", {
	"johannes",
	"johannesb",
	"pongon"
})

FHAC:LoadScripts("scripts.iam.challenges", {
	"therealbestiary",
})

FHAC:LoadScripts("scripts.iam.npcs", {
	"ogwillowalker",
	"ruinNPC"
})

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


function mod:CVS161AI(npc)
	local var = npc.Variant

	if npc.Variant == mod.Monsters.Furnace.Var then
        mod:FurnaceAI(npc, npc:GetSprite(), npc:GetData())
	elseif var == mod.Monsters.Toast.Var then
		mod:ToastAI(npc, npc:GetSprite(), npc:GetData())
	elseif var == mod.Monsters.LarryKingJr.Var then
		mod:LarryKingJrAI(npc, npc:GetSprite(), npc:GetData())
	elseif var == mod.Monsters.Patient.Var then
		mod:PatientAI(npc, npc:GetSprite(), npc:GetData())
	elseif var == mod.Monsters.Snidge.Var then
		mod:SnidgeAI(npc, npc:GetSprite(), npc:GetData())
	elseif var == mod.Monsters.Cowpat.Var then
		mod:CowpatAI(npc, npc:GetSprite(), npc:GetData())
	elseif var == mod.Monsters.HorfOnAStick.Var then
		mod:HorfOnAStickAI(npc, npc:GetSprite(), npc:GetData())
	elseif var == mod.Monsters.Dunglivery.Var then
		mod:DungliveryAI(npc, npc:GetSprite(), npc:GetData())
	elseif var == mod.Monsters.Floater.Var then
		mod:FloaterAI(npc, npc:GetSprite(), npc:GetData(), npc:GetDropRNG())
	elseif var == mod.Monsters.Fivehead.Var and npc.SubType == 0 then
		mod:FiveheadAI(npc, npc:GetSprite(), npc:GetData())
	elseif var == mod.Monsters.Log.Var then
		mod:LogAI(npc, npc:GetSprite(), npc:GetData())
	elseif var == mod.Monsters.NeutralFly.Var then
		mod:NeutralFlyAI(npc, npc:GetSprite(), npc:GetData())
	elseif var == mod.Monsters.Stoner.Var then
		mod:StonerAI(npc, npc:GetSprite(), npc:GetData())
	elseif var == mod.Monsters.SackKid.Var then
		mod:SackKidAI(npc, npc:GetSprite(), npc:GetData())
	elseif var == mod.Monsters.Silly.Var or var == mod.Monsters.String.Var then
		mod:SillyStringAI(npc, npc:GetSprite(), npc:GetData())
	elseif var == mod.Monsters.Dried.Var then
		mod:DriedAI(npc, npc:GetSprite(), npc:GetData())
	elseif var == mod.Monsters.TheHanged.Var then
		mod:TheHangedAI(npc, npc:GetSprite(), npc:GetData(), npc:GetDropRNG())
	elseif var == mod.Monsters.FlyveBomber.Var then
		mod:FlyveBomberAI(npc, npc:GetSprite(), npc:GetData())
	elseif var == mod.Monsters.SmallNest.Var then
        mod:SmallNestAI(npc, npc:GetSprite(), npc:GetData())
	elseif var == mod.Monsters.AngeryMan.Var then
		mod:AngerymanAI(npc, npc:GetSprite(), npc:GetData())
	elseif var == mod.Monsters.Bewebbed.Var then
        mod:BewebbedAI(npc, npc:GetSprite(), npc:GetData())
	elseif var == mod.Monsters.Rehost.Var then
		mod:RehostAI(npc, npc:GetSprite(), npc:GetData())
	elseif var == mod.Monsters.PottedFatty.Var then
        mod:PottedFattyAI(npc, npc:GetSprite(), npc:GetData())
	elseif var == mod.Monsters.SuckUp.Var then
        mod:SuckUpAI(npc, npc:GetSprite(), npc:GetData())
	elseif var == mod.Monsters.ScorchedSooter.Var then
        mod:ScorchedSooterAI(npc, npc:GetSprite(), npc:GetData())
	elseif var == mod.Monsters.CracklingHost.Var then
        mod:CracklingHostAI(npc, npc:GetSprite(), npc:GetData())
	elseif var == mod.Monsters.ScorchedPeat.Var then
        mod:ScorchedPeatAI(npc, npc:GetSprite(), npc:GetData())
	elseif var == mod.Monsters.Trilo.Var then
        mod:TriloAI(npc, npc:GetSprite(), npc:GetData())
	elseif var == mod.Monsters.Schmoot.Var then
        mod:SchmootAI(npc, npc:GetSprite(), npc:GetData())
	elseif var == mod.Monsters.Soot.Var then
        mod:SootAI(npc, npc:GetSprite(), npc:GetData())
	elseif var == mod.Monsters.Embolzon.Var then
        mod:EmbolzonAI(npc, npc:GetSprite(), npc:GetData())
	elseif var == mod.Monsters.Spaarker.Var then
        mod:SpaarkerAI(npc, npc:GetSprite(), npc:GetData())
	elseif var == mod.Monsters.SyntheticHorf.Var then
        mod:SyntheticHorfAI(npc, npc:GetSprite(), npc:GetData())
	elseif var == mod.Monsters.Pallun.Var then
        mod:PallunAI(npc, npc:GetSprite(), npc:GetData())
	elseif var == mod.Monsters.Ulig.Var then
        mod:UligAI(npc, npc:GetSprite(), npc:GetData())
	elseif var == mod.Monsters.SixheadTop.Var then
        mod:SixheadTopAI(npc, npc:GetSprite(), npc:GetData())
	elseif var == mod.Monsters.SixheadBottom.Var then
        mod:SixheadBottomAI(npc, npc:GetSprite(), npc:GetData())
	elseif var == mod.Monsters.MushLoom.Var then
        mod:MushLoomAI(npc, npc:GetSprite(), npc:GetData())
	elseif npc.Variant == mod.Monsters.PitPatSpawner.Var and npc.SubType >= 1 then
        mod:PitPatSpawnerAI(npc, npc:GetSprite(), npc:GetData())
	elseif npc.Variant == mod.Monsters.PitPat.Var and npc.SubType == mod.Monsters.PitPat.Sub then
        mod:PitPatAI(npc, npc:GetSprite(), npc:GetData())
	elseif npc.Variant == mod.Monsters.Babble.Var then
        mod:BabbleAI(npc, npc:GetSprite(), npc:GetData())
	elseif npc.Variant == mod.Monsters.Erythorcyte.Var and npc.SubType == 0 then
        mod:ErythorcyteAI(npc, npc:GetSprite(), npc:GetData())
	elseif npc.Variant == mod.Monsters.Erythorcytebaby.Var and npc.SubType == 1 then
        mod:ErythorcytebabyAI(npc, npc:GetSprite(), npc:GetData())
	elseif npc.Variant == mod.Monsters.Wost.Var then
        mod:WostAI(npc, npc:GetSprite(), npc:GetData())
	elseif npc.Variant == mod.Monsters.RainMonger.Var then
        mod:RainMongerAI(npc, npc:GetSprite(), npc:GetData())
	elseif npc.Variant == mod.Monsters.ZapperTeller.Var then
        mod:ZapperTellerAI(npc, npc:GetSprite(), npc:GetData())
	elseif npc.Variant == mod.Monsters.Pinprick.Var and npc.SubType >= 1 then
        mod:PinprickSpawnerAI(npc, npc:GetSprite(), npc:GetData())
	elseif npc.Variant == mod.Monsters.Pinprick.Var and npc.SubType == 0 then
        mod:PinprickAI(npc, npc:GetSprite(), npc:GetData())
	elseif npc.Variant == mod.Monsters.Drosslet.Var then
        mod:DrossletAI(npc, npc:GetSprite(), npc:GetData())
	elseif npc.Variant == mod.Monsters.GassedFly.Var then
        mod:GassedFlyAI(npc, npc:GetSprite(), npc:GetData())
	elseif npc.Variant == mod.Monsters.Stuckpoot.Var then
        --mod:StuckpootAI(npc, npc:GetSprite(), npc:GetData())
	elseif npc.Variant == mod.Monsters.TechGrudge.Var then
        mod:TechGrudgeAI(npc, npc:GetSprite(), npc:GetData())
	elseif npc.Variant == mod.Monsters.FearFlower.Var then
        mod:FearFlowerAI(npc, npc:GetSprite(), npc:GetData())
	--elseif npc.Variant == mod.Monsters.Mutilated.Var then
       --mod:MutilatedAI(npc, npc:GetSprite(), npc:GetData())
	elseif npc.Variant == mod.Monsters.LilFlash.Var then
        mod:LilFlashAI(npc, npc:GetSprite(), npc:GetData())
	elseif npc.Variant == mod.Monsters.Sulferer.Var then
        mod:SulfererAI(npc, npc:GetSprite(), npc:GetData())
	elseif npc.Variant == mod.Monsters.HotPotato.Var then
        mod:HotPotatoAI(npc, npc:GetSprite(), npc:GetData())
	elseif npc.Variant == mod.Monsters.StoneJohnny.Var then
		mod:StoneJohnnyAI(npc, npc:GetSprite(), npc:GetData())
	elseif npc.Variant == mod.Monsters.Souwa.Var then
		mod:SouwaAI(npc, npc:GetSprite(), npc:GetData())
	elseif npc.Variant == mod.Monsters.StoneAngelStatue.Var then
		mod:StoneAngelStatueAI(npc, npc:GetSprite(), npc:GetData())
	elseif npc.Variant == mod.Monsters.MusicBox.Var then
		mod:MusicBoxAI(npc, npc:GetSprite(), npc:GetData())
	elseif npc.Variant == mod.Monsters.Hotato.Var then
		mod:HotatoAI(npc, npc:GetSprite(), npc:GetData())
	elseif npc.Variant == mod.Monsters.EnflamedCrazySpider.Var then
		mod:EnflamedCrazySpider(npc, npc:GetSprite(), npc:GetData())
	elseif npc.Variant == mod.Monsters.Amekatze.Var then
		mod:AmekatzeAI(npc, npc:GetSprite(), npc:GetData())
	elseif npc.Variant == mod.Monsters.Huo.Var then
		mod:HuoAI(npc, npc:GetSprite(), npc:GetData())
	end
end

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.CVS161AI, 161)

function mod:CVSTearAI(tear)

	local sprite = tear:GetSprite()
	local d = tear:GetData()

	local var = tear.Variant

	if var == mod.Tears.CoralShardTear.Var then
		FHAC:CoralTearAI(tear, sprite, d)
	end
end

mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, mod.CVSTearAI)

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local rng = RNG()
local game = Game()
local sfx = SFXManager()
local itemConfig = Isaac.GetItemConfig()

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
						if gridpoint:Distance(pos) < imtheclosest  and (grid.CollisionClass ~= 0 or grid:GetType() == 16) then
							imtheclosest = gridpoint:Distance(pos)
							closestgridpoint = grid
						end
					end	
				end
			end
			if axis == "Y" then 
				if math.abs(gridpoint.X - pos.X) < 20 then
					if mod:CheckTableContents(rocktab, grid:GetType()) then
						if gridpoint:Distance(pos) < imtheclosest and (grid.CollisionClass ~= 0 or grid:GetType() == 16) then
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

function mod:RemoveEntFromRoomSave(npc)

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
		InitSeed = npc.InitSeed,
		Spanwner = npc.Spawner,
	}

	if npc:GetData() then
		tab.Data = npc:GetData()

		tab.Data.FakeInitSeed = tab.Data.FakeInitSeed or npc.InitSeed
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
			if v:GetData().FakeInitSeed == npc.Data.FakeInitSeed then
				return false
			end
		end
		return true
	end

	local function KillCopies()
		for k, v in pairs(tab.PreSavedEnts) do
			local og = v
			for h, i in pairs(tab.PreSavedEnts) do
				if og.Data.FakeInitSeed == i.Data.FakeInitSeed and og.InitSeed ~= i.InitSeed then
					tab.PreSavedEnts[h] = nil --is killing originals rn
					return
				end
			end
		end
	end

	for k, v in pairs(tab.PreSavedEnts) do
		if v.RoomVar == game:GetLevel():GetCurrentRoomDesc().Variant and
		v.ListIndex == game:GetLevel():GetCurrentRoomDesc().ListIndex and 
		v.Stage == game:GetLevel():GetStage() and v.Type and v.Variant and v.Subtype then
			if CheckNPCInitDat(v) then
				tab.PreSavedEnts[k] = nil
				local ent = Isaac.Spawn(v.Type, v.Variant, v.Subtype, Vector(v.PositionX, v.PositionY), Vector(v.VelocityX, v.VelocityY), v.Spanwer)
				local d = ent:GetData()
				for h, i in pairs(v.Data) do
					if not d[h] then
						d[h] = i
					end
				end
				d.isanixbirthCopy = true
				ent:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
				d.init = false
			end
		elseif not CheckNPCInitDat(v) and v.Data.isanixbirthCopy then
			tab.PreSavedEnts[k] = nil
		end
	end

	KillCopies()

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


function mod:CheckForEntInRoom(npc, id, var, sub) -- this can get NON QUERY entities!
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
				Isaac.Spawn(135, 2901, -1, game:GetRoom():GetCenterPos(), Vector.Zero, nil)
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

	if mod:CheckForEntInRoom({Type = mod.Monsters.LightPressurePlateNullEntity.ID, Variant = mod.Monsters.LightPressurePlateNullEntity.Var, SubType = 0}, true, true, false) == false then
		local ent = Isaac.Spawn(mod.Monsters.LightPressurePlateNullEntity.ID, mod.Monsters.LightPressurePlateNullEntity.Var, 0, Vector.Zero, Vector.Zero, nil)
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
				Isaac.Spawn(135, 2901, -1, game:GetRoom():GetCenterPos(), Vector.Zero, nil)
			end
		end
	else
		Isaac.ExecuteCommand("stage 13a")
	end
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


function mod:IsAnyPlayerPongon()
    local var = false
    for i = 1, game:GetNumPlayers() do
        if Isaac.GetPlayer(i):GetPlayerType() == Isaac.GetPlayerTypeByName("Pongon") then
            return true
        end
    end
    return false
end

function mod:GetNextAttack(attacks)
	local tab = {}
	local strings = {}
	local na = 0
	for k, v in ipairs(attacks) do
		table.insert(tab, v[2])
		strings[v[2]] = v[1]
	end
	local newtab = mod:GetListInOppositeOrder(tab)

	local newertab = {}
	local newetabbutIdontknowwhatimdoing = {}
	for k, v in ipairs(newtab) do
		na = na + v
		table.insert(newertab, na)
		table.insert(newetabbutIdontknowwhatimdoing, {na, v})
	end

	local num = math.random(mod:GetLargestInATable(tab), mod:GetLargestInATable(newertab))

	for k, v in ipairs(newertab) do
		if newertab[k+1] and num >= v and num < newertab[k+1] then
			return strings[newetabbutIdontknowwhatimdoing[k][2]]
		elseif not newertab[k+1] then
			return strings[mod:GetLargestInATable(tab)]
		end
	end
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local player = Isaac.GetPlayer()

mod.LuaFont = Font()
mod.LuaFont:Load("font/luaminioutlined.fnt") --:Load("mods/Anixbirth-Teasrer-/resources/font/TheFuture.fnt") --

local glitchedtext = nil
local glitchedvar = nil

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
			pastext = vartext
			vartext = ""
			for i = 0, tonumber(string.len(pastext)) do
					local letter = string.sub(pastext, i, i)
					if math.random(1, 5) == 1 then
						letter = tostring(math.random(1, 9))
					end
					vartext = vartext..tostring(letter)
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

	--[[local level = game:GetLevel()
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
	end]]
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

	local rundat = AnixbirthSaveManager.GetRunSave().anixbirthsaveData

	if not rundat then return end

	if rundat.ReturnPlayersToColl5 then
		rundat.ReturnPlayersToColl5 = nil
		for i = 1, game:GetNumPlayers() do
			local player = Isaac.GetPlayer(i)

			player.GridCollisionClass = 5
			player.EntityCollisionClass = 5
		end
	end

    FHAC:SetupMegaperWallEndsForCircling()
end

function mod:ChangeToDoorwayRoomType()

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

	FHAC:SaveCassetteInfoNPC(npc)

end

function FHAC:GetTrueAngle(angle)

	local num = angle
	if angle > 360 then
		while angle > 360 do
			angle = angle - 360
		end
		return angle
	end

	if angle < 0 then
		while angle < 0 do
			angle = 360 + angle
		end
		return angle
	end

	if math.abs(angle) ~= angle then
		return 180 + math.abs(angle)
	else
		return angle
	end
end

local function CheckEntityInNoFireList(npc)
	for _, ent in ipairs(FHAC.noFireDamage) do
		if npc.Type == mod.Monsters[ent].ID and npc.Variant == mod.Monsters[ent].Var then
			return true
		end
	end
	return false
end

function FHAC:GetFireProjectileCollisions()

	if not mod.FireProjectiles or #mod.FireProjectiles == 0 then return end 

	for _, fire in ipairs(mod.FireProjectiles) do
		local d = fire:GetData()

		if d.damage == 0 then return end

		--thanks ff i didnt realize it needs post render 

		local radius = fire:GetData().radius or 20
		local colEnts = Isaac.FindInRadius(fire.Position, radius, EntityPartition.ENEMY | EntityPartition.PLAYER | EntityPartition.TEAR)


		if #Isaac.FindInRadius(fire.Position, radius, EntityPartition.TEAR) == 0 then
			d.isCollidingWithProj = false
		else
			for i = 1, #Isaac.FindInRadius(fire.Position, radius, EntityPartition.TEAR) do
				local entity = Isaac.FindInRadius(fire.Position, radius, EntityPartition.TEAR)[i]

				if d.hp > 0 and not d.isCollidingWithProj then
					entity:Kill()
					d.isCollidingWithProj = true
					if entity.Type == 2 then
						d.hp = d.hp - 1 --no i actually dont care how powerful u are
						fire.SpriteScale = fire.SpriteScale * (d.hp/d.MaxHitPoints)
					end
					if d.hp == 0 then
						fire.CollisionDamage = 0
						mod:spritePlay(fire:GetSprite(), "Disappear")
						sfx:Play(SoundEffect.SOUND_FIREDEATH_HISS, 2, 1, false, 1)
					end
				end
			end
		end

		for i = 1, #colEnts do
			local entity = colEnts[i]
			if entity.Type == 1 or (entity.EntityCollisionClass > 2 and entity:IsActiveEnemy()) and not CheckEntityInNoFireList(entity) then
				entity:TakeDamage(1, DamageFlag.DAMAGE_FIRE, EntityRef(fire), 0)
			end
		end
	end
end

function mod:GetFarthestPosition(pos1)
	local closestgridpoint
	local room = Game():GetRoom()

	local imthefarthest = 0
	local tab = {}
	for i = 0, room:GetGridSize() do
		if room:GetGridPosition(i) ~= nil then
			local gridpoint = room:GetGridPosition(i)
			if (room:GetGridEntity(i) == nil or room:GetGridEntity(i) == true) and room and room:IsPositionInRoom(gridpoint, 0) then
				if gridpoint:Distance(pos1) > imthefarthest then
					imthefarthest = gridpoint:Distance(pos1)
					closestgridpoint = gridpoint
				end
				table.insert(tab, gridpoint)
			end
		end
	end

	return closestgridpoint
end

function mod:findHideablePlace(target)
	local closestgridpoint
	local room = Game():GetRoom()

	local imtheclosest = 0 --just a absurdly big number
	local tab = {}
	for i = 0, room:GetGridSize() do
		if room:GetGridPosition(i) ~= nil then
			local gridpoint = room:GetGridPosition(i)
			if (room:GetGridEntity(i) == nil or room:GetGridEntity(i) == true) and room and room:IsPositionInRoom(gridpoint, 0) and not game:GetRoom():CheckLine(target.Position,gridpoint,0,900,false,false) then
				if gridpoint:Distance(target.Position) > imtheclosest then
					imtheclosest = gridpoint:Distance(target.Position)
					closestgridpoint = gridpoint
				end
				table.insert(tab, gridpoint)
			end
		end
	end
	if mod:IsTableEmpty(tab) then
		return mod:GetFarthestPosition(target.Position)
	else
		return closestgridpoint
	end
end

function mod:CheckLastPlayerDamageIsSpikesAtHalfHeart(ent, source)

	local room = game:GetRoom()
	local rDD = game:GetLevel():GetCurrentRoomDesc().Data

	if rDD.Type == 13 and ent.Position:Distance(room:GetCenterPos()) < 20 and source.Type == 0 and ent.Type == 1 then
		AnixbirthSaveManager.GetRunSave(ent).lastDamageWasSpikes = true
	end
end

function mod:SetupMegaperItem()
	for i = 1, game:GetNumPlayers() do
		local ent = Isaac.GetPlayer(i)

		if ent:ToPlayer():GetHearts() == 1 and AnixbirthSaveManager.GetRunSave(ent).lastDamageWasSpikes == true then
			AnixbirthSaveManager.GetRunSave(ent).lastDamageWasSpikesAndNowWeAreAtHalfAHeart = true
		end

		if AnixbirthSaveManager.GetRunSave(ent).lastDamageWasSpikesAndNowWeAreAtHalfAHeart == true and not AnixbirthSaveManager.GetRunSave(ent).checkMegDamFirst then
			AnixbirthSaveManager.GetRunSave(ent).checkMegDamFirst = true
			AnixbirthSaveManager.GetRunSave(ent).checkMegDamRot = 0
		end

		print(AnixbirthSaveManager.GetRunSave(ent).checkMegDamRot)
		if AnixbirthSaveManager.GetRunSave(ent).checkMegDamFirst and game:GetLevel():GetCurrentRoomDesc().Data.Variant == 2 then
			if AnixbirthSaveManager.GetRunSave(ent).goobPositions and AnixbirthSaveManager.GetRunSave(ent).goobPositions[1] then
				AnixbirthSaveManager.GetRunSave(ent).localGoobPosition = AnixbirthSaveManager.GetRunSave(ent).localGoobPosition or 1
				DebugRenderer.Get():Circle(AnixbirthSaveManager.GetRunSave(ent).goobPositions[AnixbirthSaveManager.GetRunSave(ent).localGoobPosition], 10)

				if ent.Position:Distance(AnixbirthSaveManager.GetRunSave(ent).goobPositions[AnixbirthSaveManager.GetRunSave(ent).localGoobPosition]) < 70 then
					AnixbirthSaveManager.GetRunSave(ent).localGoobPosition = AnixbirthSaveManager.GetRunSave(ent).localGoobPosition + 1
				end
			end

			if AnixbirthSaveManager.GetRunSave(ent).localGoobPosition > 4 then
				AnixbirthSaveManager.GetRunSave(ent).localGoobPosition = 1
				AnixbirthSaveManager.GetRunSave(ent).checkMegDamRot = AnixbirthSaveManager.GetRunSave(ent).checkMegDamRot + 1
			end
		end

		if AnixbirthSaveManager.GetRunSave(ent).checkMegDamRot and AnixbirthSaveManager.GetRunSave(ent).checkMegDamRot > 5 then
			AnixbirthSaveManager.GetRunSave(ent).lastDamageWasSpikesAndNowWeAreAtHalfAHeart = false
			AnixbirthSaveManager.GetRunSave(ent).checkMegDamFirst = false


			local itemcon = itemConfig:GetCollectible(mod.Collectibles.Items.Megaper)
			for h = 1, 100 do
				mod.scheduleCallback(function()
					if not ent then return end
					local s = Sprite()

					local pos

					s:Load("gfx/items/collectible.anm2", true)
					s:Play(s:GetDefaultAnimationName(), true)
					s:ReplaceSpritesheet(1, itemcon.GfxFileName)

					if i < 80 then
						s.Color = Color(1, 1, 1, h/100)
					else
						s.Color = Color(1, 1, 1, (100-h)/20)
					end

					s:LoadGraphics()

					--if i < 100 then
						pos = Game():GetRoom():WorldToScreenPosition(player.Position) + Vector(0, -(player.SpriteScale.Y * 35) + h/3)
					--end

					s:Render(Vector(pos.X, pos.Y))
					if h == 100 then
						if ent then
							ent:AddCollectible(mod.Collectibles.Items.Megaper)
						end
					end
				end, h, ModCallbacks.MC_POST_RENDER, false)
			end
		end

	end
end

function mod:SetupMegaperWallEndsForCircling()
	for i = 1, game:GetNumPlayers() do
		local ent = Isaac.GetPlayer(i)

		local function TechGrudgeEnt(pos)

			local room = game:GetRoom()

			local tab = {GridEntityType.GRID_ROCK, GridEntityType.GRID_ROCKT, GridEntityType.GRID_ROCK_BOMB, GridEntityType.GRID_ROCK_ALT, GridEntityType.GRID_LOCK, GridEntityType.GRID_TNT, GridEntityType.GRID_FIREPLACE,
			GridEntityType.GRID_WALL, GridEntityType.GRID_DOOR, GridEntityType.GRID_STATUE, GridEntityType.GRID_ROCK_SS, GridEntityType.GRID_PILLAR, GridEntityType.GRID_ROCK_SPIKED, GridEntityType.GRID_ROCK_ALT2,
			GridEntityType.GRID_ROCK_GOLD}

			--local tab = {GridEntityType.GRID_WALL, GridEntityType.GRID_DOOR}
			--1 is right, 2 is up, 3 is left, 4 is down
			if pos == 2 or pos == 4 then
				return mod:GetClosestGridEntAlongAxisDirection(room:GetCenterPos() + Vector(0, (-3+pos)*30), "Y", true, true, pos*-90, tab, nil, room)
			end

			if pos == 1 or pos == 3 then
				return mod:GetClosestGridEntAlongAxisDirection(room:GetCenterPos() + Vector((2-pos)*10, 0), "X", true, true, pos*-90, tab, nil, room)        
			end

		end
		AnixbirthSaveManager.GetRunSave(ent).goobPositions = {}
		for j = 1, 4 do
			table.insert(AnixbirthSaveManager.GetRunSave(ent).goobPositions, TechGrudgeEnt(j).Position)
		end
	end
end

function FHAC:CVSProjStuff(v)
	local d = v:GetData();

	FHAC.SyntheticHorfShot(v, d)
    FHAC.WostShot(v, d)
    FHAC.PallunShot(v, d)
    FHAC.SillyShot(v, d)
    FHAC.PatientShots(v, d)
    FHAC.SixheadShot(v, d)
    FHAC.andShot(v, d)
    FHAC.WoodheadShots(v, d)
    FHAC.webbedCreepProj(v, d)
    FHAC.BewebbedShot(v, d)
	FHAC.StallCreepShots(v, d)
    FHAC.SheriffShots(v, d)
end