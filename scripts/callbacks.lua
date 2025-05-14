local game = Game()

function FHAC.DeathStuff(_, ent)
    FHAC.ShowFortuneDeath()
    FHAC.SchmootDeath(ent)
    FHAC.GassedFlyDeath(ent)
end
FHAC:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, FHAC.DeathStuff)

function FHAC.FHACNPCUpdate(_, npc)

    local sprite = npc:GetSprite()
    local d = npc:GetData()

    FHAC:GlobalCVSEntityStuff(npc, sprite, d)
end

FHAC:AddCallback(ModCallbacks.MC_NPC_UPDATE, FHAC.FHACNPCUpdate)

function FHAC.NewLevelStuff()
    FHAC.YouCanEndTheAltCutsceneNow = false
    FHAC.StartCutscene = false
    FHAC.RuinSecretMusicInit = false
end

FHAC:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, FHAC.NewLevelStuff)

function FHAC:PostTearRenderStuff(tear, collider, bool)
    local data = tear:GetData()

    FHAC:MarketablePlushieTearDeathAI(tear, data)
end
FHAC:AddCallback(ModCallbacks.MC_POST_TEAR_RENDER, FHAC.PostTearRenderStuff)

function FHAC.PostUpdateStuff()
    if not FHAC.FiendFolioCompactLoaded then
        FHAC.FiendFolioCompat()
    end
    --FHAC.PreSavedEntsLevel = AnixbirthSaveManager.GetRunSave().PreSavedEntsLevel
    --FHAC.SavedEntsLevel = AnixbirthSaveManager.GetRunSave().SavedEntsLevel
    --FHAC.ToBeSavedEnts = AnixbirthSaveManager.GetRunSave().ToBeSavedEnts
end
FHAC:AddCallback(ModCallbacks.MC_POST_UPDATE, FHAC.PostUpdateStuff)

function FHAC.PlayersTearsPostUpdate(_, t)
    FHAC.FloaterTearUpdate(t)
end
FHAC:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, FHAC.PlayersTearsPostUpdate)

function FHAC:ProjStuff(v)
	local d = v:GetData();
    
	FHAC.SyntheticHorfShot(v, d)
    FHAC.WostShot(v, d)
    FHAC.PallunShot(v, d)
    FHAC.SillyShot(v, d)
    FHAC:PatientShots(v, d)
    FHAC:SixheadShot(v, d)
    FHAC.andShot(v, d)
    FHAC.WoodheadShots(v, d)
    FHAC.webbedCreepProj(v, d)
end
FHAC:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, FHAC.ProjStuff)

function FHAC:ProjStuffDeath(v)
    local d = v:GetData();
    FHAC.andShot(v, d)
end

FHAC:AddCallback(ModCallbacks.MC_POST_PROJECTILE_DEATH, FHAC.ProjStuffDeath)


function FHAC:ProjCollStuff(v,c)
    local d = v:GetData();

    FHAC.RemoveWostProj(v, c, d)
    FHAC.UpdateSillyStringProj(v, c, d)
end

FHAC:AddCallback(ModCallbacks.MC_PRE_PROJECTILE_COLLISION, FHAC.ProjCollStuff)

function FHAC:RenderedStuff()
    if not FiendFolio then
        FHAC.ShowRoomText()
    end
    FHAC.JohannesPostRender()
    FHAC.MusicCheckCallback()
end
FHAC:AddCallback(ModCallbacks.MC_POST_RENDER, FHAC.RenderedStuff)

function FHAC:PostNewRoom()
    FHAC:LoadSavedRoomEnts()
    FHAC.ToBeSavedEnts = {}

    FHAC.spawnedDried = false
    FHAC:SpawnRandomDried()
    FHAC:BigBowlOfSauerkrautSpawn()
    FHAC:RemoveAllSpecificItemEffects(Isaac.GetPlayer())

    FHAC:CVSNewRoom()
end
FHAC:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, FHAC.PostNewRoom)

FHAC:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, function(_, pickup)
    FHAC:ReplaceItemTheLeftBall(pickup)
end)

function FHAC:PostPlayerUpdate(player)
    FHAC:PostUpdateRemoveTempItems(player)
    FHAC:MysteryMilkRoomInit(player)
    FHAC:StinkySocksPoisonCloud(player)
end
FHAC:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, FHAC.PostPlayerUpdate)

function FHAC:PostGameStarted(bool)

    AnixbirthSaveManager.GetRunSave().anixbirthsaveData = AnixbirthSaveManager.GetRunSave().anixbirthsaveData or {}
    AnixbirthSaveManager.GetFloorSave().anixbirthsaveData = AnixbirthSaveManager.GetFloorSave().anixbirthsaveData or {}

    FHAC.YouCanEndTheAltCutsceneNow = false
    FHAC.StartCutscene = false
    FHAC.RuinSecretMusicInit = false
