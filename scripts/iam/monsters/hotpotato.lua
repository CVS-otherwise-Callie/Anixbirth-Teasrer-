local mod = FHAC
local game = Game()
local rng = RNG()

local enemyStats = {
    state = "wander"
}

function mod:HotPotatoAI(npc, sprite, d)

    local room = game:GetRoom()
    local target = npc:GetPlayerTarget()
    local targetpos = mod:confusePos(npc, target.Position, 5, nil, nil)
    local path = npc.Pathfinder

    if not d.init then
        for name, stat in pairs(enemyStats) do
            d[name] = d[name] or stat
        end
        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    if d.state == "wander" then
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
        npc:MultiplyFriction(0.65+(0.016))

        mod:spritePlay(sprite, "Walk" .. mod:GetMoveString(npc.Velocity, false, false))
    elseif d.state == "chase" then
        if mod:isScare(npc) then
            local targetvelocity = (targetpos - npc.Position):Resized(-4)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.6)
        elseif room:CheckLine(npc.Position,targetpos,0,1,false,false) then
            local targetvelocity = (targetpos - npc.Position):Resized(4)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.6)
        else
            path:FindGridPath(targetpos, 1.3, 1, true)
        end

        mod:spritePlay(sprite, "Run" .. mod:GetMoveString(npc.Velocity, false, false) .. math.ceil(npc.StateFrame / 10))
    end

    if sprite:IsFinished("Lit") then
        d.state = "chase"
    end

end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, npc, damage, flags, guy)
    if npc.Type == 161 and npc.Variant == mod.Monsters.HotPotato.Var and flags == flags | DamageFlag.DAMAGE_FIRE then
        npc:GetData().state = nil
        npc:GetSprite():Play("Lit")
        return false
    end
end)

