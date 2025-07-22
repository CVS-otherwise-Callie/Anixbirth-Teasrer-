function IsMoQu:LoadScripts(includestart, t)
    for k, v in ipairs(t) do
        if includestart then v= includestart.."." .. v end
        include(v)
    end
end

if StageAPI and StageAPI.Loaded then
    IsMoQu:LoadScripts("quizscripts", {
        "savedata",
        "constants",
        "quizapi",
        "misc.custombuttons",
        "questions.quesmain",
        "deadseascrolls.dssmain"
    })

else
	include("quizscripts.misc.warning")
end