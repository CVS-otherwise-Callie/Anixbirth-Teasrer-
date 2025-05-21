local mod = FHAC
local rng = RNG()
local game = Game()
local sfx = SFXManager()

function mod:reverseIfFear(npc, vec, multiplier)
	multiplier = multiplier or 1
	if mod:isScare(npc) then
		vec = vec * -1 * multiplier
	end
	return vec
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

function mod:freeGrid(npc, path, far, close, closest) -- the npc, should it be able to pathfind there, max dist from gridpoint, min dist from gridpoint, should it just find the closest avaible space
	local room = game:GetRoom()
	path = path or false
	far = far or 300
	close = close or 250
	closest = closest or false

	local closestgridpoint

	local imtheclosest = 9999999999999999538762658202121142272 --just a absurdly big number
	local tab = {}
	if path then
		for i = 0, room:GetGridSize() do
			if room:GetGridPosition(i) ~= nil then
			local gridpoint = room:GetGridPosition(i)
			if gridpoint and gridpoint:Distance(npc.Position) < far and gridpoint:Distance(npc.Position) > close and room:GetGridEntity(i) == nil and 
			room:IsPositionInRoom(gridpoint, 0) and patherReal(npc, gridpoint) then
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
			if room:GetGridPosition(i) ~= nil then
				local gridpoint = room:GetGridPosition(i)
				if gridpoint and gridpoint:Distance(npc.Position) < far and gridpoint:Distance(npc.Position) > close 
				and (room:GetGridEntity(i) == nil or room:GetGridEntity(i) == true) and room and room:IsPositionInRoom(gridpoint, 0) then
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
		return npc.Position
	end
	return tab[math.random(1, #tab)]
end

function mod:freeGridToPos(pos, path, far, close, closest) -- the npc, should it be able to pathfind there, max dist from gridpoint, min dist from gridpoint, should it just find the closest avaible space
	local room = game:GetRoom()
	path = path or false
	far = far or 300
	close = close or 250
	closest = closest or false

	local closestgridpoint

	local imtheclosest = 9999999999999999538762658202121142272 --just a absurdly big number
	local tab = {}
	if path then
		for i = 0, room:GetGridSize() do
			if room:GetGridPosition(i) ~= nil then
			local gridpoint = room:GetGridPosition(i)
			if gridpoint and gridpoint:Distance(pos) < far and gridpoint:Distance(pos) > close and room:GetGridEntity(i) == nil and 
			room:IsPositionInRoom(gridpoint, 0)  then
				if closest then
					if gridpoint:Distance(pos) < imtheclosest then
						imtheclosest = gridpoint:Distance(pos)
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
			if room:GetGridPosition(i) ~= nil then
				local gridpoint = room:GetGridPosition(i)
				if gridpoint and gridpoint:Distance(pos) < far and gridpoint:Distance(pos) > close 
				and (room:GetGridEntity(i) == nil or room:GetGridEntity(i) == true) and room and room:IsPositionInRoom(gridpoint, 0) then
					if closest then
						if gridpoint:Distance(pos) < imtheclosest then
							imtheclosest = gridpoint:Distance(pos)
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
		return pos
	end
	return tab[math.random(1, #tab)]
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
			return npc.Position
		end
	end
end

function mod:HasDamageFlag(damageFlag, damageFlags)
    return damageFlags & damageFlag ~= 0
end

function mod:isConfuse(npc)
	return npc:HasEntityFlags(EntityFlag.FLAG_CONFUSION)
end
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

function mod.onEntityTick(type, fn, variant, subtype)
	mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
		local found = Isaac.FindByType(type, variant or -1, subtype or -1, false, false)
		for _, ent in ipairs(found) do
			fn(ent)
		end
	end)
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


--Burslake Bestiary's Handy Dandy Code for morphing on death
