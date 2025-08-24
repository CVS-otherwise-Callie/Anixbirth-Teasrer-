local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.Dangler.Var then
        mod:DanglerAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.Dangler.ID)

function mod:DanglerAI(npc, sprite, d)

    local target = npc:GetPlayerTarget()
    local path = npc.Pathfinder
    local room = game:GetRoom()
    if not d.init then
        d.init = true
    end

    if d.isDead then
        npc.CanShutDoors = false
        npc.CollisionDamage = 0
    else
        local targetpos = mod:confusePos(npc, target.Position, 5, nil)
        if mod:isScare(npc) then
            local targetvelocity = (targetpos - npc.Position):Resized(-5)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.25)
        elseif room:CheckLine(npc.Position,targetpos,0,1,false,false) then
            local targetvelocity = (targetpos - npc.Position):Resized(5)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.25)
        else
            path:FindGridPath(targetpos, 0.7, 1, true)
        end

        if npc.Velocity:Length() > 1 then
            npc:AnimWalkFrame("WalkHori","WalkVert",0)
        else
            sprite:SetFrame("WalkVert", 0)
        end
    end

    function mod.danglerDeath(npc)
        local danglerhair = Isaac.Spawn(npc.Type, npc.Variant, npc.SubType, npc.Position, Vector.Zero, npc)
        
        
    end
end

