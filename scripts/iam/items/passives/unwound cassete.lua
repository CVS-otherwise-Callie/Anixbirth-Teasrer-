local mod = FHAC
local game = Game()

function mod:UnwoundCasseteShot(tear, player, isLudo) --post fire tear

    if not player:HasCollectible(mod.Collectibles.Items.UnwoundCassete) then return end

    local d = tear:GetData()
    local sprite = tear:GetSprite()

    local freq = math.min(math.max(math.floor(22 - player.Luck), 3), 25)

    if not d.PCheck then
        d.trueLuck = math.random(math.max(player.Luck, 20), 30)
        d.PCheck = true
    end

    if (not isLudo and tear.InitSeed % freq == 0) or (isLudo and math.random(freq) == 1) or d.trueLuck==30 then
        d.isCasseteTear = true
        d.oldAnim = sprite:GetAnimation()
        sprite:Load("gfx/tears/cassette.anm2", true)
        sprite:Play(d.oldAnim)
    end

end

function mod:SaveCassetteInfoNPC(npc)

    if not mod:AnyPlayerHasCollectible(mod.Collectibles.Items.UnwoundCassete) then return end

    if npc:GetData().isCasseted then

        npc:AddConfusion(EntityRef(npc), 5, false)

        npc:GetData().LastFrameCount = npc:GetData().LastFrameCount or npc.FrameCount - 5

        if ((npc:GetData().LastFrameCount - (npc.FrameCount - npc:GetData().LastFrameCount)) > (npc:GetData().LastFrameCount+ 200)) or npc:GetData().CassetePositions[npc:GetData().LastFrameCount - (npc.FrameCount - npc:GetData().LastFrameCount)] == nil then
            npc:GetData().isCasseted = false
            npc:ClearEntityFlags(EntityFlag.FLAG_CONFUSION)
            return
        end

        npc.Velocity = mod:Lerp(npc.Velocity, npc:GetData().CassetePositions[npc:GetData().LastFrameCount - (npc.FrameCount - npc:GetData().LastFrameCount)] - npc.Position, 0.1)

    else
        npc:GetData().LastFrameCount = nil
    end

        npc:GetData().CassetePositions = npc:GetData().CassetePositions or {}

        npc:GetData().CassetePositions[npc.FrameCount] = npc.Position

end

function mod:SetCassetteDamage(ent, dmg, flag, source) 
    if source.Type == 2 then
            if ent.Type > 9 and ent:IsActiveEnemy() then
                if source.Entity:GetData().isCasseteTear then
                    ent:GetData().isCasseted = true
                end
            end
    end
end