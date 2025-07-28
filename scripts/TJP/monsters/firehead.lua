local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.Firehead.Var and npc.SubType == 0 then
        mod:FireheadAI(npc, npc:GetSprite(), npc:GetData())
	end
end, mod.Monsters.Firehead.ID)

function mod:FireheadAI(npc, sprite, d)

	local target = npc:GetPlayerTarget()
    local targetpos = mod:confusePos(npc, target.Position, 5, nil, nil)
    local distance = target.Position:Distance(npc.Position)

    if not d.init then
        d.rngshoot = Vector(100, 100):GetAngleDegrees() 
        d.state = "shake"
        d.wait = 1
        d.flip = 0
        sprite:Play(sprite:GetDefaultAnimation())
        d.init = true
    elseif d.init then
        npc.StateFrame = npc.StateFrame + 1
    end

    local params = ProjectileParams()
    params.FallingAccelModifier = 0.4
    params.Scale = 1

    if d.state == "shake" then
        if (target.Position - npc.Position):Length() < 100 and game:GetRoom():CheckLine(target.Position,npc.Position,3,900,false,false) then   --fucking walls
            sprite:Play("AttackStart", true)
            d.state = "attackstart"
        else
            if not sprite:IsFinished("Shake") then
            sprite:Play("Shake")
            end
        end
        if target.Position.X < npc.Position.X then --future me pls don't fuck this up
            sprite.FlipX = true
        else
            sprite.FlipX = false
        end
    end

    if d.state == "attackstart" and sprite:GetFrame("AttackStart") == 3 then
        sprite:Play("Attack", true)
        d.state = "attack"
    end
    if d.state == "attack" then
        mod:spritePlay(sprite, "Attack")
        if sprite:IsEventTriggered("Shoot") then
            for i = 0, 4 do
                FHAC:ShootFire(npc.Position, Vector(2.7,10):Rotated((72*i+d.rngshoot)))
            end
            d.rngshoot = d.rngshoot + 30
        end
        if (target.Position - npc.Position):Length() > 130 then
            d.state = "shake"
            npc.StateFrame = 0
            d.wait = 0
        end

    end
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, npc, damage, flags, guy)
    if npc.Type == 161 and npc.Variant == mod.Monsters.Firehead.Var and flags == flags | DamageFlag.DAMAGE_FIRE then
        return false
    end
end)