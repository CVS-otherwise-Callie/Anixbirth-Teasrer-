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
    mod.ErrorRoomSubtype = ef.SubType+1

    local room = Game:GetRoom()
    local player = Isaac.GetPlayer()

    local num = 0

    if mod.ErrorRoomSubtype == 1 then

        ms:Play(Isaac.GetMusicIdByName("chairsong"), 1)

        if not d.init then
            for j = 1, 100 do
                mod.scheduleCallback(function()

                    num = num + 1


                    local str = "[extinct]"

                    if not player then return end

                    local pos = Game():GetRoom():WorldToScreenPosition(player.Position) + Vector(mod.TempestFont:GetStringWidth(str) * -0.5, -(player.SpriteScale.Y * 35) - j/3 - 15)
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
            game:GetRoom():SetBackdropType(Isaac.GetBackdropIdByName("Error Room Chair"), 1)
            for i = 1, game:GetNumPlayers() do
                local player = Isaac.GetPlayer(i)

                player.GridCollisionClass = 0
                player.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
            end
            AnixbirthSaveManager.GetRunSave().anixbirthsaveData.ReturnPlayersToColl5 = true
        end

    end
end

function mod:CVSnilNPC(npc, sprite, d)

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
    end
    
end

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, pickup)
    local d = pickup:GetData()
    if d.isChairPickup then
        pickup.GridCollisionClass = 0

        pickup.Velocity = Vector(1, 0)
    end
end)