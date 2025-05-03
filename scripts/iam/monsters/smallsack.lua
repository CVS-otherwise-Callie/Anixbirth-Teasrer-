local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.SmallSack.Var then
        mod:SmallSackAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.SmallSack.ID)

function mod:SmallSackAI(npc, sprite, d)

    if not d.init then
        if not d.state == "appear" then
            if npc.SubType == 1 then
                d.state = "wait"
            else
                d.state = "idle"
            end
        end
        d.lev = 1
        d.stage = 1
        npc:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK)
        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    npc:MultiplyFriction(0)

    if d.state == "appear" then
        mod:spritePlay(sprite, "SackAppear")
    elseif d.state == "idle" then
        mod:spritePlay(sprite, "Idle" .. d.lev .. "Stage" .. d.stage)
    elseif d.state == "wait" then
        if npc.StateFrame > 200 then
            d.state = "die"
        elseif npc.StateFrame > 180 then
            d.lev = 4
        elseif npc.StateFrame > 120 then
            d.lev = 3
        elseif npc.StateFrame > 60 then
            d.lev = 2
        end

        mod:spritePlay(sprite, "Idle" .. d.lev .. "Stage" .. d.stage)
    elseif d.state == "die" then
        mod:spritePlay(sprite, "Death" .. d.stage)
    end

    if sprite:IsFinished("Death" .. d.stage) then
        npc:Kill()
    end

    if sprite:IsEventTriggered("Death") then
        for i = 1, d.stage do
            local ents = {
                {EntityType.ENTITY_ATTACKFLY, 0},
                {EntityType.ENTITY_SPIDER, 0},
                {EntityType.ENTITY_DART_FLY, 0}
            }

            local choice = math.random(#ents)

            Isaac.Spawn(ents[choice][1], ents[choice][2], 0, npc.Position, Vector.Zero, nil)
        end
    end

    if sprite:IsFinished("SackAppear") then
        if npc.SubType == 1 then
            d.state = "wait"
        else
            d.state = "idle"
        end
    end
end

