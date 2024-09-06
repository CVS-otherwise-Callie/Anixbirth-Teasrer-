--just taken from one of my other mdos :3333 no one will ever know mwahahaha!

local mod = FHAC
local json = require("json")

FHAC.savedata = FHAC.savedata or {}

function FHAC.SaveModData()
    FHAC.savedata.config = {
        fortuneDeathChance = FHAC.fortuneDeathChance,
        PreSavedEntsLevel = FHAC.PreSavedEntsLevel,
        SavedEntsLevel = FHAC.SavedEntsLevel
    }
    Isaac.SaveModData(mod, json.encode(FHAC.savedata))
end
function FHAC.LoadModData()
    if not mod:HasData() then
        FHAC.SaveModData()
        print("FHAC Data Initialized! Have a wonderful run!!")
    else
        FHAC.savedata = json.decode(mod:LoadData())

        local config = FHAC.savedata.config
        if config then
            FHAC.fortuneDeathChance = config.fortuneDeathChance or FHAC.fortuneDeathChance
            FHAC.PreSavedEntsLevel = config.PreSavedEntsLevel or FHAC.PreSavedEntsLevel
            FHAC.SavedEntsLevel = config.SavedEntsLevel or FHAC.SavedEntsLevel
        end
    end
end

FHAC.LoadModData()


--this is specifically fiend folio style, thanks to the ppl in fiend folio who made the savedata stuff
function FHAC.getFieldInit(tab, ...) --we lvoe saving tables
	if not tab then error("Expected table! Got " .. type(tab)) end

	local keys = { ... }
	local default = table.remove(keys) -- last arg is always default val

	for i, key in ipairs(keys) do
		if not tab[key] then
			tab[key] = i < #keys and {} or default
		end
		tab = tab[key]
	end

	return tab
end
FHAC:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, function()
	Isaac.DebugString("PREGAMEEXITPRESAVE")
    FHAC.SaveModData()
	Isaac.DebugString("PREGAMEEXITPOSTSAVE")
    FHAC.gamestarted = false
end)

FHAC:AddCallback(ModCallbacks.MC_POST_GAME_END, function()
    FHAC.gamestarted = false
end)

FHAC:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
    FHAC.getFieldInit(FHAC.savedata, 'run', {}).level = {}
    if FHAC.gamestarted then
        FHAC.SaveModData()
    end
end)

--end of fiend folio