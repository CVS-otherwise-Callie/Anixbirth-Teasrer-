local mod = FHAC
local game = Game()
local ms = MusicManager()

function mod:CoralTearRenderAI(tear, sprite, d)

    d.height = d.height or tear.Height
    tear.Height = d.height

    sprite = Sprite()
    sprite:Load("gfx/tears/coralshards.anm2", true)
    sprite:SetFrame("Idle", math.random(1, 1))

    tear:MultiplyFriction(0.95)

end