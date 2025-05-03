local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.StallCreep.Var then
        mod:StallCreepAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.StallCreep.ID)

function mod:StallCreepAI(npc, sprite, d)


    if not d.init then
		d.state = "idle"
		d.init = true
		npc.StateFrame = 60
	end

	if d.state == "idle" then
		if npc.State == 8 then
			d.state = "attackstart"
			npc.State = 5
		else
			npc.State = 4
		end
	elseif d.state == "attackstart" then
		if sprite:IsFinished("Attack") then
			d.state = "idle"
			npc.StateFrame = 15
		elseif sprite:IsEventTriggered("Shoot") then
			npc:PlaySound(SoundEffect.SOUND_BLOODSHOOT,1,2,false,math.random(9,11)/10)
            for i = 1, 3 do
                local projectile = Isaac.Spawn(9, 0, 0, npc.Position + Vector(-50 + (25*i), 0):Rotated(npc.SpriteRotation), Vector(0,8):Rotated(npc.SpriteRotation), npc):ToProjectile();
				projectile.FallingAccel = -0.01
				projectile.FallingSpeed = -0.01
            end
		else
			mod:spritePlay(sprite, "Attack")
		end
	end

end

