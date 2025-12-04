local mod = FHAC
local game = Game()
local sfx = SFXManager()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Bosses.Megaper.Var then
        mod:MegaperAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Bosses.Megaper.ID)

mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, function(_, npc)
    if npc.Variant == mod.Bosses.Megaper.Var then
        mod:MegaperRenderAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Bosses.Megaper.ID)

function mod:MegaperAI(npc, sprite, d)

    local target = npc:GetPlayerTarget()
    local targetpos = mod:confusePos(npc, target.Position, 5, nil, nil)
    local path = npc.Pathfinder
    local room = game:GetRoom()
    local rng = RNG()
    local params = ProjectileParams()

    if npc.StateFrame < 100 then

        if npc.StateFrame%5 == 0 then
            d.targetpos = targetpos
        end

    else

        d.state = nil

        if npc.Velocity:Length() < 3 and d.state ~= "slam" then
            npc.StateFrame = 0
        end

    end

    local champSheet
    local champbodysheet
    if mod.IsDeliRoom then
        champSheet = "gfx/bosses/afterbirthplus/deliriumforms/megaper_delirium"
        champbodysheet = "gfx/bosses/afterbirthplus/deliriumforms/boss_000_bodies01"
    end
    if champSheet and champbodysheet and mod.IsDeliRoom then
        mod:ReplaceEnemySpritesheet(npc, champbodysheet, 0)
        for i  = 1, 3 do
            mod:ReplaceEnemySpritesheet(npc, champSheet, i)
        end
        sprite:LoadGraphics()

    end
    
    if not d.init then
        d.targetpos = targetpos
        d.lerpnonsense = 0.06
        d.coolaccel = 0.5
        d.state = "chase"
        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end
    
    if d.state == "chase" then

        if npc.StateFrame%50 == 0 then
            npc:PlaySound(SoundEffect.SOUND_ZOMBIE_WALKER_KID,1,0,false,0.8)
        end

        if d.coolaccel and d.coolaccel < 5 then
            d.coolaccel = d.coolaccel + 0.1
        end
        if mod:isScare(npc) then
            local targetvelocity = (d.targetpos - npc.Position):Resized(-30)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, d.lerpnonsense)
        elseif room:CheckLine(npc.Position,target.Position,0,1,false,false) then
            local targetvelocity = (d.targetpos - npc.Position):Resized(30)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, d.lerpnonsense)
        else
            path:FindGridPath(d.targetpos, 0.7, 1, true)
        end

        npc.Velocity = mod:Lerp(npc.Velocity, npc.Velocity:Resized(d.coolaccel), d.lerpnonsense)
        if npc:CollidesWithGrid() then
            d.coolaccel = 1
        end
        mod:CatheryPathFinding(npc, target.Position, {
            Speed = d.coolaccel,
            Accel = d.lerpnonsense,
            GiveUp = true
        })
        if rng:RandomInt(1, 2) == 2 then
            d.lerpnonsense = mod:Lerp(d.lerpnonsense, 0.04, 0.05)
        else
            d.lerpnonsense = mod:Lerp(d.lerpnonsense, 0.01, 0.02)
        end
    elseif d.state == "slam" then
        if not d.slaminit then
            for i = 0, 9 do
                npc:FireProjectiles(npc.Position, Vector(8,0):Rotated((36*i)), 0, params)
            end
            d.slaminit = true
        end
        if npc.StateFrame > 20 then
            d.state = "chase"
            mod:spritePlay(sprite, "New Animation")
            d.slaminit = false
        end
    end

    if npc.Velocity:Length() > 1 and d.slaminit then
        npc:AnimWalkFrame("WalkHori","WalkVert",0)
    elseif npc.Velocity:Length() < 1 then
        if sprite:GetOverlayAnimation() == "Head" then sprite:SetOverlayFrame("Head", 19) end
        sprite:SetFrame("WalkHori", 0)
    elseif sprite:GetAnimation() ~= "New Animation" then
        npc:AnimWalkFrame("RunHori","RunVert",0)
    end

    if sprite:IsFinished("New Animation") then
        sprite:SetFrame("RunHori", 0)
    end

    if npc:CollidesWithGrid() then
        d.state = "slam"
        npc:PlaySound(SoundEffect.SOUND_FORESTBOSS_STOMPS, 1, 1, false, 1)
        Game():ShakeScreen(10)
        npc.StateFrame = 0
    end

end

function mod:MegaperRenderAI(npc, sprite, d)
    mod:MakeBossDeath(npc, true)
end