local mod = FHAC
local game = Game()
local rng = RNG()
local room = game:GetRoom()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.Neutralfly.Var then
        mod:NeutralflyAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.Neutralfly.ID)

function mod:NeutralflyAI(npc, sprite, d)
    local possibleinits = {}
    
    if not d.init then
        d.entitypos = 500
        d.exaggeratednewpos = 0
        d.newpos = 0
        d.slowdowntime = 0.9
        npc.SpriteOffset = Vector(0,-12)
        npc.StateFrame = 60
        d.rounds = 0
        d.speedup = 0
        d.rotation =  45 * rng:RandomInt(1, 8)
        d.state = "idle"
        

        --here's some other shit to do
        d.accel = 0
        d.newpos = nil
        npc.StateFrame = 20
        npc.Velocity = Vector.Zero
        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    if d.state == "idle" then
        d.accel = 1
        --d.accel = 0
        npc.Velocity = npc.Velocity * d.slowdowntime
        d.slowdowntime = d.slowdowntime - 0.005
        sprite:Play("Idle")
        if npc.StateFrame == 30 then
                d.rounds = 0
                d.state = "moving"
        end
        if npc.Position then
        if room:GetGridCollisionAtPos(npc.Position) then
            if room:GetGridCollisionAtPos(npc.Position) > 2 then
                npc.GridCollisionClass = GridCollisionClass.COLLISION_WALL_EXCEPT_PLAYER
            else
                npc.GridCollisionClass = GridCollisionClass.COLLISION_SOLID
            end
        end
        end
    end
    --thx erfly
    

    if d.state == "moving" then
                if d.rounds >= 4 then
                    d.slowdowntime = 0.9
                    d.rounds = 0
                    npc.StateFrame = 0
                    d.state = "idle"
                end
                if npc.StateFrame == 10 then
                    d.newpos = nil
                    for i = 1, 8 do
                        d.newpos = npc.Position + Vector(15 + d.speedup, 15 + d.speedup):Rotated(i * 45)
                        d.exaggeratednewpos = npc.Position + Vector(20 + d.speedup, 20 + d.speedup):Rotated(i * 45)
                        if room:IsPositionInRoom(d.exaggeratednewpos, 0) and room:GetGridCollisionAtPos(d.exaggeratednewpos) < 2 then
                            table.insert(possibleinits, d.newpos)
                        end
                    end
                    if not mod:IsTableEmpty(possibleinits) then
                        d.newpos = possibleinits[math.random(#possibleinits)] - npc.Position
                    else
                        d.newpos = Vector(20 + d.speedup, 20 + d.speedup):Rotated(d.rotation)
                    end
                    d.rounds = d.rounds + 1
                    d.accel = 0
                    d.speedup = d.rounds * 2
                elseif npc.StateFrame > 30 then
                    npc.StateFrame = 0
                end

                if npc.StateFrame > 25 and d.newpos then
                    if mod:isScare(npc) then
                        npc.Velocity = mod:Lerp(npc.Velocity, Vector(2, 0), 1, 5, 5)
                    else
                        npc.Velocity = mod:Lerp(npc.Velocity, d.newpos, 0.12 + (d.accel * 0.01), 2, 2)
                        if d.newpos:Rotated(-90):GetAngleDegrees() < 0 then
                            sprite.FlipX = true
                        else
                            sprite.FlipX = false
                        end
                        if npc.StateFrame == 26 then
                            npc.GridCollisionClass = GridCollisionClass.COLLISION_SOLID
                            if d.newpos:GetAngleDegrees() < 0 then
                                mod:spritePlay(sprite, "MovingUp")
                            else
                                mod:spritePlay(sprite, "MovingDown")
                            end
                        end
                        d.accel = d.accel + 1
                    end
                    --may as well
                end
    end

end

