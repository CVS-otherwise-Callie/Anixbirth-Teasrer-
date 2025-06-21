local mod = FHAC
local game = Game()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.NPCS.WilloWalker.Var then
        mod:WilloWalkerNPC(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.NPCS.WilloWalker.ID)

mod:AddCallback(ModCallbacks.MC_PRE_NPC_COLLISION, function(_, npc, coll)
    if npc.Variant == mod.NPCS.WilloWalker.Var then
        mod:WilloWalkerNPCColl(npc, npc:GetSprite(), npc:GetData(), coll)
    end
end, mod.NPCS.WilloWalker.ID)

mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, function(_, npc)
    if npc.Variant == mod.NPCS.WilloWalker.Var then
        npc:GetData().isDialouging = false
    end
end, mod.NPCS.WilloWalker.ID)

function mod:WilloWalkerNPC(npc, sprite, d)

    npc.CanShutDoors = false

    if not d.init then
        mod:spritePlay(sprite, "bounc1")
        d.init = true
    end

    mod:SaveEntToRoom(npc, false)

end

function mod:WilloWalkerNPCColl(npc, sprite, d, coll)

    if coll.Type ~= 1 then return end

    if not d.init then return end

    if d.isDialouging then return end

    d.isDialouging = true
    sprite:Play("bounc2", true)
    npc:PlaySound(SoundEffect.SOUND_THUMBSUP, 1, 2, false, 1)

    for j = 1, 300 do
        local str = "i'm the"
        mod.scheduleCallback(function()

            if not npc then return end

                local pos = Game():GetRoom():WorldToScreenPosition(npc.Position) + Vector(mod.TempestFont:GetStringWidth(str) * -0.5, -(npc.SpriteScale.Y * 35) - j/3 - 15)
                local opacity
                local cap = 100
                if j >= cap then
                    opacity = 1 - ((j-cap)/100)
                else
                    opacity = j/cap
                end
                --Isaac.RenderText(str, pos.X, pos.Y, 1, 1, 1, opacity)
                mod.TempestFont:DrawString(str, pos.X, pos.Y + (12), KColor(1,1,1,opacity), 0, false)
        end, j, ModCallbacks.MC_POST_RENDER, false)
    end

    for j = 1, 400 do
        local str = "original"
        mod.scheduleCallback(function()

            if j < 100 then return end

                        if not npc then return end


                j = j - 99

                local pos = Game():GetRoom():WorldToScreenPosition(npc.Position) + Vector(mod.TempestFont:GetStringWidth(str) * -0.5, -(npc.SpriteScale.Y * 35) - j/3 - 15)
                local opacity
                local cap = 99
                if j >= cap then
                    opacity = 1 - ((j-cap)/99)
                else
                    opacity = j/cap
                end
                --Isaac.RenderText(str, pos.X, pos.Y, 1, 1, 1, opacity)
                mod.TempestFont:DrawString(str, pos.X, pos.Y + (12), KColor(1,1,1,opacity), 0, false)
        end, j, ModCallbacks.MC_POST_RENDER, false)
    end

for j = 1, 1000 do
        local str = "willowalker"
        mod.scheduleCallback(function()

            if j < 300 then return end

                    if not npc then return end



                j = j - 299

                local pos = Game():GetRoom():WorldToScreenPosition(npc.Position) + Vector(mod.TempestFont:GetStringWidth(str) * -0.5, -(npc.SpriteScale.Y * 35) - j/3 - 15)
                local opacity
                local cap = 500
                if j >= cap then
                    opacity = 1 - ((j-cap)/500)
                else
                    opacity = j/cap
                end
                --Isaac.RenderText(str, pos.X, pos.Y, 1, 1, 1, opacity)
                mod.TempestFont:DrawString(str, pos.X, pos.Y + (12), KColor(1,1,0,opacity), 0, false)

                if j == 300 then d.isDialouging = false end
        end, j, ModCallbacks.MC_POST_RENDER, false)
    end


end