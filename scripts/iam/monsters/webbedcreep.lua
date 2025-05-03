local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.WebbedCreep.Var then
        mod:WebbedCreepAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.WebbedCreep.ID)

function mod:WebbedCreepAI(npc, sprite, d)

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
            local projectile = Isaac.Spawn(9, 0, 0, npc.Position, Vector(0,8):Rotated(npc.SpriteRotation), npc):ToProjectile();
            projectile:GetData().isWebbedCreep = true
            projectile:GetData().targ = npc:GetPlayerTarget()
            projectile.FallingAccel = 0.5
            projectile.FallingSpeed = -10
		else
			mod:spritePlay(sprite, "Attack")
		end
	end

end

function mod.webbedCreepProj(v, d)
    if d.isWebbedCreep then

        if not d.init then
            if math.abs(v.Velocity.X) > math.abs(v.Velocity.Y) then
                d.isX = true
            else
                d.isX = false
            end
            d.init = true
        end

        if d.isX then
            v.Velocity = mod:Lerp(v.Velocity, Vector((d.targ.Position - v.Position):Resized(10).X, 0), 0.1)
        else
            v.Velocity = mod:Lerp(v.Velocity, Vector(0, (d.targ.Position - v.Position):Resized(10).Y), 0.1)
        end

        local sprite = v:GetSprite()

        sprite:Load("gfx/projectiles/webbedcreepshot.anm2", true)
        sprite:LoadGraphics()
        sprite:Update()

        sprite:Play(sprite:GetDefaultAnimationName(), true)

        if v.Height > -2 then
            local nutsack = Isaac.Spawn(mod.Monsters.SmallSack.ID, mod.Monsters.SmallSack.Var, 1, v.Position, v.Velocity, v)
            nutsack:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
            nutsack:GetData().state = "appear"
            v:Remove()
        end
    end
end

