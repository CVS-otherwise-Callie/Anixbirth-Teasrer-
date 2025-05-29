local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.PottedFatty.Var then
        mod:PottedFattyAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.PottedFatty.ID)

function mod:PottedFattyAI(npc, sprite, d)

    local targ = npc:GetPlayerTarget()
    local room = game:GetRoom()
    local path = npc.Pathfinder

    if not d.init then
        d.wait = math.random(-5, 5)
        d.newPer = 3
        d.crackedPer = 0
        d.speedMod = 0.5
        d.newpos = mod:freeGrid(npc, true, 400, 0)
        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    if npc.Position:Distance(d.newpos) < 20 then
        d.wait = 0
        d.newpos = mod:freeGrid(npc, true, 400, 0)
        npc.StateFrame = 0
    else
        if mod:isScare(npc) then
            npc.Velocity = mod:Lerp(npc.Velocity, Vector(-2*d.speedMod, 0):Rotated((d.newpos - npc.Position):GetAngleDegrees()), 1)
        elseif room:CheckLine(npc.Position,d.newpos,0,1,false,false) then
            npc.Velocity = mod:Lerp(npc.Velocity, Vector(2*d.speedMod, 0):Rotated((d.newpos - npc.Position):GetAngleDegrees()), 1)
        else
            path:FindGridPath(d.newpos, 0.7, 1, true)
        end
    end

    if npc.Velocity:Length() > 0.3 then
        npc:AnimWalkFrame("WalkHori","WalkVert",0.)
    else
        sprite:SetFrame("WalkHori", 0)
    end

    if sprite:IsEventTriggered("Slow") then
        d.speedMod = 0.5
    elseif sprite:IsEventTriggered("Speed") then
        d.speedMod = 0.9
    end

    if d.crackedPer and d.crackedPer > d.newPer then
        local ef = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DUST_CLOUD, -1, npc.Position + Vector(math.random(-25, 25), 10),Vector.Zero, npc):ToEffect()
        ef:SetTimeout(10)
        ef.SpriteScale = Vector(0.03,0.03)
        d.crackedPer = d.crackedPer + 1
        d.newPer = d.crackedPer + math.random(2, 4)
    end

    if d.crackedPer > 20 then
        for i = 1, math.random(3, 5) do
            local bucketGib = Isaac.Spawn(1000, 4, 0, npc.Position, Vector(math.random(15,30)/10, 0):Rotated(i*75 + math.random(45)), nil)
            bucketGib:GetSprite():SetFrame("rubble_alt", math.random(4))
            bucketGib:SetColor(Color(2, 1, 1, 1, 0, 0,0,0), 5, 2, true, false)
            bucketGib:Update()
        end
        npc:ToNPC():PlaySound(SoundEffect.SOUND_POT_BREAK, 1, 0, false, 1)

        npc:Remove()
        local ent = Isaac.Spawn(EntityType.ENTITY_FATTY, 0, 0, npc.Position, npc.Velocity, npc)
        ent:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        ent:AddConfusion(EntityRef(npc), 100, false)
    end

end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, ent, dmg, flag, source)
    if ent.Type == mod.Monsters.PottedFatty.ID and ent.Variant == mod.Monsters.PottedFatty.Var then
        ent:GetData().crackedPer = ent:GetData().crackedPer + dmg
        ent:SetColor(Color(2,2,2,1,0,0,0),5,2,true,false)
        return false
    end
end)

