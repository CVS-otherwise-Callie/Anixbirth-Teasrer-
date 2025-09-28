--- Quick Insturctions to Creating:
--- Every number means the subtype corrosponding, so the NPC type with 1 will always follow behavior of 1 in here.
--- Here is a list of all the attributes these MUST have.


-- animation (anm2 file path) - this is the animation the npc will load
-- Each Dia... number means a seperate dialouge. After the first one is done AND Isaac is finished talking, the SECOND one will trigger.
-- Each Dia... number has a table for each seperate sequecne inbetween player inputs. This allows for a npc to say things that may take up more than 1 box before the player can interact to move dialogue sequencing.


--- Here is a list of attributes they CAN have.


-- animPre (string) This is just a prefix to all animations for more variety.
-- diaPre (string) This is a prefix to dialogues. If you have a set of dialogues that only plays after a certain event, use this in func(npc) to change the dialogue to ones with that prefix. It will ALWAYS reset dialogue progress to paragraph 1, sentance 1 when changed.
-- func(npc) (function) This is a function. It will ALWAYS run after the base NPC ai runs. ALL STATS MENTIONED CAN BE MODIFIED IN FUNC!!
-- touchFunc(npc, player) This is a function that plays on player touch. It will ALWAYS run after the base NPC ai runs.
-- initAnim (string) This is the beginning prefix the npc will ALWAYS spawn with. This is to avoid visual conflict between the base AI and func.
-- canInteract (boolean) Sets if the NPC should interact on init. This can be modified in the function.
-- headFollow (boolean) If the animation has a overlay called "Head", will play the overlay and wil generally lean towards the player, like a Hangeslip.
-- headDirections (boolean) Only accepts "up down left right". Can read these seperately as direction PREFIXES the animation can go in. Will ALWAYS predominate other animation prefixes (i.e. UpAngryIdle). Will ALWAYS cancel out headFollow for itself.
-- loop (boolean) If all npc dialogue under the prefix is exhausted, loops back around to the start. AUTOMATICALLY WILL LOOP LAST SENTANCE IF FALSE.
-- forceend (boolean) Forces npc dialogue to end without player input. This is generally good for NPCs that want to make a point, and have more emphasized control over their dialogue.
-- font (font) Changes the dialogue font.

--- NPC Constants that you can use in your function:
-- Current Paragraph (data.curPar)
-- Current Sentance (data.curSen)
-- isTalking (boolean)
-- isWaiting (boolean) This specific variable is if the NPC is waiting for input to say something else. It is also automatically true if another npc makes a npc talk, and is only turned off for said NPC when the entire "cutscene" tied to the first NPC is finished (this does mean cutscnces that end with another NPC have a tendancy to break)

--- Here's some extra stuff the TEXT can have inside it to make it cooler.
-- {{fsize integer}} (i.e. {{fsize 2}}) This will change the size of the text. 1 is standard, 2 is big, 3 is really big, 4 is small, 5 is really small
-- {{fspeed integer}} This changes how fast the text goes. Standard is 5, lower means it's slower and higher means it's faster. 1 is slowest; fastest is 10.


local dialogue = {


    [1] = {
        animation = "gfx/npcs/ruin/skeletons/skeletons.anm2",
        initAnim = "Hiding",
        Dia1 = {
            {
                [========[
                Hi guys
                Im cool
                ]========]
            },
            {
                [========[
                In this
                one case
                i am going
                to go off
                and say a ton
                hehe
                ]========]
            },
        },
        Dia2 = {
            {  
                [========[
                Wow a
                Second thing
                ]========]
            }
        },
        func = function(npc)
            local player = npc:GetPlayerTarget()


            if npc.Position:Distance(player.Position) < 150 then
                npc:GetData().animPre = "Scared"
            end
        end,  },




}

return dialogue