local mod = FHAC
local sfx = SFXManager()
local game = Game()

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, effect)
    if effect.Variant == mod.Effects.OGWilloWalkerFont.Var then
        mod:OGWilloWalkerFontAI(effect, effect:GetSprite(), effect:GetData())
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()

    for k, v in ipairs(Isaac.GetRoomEntities()) do
        if v.Type == 1000 and v.Variant == mod.Effects.OGWilloWalkerFont.Var then
            local ef = v
            local sprite = v:GetSprite()
            local d = v:GetData()

            local function textToAsciiNumberConverter(char)
                local ascii = string.byte(char)

                return ascii - 32
            end
            local function changeTextColour(ef, colour)
                if colour == "W" then
                    ef:SetColor(Color.Default, 2, 1, false, false)
                    --return "W (ts in func)"
                end
                if colour == "Y" then
                    ef:SetColor(Color(1,1,0,1), 2, 1, false, false)
                    --return "Y (ts in func)"
                end
            end

            d.sent =  [[Hey \YCVS \Wthis \Ytext \W is a \Yplaceholder]]

            d.loopcount = 0
            ef.Position = Vector(100,100)
            while d.loopcount < #d.sent do
                d.loopcount = d.loopcount + 1
                local letter = string.sub(d.sent,d.loopcount,d.loopcount)
                local ascii = textToAsciiNumberConverter(letter)
                if string.sub(d.sent,d.loopcount,d.loopcount) == [[\]] then
                    local colour = string.sub(d.sent,d.loopcount + 1,d.loopcount + 1)
                    print(changeTextColour(ef, colour))
                    d.loopcount = d.loopcount + 1
                else
                    sprite:SetFrame(ascii)
                    ef:Render(Vector(0,0))
                    ef.Position = ef.Position + Vector(10,0)
                end
            end     
        end
    end
end)

function mod:OGWilloWalkerFontAI(ef, sprite, d)

    if not d.init then
        d.init = true
    end

end
