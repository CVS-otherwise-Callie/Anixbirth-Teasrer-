local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.Bewebbed.Var then
        mod:BewebbedAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.Bewebbed.ID)

function mod:BewebbedAI(npc, sprite, d)

    local player = npc:GetPlayerTarget()
    local targetpos = mod:confusePos(npc, player.Position, 5, nil, nil)
    local params = ProjectileParams()
    local room = game:GetRoom()

    local function GetBewebbedGrid(pos)
        local vec = Vector(0, 1)
        local distance = 100000

        local pick
        local rot 
        for i = 1, 4 do
            local gridvalid = true
            local dist = 1
            while gridvalid == true do
                local newpos = pos + (vec:Rotated(i*90) * dist)
                local gridColl = room:GetGridCollisionAtPos(newpos)
                if gridColl == GridCollisionClass.COLLISION_WALL or not room:IsPositionInRoom(newpos, 15) then
                    gridvalid = false
                    if newpos:Distance(pos) < distance then
                        pick = newpos
                        distance = newpos:Distance(pos)
                        rot = i+2
                    end
                else
                    dist = dist + 1
                end
            end
        end
        return pick, rot
    end

    if not d.init then

        d.init = true


        npc:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK)
        npc.GridCollisionClass = GridCollisionClass.COLLISION_NONE

        d.WallPosition,d.Direction = GetBewebbedGrid(npc.Position)
        d.WallPosition = d.WallPosition + Vector(0, -10):Rotated(d.Direction*90)

        d.state = "idle"

        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    npc.Position = d.WallPosition
    sprite.Rotation = d.Direction*90

    if npc.StateFrame > 50 and not sprite:IsPlaying("Shoot") then
        mod:spritePlay(sprite, "Shoot")
    end

    if sprite:IsFinished("Shoot") then
        mod:spritePlay(sprite, "Idle")
        npc.StateFrame = 0
    end

    if sprite:IsEventTriggered("Shoot") then

        params.BulletFlags = params.BulletFlags | ProjectileFlags.NO_WALL_COLLIDE

        params.Color = Color(0,0,0,0.3,204 / 255,204 / 255,204 / 255)

        params.FallingAccelModifier = -0.1

        npc:FireProjectiles(npc.Position + (targetpos - npc.Position):Resized(1), (targetpos - npc.Position):Resized(7), 0, params)
    end

end

function mod.BewebbedShot(v, d)
    if v.SpawnerEntity and v.SpawnerType == mod.Monsters.Bewebbed.ID and v.SpawnerVariant == mod.Monsters.Bewebbed.Var then
        d.tar = d.tar or v.SpawnerEntity:ToNPC():GetPlayerTarget()

        local targetvelocity = (d.tar.Position - v.Position):Resized(20)
        v.Velocity = mod:Lerp(v.Velocity, targetvelocity, 0.005)

        if v:IsDead() then
            for i = 1, 4 do
                local shot = Isaac.Spawn(9, 0, 0, v.Position, Vector(5, 0):Rotated((d.tar.Position - v.Position):GetAngleDegrees() + (i-1)*90), nil):ToProjectile()
                shot.Size = 0.5
                shot:GetSprite().Color = Color(0,0,0,0.3,204 / 255,204 / 255,204 / 255)
                shot:GetSprite().Scale = shot:GetSprite().Scale * 0.7
                shot.FallingAccel = 2
                shot.FallingSpeed = -5
                shot:AddProjectileFlags(ProjectileFlags.NO_WALL_COLLIDE)
            end
        end
    end
end

