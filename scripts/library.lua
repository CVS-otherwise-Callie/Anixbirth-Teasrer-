local mod = FHAC
local game = Game()
local sfx = SFXManager()

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

function mod:AnyPlayerHasTrinket(trinketType)
	for i = 1, game:GetNumPlayers() do
        if game:GetPlayer(i):ToPlayer():HasTrinket(trinketType) then
            return true
        end
    end

    return false
end

function mod:AnyPlayerHasCollectible(coll)
	for i = 1, game:GetNumPlayers() do
        if game:GetPlayer(i):ToPlayer():HasCollectible(coll) then
            return true
        end
    end

    return false
end

function mod:GetCirc(rad, per)
	return Vector(rad * math.sin(per), rad * math.cos(per))
end

function mod:reverseIfFear(npc, vec, multiplier)
	multiplier = multiplier or 1
	if mod:isScare(npc) then
		vec = vec * -1 * multiplier
	end
	return vec
end

function mod:MakeBossDeath(npc, extragore, frame, sfx1, sfx2)
	local sprite = npc:GetSprite()
	local d = npc:GetData()
	extragore = extragore or true
	frame = frame or 4
	sfx1 = sfx1 or SoundEffect.SOUND_MEAT_JUMPS
	sfx2 = sfx2 or SoundEffect.SOUND_DEATH_BURST_LARGE

	if not d.npcDeathAnimInit then
		d.npcDeathlastFrame = 0
		d.npcDeathAnimInit = true
	end

	if sprite:IsPlaying("Death") then
        if sprite:GetFrame()%frame == 0 and npc.StateFrame ~= d.npcDeathlastFrame then
            npc:PlaySound(sfx1, 1, 0, false, 1)
			if extragore then
				Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_PARTICLE, 0, npc.Position, Vector(math.random(-10, 10), math.random(-10, 10)), npc)
			end
        end
        d.npcDeathlastFrame = npc.StateFrame
    end
    if sprite:IsFinished("Death") then
		if not d.hasBloodGibsExploded then
        	npc:PlaySound(sfx2, 1, 0, false, 1)
			if extragore then
        		npc:BloodExplode()
				Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.LARGE_BLOOD_EXPLOSION, 0, npc.Position, Vector.Zero, npc):ToEffect()
			else
				npc:Kill()
			end
			d.hasBloodGibsExploded = true
		end
    end
end

function mod:MixTables(input, table)
    if input and table then
        for k, v in pairs(table) do
            if type(input[k]) == "table" and type(v) == "table" then
                mod:MixTables(input[k], v)
            else
                input[k] = v
            end
        end
    end
end

function mod:IsSourceofDamagePlayer(source, bomb)
	if source.Entity then
		if bomb then
			return (source.Entity.Type == 1 or source.Entity.Type == 3 or source.Entity.Type == 4 or source.Entity.SpawnerType == 1 or source.Entity.Type == 3 or source.Entity.SpawnerType == 4)
		else
			return (source.Entity.Type == 1 or source.Entity.Type == 3 or source.Entity.SpawnerType == 1 or source.Entity.SpawnerType == 3)
		end
	else
		return false
	end
end

local function patherReal(npc, point)
	if npc.Type == 1 or npc.Type == 3 then
		return game:GetRoom():CheckLine(point,npc.Position,3,900,false,false)
	else
		local pather = npc.Pathfinder
		if not pather then return end
		return pather:HasPathToPos(point, true)
	end
end

