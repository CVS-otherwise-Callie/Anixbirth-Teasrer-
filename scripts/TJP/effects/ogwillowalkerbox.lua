local mod = FHAC
local sfx = SFXManager()
local game = Game()

mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()

	local center = StageAPI.GetScreenCenterPosition()
	local bottomright = StageAPI.GetScreenBottomRight()
	local bcenter = Vector(center.X, bottomright.Y - 300)

    if #Isaac.FindByType(mod.Effects.OGWilloWalkerBox.ID, mod.Effects.OGWilloWalkerBox.Var) ~= 0 then
        local tab = Isaac.FindByType(mod.Effects.OGWilloWalkerBox.ID, mod.Effects.OGWilloWalkerBox.Var)
        local ef = tab[#tab]
        if #tab > 1 then -- no overflows
            for i = 1, #tab - 1 do
                tab[i]:Remove()
            end
        end

        ef.Position = Vector(bcenter.X, Isaac.GetScreenHeight() - 35)

        ef.Visible = false

        local sprite = ef:GetSprite()
        local d = ef:GetData()

        sprite:Render(Vector(bcenter.X, Isaac.GetScreenHeight() - 35), Vector.Zero, Vector.Zero)

        if not ef.Child then
            d.font = Isaac.Spawn(1000, 430, 55, ef.Position, ef.Velocity, ef):ToEffect() --Isaac.ScreenToWorld(Vector(Isaac.GetScreenWidth(), (Isaac.GetScreenHeight()*2)-70))
            d.font.Parent = ef
            ef.Child = d.font
            d.font = ef.Child:GetData()
        end
        ef.DepthOffset = 500
    end
end)