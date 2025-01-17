local mod = FHAC
local game = Game()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.LarryKingJr.Var then
        mod:LarryKingJrAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.LarryKingJr.ID)

--[[mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, function(_, npc, offset)
    if npc.Variant == mod.Monsters.LarryKingJr.Var then
        mod:LarryKingJrRenderAI(npc, npc:GetSprite(), npc:GetData(), offset)
    end
end, mod.Monsters.LarryKingJr.ID)]]

function mod:LarryKingJrAI(npc, sprite, d)
    local rng = npc:GetDropRNG()

    if not d.larryKJinit then

        d.butts = {}

        if not d.bodyInit and not d.IsSegment then
            for i = 1, 3 do
                local butt = Isaac.Spawn(mod.Monsters.LarryKingJr.ID, mod.Monsters.LarryKingJr.Var, (i > 1 and mod.Monsters.LarryKingJr.Sub or 0), npc.Position, Vector.Zero, npc)
                butt.Parent = npc
                butt.DepthOffset = -3 * i
                butt:GetData().MoveDelay = i * 3
                butt:GetData().SegNumber = i
                butt:GetData().IsSegment = true
                butt:GetData().name = "Body"
                table.insert(d.butts, butt)
            end
            d.name = "Head"
            d.bodyInit = true
            d.MoveDelay = 0
            d.MovementLog = {}
        end
        npc.StateFrame = 0
        d.state = "Moving"
        d.larryKJinit = true
    end

    if d.IsSegment and npc.Parent then
        if npc.Parent and npc.Parent:IsDead() then
            if d.SegNumber == 1 then
                d.IsButt = false
                d.name = "Head"
                d.MovementLog = {}
            end
        end
        local targpos = npc.Parent:GetData().MovementLog[npc.FrameCount - d.MoveDelay]
        if targpos then
            npc.Velocity = targpos - npc.Position
        end
        mod:spritePlay(sprite, d.name ..  mod:GetMoveString(npc.Velocity, true))
    elseif not d.IsButt then

        if npc.Velocity.X < 0 then --future me pls don't fuck this up
            sprite.FlipX = true
        else
            sprite.FlipX = false
        end

        if d.state == "Moving" then
            d.newpos = d.newpos or mod:GetNewPosAligned(npc.Position, true)
            if npc.Position:Distance(d.newpos) < 20 or npc.Velocity:Length() < 0.3 or (mod:isScareOrConfuse(npc) and npc.StateFrame % 10 == 0) then
                d.newpos = mod:GetNewPosAligned(npc.Position, true)
            end
            local targetvelocity = (d.newpos - npc.Position):Resized(5)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.3)
            
            npc.StateFrame = npc.StateFrame - 1
        end

        mod:spritePlay(sprite, d.name ..  mod:GetMoveString(npc.Velocity, true), true)
        d.MovementLog[npc.FrameCount] = npc.Position
    end
end

function mod:LarryKingJrRenderAI(npc, sprite, d)
    if npc:IsDead() then
        for k, v in ipairs(d.butts) do
            if k > 1 then
                npc.Parent = d.butts[1]
            end
        end
    end
end
