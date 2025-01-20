local mod = FHAC
local game = Game()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.LarryKingJr.Var then
        mod:LarryKingJrAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.LarryKingJr.ID)

mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, function(_, npc, offset)
    if npc.Variant == mod.Monsters.LarryKingJr.Var then
        mod:LarryKingJrRenderAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.LarryKingJr.ID)

function mod:LarryKingJrAI(npc, sprite, d)
    local rng = npc:GetDropRNG()

    if not d.larryKJinit then

        d.butts = {}

        table.insert(d.butts, npc)

        if not d.bodyInit and not d.IsSegment then
            local num = math.random(3)+1
            if npc.SubType <= 0 then
                npc.SubType = num
            end
            for i = 1, npc.SubType do
                local butt = Isaac.Spawn(mod.Monsters.LarryKingJr.ID, mod.Monsters.LarryKingJr.Var, (i > 1 and mod.Monsters.LarryKingJr.Sub or 0), npc.Position, Vector.Zero, npc)
                butt.Parent = npc
                butt:GetData().OldPos = butt.Position
                butt.GridCollisionClass = GridCollisionClass.COLLISION_WALL_EXCEPT_PLAYER
                butt:GetData().SegNumber = i + 1
                butt:GetData().MovementLog = {}
                table.insert(butt:GetData().MovementLog, npc.Position)
                if i == npc.SubType then
                    butt:GetData().IsSegment = true
                    butt:GetData().IsButt = true
                    butt:GetData().name = "Butt"
                    butt:SetSpriteFrame("ButtHori", 1)
                else
                    butt:GetData().IsSegment = true
                    butt:GetData().name = "Body"
                    butt:SetSpriteFrame("BodyHori", 1)
                end
                table.insert(d.butts, butt)
                butt:GetData().butts = d.butts
            end
        elseif not d.IsSegment then
            d.SegNumber = 1
        end
        npc.StateFrame = 0
        d.state = "Moving"
        d.larryKJinit = true
    end

    if d.IsSegment then

        npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS

        if d.SegNumber == 1 then
            d.IsSegment = false
        else
            for k, butt in ipairs(Isaac.FindByType(mod.Monsters.LarryKingJr.ID, mod.Monsters.LarryKingJr.Var)) do
                local tab = {}
                table.insert(tab,GetPtrHash(butt:GetData().butts[#butt:GetData().butts]))
                if d.butts and butt:GetData().butts and 
                mod:CheckTableContents(tab, GetPtrHash(d.butts[#d.butts])) and butt.Position:Distance(butt:GetData().butts[1].Position) < 0.01 and not butt:IsDead() then
                    local buttdata = butt:GetData()
                    if not buttdata.IsSegment then
                        npc.Parent = butt
                    end
                end
            end
        end

        if not npc.Parent or npc.Parent:IsDead() or npc.Parent:GetData().SegNumber ~= 1 then
            if d.SegNumber ~= 1 then
                npc.Parent = d.butts[1]
            else
                local dat = npc:GetData()
                dat.IsSegment = false
                dat.name = "Head"
                dat.bodyInit = true
                dat.MoveDelay = 0
                dat.MovementLog = d.MovementLog or {}
                npc.StateFrame = 0
                dat.state = "Moving"
                dat.larryKJinit = true
            end
            return
        end

        d.state = npc.Parent:GetData().state
        
        d.butts = npc.Parent:GetData().butts or d.butts
        npc:GetData().MoveDelay = (d.SegNumber-1) * 4
        npc.DepthOffset = (-4 * d.SegNumber-1)

        if npc.Velocity.X < 0 then --future me pls don't fuck this up
            sprite.FlipX = true
        else
            sprite.FlipX = false
        end

        if d.state == "Moving" then

            if npc.Parent:GetData().MovementLog[npc.FrameCount - d.MoveDelay + 2] == nil then
                npc.Position = npc.Parent:GetData().MovementLog[#npc.Parent:GetData().MovementLog]
            else
                local targpos = npc.Parent:GetData().MovementLog[npc.FrameCount - d.MoveDelay + 2]
                if targpos then
                    npc.Velocity = targpos - npc.Position
                end
            end

        elseif d.state == "BunchedUp" then

        end

        if npc.StateFrame > d.SegNumber*2 then
            mod:spritePlay(sprite, d.name ..  mod:GetMoveString(npc.Velocity, true))
        end

        d.MovementLog[npc.FrameCount] = npc.Position
        npc.StateFrame = npc.StateFrame + 1

    elseif not d.IsSegment then

        d.name = "Head"
        d.bodyInit = true
        d.MoveDelay = d.MoveDelay or 0
        d.MovementLog = d.MovementLog or {}
        d.SegNumber = 1

        if npc.Velocity.X < 0 then --future me pls don't fuck this up
            sprite.FlipX = true
        else
            sprite.FlipX = false
        end

        if d.state == "Moving" then
            d.newpos = d.newpos or mod:GetNewPosAligned(npc.Position, false)
            if (npc.Position:Distance(d.newpos) < 10 or npc.Velocity:Length() < 0.5) or (mod:isScareOrConfuse(npc) and npc.StateFrame % 10 == 0)then
                d.newpos = mod:GetNewPosAligned(npc.Position, false)
            end
            local targetvelocity = (d.newpos - npc.Position):Resized(7)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 1)
            
            npc.StateFrame = npc.StateFrame - 1
        elseif d.state == "BunchedUp" then

        end

        if math.abs(npc.Velocity.X) < math.abs(npc.Velocity.Y) then
            d.newpos.X = npc.Position.X
        else
            d.newpos.Y = npc.Position.Y
        end

        mod:spritePlay(sprite, d.name ..  mod:GetMoveString(npc.Velocity, true), true)
        d.MovementLog[npc.FrameCount] = npc.Position

        local num =0
        for k, v in ipairs(d.butts) do
            if v:Exists() and not v:IsDead() then
                num = num + 1
            end
        end
        if num <= 1 then
            for _, butt in ipairs(Isaac.FindByType(mod.Monsters.LarryKingJr.ID, mod.Monsters.LarryKingJr.Var)) do
                if butt.Parent and butt:GetData().butts and butt.Parent.Position:Distance(butt:GetData().butts[1].Position) < 0.01 and not butt:IsDead() then
                    butt:Kill()
                end
            end
            npc:Kill()
        end
    end
end

local function DoDataThing(d, dat)
    for k, v in ipairs(dat) do
        if v then
            table.remove(dat, k)
        end
    end
    for k, v in pairs(d) do
        if not dat[k] then
            dat[k] = v
        end
    end
end

function mod:LarryKingJrRenderAI(npc, sprite, d)
    if npc:HasMortalDamage() and not d.FinishedEverything then
        if not d.IsSegment then
            if #d.butts == 0 then return end
            local ent = d.butts[1]
            local dat = ent:GetData()
            if mod:CheckTableContents(d.butts, npc) then
                table.remove(d.butts, d.SegNumber)
            end
            if #d.butts == 0 then 
                for _, butt in ipairs(Isaac.FindByType(mod.Monsters.LarryKingJr.ID, mod.Monsters.LarryKingJr.Var)) do
                    if butt.Parent and butt.Parent.InitSeed == npc.InitSeed then
                        butt:Kill()
                    end
                end
                return
            end
            local count = 0
            for k, butt in ipairs(Isaac.FindByType(mod.Monsters.LarryKingJr.ID, mod.Monsters.LarryKingJr.Var)) do
                if butt.Parent and butt.Parent.InitSeed == npc.InitSeed and not butt:IsDead() then
                    count = count + 1
                    local buttdata = butt:GetData()
                    buttdata.SegNumber = count
                    buttdata.butts = d.butts
                    if buttdata.SegNumber > 1 then
                        buttdata.Parent = buttdata.butts[1]
                    end
                end
            end
            local buttdat = d.butts[#d.butts]:GetData()
            buttdat.IsButt = true
            buttdat.name = "Butt"
            DoDataThing(d, dat)
        elseif d.IsSegment then
            if not d.HasRemovedFromTab and d.butts[d.SegNumber] then
                table.remove(d.butts, d.SegNumber)
                d.HasRemovedFromTab = true
            end
            for h, l in ipairs(d.butts) do
                local buttdata = l:GetData()
                local count = 0
                for k, butt in ipairs(Isaac.FindByType(mod.Monsters.LarryKingJr.ID, mod.Monsters.LarryKingJr.Var)) do
                    if not butt:IsDead() then
                        count = count + 1
                        local buttdata = butt:GetData()
                        buttdata.SegNumber = count
                        buttdata.butts = d.butts
                    end
                end
                if buttdata.butts and l.Position:Distance(buttdata.butts[#buttdata.butts].Position) < 0.5 then
                    buttdata.IsButt = true
                    buttdata.name = "Butt"
                end
            end
        end
        d.FinishedEverything = true
    end
end

--tha-thanks ff.........
function mod:LarryGetHurt(npc, amount, damageFlags, source)
    local d = npc:GetData()
    local room = game:GetRoom()
    local rng = npc:GetDropRNG()

    if not d.IsSegment then
        for _, butt in ipairs(Isaac.FindByType(mod.Monsters.LarryKingJr.ID, mod.Monsters.LarryKingJr.Var)) do
            if butt.Parent and butt.Parent.InitSeed == npc.InitSeed then
                --butt:TakeDamage(amount*0.1, damageFlags | DamageFlag.DAMAGE_CLONES, source, 0)
            end
        end
    elseif not mod:HasDamageFlag(DamageFlag.DAMAGE_CLONES, damageFlags) and npc.Parent then
        --npc.Parent:TakeDamage(amount*0.01, damageFlags, source, 0)
        for _, butt in ipairs(Isaac.FindByType(mod.Monsters.LarryKingJr.ID, mod.Monsters.LarryKingJr.Var)) do
            if butt.Parent and butt.Parent.InitSeed == npc.InitSeed then
                --butt:TakeDamage(amount*0.1, damageFlags | DamageFlag.DAMAGE_CLONES, source, 0)
            end
        end
        return false
    end
end
