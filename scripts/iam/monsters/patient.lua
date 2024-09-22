local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.Patient.Var then
        mod:PatientAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.Patient.ID)

function mod:PatientAI(npc, sprite, d)

    local path = npc.Pathfinder
    local target = npc:GetPlayerTarget()
    local targetpos = mod:confusePos(npc, target.Position, 5, nil, nil)
    local projparams = ProjectileParams()
    local patienttypes = {
        {
            name = "Virus",
            speed = "1",
            behavior = "WanderShoot",
            state = "Moving"
        }
    }

    if not d.init then
        local tab
        if npc.SubType == nil or npc.SubType == 0 then
            tab= patienttypes[math.random(1, #patienttypes)]
        else
            tab = patienttypes[npc.SubType]
        end
        for h, g in pairs(tab) do
            if not d[h] then
                d[h] = g
            end
        end
        d.rounds = 0
        d.newpos = npc.Position
        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    --movement
    if d.behavior == "WanderShoot" then

        if npc.StateFrame > 60 then
            d.state = "Shoot"
            npc.StateFrame = 0
        end

        if d.state == "Moving" then

            --stolen off of the neutral fly cus im tired and lazy tonight
            npc.Velocity = npc.Velocity + npc.Velocity:Normalized() * 1.05
            path:MoveRandomly()
            npc:MultiplyFriction(0.7)
        elseif d.state == "Shoot" then

            npc:MultiplyFriction(0.1)
            npc:PlaySound(SoundEffect.SOUND_SHAKEY_KID_ROAR,1,0,false,1)
            local effect = Isaac.Spawn(1000, 2, 5, npc.Position, Vector.Zero, npc):ToEffect()
                effect.SpriteOffset = Vector(0,-6)
                effect.DepthOffset = npc.Position.Y * 1.25
                effect:FollowParent(npc)
                npc:FireProjectiles(npc.Position, Vector(10, 0):Rotated((targetpos - npc.Position):GetAngleDegrees()), 0, projparams)
            d.state = "Moving"
        end
    end

    --finally animations
    sprite:PlayOverlay("head")

    if npc.Velocity:Length() > 1 then
        npc:AnimWalkFrame("walk h","walk v",0)
    else
        sprite:SetFrame("walk v", 0)
    end

end

