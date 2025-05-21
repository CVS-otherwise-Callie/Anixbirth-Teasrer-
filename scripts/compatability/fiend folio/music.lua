if FiendFolio then

    FiendFolio:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function(_, player)
        local data = player:GetData()
        if player:IsDead() and player:GetPlayerType() == Isaac.GetPlayerTypeByName("Peat") then
            if not data.checkedofrPeatMusic then
                if math.random(1) == 1 then -----mmmmmm whatecver
                    FiendFolio.scheduleForUpdate(function()
                        local ms = MusicManager()
                        if ms:GetCurrentMusicID() == Music.MUSIC_JINGLE_GAME_OVER then
                            ms:Play(Isaac.GetMusicIdByName("petermation"), 0)
                            ms:UpdateVolume()
                        end
                    end, 120, ModCallbacks.MC_POST_RENDER)
                end
                data.checkedofrPeatMusic = true
            end
        elseif data.checkedofrPeatMusic then
            data.checkedofrPeatMusic = false
        end
    end)

    --fittingly, i this is fiend folio code you are looking at!

end