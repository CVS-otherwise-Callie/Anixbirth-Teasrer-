FHAC.ExDescs = {}
FHAC.ExDescs.COLLECTIBLES = {}

local descs = {
	"iam.cvsitemdescs"
}

for i = 1, #descs do
	local file = include("scripts." .. descs[i])
	FHAC:MixTables(FHAC.ExDescs.COLLECTIBLES, file.ExDescs.COLLECTIBLES)
end

local function GetEidDesc(pickupVariant, id)
	if EID then
		local eidDesc = EID:getDescriptionEntryEnglish("custom", "5."..pickupVariant.."."..id)
		if eidDesc then
			return eidDesc[3]
		end
	end
end

if not EID then return end

if not __eidItemDescriptions then
    __eidItemDescriptions = {}
end

-- gooo my fiend folio!! go go go!!!!!!
for _, itemEntry in ipairs(FHAC.ExDescs.COLLECTIBLES) do
	-- EID
	local id = itemEntry.ID
	if itemEntry.EID then
		local desc = itemEntry.EID.Desc
		print(id)
		__eidItemDescriptions[id] = desc
		if itemEntry.EID.Transformations then
			__eidItemTransformations[id] = itemEntry.EID.Transformations
		end
	end

	-- ENCYCLOPEDIA
	if Encyclopedia and itemEntry.Encyclopedia then
		Encyclopedia.AddItem({
			Class = "Anixbirth",
			ID = itemEntry.ID,
			WikiDesc = Encyclopedia.EIDtoWiki(itemEntry.Wiki or __eidItemDescriptions[itemEntry.ID] or GetEidDesc(PickupVariant.PICKUP_COLLECTIBLE, itemEntry.ID) or "???"),
			Pools = itemEntry.Encyclopedia.Pools,
			UnlockFunc = function(self)
				--[[if mod.IsCollectibleLocked(itemEntry.ID) then
					self.Desc = "Locked!"
					return self
				end]]
			end,
			Hide = itemEntry.Encyclopedia.Hide,
			ModName = "Anixbirth",
		})
	end
end

--[[
--gonna be honest im not sure if this is NEEDED if i can iterate over should be fine but idk
if EID.CharacterToHeartType then
	EID.CharacterToHeartType[BobbyMod.PLAYERS.BOBBY] = "Red"
end
EID.InlineIcons["Player" .. BobbyMod.PLAYERS.BOBBY] = EID.InlineIcons["Bobby"]

BobbyPlayerIconSprite = Sprite()
BobbyPlayerIconSprite:Load("gfx/ui/eid_bobby_players_icon.anm2", true)
EID:addIcon("Player"..BobbyMod.PLAYERS.BOBBY, "Bobby", 0, 12, 12, -1, 1, BobbyPlayerIconSprite)

EID:addBirthright(BobbyMod.PLAYERS.BOBBY, "uhhh does something stupid how tf should i know", "Bobby", "en_us")
]]