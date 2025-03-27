local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.NarcissismReflections.Var then
        mod:NarcissismReflectionsAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.NarcissismReflections.ID)

function mod:NarcissismReflectionsAI(npc, sprite, d)

    local target = npc:GetPlayerTarget()
    local targetpos = mod:confusePos(npc, target.Position, 5, nil, nil)
    local room = game:GetRoom()
    local num = 7
    local path = npc.Pathfinder

    if not d.init then
        d.lerpnonsense = 0.08
        d.coolaccel = 1.2
        d.init = true
    end

    if npc:CollidesWithGrid() then
        d.state = "broken"
        sprite.Rotation = 0
        npc:MultiplyFriction(0)
    end

    if d.state == "broken" then
        if not d.hasslopeded then
            d.hasslopeded = true
            for i = 1, 5 do
                local realshot = Isaac.Spawn(9, 0, 0, npc.Position,  Vector(13, 0):Rotated((targetpos - npc.Position):GetAngleDegrees() + 72*i), npc):ToProjectile()
                local psprite = realshot:GetSprite()
                psprite:ReplaceSpritesheet(0, "gfx/projectiles/mirror shard.png")
                psprite.Rotation = ((targetpos - npc.Position):GetAngleDegrees() + 72*i)
                psprite:LoadGraphics()
            end
        end
        npc:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
        mod:spritePlay(sprite, "glass")
    else
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
            path:FindGridPath(targetpos, 0.9, 1, true)
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
    
        if npc.Velocity:Length() > 0.5 and not sprite:IsPlaying("SpawnEntityStand") then
            npc:AnimWalkFrame("MirrorHori","MirrorVert",0)
        else
            sprite:SetFrame("MirrorHori", 0)
        end
    end

end


mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, npc, damage, flag, source)
    if npc.Variant == mod.Monsters.NarcissismReflections.Var and flag ~= flag | DamageFlag.DAMAGE_CLONES then
        return false
    end
end, mod.Monsters.NarcissismReflections.ID)

