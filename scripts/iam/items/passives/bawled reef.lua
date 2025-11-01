local mod = FHAC
local game = Game()
local ms = MusicManager()

function mod:BawledReefPlayerAI(player)

    local d = AnixbirthSaveManager.GetRunSave(player).anixbirthsaveData

    if player:HasCollectible(mod.Collectibles.Items.BawledReef) then

        d.coralWait = d.coralWait or 0

        local exRot = math.random(1, 360)

        if player:GetMovementInput():Length() > 0.2 or player:GetShootingInput():Length() > 0.1 then
            d.coralWait = 0

            if d.coralStateShell == true then

                player:UpdateCanShoot()

                for i = 1, 3 do
                    local direction = (i)*120 + exRot
                    local ef = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DUST_CLOUD, -1, player.Position + Vector(0, -10), Vector(5, 0):Rotated(direction), player):ToEffect()
                    ef:SetTimeout(10)
                    ef.SpriteScale = Vector(0.03,0.03)
                    ef:Update()
                end

                for i = 1, math.random(3, 5) do
                    local direction = math.random(1, 360)
                    local coralshard = Isaac.Spawn(2, mod.Tears.CoralShardTear.Var, 0, player.Position + Vector(3, 0):Rotated(direction), Vector(10, 0):Rotated(direction), player)
                    coralshard:GetData().isCoralShard = true
                end

                player:TryRemoveNullCostume(mod.Collectibles.Null.ID_CORALSTATUE)

                d.coralStateShell = false
            end
        else
            d.coralWait = d.coralWait + 1
        end

        if d.coralWait > 100 then
            if not d.coralStateShell then
                Isaac.Spawn(1000, 15, 0, player.Position, Vector.Zero, nil)
                for i = 1, 3 do
                    local direction = (i)*120 + exRot
                    local ef = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DUST_CLOUD, -1, player.Position + Vector(0, -10), Vector(5, 0):Rotated(direction), player):ToEffect()
                    ef:SetTimeout(10)
                    ef.SpriteScale = Vector(0.03,0.03)
                    ef:Update()
                end
            end
            d.coralStateShell = true
        end
    end

    if d.coralStateShell then
        player:AddNullCostume(mod.Collectibles.Null.ID_CORALSTATUE)
        local challenge = game.Challenge
        game.Challenge = 6
        player:UpdateCanShoot()
        game.Challenge = challenge
    end

end

function mod:PlayerCoralCheck(player)
    if player:ToPlayer() and player:ToPlayer():HasCollectible(mod.Collectibles.Items.BawledReef) then
        local d = AnixbirthSaveManager.GetRunSave(player).anixbirthsaveData

        if d.coralStateShell then
            return false
        end
    end
end