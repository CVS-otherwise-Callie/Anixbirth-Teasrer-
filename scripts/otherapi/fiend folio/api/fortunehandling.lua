local mod = FHAC

---api shit

if not APIOverride then
    APIOverride = {
        OverriddenClasses = {}
    }
end

function APIOverride.GetClass(class)
    if type(class) == "function" then
        return getmetatable(class())
    else
        return getmetatable(class).__class
    end
end

function APIOverride.OverrideClass(class)
    local class_mt = APIOverride.GetClass(class)

    local classDat = APIOverride.OverriddenClasses[class_mt.__type]
    if not classDat then
        classDat = {Original = class_mt, New = {}}

        local oldIndex = class_mt.__index

        rawset(class_mt, "__index", function(self, k)
            return classDat.New[k] or oldIndex(self, k)
        end)

        APIOverride.OverriddenClasses[class_mt.__type] = classDat
    end

    return classDat
end

function APIOverride.GetCurrentClassFunction(class, funcKey)
    local class_mt = APIOverride.GetClass(class)
    return class_mt[funcKey]
end

function APIOverride.OverrideClassFunction(class, funcKey, fn)
    local classDat = APIOverride.OverrideClass(class)
    classDat.New[funcKey] = fn
end

--[[ Example, changes the Remove function on EntityTear only, inserting a hook

local EntityTear_Remove_Old = APIOverride.GetCurrentClassFunction(EntityTear, "Remove")

APIOverride.OverrideClassFunction(EntityTear, "Remove", function(entity)
    print("Hooked EntityTear:Remove!")
    EntityTear_Remove_Old(entity)
end)

]]
--alroghty done

local function split(pString, pPattern)
    local Table = {}  -- NOTE: use {n = 0} in Lua-5.0
    local fpat = "(.-)" .. pPattern
    local last_end = 1
    local s, e, cap = pString:find(fpat, 1)
    while s do
       if s ~= 1 or cap ~= "" then
      table.insert(Table,cap)
       end
       last_end = e+1
       s, e, cap = pString:find(fpat, last_end)
    end
    if last_end <= #pString then
       cap = pString:sub(last_end)
       table.insert(Table, cap)
    end
    return Table
end

local function fortuneArray(array)
    Game():GetHUD():ShowFortuneText(
        array[1], 
        array[2] or nil, 
        array[3] or nil, 
        array[4] or nil, 
        array[5] or nil, 
        array[6] or nil, 
        array[7] or nil, 
        array[8] or nil, 
        array[9] or nil, 
        array[10] or nil,
        array[11] or nil,
        array[12] or nil,
        array[13] or nil,
        array[14] or nil,
        array[15] or nil,
        array[16] or nil,
        array[17] or nil,
        array[18] or nil,
        array[19] or nil,
        array[20] or nil,
        array[21] or nil,
        array[22] or nil,
        array[23] or nil,
        array[24] or nil,
        array[25] or nil,
        array[26] or nil,
        array[27] or nil,
        array[28] or nil,
        array[29] or nil,
        array[30] or nil,
        array[31] or nil,
        array[32] or nil,
        array[33] or nil,
        array[34] or nil,
        array[35] or nil,
        array[36] or nil,
        array[37] or nil,
        array[38] or nil,
        array[39] or nil,
        array[40] or nil,
        array[41] or nil,
        array[42] or nil,
        array[43] or nil,
        array[44] or nil,
        array[45] or nil,
        array[46] or nil,
        array[47] or nil,
        array[48] or nil,
        array[49] or nil,
        array[50] or nil,
        array[51] or nil,
        array[52] or nil,
        array[53] or nil,
        array[54] or nil,
        array[55] or nil,
        array[56] or nil,
        array[57] or nil,
        array[58] or nil,
        array[59] or nil,
        array[60] or nil,
        array[61] or nil,
        array[62] or nil,
        array[63] or nil,
        array[64] or nil,
        array[65] or nil,
        array[66] or nil,
        array[67] or nil,
        array[68] or nil,
        array[69] or nil,
        array[70] or nil,
        array[71] or nil,
        array[72] or nil,
        array[73] or nil,
        array[74] or nil,
        array[75] or nil,
        array[76] or nil,
        array[77] or nil,
        array[78] or nil,
        array[79] or nil,
        array[80] or nil
    )
end

function mod:ShowFortune(forcedtune)
    if mod.DSSavedata.customFortunes == 1 then
        local fortuneLangs = {
            mod.Fortunes,
            mod.MandarinFortunes,
	        mod.Hylics,
            mod.UnfunnyJokes
        }
        if mod.FortuneLang ~= fortuneLangs[mod.DSSavedata.fortuneLanguage] then
            mod.FortuneLang = fortuneLangs[mod.DSSavedata.fortuneLanguage]
            mod.FortuneTable = {}
        end
        if forcedtune then
            local fortune = split(forcedtune, "\n")
            fortuneArray(fortune)
        else
            mod.FortuneTable = mod.FortuneTable or {}
            if #mod.FortuneTable <= 1 then
                local fortunelist = fortuneLangs[mod.DSSavedata.fortuneLanguage]
                local fortunetablesetup = split(fortunelist, "\n\n")
                for i = 1, #fortunetablesetup do
                    table.insert(mod.FortuneTable, split(fortunetablesetup[i], "\n"))
                end
            end
            local fortune = mod.FortuneTable[math.random(#mod.FortuneTable)]
            fortuneArray(fortune)
        end
    else
        Game():ShowFortune()
    end
end

function mod:checkFortuneMachine()
	local totalFortune = Isaac.FindByType(EntityType.ENTITY_SLOT, 3)
	if #totalFortune > 0 then
		for _, fortuneMachine in ipairs(totalFortune) do
			local sprite = fortuneMachine:GetSprite()
			if sprite:IsPlaying("Prize") then
				if sprite:GetFrame() == 4 then
					local pickupFound
					for _, pickup in pairs(Isaac.FindByType(5, -1, -1)) do
						if pickup and pickup.Type == 5 and pickup.FrameCount <= 0 then
							pickupFound = true
						end
					end
					if not pickupFound then
						mod:ShowFortune()
					end
				end
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.checkFortuneMachine)

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function()
	local pickupFound
	for _, pickup in pairs(Isaac.FindByType(5, -1, -1)) do
		if pickup and pickup.Type == 5 and pickup.FrameCount <= 0 then
			pickupFound = true
		end
	end
	if not pickupFound then
		mod:ShowFortune()
	end
end, CollectibleType.COLLECTIBLE_FORTUNE_COOKIE)

APIOverride.OverrideClassFunction(Game, "ShowFortune", function()
	mod:ShowFortune()
	return
end)
