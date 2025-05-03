local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.Weblet.Var then
        mod:WebletAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.Weblet.ID)

function mod:WebletAI(npc, sprite, d)
    local path = npc.Pathfinder
    local room = game:GetRoom()
    local player = npc:GetPlayerTarget()

    if not d.init then
        d.speed = 10
        d.init = true
        d.state = "chase"
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    if d.state == "chase" then
        d.emotion = "Excited"
        d.playerpos = mod:confusePos(npc, player.Position,5 , nil, nil)
        d.targetpos = mod:GetClosestMinisaacAttackPos(npc.Position, d.playerpos, 150, true, 60)

        if npc.Position:Distance(d.playerpos) < 20 then
            path:EvadeTarget(d.playerpos)
        elseif npc.Position:Distance(d.targetpos) > 5 then
            if room:CheckLine(npc.Position,d.targetpos,0,1,false,false) then
                local targetvelocity = (d.targetpos - npc.Position):Resized(d.speed)
                npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.1)
            else
                path:FindGridPath(d.targetpos, d.speed/7, 0, false)
            end
        else
            if npc.Velocity:Length() < 0.01 then
                npc.Velocity = npc.Velocity*0
            else
                npc.Velocity = npc.Velocity*0.75
            end
        end

    end

    if npc.StateFrame%3 == 0 then
        d.faceframe = npc.StateFrame%2
    end

    if npc.Velocity:Length() > 1 then
        if math.abs(npc.Velocity.X) > math.abs(npc.Velocity.Y) then
            if npc.Velocity.X > 0 then
                mod:spritePlay(sprite, "WalkRight")
                sprite:SetOverlayFrame("HeadRight"..d.emotion,d.faceframe)
            else
                mod:spritePlay(sprite, "WalkLeft")
                sprite:SetOverlayFrame("HeadLeft"..d.emotion,d.faceframe)
            end
        else
            if npc.Velocity.Y > 0 then
                mod:spritePlay(sprite, "WalkDown")
                sprite:SetOverlayFrame("HeadDown"..d.emotion,d.faceframe)
            else
                mod:spritePlay(sprite, "WalkUp")
                sprite:SetOverlayFrame("HeadUp"..d.emotion,d.faceframe)
            end
        end
    else
        sprite:SetFrame("WalkDown",0)
        sprite:SetOverlayFrame("HeadDown"..d.emotion, d.faceframe)
    end

end

