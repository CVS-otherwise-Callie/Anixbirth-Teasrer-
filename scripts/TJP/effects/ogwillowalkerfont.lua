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

        if not d.init then
            d.sentlen = 1
            d.init  = true
        end
        d.sent =  [[These \Ywillos \Ware \YPissing \Wme off... waaaaaa\Laaaaaaaaaaaaaaaaaaaah]]

        d.loopcount = 0
        d.charY = 0
        d.charX = 0
        if not ef.Parent then
            ef:Remove()
        else
            ef.Position = ef.Parent.Position
        end
        mod:textEffect(ef, "W")
        ef.Visible = true
        while d.loopcount < d.sentlen do
            d.loopcount = d.loopcount + 1
            d.charX = d.charX + 1
            local letter = string.sub(d.sent,d.loopcount,d.loopcount)
            local ascii = mod:textToAscii(letter)
            if string.sub(d.sent,d.loopcount,d.loopcount) == [[\]] then
                local colour = string.sub(d.sent,d.loopcount + 1,d.loopcount + 1)
                mod:textEffect(ef, colour)
                d.loopcount = d.loopcount + 1
            else
                sprite:SetFrame(ascii)
                sprite:Render(Vector(bcenter.X + (d.charX* 7) - 200, (Isaac.GetScreenHeight() - 45) + (d.charY * 13)), Vector.Zero, Vector.Zero)
            end
        end
        if d.sentlen < #d.sent then
            d.sentlen = d.sentlen + 1
        end
        ef.Visible = false
    end
end)
