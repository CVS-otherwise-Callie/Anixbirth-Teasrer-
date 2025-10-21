local mod = FHAC
local game = Game()
local rng = RNG()
local sfx = SFXManager()
local ms = MusicManager()

local times = {
    [2] = 10,
    [3] = 14,
    [4] = 10,
    [5] = 17,
    [6] = 15, 
    [7] = 17, 
    [8] = 15,
    [9] = 15,
    [10] = 31,
    [11] = 8
}

local enemyStats = {
    state = "idle"
}

function mod:MusicBoxAI(npc, sprite, d)

    npc:MultiplyFriction(0.1)

    if not d.init then
        for name, stat in pairs(enemyStats) do
            d[name] = d[name] or stat
        end
        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    mod.MusicBoxOldSoundOp = mod.MusicBoxOldSoundOp or Options.MusicVolume

    AnixbirthSaveManager.GetPersistentSave().anixbirthMusicBoxProgression = AnixbirthSaveManager.GetPersistentSave().anixbirthMusicBoxProgression or 1

    local s = AnixbirthSaveManager.GetPersistentSave().anixbirthMusicBoxProgression

    if s >= 11 and not d.init then
        npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        npc:Remove()
        return
    end

    d.init = true

    if d.state == "play" then

        if not d.finishOpen and not sprite:IsPlaying("Open") then
            mod:spritePlay(sprite, "Open")
            sfx:Play(mod.Sounds.MusicBoxOpen, 1, 2, false, 1)
        elseif d.finishOpen then
            d.timer = d.timer or game.TimeCounter

            if not sprite:IsPlaying("Play") then
                AnixbirthSaveManager.GetPersistentSave().anixbirthMusicBoxProgression = AnixbirthSaveManager.GetPersistentSave().anixbirthMusicBoxProgression + 1
                mod:spritePlay(sprite, "Play")
                ms:Crossfade(Isaac.GetMusicIdByName("MusicBox" .. tostring(tonumber(s)+1)), 0.08)
            end

            if s > 1 and (game.TimeCounter - d.timer) > (times[s]*30) then
            	Isaac.Explode(npc.Position, npc, 10)
                npc:Remove()
            end
        end
    end

    if sprite:IsFinished("Open") then
        d.finishOpen = true
    end

end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, p)
    for _, i in ipairs(Isaac.FindByType(mod.Monsters.MusicBox.ID,mod.Monsters.MusicBox.Var)) do
        if i.Position:DistanceSquared(p.Position) <= (i.Size + p.Size) ^ 2 then
            i:GetData().state = "play"
        end
    end	
end)