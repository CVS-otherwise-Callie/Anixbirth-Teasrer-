local mod = FHAC
local game = Game()
local rng = RNG()
local pitpatinbetweentime = 20
local pitpatspawnertime = 0

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.PitPatSpawner.Var and npc.SubType >= 1 then
        mod:PitPatSpawnerAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.PitPatSpawner.ID)

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.PitPat.Var and npc.SubType == mod.Monsters.PitPat.Sub then
        mod:PitPatAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.PitPat.ID)

function mod:PitPatSpawnerAI(npc, sprite, d)

    if not d.init then
        d.pitpatspawnerdiff = pitpatspawnertime
        pitpatspawnertime = pitpatspawnertime + 5
        d.iterateover = 1
        d.pitpattable = d.pitpattable or {}
        npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        npc:AddEntityFlags(EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_STATUS_EFFECTS)
        npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE 
        for i = 0, npc.SubType do
            local wormie = Isaac.Spawn(Isaac.GetEntityTypeByName("Pit Pat"),  Isaac.GetEntityVariantByName("Pit Pat"), Isaac.GetEntitySubTypeByName("Pit Pat"), npc.Position, Vector.Zero, npc)
            local wormdata = wormie:GetData()
            wormdata.height = 20 + i
            wormdata.speed = rng:RandomInt(1, 10)
            wormdata.peakwait = rng:RandomInt(1, 5)
            if math.random(2) == 2 then wormdata.shoot = true end
            wormdata.JumpNum = i*5
            table.insert(d.pitpattable, wormie)
        end
        npc.Position = Vector(0, 0)
        d.init = true
    else
        d.pitpattable = d.pitpattable or {}
        npc.StateFrame = npc.StateFrame + 1
    end

    if game.Difficulty > 1 then
        if game.Difficulty == 2 then
            pitpatinbetweentime = 20 - math.floor(npc.SubType/15)/math.random(7, 13) + d.pitpatspawnerdiff
        else
            pitpatinbetweentime = 10 - math.floor(npc.SubType/15)/math.random(7, 13) + d.pitpatspawnerdiff
        end
    else
        if game.Difficulty == 0 then
            pitpatinbetweentime = 20 - math.floor(npc.SubType/15)/math.random(7, 13)  + d.pitpatspawnerdiff
        else
            pitpatinbetweentime = 10 - math.floor(npc.SubType/15)/math.random(7, 13) + d.pitpatspawnerdiff
        end
    end

    if npc.StateFrame > 10+(d.iterateover*pitpatinbetweentime) and npc.StateFrame < 10+pitpatinbetweentime+(d.iterateover*pitpatinbetweentime) then --look ik this is the wrong way to do it but im TIRREEDDD
        if d.pitpattable[d.iterateover]:GetData().state == "wait" then 
            d.pitpattable[d.iterateover]:GetData().state = "jumpinit"
        end
        d.iterateover = d.iterateover + 1
        if d.iterateover > #d.pitpattable then
            d.iterateover = 1
            npc.StateFrame = 0
        end
    end

    mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, npc, amt, flag, source)
        if npc.Variant == mod.Monsters.PitPatSpawner.Var  and npc.SubType < 11 then
            if mod:IsSourceofDamagePlayer(source, true) or mod:IsSourceofDamagePlayer(source, false) then return false end
            return true
        end
    end, mod.Monsters.PitPatSpawner.ID)
end

