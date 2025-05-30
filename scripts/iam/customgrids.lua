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
    Anm2 = "gfx/grid/_lightpressureplate.anm2",
    Animation = "Off",
    RemoveOnAnm2Change = true,
    OverrideGridSpawns = true,
    SpawnerEntity = {Type = FHAC.Grids.GlobalGridSpawner.ID, Variant = 2900}
})

FHAC.AltHomeTrapDoorUnlock = StageAPI.CustomGrid("FHACAltHomeTrapDoorUnlock", {
    BaseType = GridEntityType.GRID_STAIRS,
    BaseVariant = 1,
    Anm2 = "gfx/grid/_althomeunlocktrapdoor.anm2",
    Animation = "Closed",
    RemoveOnAnm2Change = true,
    OverrideGridSpawns = true,
    SpawnerEntity = {Type = FHAC.Grids.GlobalGridSpawner.ID, Variant = 2901}
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

    local bangcustomPotTabs = {
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

    if game:GetLevel():GecustomPotTabsoluteStage() == LevelStage.STAGE8 and useVar == 6 and mod.ImInAClosetPleaseHelp then
            if d.StateFrame == bangcustomPotTabs[d.Num] then
                Knock()
                d.Num = d.Num + 1
            elseif d.StateFrame > bangcustomPotTabs[#bangcustomPotTabs] and d.StateFrame%1 == 0 then
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

-- allows stoners to activate StageAPI pressure plates --

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, button)
        local sprite, data = button:GetSprite(), button:GetData()

    for k, v in ipairs(Isaac.FindInRadius(button.Position, 100, EntityPartition.ENEMY)) do
        if v.Type == mod.Monsters.Stoner.ID and v.Variant == mod.Monsters.Stoner.Var and v.Position:DistanceSquared(button.Position) < (20 + v.Size) ^ 2 and not button:GetData().ButtonGridData.Triggered then
            sfx:Play(SoundEffect.SOUND_BUTTON_PRESS)
            button:GetData().ButtonGridData.Triggered = true
            button:GetSprite():Play("Switched", true)

            local currentRoom = StageAPI.GetCurrentRoom()
            if currentRoom then
                local triggerable = currentRoom.Metadata:Search({
                    Groups = currentRoom.Metadata:GroupsWithIndex(data.ButtonIndex),
                    Index = data.ButtonIndex,
                    IndicesOrGroups = true,
                    Tag = "Triggerable"
                })

                for _, metaEnt in ipairs(triggerable) do
                    metaEnt.Triggered = true
                end
            end
        end
    end
end, StageAPI.E.Button.V)


function mod.AllStageAPITrapdoors(customGrid)
    local grid = customGrid.GridEntity

    for k, v in ipairs(Isaac.FindInRadius(grid.Position, 100, EntityPartition.ENEMY)) do
        if v.Type == mod.Monsters.Stoner.ID and v.Variant == mod.Monsters.Stoner.Var and  v.Position:DistanceSquared(v.Position) < (20 + v.Size) ^ 2 then
            sfx:Play(SoundEffect.SOUND_BUTTON_PRESS)
            grid:GetData().ButtonGridData.Triggered = true
            grid:GetSprite():Play("Switched", true)
        end
    end
end

-- Custom Pot --

local customPotTab = {
    {{PickupVariant.PICKUP_KEY, 0, 1}, {PickupVariant.PICKUP_BOMB, 0, 1}},
    {{PickupVariant.PICKUP_BOMB, 0, 2}},
}

mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, function(_, npc)
	if npc.Variant == 161 then
		npc:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK)
		npc.Velocity = Vector.Zero
        npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
	end
end, 292)

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    local d = npc:GetData()
    local sprite = npc:GetSprite()
    local room = game:GetRoom()

    mod:SaveEntToRoom(npc)

    if d.anixbirthDONOTDOANYTHING then

        npc.GridCollisionClass = GridCollisionClass.COLLISION_NONE
        npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        npc:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK)

        if npc.Variant == 950 then

            local var = ""

            if AnixbirthSaveManager.GetSettingsSave().newGrids and AnixbirthSaveManager.GetSettingsSave().newGrids == 1 then
                var = "new"
            end

            sprite:ReplaceSpritesheet(0, "gfx/grid/breakablepots/chapter" .. room:GetBackdropType() .. "/breakablepot" .. var .. ".png")
            sprite:LoadGraphics()

            mod:spritePlay(sprite, "Base")
        end

        return
    end

    if npc.Variant == 950 then

        npc:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK)

        npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL

        local var = ""

        if AnixbirthSaveManager.GetSettingsSave().newGrids and AnixbirthSaveManager.GetSettingsSave().newGrids == 1 then
            var = "new"
        end

        sprite:ReplaceSpritesheet(0, "gfx/grid/breakablepots/chapter" .. room:GetBackdropType() .. "/breakablepot" .. var .. ".png")
        sprite:LoadGraphics()

        if npc.HitPoints/npc.MaxHitPoints > 0.75 then
            d.gridPotLevel = 1
        elseif npc.HitPoints/npc.MaxHitPoints > 0.50 and npc.HitPoints/npc.MaxHitPoints < 0.75 then
            d.gridPotLevel = 2
        elseif npc.HitPoints/npc.MaxHitPoints < 0.5 and npc.HitPoints/npc.MaxHitPoints > 0.1 then
            d.gridPotLevel = 3
        else
            --npc.HitPoints = 0.01
        end

        d.gridPotLevel = d.gridPotLevel or 3

        if npc.HitPoints > 0.1 then
            mod:spritePlay(sprite, "Stage" .. d.gridPotLevel)
        else
            mod:spritePlay(sprite, "Base")
        end
    end
