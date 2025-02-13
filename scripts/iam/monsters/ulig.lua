local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.Ulig.Var then
        mod:UligAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.Ulig.ID)

function mod:UligAI(npc, sprite, d)

    local target = npc:GetPlayerTarget()
    local targetpos = mod:confusePos(npc, target.Position, 5, nil, nil)
    local room = game:GetRoom()
    local num = 7
    local path = npc.Pathfinder
    local params = ProjectileParams()

    if not d.init then
        d.state = "hiding"
        d.lerpnonsense = 0.08
        d.coolaccel = 1.2
        d.CoolDown = npc.StateFrame + math.random(50, 70) - 3*num
        d.wait = math.random(20, 40) - 3*num
        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    if d.state == "hiding" then
        npc:AddEntityFlags(EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_STATUS_EFFECTS)
        npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
        npc.GridCollisionClass = GridCollisionClass.COLLISION_NONE
    elseif d.state == "getup" then
        mod:MakeVulnerable(npc)
        npc.GridCollisionClass = 5
        mod:spritePlay(sprite, "ComeUp")
        npc:PlaySound(SoundEffect.SOUND_MAGGOT_ENTER_GROUND, 1, 0, false, 1)
        d.state = nil
    elseif d.state == "chase" then

        if npc.StateFrame%30 == 0 then
            npc:PlaySound(SoundEffect.SOUND_ZOMBIE_WALKER_KID,1,0,false,1)
        end

        if npc.StateFrame > 20 then

            if d.coolaccel and d.coolaccel < 5 then
                d.coolaccel = d.coolaccel + 0.1
            end
            if mod:isScare(npc) then
                local targetvelocity = (targetpos - npc.Position):Resized(-10)
                npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, d.lerpnonsense)
            elseif path:HasPathToPos(targetpos) then
                local targetvelocity = (targetpos - npc.Position):Resized(10)
                npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, d.lerpnonsense)
            else
                path:FindGridPath(targetpos, 0.7, 1, true)
            end

            npc.Velocity = mod:Lerp(npc.Velocity, npc.Velocity:Resized(d.coolaccel), d.lerpnonsense)
            if npc:CollidesWithGrid() then
                d.coolaccel = 1
            end
            mod:CatheryPathFinding(npc, target.Position, {
                Speed = d.coolaccel,
                Accel = d.lerpnonsense,
                GiveUp = true
            })
            if rng:RandomInt(1, 2) == 2 then
                d.lerpnonsense = mod:Lerp(d.lerpnonsense, 0.04, 0.05)
            else
                d.lerpnonsense = mod:Lerp(d.lerpnonsense, 0.01, 0.02)
            end
        else
            if npc.StateFrame <= d.CoolDown then
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
                    npc.Velocity = npc.Velocity + npc.Velocity:Normalized() * 1.05
                    path:MoveRandomly(false)
                end
            end
            if npc.StateFrame > d.CoolDown+d.wait then
                d.CoolDown = npc.StateFrame + math.random(50, 70) - 3*num
                d.wait = math.random(20, 40) - 3*num
            end
            npc:MultiplyFriction(0.65+(0.016*num))
        end

        if npc.Velocity:Length() > 0.5 then
            npc:AnimWalkFrame("WalkHori","WalkVert",0)
        else
            sprite:SetFrame("WalkHori", 0)
        end
                
        sprite:Update()

        if npc.StateFrame > 90 then
            npc.StateFrame = 0
        end
        
    end

    if sprite:IsFinished("ComeUp") then
        npc.StateFrame = 0
        d.state = "chase"
    end

end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, npc, damage, flag, source)
    if npc.Variant == mod.Monsters.Ulig.Var and flag ~= flag | DamageFlag.DAMAGE_CLONES and npc:GetData().state == "hiding" then
        npc:GetData().state = "getup"
        npc.GridCollisionClass = 5
        npc:TakeDamage(damage*0.1, flag | DamageFlag.DAMAGE_CLONES, source, 0)
        return false
    end
end, mod.Monsters.Ulig.ID)