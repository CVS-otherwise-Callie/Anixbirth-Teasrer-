local mod = FHAC
local game = Game()

---#region Fiend Folio API

function mod.GetPlayerFireVector(player)
	return mod.DirectionToVector[player:GetFireDirection()]
end

function mod.GetGoodShootingJoystick(player)
	local returnValue = player:GetShootingJoystick()

    if player.ControllerIndex == 0 and Options.MouseControl and Input.IsMouseBtnPressed(0) then -- ControllerIndex 0 == Keyboard & Mouse
        returnValue = (Input.GetMousePosition(true) - player.Position)
    end

    return returnValue:Normalized()
end

function mod.IsPlayerMarkedFiring(player)
	return (
		player:HasCollectible(CollectibleType.COLLECTIBLE_MARKED) and
		mod.GetPlayerMarkedTarget(player)
	)
end

function mod.IsPlayerTryingToShoot(player)
	return (
		mod.GetGoodShootingJoystick(player):Length() > 0 or
		player:AreOpposingShootDirectionsPressed() or
		mod.IsPlayerMarkedFiring(player)
	)
end

function mod.GetMyKingBabyTarget(familiar) -- Modified version of a function by Erfly. Thanks Erfly!!
	local entity = familiar.Parent
	while entity do
		if entity.Type == 3 and entity.Variant == FamiliarVariant.KING_BABY then
			return entity.Target
		end

		entity = entity.Parent
	end
end

function mod.GetFamiliarShootingDirection(familiar) -- Return Values: (Vector) Fire Direction, (Bool) Override Movement Inheritance 
	local player = familiar.Player
	local kingBabyTarget = mod.GetMyKingBabyTarget(familiar)

	if kingBabyTarget then
		return (kingBabyTarget.Position - familiar.Position):Normalized(), true
	elseif player:HasCollectible(CollectibleType.COLLECTIBLE_MARKED) then
		return (mod.GetPlayerMarkedTarget(familiar.Player).Position - familiar.Position):Normalized(), true
	else
		return mod.GetPlayerFireVector(player) or mod.GetGoodShootingJoystick(player), false
	end
end

