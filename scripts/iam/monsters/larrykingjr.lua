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

local function GetLarryDist(table, element)
    for num, value in pairs(table) do
          if value:Distance(element)  == 0  then
            return num
          end
    end
    return false
end

local function FindEntsWithSameInitSeedLarry(npc)
    local tab = {}
    for k, butt in ipairs(Isaac.FindByType(mod.Monsters.LarryKingJr.ID, mod.Monsters.LarryKingJr.Var)) do
        if butt:GetData().InitSeed == npc:GetData().InitSeed and butt.Position:Distance(npc.Position) > 0 then
            table.insert(tab, butt)
        end
    end
    return tab
end

local function GetButtEnd(butts)
    local num = {}
    local butt = butts[#butts]
    num = butts
    if #butts == 0 then return end
    if butt:IsDead() then
        table.remove(butts, #butts)
        GetButtEnd(butts)
    else
        return butt
    end
end

local function CheckButts(butts)
    for k, v in ipairs(butts) do
        if v:IsDead() then
            local d = v:GetData()

            for _, butt in ipairs(Isaac.FindByType(mod.Monsters.LarryKingJr.ID, mod.Monsters.LarryKingJr.Var)) do
                if butt:GetData().SegNumber and d.SegNumber and butt:GetData().SegNumber > d.SegNumber then
                    butt:GetData().SegNumber = butt:GetData().SegNumber - 1
                    butt:GetData().butts = d.butts
                end
            end

            table.remove(butts, k)
        end
    end
end

local function DoDataThing(d, dat) -- overriding and storing all of the data of one thing into another
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

local function GetDipsWithSameDataLarry(npc)
    local tab = {}
    for k, poop in ipairs(Isaac.FindByType(EntityType.ENTITY_DIP)) do
        if poop:GetData().InitSeed == npc:GetData().InitSeed and poop.Position:Distance(npc.Position) > 0 then
            table.insert(tab, poop)
        end
    end
    for k, poop in ipairs(Isaac.FindByType(EntityType.ENTITY_DRIP)) do
        if poop:GetData().InitSeed == npc:GetData().InitSeed and poop.Position:Distance(npc.Position) > 0 then
            table.insert(tab, poop)
        end
    end
    return tab
end

function mod:LarryKingJrAI(npc, sprite, d)
    local rng = npc:GetDropRNG()

    if not d.larryKJinit then

        d.butts = {}

        table.insert(d.butts, npc)

        if not d.bodyInit and not d.IsSegment then
            d.InitSeed = npc.InitSeed
            d.extraNum = 0
            d.MovementLog = d.MovementLog or {}
            local num = math.random(3)+1
            if npc.SubType == 0 then
                npc.SubType = 1
            elseif npc.SubType < 0 then
                npc.SubType = num
            end
            for i = 1, npc.SubType do
                local butt = Isaac.Spawn(mod.Monsters.LarryKingJr.ID, mod.Monsters.LarryKingJr.Var, (i > 1 and mod.Monsters.LarryKingJr.Sub or 0), npc.Position, Vector.Zero, npc)
                butt.Parent = npc
                butt:GetData().InitSeed  = npc.InitSeed
                butt:GetData().OldPos = butt.Position
                butt.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
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
                table.insert(d.MovementLog, butt.Position)
                butt:GetData().butts = d.butts
            end
        elseif not d.IsSegment then
            d.SegNumber = 1
        end
        npc.StateFrame = 0
        d.state = "Moving"
        d.larryKJinit = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end


    local function HasPossibleParentSegs(butts) --if a butt has any parents with the same data for "initseed" (not the actual thing)
        local tab = {}
        local tab2 = {}
        if d.butts and #d.butts > 0 then
            for k, butt in ipairs(Isaac.FindByType(mod.Monsters.LarryKingJr.ID, mod.Monsters.LarryKingJr.Var)) do
                if butt:GetData().InitSeed == d.InitSeed then
                    table.insert(tab, butt.Position)
                    table.insert(tab2, butt)
                end
            end
            if not butts:IsDead() and GetLarryDist(tab, d.butts[1].Position) and tab2[GetLarryDist(tab, d.butts[1].Position)]:GetData().IsSegment == false then
                return tab2[GetLarryDist(tab, d.butts[1].Position)]
            end
        end
    end

    if d.IsSegment then

        -- safechecking head or segment --

        if d.SegNumber == 1 then
            d.IsSegment = false
        else
            for k, butt in ipairs(Isaac.FindByType(mod.Monsters.LarryKingJr.ID, mod.Monsters.LarryKingJr.Var)) do
                if HasPossibleParentSegs(butt) and butt:GetData().InitSeed == d.InitSeed then
                    npc.Parent = d.butts[1]
                end
            end
            if npc.Parent then
                d.butts = npc.Parent:GetData().butts
            end
        end

        -- if the parent is dead --

        if not npc.Parent or npc.Parent:IsDead() or npc.Parent:GetData().SegNumber ~= 1 then
            if d.SegNumber ~= 1 and d.butts and #d.butts > 0 and d.butts[1] then
                npc.Parent = d.butts[1]
            elseif d.SegNumber == 1 then
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

        if not npc.Parent or #d.butts == 0 then return end

        -- stuff it should pull from the head --

        npc.StateFrame = npc.Parent:ToNPC().StateFrame
        d.butts = npc.Parent:GetData().butts
        d.MovingOffset = npc.Parent:GetData().MovingOffset
        --if not d.IsButt and d.state == "Pop" then
            d.state = npc.Parent:GetData().state
        --end
        d.buttsanimoffset = npc.Parent:GetData().buttsanimoffset

        -- movement and movedelay --
        
        npc:GetData().MoveDelay = (d.SegNumber-1) * 4
        npc.DepthOffset = (-4 * d.SegNumber-1)
        d.animExtraName = d.animExtraName or ""
        d.animExtraName2 = d.animExtraName2 or ""

        -- states --

        if npc.Parent:GetData().MovementLog[npc.FrameCount - d.MoveDelay + 2 - d.MovingOffset] == nil and npc.Position:Distance(d.OldPos) == 0 then
            npc.Position = npc.Parent:GetData().MovementLog[#npc.Parent:GetData().MovementLog]
        else
            local targpos = npc.Parent:GetData().MovementLog[npc.FrameCount - d.MoveDelay + 2 - d.MovingOffset]
            if targpos then
                npc.Velocity = targpos - npc.Position
            end
        end

        if d.state == "Moving" then

            d.MovementLog[npc.FrameCount - d.MoveDelay + 2 - d.MovingOffset] = npc.Position
            d.Movenumber = npc.FrameCount

        else

            --npc:MultiplyFriction(0.01)

            d.MovingOffset = npc.FrameCount - #d.MovementLog - 2

        end

        if npc.Velocity.X <= 0 then --future me pls don't fuck this up
            sprite.FlipX = true
        else
            sprite.FlipX = false
        end

        -- sprites and animations --

        local mvstr =  mod:GetMoveString(npc.Velocity, true, false)

        d.elname = d.elname or d.name
        d.extraNum = npc.Parent:GetData().extraNum or d.extraNum
        if d.extraNum+1 == 0 or d.MoveDelay == 0 then
            return
        end
        if d.state == "Moving" then
            if (d.extraNum+1)%d.SegNumber == 0 then
                if d.elname ~= d.name then d.elname = d.name end
                if d.animExtraName ~= npc.Parent:GetData().animExtraName then d.animExtraName = npc.Parent:GetData().animExtraName end
                if d.animExtraName2 ~= npc.Parent:GetData().animExtraName2 then d.animExtraName2 = npc.Parent:GetData().animExtraName2 end
            elseif npc.StateFrame < d.SegNumber*2 and npc.Position:Distance(d.OldPos) == 0 then
                npc:SetSpriteFrame(d.name .. d.animExtraName ..mod:GetMoveString(npc.Velocity, true, true).. d.animExtraName2, 1)
                d.state = npc.Parent:GetData().state
            end
        else
            if (d.extraNum+1)%(d.SegNumber*(7-d.buttsanimoffset)) == 0 then
                if d.elname ~= d.name then d.elname = d.name end
                if d.animExtraName ~= npc.Parent:GetData().animExtraName then d.animExtraName = npc.Parent:GetData().animExtraName end
                if d.animExtraName2 ~= npc.Parent:GetData().animExtraName2 then d.animExtraName2 = npc.Parent:GetData().animExtraName2 end
            elseif npc.StateFrame < d.SegNumber*2 and npc.Position:Distance(d.OldPos) == 0 then
                npc:SetSpriteFrame(d.name .. d.animExtraName ..mod:GetMoveString(npc.Velocity, true, true).. d.animExtraName2, 1)
                d.state = npc.Parent:GetData().state
            end
    
        end

        if not d.IsButt then
            mod:spritePlay(sprite, d.elname .. d.animExtraName .. mod:GetMoveString(npc.Velocity, true, true) .. d.animExtraName2)
        else
            mod:spritePlay(sprite, d.elname .. d.animExtraName .. mvstr)
        end

        if d.IsButt and sprite:IsEventTriggered("Poop") and GetDipsWithSameDataLarry(npc) then
            local vec = (Vector(3, 0)):Rotated((npc.Parent.Position - npc.Position):GetAngleDegrees() + 180 + math.random(-20, 20))
            
            local var = 217
            if mod:CheckStage("Dross", {45}) then
                var = 870
            end
            local poop = Isaac.Spawn(var,0,0,npc.Position, vec, npc)
            poop:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
            poop:GetData().InitSeed = d.InitSeed

            npc:PlaySound(SoundEffect.SOUND_TEARIMPACTS, 1, 0, false, 1)
            npc:PlaySound(SoundEffect.SOUND_PLOP, 1, 0, false, 1)

            for k, v in ipairs(d.butts) do
                local dat = v:GetData()
                dat.state = "Pop"
                dat.animExtraName = "Pop"
                dat.animExtraName2 = ""
            end
        end

        if d.IsButt and sprite:IsFinished(d.elname .. "Strain" ..  mvstr) then

            d.state = "Pop"
            d.animExtraName = "Pop"
            mod:spritePlay(sprite, d.elname .. "Pop" .. mvstr)
            npc.Parent:GetData().extraNum = 0

        elseif d.IsButt and sprite:IsFinished(d.elname .. "Pop" ..  mvstr) and d.state ~= "Moving" then

            npc.Parent:ToNPC().StateFrame = 1
            npc.Parent:GetData().state = "Moving"
            d.state = "Moving"
            npc.Parent:GetData().extraNum = 0

        end

    elseif not d.IsSegment then

        -- checking if it's secretly a butt --

        if #FindEntsWithSameInitSeedLarry(npc) then
            for k, v in ipairs(FindEntsWithSameInitSeedLarry(npc)) do
                if v:GetData().IsSegment == false then
                    d.IsSegment = true
                    table.insert(FindEntsWithSameInitSeedLarry(npc)[1]:GetData().butts, npc)
                    d.SegNumber = #FindEntsWithSameInitSeedLarry(npc)[1]:GetData().butts+1
                    return
                end
            end
        end

        -- killing all dead butts --

        CheckButts(d.butts)

        -- init --

        d.name = "Head"
        d.animExtraName = d.animExtraName or ""
        d.animExtraName2 = d.animExtraName2 or ""
        d.shitOffset = d.shitOffset or math.random(-10, 20)
        d.bodyInit = true
        d.MoveDelay = d.MoveDelay or 0
        d.SegNumber = 1
        d.MovementAnim = mod:GetMoveString(npc.Velocity, true)
        d.MovingOffset = d.MovingOffset or 0

        
        -- checking butts --

        local num = 0

        if not d.butts then npc:Kill() end

        for k, v in ipairs(d.butts) do
            if v:Exists() and not v:IsDead() then
                num = num + 1
            end
        end

        if num <= 1 then
            for k, butt in ipairs(Isaac.FindByType(mod.Monsters.LarryKingJr.ID, mod.Monsters.LarryKingJr.Var)) do
                if HasPossibleParentSegs(butt) and butt:GetData().InitSeed == d.InitSeed then
                    butt:Kill()
                end
            end
            npc:Kill()
        end

        if #d.butts == 0 then return end

        -- flip --

        if npc.Velocity.X <= 0 then --future me pls don't fuck this up
            sprite.FlipX = true
        else
            sprite.FlipX = false
        end

        -- ai --

        if d.state == "Moving" then

            d.newpos = d.newpos or mod:GetNewPosAligned(npc.Position, false)
            if (npc.Position:Distance(d.newpos) < 10 or npc.Velocity:Length() == 0) or (mod:isScareOrConfuse(npc) and npc.StateFrame % 10 == 0)then
                d.newpos = mod:GetNewPosAligned(npc.Position, false)
            end
            local targetvelocity = (d.newpos - npc.Position):Resized(5)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 1)
            d.animExtraName = ""
            
        elseif d.state == "BunchedUp" then

            npc:MultiplyFriction(0.1)
            d.animExtraName = "Strain"

        elseif d.state == "Pop" then

            npc:MultiplyFriction(0.1)
            d.animExtraName = "Pop"
            d.animExtraName2 = ""

        end

        -- position for butts --

        if d.state == "Moving" then
            d.MovementLog[npc.FrameCount - d.MovingOffset] = npc.Position
            d.Movenumber = npc.FrameCount
        else
            d.MovingOffset = npc.FrameCount - #d.MovementLog - 2
        end

        -- stateframes --

        if #GetDipsWithSameDataLarry(npc) <= 2 then

            if npc.StateFrame > (100 + d.shitOffset) and d.state == "Moving" then
                d.state = "BunchedUp"
                d.extraNum = 0
            end

        else

            npc.StateFrame = 0

        end

        -- positions --

        if d.newpos then

            if math.abs(npc.Velocity.X) < math.abs(npc.Velocity.Y) then
                d.newpos.X = npc.Position.X
            else
                d.newpos.Y = npc.Position.Y
            end

        end

        -- animations --

        mod:spritePlay(sprite, d.name .. d.animExtraName .. mod:GetMoveString(npc.Velocity, true) .. d.animExtraName2, true)

        if sprite:IsFinished(d.name .. "Strain" .. mod:GetMoveString(npc.Velocity, true)) then
            d.animExtraName2 = "Idle"
        end
        
        -- i have to use this for updating the sgements in a certain pattern --

        d.buttsanimoffset = #d.butts - 2
        if d.buttsanimoffset < 1 then d.buttsanimoffset = 0 end

        d.extraNum = d.extraNum + 1
        if d.state == "Moving" then
            if d.extraNum > #d.butts then
                d.extraNum = 1
            end
        else
            if d.extraNum > #d.butts*7-d.buttsanimoffset then
                d.extraNum = 1
            end
        end

        local buttdat = GetButtEnd(d.butts)

        if buttdat == nil then return end
        buttdat = buttdat:GetData()
        if buttdat.SegNumber ~= 1 then
            buttdat.IsButt = true
            buttdat.IsSegment = true
            buttdat.name = "Butt"
        end
        
    end

    if sprite:IsEventTriggered("Poop particles") then
        for i = 2, math.random(6) do
            Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOP_PARTICLE, 0, npc.Position, Vector(math.random(-10, 10), math.random(-10, 10)), npc)
        end
    end
end

function mod:LarryKingJrRenderAI(npc, sprite, d)


    local function HasPossibleParentSegs(butts) --if a butt has any parents with the same data for "initseed" (not the actual thing)
        local tab = {}
        local tab2 = {}
        if d.butts and #d.butts > 0 then
            local var = true
            for k, butt in ipairs(Isaac.FindByType(mod.Monsters.LarryKingJr.ID, mod.Monsters.LarryKingJr.Var)) do
                if butt:GetData().InitSeed == d.InitSeed then
                    table.insert(tab, butt.Position)
                    table.insert(tab2, butt)
                end
            end
            if not butts:IsDead() and GetLarryDist(tab, d.butts[1].Position) and GetLarryDist(tab, d.butts[1].Position) > 0 then
                return tab2[GetLarryDist(tab, d.butts[1].Position)]
            end
        end
    end

    if npc:HasMortalDamage() and not d.FinishedEverything then
        if not d.IsSegment then
            if not d.butts or #d.butts == 0 then return end

            table.remove(d.butts, 1)

            if #d.butts == 0 then return end 

            local ent = d.butts[1]
            local dat = ent:GetData()

            for k, butt in ipairs(Isaac.FindByType(mod.Monsters.LarryKingJr.ID, mod.Monsters.LarryKingJr.Var)) do
                if HasPossibleParentSegs(butt) and butt:GetData().InitSeed == d.InitSeed then
                    butt.Parent = d.butts[1]
                    butt:GetData().SegNumber = butt:GetData().SegNumber - 1
                end
            end
            
            dat.SegNumber = 1
        elseif d.IsSegment then

            if not d.butts or #d.butts == 0 then return end

            if d.butts[d.SegNumber] then
                table.remove(d.butts, d.SegNumber)
            else
                table.remove(d.butts, #d.butts) --safecheck
            end

            if not d.butts or #d.butts == 0 then return end

            for k, butt in ipairs(Isaac.FindByType(mod.Monsters.LarryKingJr.ID, mod.Monsters.LarryKingJr.Var)) do
                if HasPossibleParentSegs(butt) and butt:GetData().SegNumber > d.SegNumber then
                    butt:GetData().SegNumber = butt:GetData().SegNumber - 1
                    butt:GetData().butts = d.butts
                end
            end

            local dat = GetButtEnd(d.butts)
            if not dat then return end
            mod:spritePlay(dat:GetSprite(), sprite:GetAnimation())
            dat = dat:GetData()
            dat.name = "Butt"

            DoDataThing(d, dat)

        end
        d.FinishedEverything = true
    end
end

--tha-thanks ff.........
function mod:LarryGetHurt(npc, amount, damageFlags, source)

    --[[
    local d = npc:GetData()
    local room = game:GetRoom()
    local rng = npc:GetDropRNG()

    local function HasPossibleParentSegs(butts)
        local tab = {}
        if d.butts then
            for k, butt in ipairs(Isaac.FindByType(mod.Monsters.LarryKingJr.ID, mod.Monsters.LarryKingJr.Var)) do
                table.insert(tab, butt.Position)
            end
            if not butts:IsDead() and GetLarryDist(tab, d.butts[1].Position) then
                return GetLarryDist(tab, d.butts[1].Position)
            end
        end
    end

    if not d.IsSegment then
        for _, butt in ipairs(Isaac.FindByType(mod.Monsters.LarryKingJr.ID, mod.Monsters.LarryKingJr.Var)) do
            if butt.Parent and HasPossibleParentSegs(butt) and butt:GetData().SegNumber > d.SegNumber and butt:GetData().InitSeed == d.InitSeed then
                butt:TakeDamage(amount*0.1, damageFlags | DamageFlag.DAMAGE_CLONES, source, 0)
            end
        end
    elseif not mod:HasDamageFlag(DamageFlag.DAMAGE_CLONES, damageFlags) and npc.Parent then
        npc.Parent:TakeDamage(amount*0.01, damageFlags, source, 0)
        for _, butt in ipairs(Isaac.FindByType(mod.Monsters.LarryKingJr.ID, mod.Monsters.LarryKingJr.Var)) do
            if butt.Parent and HasPossibleParentSegs(butt) and butt:GetData().SegNumber > d.SegNumber and butt:GetData().InitSeed == d.InitSeed then
                butt:TakeDamage(amount*0.1, damageFlags | DamageFlag.DAMAGE_CLONES, source, 0)
            end
        end
        return false
    end]]
end
