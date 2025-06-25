local mod = FHAC
local sfx = SFXManager()
local game = Game()
local room = game:GetRoom()

mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()

	local center = StageAPI.GetScreenCenterPosition()
	local bottomright = StageAPI.GetScreenBottomRight()
	local bcenter = Vector(center.X, bottomright.Y - 300)

    if #Isaac.FindByType(mod.Effects.OGWilloWalkerFont.ID, mod.Effects.OGWilloWalkerFont.Var) ~= 0 then
        local tab = Isaac.FindByType(mod.Effects.OGWilloWalkerFont.ID, mod.Effects.OGWilloWalkerFont.Var)
        local ef = tab[#tab]
        if #tab > 1 then -- no overflows
            for i = 1, #tab - 1 do
                tab[i]:Remove()
            end
        end

        local sprite = ef:GetSprite()
        local d = ef:GetData()

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

        d.sent =  [[These \Ywillos \Ware \YPissing \Wme off...]]

        d.loopcount = 0
        if not ef.Parent then
            ef:Remove()
        else
            ef.Position = ef.Parent.Position
        end
        changeTextColour(ef, "W")
        ef.Visible = true
        while d.loopcount < #d.sent do
            d.loopcount = d.loopcount + 1
            local letter = string.sub(d.sent,d.loopcount,d.loopcount)
            local ascii = textToAsciiNumberConverter(letter)
            if string.sub(d.sent,d.loopcount,d.loopcount) == [[\]] then
                local colour = string.sub(d.sent,d.loopcount + 1,d.loopcount + 1)
                changeTextColour(ef, colour)
                d.loopcount = d.loopcount + 1
            else
                sprite:SetFrame(ascii)
                sprite:Render(Vector(bcenter.X + (d.loopcount * 8) - 200, Isaac.GetScreenHeight() - 35), Vector.Zero, Vector.Zero)
            end
        end
        ef.Visible = false
    end
end)
