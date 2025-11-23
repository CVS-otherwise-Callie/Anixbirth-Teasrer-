local mod = FHAC
local game = Game()
local rng = RNG()

function mod:AmekatzeAI(npc, sprite, d)

    local target = npc:GetPlayerTarget()
    local room = game:GetRoom()
    local path = npc.Pathfinder

    npc.StateFrame = npc.StateFrame + 1

    d.typename = d.typename or "HasBeenPlanted"

    if npc.SubType == 1 then
        mod:spritePlay(sprite, "Bomb" .. d.typename)

        if sprite:IsPlaying("BombHasBeenPlanted") then
            npc.Velocity = mod:Lerp(npc.Velocity, (target.Position - npc.Position):Resized(12), 0.6)
        end

        npc:MultiplyFriction(0.85)
    else

        if mod:isScare(npc) then
            if target.Position.X > npc.Position.X then
                sprite.FlipX = true
                else
                sprite.FlipX = false
            end
        else
            if target.Position.X > npc.Position.X then
                sprite.FlipX = false
                else
                sprite.FlipX = true
            end
        end

        local teartab = {}

        for k, v in ipairs(Isaac.GetRoomEntities()) do
            if v.Type == 2 then
                table.insert(teartab, v)
            end
        end

        local closesttear
        local initdis = 10^10
        for k, v in ipairs(teartab) do
            local dis = npc.Position:Distance(v.Position)
            if dis < initdis then
                closesttear = v
            end
        end

        if closesttear then
            path:EvadeTarget(closesttear.Position)
        end

        d.hidingplace = mod:findHideablePlace(target)

        if mod:isCharm(npc) then
            npc.Velocity = npc.Velocity + npc.Velocity:Normalized() * 1.05
            path:FindGridPath(d.hidingplace, 1, 1, true)
        elseif mod:isScare(npc) then
            if (Game():GetRoom():CheckLine(npc.Position, d.hidingplace, 0, 1, false, false) and not npc:CollidesWithGrid()) or npc:GetChampionColorIdx() == 8 then
                npc.Velocity = npc.Velocity + (d.hidingplace - npc.Position):Normalized() * -1.35
            else
                path:FindGridPath(d.hidingplace, -0.85, 1, true)
            end
        else
            npc.Velocity = npc.Velocity + npc.Velocity:Normalized() * 1.05
            path:FindGridPath(d.hidingplace, 1, 1, true)
        end

        npc:MultiplyFriction(0.85)

        if npc:IsDead() then
            local bomb = Isaac.Spawn(mod.Monsters.Amekatze.ID, mod.Monsters.Amekatze.Var, 1, npc.Position, Vector.Zero, npc)
            bomb:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        end

        npc:AnimWalkFrame("WalkHori","WalkVert",0)
        mod:spriteOverlayPlay(sprite, "Walk")
    end

    if sprite:IsFinished("BombHasBeenPlanted") then
        d.typename = "ReadytoExplode"
    elseif sprite:IsFinished("BombReadytoExplode") then
        Isaac.Explode(npc.Position, npc, 80)

        Isaac.Spawn(EntityType.ENTITY_EFFECT, 1, -1, npc.Position, Vector.Zero, npc):ToEffect()
    
        for i = 1, 10 do
            local ef = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DUST_CLOUD, -1, npc.Position + Vector(0, 15):Rotated(36*i),Vector(0, 4):Rotated(36*i), npc):ToEffect()
            ef:SetTimeout(10)
            ef.SpriteScale = Vector(0.03,0.03)
        end

        npc:Kill()
    end

end

