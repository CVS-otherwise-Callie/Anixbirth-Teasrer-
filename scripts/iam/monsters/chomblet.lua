local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.Chomblet.Var then
        mod:ChombletAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.Chomblet.ID)

function mod:ChombletAI(npc, sprite, d)

    d.newpos = d.newpos or mod:GetNewPosAligned(npc.Position, false)
    if (npc.Position:Distance(d.newpos) < 10 or npc.Velocity:Length() == 0) or (mod:isScareOrConfuse(npc) and npc.StateFrame % 10 == 0)then
        d.newpos = mod:GetNewPosAligned(npc.Position, false)
    end
    local targetvelocity = (d.newpos - npc.Position):Resized(4)
    npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 1)

    if d.newpos.X < npc.Position.X then --future me pls don't fuck this up
        sprite.FlipX = true
    else
        sprite.FlipX = false
    end

    mod:spritePlay(sprite, "Move " .. mod:GetMoveString(npc.Velocity, true))

    if d.newpos then

        if math.abs(npc.Velocity.X) < math.abs(npc.Velocity.Y) then
            d.newpos.X = npc.Position.X
        else
            d.newpos.Y = npc.Position.Y
        end

    end

end

