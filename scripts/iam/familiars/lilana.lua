local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, fam)
    mod:LilAnaAI(fam, fam:GetSprite(), fam:GetData())
end, mod.Familiars.LilAna.Var)

function mod:LilAnaAI(fam, sprite, d)

	local player = fam.Player
	local path = fam:GetPathFinder()
	local room = game:GetRoom()

    if not d.init then
		d.stateframe = 0
		d.animation = "Move"
		d.state = "chase"
		d.XP = 1

        d.init = true
    else
        d.stateframe = d.stateframe + 1
    end

	if #Isaac.FindInRadius(fam.Position, 120, EntityPartition.ENEMY) ~= 0 then
		local targ = Isaac.FindInRadius(fam.Position, 120, EntityPartition.ENEMY)[math.random(1, #Isaac.FindInRadius(fam.Position, 120, EntityPartition.ENEMY))]

		if targ:IsActiveEnemy() and targ:IsVulnerableEnemy() and not targ:IsDead()
			and not targ:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
			d.targ = d.targ or targ
		end
	end

	if not d.targ or not d.targ:Exists() or d.targ:IsDead() then
		d.targ = nil
	end

	fam.GridCollisionClass = 5

	if d.state == "chase" then
		if not d.targ then

			d.animation = "Move"

			if not player:GetData().lilAnaNewPlace then
				if fam.Position:Distance(player.Position) > 100 then
					if mod:isScare(fam) then
						local targetvelocity = (player.Position - fam.Position):Resized(-9)
						fam.Velocity = mod:Lerp(fam.Velocity, targetvelocity, 0.5)
					elseif room:CheckLine(fam.Position,player.Position,0,1,false,false) then
						local targetvelocity = (player.Position - fam.Position):Resized(9)
						fam.Velocity = mod:Lerp(fam.Velocity, targetvelocity, 0.5)
					else
						path:FindGridPath(player.Position, 0.85, 1, true)
					end

					if player.Position.X < fam.Position.X then --future me pls don't fuck this up
						sprite.FlipX = true
					else
						sprite.FlipX = false
					end
				elseif fam.Position:Distance(player.Position) < 80 then
					fam:MultiplyFriction(0.8)
				end
			else

				d.animation = "Attack"

				local num = player:GetFireDirection()
				if num ~= -1 then
					d.num = num
				end
				local targetpos = fam.Position + Vector(-10, 0):Rotated(90*d.num)

				if (fam.Position:Distance(player.Position) < 100 or #Isaac.FindInRadius(fam.Position, 200, EntityPartition.ENEMY) ~= 0) and not fam:CollidesWithGrid() then
					local targetvelocity = (targetpos - fam.Position):Resized(10)
					fam.Velocity = mod:Lerp(fam.Velocity, targetvelocity, 0.5)

					if targetpos.X < fam.Position.X then --future me pls don't fuck this up
						sprite.FlipX = true
					else
						sprite.FlipX = false
					end
				elseif (fam.Position:Distance(player.Position) > 250 and #Isaac.FindInRadius(fam.Position, 120, EntityPartition.ENEMY) == 0) or fam:CollidesWithGrid() then
					fam:MultiplyFriction(0.8)
					player:GetData().lilAnaNewPlace = nil
				end

			end

		else

			d.animation = "Attack"

			local targetpos = mod:confusePos(fam, d.targ.Position, 5, nil, nil)
			if fam.Position:Distance(targetpos) > 10 then
				if mod:isScare(fam) then
					local targetvelocity = (targetpos - fam.Position):Resized(-10)
					fam.Velocity = mod:Lerp(fam.Velocity, targetvelocity, 0.5)
				elseif room:CheckLine(fam.Position,targetpos,0,1,false,false) then
					local targetvelocity = (targetpos - fam.Position):Resized(10)
					fam.Velocity = mod:Lerp(fam.Velocity, targetvelocity, 0.5)
				else
					path:FindGridPath(targetpos, 1, 1, true)
				end

				if targetpos.X < fam.Position.X then --future me pls don't fuck this up
					sprite.FlipX = true
				else
					sprite.FlipX = false
				end
			elseif fam.Position:Distance(targetpos) < 5 then
				fam:MultiplyFriction(0.8)
			end
		end

		if fam.Velocity:Length() > 0.2 then
			mod:spritePlay(sprite, d.animation .. " " .. mod:GetMoveString(fam.Velocity, true, false))
		end
	elseif d.state == "rewardgive" then
		fam:MultiplyFriction(0.8)
		mod:spritePlay(sprite, "Give Coin")
	end

	if d.XP%5 == 0 then
		d.state = "rewardgive"
	end

	if sprite:IsEventTriggered("Coin") then
		local coin = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, 0, game:GetRoom():FindFreePickupSpawnPosition(fam.Position, 0, true), Vector.Zero, fam)
	end

	if sprite:IsFinished("Give Coin") then
		d.state = "chase"
		d.XP = d.XP + 1
	end

end

function mod:SetLastDamageSourceAsLilAna(ent, source)
    if source.Type == 3 and source.Variant == mod.Familiars.LilAna.Var then
		ent:GetData().lastanixbirthDamageSource = source.Entity
    end
end

function mod:AddXPToAna(npc)
	if npc:HasMortalDamage() then
		if npc:GetData().lastanixbirthDamageSource and npc:GetData().lastanixbirthDamageSource.Variant == mod.Familiars.LilAna.Var and not npc:GetData().hasGievRewardtoAna then
			npc:GetData().lastanixbirthDamageSource:GetData().XP = npc:GetData().lastanixbirthDamageSource:GetData().XP + 1
			npc:GetData().hasGievRewardtoAna = true
		end
	end
end

function mod:AlertLilAnaToTear(tear)
	if tear.SpawnerEntity:ToPlayer() then
		local player = tear.SpawnerEntity:ToPlayer()

		if not player:GetData().lilAnaNewPlace then
			player:GetData().lilAnaNewPlace = tear.Position
		end
	end
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, ent, dmg, flag, source)
    mod:SetLastDamageSourceAsLilAna(ent, source)
end)

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    mod:AddXPToAna(npc)
end)

mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, function(_, tear)
	mod:AlertLilAnaToTear(tear)
end)