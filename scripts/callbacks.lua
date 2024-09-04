local mod = FHAC
local game = Game()

function mod.DeathStuff(_, ent)
    mod.ShowFortuneDeath()
    mod.SchmootDeath(ent)
end
FHAC:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.DeathStuff)

function mod.PostUpdateStuff()
    if not FHAC.FiendFolioCompactLoaded then
        mod.FiendFolioCompat()
    end
end
FHAC:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.PostUpdateStuff)

function mod.PlayersTearsPostUpdate(_, t)
    mod.FloaterTearUpdate(t)
end
FHAC:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, mod.PlayersTearsPostUpdate)

function mod:ProjStuff(v)
	local d = v:GetData();

	mod.SyntheticHorfShot(v, d)
    mod.WostShot(v, d)
end
FHAC:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, mod.ProjStuff)

function mod:ProjCollStuff(v,c)
    local d = v:GetData();

    mod.RemoveWostProj(v, c, d)
end

mod:AddCallback(ModCallbacks.MC_PRE_PROJECTILE_COLLISION, mod.ProjCollStuff)

function mod:RenderedStuff()
    if not FiendFolio then
        mod.ShowRoomText()
    end
    mod.JohannesPostRender()
end
mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.RenderedStuff)