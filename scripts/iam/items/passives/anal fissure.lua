local mod = FHAC
local game = Game()

function mod:AnalFissure(player)
    if not player:HasCollectible(mod.Collectibles.Items.AnalFissure) then return end
    local d = player:GetData()
    local sprite = player:GetSprite()
    local room = game:GetRoom()
    local creep = EffectVariant.CREEP_SLIPPERY_BROWN
    local time = 5 + math.random(-3, 3)
    local size = 0.5
    local damage = 0.3
    local timeout = 60
    local finalcountdown = 137

    if game.TimeCounter%finalcountdown == 0 then
        d.AnalFissureCreep = true
    end

    if room:IsClear() then
        timeout = 500
    elseif not d.AnalFissureCreep then
        creep = EffectVariant.PLAYER_CREEP_RED
        time = 13 + math.random(-3, 3)
        size = 0.5
        damage = 0.1
    elseif d.AnalFissureCreep then
        if not d.AnalFissureCreepInit then
            player:AddCostume(Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_IPECAC), true)
            d.AnalFissureCreepPools = d.AnalFissureCreepPools or 0
            d.AnalFissureCreepInit = true
        end
        creep = EffectVariant.PLAYER_CREEP_GREEN
        time = 12 + math.random(-3, 3)
        size = 0.7
        damage = 1.5
    end

    if game.TimeCounter%time ~= 0 then return end

    print(game.TimeCounter%time*7)

    if game.TimeCounter%(time*7) == 0 then
        local pool = Isaac.Spawn(EntityType.ENTITY_EFFECT, creep, -1, player.Position + Vector(math.random(-5, 5), math.random(-5, 5)), Vector.Zero, player):ToEffect()
        pool:SetTimeout(timeout)
        pool.Scale = size*3
        pool.CollisionDamage = player.Damage*damage
        pool:Update()

        if d.AnalFissureCreep then
            d.AnalFissureCreepPools = d.AnalFissureCreepPools+1
            sprite.Color:SetColorize(1, 1, 1, 1, 0.5, 0, 0)
        end
    else
        local realcreep = Isaac.Spawn(EntityType.ENTITY_EFFECT, creep, -1, player.Position + Vector(math.random(-5, 5), math.random(-5, 5)), Vector.Zero, player):ToEffect()
        realcreep:SetTimeout(timeout)
        realcreep.Scale = size
        realcreep.CollisionDamage = player.Damage*damage
        realcreep:Update()
    end

    if d.AnalFissureCreepPools and d.AnalFissureCreepPools > 5 then
        player:Kill()
    end
end