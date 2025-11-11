local mod = FHAC
local game = Game()
local rng = RNG()

function mod:HotatoAI(npc, sprite, d)

    npc.SplatColor = FHAC.Color.Charred

    local target = npc:GetPlayerTarget()
    local targetpos = mod:confusePos(npc, target.Position, 5, nil, nil)
    local path = npc.Pathfinder

    if not d.init then
        d.hpState = 1
        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    d.hpState = math.ceil((npc.MaxHitPoints - npc.HitPoints)/(npc.MaxHitPoints/(npc.MaxHitPoints/5)) + 0.01)

    -- animations --

    if d.hpState < 4 then
        if npc.Velocity:Length() > 0.5 then
            npc:AnimWalkFrame("WalkHori" .. d.hpState,"WalkVert" .. d.hpState,0)
        else
            sprite:SetFrame("WalkVert" .. d.hpState, 0)
        end
    else
        if npc.Velocity:Length() > 0.5 then
            mod:spritePlay(sprite, "Walk4")
        else
            sprite:SetFrame("Walk4", 0)
        end
    end

    if mod:isScare(npc) then
        local targetvelocity = (targetpos - npc.Position):Resized(-4 + (d.hpState/3))
        npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.25)
    elseif game:GetRoom():CheckLine(npc.Position,targetpos,0,1,false,false) then
        local targetvelocity = (targetpos - npc.Position):Resized(4 - (d.hpState/3))
        npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.25)
    else
        path:FindGridPath(targetpos, (0.5+(d.hpState/3))*0.7, 900, true)
    end

    if d.oldHP ~= d.hpState then
        local creep = Isaac.Spawn(1000, EffectVariant.CREEP_BLACK, 0, npc.Position, Vector.Zero, npc)
        creep:GetSprite().Color:SetTint(0.5, 0.5, 0.5, 0.8)
        creep:ToEffect().Timeout = 10000000
        creep:GetSprite().Scale = creep:GetSprite().Scale * (1+(1*d.hpState))
        creep:Update()

        for i = 1, math.random(3, 5) do
            local ef = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DUST_CLOUD, -1, npc.Position + Vector(math.random(-25, 25), 10),Vector.Zero, nil):ToEffect()
            ef:SetTimeout(50)
            ef.SpriteScale = Vector(0.05,0.05)
            ef:Update()
            ef.Color = Color(0.1, 0.1, 0.1, 0.4)
        end
        Isaac.Spawn(mod.Monsters.Soot.ID, mod.Monsters.Soot.Var, 0, npc.Position, Vector(2, 0):Rotated(math.random(1, 360)), nil)

    end

    d.oldHP = d.hpState

end

