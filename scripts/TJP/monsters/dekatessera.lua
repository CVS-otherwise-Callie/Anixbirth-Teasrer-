local mod = FHAC
local game = Game()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.Dekatessera.Var then
        mod:DekatesseraAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.Dekatessera.ID)

function mod:DekatesseraAI(npc, sprite, d)
    local player = npc:GetPlayerTarget()
    local room = game:GetRoom()
    local isGehenna = (room:GetBackdropType() == BackdropType.GEHENNA)
    local myawesomepurplecolor = Color(1,1,1,1,0.6,0,0.5)
    myawesomepurplecolor:SetColorize(1,1,1,1)
    local myawesomeredcolor = Color(1,1,1,1,0.6,0,0)
    myawesomeredcolor:SetColorize(1,1,1,1)

    d.attacktype = "Mausoleum"
    if isGehenna then
        mod:ReplaceEnemySpritesheet(npc, "gfx/monsters/dekatessera/dekatessera_gehenna", 0)
        mod:ReplaceEnemySpritesheet(npc, "gfx/monsters/dekatessera/dekatessera_gehenna", 1)
        d.attacktype = "Gehenna"
    end

    if not d.init then
        npc.GridCollisionClass = 0

        d.cooldown = 0
        d.targetpos =  mod:freeGrid(npc, false, 200, 100)
        d.state = "Idle"
        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
        d.cooldown = d.cooldown + 1
    end

    if d.state ~= "Recharge" then
        d.targetvelocity = (d.targetpos - npc.Position)
        if (d.targetvelocity * 0.1):Length() > 15 then
            npc.Velocity = mod:Lerp(npc.Velocity, d.targetvelocity:Resized(15), 0.1)
        else
            npc.Velocity = mod:Lerp(npc.Velocity, d.targetvelocity * 0.1, 0.1)
        end
    end

    if d.state ~= "Attack" then
        if npc.StateFrame > 100 then
            d.targetpos =  mod:freeGrid(npc, false, 200, 100)
            npc.StateFrame = 0
        end
    end

    if d.state == "Idle" then
        mod:spritePlay(sprite, "Idle")

        if d.cooldown > 200 then
            d.state = "Attack"
        end
    end

    if d.state == "Attack" then
        mod:spritePlay(sprite, "Attack".. d.attacktype)
        if sprite:IsFinished() then
            d.cooldown = 0
            d.state = "Recharge"
        end
    end

    if d.state == "Recharge" then

        npc:MultiplyFriction(0.8)

        if d.cooldown > 200 then
            mod:spritePlay(sprite, "Reset")
            if sprite:IsFinished() then
                d.cooldown = 0
                d.state = "Idle"
            end
        else
            mod:spritePlay(sprite, "Recharge")
        end
    end

    if sprite:IsEventTriggered("summon") then
        d.dekBall = Isaac.Spawn(mod.Effects.DekatesseraEffect.ID, mod.Effects.DekatesseraEffect.Var, mod.Effects.DekatesseraEffect.Sub, npc.Position, Vector.Zero, npc)
        d.dekBall:GetData().Baby = npc

        if isGehenna then
            d.dekBall:GetData().precision = 1
        else
            d.dekBall:GetData().precision = 10
        end
        for i = 1, 6 do
            local p = Isaac.Spawn(9, 0, 0, npc.Position, Vector.Zero, npc):ToProjectile()

            p:GetData().StateFrame = 0
            p:GetData().Baby = d.dekBall
            p:GetData().type = "Dekatessera"
            p:GetData().number = i
            p:GetData().distance = 35

            p:GetSprite().Color = myawesomeredcolor
            if not isGehenna then
                p:GetSprite().Color = myawesomepurplecolor
                p:GetData().distance = 70
            end
        end
    end

    if sprite:IsEventTriggered("attack") then
        if d.dekBall then

            local enemies = {}
            for i, entity in ipairs(Isaac.GetRoomEntities()) do
                if (entity.Type ~= mod.Monsters.Dekatessera.ID) and (entity.Variant ~= mod.Monsters.Dekatessera.Var) and entity:IsActiveEnemy() then
                    table.insert(enemies, entity)
                end
            end

            if isGehenna then
                if #enemies > 0 then
                    d.dekBall:GetData().target = enemies[math.random(1, #enemies)]
                else
                    d.dekBall:GetData().target = player
                end
            else
                d.dekBall:GetData().target = player
            end
            d.dekBall = nil
        end
    end
end

function mod.DekatesseraShot(p, d)
    if d.type == "Dekatessera" then
        local room = game:GetRoom()
        local target = d.Baby
        p.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
        p.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
        if not d.init then
            d.init = true
        else
            d.StateFrame = d.StateFrame + 1
        end
        if target:IsDead() then--or room:IsClear() then
            p.FallingAccel = p.FallingAccel + 0.001
        else
            d.targetpos = target.Position + Vector(0,d.distance):Rotated(((360/6)*d.number) + d.StateFrame)
            p.Velocity = mod:Lerp(p.Velocity, (d.targetpos - p.Position), math.min(d.StateFrame/60, 1))
            p.Height = -21
        end
    end
end