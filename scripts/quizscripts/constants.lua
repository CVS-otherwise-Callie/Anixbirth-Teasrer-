local mod = IsMoQu

function IsMoQu:ENT(name)
    return { ID = Isaac.GetEntityTypeByName(name), Var = Isaac.GetEntityVariantByName(name), Sub = 0 }
end

IsMoQu.TempestFont = Font()
IsMoQu.TempestFont:Load("font/pftempestasevencondensed.fnt")

mod.Challenges = {
    Quiz = Isaac.GetChallengeIdByName("The Isaac Modding Quiz")
}

mod.Ents = {
    QuizQuestionPlacement = mod:ENT("Quiz Question Placement")
}

mod.Grids = {
    GlobalGridSpawner = mod:ENT("IsMoQu Custom Grid Spawn")
}