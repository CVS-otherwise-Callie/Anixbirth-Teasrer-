local mod = FHAC
local game = Game()
local rng = RNG()


mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.Toast.Var then
        mod:ToastAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.Toast.ID)

function mod:ToastAI(npc, sprite, d)

    local target = npc:GetPlayerTarget()
    local targetpos = mod:confusePos(npc, target.Position, 5, nil, nil)

    if not d.init then
        d.state = "hiding"
        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    if d.state == "hiding" then
        npc.DepthOffset = -20
        npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        npc:AddEntityFlags(EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_DEATH_TRIGGER)
        npc.GridCollisionClass = GridCollisionClass.COLLISION_WALL_EXCEPT_PLAYER
        mod:spritePlay(sprite, "Hidden")

        if targetpos:Distance(npc.Position) < 35 then
            sprite:Play("SwitchedOff")
            npc.StateFrame = 0
        elseif (npc.StateFrame > 50 and targetpos:Distance(npc.Position) < 200) then
            d.state = "popup"
        end
    elseif d.state == "offhiding" then
        if sprite:GetFrame() ~= 0 then return end
    
        mod:spritePlay(sprite, "Off")
        d.oldstate = "offhiding"

        if (targetpos:Distance(npc.Position) < 35 and npc.StateFrame > 60) or targetpos:Distance(npc.Position) > 40 then
            d.state = "popup"
            print("grr")
            sprite:Play("SwitchedOn")
        end

    elseif d.state == "popup" then

        mod:spritePlay(sprite, "Reveal")
    end

    if sprite:IsFinished("SwitchedOff") then
        d.state = "offhiding"
    elseif sprite:IsFinished("SwitchedOn") then
        d.state = "popup"
    end

end

