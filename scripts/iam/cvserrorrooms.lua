local game = Game()
local sfx = SFXManager()
local mod = FHAC
local ms = MusicManager()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Type == mod.NPCS.BlankNPC.ID and npc.Variant == mod.NPCS.BlankNPC.Var then
        mod:CVSnilNPC(npc, npc:GetSprite(), npc:GetData())
    elseif npc.Type == mod.NPCS.ErrorRoomEditor.ID and npc.Variant == mod.NPCS.ErrorRoomEditor.Var then
        mod:CVSErrorRoomEditor(npc, npc:GetSprite(), npc:GetData())
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
    mod:CVSErrorRoomEditorRender()
end)

local function FindClosestTear(npc)
    local dist = 999999999
    local tr
    for _, ent in ipairs(Isaac.GetRoomEntities()) do
        if ent.Type == 2 then
            if ent.Position:Distance(npc.Position) < dist then
                tr = ent
                dist = ent.Position:Distance(npc.Position)
            end
        end
    end
    return tr
end

function mod:CVSErrorRoomEditor(ef, sprite, d)

    ef.CanShutDoors = false

    mod.ErrorRoomSubtype = ef.SubType+1

    local player = Isaac.GetPlayer()

    local num = 0

    ef:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
    ef:AddEntityFlags(EntityFlag.FLAG_NO_QUERY)

    if mod.ErrorRoomSubtype == 1 then

        if not d.init then
            for j = 1, 100 do
                mod.scheduleCallback(function()

                    num = num + 1


                    local str = "THE WORLD REVOLVING but it's just the mcdonalds beeping sound"

                    if not player then return end

                    local pos = Game():GetRoom():WorldToScreenPosition(game:GetRoom():GetCenterPos()) + Vector(mod.TempestFont:GetStringWidth(str) * -0.5, -(player.SpriteScale.Y * 35) - j/3 - 15)
                    local opacity
                    local cap = 50
                    if j >= cap then
                        opacity = 1 - ((j-cap)/50)
                    else
                        opacity = j/cap
                    end
                    --Isaac.RenderText(str, pos.X, pos.Y, 1, 1, 1, opacity)
                    mod.TempestFont:DrawString(str, pos.X, pos.Y, KColor(1,1,1,opacity), 0, false)
                end, j, ModCallbacks.MC_POST_RENDER, false)
            end
            d.init = true
        else
            if ms:GetCurrentMusicID() ~= Isaac.GetMusicIdByName("chairsong") then
                ms:Play(Isaac.GetMusicIdByName("chairsong"), 1)
            end
        end

    elseif mod.ErrorRoomSubtype == 2 then

        local roomDat = AnixbirthSaveManager.GetRoomSave().anixbirthsaveData

        for i = 1, game:GetNumPlayers() do
            local player = Isaac.GetPlayer(i)

            player.GridCollisionClass = 0
            player.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
        end
        AnixbirthSaveManager.GetRunSave().anixbirthsaveData.ReturnPlayersToColl5 = true

        game:GetRoom():SetBackdropType(Isaac.GetBackdropIdByName("Error Room Mario Paint"), 1) 

        roomDat.MarioPaintPoses = roomDat.MarioPaintPoses or {}

        roomDat.MarioPaintColor = roomDat.MarioPaintColor or 1

        local listofColors = {
            Color(1, 1, 0, 1),
            Color(0, 1, 1, 1),
            Color(1, 0, 1, 1)
        }

        for i = 1, game:GetNumPlayers() do
            local player = Isaac.GetPlayer(i)

            local color = listofColors[roomDat.MarioPaintColor]

            if Input.IsButtonPressed(Keyboard.KEY_ENTER, player.ControllerIndex) then 
                roomDat.MarioPaintPoses[tostring(player.Position)] = {player.Position, player, color, #roomDat.MarioPaintPoses+1}
            elseif Input.IsButtonPressed(Keyboard.KEY_RIGHT_SHIFT, player.ControllerIndex) or Input.IsButtonPressed(Keyboard.KEY_LEFT_SHIFT, player.ControllerIndex) then 

                for name, pos in pairs(roomDat.MarioPaintPoses) do
                    if (player.Position + Vector(0, -10)):Distance(pos[1]) < 10 then
                        roomDat.MarioPaintPoses[name] = nil
                    end
                end

            elseif Input.IsButtonPressed(Keyboard.KEY_DELETE, player.ControllerIndex) or Input.IsButtonPressed(Keyboard.KEY_BACKSPACE, player.ControllerIndex) then 
                roomDat.MarioPaintPoses = {}
                roomDat.MarioErasePoses = {}
            elseif Input.IsButtonTriggered(Keyboard.KEY_T, player.ControllerIndex) then
                Isaac.GridSpawn(GridEntityType.GRID_TRAPDOOR, 0, player.Position + Vector(50, 0), true)
            elseif Input.IsButtonPressed(Keyboard.KEY_H, player.ControllerIndex) then
                if mod.HasPressedHMarioPaint == true then return end
                mod.HasPressedHMarioPaint = true
                if not roomDat.HideMarioPaintHints then
                    roomDat.HideMarioPaintHints = true
                else
                    roomDat.HideMarioPaintHints = false
                end
            end
            if not Input.IsButtonPressed(Keyboard.KEY_H, player.ControllerIndex) then
                mod.HasPressedHMarioPaint = false
            end
            if Input.IsButtonPressed(Keyboard.KEY_PERIOD, player.ControllerIndex) then 
                if roomDat.HasPressedPeriodMarioPaint == true then return end
                roomDat.MarioPaintColor = roomDat.MarioPaintColor + 1
                roomDat.HasPressedPeriodMarioPaint = true
            elseif not Input.IsButtonTriggered(Keyboard.KEY_PERIOD, player.ControllerIndex) then 
                roomDat.HasPressedPeriodMarioPaint = false
            end
            if Input.IsButtonPressed(Keyboard.KEY_COMMA, player.ControllerIndex) then
                if roomDat.HasPressedCommaMarioPaint == true then return end
                roomDat.MarioPaintColor = roomDat.MarioPaintColor - 1
                roomDat.HasPressedCommaMarioPaint = true
            elseif not Input.IsButtonTriggered(Keyboard.KEY_COMMA, player.ControllerIndex) then
                roomDat.HasPressedCommaMarioPaint = false
            end

            if roomDat.MarioPaintColor == 0 then
                roomDat.MarioPaintColor = #listofColors
            elseif roomDat.MarioPaintColor > #listofColors then
                roomDat.MarioPaintColor = 1
            end
        end

        if ms:GetCurrentMusicID() ~= Isaac.GetMusicIdByName("creatuveexercise") then
            ms:Play(Isaac.GetMusicIdByName("creatuveexercise"), 1)
        end        
    end
end

function mod:CVSErrorRoomEditorRender()

    local roomDat = AnixbirthSaveManager.GetRoomSave().anixbirthsaveData

    if roomDat and roomDat.MarioPaintPoses then

        for name, pos in pairs(roomDat.MarioPaintPoses) do

            if not pos[3] then return end

            local sprite = Sprite()

            sprite:Load("gfx/jokes/shhhh go away/dot.anm2", true)
            sprite:Play(sprite:GetDefaultAnimation())
            sprite.Color = pos[3]
            sprite:Render(Isaac.WorldToScreen(pos[1]), Vector.Zero, Vector.Zero)
        end
    end

    local opacity = 1

    if roomDat and roomDat.HideMarioPaintHints == true then
        opacity = 0
    end


    if mod.ErrorRoomSubtype == 2 then
        local str = "Keys:"
        local str2 = "Hold ENTER to DRAW"
        local str5 = "Hold SHIFT to ERASE"
        local str3 = "Press < or > to CHANGE COLOR"
        local str4 = "Press DELETE or BACKSPACE to CLEAR SELECTION"
        local str6 = "Press T to SPAWN TRAPDOOR"
        local str7 = "Press H to HIDE and SHOW these rules"

        local pos = Game():GetRoom():WorldToScreenPosition(Vector(100, 130) + Vector(mod.TempestFont:GetStringWidth(str) * -0.5, -35))
        --Isaac.RenderText(str, pos.X, pos.Y, 1, 1, 1, opacity)
        mod.TempestFont:DrawString(str, pos.X, pos.Y, KColor(1,1,1,opacity), 0, false)
        mod.TempestFont:DrawString(str2, pos.X, pos.Y + 10, KColor(1,1,1,opacity), 0, false)
        mod.TempestFont:DrawString(str5, pos.X, pos.Y + 20, KColor(1,1,1,opacity), 0, false)
        mod.TempestFont:DrawString(str3, pos.X, pos.Y + 30, KColor(1,1,1,opacity), 0, false)
        mod.TempestFont:DrawString(str4, pos.X, pos.Y + 40, KColor(1,1,1,opacity), 0, false)
        mod.TempestFont:DrawString(str6, pos.X, pos.Y + 50, KColor(1,1,1,opacity), 0, false)
        mod.TempestFont:DrawString(str7, pos.X, pos.Y + 60, KColor(1,1,1,opacity), 0, false)
    end
end

function mod:CVSnilNPC(npc, sprite, d)

    npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)

    local roomEr = mod.ErrorRoomSubtype

    if not roomEr then return end

    if roomEr == 1 then

        if npc.SubType == 0 then

            --sprites--
            if not d.init then

                sprite:Load("gfx/jokes/shhhh go away/secretchair.anm2", true)
                sprite:LoadGraphics()
                d.randomWait = math.random(1, 10)

                npc.EntityCollisionClass = 0
                d.init = true
            else
                npc.StateFrame = npc.StateFrame + 1
            end

            game:GetRoom():SetBackdropType(Isaac.GetBackdropIdByName("Error Room Chair"), 1)
            for i = 1, game:GetNumPlayers() do
                local player = Isaac.GetPlayer(i)

                player.GridCollisionClass = 0
                player.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
            end
            AnixbirthSaveManager.GetRunSave().anixbirthsaveData.ReturnPlayersToColl5 = true

            --code--

            if not d.shotAt and npc.StateFrame > d.randomWait then
                mod:spritePlay(sprite, "Idle")
            else
                mod:spritePlay(sprite, "Glow")
            end

            if sprite:IsFinished("Glow") then
                local pickup = Isaac.Spawn(5, 0, 0, npc.Position, Vector.Zero, nil)
                pickup:GetData().isChairPickup = true
                npc:Remove()
            end

            --tears--

            local tear = FindClosestTear(npc)

            if tear and math.abs(mod:GetTrueAngle((tear.Position - tear.SpawnerEntity.Position):GetAngleDegrees()) - mod:GetTrueAngle((npc.Position - tear.SpawnerEntity.Position):GetAngleDegrees())) < 50 then
                d.shotAt = true
            end
        elseif npc.SubType == 1 then
            if not d.init then

                npc.EntityCollisionClass = 0
                npc.GridCollisionClass = 0
                sprite:Load("gfx/jokes/shhhh go away/secretchair.anm2", true)
                sprite:LoadGraphics()

                mod:spritePlay(sprite, "ILikeChairs")
                npc.SortingLayer = SortingLayer.SORTING_BACKGROUND
                d.tilt = -2
                d.init = true
            else
                local targvel = mod:diagonalMove(npc, 8, 1)
                local tiltCalc = Vector(targvel.X, 0):Resized(-1) * d.tilt
                targvel = (targvel + tiltCalc):Resized(5)

                if npc:CollidesWithGrid() then
                    d.tilt = d.tilt * -1
                end

                if npc.StateFrame % 2 == 0 then
                    npc.Velocity = mod:Lerp(npc.Velocity, targvel, 0.5)
                end

                local var = (math.ceil(npc.Velocity:Length()-3))
                if var <= 0 then var = (var*-1)+1 end
            end
        end
    elseif roomEr == 3 then

        if not d.hasSpawnedBottom then
            local SixheadBottom = Isaac.Spawn(mod.Monsters.SixheadBottom.ID, mod.Monsters.SixheadBottom.Var, 0, npc.Position, npc.Velocity, nil):ToNPC()
            local spr = SixheadBottom:GetSprite()

            spr:Load("gfx/jokes/shhhh go away/disk.anm2", true)
            spr:LoadGraphics()

            spr:Play("Idle")

            SixheadBottom.CanShutDoors = false
            SixheadBottom.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            SixheadBottom:Update()
            SixheadBottom.DepthOffset = -500

            d.hasSpawnedBottom = true
        else
            npc:Remove()
        end

        game:GetRoom():SetBackdropType(Isaac.GetBackdropIdByName("Error Room Chair"), 1)
        for i = 1, game:GetNumPlayers() do
            local player = Isaac.GetPlayer(i)

            player.GridCollisionClass = 0
            player.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
        end
        AnixbirthSaveManager.GetRunSave().anixbirthsaveData.ReturnPlayersToColl5 = true
    end
    
end

function mod:CVSnilNPCRender(npc, sprite, d)
end

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, pickup)
    local d = pickup:GetData()
    if d.isChairPickup then
        pickup.GridCollisionClass = 0

        pickup.Velocity = Vector(1, 0)
    end
end)

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, npc, amount, flags, damage)
    if npc.Type == mod.NPCS.ErrorRoomEditor.ID and npc.Variant == mod.NPCS.ErrorRoomEditor.Var then
        if damage then
            return false
        end
    end
end)