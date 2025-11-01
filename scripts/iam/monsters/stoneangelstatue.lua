local mod = FHAC
local game = Game()
local rng = RNG()

local StoneAngelStatueAIStats = {
    state = "idle",
    angel = nil,
    angelSub = math.random(271, 272)
}

function mod:StoneAngelStatueAI(npc, sprite, d)

    npc:MultiplyFriction(0)
    d.pos = d.pos or npc.Position

    npc.Position = d.pos

    if not d.init then
        for name, stat in pairs(StoneAngelStatueAIStats) do
            d[name] = d[name] or stat
        end
        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    if npc.StateFrame > 50 and d.state == "idle" then
        d.state = "angel"
    end

    if d.state == "angel" then
        if not d.angel or d.angel:IsDead() or not d.angel:Exists() then
            d.angel = Isaac.Spawn(d.angelSub, 0, 0, npc.Position, Vector.Zero, npc)
            d.angel.CollisionDamage = 0
            d.angel:GetData().isAngelStatue = true
            d.angel.Color = Color(1, 1, 1, 0)
            d.angel:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
            d.angel.SpriteOffset = Vector(0, 0)
            d.state = "wait"
        end
    elseif d.state == "wait" then
        if d.angel or d.angel:IsDead() or not d.angel:Exists() then
            npc.StateFrame = 0
            d.state = "idle"
        end
    end

end

local function AngelStatueAngel(npc, sprite, d) 
    npc:MultiplyFriction(0)
    d.pos = d.pos or npc.Position

    npc.Position = d.pos

    sprite.Scale = Vector(0.3, 0.3)

    if sprite:IsFinished() and string.find(sprite:GetAnimation(), "Shot") then
        d.state = "selfkill"
        d.fc = npc.FrameCount
    end

    if d.state == "selfkill" then
        npc.SpriteOffset = Vector(0, -50+math.min(npc.FrameCount - d.fc, 50))
        npc.Color = Color(1, 1, 1, 1 - math.min(npc.FrameCount - d.fc, 50)/50)

        if npc.Color.A == 0 then
            npc:Remove()
        end
    else   
        npc.SpriteOffset = Vector(0, -math.min(npc.FrameCount, 50))
        npc.Color = Color(1, 1, 1, math.min(npc.FrameCount/20, 0.5))
    end
end

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Type == 271 or npc.Type == 272 and npc:GetData().isAngelStatue == true then
        AngelStatueAngel(npc, npc:GetSprite(), npc:GetData()) 
    end
end)

mod:AddCallback(ModCallbacks.MC_PRE_NPC_COLLISION, function(_, npc, coll, bool)
    if npc.Type == 271 or npc.Type == 272 and npc:GetData().isAngelStatue == true then
        return true
    end 
end)

