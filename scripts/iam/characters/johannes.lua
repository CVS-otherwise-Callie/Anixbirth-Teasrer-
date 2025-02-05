local mod = FHAC
local game = Game()
local johannes = FHAC.Players.Johannes
local player = Isaac.GetPlayer()
local rng = RNG()
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
mod.JohRoomSprites = Sprite()
mod.JohRoomSprites:Load("gfx/eid_inline_icons.anm2", true)

function mod:JohannesPostRender()
    if not isplayer then
        return
    end
    local icon = Sprite()
    local timers = {
        60, --treasure
        132, --boss
        47  --shop
    }
    local names = {
        "treasure",
        "boss",
        "shop"
    }
    for k, v in ipairs(timers) do
        local mins, sec
        if v - game.TimeCounter/30 <= 0 then
            mins = 0
            sec = 0
        else
            mins, sec = mod:getMinSec((v + 1) - (game.TimeCounter/30))    
        end
        if sec < 10 then
            sec = 0 .. sec
        end
        local minstring = tostring(mins)
        local secstring = tostring(sec)
        local scale = 1
        local text = names[k] .. ": (" .. minstring .. ": " .. secstring .. ")"
        mod.JohFont:DrawStringScaled(text,60,45 + (k-1) * 12,scale, scale,KColor(1,1,1,1),0,true)
        mod.JohRoomSprites:Play("roomicons")
        mod.JohRoomSprites:Render(Vector(50, 50 + (k-1) * 12), Vector.Zero, Vector.Zero)
    end
    --icon:Play("Idle")
end

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function()
    
end)