local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, fam)
    mod:SnarkAI(fam, fam:GetSprite(), fam:GetData())
end, mod.Familiars.Snark.Var)

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    for _, ent in ipairs(Isaac.GetRoomEntities()) do
        if ent.Type == mod.Familiars.Snark.ID and ent.Variant == mod.Familiars.Snark.Var then
            mod:updateSnark()
        end
    end
end)

function mod:SnarkAI(fam, sprite, d)
    
    function mod:snarkfindEnemy(fam)
        local targets = {}
        for _, ent in ipairs(Isaac.GetRoomEntities()) do
            if ent:IsActiveEnemy() and ent:IsVulnerableEnemy() and not ent:IsDead()
            and not ent:HasEntityFlags(EntityFlag.FLAG_FRIENDLY)then
                table.insert(targets, ent)
            end
        end
        if #targets == 0 then
            d.noTarg = true
            d.myTarg = false
            return mod:freeGrid(fam, true)
        end
        d.noTarg = false
        local targ = targets[math.random(1, #targets)]
        d.myTarg = targ
        return targ.Position
    end

    --literally just part 2 shcmoot but jump (to tired to write more code atm)
    if not d.init then
        fam.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
		fam.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
        d.lerpnonsense = 0.06
        d.coolaccel = 1
        d.target = mod:snarkfindEnemy(fam)
        d.init = true
    end

    --damage
    local p = fam.Player:ToPlayer()
    local mul = 1
	if p and p:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
        mul = 2
		fam.Size = 15
		d.randyIsFriend = true
	else
		fam.Size = 10
		d.randyIsFriend = false
	end

    fam.CollisionDamage = fam.Player.Damage * mul

    if d.coolaccel and d.coolaccel < 5 then
        d.coolaccel = d.coolaccel + 0.1
    end
    if mod:isScare(fam) then
        local targetvelocity = (d.target - fam.Position):Resized(-30)
        fam.Velocity = mod:Lerp(fam.Velocity, targetvelocity, d.lerpnonsense + (fam.FrameCount/500))
    else
        local targetvelocity = (d.target - fam.Position):Resized(30)
        fam.Velocity = mod:Lerp(fam.Velocity, targetvelocity, d.lerpnonsense)
    end
    fam.Velocity = mod:Lerp(fam.Velocity, fam.Velocity:Resized(d.coolaccel + (fam.FrameCount/500)), d.lerpnonsense)
    if fam:CollidesWithGrid() then
        d.coolaccel = 1
    end
    if rng:RandomInt(1, 2) == 2 then
        d.lerpnonsense = mod:Lerp(d.lerpnonsense, 0.04, 0.05)
    else
        d.lerpnonsense = mod:Lerp(d.lerpnonsense, 0.01, 0.02)
    end

    function mod:updateSnark()
        d.target = mod:snarkfindEnemy(fam)
    end

    if (d.myTarg and d.myTarg:IsDead()) or fam.Position:Distance(d.target) < 50 then
        d.target = mod:snarkfindEnemy(fam)
    end

    if fam:CollidesWithGrid() then
        mod:spritePlay(sprite, "Jump")
        fam.GridCollisionClass = 1
        fam.Velocity = fam.Velocity*-1
    end

    if sprite:IsFinished("Jump") or (not sprite:IsPlaying("Jump")) then
        fam.GridCollisionClass = 5
        mod:spritePlay(sprite, "Down")
    end

    if fam.FrameCount > 800 then
		Isaac.Explode(fam.Position, fam, 10)
        fam:Remove()
    end
end

