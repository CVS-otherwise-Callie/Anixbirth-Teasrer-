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
    local rot = 40

    if not d.init then

        npc:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK)
	    npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
	    npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE

        local ent = mod:GetClosestEnt(npc.Position, npc)

        if ent then
            d.ENT = ent
        else
            d.ENT = mod:GetClosestPlayer(npc.Position, npc)
	    d.isentPlayer = true
        end

        d.state = "idle"
        d.shouldCirc = false

        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    if d.isentPlayer then
	rot = 70
    end

    if d.shouldCirc then
        mod:Orbit(npc, d.ENT, 1, rot)
    else

        if not d.ENT then
            local ent = mod:GetClosestEnt(npc.Position)

            if ent then
                d.ENT = ent
            else
                d.ENT = mod:GetClosestPlayer(npc.Position)
	        d.isentPlayer = true
            end
        end

        npc.Velocity = mod:Lerp(npc.Velocity,(d.ENT.Position - npc.Position):Resized(15), 0.1)
        if npc.Position:Distance(d.ENT.Position) < rot then
            d.shouldCirc = true
        end
    end

    if d.ENT and (d.ENT:IsDead() or not d.ENT:Exists()) then
        d.shouldCirc = false
        d.ENT = nil
    end

    if d.state == "idle" then
        mod:spritePlay(sprite, "Idle")
    elseif d.state == "waiting" then
        mod:spritePlay(sprite, "Suck")
    elseif d.state == "recieve" then
        mod:spritePlay(sprite, "Recieve")
    elseif d.state == "holding" then
        mod:spritePlay(sprite, "Hold")
        
        if npc.StateFrame > 100 and room:CheckLine(npc.Position,targetpos,0,1,false,false) then
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
        local realshot = Isaac.Spawn(9, 0, 0, npc.Position, Vector(7, 0):Rotated((targetpos - npc.Position):GetAngleDegrees()), npc):ToProjectile()
    end

end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, npc, amt , flag, source)
    if npc.Type == mod.Monsters.Suckup.ID and npc.Variant == mod.Monsters.Suckup.Var then
        if (npc:GetData().state == "waiting" or npc:GetData().state == "idle") then
            npc:GetData().state = "recieve"
            return false
        elseif not mod:HasDamageFlag(DamageFlag.DAMAGE_CLONES, flag) then
            npc:TakeDamage(amt*0.7 , flag | DamageFlag.DAMAGE_CLONES, source, 0)
            return false
        end
    end
end)
