local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.StickyFly.Var then
        mod:StickyFlyAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.StickyFly.ID)

mod.StickyFlyListOfSubjects = {
    {ID = EntityType.ENTITY_GAPER,Var = 0,Sub=0},
    {ID = EntityType.ENTITY_FATTY,Var = 0,Sub=0},
    mod:ENT("Slim"),
    mod:ENT("Patient"),
}

local function CheckEntsInListToNPC(table, element)
    for _, ent in ipairs(table) do
        if ent.Var == -1 then ent.Var = 0 end
        if ent.Sub == -1 then ent.Sub = 0 end
        if ent.ID == element.Type and ent.Var == element.Variant and ent.Sub == element.SubType then
            return true
        else
        end
    end
end

function mod:StickyFlyAI(npc, sprite, d)

    local function stickyflyGetEnt()
        local targets = {}
        for _, ent in ipairs(Isaac.GetRoomEntities()) do
            if not ent:IsDead()
            and not ent:HasEntityFlags(EntityFlag.FLAG_FRIENDLY)
            and CheckEntsInListToNPC(mod.StickyFlyListOfSubjects, ent)
            and ent.Parent ~= npc  then
                table.insert(targets, ent)
            end
        end
        if (#targets == 0) then
            d.baby = npc:GetPlayerTarget()
        else
            d.baby = targets[math.random(1, #targets)]
        end
    end
    

    if not d.init then
        stickyflyGetEnt()

        d.moveoffset = 0
        d.wobb = 0
        d.moveit = 0

        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    local target = d.baby

    if d.moveit >= 360 then d.moveit = 0 else d.moveit = d.moveit + 0.05 end
    local vel = mod:GetCirc(20, d.moveit)

    npc.Velocity = mod:Lerp(npc.Velocity, target.Position - npc.Position, 0.5)
    npc.Velocity = npc.Velocity:Normalized() + npc.Velocity * 2.05
    npc.Velocity = mod:Lerp(npc.Velocity, Vector(npc.Position.X - vel.X, npc.Position.Y - vel.Y) - npc.Position, 0.5)
    npc:MultiplyFriction(0.3)

    if npc.StateFrame > 100 then
        npc.StateFrame = 0
        stickyflyGetEnt()
    end

end

