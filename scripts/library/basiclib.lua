local mod = FHAC
local rng = RNG()
local game = Game()

function mod:GetCirc(rad, per)
	return Vector(rad * math.sin(per), rad * math.cos(per))
end

function mod:round(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
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

function mod:spritePlay(sprite, anim)
	if not sprite:IsPlaying(anim) then
		sprite:Play(anim)
	end
end

function mod:spriteOverlayPlay(sprite, anim)
	if not sprite:IsOverlayPlaying(anim) then
		sprite:PlayOverlay(anim)
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
