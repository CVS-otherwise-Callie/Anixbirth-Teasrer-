local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.Ulig.Var then
        mod:UligAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.Ulig.ID)

local function GetFliesWithSameDataUlig(npc)
    local tab = {}
    for k, fly in ipairs(Isaac.FindByType(EntityType.ENTITY_DART_FLY)) do
        if not fly:IsDead() and fly:Exists() and (fly:GetData().InitSeed == npc:GetData().InitSeed or fly:GetData().InitSeed == "TWW8XoULQRk") and fly.Position:Distance(npc.Position) > 0 then
            table.insert(tab, fly)
        end
    end
    return tab
end

function mod:UligAI(npc, sprite, d)

    local target = npc:GetPlayerTarget()
    local targetpos = mod:confusePos(npc, target.Position, 5, nil, nil)
    local room = game:GetRoom()
    local num = 7
    local path = npc.Pathfinder
    local params = ProjectileParams()

    if not d.init then
        d.state = "hiding"
        d.InitSeed = math.random(1000000, 2000000)
        d.lerpnonsense = 0.08
        d.coolaccel = 1.2
        d.CoolDown = npc.StateFrame + math.random(50, 70) - 3*num
        d.wait = math.random(20, 40) - 3*num
        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    if d.state == "hiding" then
        npc:AddEntityFlags(EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_STATUS_EFFECTS)
        npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
        npc.GridCollisionClass = GridCollisionClass.COLLISION_NONE

        if npc.StateFrame > 30 + math.random(5, 15) then
            mod:spritePlay(sprite, "Disappear")
        end

    elseif d.state == "getup" then
        mod:MakeVulnerable(npc)
        npc.GridCollisionClass = 5
        npc.StateFrame = 0
        mod:spritePlay(sprite, "ComeUp")
        npc:PlaySound(SoundEffect.SOUND_MAGGOT_ENTER_GROUND, 1, 0, false, 1)
        d.state = nil

    elseif d.state== "shoot" then

        mod:spritePlay(sprite, "SpawnEntity")

    elseif d.state == "chase" then

        if npc.StateFrame%90 == 0 then
            npc:PlaySound(SoundEffect.SOUND_ZOMBIE_WALKER_KID,1,0,false,1)
        end

        if npc.StateFrame > 20 then

            if d.coolaccel and d.coolaccel < 5 then
                d.coolaccel = d.coolaccel + 0.1
            end
            if mod:isScare(npc) then
                local targetvelocity = (targetpos - npc.Position):Resized(-10)
                npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, d.lerpnonsense)
            elseif game:GetRoom():CheckLine(npc.Position,targetpos,0,1,false,false) then
                local targetvelocity = (targetpos - npc.Position):Resized(10)
                npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, d.lerpnonsense)
            else
                path:FindGridPath(targetpos, 0.7, 1, true)
            end

            npc.Velocity = mod:Lerp(npc.Velocity, npc.Velocity:Resized(d.coolaccel), d.lerpnonsense)
            if npc:CollidesWithGrid() then
                d.coolaccel = 1
            end
            mod:CatheryPathFinding(npc, target.Position, {
                Speed = d.coolaccel,
                Accel = d.lerpnonsense,
                GiveUp = true
            })
            if rng:RandomInt(1, 2) == 2 then
                d.lerpnonsense = mod:Lerp(d.lerpnonsense, 0.04, 0.05)
            else
                d.lerpnonsense = mod:Lerp(d.lerpnonsense, 0.01, 0.02)
            end
        elseif not sprite:IsPlaying("SpawnEntityStand") then
            if npc.StateFrame <= d.CoolDown then
                if mod:isCharm(npc) then
                    if (Game():GetRoom():CheckLine(npc.Position, targetpos, 0, 1, false, false) and not npc:CollidesWithGrid()) or npc:GetChampionColorIdx() == 8 then
                        npc.Velocity = npc.Velocity + (targetpos - npc.Position):Normalized() * 1.35
                    else
                        path:FindGridPath(targetpos, 0.85, 1, true)
                    end
                elseif mod:isScare(npc) then
                    if (Game():GetRoom():CheckLine(npc.Position, targetpos, 0, 1, false, false) and not npc:CollidesWithGrid()) or npc:GetChampionColorIdx() == 8 then
                        npc.Velocity = npc.Velocity + (targetpos - npc.Position):Normalized() * -1.35
                    else
                        path:FindGridPath(targetpos, -0.85, 1, true)
                    end
                else
                    npc.Velocity = npc.Velocity + npc.Velocity:Normalized() * 1.05
                    path:MoveRandomly(false)
                end
            end
            if npc.StateFrame > d.CoolDown+d.wait then
                d.CoolDown = npc.StateFrame + math.random(50, 70) - 3*num
                d.wait = math.random(20, 40) - 3*num
            end
            npc:MultiplyFriction(0.65+(0.016*num))
        else
            npc:MultiplyFriction(0.8)
        end

        if npc.Velocity:Length() > 0.5 and not sprite:IsPlaying("SpawnEntityStand") then
            npc:AnimWalkFrame("WalkHori","WalkVert",0)
        elseif not sprite:IsPlaying("SpawnEntityStand") then
            sprite:SetFrame("WalkHori", 0)
        end
                
        sprite:Update()

        if npc.StateFrame > 90 then
            npc.StateFrame = 0
            if #GetFliesWithSameDataUlig(npc) <= 1 then
                mod:spritePlay(sprite, "SpawnEntityStand")
            end
        end
        
    end

    if sprite:IsFinished("ComeUp") then
        npc.StateFrame = 0
        d.state = "chase"
    elseif sprite:IsFinished("Disappear") then
        npc.Position = mod:freeGrid(npc, false, 300, 0)
        mod:spritePlay(sprite, "Appear")
        d.state = "shoot"
    elseif sprite:IsFinished("SpawnEntity") and d.state ~= "hiding" then
        d.state = "hiding"
        npc.StateFrame = 0
    elseif sprite:IsFinished("SpawnEntityStand") then
        sprite:SetFrame("WalkHori", 0)
        npc.StateFrame = 0
    end

    if sprite:IsEventTriggered("Shoot") or (sprite:IsPlaying("SpawnEntityStand") and sprite:GetFrame()  == 10) then
        local flynum = 1
        local seed
        if sprite:IsPlaying("SpawnEntity") then
            flynum = 2
            seed = d.InitSeed
        else
            seed = "TWW8XoULQRk"
        end
        if #GetFliesWithSameDataUlig(npc) < flynum and #Isaac.FindByType(EntityType.ENTITY_DART_FLY) <= 2 then
            local fly = Isaac.Spawn(EntityType.ENTITY_DART_FLY, -1, -1, npc.Position, Vector.Zero, npc)
            fly:GetData().InitSeed = seed
        else
            local proj = Isaac.Spawn(9, 0, 0, npc.Position, (targetpos - npc.Position):Resized(10), npc):ToProjectile()
            proj.Height = -5
            proj.FallingSpeed = -20
            proj.FallingAccel = 1
            proj.Size = 1.5
            proj:Update()
        end
    end

end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, npc, damage, flag, source)
    if npc.Variant == mod.Monsters.Ulig.Var and flag ~= flag | DamageFlag.DAMAGE_CLONES and npc:GetData().state == "hiding" then
        npc:GetData().state = "getup"
        npc.GridCollisionClass = 5
        npc:TakeDamage(damage*0.1, flag | DamageFlag.DAMAGE_CLONES, source, 0)
        return false
    end
end, mod.Monsters.Ulig.ID)