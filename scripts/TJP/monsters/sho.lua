local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.Sho.Var then
        mod:ShoAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.Sho.ID)

function mod:ShoAI(npc, sprite, d)
    local target = npc:GetPlayerTarget()
    local targetpos = mod:confusePos(npc, target.Position, 5, nil, nil)
    local path = npc.Pathfinder
    local room = game:GetRoom()

    if not d.init then
        d.state = "scared"

        d.init = true
    end

    if d.state == "scared" then
        npc.Velocity = npc.Velocity + npc.Velocity:Normalized() * 1.05
        path:MoveRandomly(false)
        --npc:MultiplyFriction(0.65+(0.016))
    end

end

