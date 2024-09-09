local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.Snidge.Var then
        mod:SnidgeAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.Snidge.ID)
--funny fly
function mod:SnidgeAI(npc, sprite, d)
    local target = npc:GetPlayerTarget()
    npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
    if not d.init then
        npc.GridCollisionClass = GridCollisionClass.COLLISION_WALL_EXCEPT_PLAYER
        d.targetpos = mod:confusePos(npc, target.Position, 5, nil, nil)
        d.istear = false
        npc.StateFrame = 0
        d.predeterminedoffset = Vector.Zero
        d.enemydir = Vector.Zero
        mod:spritePlay(sprite, "Idle")
        d.init = true
    else
        if not d.istear then
            d.targetpos = mod:confusePos(npc, target.Position, 5, nil, nil)
        end
        npc.StateFrame = npc.StateFrame + 1
    end

    if target.Position.X < npc.Position.X then --future me pls don't fuck this up
        sprite.FlipX = true
        else
        sprite.FlipX = false
    end

    d.newpos = d.targetpos + d.predeterminedoffset
    d.newpos = d.newpos - npc.Position

    if mod:isScare(npc) then
        npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero)
    else
        npc.Velocity = mod:Lerp(npc.Velocity, d.newpos, 0.5/npc.Position:Distance(target.Position))
    end

    if npc.StateFrame >= 5 then
        d.predeterminedoffset = Vector(20, 0):Rotated(rng:RandomInt(-300, 300))
        d.oldpos = d.targetpos + d.predeterminedoffset
        npc.StateFrame = 0
    end

end

mod:AddCallback(ModCallbacks.MC_PRE_NPC_COLLISION, function(ent, colent)
if ent.Variant == mod.Monsters.Snidge.Var then
    if colent == Isaac.GetEntityVariantByName("Tear") then
        colent:Kill()
        return false
    elseif colent.Type == 1 then
        print("yeaahhhh")
        ent.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
    end
    print(colent.Type)
    return true
end
end,mod.Monsters.Snidge.ID)

