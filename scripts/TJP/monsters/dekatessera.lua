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

    if isGehenna then
        mod:ReplaceEnemySpritesheet(npc, "gfx/monsters/dekatessera/dekatessera_gehenna", 0)
        mod:ReplaceEnemySpritesheet(npc, "gfx/monsters/dekatessera/dekatessera_gehenna", 1)
    end

    if npc.StateFrame > 100 then
        d.targetpos =  mod:freeGrid(npc, false, 200, 100)
        npc.StateFrame = 0
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

    if d.state == "Idle" then
        d.targetvelocity = (d.targetpos - npc.Position):Resized(7)
        mod:spritePlay(sprite, "Idle")
        if npc.Position:Distance(d.targetpos) > 5 then
            npc.Velocity = mod:Lerp(npc.Velocity, d.targetvelocity, 0.1)
        end

        if d.cooldown > 200 then
            d.state = "Attack"
        end


    end

    if d.state == "Attack" then

        npc:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK)

        npc:MultiplyFriction(0.5)
        mod:spritePlay(sprite, "Attack")
        if sprite:IsFinished() then
            d.cooldown = 0
            d.state = "Recharge"
        end
    end

    if d.state == "Recharge" then

        npc:MultiplyFriction(0.5)

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
        local dat = d.dekBall:GetData()
        dat.stageTypeDekka = isGehenna
        dat.dekkaTears = {}
        for i = 1, 8 do
            local p = Isaac.Spawn(9, 0, 0, npc.Position, Vector.Zero, npc):ToProjectile()

            p:GetData().offyourfuckingheadset = 70 + math.random(-10, 10) --fuuuuu THIS WONT BREAK TRUST!!!!
            p:GetData().StateFrame = 0
            p:GetData().Baby = d.dekBall
            p:GetData().moveit = (360/10) * i
            p:GetData().type = "SyntheticHorf"
            p:GetData().Player = player --d.dekBall

            if not isGehenna then
                p:GetSprite().Color = myawesomepurplecolor
            end

            table.insert(dat.dekkaTears, p)
        end
    end

    if sprite:IsEventTriggered("attack") then
        if d.dekBall then

            if isGehenna then
                d.dekBall:GetData().target = mod:GetEntInRoom(npc, true, npc)
            else
                d.dekBall:GetData().target = player
            end
            d.dekBall = nil
        end
    end
end