function mod:PitPatAI(npc, sprite, d)

    if not d.pitinit then
        d.stateframe = 0 --fuck u
        d.state = "wait"
        d.jumpinit = false
        npc.SpriteOffset = Vector(10, -10)
        npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        npc:AddEntityFlags(EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_STATUS_EFFECTS)
        npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        npc.GridCollisionClass = GridCollisionClass.COLLISION_SOLID
        local grid = mod:freeHole(npc, false, 1000, 0)
        if not grid then
            npc.Position = Vector(-50, 50)
        else
            npc.Position = grid
        end
        d.speed = 1
        d.pitinit = true
    else
        d.firstheight = Vector(0, -30)
        d.stateframe = d.stateframe + 1
    end

    if d.state == "jumpin" then
        local height = d.height or 20
        local speed = d.speed or 5
        local peakwait = d.peakwait or 2
        local shoot = d.shoot or false
        local jumpVec = npc.SpriteOffset
        local horimove = 70
        if d.flip then horimove = -70 else horimove = 70 end
        d.heighttoget = d.heighttoget or npc.SpriteOffset - Vector(0, height)
        d.jumpinit = true
        if sprite:IsFinished("JumpStart") then
            if d.anim ~= "JumpUp" and not d.hasjumped then
                d.hasjumped = true --set this to false at end of jump
                npc.SpriteOffset = npc.SpriteOffset - Vector(0, 30)
                d.anim = "JumpUp"
            end
        end
        if npc.SpriteOffset.Y < d.heighttoget.Y and sprite:IsPlaying("JumpUp") or d.anim == "JumpUp" then
            d.anim = "EaseTopUp"
        end
        if npc.SpriteOffset.Y > d.firstheight.Y and sprite:IsPlaying("FallDown") then
            d.anim = "FallEnd"
        end
        if d.anim == "JumpUp" then
            jumpVec = npc.SpriteOffset - Vector(0, height)
        end
        if d.anim == "EaseTopUp" then
            if not d.easeinit then
                jumpVec = npc.SpriteOffset - Vector(horimove,height/20)
                d.stateframe = 0
                d.heighttimer = 0
                d.easeinit = true --set this to false at end of jump
            end
            if d.stateframe >= math.floor(5/speed) then
                d.anim = "Top"
            end
            jumpVec = npc.SpriteOffset - Vector(0, height/20)
        end
        if d.anim == "Top" then
            if not d.topinit then
                d.easeinit = false -- ste this to false at end of jump
                d.stateframe = 0
                d.heighttimer = 0
                d.topinit = true --set this to false at end of jump
            end
            if d.stateframe >= peakwait then
                d.heighttimer = d.heighttimer + 1
                d.stateframe = 0
            end
            if d.heighttimer >= height/2 then
                jumpVec = npc.SpriteOffset + Vector(0, 1/10)
            else
                jumpVec = npc.SpriteOffset - Vector(0, 1/10)
            end
            if d.heighttimer >= peakwait then
                d.anim = "EaseTopDown"
            end
        end
        if d.anim == "EaseTopDown" then
            if not d.easeinit then
                jumpVec = npc.SpriteOffset + Vector(horimove, height/10)
                d.stateframe = 0
                d.heighttimer = 0
                d.easeinit = true --set this to false at end of jump
            end
            if d.stateframe >= math.floor(5/speed) then
                d.anim = "FallDown"
            end
            jumpVec = npc.SpriteOffset - Vector(0, -1* height/20)
        end
        if d.anim == "FallDown" then
            jumpVec = npc.SpriteOffset + Vector(0, height)
        end
        if sprite:IsFinished("FallEnd") and d.anim == "FallEnd" then
            if d.state == "jumpin" then
                d.hasjumped = false
                d.easeinit = false
                d.topinit = false
                d.jumpinit = false
                d.state = "wait"
                d.stateframe = 0
            end
        end
        sprite:Play(d.anim)
        npc.SpriteOffset = mod:Lerp(npc.SpriteOffset, jumpVec, 0.001*speed, 0, 2)
    end

    if d.state == "jumpinit" then
        npc.SpriteOffset = d.firstheight
        if not d.jumpinit then
            if rng:RandomInt(1, 2) == 2 then
                sprite.FlipX = true
                d.flip = true
                else
                sprite.FlipX = false
                d.flip = false
            end
            local grid = mod:freeHole(npc, false, 1000, 0)
            if not grid then
                d.stateframe = 0
                d.state = "jumpinit"
                d.jumpinit = false
            else
                npc.Position = grid
                d.anim = "JumpStart"
                d.state = "jumpin"
                d.jumpinit = true
            end
        end
    end

end

