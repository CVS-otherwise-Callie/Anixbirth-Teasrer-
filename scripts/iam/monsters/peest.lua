local mod = FHAC
local game = Game()
local rng = RNG()
local sfx = SFXManager()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.CVSMonsters.Peest.Var then
        mod:PeestAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.CVSMonsters.Peest.ID)

function mod:PeestAI(npc, sprite, d)

    local target = npc:GetPlayerTarget()
    local targetpos = mod:confusePos(npc, target.Position, 5, nil, nil)

    if not d.init then
        d.state = "idle"
        d.addon = 0
        local color = Color(1,1,1,1,0.6,0.5,0.05)
        npc.SplatColor = color
        d.canBeHit = false
        npc:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK)
        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    if d.state == "shoot" then
        mod:spritePlay(sprite, "Shoot")
    elseif d.state == "idle" then
        d.shotsnum = 1
        mod:spritePlay(sprite, "Idle")

        if npc.StateFrame%20 == 0 then
            local creep = Isaac.Spawn(1000, EffectVariant.CREEP_YELLOW,  0, npc.Position + RandomVector(), Vector(0, 0), npc):ToEffect()
            creep.Scale = creep.Scale * 1.2
            creep:SetTimeout(40)
            creep:Update()
        end
            
        for _, tear in pairs(Isaac.FindByType(2, -1, -1, false, false)) do
            if tear.Position:Distance(npc.Position) < 20 and d.canBeHit == false then
                d.addon = d.addon + math.random(5)
            end
        end
        if npc.StateFrame > 100 + d.addon and game:GetRoom():CheckLine(target.Position,npc.Position,3,900,false,false) then
            d.state = "shoot"
        end
    elseif d.state == "bombed" then
        mod:spritePlay(sprite, "Bombed")
        
        if npc.StateFrame > 100 then
            d.state = "idle"
            npc.StateFrame = 0
        end
    end
    
if sprite:IsFinished("Shoot") then
        if math.random(3) == 3 then
            mod:spritePlay(sprite, "Dissapear")
            d.state = nil
        else
            d.state = "idle"
        end
        npc.StateFrame = 0
    elseif sprite:IsFinished("Dissapear") then
        d.state = "hiding"
    end
    
    if sprite:IsEventTriggered("Open") then
        npc:ClearEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)
        d.canBeHit = true
    elseif sprite:IsEventTriggered("Close") then
        d.canBeHit = false
    elseif sprite:IsEventTriggered("Shoot") then
        npc:PlaySound(SoundEffect.SOUND_BLOODSHOOT,1,0,false,1)
        d.shotsnum = d.shotsnum + 1
        for i = 1, math.random(4, 7) do
            local newtear = Isaac.Spawn(9, 0, 0, npc.Position, ((targetpos+Vector(math.random(-20, 20), math.random(-20, 20))) - (npc.Position+Vector(math.random(-20, 20), math.random(-20, 20)))):Resized(i), npc)
            local scalecalc = math.random(30,60) / 100
            newtear:ToProjectile().Scale = scalecalc
            local num = ((4/(d.shotsnum/2)) - 1.5)
            if num < 1 then
                num = 1
            end
            newtear:ToProjectile().FallingSpeed = (-50) --/ num
            newtear:ToProjectile().FallingAccel = (2) --/ num
            --newtear:ToProjectile().Height = -15
            local col = Color(1,1,1,1,0,0,0)
            col:SetColorize(2.5, 1.9, 0.5, 1)
            newtear:GetSprite().Color = col
            newtear:GetData().type = "peest"
            newtear:GetData().target = target
            newtear:GetData().realmult = num
            newtear:ToProjectile():Update()
        end
    end

end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, npc, amt, flag, source)
    if npc.Type == 161 and npc.Variant == 2554 then
        if not npc:GetData().canBeHit then
            if (flag & DamageFlag.DAMAGE_EXPLOSION ~= 0 and mod:IsSourceofDamagePlayer(source, true) == false and npc.Variant == 1) or amt > 20 then
                npc:ToNPC():GetData().state = "bombed"
                npc:ToNPC().StateFrame = 0
            end
            return false
        end
    end
end, mod.CVSMonsters.Peest.ID)

function mod.peestShotDeath(p, d)
    if d.type == "peest" and p:IsDead() then
        local creep = Isaac.Spawn(1000, EffectVariant.CREEP_YELLOW,  0, game:GetRoom():GetClampedPosition(p.Position, 15), Vector(0, 0), p):ToEffect()
        creep.Scale = creep.Scale * 0.5
        creep:SetTimeout(187)
        creep:Update()
    end
end

function mod.peestShot(p, d)
    if d.type == "peest" then

        if not d.init then
            d.mult = math.random(80, 120)/100
            d.mult2 = math.random(60, 80)/100
            d.randVec = Vector(math.random(-50, 50), math.random(-50, 50))
            d.init = true
        end

        d.targetpos = d.target.Position+Vector(math.random(-5, 5), math.random(-5, 5))
        local truepos = (d.targetpos - p.Position) + (d.targetpos - p.Position):Normalized()*d.mult
        d.randVec = mod:Lerp(d.randVec, Vector(math.random(-20, 20), math.random(-20, 20)), 0.07)
        p.Velocity = mod:Lerp(Vector.Zero, (truepos + d.randVec), (d.mult2*70/1500)/((d.realmult)/2))

    end
end

