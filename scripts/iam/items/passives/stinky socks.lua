local mod = FHAC
local game = Game()

function mod:AddStinkySocksSpeed(player)
    local itemCount = player:GetCollectibleNum(mod.Collectibles.Items.StinkySocks)

    player.MoveSpeed = player.MoveSpeed + (0.1*itemCount)
end

function mod:StinkySocksPoisonCloud(player)

    if player:HasCollectible(mod.Collectibles.Items.StinkySocks) then

        local d = AnixbirthSaveManager.GetRunSave(player).anixbirthsaveData
        local size = 100
        local damage = 0.01
        local time = 10

        if not d.stinkySocksTimerDat then d.stinkySocksTimerDat = 0 end
        if not d.stinkySocksTimerDatTwo then d.stinkySocksTimerDatTwo = 0 end

        if player.Velocity:Length() < 0.5 then
            d.stinkySocksTimerDat = d.stinkySocksTimerDat + 1

            if d.stinkySocksTimerDat > 50 then
                size = d.stinkySocksTimerDat
            end
            d.stinkySocksTimerDatTwo = 0
        else
            size = d.stinkySocksTimerDat

            time = math.ceil(5+(d.stinkySocksTimerDatTwo/2))
            if time > 10 then
                time = 10
            end
            d.stinkySocksTimerDatTwo = d.stinkySocksTimerDatTwo + 0.1
            if d.stinkySocksTimerDat > 0 then
                d.stinkySocksTimerDat = d.stinkySocksTimerDat - d.stinkySocksTimerDatTwo
            end
        end
    
        if game.TimeCounter%time == 0 then

            local cloud = Isaac.Spawn(1000, 141, 0, player.Position + player.Velocity:Normalized() * 2 + Vector(0, 5), Vector.Zero, player):ToEffect()
            cloud:SetTimeout(50)
            cloud:GetSprite().Scale = Vector(((size*2)+800)/1000, ((size*2)+800)/1000)
            cloud.Scale = math.ceil(d.stinkySocksTimerDat/100)
            cloud.CollisionDamage = ((player.Damage/25)*(size/600))+damage
            cloud:GetSprite():Update()
            cloud:Update()
        end

    end

end