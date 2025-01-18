local mod = FHAC

if REPENTOGON then

function mod:CheckEnemyDeathUnlocks()
    --floater
    local persistentGameData = Isaac.GetPersistentGameData()
    if persistentGameData:GetBestiaryKillCount(EntityType.ENTITY_GAPER, 0) >= 25 then
        persistentGameData:TryUnlock(FHAC.Unlocks.Floater)
    end
    --fivehead
    if persistentGameData:GetBestiaryKillCount(EntityType.ENTITY_HORF, 0) >= 25 then
        persistentGameData:TryUnlock(FHAC.Unlocks.Fivehead)
    end
end

function mod:postSaveSlotLoad(_, _, slot)
    if slot ~= 0 then
        mod:CheckEnemyDeathUnlocks()
    end
end

function mod:CheckPlayerUnlocked(player)

    if player:GetPlayerType() == mod.Players.Bohannes then
        
    end

end

---- REPENTAGON shit ----
mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, mod.CheckEnemyDeathUnlocks)
mod:AddCallback(ModCallbacks.MC_POST_SAVESLOT_LOAD, mod.CheckEnemyDeathUnlocks)


end
