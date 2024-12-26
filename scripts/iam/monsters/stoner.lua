local mod = FHAC
local game = Game()
local rng = RNG()
local sfx = SFXManager()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.Stoner.Var then
        mod:StonerAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.Stoner.ID)

function mod:StonerAI(npc, sprite, d)

    local room = game:GetRoom()

    mod:SaveEntToRoom({
        Name="Stoner",
        NPC = npc,
    })

    if not d.init then
        d.face = d.face or math.random(100)
        sprite:SetFrame("Idle", d.face)
        npc.GridCollisionClass = GridCollisionClass.COLLISION_WALL_EXCEPT_PLAYER
        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
        npc:MultiplyFriction(0.6)
    end

    for i = 0, room:GetGridSize() do  
        if room:GetGridEntity(i) ~= nil and room:GetGridEntity(i):GetType() == 20 then
            if npc.Position:Distance(room:GetGridEntity(i).Position) < 30 then
                local grid = room:GetGridEntity(i)
                local sprite = grid:GetSprite()
                if sprite:IsPlaying("Off") then
                    mod:spritePlay(sprite, "Switched")
                    sfx:Play(469, 1, 0, false, 1, 0)
                end
                grid:ToPressurePlate().State = 3
                grid:Update()
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, npc)
    if npc.Type == mod.Monsters.Stoner.ID and npc.Variant == mod.Monsters.Stoner.Var then
        return false
    end
end, mod.Monsters.Stoner.ID)


