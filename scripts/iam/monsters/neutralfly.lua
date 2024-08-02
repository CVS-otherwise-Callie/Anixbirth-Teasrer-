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
        d.speedup = 0
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
        if d.accel > 0 then
            d.accel = d.accel - 0.1  
        end
        sprite:Play("Idle")
        if d.accel <= 0 then
                d.rounds = 0
                d.state = "moving"
        end
        if npc.Position then

        end
    end
    --thx erfly
    

    if d.state == "moving" then
        if d.rounds >= 4 then
            if game:GetRoom():GetGridCollisionAtPos(npc.Position) < 2 then
                d.rounds = 0
                npc.StateFrame = 0
                d.state = "idle"
            else
                d.rounds = 3
            end
        end
        if npc.StateFrame == 10 then
                for i = 1, 360 do
                    local coolpos = npc.Position + Vector(1, 1):Rotated(i)
                    if room:IsPositionInRoom(coolpos, 0) and room:GetGridCollisionAtPos(coolpos) < 2 and math.abs((coolpos - npc.Position):GetAngleDegrees()) < 180 and (room:GetCenterPos() - coolpos):Length() < 100 then
                        table.insert(possibleinits, coolpos)
                    end
                end  
                if not mod:IsTableEmpty(possibleinits) then
                    d.newpos = possibleinits[math.random(#possibleinits)] - npc.Position
                elseif d.newpos then
                    d.newpos = d.newpos:Rotated(180)
                else
                    d.newpos = Vector(1, 1):Rotated(rng:RandomInt(100))
                end
                d.rounds = d.rounds + 1
                d.speedup = d.rounds * 2
            elseif npc.StateFrame > 30 + d.rounds then
                npc.StateFrame = 0
            end
            if npc.StateFrame > 25 + d.rounds and d.newpos then
                if d.accel <= 4 + d.rounds then
                d.accel = d.accel + 1
                end
            else
                if d.accel >= 0 then
                    d.accel = d.accel - 0.1  
                end
            end
                if d.newpos then
                if npc.Position.Y+d.newpos.Y < npc.Position.Y then
                    d.spritedir = "MovingUp"
                else
                    d.spritedir = "MovingDown"
                end
                if npc.Position.X+d.newpos.X < npc.Position.X then
                    if d.spritedir == "MovingUp" then
                        sprite.FlipX = true
                    else
                        sprite.FlipX = false
                    end
                else
                    if d.spritedir == "MovingDown" then
                        sprite.FlipX = false
                    else
                        sprite.FlipX = true
                    end    
                end 
                mod:spritePlay(sprite, d.spritedir)
            end
    end
    if d.newpos then
    if mod:isScare(npc) then
        npc.Velocity = mod:Lerp(npc.Velocity,d.newpos, -1*(0.3)):Resized(d.accel * 2)
    else
        npc.Velocity = mod:Lerp(npc.Velocity, d.newpos, 0.3):Resized(d.accel * 2)
        if npc.StateFrame == 26 then
            npc.GridCollisionClass = GridCollisionClass.COLLISION_SOLID
        end
    end--may as well
    end
end

