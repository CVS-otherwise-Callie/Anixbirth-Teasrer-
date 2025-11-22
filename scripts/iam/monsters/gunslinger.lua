local mod = FHAC
local game = Game()
local rng = RNG()
local sfx = SFXManager()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.CVSMonsters.Gunslinger.Var and npc.SubType == 0 then
        mod:GunslingerAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.CVSMonsters.Gunslinger.ID)

function mod:GunslingerAI(npc, sprite, d)

    local target = npc:GetPlayerTarget()
    local targetpos = mod:confusePos(npc, target.Position, 5, nil, nil)
    local room = game:GetRoom()
    local path = npc.Pathfinder
    local params = ProjectileParams()
    local teartab = {}

    if not d.init then
        d.wait = math.random(-5, 5)
        npc.GridCollisionClass = GridCollisionClass.COLLISION_WALL_EXCEPT_PLAYER
        d.newpos = mod:freeGrid(npc, true, 400, 0)
        d.state = "fly"
        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    d.targetpos = targetpos

    if d.state == "fly" then
        npc:ClearEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK)
        mod:spritePlay(sprite, "Fly")

        if mod:isCharm(npc) then
            if (Game():GetRoom():CheckLine(npc.Position, targetpos, 0, 1, false, false) and not npc:CollidesWithGrid()) or npc:GetChampionColorIdx() == 8 then
                npc.Velocity = npc.Velocity + (targetpos - npc.Position):Normalized() * 1.35
            else
                path:FindGridPath(targetpos, 0.85, 1, true)
            end
        elseif mod:isScare(npc) then
            if (Game():GetRoom():CheckLine(npc.Position, targetpos, 0, 1, false, false) and not npc:CollidesWithGrid()) or npc:GetChampionColorIdx() == 8 then
                npc.Velocity = npc.Velocity + (targetpos - npc.Position):Normalized() * -1.35
            else
                path:FindGridPath(targetpos, -0.85, 1, true)
            end
        else
            if npc.Position:Distance(d.newpos) < 20 then
                d.wait = 0
                d.newpos = mod:freeGrid(npc, true, 400, 0)
                npc.StateFrame = 0
            elseif npc.StateFrame > 25 + d.wait then
                if mod:isScare(npc) then
                    npc.Velocity = mod:Lerp(npc.Velocity, Vector(-7, 0):Rotated((d.newpos - npc.Position):GetAngleDegrees()), 0.2)
                elseif room:CheckLine(npc.Position,d.newpos,0,1,false,false) then
                    npc.Velocity = mod:Lerp(npc.Velocity, Vector(7, 0):Rotated((d.newpos - npc.Position):GetAngleDegrees()), 0.2)
                else
                    path:FindGridPath(d.newpos, 0.7, 1, true)
                end
            end
        end

        path:EvadeTarget(targetpos)

        
        if npc.StateFrame > 50 and game:GetRoom():CheckLine(target.Position,npc.Position,3,900,false,false) then
            d.state = "shoot"
        end

    elseif d.state == "shoot" then

        mod:spritePlay(sprite, "ItemHold")

        npc:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK)
        npc:MultiplyFriction(0.75)
    end

    if sprite:IsFinished("ItemHold") then
        d.state = "fly"
        npc.StateFrame = 0
    end

    if sprite:IsEventTriggered("gun") then
        local gun = Isaac.Spawn(EntityType.ENTITY_EFFECT, 2556, 0, npc.Position, Vector(10, 0):Rotated((targetpos - npc.Position):GetAngleDegrees()+ math.random(-50, 50)), npc)
        gun:GetData().target = target
        gun.Parent = npc
    elseif sprite:IsEventTriggered("Hold") then
        npc:PlaySound(SoundEffect.SOUND_CHOIR_UNLOCK, 0.3, 0, false, 1)
    end

end


