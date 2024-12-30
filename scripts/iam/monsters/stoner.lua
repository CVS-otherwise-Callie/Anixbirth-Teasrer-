local mod = FHAC
local game = Game()
local rng = RNG()
local sfx = SFXManager()

mod.OldStonerDirs = { --this shit is FUCKED!
    {-90, -90, -67.5},
    {-45, -67.5, -22.5},
    {1, -22.5, 22.5},
    {45, 22.5, 67.5},
    {90, 67.5, 112.5},
    {135, 112.5, 157.5},
    {180, 157.7, -157.5},
    {-135, -157.7, -90},
}

mod.StonerDirs = { --this shit is FUCKED!
    {-90, -135, -45},
    {1, -45, 45},
    {90, 45, 135},
    {180, 135, -135},
}


mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.Stoner.Var then
        mod:StonerAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.Stoner.ID)

function mod:StonerAI(npc, sprite, d)

    local room = game:GetRoom()
    local target = npc:GetPlayerTarget()
    local targetpos = mod:confusePos(npc, target.Position, 5, nil, nil)
    local enemydir = (targetpos - npc.Position):GetAngleDegrees()

    mod:SaveEntToRoom({
        Name="Stoner",
        NPC = npc,
    })

    if not d.init then
        rng:SetSeed(npc.DropSeed,35)
        d.face = d.face or rng:RandomInt(450)
        sprite:SetFrame("Idle", d.face)
        npc:AddEntityFlags(EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_DEATH_TRIGGER)
        npc.GridCollisionClass = GridCollisionClass.COLLISION_WALL_EXCEPT_PLAYER
        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
        npc:MultiplyFriction(0.6)
    end

    if npc.Velocity:Length() > 0.5 then
        if not d.movementinit then
            npc.StateFrame = 12
            d.movementinit = true
        end
        if npc.StateFrame % 12 == 0 then
            local ef = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DUST_CLOUD, -1, npc.Position + Vector(math.random(-25, 25), 10),Vector.Zero, npc):ToEffect()
            ef:SetTimeout(10)
            ef.SpriteScale = Vector(0.03,0.03)
        end
        npc:PlaySound(mod.Sounds.TombstoneMove, math.random(3, 5)/10, 0, false, math.random(80, 101)/100, 0)
    else
        d.movementinit= false
    end

    ---@param plate GridEntity
    local function ActivePressurePlate(plate) --thanks kerkel!!!!
        if plate.State ~= 0 then return end
        sfx:Play(469, 1, 0, false, 1, 0)

        plate.State = 3
        plate:GetSprite():Play("Switched", true)
        plate:ToPressurePlate():Reward()
    end


    for i = 0, room:GetGridSize() do 
        if room:GetGridEntity(i) ~= nil and room:GetGridEntity(i):GetType() == 20 then
            if npc.Position:Distance(room:GetGridEntity(i).Position) < 35 then
                local grid = Game():GetRoom():GetGridEntityFromPos(npc.Position)

                if grid and grid:GetType() == GridEntityType.GRID_PRESSURE_PLATE and grid.VarData ~= 20 then
                    ActivePressurePlate(grid)
                end
            end
        end
    end


    --code form psi hunter, thanks ff for teaching me how to block lasers
    mod.scheduleCallback(function() for _, laser in pairs(Isaac.FindByType(7, 1, -1, false, false)) do

			local laser = laser:ToLaser()
			local laserVec = laser:GetEndPoint() - (laser.Position + laser.PositionOffset)
			if (laser.Position + laserVec:Normalized()):Distance(npc.Position) < laser.Position:Distance(npc.Position) then
				local beingHit
				if math.abs(math.abs(laser.Position.X) - math.abs(npc.Position.X)) < 40 and math.abs(laserVec.Y) > math.abs(laserVec.X) then
					beingHit = true
				elseif math.abs(math.abs(laser.Position.Y) - math.abs(npc.Position.Y)) < 40 and math.abs(laserVec.X) > math.abs(laserVec.Y)then
					beingHit = true
				end
				if beingHit and not npc:IsDead() then
					if not laser:GetData().hittingStoner then
						laser:GetData().hittingStoner = laser.MaxDistance
					end
					local lengthcalc = (npc.Position - laser.Position):Length() - 40
					if laser:GetData().annoyingAndStupidPsionicKnightThing and laser.Parent then --ff compatability??
						lengthcalc = lengthcalc + 20 + laser.Parent.Velocity:Length()
					end
					if laser:GetData().hittingStoner > 0 then
						laser:SetMaxDistance(math.min(lengthcalc, laser:GetData().hittingStoner))
					else
						laser:SetMaxDistance(lengthcalc)
					end
					laser:Update()

					if laser:GetData().hittingStoner and (lengthcalc < laser:GetData().hittingStoner or laser:GetData().hittingStoner == 0) then
						npc.Velocity = npc.Velocity + laserVec:Resized(1)

						local vec = (laserVec * -1):Rotated(-90 + math.random(180)):Resized(math.random(10,15))
						local brimDrops = Isaac.Spawn(1000, 70, 0, laser:GetEndPoint(), vec, nil):ToEffect()
						brimDrops.FallingAcceleration = 1.3
						brimDrops.FallingSpeed = -3
						brimDrops.PositionOffset = Vector(vec.X, math.abs(vec.Y) * -1)
						brimDrops:Update()
					end
				else
					if laser:GetData().hittingStoner then
						laser:SetMaxDistance(laser:GetData().hittingStoner)
						laser:GetData().hittingStoner = nil
						laser:Update()
					end
				end
			end
		end end, 1, ModCallbacks.MC_POST_UPDATE)

        mod.scheduleCallback(function()
            for _, tear in pairs(Isaac.FindByType(9, -1, -1, false, false)) do
                local beingHit
				if tear.Position:Distance(npc.Position) < 20 then
					beingHit = true
                end
                if beingHit then
                    npc.Velocity = npc.Velocity + tear.Velocity:Resized(7)
                    tear:ToProjectile():Die()
                end
            end
        end, 1, ModCallbacks.MC_POST_UPDATE)
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, npc)
    if npc.Type == mod.Monsters.Stoner.ID and npc.Variant == mod.Monsters.Stoner.Var then
        return false
    end
end, mod.Monsters.Stoner.ID)


