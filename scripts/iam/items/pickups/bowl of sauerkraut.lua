local mod = FHAC
local game = Game()
local sfx = SFXManager()
local ms = MusicManager()

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, pickup)
    mod:BowlOfSauerkrautAI(pickup, pickup:GetSprite(), pickup:GetData())
end, mod.Collectibles.PickupsEnt.BowlOfSauerkraut.Var)

mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, function(_, pickup, collider)
    if collider.Type == 1 and collider.Variant == 0 then
        collider = collider:ToPlayer()
        mod.CollectBowlOfSauerkraut(collider, pickup)
        return true
    else
        return true
    end
end, mod.Collectibles.PickupsEnt.BowlOfSauerkraut.Var)

function mod:BowlOfSauerkrautAI(p, sprite, d)
    if not d.inut then
        sprite:ReplaceSpritesheet(0, "gfx/items/pick ups/sauerkraut_PickupsEnt" .. math.random(2) .. ".png")
        sprite:LoadGraphics()
        sprite:Update()
        d.inut = true
    end
    if sprite:IsFinished("Appear") then
        sprite:Play("Idle", false)
    end
    if sprite:IsPlaying("Collect") and sprite:GetFrame() == 5 then
        p.Visible = false
        p.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        p:Remove()
        if math.random(100000) == 1 then --alllllbuqurue
            ms:Play(Isaac.GetMusicIdByName("albuquerque"), 0.1)
        end
    end
    if sprite:IsEventTriggered("DropSound") then
        --sfx:Play(SoundEffect.SOUND_KEY_DROP0, 1, 0, false, 1.25)
    end
end

function mod.CollectBowlOfSauerkraut(player, pickup)
    local sprite = pickup:GetSprite()
    if sprite:WasEventTriggered("DropSound") or sprite:IsPlaying("Idle") then
        pickup.Touched = true
        sprite:Play("Collect")
        --sfx:Play(SoundEffect.SOUND_KEYPICKUP_GAUNTLET, 1, 0, false, math.random(147,153)/100)


        local dat = AnixbirthSaveManager.GetRunSave(player).anixbirthsaveData
        dat.BowlOfSauerkraut = dat.BowlOfSauerkraut or 1
        dat.BowlOfSauerkraut = dat.BowlOfSauerkraut + 1

        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
        player:EvaluateItems()
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE,function(_, player, flag)

    local dat = AnixbirthSaveManager.GetRunSave(player).anixbirthsaveData

    if dat.BowlOfSauerkraut and dat.BowlOfSauerkraut > 0 and dat.BowlOfSauerkraut ~= dat.BowlOfSauerkrautOld then
        player.Damage = player.Damage + (0.003+(0.002*dat.BowlOfSauerkraut))*dat.BowlOfSauerkraut
        dat.BowlOfSauerkrautOld = dat.BowlOfSauerkraut
    end
end)