end, 753)

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, npc, amount, flags)

    local d = npc:GetData()
    local sprite = npc:GetSprite()

    if d.anixbirthDONOTDOANYTHING then
        return
    end

    if npc.Variant == 950 then
        
		local amt = math.min(math.max(math.floor(amount / 60), 1), 3)
        if npc.HitPoints - amt <= 1 or flags & (DamageFlag.DAMAGE_TNT | DamageFlag.DAMAGE_EXPLOSION) ~= 0 then
            for k, v in ipairs(customPotTab[math.random(#customPotTab)]) do
                for i = 1, v[3] do
                    if v[1] == 20 then
                        Isaac.Spawn(5, 20, 0, npc.Position, RandomVector()*math.random(2,5), nil)
                    else
                        Isaac.Spawn(EntityType.ENTITY_PICKUP, v[1], v[2], npc.Position, RandomVector()*math.random(2,5), nil)
                    end
                end
            end

            for i = 1, math.random(3, 5) do
                local bucketGib = Isaac.Spawn(1000, 4, 0, npc.Position, Vector(math.random(15,30)/10, 0):Rotated(i*75 + math.random(45)), nil)
                bucketGib:GetSprite():SetFrame("rubble_alt", math.random(4))
                bucketGib:SetColor(Color(2, 1, 1, 1, 0, 0,0,0), 5, 2, true, false)
                bucketGib:Update()

                local ef = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DUST_CLOUD, -1, npc.Position + Vector(math.random(-25, 25), 10),Vector.Zero, npc):ToEffect()
                ef:SetTimeout(50)
                ef.SpriteScale = Vector(0.05,0.05)
                ef:Update()
            end
            npc:ToNPC():PlaySound(78, 1, 0, false, 1)

            d.anixbirthDONOTDOANYTHING = true
        else

            local bucketGib = Isaac.Spawn(1000, 4, 0, npc.Position, Vector(math.random(15,30)/10, 0):Rotated(math.random(360)), nil)

            local ef = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DUST_CLOUD, -1, npc.Position + Vector(math.random(-25, 25), 10),Vector.Zero, npc):ToEffect()
            ef:SetTimeout(10)
            ef.SpriteScale = Vector(0.03,0.03)

            bucketGib:GetSprite():SetFrame("rubble_alt", math.random(4))
            bucketGib:SetColor(Color(2, 1, 1, 1, 0, 0,0,0), 5, 2, true, false)
            bucketGib:Update()

            npc:ToNPC():PlaySound(SoundEffect.SOUND_SCYTHE_BREAK, 0.5, 0, false, 0.3)


            npc.HitPoints = npc.HitPoints - amt
        end
        return false
    end

end, 753)


StageAPI.AddCallback("FHAC", "POST_CUSTOM_GRID_UPDATE", 1, mod.lightpressurePlateAI, "FHACLightPressurePlate")
StageAPI.AddCallback("FHAC", "POST_CUSTOM_GRID_UPDATE", 1, mod.AltHomeTrapDoorUnlock, "FHACAltHomeTrapDoorUnlock")
StageAPI.AddCallback("FHAC", "POST_SPAWN_CUSTOM_GRID", 1, mod.lightpressurePlateAIPost, "FHACLightPressurePlate")
--StageAPI.AddCallback("FHAC", "POST_SPAWN_CUSTOM_GRID", 1, mod.AltHomeTrapDoorUnlockPost, "FHACAltHomeTrapDoorUnlock")