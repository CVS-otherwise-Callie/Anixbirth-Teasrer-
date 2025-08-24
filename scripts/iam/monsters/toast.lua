local mod = FHAC
local game = Game()
local rng = RNG()
local sfx = SFXManager()

local function GetAliveEntitiesInDist(npc, dist)
	local tab = {}
	for k, v in ipairs(Isaac.GetRoomEntities()) do
		if npc.Position:Distance(v.Position) > 0 and npc.Position:Distance(v.Position) < dist and v:Exists() and not v:IsDead() and v.GridCollisionClass == EntityGridCollisionClass.GRIDCOLL_GROUND then
            table.insert(tab, v)
		end
	end
	return tab
end

function mod:ToastAI(npc, sprite, d)

    local target = npc:GetPlayerTarget()
    local targetpos = mod:confusePos(npc, target.Position, 5, nil, nil)

    if not d.init then
        d.state = "hiding"
        npc:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK)
        d.addon = 0
        d.canBeHit = false
        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
        npc:MultiplyFriction(0.3)
    end

    if d.state == "hiding" then
        npc.DepthOffset = -100
        npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        npc:AddEntityFlags(EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_DEATH_TRIGGER| EntityFlag.FLAG_NO_STATUS_EFFECTS)
        mod:spritePlay(sprite, "Hidden")
        d.canBeHit = false

        if  targetpos:Distance(npc.Position) > 200 and game:GetRoom():CheckLine(target.Position,npc.Position,3,900,false,false) then
            npc.StateFrame = npc.StateFrame - 1
        end

        if #GetAliveEntitiesInDist(npc, 22) ~= 0 or #Isaac.FindInRadius(npc.Position, 35, EntityPartition.PLAYER) ~= 0 then
            mod:spritePlay(sprite, "SwitchedOff")
            sfx:Play(SoundEffect.SOUND_BUTTON_PRESS, 1, 2, false, 1, 0)
            npc.StateFrame = 0
            d.state = nil
        elseif (npc.StateFrame > 200 and targetpos:Distance(npc.Position) < 200) and game:GetRoom():CheckLine(target.Position,npc.Position,3,900,false,false) then
            d.state = "popup"
        end
    elseif d.state == "offhiding" then
    
        mod:spritePlay(sprite, "Off")
        d.oldstate = "offhiding"

        if (#GetAliveEntitiesInDist(npc, 22) == 0 and #Isaac.FindInRadius(npc.Position, 35, EntityPartition.PLAYER) == 0) then
            mod:spritePlay(sprite, "SwitchedOn")
            d.state = nil
        end

    elseif d.state == "popup" then
        npc.DepthOffset = 0
        npc:ClearEntityFlags(EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_DEATH_TRIGGER| EntityFlag.FLAG_NO_STATUS_EFFECTS)
        npc.GridCollisionClass = GridCollisionClass.COLLISION_WALL_EXCEPT_PLAYER
        mod:spritePlay(sprite, "Reveal")

        if sprite:GetFrame() > 2 and sprite:GetFrame() < 12 then
            npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
            d.canBeHit = true
        else
            npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
            d.canBeHit = false
        end

        if sprite:GetFrame() > 1 then
            for _, tear in pairs(Isaac.FindByType(2, -1, -1, false, false)) do
                if tear.Position:Distance(npc.Position) < 20 and d.canBeHit == false then
                    d.addon = d.addon + math.random(5)
                end
            end
        end

        if npc.StateFrame > 20 + d.addon and game:GetRoom():CheckLine(target.Position,npc.Position,3,900,false,false) and sprite:IsFinished("Reveal") then
            d.state = "shoot"
        end
    elseif d.state == "shoot" then
        mod:spritePlay(sprite, "Shoot")
    elseif d.state == "idle" then
        mod:spritePlay(sprite, "Idle")

            
        for _, tear in pairs(Isaac.FindByType(2, -1, -1, false, false)) do
            if tear.Position:Distance(npc.Position) < 20 and d.canBeHit == false then
                d.addon = d.addon + math.random(5)
            end
        end
        if npc.StateFrame > 100 + d.addon and game:GetRoom():CheckLine(target.Position,npc.Position,3,900,false,false) then
            d.state = "shoot"
        end
    elseif d.state == "bombed" then
        mod:spritePlay(sprite, "Bombed")
        
        if npc.StateFrame > 100 then
            d.state = "idle"
            npc.StateFrame = 0
        end
    elseif sprite:GetAnimation() == "Appear" then
        d.state = "hiding"
    end

    if sprite:IsFinished("SwitchedOff") then
        if npc.StateFrame > 10 then
            sfx:Play(SoundEffect.SOUND_BUTTON_PRESS, 1, 2, false, 1, 0)
            d.state = "offhiding"
            mod:spritePlay(sprite, "SwitchedOff")
            npc.StateFrame = 0
        end
    elseif sprite:IsFinished("SwitchedOn") then
        d.state = "popup"
    elseif sprite:IsFinished("Shoot") then
        if math.random(3) == 3 then
            mod:spritePlay(sprite, "Dissapear")
            d.state = nil
        else
            d.state = "idle"
        end
        npc.StateFrame = 0
    elseif sprite:IsFinished("Dissapear") then
        d.state = "hiding"
    end

    if sprite:IsEventTriggered("Open") then
        npc:ClearEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)
        d.canBeHit = true
    elseif sprite:IsEventTriggered("Close") then
        d.canBeHit = false
    elseif sprite:IsEventTriggered("Shoot") then
        npc:PlaySound(SoundEffect.SOUND_BLOODSHOOT,1,0,false,1)
        d.p = Isaac.Spawn(9, 0, 0, npc.Position, Vector(8, 0):Rotated((targetpos - npc.Position):GetAngleDegrees()), npc):ToProjectile()
        d.p.Parent = npc
        d.p.Scale = 2.3
    end

    mod.scheduleCallback(function()
        if d.canBeHit then return end

        for _, tear in pairs(Isaac.FindByType(9, -1, -1, false, false)) do
            local beingHit
            if tear.Position:Distance(npc.Position) < 20 then
                beingHit = true
            end
            if beingHit then
                tear:ToProjectile():Die()
            end
        end
    end, 1, ModCallbacks.MC_POST_UPDATE)

end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, npc, amt, flag, source)
    if npc.Type == 161 and npc.Variant == 1 then
        if not npc:GetData().canBeHit then
            if (flag & DamageFlag.DAMAGE_EXPLOSION ~= 0 and mod:IsSourceofDamagePlayer(source, true) == false and npc.Variant == 1) or amt > 20 then
                npc:ToNPC():GetData().state = "bombed"
                npc:ToNPC().StateFrame = 0
            end
            return false
        end
    end
end, mod.Monsters.Stoner.ID)

