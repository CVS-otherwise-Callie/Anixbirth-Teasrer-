local mod = FHAC
local game = Game()
local sfx = SFXManager()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == 0 and npc.SubType == 0 then
        npc:GetSprite():Play("Idle")
    end
end, mod.Grids.GlobalGridSpawner.ID)

FHAC.LightPressurePlate = StageAPI.CustomGrid("FHACLightPressurePlate", {
    BaseType = GridEntityType.GRID_PRESSURE_PLATE,
    BaseVariant = 0,
    Anm2 = "gfx/grid/lightpressureplate.anm2",
    Animation = "Off",
    RemoveOnAnm2Change = true,
    OverrideGridSpawns = true,
    SpawnerEntity = {Type = FHAC.Grids.GlobalGridSpawner.ID, Variant = 2900}
})

FHAC.AltHomeTrapDoorUnlock = StageAPI.CustomGrid("FHACAltHomeTrapDoorUnlock", {
    BaseType = GridEntityType.GRID_STAIRS,
    BaseVariant = 1,
    Anm2 = "gfx/grid/althomeunlocktrapdoor.anm2",
    Animation = "Closed",
    RemoveOnAnm2Change = true,
    OverrideGridSpawns = true,
    SpawnerEntity = {Type = FHAC.Grids.GlobalGridSpawner.ID, Variant = 2901}
})

FHAC.BreakablePot = StageAPI.CustomGrid("FHACBreakablePot", {
    BaseType = GridEntityType.GRID_STAIRS,
    BaseVariant = 1,
    Anm2 = "gfx/grid/breakablepot.anm2",
    Animation = "pot1",
    RemoveOnAnm2Change = true,
    OverrideGridSpawns = true,
    SpawnerEntity = {Type = FHAC.Grids.GlobalGridSpawner.ID, Variant = 2902}
})

function mod.lightpressurePlateAI(customGrid)
    local grid = customGrid.GridEntity
    local sprite = grid:GetSprite()
    local d = customGrid.PersistentData

    if not d.init then
        grid.State = 3
        grid.VarData = 20
        d.init = true
    end

    if grid.VarData == 1 then
        grid.VarData = 20
    end

    if sprite:IsPlaying("Switched") then
        if not d.switchedinit then
            sfx:Play(469, 1, 0, false, 1, 0)
            d.switchedinit = true
        end
    end

    if sprite:IsPlaying("UnSwitched") then
        if not d.unswitchedinit then
            sfx:Play(469, 1, 0, false, 1, 0)
            d.unswitchedinit = true
        end
    end

    if grid.State == 1 and sprite:GetAnimation() == "On" and #Isaac.FindInRadius(grid.Position, 24, EntityPartition.PLAYER) == 0 and #Isaac.FindInRadius(grid.Position, 9, EntityPartition.ENEMY) == 0 then
        grid.State = 2
    elseif #Isaac.FindInRadius(grid.Position, 9, EntityPartition.ENEMY) ~= 0 or #Isaac.FindInRadius(grid.Position, 24, EntityPartition.PLAYER) ~= 0 then
        grid.State = 4
    end

    if grid.State == 3 then
        d.unswitchedinit = false
        mod:spritePlay(sprite, "Off")
        if mod:CheckForEntInRoom({Type = mod.Monsters.LightPressurePlateEntNull.ID, Variant = mod.Monsters.LightPressurePlateEntNull.Var, SubType = 0}, true, true, false) == false then
            local ent = Isaac.Spawn(mod.Monsters.LightPressurePlateEntNull.ID, mod.Monsters.LightPressurePlateEntNull.Var, 0, Vector.Zero, Vector.Zero, nil)
            ent:GetData().wasSpawned = true
        end
        d.Off = true
    elseif grid.State == 1 then
        d.switchedinit = false
        mod:spritePlay(sprite, "On")
        d.Off = false
    elseif grid.State == 2 then
        mod:spritePlay(sprite, "UnSwitched")
    elseif grid.State == 4 then
        mod:spritePlay(sprite, "Switched")
    end

    if grid.State == 2 then
        if sprite:IsFinished() then
            grid.State = 3
        end
    elseif grid.State == 4 then
        if sprite:IsFinished() then
            grid.State = 1
        end
    end

end

function mod.AltHomeTrapDoorUnlock(customGrid)
    local grid = customGrid.GridEntity
    local sprite = grid:GetSprite()
    local d = customGrid.PersistentData

    local rDD = game:GetLevel():GetCurrentRoomDesc().Data
	local useVar = rDD.Variant

    if not d.init then
        mod.YouCanEndTheAltCutsceneNow = false
        d.knockInit = false
        d.Num = 1
        d.StateFrame = 0
        d.init = true
    else
        d.StateFrame = d.StateFrame + 1
    end

    local function Knock()
        if not d.knockInit then
            d.vecnum = Vector(1.015, 1.05)
            sfx:Play(FHAC.Sounds.AltTrapdoorBang, 1, 2, false, 1, 0)
            d.initnumber = d.StateFrame
            d.knockInit = true
        end
    end

    if d.knockInit then
        d.vecnum = mod:Lerp(d.vecnum, Vector(d.vecnum.X - (d.StateFrame - d.initnumber)/1000, d.vecnum.Y - (d.StateFrame - d.initnumber)/500), 1)
        sprite.Scale = d.vecnum
        if d.vecnum:Distance(Vector(1, 1)) < 0.025 then
            sprite.Scale = Vector(1, 1)
            d.knockInit = false
        end
    end

    local bangtabs = {
        10,
        14,
        34,
        37,
        43,
        73,
        75,
        78,
        110,
        130,
        136,
        161,
        163,
        166,
        201,
        203,
        205,
        207,
    }

    if game:GetLevel():GetAbsoluteStage() == LevelStage.STAGE8 and useVar == 6 and mod.ImInAClosetPleaseHelp then
            if d.StateFrame == bangtabs[d.Num] then
                Knock()
                d.Num = d.Num + 1
            elseif d.StateFrame > bangtabs[#bangtabs] and d.StateFrame%1 == 0 then
                Knock()
            end
    end

    if d.StateFrame > 242 and d.StateFrame < 244 then
        mod.YouCanEndTheAltCutsceneNow = true
    end

end

function mod.lightpressurePlateAIPost(customGrid)
    local grid = customGrid.GridEntity
    local sprite = grid:GetSprite()

    if grid.State == 3 then
        if sprite:IsFinished() then
            grid.State = 2
        end
    elseif grid.State == 4 then
        if sprite:IsFinished() then
            sfx:Play(469, 1, 0, false, 1, 0)
            grid.State = 1
        end
    end

end

StageAPI.AddCallback("FHAC", "POST_CUSTOM_GRID_UPDATE", 1, mod.lightpressurePlateAI, "FHACLightPressurePlate")
StageAPI.AddCallback("FHAC", "POST_CUSTOM_GRID_UPDATE", 1, mod.AltHomeTrapDoorUnlock, "FHACAltHomeTrapDoorUnlock")
StageAPI.AddCallback("FHAC", "POST_SPAWN_CUSTOM_GRID", 1, mod.lightpressurePlateAIPost, "FHACLightPressurePlate")
--StageAPI.AddCallback("FHAC", "POST_SPAWN_CUSTOM_GRID", 1, mod.AltHomeTrapDoorUnlockPost, "FHACAltHomeTrapDoorUnlock")