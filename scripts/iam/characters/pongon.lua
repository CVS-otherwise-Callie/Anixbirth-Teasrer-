local mod = FHAC
local game = Game()
local player = Isaac.GetPlayer()
local rng = RNG()
local deathcount = 0

function mod:IsPongon(player)
    if not player then player = Isaac.GetPlayer() end
    if player:GetPlayerType() == Isaac.GetPlayerTypeByName("Pongon") then
        return "Pongon"
    end
    return false
end

--------------------------------------------------------------------------------------------------


function mod:checkSnarks(max)
    local max = max or 20
    local count = 0
    for _, ent in ipairs(Isaac.GetRoomEntities()) do
        if ent.Type == mod.Familiars.Snark.ID and ent.Variant == mod.Familiars.Snark.Var then
            count = count + 1
        end
    end
    if count > max then
        return false
    else
        return true
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, function(_, ent)
    local player = Isaac.GetPlayer()
    if not mod:IsPongon(player) then return end
    if not deathcount == 3 then
        deathcount = deathcount + 1
    elseif mod:checkSnarks(5) then
        local snark = Isaac.Spawn(3, mod.Familiars.Snark.Var, 0, ent.Position, ent.Velocity, ent)
        snark:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        deathcount = 0
    end
end)