local cmds = {
    trueDebug10 = {
        Func = function(params) --this irks me i hate it
            if not FHAC.trueDebug10On then
                FHAC.trueDebug10On = true
            else
                FHAC.trueDebug10On = false
            end
        end,
        Desc = "Actually kills everything"
    },
    spriteDebug = {
        Func = function(params)
            if not FHAC.spriteDebugOn then
                FHAC.spriteDebugOn = true
            else
                FHAC.spriteDebugOn = false
            end
        end,
        Desc = "Shows enemy animations, frames, etc"
    },
}


for command, funcs in pairs(cmds) do

    local autocompleteType = AutocompleteType.NONE --stageapi if you snooze you lose (i choose to lose)
    if type(funcs.Autocomplete) == "function" then
        autocompleteType = AutocompleteType.CUSTOM
    elseif funcs.Autocomplete then
        autocompleteType = funcs.Autocomplete
    end

    local help = funcs.Desc .. "\n" .. "Usage: " .. command

    Console.RegisterCommand(command, funcs.Desc, help, true, autocompleteType)
end

FHAC:AddCallback(ModCallbacks.MC_EXECUTE_CMD, function(_, cmd, params)
    params = tostring(params)

    --local aliasTable = GetAliasTable()
    local commandData = cmds[cmd] --reminds me later to make aliases

    if commandData then
        return commandData.Func(params)
    end

    -- secret dev stuff

    if cmd == "dssDeveloperMode" then
        if not FHAC.fhacDSSDeveloperMode then
            FHAC.fhacDSSDeveloperMode = true
        else
            FHAC.fhacDSSDeveloperMode = false
        end 
    end
    
end)

FHAC:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, function(_, npc)
    if not FHAC.spriteDebugOn then return end

    if npc.Type == 33 then return end

    local sprite = npc:GetSprite()

    local strs = {}

    if sprite:GetOverlayFrame() ~= -1 then
        strs = {
            "Animation: " .. tostring(npc:GetSprite():GetAnimation()) .. "Overlay Animation: " .. tostring(sprite:GetOverlayAnimation()),
            "Default Animation: " .. tostring(sprite:GetDefaultAnimation()),
            "Filename: " .. tostring(sprite:GetFilename()),
            "Frame: " .. tostring(sprite:GetFrame()) ..         "Overlay Frame: " .. tostring(sprite:GetOverlayFrame()),
            "Layer Count: " .. tostring(sprite:GetLayerCount()),
            "Playback Speed: " .. sprite.PlaybackSpeed
        }
    else
        strs = {
            "Animation: " .. tostring(npc:GetSprite():GetAnimation()),
            "Default Animation: " .. tostring(sprite:GetDefaultAnimation()),
            "Filename: " .. tostring(sprite:GetFilename()),
            "Frame: " .. tostring(sprite:GetFrame()),
            "Layer Count: " .. tostring(sprite:GetLayerCount()),
            "Playback Speed: " .. sprite.PlaybackSpeed
        }
    end

    for i = 1, #strs do
        local str = strs[i]
        local pos = Game():GetRoom():WorldToScreenPosition(npc.Position) + Vector(FHAC.TempestFont:GetStringWidth(str) * -0.5, (npc.SpriteScale.Y * (i*9)))
        FHAC.TempestFont:DrawString(str, pos.X, pos.Y, KColor(1,1,1,1), 0, false)
    end
end)

FHAC:AddCallback(ModCallbacks.MC_POST_RENDER, function()
    if FHAC.trueDebug10On then
            for _, v in ipairs(Isaac.GetRoomEntities()) do
                if v.Type ~= 1 then
                    v:Kill()
                end
                if v.Type == 5 or v.Type == 6 or v.Type == 3 then
                    v:Remove()
                end
            end
    end
end)
