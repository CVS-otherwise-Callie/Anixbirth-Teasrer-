local mod = FHAC
local game = Game()

function mod:StrawDollPassive(player)
    player = player:ToPlayer()
    for k, v in ipairs(Isaac.GetRoomEntities()) do
        if v:IsActiveEnemy() then
            v:TakeDamage(5+(0.03*player:GetTotalDamageTaken())+(0.5*player.Damage), 0, EntityRef(player), 3)
        end
    end
end

function mod:StrawDollActive()
    mod.StrawDollActiveIsActive = true
end

function mod:StrawDollActiveEffect(npc, damage, flag, countdown)
    if mod.StrawDollActiveIsActive == true and not npc:GetData().isStrawDollDamage then
        npc:GetData().isStrawDollDamage = true
        for k, v in ipairs(Isaac.GetRoomEntities()) do
            if v:IsActiveEnemy() and v:IsVulnerableEnemy() then
                v:GetData().isStrawDollDamage = true
                v:TakeDamage(damage, flag, EntityRef(Isaac.GetPlayer()), countdown)
            end
            v:GetData().isStrawDollDamage = false
        end
        npc:GetData().isStrawDollDamage = false
    end
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.StrawDollActive, mod.Collectibles.Items.StrawDoll)