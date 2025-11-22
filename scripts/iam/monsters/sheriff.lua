local mod = FHAC
local game = Game()
local rng = RNG()
local sfx = SFXManager()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.Sheriff.Var then
        mod:SheriffAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.Sheriff.ID)

function mod:SheriffAI(npc, sprite, d)

    local name
    local option = FHAC.DSSavedata.sheriffMode or 1

    if option == 1 or option == nil then
        name = "Shoot3"
    else
        name = "Shoot"
    end

    local target = npc:GetPlayerTarget()
    local targetpos = mod:confusePos(npc, target.Position, 5, nil, nil)
    local room = game:GetRoom()
    local path = npc.Pathfinder
    local params = ProjectileParams()
    local teartab = {}

    if not d.init then
        rng:SetSeed(npc.InitSeed, 0)

        if rng:RandomInt(1000) < 2 then
            d.name = "hat"
        else
            d.name = ""
        end

        sprite:PlayOverlay("Head" .. d.name)
        d.state = "hide"
        d.num = math.random(-20, 20)
        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    for k, v in ipairs(Isaac.GetRoomEntities()) do
        if v.Type == 2 then
            table.insert(teartab, v)
        end
    end

    local closesttear
    local initdis = 10^10
    for k, v in ipairs(teartab) do
        local dis = npc.Position:Distance(v.Position)
        if dis < initdis then
            closesttear = v
        end
    end

    if closesttear then
        path:EvadeTarget(closesttear.Position)
    end

    if mod:isScare(npc) then
        if target.Position.X > npc.Position.X then
            sprite.FlipX = true
            else
            sprite.FlipX = false
        end
    else
        if target.Position.X > npc.Position.X then
            sprite.FlipX = false
            else
            sprite.FlipX = true
        end
    end

    function mod:findHideablePlace()
        local closestgridpoint

        local imtheclosest = 0 --just a absurdly big number
        local tab = {}
        for i = 0, room:GetGridSize() do
			if room:GetGridPosition(i) ~= nil then
				local gridpoint = room:GetGridPosition(i)
				if (room:GetGridEntity(i) == nil or room:GetGridEntity(i) == true) and room and room:IsPositionInRoom(gridpoint, 0) and not game:GetRoom():CheckLine(target.Position,gridpoint,0,900,false,false) then
                    if gridpoint:Distance(target.Position) > imtheclosest then
                        imtheclosest = gridpoint:Distance(target.Position)
                        closestgridpoint = gridpoint
                    end
					table.insert(tab, gridpoint)
				end
			end
		end
        if mod:IsTableEmpty(tab) then
            d.state = "wander"
            return npc.Position
        else
            return closestgridpoint
        end
    end

    if d.state == "hide" then

        d.hidingplace = mod:findHideablePlace()

        if mod:isCharm(npc) then
            npc.Velocity = npc.Velocity + npc.Velocity:Normalized() * 1.05
            path:FindGridPath(d.hidingplace, 1, 1, true)
        elseif mod:isScare(npc) then
            if (Game():GetRoom():CheckLine(npc.Position, d.hidingplace, 0, 1, false, false) and not npc:CollidesWithGrid()) or npc:GetChampionColorIdx() == 8 then
                npc.Velocity = npc.Velocity + (d.hidingplace - npc.Position):Normalized() * -1.35
            else
                path:FindGridPath(d.hidingplace, -0.85, 1, true)
            end
        else
            npc.Velocity = npc.Velocity + npc.Velocity:Normalized() * 1.05
            path:FindGridPath(d.hidingplace, 1, 1, true)
        end


        if npc.StateFrame > 70+d.num then
            d.state = "shootouttime"
        end

        npc:MultiplyFriction(0.85)

    elseif d.state == "shootouttime" then

        if 4 > math.abs(npc.Position.Y - targetpos.Y) then
            d.newpos = mod:GetNewPosAlignedXAxis(target.Position, false)
        end

        d.newpos = d.newpos or mod:GetNewPosAlignedXAxis(target.Position, false)

        if not room:CheckLine(targetpos,npc.Position,3,900,false,false) then
            d.newpos = nil
            if mod:isCharm(npc) then
                npc.Velocity = npc.Velocity + npc.Velocity:Normalized() * 1.05
                path:FindGridPath(targetpos, 0.7, 1, true)
            elseif mod:isScare(npc) then
                if (Game():GetRoom():CheckLine(npc.Position, targetpos, 0, 1, false, false) and not npc:CollidesWithGrid()) or npc:GetChampionColorIdx() == 8 then
                    npc.Velocity = npc.Velocity + (targetpos - npc.Position):Normalized() * -1.35
                else
                    path:FindGridPath(targetpos, -0.85, 1, true)
                end
            else
                npc.Velocity = npc.Velocity + npc.Velocity:Normalized() * 1.05
                path:FindGridPath(targetpos, 0.7, 1, true)
            end
            d.dir = nil
        else

            if mod:isCharm(npc) then
                npc.Velocity = npc.Velocity + npc.Velocity:Normalized() * 1.05
                path:FindGridPath(d.newpos, 0.7, 1, true)
            elseif mod:isScare(npc) then
                if (Game():GetRoom():CheckLine(npc.Position, d.newpos, 0, 1, false, false) and not npc:CollidesWithGrid()) or npc:GetChampionColorIdx() == 8 then
                    npc.Velocity = npc.Velocity + (d.newpos - npc.Position):Normalized() * -1.35
                else
                    path:FindGridPath(d.newpos, -0.85, 1, true)
                end
            elseif path:HasPathToPos(targetpos) then
                npc.Velocity = npc.Velocity + npc.Velocity:Normalized() * 1.05
                path:FindGridPath(d.newpos, 0.7, 1, true)
            else
                npc.Velocity = mod:Lerp(npc.Velocity, (Vector(npc.Position.X, targetpos.Y) - npc.Position):Resized(10), 0.1)
            end
        end

        npc:MultiplyFriction(0.85)

        if npc.StateFrame > 110+d.num and room:CheckLine(targetpos,npc.Position,3,900,false,false) then
            d.state = name
        end

    elseif d.state == name and not sprite:IsOverlayPlaying(name .. d.name) then
        d.teartab = {}
        d.newpos = nil
        d.hidingplace = nil
        sprite:PlayOverlay(name .. d.name, true)
    elseif d.state == "wander" then
        if mod:isCharm(npc) then
            npc.Velocity = npc.Velocity + npc.Velocity:Normalized() * 1.05
            path:MoveRandomly(false)
        elseif mod:isScare(npc) then
            if (Game():GetRoom():CheckLine(npc.Position, targetpos, 0, 1, false, false) and not npc:CollidesWithGrid()) or npc:GetChampionColorIdx() == 8 then
                npc.Velocity = npc.Velocity + (targetpos - npc.Position):Normalized() * -1.35
            else
                path:FindGridPath(targetpos, -0.85, 1, true)
            end
        else
            npc.Velocity = npc.Velocity + npc.Velocity:Normalized() * 1.05
            path:MoveRandomly(false)
        end
        npc:MultiplyFriction(0.7)

        if npc.StateFrame > 70+d.num then
            d.state = "shootouttime"
        end
    elseif not sprite:IsOverlayFinished(name .. d.name) then
        d.state = "hide"
    end

    if sprite:IsOverlayFinished(name .. d.name) then
        npc.StateFrame = 0
    end

    local projtype = 0

    if sprite:IsOverlayPlaying("Shoot" .. d.name) and sprite:GetOverlayFrame("Shoot" .. d.name) == 10 then
        if (target.Position - npc.Position):Length() > 100 then
            local targetvelocity = (targetpos - npc.Position)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, -0.12)
        else
            local targetvelocity = (targetpos - npc.Position)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, -0.08)
        end
        npc:PlaySound(SoundEffect.SOUND_BULLET_SHOT, 1, 0, false, 2)

        local num = 5

        if d.name == "hat" then
            num = 10
        end

        for i = 1, num do
            local realshot = Isaac.Spawn(9, projtype, 0, npc.Position, Vector(30, 0):Rotated((targetpos - npc.Position):GetAngleDegrees() + ((-12*num+ (4*num*i))/(num/5))):Resized(7 + num), npc):ToProjectile()
            realshot.FallingAccel = 0.01
            realshot.FallingSpeed = 0.1
            realshot:GetData().type = "sheriff"
            realshot:GetData().hat = d.name

            d.Trail = Isaac.Spawn(1000,166,0,npc.Position,Vector.Zero,realshot):ToEffect() -- to learn how to do trails specifically like this, i consulted erfly and he told me to check the tricko code
            d.Trail:FollowParent(realshot)
            d.Trail.ParentOffset = Vector(0,-32)
            local color = Color(1,1,1,1,0.6,0.5,0.05)
            npc.SplatColor = color
            color:SetColorize(1, 0.8, 0.1, 3)
            d.Trail.Color = color
        end
    elseif sprite:IsOverlayPlaying("Shoot3" .. d.name) and (sprite:GetOverlayFrame("Shoot3" .. d.name) == 10 or sprite:GetOverlayFrame("Shoot3" .. d.name) == 18 or sprite:GetOverlayFrame("Shoot3" .. d.name) == 29) then
        if (target.Position - npc.Position):Length() > 100 then
            local targetvelocity = (targetpos - npc.Position)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, -0.12)
        else
            local targetvelocity = (targetpos - npc.Position)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, -0.08)
        end
        npc:PlaySound(SoundEffect.SOUND_BULLET_SHOT, 1, 0, false, 2)

        local num = 2

        if d.name == "hat" then
            num = 5
        end

        for i = 1, num do
            local realshot = Isaac.Spawn(9, projtype, 0, npc.Position, Vector(20, 0):Rotated((targetpos - npc.Position):GetAngleDegrees()-20+(10*i)):Resized(15), npc):ToProjectile()--(targetpos - npc.Position):GetAngleDegrees() + ((-12*num+ (4*num*i))/(num/5))):Resized(7 + num), npc):ToProjectile()
            realshot.FallingAccel = 0.01
            realshot.FallingSpeed = 0.1
            realshot:GetData().type = "sheriff"
            realshot:GetData().hat = d.name

            d.Trail = Isaac.Spawn(1000,166,0,npc.Position,Vector.Zero,realshot):ToEffect() -- to learn how to do trails specifically like this, i consulted erfly and he told me to check the tricko code
            d.Trail:FollowParent(realshot)
            d.Trail.ParentOffset = Vector(0,-17)
            local color = Color(1,1,1,1,0.6,0.5,0.05)
            npc.SplatColor = color
            color:SetColorize(1, 0.8, 0.1, 3)
            d.Trail.Color = color
        end
    end

    if npc.Velocity:Length() > 0.5 then
        npc:AnimWalkFrame("WalkHori","WalkVert",0)
        if not sprite:IsOverlayPlaying(name .. d.name) then
            sprite:PlayOverlay("Head" .. d.name)
        end
    elseif not sprite:IsOverlayPlaying(name .. d.name) then
        sprite:SetFrame("WalkHori", 0)
    end

