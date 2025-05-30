local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.Onedead.Var and npc.SubType == 1 then
        mod:OnedeadAI(npc, npc:GetSprite(), npc:GetData())
	end
end, mod.Monsters.Onedead.ID)

function mod:OnedeadAI(npc, sprite, d)
	local target = npc:GetPlayerTarget()
    local distance = target.Position:Distance(npc.Position)

    if not d.init then
        d.rngshoot = Vector(100, 100):GetAngleDegrees() 
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
    end

    if d.state == "attackstart" and sprite:GetFrame("AttackStart") == 3 then
        sprite:Play("Attack", true)
        d.state = "attack"
    end

    if d.state == "attack" then
        if sprite:IsEventTriggered("Shoot") then
            if d.wait == 1 then

                Isaac.Spawn(853, 0, 0, npc.Position, Vector(10,15), npc)

                d.rngshoot = d.rngshoot + 1
                d.wait = d.wait + 1
            else
                d.wait = 1
            end
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
