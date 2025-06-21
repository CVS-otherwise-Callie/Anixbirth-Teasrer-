local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.Suckup.Var then
        mod:SuckupAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.Suckup.ID)

function mod:SuckupAI(npc, sprite, d)

    local target = npc:GetPlayerTarget()
    local targetpos = mod:confusePos(npc, target.Position, 5, nil, nil)
    local room = game:GetRoom()
    local params = ProjectileParams()
    local rot = 40
    local speed = 1

    if not d.init then

        npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)

        local ent = mod:GetClosestEnt(npc.Position, npc)

        if ent and ent.Position:Distance(npc.Position) < 100 then
            d.ENT = ent
            d.hasHadEnt = true
            d.shouldCirc = true
        else
            d.ENT = mod:GetClosestPlayer(npc.Position, npc)
	        d.isentPlayer = true
            d.shouldCirc = false
        end

        d.state = "idle"

        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    if d.isentPlayer then
	    rot = 120
        speed = 0.5
    end

    if d.shouldCirc then
        mod:Orbit(npc, d.ENT, speed, rot)

        npc:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK)
	    npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
	    npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
    else
        npc:ClearEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK)
        npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
        local targetvelocity = (targetpos - npc.Position):Resized(5)
        npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.1)
    end

    local tr = mod:GetClosestEnt(npc.Position, npc)

    if tr and tr.Type == 2 and npc.Position:Distance(tr.Position) < 5 then
        npc:GetData().state = "recieve"
        tr:Remove()
    end

    if d.ENT and (d.ENT:IsDead() or not d.ENT:Exists()) then
        d.shouldCirc = false
        d.ENT = target
    end

    if d.ENT and d.ENT.Type == 1 then
        if mod:GetClosestEnt(npc.Position, npc) and not d.hasHadEnt and mod:GetClosestEnt(npc.Position, npc).Position:Distance(npc.Position) < 100 then
            d.ENT = mod:GetClosestEnt(npc.Position, npc)
            d.shouldCirc = true
            d.isentPlayer = false
            d.hasHadEnt = true
        end
    else
    end

    if d.state == "idle" then
        mod:spritePlay(sprite, "Idle")
    elseif d.state == "waiting" then
        mod:spritePlay(sprite, "Suck")
    elseif d.state == "recieve" then
        mod:spritePlay(sprite, "Recieve")
    elseif d.state == "holding" then
        mod:spritePlay(sprite, "Hold")
        
        if npc.StateFrame > 60 and room:CheckLine(npc.Position,targetpos,0,1,false,false) then
            d.state = "shoot"
        end
    elseif d.state == "shoot" then
        mod:spritePlay(sprite, "Shoot")
    end

    if #Isaac.FindInRadius(npc.Position, 30, EntityPartition.TEAR) ~= 0 and d.state == "idle" then
        d.state = "waiting"
    elseif d.state == "waiting" and #Isaac.FindInRadius(npc.Position, 30, EntityPartition.TEAR) == 0 then
        d.state = "idle"
    end

    if sprite:IsFinished("Recieve") then
        d.state = "holding"
        npc.StateFrame = 0
    elseif sprite:IsFinished("Shoot") then
        d.state = "idle"
    end

    if sprite:IsEventTriggered("Shoot") then

        params.Scale = 0.8

        npc:FireProjectiles(npc.Position, (targetpos - npc.Position):Resized(10), 0, params)
        npc:PlaySound(SoundEffect.SOUND_BLOODSHOOT, 0.8,2, false, 1.5)

        local effect = Isaac.Spawn(1000, 2, 5, npc.Position, Vector.Zero, npc):ToEffect()
        effect.SpriteOffset = Vector(0,-6)
        effect.DepthOffset = npc.Position.Y * 1.25
        effect.Scale = 0.7
        effect:FollowParent(npc)
    elseif sprite:IsEventTriggered("Recieve") then
        npc:PlaySound(SoundEffect.SOUND_VAMP_GULP,1,0,false,1.5)
    end

end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, npc, amt , flag, source)
    if npc.Type == mod.Monsters.Suckup.ID and npc.Variant == mod.Monsters.Suckup.Var then
        if (npc:GetData().state == "waiting" or npc:GetData().state == "idle") then
            npc:GetData().state = "recieve"
            return false
        elseif not mod:HasDamageFlag(DamageFlag.DAMAGE_CLONES, flag) and not (npc:GetData().state == "idle" or npc:GetData().state == "waiting") then
            npc:TakeDamage(amt*0.8 , flag | DamageFlag.DAMAGE_CLONES, source, 0)
            return false
        end
    end
end)

mod:AddCallback(ModCallbacks.MC_PRE_NPC_COLLISION, function(_, npc, coll, bool)
    if npc.Type == mod.Monsters.Suckup.ID and npc.Variant == mod.Monsters.Suckup.Var and coll.Type == 2 and npc:GetData().state == "recieve" then
        coll:GetSprite():ReplaceSpritesheet(0, "gfx/nothing.png")
        coll:Remove()
    end
end)