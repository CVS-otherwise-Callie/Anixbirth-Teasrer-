local mod = FHAC
local game = Game()

function mod.DeathStuff(_, ent)
    mod.ShowFortuneDeath()
    mod.SchmootDeath(ent)
    mod.GassedFlyDeath(ent)
end
FHAC:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.DeathStuff)

function mod.PreChangeRooms()
    mod:SavePreEnts()
    mod:TransferSavedEnts()
end
FHAC:AddCallback(ModCallbacks.MC_PRE_CHANGE_ROOM, mod.PreChangeRooms)

function mod.LeaveGame()
    mod:SavePreEnts()
    mod:TransferSavedEnts()
end
FHAC:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, mod.LeaveGame)

function mod.NewLevelStuff()
    mod.YouCanEndTheAltCutsceneNow = false
    mod.StartCutscene = false
    mod.RuinSecretMusicInit = false
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.NewLevelStuff)

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
    mod:PatientShots(v, d)
    mod:SixheadShot(v, d)
end
FHAC:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, mod.ProjStuff)

function mod:ProjCollStuff(v,c)
    local d = v:GetData();

    mod.RemoveWostProj(v, c, d)
    mod.UpdateSillyStringProj(v, c, d)
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
    FHAC.ToBeSavedEnts = {}

    mod.spawnedDried = false
    mod:SpawnRandomDried()

    mod:RemoveAllSpecificItemEffects(Isaac.GetPlayer())
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.PostNewRoom)

function mod:PostPlayerUpdate(player)
    mod:AnalFissure(player)
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.PostPlayerUpdate)

function mod:PostGameStarted(bool)
    mod.CheckForNewRoom(bool)
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.PostGameStarted)

function mod:PostNPCColl(npc, coll)
    return mod.SillyStringColl(npc, coll) or mod.WostColl(npc, coll)
end
mod:AddCallback(ModCallbacks.MC_PRE_NPC_COLLISION, mod.PostNPCColl)

function mod:EffectPostUpdate(effect)
    local d = effect:GetData()
    local sprite = effect:GetSprite()

    mod:PostDriedDripUpdate(effect, sprite, d)
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.EffectPostUpdate)

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE,function(_, player, flag)

	local basedata = player:GetData() --for stats and shit

    if flag == CacheFlag.CACHE_DAMAGE then

    elseif flag == CacheFlag.CACHE_FIREDELAY then
        mod:JokeBookStats(player)
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
    mod:StrawDollActiveEffect(npc, damage, flag, countdown)

    if npc.Type == 1 then
        local d = npc:GetData()

        d.ColorectalCancerCreepInit = false
        mod:StrawDollPassive(npc)
    end

    --extra item stuff
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.NPCGetHurtStuff)

function mod:NPCPostInit(npc)
    mod:NPCReplaceCallback(npc)
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, mod.NPCPostInit)

function mod:PrePlayerColl(_, player, collider, low)
    mod:PatientEuthInstaKill(_, player, collider, low)
end

mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_COLLISION, mod.PrePlayerColl)

function mod.PreNPCUpdate(npc)
end

mod:AddCallback(ModCallbacks.MC_PRE_NPC_UPDATE, mod.PreNPCUpdate)

---- custom utility callbacks! ----

function mod:OnPostDataLoad(saveData, isLuamod)
    FHAC.PreSavedEntsLevel = saveData.game.roomFloor.PreSavedEntsLevel or {}
    FHAC.SavedEntsLevel = saveData.game.roomFloor.SavedEntsLevel or {}
    FHAC.ToBeSavedEnts = saveData.game.roomFloor.ToBeSavedEnts or {}
    saveData.file.other.HasLoaded = true
end

SaveManager.AddCallback(SaveManager.Utility.CustomCallback.POST_DATA_LOAD, mod.OnPostDataLoad)

if REPENTOGON then

    function mod:SongChangesToIngameOST(music, arg, arg2)
        local rDD = game:GetLevel():GetCurrentRoomDesc().Data
        print(rDD.Name)
        return Isaac.GetMusicIdByName("AnixbirthFunctions")
    end

--mod:AddCallback(ModCallbacks.MC_PRE_MUSIC_PLAY, mod.SongChangesToIngameOST)

end