local mod = FHAC
local game = Game()
local rng = RNG()

function mod:AmekatzeAI(npc, sprite, d)

    local target = npc:GetPlayerTarget()
    local room = game:GetRoom()
    local path = npc.Pathfinder

    npc.StateFrame = npc.StateFrame + 1

    d.typename = d.typename or "HasBeenPlanted"

    if npc.SubType == 1 then
        mod:spritePlay("Bomb" .. d.typename)
    else
        d.hidingplace = mod:findHideablePlace(npc, d, target)

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

        npc:MultiplyFriction(0.85)

        if npc:IsDead() then
            local bomb = Isaac.Spawn(mod.Monsters.Amekatze.ID, mod.Monsters.Amekatze.Var, 1, npc.Position, Vector.Zero, npc)
            bomb:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        end
    end

    npc:AnimWalkFrame("WalkHori","WalkVert",0)
    mod:spriteOverlayPlay(sprite, "Walk")

    if sprite:IsFinished("BombHasBeenPlanted") then
        d.typename = "ReadyToExplode"
    elseif sprite:IsFinished("ReadyToExplode") then
        Isaac.Explode(npc.Position, npc, 80)
        npc:Kill()
    end

end

