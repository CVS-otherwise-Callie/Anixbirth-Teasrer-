local mod = FHAC
local game = Game()
local rng = RNG()

local embolzonStats = {
    state = "chase",
    wait = 80 + math.random(-20, 20),
    firstJumper = false,
    blockDMGEmbolzon = 1,
    landtarget = Vector.Zero
}

function mod:EmbolzonAI(npc, sprite, d)

    local target = npc:GetPlayerTarget()
    local targetpos = mod:confusePos(npc, target.Position, 5, nil, nil)
    local path = npc.Pathfinder
    local room = game:GetRoom()

    if not d.init then
        for name, stat in pairs(embolzonStats) do
            d[name] = d[name] or stat
        end
        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end


    local function CheckEmbolzonsforJump()
        for _, ent in ipairs(Isaac.GetRoomEntities()) do
            if ent:GetData().firstJumper == true then
                return true
            end
        end
        return false
    end

    local function SetAllEmbolzonTargets()
        local num = 0
        for _, ent in ipairs(Isaac.GetRoomEntities()) do
            if ent.Type == mod.Monsters.Embolzon.ID and ent.Variant == mod.Monsters.Embolzon.Var then
                num = num + 6
                ent.Position = targetpos + Vector(math.random(-20, 20), math.random(-20, 20))
                ent:GetData().wait = d.wait + num + 20
                ent:ToNPC().StateFrame = npc.StateFrame + math.random(-10, 10)
                ent:GetData().state = "actuallyland"
            end
        end 
    end

    local function CheckEmbolzonReadyforFall()
        for _, ent in ipairs(Isaac.GetRoomEntities()) do
            if ent.Type == mod.Monsters.Embolzon.ID and ent.Variant == mod.Monsters.Embolzon.Var then
                if ent:GetData().state ~= "hiddenabove" then
                    return false
                end
            end
        end 
        return true
    end

    if d.state == "chase" then
        if mod:isScare(npc) then
            local targetvelocity = (targetpos - npc.Position):Resized(-7)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.25)
        elseif game:GetRoom():CheckLine(npc.Position,targetpos,0,1,false,false) then
            local targetvelocity = (targetpos - npc.Position):Resized(7)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.25)
        else
            path:FindGridPath(targetpos, 0.7, 900, true)
        end

        if npc.StateFrame > d.wait and not mod:isScareOrConfuse(npc) then
            d.state = "jump"
        end

        if npc.Velocity:Length() > 0.1 then
            npc:AnimWalkFrame("WalkHori","WalkVert",0)
        else
            sprite:SetFrame("WalkHori", 0)
        end
    elseif d.state == "jump" then
        npc:MultiplyFriction(0)
        d.blockDMGEmbolzon = 0

        if not CheckEmbolzonsforJump() then
            d.firstJumper = true
        end

        if d.firstJumper then
            mod:spritePlay(sprite, "Jump")
        else
            mod:spritePlay(sprite, "JumpNoShake")
        end
    elseif d.state == "hiddenabove" then

        if npc.StateFrame > (d.wait + 70) then
            if not CheckEmbolzonReadyforFall() then
                d.wait = d.wait + 1
                return
            end
            if d.firstJumper then
                SetAllEmbolzonTargets()   
            end

            d.state = "actuallyland"
        end
    elseif d.state == "actuallyland" then
        d.blockDMGEmbolzon = 0.1

        if npc.StateFrame > d.wait + 90 then
            if mod:isScare(npc) then
                local targetvelocity = (targetpos - npc.Position):Resized(-4)
                npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.25)
            elseif game:GetRoom():CheckLine(npc.Position,targetpos,0,1,false,false) then
                local targetvelocity = (targetpos - npc.Position):Resized(4)
                npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.25)
            else
                path:FindGridPath(targetpos, 0.7, 900, true)
            end
            mod:spritePlay(sprite, "JumpFromLand")
        else
            npc:MultiplyFriction(0)
            mod:spritePlay(sprite, "Land")
        end
    end

    if sprite:IsEventTriggered("offscreen") then
        mod:MakeInvulnerable(npc)
    elseif sprite:IsEventTriggered("onscreen") then
        mod:MakeVulnerable(npc)
        npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
    end

    if (sprite:IsFinished("Jump") or sprite:IsFinished("JumpNoShake")) and d.state == "jump" then
        d.state = "hiddenabove"
    elseif sprite:IsFinished("JumpFromLand") and d.state == "actuallyland" then
        d.blockDMGEmbolzon = 1
        d.wait = 80 + math.random(-20, 20)
        d.state = "chase"
        npc.StateFrame = 0
    end

end

function mod:embolzonTakeDamage(npc, damage, flag, source)
    local d = npc:GetData()

    if npc.Type == mod.Monsters.Embolzon.ID and npc.Variant == mod.Monsters.Embolzon.Var and d.blockDMGEmbolzon ~= 1 and flag ~= flag | DamageFlag.DAMAGE_CLONES then
        npc:TakeDamage(d.blockDMGEmbolzon * damage, flag | DamageFlag.DAMAGE_CLONES, source, 0)
        return false
    end
    if npc.Type == mod.Monsters.Embolzon.ID and npc.Variant == mod.Monsters.Embolzon.Var and flag == flag | DamageFlag.DAMAGE_FIRE then
        return false
    end
end

