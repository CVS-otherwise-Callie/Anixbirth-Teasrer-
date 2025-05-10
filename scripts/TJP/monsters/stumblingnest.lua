local mod = FHAC
local game = Game()
local rng = RNG()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.StumblingNest.Var then
        mod:StumblingNestAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.StumblingNest.ID)

function mod:StumblingNestAI(npc, sprite, d)

    if not d.init then
        d.init = true
        d.state = "idle"
        d.webletcooldown = math.random(50,75)
    else
        npc.StateFrame = npc.StateFrame + 1
        d.webletcooldown = d.webletcooldown - 1
    end
    print()
    print()
    print(npc.Position, "Nest")
    print(npc.Velocity)
    print()


    if d.state == "idle" then
        d.targetvelocity = npc.Velocity:Resized(2)
        npc.Velocity = mod:Lerp(npc.Velocity, d.targetvelocity, 0.1)
        mod:spritePlay(sprite, "Walk"..mod:ConvertVectorToWordDirection(npc.Velocity, 1, 1))
        if d.webletcooldown <= 0 then
            d.weblet = Isaac.Spawn(mod.Monsters.Weblet.ID, mod.Monsters.Weblet.Var, mod.Monsters.Weblet.Sub, npc.Position, Vector.Zero, npc)
            d.weblet.Parent = npc
            d.webletsprite = d.weblet:GetSprite()
            d.webletsprite:Play("HeadAppear")
            d.weblet.EntityCollisionClass = 0
            d.webletcooldown = math.random(200,250)
        end
    end

end

