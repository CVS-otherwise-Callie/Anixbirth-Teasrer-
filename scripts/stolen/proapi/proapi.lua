local mod = FHAC
local game = Game()
local nilvector = Vector.Zero
--This is all stolen from PROAPI
function mod:GetRoomGridPath()
    local room = game:GetRoom()
    mod.RoomGridPreBuiltPaths = {}

	local path_room = {}
	local size = room:GetGridSize()-1
    for i=0, size do
		path_room[i] = room:GetGridPath(i)
	end
	return path_room
end

function mod:GetRoomIndexOffsets()
    local room = game:GetRoom()
    local w = room:GetGridWidth()
    return { -1, -w, 1, w }
end

local gridDirection = {
	Vector(-40, 0),
	Vector(	0, -40),
	Vector(	40,	0),
	Vector(	0, 	40),
}

function mod:CatheryPathFinding(ent, target, args)
    if ent.FrameCount < 1 then return end
    if not mod.RoomGridPath then -- TODO update this for enemies that mess with the path values
        mod.RoomGridPath = mod:GetRoomGridPath()
    end
    if not mod.RoomIndexOffsets then
        mod.RoomIndexOffsets = mod:GetRoomIndexOffsets()
    end

	local room = game:GetRoom()
    local entPos = ent.Position
    local threshold = args.Threshold or 100 -- pathfinder value threshold to try reaching; important for non-enemies pathfinding after enemies
	local speed = args.Speed -- how fast we try to walk
    local accel = args.Accel -- how fast we accel to speed
    local interval = args.Interval or 30 -- how often to rebuild the path
	local giveup = args.GiveUp or false -- stop if target is unreachable
	--local target = target -- position where we're trying to reach

	local data = ent:GetData()
	data.api_Pathfinder = data.api_Pathfinder or {}
    local d = data.api_Pathfinder

    if d.path == nil or ent.FrameCount % interval == 0 then
        --------------getting passable tiles
        if not mod.RoomGridPreBuiltPaths[threshold] then
            local path = {}
            for i = 0, #mod.RoomGridPath do
                path[i] = mod.RoomGridPath[i] <= threshold and 1000 or 2000
            end
            mod.RoomGridPreBuiltPaths[threshold] = path
        end
        d.path = { table.unpack(mod.RoomGridPreBuiltPaths[threshold]) }
                --------------getting a virtual map
		d.cells = {}
		local targetIndex = room:GetGridIndex(target)
		d.path[targetIndex] = 0
		table.insert(d.cells, targetIndex)
		for k, gridIndex in ipairs(d.cells) do
			for i, offset in pairs(mod.RoomIndexOffsets) do
                local adjIndex = gridIndex + offset
				if d.path[adjIndex] == 1000 then
					d.path[adjIndex] = d.path[gridIndex] + 1
					table.insert(d.cells, adjIndex)
				end
			end
		end
		--------------
    end

	local targetpos
    if room:CheckLine(target, entPos, 1, 1, false, false) then
		targetpos = target
	else
		if not d.dif then d.dif = math.random(9) - 5 end

        targetpos = entPos + (ent.Velocity * d.dif)
        local targetIndex = room:GetGridIndex(targetpos)

        local lowestdistance = 999999
        local dirIdx = 0
		for i, offset in pairs(mod.RoomIndexOffsets) do
			local adjIndex = targetIndex + offset
			local adjacent = d.path[adjIndex]
			if adjacent and adjacent < lowestdistance then
                lowestdistance = adjacent
                dirIdx = i
			end
        end
        if targetpos and gridDirection[dirIdx] then
            targetpos = targetpos + gridDirection[dirIdx]
        end
    end
    ------------------------------------

    local entIdx = room:GetGridIndex(entPos)

    local diff = targetpos - entPos
    local dist = diff:Length()

    local reached = dist < speed

	if not reached and d.path[entIdx] and d.path[entIdx] < 1000 then
		local vel = diff * (speed / dist)
		ent.Velocity = mod:Lerp(ent.Velocity, vel, accel)
		return dist
	elseif reached then
		ent.Velocity = mod:Lerp(ent.Velocity, nilvector, accel)
		return 0
	elseif giveup then
        ent.Velocity = mod:Lerp(ent.Velocity, nilvector, accel)
    end

    return false
end