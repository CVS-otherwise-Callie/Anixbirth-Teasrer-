local mod = FHAC
local game = Game()
local johannes = Isaac.GetPlayerTypeByName("Johannes")
local player = Isaac.GetPlayer()
local rng = RNG()
local icon = Sprite()
local isplayer

function mod:GiveCostumesOnInit(player)
    if player:GetPlayerType() ~= johannes then
        isplayer = false
        return
    else
    isplayer = true
    player:AddNullCostume(Isaac.GetCostumeIdByPath("gfx/characters/johanneshair.anm2"))
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, mod.GiveCostumesOnInit)


--------------------------------------------------------------------------------------------------
--timer handling
mod.JohFont = Font()
--font:Load("mods/Hope (Teasrer)/resources/font/foursouls.fnt")
mod.JohFont:Load("font/pftempestasevencondensed.fnt")

mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
    if not isplayer then
        return
    end
    local text = ""
    local secs = 60 - math.floor(game.TimeCounter/30)
    local secsstring = tostring(secs)
    local scale = 1
    local size = mod.JohFont:GetStringWidth(text) * scale * 1.1
    if secs > 0 then
        text = secsstring
        mod.JohFont:DrawStringScaled(text,60,45,scale, scale,KColor(1,1,1,1,0,0,0),0,true)
    end

    icon:Load("gfx/characters/johanneshair.anm2", true)
    icon:Render(Vector(0, 0), Vector.Zero, Vector.Zero)
    icon:Play("Idle")
end)