end

function mod.SheriffShots(v, d)
    if d.type == "sheriff" then
        v.SpriteRotation = v.Velocity:GetAngleDegrees()
        local psprite = v:GetSprite()
        psprite:ReplaceSpritesheet(0, "gfx/projectiles/bullet_projectile-sheet.png")
        psprite:LoadGraphics()

        v.Height = -20

        if v:IsDead() then
            sfx:Play(SoundEffect.SOUND_METAL_BLOCKBREAK, 0.3, 0, false, 2)
            local ef = Isaac.Spawn(1000, EffectVariant.POOF04, 0, v.Position, Vector.Zero, v):ToEffect()
            ef:GetData().type = "temp"
            v:Remove()  
        end


    end
end

function mod.SherrifShotsCollisionPlayer(v, coll)
    local d = v:GetData()
    if d.type == "sheriff" and d.hat == "hat" and coll.Type == 1 then
        coll:ToPlayer():AddCollectible(CollectibleType.COLLECTIBLE_SHARD_OF_GLASS, 0, false, nil, 15)
        coll:ToPlayer():TakeDamage(2, 0, EntityRef(coll), 1)
        coll:ToPlayer():RemoveCollectible(CollectibleType.COLLECTIBLE_SHARD_OF_GLASS, 0, false, nil)
        return false
    end
end

function mod.TempEffects(ef, d)
    if d.type == "temp" then
        d.initTime = game.TimeCounter
        d.timeout = d.timeout or 10
        if game.TimeCounter >= d.initTime+60 then
            ef:Remove()
        end
    end
end