FHAC = RegisterMod("Fivehead", 1)
local json = require("json")
local room = Game():GetRoom()
local mod = FHAC
local game = Game()
local rng = RNG()
local settings
local stealingUpdate

FHAC.Scripts = {
	Savedata = include("scripts.savedata"),
	Library = include("scripts.library"),
	Constants = include("scripts.constants"),
	Items = include("scripts.items"),
	IamScripts = include("scripts.iam.main"),
	
	Misc = {
		Fortunes = include("scripts.stolen.fiend folio.api.fortunehandling"),
		include("scripts.stolen.fiend folio.apioverride"),
		include("scripts.iam.misc.resources.fortunes"),
	},

}
--ff
FHAC.savedata = FHAC.savedata or {}

--Bomber Boi
local BB = Isaac.GetChallengeIdByName("[ANIX] Bomber Boi")
local frick = {}
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(continued)
    if Isaac.GetChallenge() == BB then
    stealingUpdate = true
        if not continued then
            stealingUpdate = true
            local player = Isaac.GetPlayer()
            player:AddBombs(-1)
            player:AddCoins(3)
        end


game:GetSeeds():AddSeedEffect(77)
---@param tear EntityTear
---@param player EntityPlayer
function frick:agh(tear, player)
        
	    tear:Remove()
	    local uh = player
     if rng:RandomInt(5) >= 4 then
		    Isaac.Spawn(EntityType.ENTITY_BOMB, rng:RandomInt(20), 0,  room:GetRandomPosition(1), tear.Velocity, nil):ToTear()
     elseif rng:RandomInt(5) == 1 then
        Isaac.Spawn(EntityType.ENTITY_BOMB, 3, 0,  room:GetRandomPosition(1), tear.Velocity, nil):ToTear()	
     end
    end
if Isaac.GetChallenge() == BB then       
    mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, frick.agh)
end
end
end)

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--savedata (srappy) dont you just love savedata? I know i do. That's why we created this piece of utter shit. someone get me out of here i cant stand it i think im going to explode if i infish this sentence thus this senatcne must go on into ternity, while we suffer in the pain of things. things? oh i dont evemn knwo. but i think i have an idea. let me tell a story of brownies ERROR 404 Brain.exe is unable to load. here is a recipe for brownies: 2 eggs water unsweetened  cocoa powder oil vanilla  extract First, mix together the dry and wet ingredients in two separate bowls. Combine the sugar, flour, powdered sugar, cocoa powder, chocolate chips, and salt in a medium bowl. Then, whisk together the eggs, olive oil, and water in a large one. Next, combine the wet and dry ingredients. Sprinkle the dry mixture over the wet one, and fold until just combined. The batter will be thick! Then, pour the batter into an 8×8 inch baking pan lined with parchment paper. Use a rubber spatula to spread it to all four sides of the pan and to smooth the top. The mixture will be very thick – that’s ok  Finally, bake! Transfer the pan to a 325-degree oven and bake for 40 to 45 minutes, until a toothpick inserted comes out with a few crumbs attached. Allow the brownies to cool completely before slicing and serving. Enjoy! Store any leftovers in an airtight container at room temperature for up to 3 days. They also freeze well for up to a month. Last time I made these, I doubled the recipe and stored the second batch in the freezer. It was so fun to have them on hand for a quick and easy dessert or afternoon treat! Best Brownie Recipe Tips Better chocolate chips = better brownies. In her book, Michelle writes that one of the biggest secrets to making great brownies is using large, good-quality chocolate chips. She recommends Ghiradelli’s 60% Cacao Bittersweet Baking Chips, while I love Enjoy Life’s Dark Chocolate Morsels. Either brand would fantastic in this recipe! It’s better to pull them out too early than to leave them in too long. No one likes dry brownies, so err on the side of caution when you’re making this recipe. Bake them until a toothpick inserted comes out with just a few crumbs attached. If you’re on the fence, go ahead and take them out of the oven. They’ll continue to firm up as they cool! Wait for them to cool. Try your best to resist eating these guys straight out of the oven. Letting them cool makes them gooier and fudgier, and they’ll be less likely to crumble when you slice them. Plus, they’ll have an even richer chocolate flavor. Trust me, it’s worth the wait!
