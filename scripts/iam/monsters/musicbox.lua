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
    [7] = 14, 
    [8] = 14,
    [9] = 15,
    [10] = 31,
    [11] = 8
}

local enemyStats = {
    state = "play"
}

function mod:MusicBoxAI(npc, sprite, d)

    if not d.init then
        for name, stat in pairs(enemyStats) do
            d[name] = d[name] or stat
        end
        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    mod.MusicBoxOldSoundOp = mod.MusicBoxOldSoundOp or Options.MusicVolume

    Options.MusicVolume = 1.0

    AnixbirthSaveManager.GetPersistentSave().anixbirthMusicBoxProgression = AnixbirthSaveManager.GetPersistentSave().anixbirthMusicBoxProgression or 1

    local s = AnixbirthSaveManager.GetPersistentSave().anixbirthMusicBoxProgression

    if s >= 11 then
        npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        npc:Remove()
        Isaac.DebugString("hihihihihihi")
        return
    end

    if d.state == "play" then

        if not d.finishOpen and not sprite:IsPlaying("Open") then
            mod:spritePlay(sprite, "Open")
            sfx:Play(mod.Sounds.MusicBoxOpen, 1, 2, false, 1)
        elseif d.finishOpen then
            d.timer = d.timer or game.TimeCounter

            if not sprite:IsPlaying("Play") then
                AnixbirthSaveManager.GetPersistentSave().anixbirthMusicBoxProgression = AnixbirthSaveManager.GetPersistentSave().anixbirthMusicBoxProgression + 1
                mod:spritePlay(sprite, "Play")
                ms:Play(Isaac.GetMusicIdByName("MusicBox" .. tostring(tonumber(s)+1)), 0)
            end

            if s > 1 and (game.TimeCounter - d.timer) > (times[s]*30) then
            	Isaac.Explode(npc.Position, npc, 10)
                npc:Remove()
                Options.MusicVolume = mod.MusicBoxOldSoundOp
            end
        end
    end

    if sprite:IsFinished("Open") then
        d.finishOpen = true
    end

end

function mod.MusicBoxAICOllect(player, pickup)
    local sprite = pickup:GetSprite()
    if sprite:WasEventTriggered("DropSound") or sprite:IsPlaying("Idle") then
        pickup.Touched = true
        pickup:GetData().state = "play"
    end
end

