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
        array[10] or nil
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
