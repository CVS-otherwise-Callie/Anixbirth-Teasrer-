local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.Onehead.Var and npc.SubType == 1 then
        mod:OneheadAI(npc, npc:GetSprite(), npc:GetData())
	end
end, mod.Monsters.Onehead.ID)

function mod:OneheadAI(npc, sprite, d)
	local target = npc:GetPlayerTarget()
    local distance = target.Position:Distance(npc.Position)

    if not d.init then
        d.shoottimer = math.random(0,4)
        --d.sprite = 1    never again
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
    params.Scale = 0.3
    params.HeightModifier = 10

    if d.state == "shake" then
        --stollen from beeter
        if  (target.Position - npc.Position):Length() < 50 and game:GetRoom():CheckLine(target.Position,npc.Position,3,900,false,false) then   --fucking walls
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
        if sprite:IsEventTriggered("Shoot") then

                npc:FireProjectiles(npc.Position, Vector(1.5,3):Rotated(d.shoottimer*75), 0, params)

                d.shoottimer = d.shoottimer + 1
        end
        if sprite:IsFinished("Attack") then
            if (target.Position - npc.Position):Length() > 50 then
                d.state = "shake"
                npc.StateFrame = 0
                d.wait = 0
            else
                sprite:Play("Attack", true)
            end
        end
    end
end
