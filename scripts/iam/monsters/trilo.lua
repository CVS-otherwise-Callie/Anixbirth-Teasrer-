local mod = FHAC
local game = Game()
local rng = RNG()

function FindAllTrilo()
    local tab = {}
    for k, v in ipairs(Isaac.GetRoomEntities()) do
        if v.Type == 161 and v.Variant == mod.Monsters.Trilo.Var and v:IsActiveEnemy() then
            table.insert(tab, v)
        end
    end
    return tab
end

function mod:TriloAI(npc, sprite, d)

    local target = npc:GetPlayerTarget()
    local targetpos = mod:confusePos(npc, target.Position, 5, nil, nil)
    local room = game:GetRoom()
    local num = 7
    local path = npc.Pathfinder
    local params = ProjectileParams()

    if not d.init then
        d.heatLevel = 1
        d.amountofTriloInRoom = #FindAllTrilo()

        for k, v in ipairs(Isaac.GetRoomEntities()) do
            if v.Type == 161 and v.Variant == mod.Monsters.Trilo.Var and v:GetData().amountofTriloInRoom == nil then
                v:GetData().amountofTriloInRoom = #FindAllTrilo()
            elseif v.Type == 161 and v.Variant == mod.Monsters.Trilo.Var and v:GetData().amountofTriloInRoom ~= d.amountofTriloInRoom then
                v:GetData().amountofTriloInRoom = v:GetData().amountofTriloInRoom + 1
            end
        end

        d.bodyHeat = 1
        d.state = "Chase"
        sprite:SetOverlayAnimation("Head" .. d.heatLevel)
        d.init = true
    end

    if d.state == "Chase" then

        if d.heatLevel < 5 and not d.isBlowingUp then
            sprite:PlayOverlay("Head"  .. d.heatLevel, true)
        end

        if mod:isScare(npc) then
            local targetvelocity = (targetpos - npc.Position):Resized(-4 - d.heatLevel)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.25)
        elseif game:GetRoom():CheckLine(npc.Position,targetpos,0,1,false,false) then
            local targetvelocity = (targetpos - npc.Position):Resized(4 + d.heatLevel)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.25)
        else
            path:FindGridPath(targetpos, (0.5+(d.heatLevel/3))*0.7, 900, true)
        end

    elseif d.state == "Blowup" then
        npc:MultiplyFriction(0.9)
        sprite:PlayOverlay("HeadTransition".. (d.heatLevel-1))
    end

    if #FindAllTrilo() == 1 and d.heatLevel > 1 then
        d.state = "Chase"
        d.state = nil
        npc:MultiplyFriction(0.99)
        d.isBlowingUp = true
        sprite:PlayOverlay("HeadTransition4")
        d.bodyHeat = 3
    end

    if sprite:IsOverlayFinished("HeadTransition".. (d.heatLevel-1)) then
        d.state = "Chase"
    end

    if npc.Velocity:Length() > 0.5 then
        npc:AnimWalkFrame("WalkHori"  .. d.bodyHeat,"WalkVert"  .. d.bodyHeat,0)
    else
        sprite:SetFrame("WalkHori"  .. d.bodyHeat, 0)
    end

    if sprite:IsOverlayPlaying("HeadTransition4") then
        npc:MultiplyFriction(0.8)
    end

    if sprite:IsOverlayPlaying("HeadTransition4") and sprite:GetOverlayFrame() == 33 then
        npc.SplatColor = FHAC.Color.Charred
        Isaac.Explode(npc.Position, npc, 40)
        npc:Kill()
    elseif sprite:GetOverlayFrame() == 17 and string.find(sprite:GetOverlayAnimation(), "HeadTransition") and not (sprite:IsOverlayPlaying("HeadTransition4"))then
        mod:ShootFire(npc.Position, Vector(math.random()*5,0):Rotated(math.random(0,360)), {scale = 1, timer = 60, hp = 1, radius = 20})
        npc:PlaySound(SoundEffect.SOUND_MONSTER_GRUNT_1, 1, 0, false, 1.5)
        d.bodyHeat = d.bodyHeat + 1
    end

end

mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, function (_, npc)
    if npc.Type == 161 and npc.Variant == mod.Monsters.Trilo.Var and npc:IsDead() then
        for k, v in ipairs(Isaac.GetRoomEntities()) do
            mod.scheduleCallback(function()
                if v.Type == 161 and v.Variant == mod.Monsters.Trilo.Var and not v:IsDead() then
                    local oldheat = v:GetData().heatLevel

                    if v:GetData().amountofTriloInRoom < 3 then
                        v:GetData().heatLevel = v:GetData().heatLevel + 1
                    else
                        v:GetData().heatLevel = math.ceil((4 * (1+math.abs(v:GetData().amountofTriloInRoom - #FindAllTrilo())))/v:GetData().amountofTriloInRoom)
                    end

                    if v:GetData().heatLevel > 5 then v:GetData().heatLevel = 5 end
                    if oldheat ~= v:GetData().heatLevel then
                        v:GetData().state = "Blowup"
                    end
                end
            end, (k-1)*10, ModCallbacks.MC_NPC_UPDATE)     
        end
    end
end)

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function (_, npc, amount, damageFlags, source)
    if npc.Type == 161 and npc.Variant == mod.Monsters.Trilo.Var and (npc:GetData().isBlowingUp or string.find(npc:GetSprite():GetOverlayAnimation(), "HeadTransition")) and not mod:HasDamageFlag(DamageFlag.DAMAGE_CLONES, damageFlags) then
        npc:TakeDamage(amount*0.1, damageFlags | DamageFlag.DAMAGE_CLONES, source, 0)
        return false
    end
end)

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, npc, damage, flags, guy)
    if npc.Type == 161 and npc.Variant == mod.Monsters.Trilo.Var and flags == flags | DamageFlag.DAMAGE_FIRE then
        return false
    end
end)

-- i LOVE his animations
-- i always wanted to be a animator
-- so a ton of rspect
-- yeah but no drawing pen so uh :pensive: what did u think i wrote? ok then
-- hmmmm
-- i mean i should fix the numebr systme cus clearly it's kinda weird
-- no not even that this one internally
