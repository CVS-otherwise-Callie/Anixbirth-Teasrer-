local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.Neutralfly.Var then
        mod:NeutralflyAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.Neutralfly.ID)

function mod:NeutralflyAI(npc, sprite, d)
    local room = game:GetRoom()
    local possibleinits = {}

    if not d.init then
        d.entitypos = 500
        npc.SpriteOffset = Vector(0,-12)
        npc.StateFrame = 60
        d.rounds = 0
        d.rotation =  45 * rng:RandomInt(1, 8)
        d.state = "idle"
        

        --here's some other shit to do
        d.accel = 0
        npc.StateFrame = 20
        npc.Velocity = Vector.Zero
        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    if d.state == "idle" then
        sprite:Play("Idle")
        if npc.StateFrame > 50 then
            d.newpos = mod:freeGrid(npc, false, 200, 100)
            d.rounds = 0
            d.state = "moving"
            if d.newpos.Y < npc.Position.Y then
                d.spritedir = "MovingUp"
            else
                d.spritedir = "MovingDown"
            end
            if d.newpos.X > npc.Position.X then
                if d.spritedir == "MovingUp" then
                    sprite.FlipX = true
                else
                    sprite.FlipX = false
                end
            else
                if d.spritedir == "MovingUp" then
                    sprite.FlipX = false
                else
                    sprite.FlipX = true
                end 
            end
        end
        npc.Velocity = npc.Velocity * 0.8
    end
    --thx erfly
    

    if d.state == "moving" then
        if d.rounds > 3 then
            d.rounds = 0
            npc.StateFrame = 0
            d.state = "idle"
        end
        if npc.StateFrame > 40 or npc.Position:Distance(d.newpos) < 5 then
            d.newpos = mod:freeGrid(npc, false, 200, 100)
            npc:MultiplyFriction(0.7)
            npc.StateFrame = 0
            d.rounds = d.rounds + 1
            if d.newpos.Y < npc.Position.Y then
                d.spritedir = "MovingUp"
            else
                d.spritedir = "MovingDown"
            end
            if d.newpos.X < npc.Position.X then
                sprite.FlipX = false
            else
                sprite.FlipX = true
            end
        elseif npc.StateFrame > 10 then
            local myvec = (d.newpos - npc.Position) + (d.newpos - npc.Position):Normalized() * 1.05
            if mod:isScare(npc) then
                npc.Velocity = mod:Lerp(npc.Velocity, myvec, 0.5):Resized(-8)
            else
                npc.Velocity = mod:Lerp(npc.Velocity, myvec, 0.5):Resized(8)
            end

            mod:CatheryPathFinding(npc, d.newpos, {
                Speed = 2,
                Accel = 0.05,
                GiveUp = true
            })
        end
        mod:spritePlay(sprite, d.spritedir)
    end
end

