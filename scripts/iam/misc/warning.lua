local mod = FHAC
local game = Game()

local warningText = {
	"    ---------------------ERROR-----------------------",
    "      HOPE (Anixbirth) was unable to load properly!",
    "This MOD requires both REPENTOGON and StageAPI to function!",
    "      Please install both MODs and come back soon. :3",
	"    ---------------------ERROR-----------------------",
}

-- Log + console error
for i, line in pairs(warningText) do
	Isaac.DebugString(line)
	print(line)
end

mod.LuaFont = Font()
mod.LuaFont:Load("font/luaminioutlined.fnt")

function mod:WARN()
    if game.TimeCounter%5 ~= 0 then
	local x = Isaac.GetScreenWidth() / 5 + 5
	local y = Isaac.GetScreenHeight() / 3 -90

	for i, line in pairs(warningText) do
		mod.LuaFont:DrawStringScaled(line, x - (1/2), y + (16*i), 1, 1, KColor(1,1,1,0.5), 0, false)
    end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.WARN)