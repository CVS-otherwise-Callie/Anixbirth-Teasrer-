local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.Roach.Var then
        mod:RoachAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.Roach.ID)

function mod:RoachAI(npc, sprite, d)
    if not d.init then
        npc:AddEntityFlags(EntityFlag.FLAG_NO_BLOOD_SPLASH)
        d.init = true
        d.state = "spawned"
        d.turndir = math.random(-12,12)
        if d.turndir == 0 then
            d.turndir = 1
        end
    end

    if npc.HitPoints <= 0 then
        npc.HitPoints = 1
    end

    if d.state == "spawned" then
        mod:spritePlay(sprite, "Appear")
        if sprite:IsFinished() then
            npc.Velocity = Vector(4,0):Rotated(math.random(0,360))
            d.state = "skuttle"
        end
    end

    if d.state == "skuttle" then
        if npc.Velocity.Y < 0 then
            d.facinganim = "Up"
        else
            d.facinganim = "Down"
        end
        npc:AnimWalkFrame("Hori", d.facinganim, 0)

        if math.random(1,20) == 1 then
            d.turndir = math.random(3,12)*-(d.turndir/math.abs(d.turndir))
        end

        npc.Velocity = npc.Velocity:Rotated(d.turndir):Resized(4)
    end

    if d.state == "dead" then
        npc.GridCollisionClass = 0
        npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        npc.Velocity = Vector.Zero
        mod:spritePlay(sprite, "Death")
        if sprite:IsEventTriggered("Blood") then
            game:SpawnParticles ( npc.Position, 5, 5, math.random(1,5), Color.Default, 10, Game():GetRoom():GetSpawnSeed())
            npc:PlaySound(SoundEffect.SOUND_DEATH_BURST_SMALL, 1, 2, false, 1.5)
        end
        if sprite:IsFinished() then
            npc:Remove()
        end
    end
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, npc, dmg, flags, source)
    if npc.Type == 161 and npc.Variant == mod.Monsters.Roach.Var then
        if AnixbirthSaveManager.GetSettingsSave().accurateRoach == 1 then
            if source.Entity and source.Entity.Type == 1000 and source.Entity.Variant == 29 then
                local str = {"Fun fact:", "Roaches are", "fucking bastards"}
                    for j = 1, 60 do
                    mod.scheduleCallback(function()
                        for k = 1, 3 do
                            local pos = Game():GetRoom():WorldToScreenPosition(npc.Position) + Vector(mod.TempestFont:GetStringWidth(str[k]) * -0.5, -(npc.SpriteScale.Y * 35) - j/3 - 15)
                            local opacity
                            local cap = 45
                            if j >= cap then
                                opacity = 1 - ((j-cap)/30)
                            else
                                opacity = j/cap
                            end
                            --Isaac.RenderText(str, pos.X, pos.Y, 1, 1, 1, opacity)
                            mod.TempestFont:DrawString(str[k], pos.X, pos.Y + (12 * k), KColor(1,1,1,opacity), 0, false)
                        end
                    end, j, ModCallbacks.MC_POST_RENDER)
                end
                return false
            end
            if math.random(2) == 2 then
                npc:SetColor(Color(2,2,2,1,0,0,0),5,2,true,false)
                npc:ToNPC():PlaySound(SoundEffect.SOUND_THUMBS_DOWN, 1, 2, false, 1)
                for i = 1, game:GetNumPlayers() do
                    Isaac.GetPlayer(i):AnimateSad()
                end
                return false
            end
        end
        if npc.HitPoints - dmg <= 0 then
            npc:GetData().state = "dead"
            return false 
        end
    end
end, 161)