local mod = FHAC
local game = Game()
local room = Game():GetRoom()

--EID STUFF COMES FIRST
function FHAC:loadFont(fontFileName)
	FHAC.font:Load(fontFileName, "")
	FHAC.font:SetMissingCharacter(2)
	if not FHAC.font:IsLoaded() then
		Isaac.DebugString("EID - ERROR: Could not load font from resources/font/default.fnt" .. "'")
		return false
	end
	return true
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
	--print(#tbl)
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

function mod:ENT(name)
	return {ID = Isaac.GetEntityTypeByName(name), Var = Isaac.GetEntityVariantByName(name), Sub = Isaac.GetEntitySubTypeByName(name)}
end

function mod:FindRandomValidPathPosition(npc, mode, avoidplayer, nearposses,farposses,ignorepoops) --omfg i love you fiend folio
	local validPositions = {}
	local validPositionsFar = {}
	local validPositionsNear = {}
	local pathfinder = npc.Pathfinder
	local room = game:GetRoom()
	local size = room:GetGridSize()
	nearposses = nearposses or 80
	farposses = farposses or 150
	ignorepoops = ignorepoops or false
	local playertable = {}

	if avoidplayer then
        for i = 0, game:GetNumPlayers() do
			table.insert(playertable, game:GetPlayer(i))
		end
	end
	for i=0, size do
		local gridpos = room:GetGridPosition(i)
		local gridEntity = room:GetGridEntity(i)
		local farfromplayer = true
		if npc.Pathfinder:HasPathToPos(gridpos, ignorepoops) and not gridEntity then
			if avoidplayer then
				for k = 1, #playertable do
					if gridpos:Distance(playertable[k].Position) < avoidplayer then
						farfromplayer = false
					end
				end
			end
			if farfromplayer then
				table.insert(validPositions, gridpos)
				if npc.Position:Distance(gridpos) > farposses then
					table.insert(validPositionsFar, gridpos)
				elseif npc.Position:Distance(gridpos) < nearposses and npc.Position:Distance(gridpos) > 30 then
					table.insert(validPositionsNear, gridpos)
				end
			end
		end
	end
	if #validPositionsFar > 0 and mode == 2 then
		return validPositionsFar[math.random(#validPositionsFar)]
	elseif #validPositionsNear > 0 and mode == 3 then
		return validPositionsNear[math.random(#validPositionsNear)]
	elseif #validPositions > 0 then
		return validPositions[math.random(#validPositions)]
	else
		if mode == 10 then
			return false
		else
			return npc.Position
		end
	end
end

function mod:spritePlay(sprite, anim)
	if not sprite:IsPlaying(anim) then
		sprite:Play(anim)
	end
end

function mod:SnapVector(angle, snapAngle)
	local snapped = math.floor(((angle:GetAngleDegrees() + snapAngle/2) / snapAngle)) * snapAngle
	local snappedDirection = angle:Rotated(snapped - angle:GetAngleDegrees())
	return snappedDirection
end

function mod:RandomVector(entrng)
	local rand = entrng or rng
	return Vector(mod:TrueRandomFloat(entrng), mod:TrueRandomFloat(entrng))
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
function mod:isScare(npc)
	return npc:HasEntityFlags(EntityFlag.FLAG_FEAR | EntityFlag.FLAG_SHRINK)
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
---@param entities Entity[]
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
---@param entities Entity[]
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

function mod:CheckTableContents(table, element)
	for _, value in pairs(table) do
	  if value == element then
		return true
	  end
	end
	return false
end

function mod:ReplaceEnemyAnimation(npc, filepath, animation, layer, loadGraphics) --not important anymore, meant to scrap but i'm keeping in case i want to use it 
	layer = layer or 0
    loadGraphics = loadGraphics or true
    npc = npc:ToNPC()
    local sprite = npc:GetSprite()
end

function mod:spriteOverlayPlay(sprite, anim)
	if not sprite:IsOverlayPlaying(anim) then
		sprite:PlayOverlay(anim)
	end
end

--form codepal - https://codepal.ai/code-generator/query/GQzPwted/lua-function-remove-substring#:~:text=In%20Lua%2C%20you%20can%20easily,with%20the%20specified%20substring%20removed.
function mod:removeSubstring(str, substr)
    -- Find the starting index of the substring in the string.
    local startIndex, endIndex = string.find(str, substr)
 
    -- If the substring is found, remove it from the string.
    if startIndex and endIndex then
        local prefix = string.sub(str, 1, startIndex - 1)
        local suffix = string.sub(str, endIndex + 1)
        return prefix .. suffix
    end
 
    -- If the substring is not found, return the original string.
    return str
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