function mod.GetPlayerMarkedTarget(player, force)
	-- player:GetActiveWeaponEntity doesn't work for Marked :'(
	local data = player:GetData()
	if data.retributionMarkedTargetStorage and data.retributionMarkedTargetStorage:Exists() and not force then
		return data.retributionMarkedTargetStorage
	end

	local targets = Isaac.FindByType(1000, EffectVariant.TARGET)
	for _, target in pairs(targets) do
		if target.SpawnerEntity and target:ToEffect().State == 0 and GetPtrHash(target.SpawnerEntity) == GetPtrHash(player) then
			if player:GetAimDirection():GetAngleDegrees() == (target.Position - player.Position):GetAngleDegrees() then
				data.retributionMarkedTargetStorage = target
				return target
			end
		end
	end
end

--thx fiends folioooo
function mod:GetNewPosAligned(pos,ignorerocks)
	local room = game:GetRoom()
	local vec = Vector(0, 40)
	local positions = {}
	for i = 1, 4 do
		local gridvalid = true
		local dist = 1
		while gridvalid == true do
			local newpos = pos + (vec:Rotated(i*90) * dist)
			local gridColl = room:GetGridCollisionAtPos(newpos)
			if (gridColl ~= GridCollisionClass.COLLISION_NONE or dist > 25) and not ignorerocks then
				gridvalid = false
			elseif ignorerocks and gridColl == GridCollisionClass.COLLISION_WALL or dist > 25 then
				gridvalid = false
			else
				table.insert(positions, newpos)
				dist = dist + 1
			end
		end
	end
	--[[for i = 1, #positions do
		Isaac.Spawn(5, 40, 0, positions[i], nilvector, npc):ToEffect()
	end]]
	if #positions > 0 then
		return positions[math.random(#positions)]
	else
		return pos
	end
end
-- Extra item callbacks
local TrackedItems = {
	Players = {},
	Callbacks = {
		Collect = {},
		Trinket = {}
	}
}

function mod.AddItemCallback(onAdd, onRemove, item, forceAddOnRepickup)
	local entry = TrackedItems.Callbacks.Collect[item]
	local listing = { Add = onAdd, Remove = onRemove, ForceAddOnRepickup = forceAddOnRepickup }
	if not entry then
		TrackedItems.Callbacks.Collect[item] = { listing }
	else
		table.insert(entry, listing)
	end
end

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, function(_, player)
	TrackedItems.Players[player:GetCollectibleRNG(1):GetSeed()] = {
		Collect = {},
		Trinket = {}
	}
end)

mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, function(_, pickup, collider, low)
	local collectibleConfig = Isaac.GetItemConfig():GetCollectible(pickup.SubType)
	local isActive = nil
	if collectibleConfig then
		isActive = collectibleConfig.Type == ItemType.ITEM_ACTIVE
	end

	if collider.Type == EntityType.ENTITY_PLAYER and
	   collider.Variant == 0
	then
		local player = collider:ToPlayer()
		if player:GetPlayerType() == PlayerType.PLAYER_THESOUL_B and player:GetOtherTwin() ~= nil then
			player = player:GetOtherTwin()
		end
		local data = AnixbirthSaveManager.GetRunSave(player).anixbirthsaveData

		if player:CanPickupItem() and
		   player:IsExtraAnimationFinished() and
		   player.ItemHoldCooldown <= 0 and
		   not player:IsCoopGhost() and
		   (collider.Parent == nil or (data and data.SpawnedAsKeeper and not isActive)) and --Strawman
		   player:GetPlayerType() ~= PlayerType.PLAYER_CAIN_B and
		   pickup.SubType ~= 0 and
		   pickup.Wait <= 0 and
		   not pickup.Touched and
		   TrackedItems.Callbacks.Collect[pickup.SubType] ~= nil
		then
			if data ~= nil then
				data.currentQueuedItem = pickup.SubType
			end
		end
	end
end, PickupVariant.PICKUP_COLLECTIBLE)

function mod.GetExpectedFamiliarNum(player, item)
	return player:GetCollectibleNum(item) + player:GetEffects():GetCollectibleEffectNum(item)
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)
	local ref = TrackedItems.Players[player:GetCollectibleRNG(1):GetSeed()]
	if not ref then
		ref = {
			Collect = {},
			Trinket = {}
		}
		TrackedItems.Players[player:GetCollectibleRNG(1):GetSeed()] = ref
	end

	-- IsHoldingItem is true for the entire pickup animation
	-- IsHeldItemVisible is true only when item is lifted... but on the first frame it's false so the cache would be updated
	-- therefore, on the first frame of a pickup animation, set a flag indicating the animation has started and from then on when IsHeldItem item is false ignore it
	-- until the player is no longer holding an item, then reset it
	-- interesting!!
	local basedata = player:GetData()
	local data = AnixbirthSaveManager.GetRunSave(player).anixbirthsaveData
	local playerIsHoldingItem = player:IsHoldingItem()
	if playerIsHoldingItem then
		if not player:IsHeldItemVisible() then
			if basedata.StartedPickupAnimation then
				playerIsHoldingItem = false
			else
				basedata.StartedPickupAnimation = true
			end
		end
	else
		basedata.StartedPickupAnimation = nil
	end

	for item, callbacks in pairs(TrackedItems.Callbacks.Collect) do
		local count = player:GetCollectibleNum(item, true)
		local skipUpdate = false
		if ref.Collect[item] then
			local diff = count - ref.Collect[item]
			if diff > 0 and playerIsHoldingItem then
				skipUpdate = true
			elseif diff ~= 0 then
				for _, entry in ipairs(callbacks) do
					local foo = nil
					if diff > 0 and entry.ForceAddOnRepickup then
						foo = entry.Add
					else
						foo = entry.Remove
					end

					if foo then
						foo(player, math.abs(diff), count)
					end
				end
			end
		end
		if not skipUpdate then
			ref.Collect[item] = count
		end
	end

	local queuedItem = player.QueuedItem
	if data.currentQueuedItem ~= nil and (queuedItem.Item == nil or queuedItem.Item.ID ~= data.currentQueuedItem) then
		local item = data.currentQueuedItem
		data.currentQueuedItem = nil

		local callbacks = TrackedItems.Callbacks.Collect[item]
		local count = player:GetCollectibleNum(item, true)

		for _, entry in ipairs(callbacks) do
			local foo = entry.Add
			if foo and not entry.ForceAddOnRepickup then
				foo(player, 1, count)
			end
		end
	end
	if data.currentQueuedItem == nil and 
	   queuedItem.Item ~= nil and 
	   not queuedItem.Touched and 
	   queuedItem.Item:IsCollectible() and
	   TrackedItems.Callbacks.Collect[queuedItem.Item.ID] ~= nil 
	then
		data.currentQueuedItem = queuedItem.Item.ID
	end

	for item, callbacks in pairs(TrackedItems.Callbacks.Trinket) do
		local has = player:HasTrinket(item)
		local gulped = has
		local skipUpdate = false
		if ref.Trinket[item] ~= nil then
			if has and playerIsHoldingItem then
				skipUpdate = true
			elseif has ~= ref.Trinket[item].Has then
				for _, entry in ipairs(callbacks) do
					local foo = nil
					if has then
						foo = entry.Add
					else
						foo = entry.Remove
					end

					if foo then
						foo(player, has)
					end
				end
			elseif gulped and not ref.Trinket[item].Gulped then
				for _, entry in ipairs(callbacks) do
					local foo = entry.Gulp
					if foo then
						foo(player)
					end
				end
			end
		end
		if not skipUpdate then
			ref.Trinket[item] = { Has = has, Gulped = gulped }
		end
	end

