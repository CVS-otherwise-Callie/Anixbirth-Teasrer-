local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.Erythorcyte.Var and npc.SubType == 0 then
        mod:ErythorcyteAI(npc, npc:GetSprite(), npc:GetData())
    else
    end
end, mod.Monsters.Erythorcyte.ID)

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.Erythorcytebaby.Var and npc.SubType == 1 then
        mod:ErythorcytebabyAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.Erythorcytebaby.ID)

function mod:ErythorcyteAI(npc, sprite, d)
    local room = Game():GetRoom()
    local isFriendly = npc:HasEntityFlags(EntityFlag.FLAG_FRIENDLY)
    local target = npc:GetPlayerTarget()
    local targetpos = mod:confusePos(npc, target.Position, 5, nil, nil)
    local params = ProjectileParams()

	if not d.init then
        d.wait = 10
		d.state = "movin" --they be movin and groovin
        d.accel = 0
        --npc.GridCollisionClass = (GridCollisionClass.COLLISION_SOLID | GridCollisionClass.COLLISION_WALL_EXCEPT_PLAYER) FUCK YOU WHY NOT?!!!!!
        npc.SpriteOffset = Vector(0,-22)
        d.rot = rng:RandomInt(0, 360)
        d.newpos = npc.Position + Vector(5, 5):Rotated(d.rot)
        d.newpos = d.newpos - npc.Position
        npc.StateFrame = 9
        sprite:Play("Spin")
        d.slowdown = 0
        d.init = true
	end

	if d.state == "movin" then
        if npc.StateFrame <= d.wait then
        sprite:Play("Idle")
        npc.Velocity = npc.Velocity:Resized(5/d.slowdown)
        d.slowdown = d.slowdown + (1/10)
        else
            d.rot = d.rot + rng:RandomInt(25, 45)
		    mod:spritePlay(sprite, "Spin")
            if not d.rotstart then
                if not isFriendly then
                local creep = Isaac.Spawn(1000, 22,  0, npc.Position, Vector(0, 0), npc):ToEffect()
                    creep:SetTimeout(creep.Timeout - 45)
                    params.FallingSpeedModifier = -3
                    params.FallingAccelModifier = -0.15
                    params.Scale = 1.3
                    creep:Update()
                end
                npc:FireProjectiles(npc.Position, Vector.Zero, 0, params)
                d.rotstart = true
            end
            if mod:isScare(npc) then
                npc.Velocity = mod:Lerp(npc.Velocity, d.newpos, -0.1)
            else
                npc.Velocity = mod:Lerp(npc.Velocity, d.newpos, 0.1)
            end
        end
        npc.StateFrame = npc.StateFrame + 1
    end

    if sprite:IsFinished("Spin") then
        d.rotstart = false
        npc.StateFrame = 0
        d.slowdown = 1
        if targetpos:Distance(npc.Position) > 130 then
            d.newpos = npc.Position + Vector(5, 5):Rotated(d.rot)
            d.newpos = d.newpos - npc.Position
            d.wait = 10
        else
            d.newpos = targetpos
            d.newpos = (d.newpos - npc.Position):Resized(6)
            d.wait = 5
        end
    end

end


--ok so the rlly shitty thing is that the baby is kinda like the parent but not at all
--idk how to explain it but this isn;t very effieicnt
--guys how do i make it effieicnt
function mod:ErythorcytebabyAI(npc, sprite, d)
    local room = Game():GetRoom()
    local targetpos = mod:GetSpecificEntInRoom({ID = mod.Monsters.Erythorcyte.ID, Var = mod.Monsters.Erythorcyte.Var}, npc).Position or npc:GetPlayerTarget().Position
    local params = ProjectileParams()
    local roomEntities = room:GetEntities()

	if not d.init then
        d.wait = 10
        sprite.Scale = sprite.Scale * 0.5
		d.state = "movin"
        d.dist = 5000
        d.accel = 0
        npc.SpriteOffset = Vector(0,-22)
        d.rot = rng:RandomInt(0, 360)
        d.newpos = npc.Position + Vector(5, 5):Rotated(d.rot)
        d.newpos = d.newpos - npc.Position
        npc.StateFrame = 9
        sprite:Play("Spin")
        d.slowdown = 0
        d.init = true
	end

	if d.state == "movin" then
        if npc.StateFrame <= d.wait then
        sprite:Play("Idle")
        npc.Velocity = npc.Velocity:Resized(2/d.slowdown)
        d.slowdown = d.slowdown + (1/10)
        else
            d.rot = d.rot + rng:RandomInt(25, 45)
		    mod:spritePlay(sprite, "Spin")
            if not d.rotstart then
                local creep = Isaac.Spawn(1000, 22,  0, npc.Position, Vector(0, 0), npc):ToEffect()
                    creep:SetTimeout(creep.Timeout - 45)
                    params.FallingSpeedModifier = -2
                    params.FallingAccelModifier = 0
                    creep.Scale = 0.3
                    params.Scale = 0.6
                npc:FireProjectiles(npc.Position, Vector.Zero, 0, params)
                creep:Update()
                d.rotstart = true
            end
            if mod:isScare(npc) then
                npc.Velocity = mod:Lerp(npc.Velocity, Vector(2, 0), 1, 5, 5)
            else
                npc.Velocity = mod:Lerp(npc.Velocity, d.newpos, 0.1)
            end
        end
        npc.StateFrame = npc.StateFrame + 1
    end

    if sprite:IsFinished("Spin") then
        d.rotstart = false
        npc.StateFrame = 0
        d.slowdown = 1
        if d.newhost ~= nil then
        d.newpos = d.newhost.Position
        d.newpos = (d.newpos - npc.Position):Resized(2)
        else
            if targetpos:Distance(npc.Position) > 300 then
                d.newpos = npc.Position + Vector(2, 2):Rotated(d.rot)
                d.newpos = d.newpos - npc.Position
                d.wait = 10
            else
                d.newpos = targetpos
                d.newpos = (d.newpos - npc.Position):Resized(6)
                d.wait = 5
            end
        end
        d.wait = 5
    end

end
