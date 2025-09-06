local mod = FHAC
local game = Game()

local lkjStats = {
    butts = {},
    buttsToSpawn = 2,
    isSeg = false,
    isButt = false,
    MoveDelay = 0,
    MovingOffset = 0,
    MovementLog = {},
    SegmentNumber = 1,
    state = "Moving",
    segUpdateNum = 0,
    specialAnim = ""
}

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

mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, function(_, npc, offset)
    if npc.Variant == mod.Monsters.LarryKingJr.Var then
        --mod:LarryKingJrRenderAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.LarryKingJr.ID)

function mod:LarryKingJrAI(npc, sprite, d)
    local rng = npc:GetDropRNG()

    if not d.init then
        for name, stat in pairs(lkjStats) do
            d[name] = d[name] or stat
        end

        npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS

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
                Isaac.DebugString("got it")
                d.isSeg = false
                for name, stat in pairs(d) do
                    if string.find(name, "Parent") then
                        d[name:gsub("Parent_", '')] = stat
                    end
                    for k, butt in ipairs(d.butts) do
                        butt:GetData().Head = npc
                    end
                end
            end
        end


        if d.isSeg then
            segAnimName = "Body"
        else
            segAnimName = "Butt"
        end

        local p = d.Head
        local pd = p:GetData()

        if GetHighestSeg(pd.butts) == GetLowestSeg(pd.butts) and d.Head and npc:HasMortalDamage() then
            d.Head:Kill()
        end

        if d.SegNumber == GetHighestSeg(pd.butts) then
            d.isSeg = false
            d.isButt = true
        end

        for name, stat in pairs(pd) do
            d["Parent_" .. name] = stat
        end

        local elBut = d.Parent_butts[d.SegNumber-1]


        if not elBut and d.SegNumber > 1 then
            d.SegNumber = d.SegNumber - 1
        end

        if not (npc.StateFrame < d.SegNumber*2 and npc.Position:Distance(d.initPos) == 0) and not (d.isButt and d.state ~= "Moving") then
            d.state = pd.state
        end

        -- MOVEMENT --

        d.MoveDelay = (d.SegNumber) * 5

        if d.state == "Moving" then
            if d.Parent_MovementLog[npc.FrameCount - d.MoveDelay + 2 - d.MovingOffset] == nil then
                npc.Position = d.Parent_MovementLog[#d.Parent_MovementLog]
            else
                local targpos = d.Parent_MovementLog[npc.FrameCount - d.MoveDelay + 2 - d.MovingOffset]
                if targpos then
                    npc.Velocity = targpos - npc.Position
                end
            end
            d.lastFrameCount = npc.FrameCount - d.MoveDelay + 2 - d.MovingOffset
        else

            npc.Position = d.Parent_MovementLog[d.lastFrameCount]

            npc:MultiplyFriction(0.01)

        end

        -- ANIMATIONS --

        if d.state == "Moving" then
            if (d.Parent_segUpdateNum+1)%d.SegNumber == 0 then

                if d.specialAnim ~= pd.specialAnim then d.specialAnim = pd.specialAnim end

            elseif npc.StateFrame < d.SegNumber*2 and npc.Position:Distance(d.initPos) == 0 then
                npc:SetSpriteFrame(segAnimName .. d.specialAnim ..mod:GetMoveString(npc.Velocity, true, true), 1)
                d.state = pd.state
            end
        else
            if d.Parent_segUpdateNum and d.SegNumber and pd.buttsanimoffset and (6-pd.buttsanimoffset) ~= 0 and (d.Parent_segUpdateNum+1)%(d.SegNumber*(6-pd.buttsanimoffset)) == 0 and not (d.isButt and d.state ~= "Moving") then

                if d.specialAnim ~= pd.specialAnim then d.specialAnim = pd.specialAnim end

            elseif npc.StateFrame < d.SegNumber*2 and npc.Position:Distance(d.initPos) == 0 then
                npc:SetSpriteFrame(segAnimName .. d.specialAnim ..mod:GetMoveString(npc.Velocity, true, true), 1)
                d.state = pd.state
            end
        end

        local spAnim = d.specialAnim

        if d.isButt then
            spAnim = spAnim:gsub('Idle', '')
        end
        mod:spritePlay(sprite, segAnimName .. spAnim ..mod:GetMoveString(npc.Velocity, true))

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

            for k, v in ipairs(d.butts) do
                local dat = v:GetData()
                dat.state = "Pop"
                dat.specialAnim = "Pop"
            end
        end

        if d.isButt and sprite:IsFinished(segAnimName .. "Strain" ..mod:GetMoveString(npc.Velocity, true)) then

            d.state = "Pop"
            d.specialAnim = "Pop"
            mod:spritePlay(sprite, segAnimName .. "Pop" .. mod:GetMoveString(npc.Velocity, true))
            d.Head:GetData().extraNum = 0

        elseif d.isButt and sprite:IsFinished(segAnimName .. "Pop" ..  mod:GetMoveString(npc.Velocity, true)) and d.Head:GetData().state ~= "Pop" then

            d.Head:ToNPC().StateFrame = 1
            d.Head:GetData().state = "Pop"
            d.Head:GetData().extraNum = 0

        end

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
            buttD.SegNumber = k
            if not v or v:IsDead() or not v:Exists() or not (buttD.isSeg or buttD.isButt) then
                table.remove(d.butts, k)
            end
        end

        -- MOVEMENT --

        if d.state == "Moving" then
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
            d.specialAnim = "Strain"

        elseif d.state == "Pop" then

            npc:MultiplyFriction(0.1)
            d.specialAnim = "Pop"

        end

        if sprite:IsFinished() and string.find(sprite:GetAnimation(), "Pop") then
            d.state = "Moving"
            npc.StateFrame = 0
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
            if d.segUpdateNum > #d.butts then
                d.segUpdateNum = 1
            end
        else
            if d.segUpdateNum > #d.butts*7-d.buttsanimoffset then
                d.segUpdateNum = 1
            end
        end

        if d.state == "Moving" then
            d.MovementLog[npc.FrameCount] = npc.Position
        end

        -- STATES --

        if #GetDipsWithSameDataLarry(npc) <= 2 then

            if npc.StateFrame > (100) and d.state == "Moving" then
                d.state = "BunchedUp"
                d.extraNum = 0
            end

        else

            npc.StateFrame = 0

        end

        
    end

end