end)

--ok i must be super lazy tonight but ye gain ff 
function mod:GetMoveString(vec, doFlipX, doFlipY)
	doFlipX = doFlipX or true
	doFlipY = doFlipY or false
    if math.abs(vec.Y) > math.abs(vec.X) then
        if vec.Y > 0 then
            if doFlipY then
                return "Vert", false
            else
                return "Down", false
            end        
		else
			if doFlipY then
                return "Vert", true
            else
                return "Up", false
            end
        end
    else
        if vec.X > 0 then
            if doFlipX then
                return "Hori", false
            else
                return "Right", false
            end
        else
            if doFlipX then
                return "Hori", true
            else
                return "Left", false
            end
        end
    end
end

--based on the last two you guys know where this is from....
function mod:diagonalMove(npc, speed, thirdboolean, xmult)
	xmult = xmult or 1
	local xvel = speed * xmult
	local yvel = speed
	if npc.Velocity.X < 0 then
		xvel = xvel * -1
	end
	if npc.Velocity.Y < 0 then
		yvel = yvel * -1
	end

	if mod:isScare(npc) then
		if npc:GetPlayerTarget() then
			local pdist = npc:GetPlayerTarget().Position:Distance(npc.Position)
			if pdist < 300 then
				local vec = (npc.Position - npc:GetPlayerTarget().Position):Resized(math.max(5, 10 - pdist/20))
				xvel = vec.X
				yvel = vec.Y
			end
		end
	end
	if mod:isConfuse(npc) then
		local vec = mod:confusePos(npc, Vector(xvel, yvel), nil, true)
		xvel = vec.X
		yvel = vec.Y
	end
	if thirdboolean then
		return Vector(xvel, yvel)
	else
        npc.Velocity = Vector(xvel, yvel)
	end
end

function mod:changeExtension(filename, newExtension) 
	local lastDotIndex = string.len(filename) - string.len(string.match(filename, "%.[^%.]*$"))
	local baseName = string.sub(filename, 1, lastDotIndex - 1)
	return baseName .. "." .. newExtension
  
end

function mod.anyPlayerHas(itemid, trinket, mombox)
	for i = 1, game:GetNumPlayers() do
		local p = Isaac.GetPlayer(i - 1)
		if trinket then
			if mombox then
				if p:HasTrinket(itemid) and p:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_BOX) then
					return true
				end
			else
				if p:HasTrinket(itemid) then
					return true
				end
			end
		else
			if p:HasCollectible(itemid) then
				return true
			end
		end
	end
end


--#end region

mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, function(_, pickup, collider, low)
	local collectibleConfig = Isaac.GetItemConfig():GetCollectible(pickup.SubType)
	local isActive = nil
	if collectibleConfig then
		isActive = collectibleConfig.Type == ItemType.ITEM_ACTIVE
	end

	if collider.Type == EntityType.ENTITY_PLAYER and
	   collider.Variant == 0
	then
		local player = collider:ToPlayer()
		if player:GetPlayerType() == PlayerType.PLAYER_THESOUL_B and player:GetOtherTwin() ~= nil then
			player = player:GetOtherTwin()
		end
		local data = player:GetData().ffsavedata

		if player:CanPickupItem() and
		   player:IsExtraAnimationFinished() and
		   player.ItemHoldCooldown <= 0 and
		   not player:IsCoopGhost() and
		   (collider.Parent == nil or (data and data.SpawnedAsKeeper and not isActive)) and --Strawman
		   player:GetPlayerType() ~= PlayerType.PLAYER_CAIN_B and
		   pickup.SubType ~= 0 and
		   pickup.Wait <= 0 and
		   not pickup.Touched and
		   TrackedItems.Callbacks.Collect[pickup.SubType] ~= nil
		then
			if data ~= nil then
				data.currentQueuedItem = pickup.SubType
			end
		end
	end
end, PickupVariant.PICKUP_COLLECTIBLE)