end
FHAC:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, FHAC.PostGameStarted)

function FHAC:PostNPCColl(npc, coll)
    return FHAC.SillyStringColl(npc, coll) or FHAC.WostColl(npc, coll)
end
FHAC:AddCallback(ModCallbacks.MC_PRE_NPC_COLLISION, FHAC.PostNPCColl)

function FHAC:EffectPostUpdate(effect)
    local d = effect:GetData()
    local sprite = effect:GetSprite()

    FHAC:PostDriedDripUpdate(effect, sprite, d)
end
FHAC:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, FHAC.EffectPostUpdate)

FHAC:AddCallback(ModCallbacks.MC_EVALUATE_CACHE,function(_, player, flag)

    local dat = AnixbirthSaveManager.GetRunSave(player).anixbirthsaveData

    if flag == CacheFlag.CACHE_DAMAGE then

    elseif flag == CacheFlag.CACHE_FIREDELAY then
        FHAC:JokeBookStats(player)
    elseif flag == CacheFlag.CACHE_SHOTSPEED then
    elseif flag == CacheFlag.CACHE_RANGE then
    elseif flag == CacheFlag.CACHE_SPEED then
        FHAC:AddStinkySocksSpeed(player)
    elseif flag == CacheFlag.CACHE_TEARFLAG then
    elseif flag == CacheFlag.CACHE_TEARCOLOR then
    elseif flag == CacheFlag.CACHE_FLYING then
    elseif flag == CacheFlag.CACHE_WEAPON then
    elseif flag == CacheFlag.CACHE_FAMILIARS then
        local itemconfig = Isaac.GetItemConfig()
        FHAC:CVSFamiliarCheck(player, itemconfig)
    elseif flag == CacheFlag.CACHE_LUCK then
    elseif flag == CacheFlag.CACHE_ALL then --everything after this is repenatcne only
    elseif flag == CacheFlag.CACHE_SIZE then --this will invalidate the size! only use in extremely rare cases!!!
    elseif flag == CacheFlag.CACHE_COLOR then --this will invalidate the color of the player! ONLY USE IN SPECIAL CASES!!!!
    elseif flag == CacheFlag.CACHE_TWIN_SYNC then --specific for jacob and esau sync movement
    end
end)

function FHAC:NPCGetHurtStuff(npc, damage, flag, source, countdown)
    FHAC:AngeryManTakeDamage(npc, damage, flag, source)
    FHAC:PatientGetHurt(npc, damage, flag, source,countdown)
    FHAC:PallunLeaveWhenHit(npc)
    FHAC:StrawDollActiveEffect(npc, damage, flag, countdown)
    FHAC:LarryGetHurt(npc, damage, flag, source)

    if npc.Type == 1 then
        local d = npc:GetData()

        d.ColorectalCancerCreepInit = false
        FHAC:StrawDollPassive(npc)
    end

    --extra item stuff
end
FHAC:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, FHAC.NPCGetHurtStuff)

function FHAC:NPCPostInit(npc)
    FHAC:NPCReplaceCallback(npc)
    FHAC:ClatterTellerWhitelistCheck(npc) 
end
FHAC:AddCallback(ModCallbacks.MC_POST_NPC_INIT, FHAC.NPCPostInit)

function FHAC:PrePlayerColl(_, player, collider, low)
    FHAC:PatientEuthInstaKill(_, player, collider, low)
end

FHAC:AddCallback(ModCallbacks.MC_PRE_PLAYER_COLLISION, FHAC.PrePlayerColl)

function FHAC.PreNPCUpdate(npc)
end

FHAC:AddCallback(ModCallbacks.MC_PRE_NPC_UPDATE, FHAC.PreNPCUpdate)

---- custom utility callbacks! ----

function FHAC:OnPostDataLoad(saveData, isLuamod)
    saveData.file.other.HasLoaded = true
end

AnixbirthSaveManager.AddCallback(AnixbirthSaveManager.Utility.CustomCallback.POST_DATA_LOAD, FHAC.OnPostDataLoad)

if REPENTOGON then

    function FHAC:SongChangesToIngameOST(music, arg, arg2)
        local rDD = game:GetLevel():GetCurrentRoomDesc().Data
        return Isaac.GetMusicIdByName("AnixbirthFunctions")
    end

--FHAC:AddCallback(ModCallbacks.MC_PRE_MUSIC_PLAY, FHAC.SongChangesToIngameOST)

end