function mod:freeGrid(npc, path, far, close)
	local room = game:GetRoom()
	path = path or false
	far = far or 300
	close = close or 250
	local tab = {}
	if path then
		for i = 0, room:GetGridSize() do
			if room:GetGridPosition(i) ~= nil then
			local gridpoint = room:GetGridPosition(i)
			if gridpoint and gridpoint:Distance(npc.Position) < far and gridpoint:Distance(npc.Position) > close and room:GetGridEntity(i) == nil and 
			room:IsPositionInRoom(gridpoint, 0) and patherReal(npc, gridpoint) then
				table.insert(tab, gridpoint)
			end
			end
		end
	else
		for i = 0, room:GetGridSize() do
			if room:GetGridPosition(i) ~= nil then
				local gridpoint = room:GetGridPosition(i)
				if gridpoint and gridpoint:Distance(npc.Position) < far and gridpoint:Distance(npc.Position) > close 
				and (room:GetGridEntity(i) == nil or room:GetGridEntity(i) == true) and room and room:IsPositionInRoom(gridpoint, 0) then
					table.insert(tab, gridpoint)
				end
			end
		end
	end
	if #tab <= 0 then
		return npc.Position
	end
	return tab[math.random(1, #tab)]
end

-- thanks fiend folio
function mod:tearsUp(firedelay, val)
	local currentTears = 30 / (firedelay + 1)
	local newTears = currentTears + val
	return math.max((30 / newTears) - 1, -0.99)
end

function mod:freeHole(npc, path, far, close, closest)
	local room = game:GetRoom()
	closest = closest or false
	path = path or false
	far = far or 300
	close = close or 250
	local tab = {}
	local closestgridpoint

	local imtheclosest = 9999999999999999538762658202121142272 --just a absurdly big number
	if path then
		for i = 0, room:GetGridSize() do
			if room:GetGridEntity(i) and room:GetGridEntity(i):GetType() == GridEntityType.GRID_PIT then
			local gridpoint = room:GetGridPosition(i)
			if gridpoint and gridpoint:Distance(npc.Position) < far and gridpoint:Distance(npc.Position) > close and room:GetGridEntity(i) and room:GetGridEntity(i):GetType() == GridEntityType.GRID_PIT and 
			room:IsPositionInRoom(gridpoint, 0) and game:GetRoom():CheckLine(gridpoint,npc.Position,3,900,false,false) then
				if closest then
					if gridpoint:Distance(npc.Position) < imtheclosest then
						imtheclosest = gridpoint:Distance(npc.Position)
						closestgridpoint = gridpoint
					end
				else
					table.insert(tab, gridpoint)
				end			
				end
			end
		end
	else
		for i = 0, room:GetGridSize() do
			if room:GetGridEntity(i) and room:GetGridEntity(i):GetType() == GridEntityType.GRID_PIT then
				local gridpoint = room:GetGridPosition(i)
				if gridpoint and gridpoint:Distance(npc.Position) < far and gridpoint:Distance(npc.Position) > close 
				and room and room:IsPositionInRoom(gridpoint, 0) then
					if closest then
						if gridpoint:Distance(npc.Position) < imtheclosest then
							imtheclosest = gridpoint:Distance(npc.Position)
							closestgridpoint = gridpoint
						end
					else
						table.insert(tab, gridpoint)
					end
				end
			end
		end
	end
	if closest and closestgridpoint then return closestgridpoint end
	if #tab <= 0 then
		return nil
	end
	return tab[math.random(1, #tab)]
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

function mod:HasDamageFlag(damageFlag, damageFlags)
    return damageFlags & damageFlag ~= 0
end

function mod:FindClosestNextEntitySpawn(npc, dist, random)
	local room = game:GetRoom()
	local vec = Vector(0, dist)
	local positions = {}
	for i = 1, 4 do
		local pos = npc.Position + vec:Rotated((i+1)*90)
		if (room:GetGridCollisionAtPos(pos)== 0 and mod:IsTableEmpty(Isaac.FindInRadius(pos, dist, EntityPartition.PLAYER)) and mod:IsTableEmpty(Isaac.FindInRadius(pos, dist, EntityPartition.ENEMY))) then
			table.insert(positions, pos)
		end
	end
	--[[for i = 1, #positions do
		Isaac.Spawn(5, 40, 0, positions[i], nilvector, npc):ToEffect()
	end]]
	if random then
		if #positions > 0 then
			return positions[math.random(#positions)]
		else
			return npc.Position
		end
	else
		if #positions > 0 then
			return positions[1]
		else
			print("aww")
			return npc.Position
		end
	end
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

function mod:isSirenCharmed(familiar)
	local helpers = Isaac.FindByType(EntityType.ENTITY_SIREN_HELPER, -1, -1, true)
	for _, helper in ipairs(helpers) do
		if helper.Target and helper.Target.Index == familiar.Index and helper.Target.InitSeed == familiar.InitSeed then
			return true, helper
		end
	end
	return false, nil
end

--thx future
function mod:isConfuse(npc)
	return npc:HasEntityFlags(EntityFlag.FLAG_CONFUSION)
end

--thx imt_tem
function mod:IsTableEmpty(tbl)
    for _,_ in pairs(tbl) do
        return false
    end
	if tbl[1] ~= nil then
		return false
	end
    return true
end

function mod.onEntityTick(type, fn, variant, subtype)
	mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
		local found = Isaac.FindByType(type, variant or -1, subtype or -1, false, false)
		for _, ent in ipairs(found) do
			fn(ent)
		end
	end)
end

function mod:spritePlay(sprite, anim)
	if not sprite:IsPlaying(anim) then
		sprite:Play(anim)
	end
end

--thanks fiend folio
function mod:getSeveralDifferentNumbers(needed, totalAmount, customRNG, blacklist)
	local numTable = {}
	local results = {}
	for i=1,totalAmount do
		table.insert(numTable, i)
	end
	local rng = RNG()
	if customRNG == nil then
		rng:SetSeed(game:GetRoom():GetSpawnSeed(), 0)
	else
		rng = customRNG
	end
	
	if blacklist then
		for _,num in ipairs(blacklist) do
			table.remove(numTable, num)
		end
	end

	for i=1,needed do
		if #numTable == 0 then
            break
        else
            local roll = rng:RandomInt(#numTable)+1
            results[i] = numTable[roll]
            table.remove(numTable, roll)
        end
	end
	return results
end

function mod:SnapVector(angle, snapAngle)
	local snapped = math.floor(((angle:GetAngleDegrees() + snapAngle/2) / snapAngle)) * snapAngle
	local snappedDirection = angle:Rotated(snapped - angle:GetAngleDegrees())
	return snappedDirection
end

function mod:Lerp(first, second, percent, smoothIn, smoothOut) --woah siiickkkk
    if smoothIn then
        percent = percent ^ smoothIn
    end

    if smoothOut then
        percent = 1 - percent
        percent = percent ^ smoothOut
        percent = 1 - percent
    end

	return (first + (second - first)*percent)
end

function mod:confusePos(npc, pos, frameCountCheck, isVec, alwaysConfuse)
	frameCountCheck = frameCountCheck or 10
	local d = npc:GetData()
	if FHAC:isConfuse(npc) or alwaysConfuse then
		if isVec then
			if npc.FrameCount % frameCountCheck == 0 then
				d.confusedEffectPos = nil
			end
			d.confusedEffectPos = d.confusedEffectPos or RandomVector()*math.random(2,5)
			return d.confusedEffectPos
		else
			if npc.FrameCount % frameCountCheck == 0 then
				d.confusedEffectPos = nil
			end
			if d.confusedEffectPos and npc.Position:Distance(d.confusedEffectPos) < 2 then
				d.confusedEffectPos = npc.Position
			end
			d.confusedEffectPos = d.confusedEffectPos or npc.Position + RandomVector()*math.random(5,15)
			return d.confusedEffectPos
		end
	else
		d.confusedEffectPos = nil
		return pos
	end
end

--thx boiler
function mod:isFriend(npc)
	return npc:HasEntityFlags(EntityFlag.FLAG_FRIENDLY)
end
function mod:isCharm(npc)
	return npc:HasEntityFlags(EntityFlag.FLAG_FRIENDLY | EntityFlag.FLAG_CHARM)
end
function mod:isScare(npc)
	return npc:HasEntityFlags(EntityFlag.FLAG_FEAR | EntityFlag.FLAG_SHRINK)
end
function mod:isScareOrConfuse(npc)
	return npc:HasEntityFlags(EntityFlag.FLAG_CONFUSION | EntityFlag.FLAG_FEAR | EntityFlag.FLAG_SHRINK)
end
function mod:isBaited(npc)
	return npc:HasEntityFlags(EntityFlag.FLAG_BAITED)
end

function mod:ReplaceEnemySpritesheet(npc, filepath, layer, loadGraphics) --cmon if you literally add the fucking .png one more time I'm gonna delete this and let you suffer in pain
    layer = layer or 0
    loadGraphics = loadGraphics or true
    npc = npc:ToNPC()
    local sprite = npc:GetSprite()
    if npc:IsChampion() then ---and not FHAC.SpritesheetlessChamps[npc:GetChampionColorIdx()] then
        filepath = filepath.."_champion"
    end
    filepath = filepath..".png"
    sprite:ReplaceSpritesheet(layer, filepath)
    if loadGraphics then
        sprite:LoadGraphics()
    end
end
--nvm no more

---thanks to mr. catwizard on this!!
---@param point Vector
---@param lineStart Vector
---@param lineEnd Vector
function mod:getDistanceToLineSegment(point, lineStart, lineEnd)
    local diff = lineEnd - lineStart
    local len_sq = diff:LengthSquared()

    local startX, startY = lineStart.X, lineStart.Y

    -- If the line segment is a single point
    if len_sq == 0 then
        return math.sqrt((point.X - lineStart.X)^2 + (point.Y - lineStart.Y)^2)
    end

    local projection = ((point - lineStart):Dot(diff)) / len_sq

    -- Projection is outside the line segment
    if projection < 0 or projection > 1 then
        return nil
    end

    -- Projection point on the segment
    local projX, projY = lineStart.X + projection * diff.X, lineStart.Y + projection * diff.Y
    local distX, distY = point.X - projX, point.Y - projY

    return math.sqrt(distX * distX + distY * distY)
end

local DISTANCE_THRESHOLD = 20

---@param lineStart Vector
---@param lineEnd Vector
function mod:FindEntitiesInLine(lineStart, lineEnd, ent)
    local result = {}
    --for _, ent in ipairs(entities) do
        local distance = mod:getDistanceToLineSegment(ent.Position, lineStart, lineEnd)
        if distance and distance < DISTANCE_THRESHOLD then
            result[#result + 1] = ent
        end
    --end
    return result
end

---@param lineStart Vector
---@param lineEnd Vector
function mod:AreEntitiesInLine(lineStart, lineEnd, ent)
    local result = {}
    --for _, ent in ipairs(entities) do
        local distance = mod:getDistanceToLineSegment(ent.Position, lineStart, lineEnd)
        if distance and distance < DISTANCE_THRESHOLD then
            return true
        end
    --end
    return false
end

function mod:FindLongerorShorterTable(tables, long, longest)
	longest = longest or (10^10)
	local coolernum = 0
	if long then
		local table = 0
		for num, tab in ipairs(tables) do
			if #tab > table then
				table = #tab
				coolernum = num
			end
		end
	else
		local table = longest
		for num, tab in ipairs(tables) do
			if #tab < table then
				table = #tab
				coolernum = num
			end
		end
	end
	return tables[coolernum]
end

function mod:CheckTableContents(table, element)
	for _, value in pairs(table) do
	  	if value == element then
			return true
	  	end
	end
	return false
end

function mod:ValidifyTables(table1, table2, basedonlength)
	basedonlength = basedonlength or false
	if basedonlength then
		for _, element in pairs(mod:FindLongerorShorterTable({table1, table2}, true)) do
			if not mod:CheckTableContents(mod:FindLongerorShorterTable({table1, table2}, false), element) then return false end
		end
	else
		for _, element in pairs(table1) do
			if not mod:CheckTableContents(table2, element) then return false end
		end
	end
	return true
end

function mod:spriteOverlayPlay(sprite, anim)
	if not sprite:IsOverlayPlaying(anim) then
		sprite:PlayOverlay(anim)
	end
end

--form codepal - https://codepal.ai/code-generator/query/GQzPwted/lua-function-remove-substring#:~:text=In%20Lua%2C%20you%20can%20easily,with%20the%20specified%20substring%20removed.
function mod:removeSubstring(str, substr)
	str = str or "Null Name"
	substr = substr or "Null"
   local startIndex, endIndex = string.find(str, substr)
 
    if startIndex and endIndex then
        local prefix = string.sub(str, 1, startIndex - 1)
        local suffix = string.sub(str, endIndex + 1)
        return prefix .. suffix
    end
    return str
end

FHAC.PreSavedEntsLevel = FHAC.PreSavedEntsLevel or {}
FHAC.SavedEntsLevel = FHAC.SavedEntsLevel or {}
FHAC.ToBeSavedEnts = FHAC.ToBeSavedEnts or {}

function mod:SaveEntToRoom(enttable)
	for k, v in ipairs(FHAC.ToBeSavedEnts) do
		if v[3] == GetPtrHash(enttable.NPC) then
			v.NPC = enttable.NPC
			return
		end
	end
	if enttable.NPC:ToNPC():GetData().isPrevEntCopy then
		for k, v in ipairs(FHAC.SavedEntsLevel) do
			if v.Position:Distance(enttable.NPC.Position) < 0.001 then
				table.remove(FHAC.SavedEntsLevel, k)
				table.remove(FHAC.PreSavedEntsLevel, k)
				enttable.NPC:ToNPC():GetData().isPrevEntCopy = false
			end
		end
	end
	enttable[3] = GetPtrHash(enttable.NPC)-- this turns into the thrid part of the table
	enttable.Room = game:GetLevel():GetCurrentRoomDesc().Data
	enttable.ListIndex = game:GetLevel():GetCurrentRoomDesc().ListIndex
	enttable.Stage = game:GetLevel():GetStage()
	table.insert(FHAC.ToBeSavedEnts, enttable)
end

function mod:SavePreEnts()

	for k, v in ipairs(FHAC.ToBeSavedEnts) do
		if type(v) == "table" then

			local enttable = v

			local tab = {
				NPC = enttable.NPC,
				Room = enttable.Room,
				ListIndex = enttable.ListIndex,
				Stage = enttable.Stage,
				Subtype = enttable.NPC.SubType,
				Position = enttable.NPC.Position,
				Velocity = enttable.NPC.Velocity,
				Spanwner = enttable.NPC.Spawner,
				Data = enttable.NPC:GetData()
			}

			if enttable.NPC:ToNPC():GetData().isPrevEntCopy then
				for j, h in pairs(v) do
					enttable[j] = v[j]
				end
			return end

			mod:MixTables(tab, enttable)
				
			table.insert(FHAC.PreSavedEntsLevel, tab)
		end
	end
	FHAC.ToBeSavedEnts = {}
end

function mod:TransferSavedEnts()
	for k, v in ipairs(FHAC.PreSavedEntsLevel) do
		if not mod:CheckTableContents(FHAC.SavedEntsLevel, v) then
			table.insert(FHAC.SavedEntsLevel, v)
		end
	end
	FHAC.SavedEntsLevel = FHAC.SavedEntsLevel
end

function mod:LoadSavedRoomEnts()
	local ents = FHAC.SavedEntsLevel or {}
	for k, v in pairs(ents) do
		if v.Room and v.ListIndex == game:GetLevel():GetCurrentRoomDesc().ListIndex and v.Stage == game:GetLevel():GetStage() then
			local ent = Isaac.Spawn(Isaac.GetEntityTypeByName(v.Name), Isaac.GetEntityVariantByName(v.Name), v.Subtype, v.Position, v.Velocity, nil)
			local d = ent:GetData()
			d.isPrevEntCopy = true
			for k, v in pairs(v.Data) do
				if not d[k] then
					d[k] = v
				end
			end
			ent:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			d.init = false
		end
	end
end

function mod:CheckForNewRoom(bool)
end

-- i had no idea how to set up a registered callback to be set up later unitl fiend folio, thank yall ^-^

mod.funcs = {}
function mod.scheduleCallback(foo, delay, callback, noCancelOnNewRoom)
	callback = callback or ModCallbacks.MC_POST_UPDATE
	if not mod.funcs[callback] then
		mod.funcs[callback] = {}
		mod:AddCallback(callback, function()
			for i = #mod.funcs[callback], 1, -1 do
				local func = mod.funcs[callback][i]
				func.Delay = func.Delay - 1
				if func.Delay <= 0 then
					func.Func()
					table.remove(mod.funcs[callback], i)
				end
			end
		end)
	end

	table.insert(mod.funcs[callback], { Func = foo, Delay = delay, NoCancel = noCancelOnNewRoom })
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

function mod:MakeInvulnerable(npc)
	npc:AddEntityFlags(EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_STATUS_EFFECTS)
	npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
	npc.GridCollisionClass = GridCollisionClass.COLLISION_NONE
end

function mod:MakeVulnerable(npc)
	npc:ClearEntityFlags(EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_STATUS_EFFECTS)
	npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
	npc.GridCollisionClass = GridCollisionClass.COLLISION_SOLID
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

--Burslake Bestiary's Handy Dandy Code for morphing on death
function FHAC:MorphOnDeath(npc, morphType, morphVariant, morphSub, sound, chance, times)
	if not chance then chance = 1 end
	if math.random() <= chance then
		npc:Morph(morphType, morphVariant, morphSub, npc:GetChampionColorIdx())
		if sound then
			sfx:Play(sound)
		end
		npc:BloodExplode()
		npc:GetData().anixbirthRespawned = true
		npc.HitPoints = npc.MaxHitPoints
	end

	return npc
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

local function GetLarryDist(table, element)
	for num, value in pairs(table) do
		  if value:Distance(element)  == 0  then
			return num
		  end
	end
	return false
end

local function HasPossibleParentSegs(butts, d)
	local tab = {}
	if d.butts then
		for k, butt in ipairs(Isaac.FindByType(mod.Monsters.LarryKingJr.ID, mod.Monsters.LarryKingJr.Var)) do
			table.insert(tab, butt.Position)
		end
		if not butts:IsDead() and GetLarryDist(tab, d.butts[1].Position) then
			return GetLarryDist(tab, d.butts[1].Position)
		end
	end
end

local function DoDataThing(d, dat)
    for k, v in ipairs(dat) do
        if v then
            table.remove(dat, k)
        end
    end
    for k, v in pairs(d) do
        if not dat[k] then
            dat[k] = v
        end
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

--thx guwah
function mod:CheckStage(stagename, backdroptypes)
    local level = game:GetLevel()
    local room = game:GetRoom()
    local levelname = level:GetName()
    if levelname == stagename or levelname == stagename.."I" or levelname == stagename.."II" then
        return true
    elseif backdroptypes then
        for _, backdrop in pairs(backdroptypes) do
            if room:GetBackdropType() == backdrop then
                return true
            end
        end
    end
end

function mod:GetAliveEntitiesInDist(npc, dist)
	local tab = {}
	for k, v in ipairs(Isaac.GetRoomEntities()) do
		if npc.Position:Distance(v.Position) > 0 and npc.Position:Distance(v.Position) < dist and v:Exists() and not v:IsDead() then
			table.insert(tab, v)
		end
	end
	return tab
end

function mod:AddTempItem(item, player, callback)
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
