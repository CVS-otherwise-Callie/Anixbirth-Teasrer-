local mod = FHAC
local game = Game()
local ms = MusicManager()

function mod:CoralTearAI(tear, sprite, d)

    d.height = d.height or tear.Height
    tear.Height = d.height
    tear:ToTear().FallingAcceleration = 0
    tear:ToTear().FallingSpeed = 0

    tear.TearFlags = tear.TearFlags | TearFlags.TEAR_BONE

    sprite:Load("gfx/tears/coralshards.anm2", true)

    if not d.init then
        if math.random(1, 2) == 2 then
            sprite.FlipX = true
        end
        d.num = math.random(1, 6)
        d.offs = 0
        d.init = true
    end

    if tear.FrameCount%20 == 0 then
        d.offs = math.random(-3, 3)
    end

    tear.SpriteOffset = mod:Lerp(tear.SpriteOffset, Vector(0, d.offs), 0.01)

    sprite:Play("Idle" .. d.num)

    tear:MultiplyFriction(0.8)

end