local mod = FHAC
local game = Game()

local function GetLowestSeg(segments)
    local hi = 999999999999
    if not segments or #segments == 0 then return end
    for k, v in pairs(segments) do
        if k < hi then
            hi = k
        end
    end
    return hi
end

local function GetHighestSeg(segments)
    local hi = 0
    if not segments or #segments == 0 then return end
    for k, v in pairs(segments) do
        if k > hi then
            hi = k
        end
    end
    return hi
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

    if not d.init then

        npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS


        d.butts = d.butts or {}
        d.buttsToSpawn = d.buttsToSpawn or 2
        d.isSeg = d.isSeg or false
        d.isButt = d.isButt or false
        d.MoveDelay = d.MoveDelay or 0
        d.MovingOffset = d.MovingOffset or 0
        d.MovementLog = d.MovementLog or {}
        d.SegmentNumber = d.SegmentNumber or 1
        d.state = d.state or "Moving"
        d.segUpdateNum = d.segUpdateNum or 0
        d.specialAnim = d.specialAnim or ""
        d.lastFrameCount = d.lastFrameCount or 0
        d.lateFrameCount = d.lateFrameCount or 0

        -- SPAWNING BUTTS --

        if not d.isSeg and not d.isButt then
            local segNum

            if npc.SubType > 0 then
                segNum = npc.SubType
            else
                segNum = d.buttsToSpawn
            end

            for i = 1, tonumber(segNum) do

                local seg = Isaac.Spawn(npc.Type, npc.Variant, 0, npc.Position, Vector.Zero, npc)
                local sd = seg:GetData()

                sd.SegNumber = #d.butts + 1

                if i == segNum then
                    sd.isButt = true
                else
                    sd.isSeg = true
                end

                sd.Head = npc
                sd.InitHead = npc.InitSeed
                d.InitHead = npc.InitSeed

                sd.initPos = seg.Position

                -- ADDING TO TABLE --
                d.butts[#d.butts + 1] = seg

            end
        end
        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    if npc.Velocity.X <= 0 then
        sprite.FlipX = true
    else
        sprite.FlipX = false
    end


    local segAnimName

    if d.isSeg or d.isButt then
        -- SEGMENT AI --

        -- HEAD CHECK --
        if not d.Head or not d.Head:Exists() or d.Head:IsDead() then
            if d.SegNumber == GetLowestSeg(d.Parent_butts) and not d.Parent_butts[d.SegNumber-1] then
                d.isSeg = false
                for name, stat in pairs(d) do
                    if string.find(name, "Parent") then
                        d[name:gsub("Parent_", '')] = stat
                    end
                    for k, butt in ipairs(d.butts) do
                        if butt:GetData().InitHead == d.InitHead and (butt:GetData().isButt or butt:GetData().isSeg) then
                            butt:GetData().Head = npc
                        end
                    end
                end
            end
            return
        end

        if d.isSeg then
            segAnimName = "Body"
        else
            segAnimName = "Butt"
        end

        local p = d.Head
        local pd = p:GetData()

        if d.InitHead ~= pd.InitHead then
            d.Head = nil
            print("grrrrrrrrrrrrrrr")
            return
        end

        if GetHighestSeg(pd.butts) == GetLowestSeg(pd.butts) and d.Head and npc:HasMortalDamage() then
            d.Head:Kill()
        end

        if d.SegNumber == GetHighestSeg(pd.butts) then
            d.isSeg = false
            d.isButt = true
        else
            d.isSeg = true
            d.isButt = false          
        end

        for name, stat in pairs(pd) do
            d["Parent_" .. name] = stat
        end

        local elBut = d.Parent_butts[d.SegNumber-1]

        if not elBut and d.SegNumber > 1 then
            d.SegNumber = d.SegNumber - 1
        end

        if not (npc.StateFrame < d.SegNumber*2 and npc.Position:Distance(d.initPos) == 0) then
            d.state = pd.state
        end

        -- MOVEMENT --

        d.MoveDelay = (d.SegNumber) * 5

        local lastSegC = npc.FrameCount - d.MoveDelay + 2 - d.Parent_lateFrameCount

        if d.state == "Moving" then
            if d.Parent_MovementLog[lastSegC] == nil then
                npc.Position = d.Parent_MovementLog[#d.Parent_MovementLog]
            else
                local targpos = d.Parent_MovementLog[lastSegC]
                if targpos then
                    npc.Velocity = targpos - npc.Position
                end
            end
            d.lastFrameCount = lastSegC
        else

            npc.Position = d.Parent_MovementLog[d.lastFrameCount+1]
            npc:MultiplyFriction(0.01)

        end

        -- ANIMATIONS --

        --print(math.ceil((d.Parent_segUpdateNum+1)) , tonumber(d.SegNumber)*5 , (d.isButt and d.specialAnim~="Pop" and not d.hasPopped))

        if d.state == "Moving" then
            d.hasPopped = false
            if math.ceil((d.Parent_segUpdateNum+1)) == tonumber(d.SegNumber)*5 then

                if d.specialAnim ~= pd.specialAnim then d.specialAnim = pd.specialAnim end

            elseif npc.StateFrame < d.SegNumber*2 and npc.Position:Distance(d.initPos) == 0 then
                npc:SetSpriteFrame(segAnimName .. d.specialAnim ..mod:GetMoveString(npc.Velocity, true, true), 1)
                d.state = pd.state
            end
        else
            if math.ceil((d.Parent_segUpdateNum+1)) == tonumber(d.SegNumber)*5 and (not d.isButt or (d.isButt and d.specialAnim~="Pop" and not d.hasPopped)) then

                if d.specialAnim ~= pd.specialAnim then d.specialAnim = pd.specialAnim end

            elseif npc.StateFrame < d.SegNumber*2 and npc.Position:Distance(d.initPos) == 0 then
                npc:SetSpriteFrame(segAnimName .. d.specialAnim ..mod:GetMoveString(npc.Velocity, true, true), 1)
                d.state = pd.state
            end
        end

        if d.isButt and sprite:IsEventTriggered("Poop") then --and #GetDipsWithSameDataLarry(npc) <= 3 then
            local vec = (Vector(3, 0)):Rotated((d.Head.Position - npc.Position):GetAngleDegrees() + 180 + math.random(-20, 20))
            
            local var = 217
            if mod:CheckStage("Dross", {45}) then
                var = 870
            end
            
            local poop = Isaac.Spawn(var,0,0,npc.Position, vec, npc)
            poop:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
            poop:GetData().InitSeed = d.InitSeed

            npc:PlaySound(SoundEffect.SOUND_TEARIMPACTS, 1, 0, false, 1)
            npc:PlaySound(SoundEffect.SOUND_PLOP, 1, 0, false, 1)

            d.Head:ToNPC().StateFrame = 1
            d.Head:GetData().state = "Pop"

            d.Head:GetData().extraNum = 0

            for k, v in ipairs(d.Parent_butts) do
                local dat = v:GetData()
                dat.state = "Pop"
                dat.specialAnim = "Pop"
            end
            d.hasPopped = true
        end

        if d.isButt and sprite:IsFinished(segAnimName .. "Strain" ..mod:GetMoveString(npc.Velocity, true)) then

            d.state = "Pop"
            d.specialAnim = "Pop"

        end

        if d.isButt and d.state == "Pop" then
            d.specialAnim = "Pop"
        end

        local spAnim = d.specialAnim

        if d.isButt then
            spAnim = spAnim:gsub('Idle', '')
        end
        mod:spritePlay(sprite, segAnimName .. spAnim ..mod:GetMoveString(npc.Velocity, true))

    else

        -- HEAD AI --

        segAnimName = "Head"
        d.specialAnim = d.specialAnim or ""

        if not d.butts then npc:Kill() end

        if #d.butts == 1 and npc:HasMortalDamage() then
            d.butts[1]:Kill()
        end

        -- FIXING BUTTS --

        for k, v in ipairs(d.butts) do
            local buttD = v:GetData()
            if buttD.InitHead == d.InitHead then
                buttD.SegNumber = k
                buttD.Head = npc
                if not v or v:IsDead() or not v:Exists() or not (buttD.isSeg or buttD.isButt) or buttD.InitHead ~= d.InitHead then
                    table.remove(d.butts, k)
                end            
            end
        end

        -- MOVEMENT --

        if d.state == "Moving" then
            d.specialAnim = ""
            d.newpos = d.newpos or mod:GetNewPosAligned(npc.Position, false)

            if (npc.Position:Distance(d.newpos) < 10 or npc.Velocity:Length() == 0) or (mod:isScareOrConfuse(npc) and npc.StateFrame % 10 == 0)then
                d.newpos = mod:GetNewPosAligned(npc.Position, false)
            end

            local targetvelocity = (d.newpos - npc.Position):Resized(5)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 1)

            if d.newpos then

                if math.abs(npc.Velocity.X) < math.abs(npc.Velocity.Y) then
                    d.newpos.X = npc.Position.X
                else
                    d.newpos.Y = npc.Position.Y
                end

            end
        elseif d.state == "BunchedUp" then

            npc:MultiplyFriction(0.1)
            if d.specialAnim ~= "Strain" then
                d.specialAnim = "Strain"
                d.segUpdateNum = 1
            end

        elseif d.state == "Pop" then

            npc:MultiplyFriction(0.1)
            if d.specialAnim ~= "Pop" then
                d.specialAnim = "Pop"
                d.segUpdateNum = 1
            end

        end

        if sprite:IsFinished() and string.find(sprite:GetAnimation(), "Pop") then
            d.state = "Moving"
            npc.StateFrame = 0
            d.newpos = d.newpos or mod:GetNewPosAligned(npc.Position, false)
        end

        -- ANIMATIONS --

        mod:spritePlay(sprite, segAnimName .. d.specialAnim .. mod:GetMoveString(npc.Velocity, true), true)

        if sprite:IsFinished(segAnimName .. "Strain" .. mod:GetMoveString(npc.Velocity, true)) then
            d.specialAnim = "StrainIdle"
        end

        d.buttsanimoffset = #d.butts - 2
        if d.buttsanimoffset < 1 then d.buttsanimoffset = 0 end

        d.segUpdateNum = d.segUpdateNum + 1

        if d.state == "Moving" then
            if d.segUpdateNum > (#d.butts)*5 then
                d.segUpdateNum = 1
            end
        else
            if d.segUpdateNum > (#d.butts)*5 then
                d.segUpdateNum = 1
            end
        end

        if d.state == "Moving" then
            d.lastFrameCount = npc.FrameCount
            d.MovementLog[npc.FrameCount - d.lateFrameCount] = npc.Position
            d.checkLast = d.lateFrameCount
        else
            d.lateFrameCount = npc.FrameCount - d.lastFrameCount + d.checkLast
        end

        -- STATES --

        if #GetDipsWithSameDataLarry(npc) <= 2 then

            if npc.StateFrame > (100) and d.state == "Moving" and
            (d.butts[#d.butts].FrameCount - 
            d.butts[#d.butts]:GetData().MoveDelay) > 
            10*#d.butts then
                d.state = "BunchedUp"
                d.extraNum = 0
            end

        else

            npc.StateFrame = 0

        end

        
    end

end