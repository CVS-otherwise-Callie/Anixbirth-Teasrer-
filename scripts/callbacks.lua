local mod = FHAC
local game = Game()

function mod.DeathStuff(_, ent)
    mod.ShowFortuneDeath()
    mod.SchmootDeath(ent)
    mod.GassedFlyDeath(ent)
end
FHAC:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.DeathStuff)

function mod.PostUpdateStuff()
    if not FHAC.FiendFolioCompactLoaded then
        mod.FiendFolioCompat()
    end
end
FHAC:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.PostUpdateStuff)

function mod.PlayersTearsPostUpdate(_, t)
    mod.FloaterTearUpdate(t)
end
FHAC:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, mod.PlayersTearsPostUpdate)

function mod:ProjStuff(v)
	local d = v:GetData();

	mod.SyntheticHorfShot(v, d)
    mod.WostShot(v, d)
    mod.PallunShot(v, d)
    mod.SillyShot(v, d)
end
FHAC:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, mod.ProjStuff)

function mod:ProjCollStuff(v,c)
    local d = v:GetData();

    mod.RemoveWostProj(v, c, d)
end

mod:AddCallback(ModCallbacks.MC_PRE_PROJECTILE_COLLISION, mod.ProjCollStuff)

function mod:RenderedStuff()
    if not FiendFolio then
        mod.ShowRoomText()
    end
    mod.JohannesPostRender()
    mod.MusicCheckCallback()
end
mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.RenderedStuff)

function mod:PostNewRoom()
    mod:LoadSavedRoomEnts()
    mod:TransferSavedEnts()
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.PostNewRoom)

function mod:PostGameStarted(bool)
    mod.CheckForNewRoom(bool)
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.PostGameStarted)

function mod:PostNPCColl(npc, coll)
    return mod.SillyStringGetHit(npc, coll)
end
mod:AddCallback(ModCallbacks.MC_PRE_NPC_COLLISION, mod.PostNPCColl)

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE,function(_, player, flag)
    
	local basedata = player:GetData() --for stats and shit
	local data = basedata.crossversedata

    if flag == CacheFlag.CACHE_DAMAGE then

    elseif flag == CacheFlag.CACHE_FIREDELAY then
    elseif flag == CacheFlag.CACHE_SHOTSPEED then
    elseif flag == CacheFlag.CACHE_RANGE then
    elseif flag == CacheFlag.CACHE_SPEED then
    elseif flag == CacheFlag.CACHE_TEARFLAG then
    elseif flag == CacheFlag.CACHE_TEARCOLOR then
    elseif flag == CacheFlag.CACHE_FLYING then
    elseif flag == CacheFlag.CACHE_WEAPON then
    elseif flag == CacheFlag.CACHE_FAMILIARS then
        local itemconfig = Isaac.GetItemConfig()
    elseif flag == CacheFlag.CACHE_LUCK then
    elseif flag == CacheFlag.CACHE_ALL then --everything after this is repenatcne only
    elseif flag == CacheFlag.CACHE_SIZE then --this will invalidate the size! only use in extremely rare cases!!!
    elseif flag == CacheFlag.CACHE_COLOR then --this will invalidate the color of the player! ONLY USE IN SPECIAL CASES!!!!
    elseif flag == CacheFlag.CACHE_TWIN_SYNC then --specific for jacob and esau sync movement
    end
end)

function mod:NPCGetHurtStuff(npc, damage, flag, source, countdown)
    mod:PatientGetHurt(npc, damage, flag, source,countdown)
    mod:PallunLeaveWhenHit(npc)
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.NPCGetHurtStuff)