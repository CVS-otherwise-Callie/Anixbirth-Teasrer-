local mod = FHAC
local sfx = SFXManager()
local game = Game()

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, effect)
    if effect.Variant == mod.Effects.InterminatorGhost.Var then
        mod:InterminatorGhostAI(effect, effect:GetSprite(), effect:GetData())
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
    for _, effect in ipairs(Isaac.GetRoomEntities()) do
        if effect.Type == 1000 and effect.Variant == mod.Effects.InterminatorGhost.Var then
            mod:InterminatorGhostAIRender(effect, effect:GetSprite(), effect:GetData())
        end     
    end
end)

local function GetValidPosition(ef)
    local pos
    local valid = false
    repeat
        pos = Isaac.GetRandomPosition()
        if game:GetRoom():GetGridCollisionAtPos(pos) == 0 then
            valid = true
        end
    until valid
    return pos
end

function mod:InterminatorGhostAI(ef, sprite, d)

    local target = d.Target

    if not d.init then
        d.state = "appear"
        d.trailPos = {}
        d.targetPos = GetValidPosition(ef)
        d.init = true
    end

    local targetPos = d.targetPos
    if target then
        targetPos = target.Position
    end

    if sprite:IsFinished("Appear") then
        d.state = "chase"
    end

    if d.state == "chase" then
        ef.Velocity = mod:Lerp(ef.Velocity, (targetPos - ef.Position):Resized(30),  0.025 + d.moveoffset + (ef.FrameCount/1000)%30)
        d.trailPos[ef.FrameCount] = ef.Position
    end

end

function mod:InterminatorGhostAIRender(ef, sprite, d)
    if d.state == "chase" then
        for i = 1, 5 do
            local tsprite = Sprite()

            local pos = d.trailPos[ef.FrameCount - (i*4)]

            tsprite:Load(sprite:GetFilename(), true)
            tsprite:Play("GhostTrailBack" .. i)
            if pos then
                tsprite:Render(Isaac.ScreenToWorld(pos))
            else
                tsprite:Render(Isaac.ScreenToWorld(d.trailPos[#d.trailPos]))
            end
        end
        for i = 1, 5 do
            local tsprite = Sprite()

            local pos = d.trailPos[ef.FrameCount - (i*4)]

            tsprite:Load(sprite:GetFilename(), true)
            tsprite:Play("GhostTrail" .. i)
            if pos then
                tsprite:Render(Isaac.ScreenToWorld(pos))
            else
                tsprite:Render(Isaac.ScreenToWorld(d.trailPos[#d.trailPos]))
            end
        end
    end
end