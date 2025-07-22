local mod = FHAC
local sfx = SFXManager()
local game = Game()

--having fun trying to be ffg
local stats = {
    timer = 30,
    form = 1,
    gridcoll = 1,
    scale = 1,
    radius = 20,
    friction = 0.9, --eh
    rebirthdeath = false,
    griddeath = false,
    deathtime = 10,
    damage = 1
}

mod.CVSFires = {}

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, effect)
    if effect.Variant == mod.Effects.CVSFire.Var then
        mod:CVSFireAI(effect, effect:GetSprite(), effect:GetData())
    end
end)

function mod:CVSFireAI(ef, sprite, d)

    if not d.init then

        for name, stat in pairs(stats) do
            d[name] = d[name] or stat
        end

        if d.form == 1 then -- normal fire
            sprite:ReplaceSpritesheet(0, "gfx/effects/effect_005_fire.png")
        elseif d.form == 2 then
            sprite:ReplaceSpritesheet(0, "gfx/effects/effect_005_fire_red.png")
        elseif d.form == 3 then
            sprite:ReplaceSpritesheet(0, "gfx/effects/effect_005_fire_blue.png")
        end

		d.SpriteScale = ef.SpriteScale * d.scale

        ef.CollisionDamage = 1

        sprite:LoadGraphics()
        d.init = true
    end

    local frameC = ef.FrameCount

	if frameC > 3 and frameC < (d.timer + 5) and (ef.InitSeed + frameC) % 3 == 0 then --oh god i thought i didnt need this thank you so much ff :sob:
		table.insert(mod.CVSFires, ef)
	end

    if frameC < 5 then
        ef.SpriteScale = d.SpriteScale * frameC / 5
    elseif frameC > d.timer then

        if d.rebirthdeath then
            sprite:Play("Disappear")
        end

        ef.SpriteScale = d.SpriteScale * (1 - (frameC - d.timer)/(d.deathtime + 10))

        ef.Color = Color(ef.Color.R, ef.Color.G, ef.Color.B, 1 - ((frameC - d.timer)/d.deathtime), ef.Color.RO, ef.Color.GO, ef.Color.BO) -- DONT.
    	if frameC > d.timer + 10 then
			ef:Remove()
		end
    else
        if d.griddeath then
            
        end
    end

    ef:MultiplyFriction(d.friction)

end

function FHAC:ShootFire(position, velocity, stat)

    stat = stat or {}

    local fire = Isaac.Spawn(1000, mod.Effects.CVSFire.Var, 0, position, velocity, nil)

    for name, states in pairs(stat) do
        fire:GetData()[name] = fire:GetData()[name] or states
    end
end