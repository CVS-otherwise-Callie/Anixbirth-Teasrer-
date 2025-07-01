local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Jokes.Willowalker.Var then
        mod:WillowalkerAI(npc, npc:GetSprite(), npc:GetData())
	  end
end, mod.Jokes.Willowalker.ID)

function mod:WillowalkerAI(npc, sprite, d)

    local player = npc:GetPlayerTarget()

    if not d.init then
        d.targetheight = npc.Position.Y
        if player.Position.X > npc.Position.X then
            d.targetposdir = "Left"
        else
            d.targetposdir = "Right"
        end
        mod:spritePlay(sprite, "IdleFront")
        npc.EntityCollisionClass = 0
	    npc.GridCollisionClass = 0
        d.state = "idle"
        d.init = true
    end

    if math.abs(player.Position.X - npc.Position.X) < 25 and not (sprite:GetFrame() > 20) then
        d.dir = "Front"
    elseif player.Position.X > npc.Position.X then
        d.dir = "Right"
    else
        d.dir = "Left"
    end

    if d.state == "idle" then
        if d.targetposdir == "Left" then
            d.targetposX = player.Position.X - 200
        else
            d.targetposX = player.Position.X + 200
        end
        if npc.Position.X > d.targetposX then
            npc.Velocity = Vector(npc.Velocity.X - 1, 0)
        else
            npc.Velocity = Vector(npc.Velocity.X + 1, 0)
        end
        npc.Position.Y = d.targetheight
        npc.Velocity = npc.Velocity:Resized(math.min(npc.Velocity:Length(), 10))
        sprite:SetAnimation( "Idle"..d.dir, false)
    end
end