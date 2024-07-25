local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.Fivehead.Var then
        mod:FiveheadAI(npc, npc:GetSprite(), npc:GetData())
	end
end, mod.Monsters.Fivehead.ID)

function mod:FiveheadAI(npc, sprite, d)
	local target = npc:GetPlayerTarget()
    local distance = target.Position:Distance(npc.Position)
    
    if not d.init then
        d.rngshoot = RandomVector():GetAngleDegrees() 
        --d.sprite = 1    never again
        d.state = "shake"
        d.wait = 1
        d.flip = 0
        sprite:Play(sprite:GetDefaultAnimation())
        d.init = true
    elseif d.init then
        npc.StateFrame = npc.StateFrame + 1
    end

    
    if target.Position.X < npc.Position.X then --future me pls don't fuck this up
		sprite.FlipX = true
	else
		sprite.FlipX = false
	end

    local params = ProjectileParams()
    params.FallingAccelModifier = 0.5
    params.Scale = 1

    if d.state == "shake" then
        --stollen from beeter
        if  (target.Position - npc.Position):Length() < 90 and game:GetRoom():CheckLine(target.Position,npc.Position,3,900,false,false) then   --fucking walls
            sprite:Play("AttackStart", true)
            d.state = "attackstart"
        else
            if not sprite:IsFinished("Shake") then
            sprite:Play("Shake")
            end
        end
    end

    if d.state == "attackstart" and sprite:GetFrame("AttackStart") == 3 then
        sprite:Play("Attack", true)
        d.state = "attack"
    end

    if d.state == "attack" then
        if sprite:IsEventTriggered("Shoot") then
            if d.wait == 1 then
             for i = 0, 4 do
            npc:FireProjectiles(npc.Position, Vector(2.7,5):Rotated((75*i+d.rngshoot)), 0, params)
             end
            d.rngshoot = d.rngshoot + 30
            d.wait = d.wait + 1
            else
             d.wait = 1
          end
        end
        if sprite:IsFinished("Attack") then
            if (target.Position - npc.Position):Length() > 90 then
                d.state = "shake"
                npc.StateFrame = 0
                d.wait = 0
            else
                sprite:Play("Attack", true)
            end
        end
end
end