local mod = FHAC
local game = Game()
local rng = RNG()
local itemConfig = Isaac.GetItemConfig()


mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	for i = 1, game:GetNumPlayers() do
		local player = Isaac.GetPlayer(i)
		rng:SetSeed(game:GetRoom():GetAwardSeed(), 32) --not particularly correlated but makes my job easy
		if rng:RandomInt(15) == 15 and player:HasCollectible(mod.Collectibles.Items.GrosMichel) then
            local itemcon = itemConfig:GetCollectible(mod.Collectibles.Items.GrosMichel)
			player:RemoveCollectible(mod.Collectibles.Items.GrosMichel)
            local num = 0
            for j = 1, 300 do
                mod.scheduleCallback(function()
                    local sprite = Sprite()

                    num = num + 1

                    sprite:Load("gfx/items/collectible.anm2", true)
                    sprite:Play(sprite:GetDefaultAnimationName(), true)
                    sprite:ReplaceSpritesheet(1, itemcon.GfxFileName)

                    sprite.Color = Color(1, 1, 1, (50 - j)/50)

                    sprite:LoadGraphics()

                    sprite:Render(Isaac.WorldToScreen(player.Position + Vector(0, num*-1)))

                end, j, ModCallbacks.MC_POST_RENDER)
            end
            for j = 1, 900 do
                local str = "[extinct]"
                mod.scheduleCallback(function()

                    if j < 300 then return end

                    if not player then return end

                    local pos = Game():GetRoom():WorldToScreenPosition(player.Position) + Vector(mod.TempestFont:GetStringWidth(str) * -0.5, -(player.SpriteScale.Y * 35) - j/3 - 15)
                    local opacity
                    local cap = 300
                    if j >= cap then
                        opacity = 1 - ((j-cap)/300)
                    else
                        opacity = j/cap
                    end
                    --Isaac.RenderText(str, pos.X, pos.Y, 1, 1, 1, opacity)
                    mod.TempestFont:DrawString(str, pos.X, pos.Y + (12), KColor(1,1,1,opacity), 0, false)
                end, j, ModCallbacks.MC_POST_RENDER, false)
            end
		end
	end
end)	

function mod:EvaluateCache(player, cacheFlags)
    if cacheFlags & CacheFlag.CACHE_DAMAGE == CacheFlag.CACHE_DAMAGE then
        if player:HasCollectible(mod.Collectibles.Items.GrosMichel) then
        	player.Damage = player.Damage * 2
        end
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.EvaluateCache)
