local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.Dunglivery.Var then
        mod:DungliveryAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.Dunglivery.ID)

mod.DungliveryEnts = {
    {EntityType.ENTITY_DIP, -1},
    {EntityType.ENTITY_DRIP, 0},
    {EntityType.ENTITY_MAGGOT, -1},
    {EntityType.ENTITY_SMALL_MAGGOT, -1},
    {EntityType.ENTITY_LEECH, 0},
    {EntityType.ENTITY_SPITTY, 0},
    {EntityType.ENTITY_CONJOINED_SPITTY, 0}
}

if FiendFolio then

    mod.FiendFolioDungliveryEnts = {
        {FiendFolio.FF.Morsel.ID, FiendFolio.FF.Morsel.Var},
        {FiendFolio.FF.Limb.ID, FiendFolio.FF.Limb.Var},
        {FiendFolio.FF.PaleLimb.ID, FiendFolio.FF.PaleLimb.Var},
        {FiendFolio.FF.Drumstick.ID, FiendFolio.FF.Drumstick.Var},
        {FiendFolio.FF.Spooter.ID, FiendFolio.FF.Spooter.Var},
        {FiendFolio.FF.SuperSpooter.ID, FiendFolio.FF.SuperSpooter.Var},
        {FiendFolio.FF.Spark.ID, FiendFolio.FF.Spark.Var},
        {FiendFolio.FF.Buoy.ID, FiendFolio.FF.Buoy.Var},
        {FiendFolio.FF.Litling.ID, FiendFolio.FF.Litling.Var},
        {FiendFolio.FF.RolyPoly.ID, FiendFolio.FF.RolyPoly.Var},
        {FiendFolio.FF.Shiitake.ID, FiendFolio.FF.Shiitake.Var},
        {FiendFolio.FF.Smidgen.ID, FiendFolio.FF.Smidgen.Var},
        {FiendFolio.FF.RedSmidgen.ID, FiendFolio.FF.RedSmidgen.Var},
        {FiendFolio.FF.ErodedSmidgen.ID, FiendFolio.FF.ErodedSmidgen.Var},
        {FiendFolio.FF.ErodedSmidgenNaked.ID, FiendFolio.FF.ErodedSmidgenNaked.Var},
        {FiendFolio.FF.Frowny.ID, FiendFolio.FF.Fronwy.Var},
        {FiendFolio.FF.Tot.ID, FiendFolio.FF.Tot.Var},
        {FiendFolio.FF.CreepyMaggot.ID, FiendFolio.FF.CreepyMaggot.Var},
        {FiendFolio.FF.Drop.ID, FiendFolio.FF.Drop.Var},
        {FiendFolio.FF.Offal.ID, FiendFolio.FF.Offal.Var},
        {FiendFolio.FF.DriedOffal.ID, FiendFolio.FF.DriedOffal.Var},
        {FiendFolio.FF.Glob.ID, FiendFolio.FF.Glob.Var},
        {FiendFolio.FF.Sternum.ID, FiendFolio.FF.Sternum.Var},
        {FiendFolio.FF.Blot.ID, FiendFolio.FF.Blot.Var},
        {FiendFolio.FF.SpicyDip.ID, FiendFolio.FF.SpicyDip.Var},
        {FiendFolio.FF.Magleech.ID, FiendFolio.FF.Magleech.Var},
        {FiendFolio.FF.Organelle.ID, FiendFolio.FF.Organelle.Var},
        {FiendFolio.FF.InnerEye.ID, FiendFolio.FF.InnerEye.Var},
    }

    mod:MixTables(mod.DungliveryEnts, FHAC.FiendFolioDungliveryEnts)
end

function mod:DungliveryAI(npc, sprite, d)

    local target = npc:GetPlayerTarget()
    local targetpos = target.Position
    local room = game:GetRoom()
    local path = npc.Pathfinder

    if not d.init then
        d.state = "idle"
        d.speed = 1

        npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS

        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    local function GetSmallEnt()
        local tab = {}
        for k, v in ipairs(mod.DungliveryEnts) do
            local ent = mod:GetSpecificEntInRoom({ID = v[1], Var = v[2]}, npc, 1000)
            if not d.specificTargTypeIsPlayer then
                table.insert(tab, ent)
            end
        end
        return tab[math.random(#tab)]
    end

    if not d.ent or d.ent:IsDead() or not d.ent:Exists() then
        d.state = "idle"
    elseif d.state == "idle" and d.ent then
        d.state = "moving"
        npc.StateFrame = 0
    elseif d.state == "moving" then

        targetpos = d.ent.Position

        if mod:isScare(npc) then
            local targetvelocity = (targetpos - npc.Position):Resized(-4)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, d.speed)
        elseif room:CheckLine(npc.Position,target.Position,0,1,false,false) then
            local targetvelocity = (targetpos - npc.Position):Resized(4)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, d.speed)
        else
            local targetvelocity = (targetpos - npc.Position):Resized(2)
            npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, d.speed)
            path:FindGridPath(target.Position, 0.5, 1, true)
        end 

        if npc.Position:Distance(d.ent.Position) < 5 then
            d.state = "pickup"
        end

    end

    if d.state == "idle" then
        mod:spritePlay(sprite, "Idle")
        npc:MultiplyFriction(0.5)

        if npc.StateFrame > 30 then
            d.ent = GetSmallEnt()
        end
    end

    if npc.Velocity:Length() > 1 and d.state == "idle" or d.state == "moving" then
        mod:spritePlay(sprite, "FlySide")
    end --
end

