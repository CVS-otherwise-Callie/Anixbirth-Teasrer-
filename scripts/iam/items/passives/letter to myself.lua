local mod = FHAC
local game = Game()

local letterToMyselfRewards = {
    {{5, 20, 0, 2}, {5, 40, 0, 1}},
    {{5, 20, 2, 2}, {5, 30, 1, 1}},
    {{5, 10, 8, 3}, {5, 300, 0, 1}},
    {{5, 300, 0, 2}, {5, 10, 3, 1}, {5, 20, 0, 2}, {5, 30, 1, 1}}
}

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
    if mod:AnyPlayerHasCollectible(mod.Collectibles.Items.LetterToMyself) then

        if not AnixbirthSaveManager.GetRunSave().lettertoMyself then
            AnixbirthSaveManager.GetRunSave().lettertoMyself = {}
            for i = 1, game:GetNumPlayers() do
                local player = Isaac.GetPlayer(i)
                if mod:AnyPlayerHasCollectible(mod.Collectibles.Items.LetterToMyself) then
                    AnixbirthSaveManager.GetRunSave().lettertoMyself[tostring(player.InitSeed)] = game:GetLevel():GetAbsoluteStage()
                end
            end
        else
            for i = 1, game:GetNumPlayers() do
                local player = Isaac.GetPlayer(i)
                if AnixbirthSaveManager.GetRunSave().lettertoMyself[tostring(player.InitSeed)] then
                    AnixbirthSaveManager.GetRunSave().lettertoMyself[tostring(player.InitSeed)] = game:GetLevel():GetAbsoluteStage()
                end
            end 
        end

        if #Isaac.FindByType(mod.Collectibles.PickupsEnt.LetterToMyself.ID, mod.Collectibles.PickupsEnt.LetterToMyself.Var) == 0 then
            for i = 1, game:GetNumPlayers() do
                local player = Isaac.GetPlayer(i)
                local num = AnixbirthSaveManager.GetRunSave(player).anixbirthsaveData.HasOpenedLetter or 0
                if AnixbirthSaveManager.GetRunSave(player).anixbirthsaveData.HasOpenedLetter ~= player:GetCollectibleNum(mod.Collectibles.Items.LetterToMyself) then
                    for j = 1, player:GetCollectibleNum(mod.Collectibles.Items.LetterToMyself) - num do
                            Isaac.Spawn(mod.Collectibles.PickupsEnt.LetterToMyself.ID, mod.Collectibles.PickupsEnt.LetterToMyself.Var, 0, Game():GetRoom():FindFreePickupSpawnPosition(Vector(500, 500), 5, true, false), Vector.Zero, nil)   
                    end
                end
            end 
        end
    end
end)

function mod:LetterToMyselfCollAI(npc, sprite, d, coll)

    if not coll.Type == 1 then return end

    if AnixbirthSaveManager.GetRunSave(coll:ToPlayer()).anixbirthsaveData and (AnixbirthSaveManager.GetRunSave(coll:ToPlayer()).anixbirthsaveData.HasOpenedLetter == coll:ToPlayer():GetCollectibleNum(mod.Collectibles.Items.LetterToMyself)) then return end

    if d.hasOpened then return end

    if sprite:WasEventTriggered("DropSound") or sprite:IsPlaying("Idle") then
        npc.Touched = true

        if d.hasRewarded == true then return end

        d.hasRewarded = true
        d.state = "opened"
        mod:spritePlay(sprite, "Collect")

        AnixbirthSaveManager.GetRunSave(coll:ToPlayer()).anixbirthsaveData = AnixbirthSaveManager.GetRunSave(coll:ToPlayer()).anixbirthsaveData or {}
        AnixbirthSaveManager.GetRunSave(coll:ToPlayer()).anixbirthsaveData.HasOpenedLetter = AnixbirthSaveManager.GetRunSave(coll:ToPlayer()).anixbirthsaveData.HasOpenedLetter or 0
        AnixbirthSaveManager.GetRunSave(coll:ToPlayer()).anixbirthsaveData.HasOpenedLetter = AnixbirthSaveManager.GetRunSave(coll:ToPlayer()).anixbirthsaveData.HasOpenedLetter + 1
    end
end

function mod:LetterToMyselfAI(npc, sprite, d)

    if d.hasOpened then
        mod:spritePlay(sprite, "Open")
        return
    end

    if not d.init then
        sprite:Play("Appear")
        d.fakeStateFrame = 0
        d.init = true
    end

    d.fakeStateFrame = d.fakeStateFrame + 1

    if sprite:WasEventTriggered("DropSound") or sprite:IsPlaying("Idle") then
        d.state = "dissapear"

        if d.state == "dissapear" and d.fakeStateFrame > 100 then
            mod:spritePlay(sprite, "Teleport")
        elseif not d.hasRewarded then
            mod:spritePlay(sprite, "Idle")
        else
            mod:spritePlay(sprite, "Open")
            d.hasOpened = true
        end
    end

    if sprite:IsFinished("Teleport") or sprite:IsFinished("TeleportOpen") then
        npc:Remove()
    end

    if sprite:IsEventTriggered("Reward") then
        if not letterToMyselfRewards[d.rewardNum-1] then Isaac.Spawn(EntityType.ENTITY_FLY, 0, 0, npc.Position, Vector.Zero, nil) return end
        for _, v in ipairs(letterToMyselfRewards[d.rewardNum-1]) do
            for i = 1, v[4] do
                if v[2] == 20 then
                    Isaac.Spawn(5, 20, v[3], npc.Position, RandomVector()*math.random(2,5), nil)
                else
                    Isaac.Spawn(v[1], v[2], v[3], npc.Position, RandomVector()*math.random(2,5), nil)
                end
            end
        end
    end

    npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY

    npc:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK)

    if d.hasRewarded and sprite:IsFinished("Collect") then
        sprite:Play("Open")
        d.state = "opened"

    end
end

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, npc)
    AnixbirthSaveManager.GetRunSave().anixbirthsaveData[tostring(npc.InitSeed .. Game():GetLevel():GetCurrentRoomDesc().ListIndex)] = AnixbirthSaveManager.GetRunSave().anixbirthsaveData[tostring(npc.InitSeed .. Game():GetLevel():GetCurrentRoomDesc().ListIndex)] or {}
    mod:LetterToMyselfAI(npc, npc:GetSprite(), AnixbirthSaveManager.GetRunSave().anixbirthsaveData[tostring(npc.InitSeed .. Game():GetLevel():GetCurrentRoomDesc().ListIndex)])
end, mod.Collectibles.PickupsEnt.LetterToMyself.Var)

mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, function(_, npc, coll)
        if coll.Type == 1 and AnixbirthSaveManager.GetRunSave().lettertoMyself[tostring(coll.InitSeed)] then
            AnixbirthSaveManager.GetRunSave().anixbirthsaveData[tostring(npc.InitSeed .. Game():GetLevel():GetCurrentRoomDesc().ListIndex)].rewardNum = AnixbirthSaveManager.GetRunSave().lettertoMyself[tostring(coll.InitSeed)]
            if AnixbirthSaveManager.GetRunSave().anixbirthsaveData[tostring(npc.InitSeed .. Game():GetLevel():GetCurrentRoomDesc().ListIndex)].rewardNum then
                mod:LetterToMyselfCollAI(npc, npc:GetSprite(), AnixbirthSaveManager.GetRunSave().anixbirthsaveData[tostring(npc.InitSeed .. Game():GetLevel():GetCurrentRoomDesc().ListIndex)], coll)
            end
        end
end, mod.Collectibles.PickupsEnt.LetterToMyself.Var)