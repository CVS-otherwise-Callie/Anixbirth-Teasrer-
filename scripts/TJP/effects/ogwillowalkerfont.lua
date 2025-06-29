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
            d.letterdelay = 1
            d.timer = 0
            d.sentlen = 1
            d.init  = true
            d.scriptnumber = 1
        else
            d.timer = d.timer + 1
        end

        if not (d.scriptnumber < 0) then
            d.sent =  ef.Parent.Parent:GetData().script[d.scriptnumber]
        end
        d.charY = 0
        d.charX = 0
        if not ef.Parent then
            ef:Remove()
        else
            ef.Position = ef.Parent.Position
        end

        if d.sent then
            if not game:IsPaused() then
                mod:npctalk(ef, d.sent, d.sentlen, d.charX, d.charY)
                if d.sentlen < #d.sent and d.timer > d.letterdelay then
                    d.sentlen = d.sentlen + 1
                    d.timer = 1
                end
                if mod:npctalk(ef, d.sent, d.sentlen, d.charX, d.charY) then
                    ef.Parent.Parent:GetData().isspeaking = false
                end
            end
        else
            ef.Parent:Remove()
            ef:Remove()
            ef.Parent.Parent:GetData().state = "follow"
        end
    end
end)
