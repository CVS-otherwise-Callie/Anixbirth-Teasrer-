local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.AngeryMan.Var then
        mod:AngerymanAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.AngeryMan.ID)

function mod:AngerymanAI(npc, sprite, d)

    local webHP = 50

    local target = npc:GetPlayerTarget()
    local targetpos = mod:confusePos(npc, target.Position, 5, nil, nil)
    local path = npc.Pathfinder
    local room = game:GetRoom()

    if not d.init then
        d.state = "stuck"
        d.stuckdegradeNum = 0
        d.head = tostring(math.random(3))
        d.init = true
    end

    if d.state == "stuck" then
        npc:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK)
        if d.stuckdegradeNum > webHP then
            d.state = "awaken"
        end
        mod:spriteOverlayPlay(sprite, "HeadCalm" .. d.head)
        sprite:SetFrame(math.floor(3-math.ceil((webHP - d.stuckdegradeNum)/(webHP/3))))
    elseif d.state == "awaken" then
        mod:spriteOverlayPlay(sprite, "HeadTransition" .. d.head)
    elseif d.state == "chase" then
        mod:spriteOverlayPlay(sprite, "HeadMad" .. d.head)

        if mod:isScare(npc) then
            local targetvelocity = (targetpos - npc.Position):Resized(-4)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.2)
        elseif room:CheckLine(npc.Position,targetpos,0,1,false,false) then
            local targetvelocity = (targetpos - npc.Position):Resized(4)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.2)
        else
            path:FindGridPath(targetpos, 0.7, 1, true)
        end

        if npc.Velocity:Length() > 1.3 then
            npc:AnimWalkFrame("WalkHori","WalkVert",0.1)
        else
            sprite:SetFrame("WalkHori", 0)
        end
    end

    if sprite:IsOverlayFinished("HeadTransition" .. d.head) then
        d.state = "chase"
    end

end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, npc, damage, flag, source)
    if npc.Type == mod.Monsters.AngeryMan.ID and npc.Variant == mod.Monsters.AngeryMan.Var and flag ~= flag | DamageFlag.DAMAGE_CLONES then
        if npc:GetData().state == "stuck" or npc:GetData().state == "awaken" then
            npc:GetData().stuckdegradeNum = npc:GetData().stuckdegradeNum + damage
            return false
        end
    end
end)

