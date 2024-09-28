local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.Silly.Var then
        mod:SillyStringAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.Silly.ID)

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.String.Var then
        mod:SillyStringAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.String.ID)

function mod:SillyStringAI(npc, sprite, d)
    if npc.Variant == mod.Monsters.Silly.Var then d.isSilly = true end
    if npc.Variant == mod.Monsters.String.Var then d.isString = true end

    local projparams = ProjectileParams()
    local extraanim = ""

    if not d.init then
        d.state = "idle"
        npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
        if d.isSilly then
            local targets = {}
            for _, ent in ipairs(Isaac.GetRoomEntities()) do
                if not ent:IsDead()
                and not ent:HasEntityFlags(EntityFlag.FLAG_FRIENDLY)
                and ent.Type == mod:ENT("String").ID and ent.Variant == mod:ENT("String").Var and ent.SubType == mod:ENT("String").Sub
                and ent.Parent ~= npc  then
                    table.insert(targets, ent)
                end
            end
            if (#targets == 0) then
                d.baby = npc:GetPlayerTarget()
            else
                d.baby = targets[math.random(1, #targets)]
            end
            d.baby.Parent = npc
            d.baby:GetData().Par = npc
        else
            d.baby = npc.Parent
        end
        if not d.baby then
            d.baby = npc:GetPlayerTarget()
        end
        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    npc.Velocity = mod:Lerp(npc.Velocity, (d.baby.Position - npc.Position):Resized(40), 0.01)

    if d.state == "idle" then
        sprite:Play("Idle")
    end

    if d.isRecieving then
        extraanim = "Recive"
    end

    if d.state == "shoot" then
        mod:spritePlay(sprite, extraanim .. "Shoot")
        local effect = Isaac.Spawn(1000, 2, 5, npc.Position, Vector.Zero, npc):ToEffect()
        effect.SpriteOffset = Vector(0,-6)
        effect.DepthOffset = npc.Position.Y * 1.25
        effect:FollowParent(npc)
        npc:FireProjectiles(npc.Position, Vector(10, 0):Rotated((d.baby - npc.Position):GetAngleDegrees()), 0, projparams)
    end

    npc:MultiplyFriction(0.1)
end

function mod.SillyStringGetHit(npc, coll)
    if npc.Type == 161 and (npc.Variant == mod.Monsters.String.Var or npc.Variant == mod.Monsters.Silly.Var) then
        if coll.Type == 1 or (coll.Type == 2 and coll.Parent.Position:Distance(npc.Position) < 30) then
            return true
        else
            if coll.Parent then
                print(coll.Type == 2,coll.Parent.Position:Distance(npc.Position), coll.Parent.Position:Distance(npc.Position) < 30)
            end
        end
    end
end


