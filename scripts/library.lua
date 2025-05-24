local mod = FHAC
local game = Game()
local sfx = SFXManager()

-- REMINDER:
-- At end of project, do complile them together for ONLY the workshop version!!!!!!!
-- and delete this lmao

mod:LoadScripts("scripts.library", {
	"basiclib",
	"playerlib",
	"entitylib",
	"familiarlib"
})


function mod:GetClosestMinisaacAttackPos(pos, targetpos, distfromtarget, lineofsight, closelimit) --lineofsight is if you should be able to draw a line from winner to targetpos, closelimit is how small the value can be
	local room = game:GetRoom()
	local closest = Vector(9999999999999999, 9999999999999999) --just a absurdly big number
	local winner = nil
	local options = {
		targetpos + Vector(distfromtarget,0),
		targetpos - Vector(distfromtarget,0),
		targetpos + Vector(0,distfromtarget),
		targetpos - Vector(0,distfromtarget)
	}

	local directions = {
		"Left",
		"Right",
		"Up",
		"Down"
	}

	if lineofsight then

		for i, option in pairs(options) do
			_, options[i] = room:CheckLine(targetpos, option,3,1,false,false)
		end

	end

	for i, option  in ipairs(options) do

		if pos:Distance(options[i]) < pos:Distance(closest) and targetpos:Distance(options[i]) > closelimit then
			closest = option
			winner = i
		end
	end

	if not winner then
		return nil, nil
	end
	if lineofsight then
		return mod:Lerp(targetpos, options[winner], 0.90), directions[winner]
	else
		return options[winner], directions[winner]
	end
end

function mod:ConvertWordDirectionToVector(direction)
	direction = string.lower(direction)
	if direction == "up" then
		return Vector(0,-1)
	elseif direction == "down" then
		return Vector(0,1)
	elseif direction == "left" then
		return Vector(-1,0)
	elseif direction == "right" then
		return Vector(1,0)
	end
end

function mod:ConvertVectorToWordDirection(velocity, Xpriority, Ypriority)
	if not Xpriority then
		Xpriority = 1
	end
	if not Ypriority then
		Ypriority = 1
	end
	if math.abs(velocity.X)*Xpriority < math.abs(velocity.Y)*Ypriority then
		if velocity.Y < 0 then
			return "Up"
		else
			return "Down"
		end
	else
		if velocity.X < 0 then
			return "Left"
		else
			return "Right"
		end
	end
end

--reused for the Clatter Teller
function mod:ClatterTellerWhitelistCheck(npc) 
    for _, entry in pairs(mod.ClatterTellerWhitelist) do
        if npc.Type == entry[1] then
            if entry[4] then
                npc:GetData().ClatterTellerHighPriority = true
            else
                npc:GetData().ClatterTellerLowPriority = true
            end
            if entry[5] then
                npc:GetData().ClatterTellerDontClearAppear = true
            end
            if entry[6] then
                npc:GetData().ClatterTellerGoEasyOnMe = true
            end
            return true
        end
    end
end

function mod:AttachCord(startEnt, endEnt, subtype, anim, splatColor, startOffset, endOffset) --thank you fall from grace/last judgement i think
    subtype = subtype or 0

    local cord = Isaac.Spawn(EntityType.ENTITY_EVIS, 10, subtype, startEnt.Position, Vector.Zero, startEnt):ToNPC()
    cord:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
    cord:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
    cord.TargetPosition = Vector.One
    anim = anim or cord:GetSprite():GetDefaultAnimationName()
    if anim then
        cord:GetSprite():Play(anim, true)
    end

    if startOffset then
        local anchor = Isaac.Spawn(mod.ENT.CordAnchorPoint.ID, mod.ENT.CordAnchorPoint.Var, 0, startEnt.Position, Vector.Zero, startEnt):ToEffect()
        anchor.Parent = startEnt
        anchor.ParentOffset = startOffset
        anchor:Update()
        cord.Parent = anchor
        startEnt:GetData().CordAnchorPoint = anchor
    else
        cord.Parent = startEnt
    end
    cord.Parent:AddVelocity(Vector(0.001,0))

    if endOffset then
        local anchor = Isaac.Spawn(mod.ENT.CordAnchorPoint.ID, mod.ENT.CordAnchorPoint.Var, 0, endEnt.Position, Vector.Zero, endEnt):ToEffect()
        anchor.Parent = endEnt
        anchor.ParentOffset = endOffset
        anchor:Update()
        cord.Target = anchor
        endEnt:GetData().CordAnchorPoint = anchor
    else
        cord.Target = endEnt
    end
    cord.Target:AddVelocity(Vector(0.001,0))

    if splatColor then
        cord.SplatColor = splatColor
        cord:GetData().CordSplatColor = splatColor
    end
    for i = 1, 20 do
        cord:Update()
    end

    return cord
end