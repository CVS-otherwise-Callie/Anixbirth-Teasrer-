FHAC.HasLoadedDSS = true

local mod = FHAC

local DSSModName = "FHAC Mod DSS Menu"

local DSSCoreVersion = 7

local MenuProvider = {}

function MenuProvider.SaveSaveData()
    AnixbirthSaveManager.Save()
end

function MenuProvider.GetPaletteSetting()
	return AnixbirthSaveManager.GetDeadSeaScrollsSave().MenuPalette
end

function MenuProvider.SavePaletteSetting(var)
	AnixbirthSaveManager.GetDeadSeaScrollsSave().MenuPalette = var
end

function MenuProvider.GetHudOffsetSetting()
	if not REPENTANCE then
		return AnixbirthSaveManager.GetDeadSeaScrollsSave().HudOffset
	else
		return Options.HUDOffset * 10
	end
end

function MenuProvider.SaveHudOffsetSetting(var)
	if not REPENTANCE then
		AnixbirthSaveManager.GetDeadSeaScrollsSave().HudOffset = var
	end
end

function MenuProvider.GetGamepadToggleSetting()
	return AnixbirthSaveManager.GetDeadSeaScrollsSave().GamepadToggle
end

function MenuProvider.SaveGamepadToggleSetting(var)
	AnixbirthSaveManager.GetDeadSeaScrollsSave().GamepadToggle = var
end

function MenuProvider.GetMenuKeybindSetting()
	return AnixbirthSaveManager.GetDeadSeaScrollsSave().MenuKeybind
end

function MenuProvider.SaveMenuKeybindSetting(var)
	AnixbirthSaveManager.GetDeadSeaScrollsSave().MenuKeybind = var
end

function MenuProvider.GetMenuHintSetting()
    return FHAC.AnixbirthSaveManager.GetDeadSeaScrollsSave().MenuHint
end

function MenuProvider.SaveMenuHintSetting(var)
	AnixbirthSaveManager.GetDeadSeaScrollsSave().MenuHint = var
end

function MenuProvider.GetMenuBuzzerSetting()
	return AnixbirthSaveManager.GetDeadSeaScrollsSave().MenuBuzzer
end

function MenuProvider.SaveMenuBuzzerSetting(var)
	AnixbirthSaveManager.GetDeadSeaScrollsSave().MenuBuzzer = var
end

function MenuProvider.GetMenusNotified()
	return AnixbirthSaveManager.GetDeadSeaScrollsSave().MenusNotified
end

function MenuProvider.SaveMenusNotified(var)
	AnixbirthSaveManager.GetDeadSeaScrollsSave().MenusNotified = var
end

function MenuProvider.GetMenusPoppedUp()
	return AnixbirthSaveManager.GetDeadSeaScrollsSave().MenusPoppedUp
end

function MenuProvider.SaveMenusPoppedUp(var)
	AnixbirthSaveManager.GetDeadSeaScrollsSave().MenusPoppedUp = var
end

local globalnewsletterSprites = {
    cvsme = "cvsme",
    tjp = "tjp",
    gub = "gub",
    dymoz = "dymoz",
    xocolate = "xocolate"
}

for k, v in pairs(globalnewsletterSprites) do

    local sprlocation = "gfx/ui/deadseascrolls/newsletters/" .. v .. ".png"

    globalnewsletterSprites[k] = Sprite()

    globalnewsletterSprites[k]:Load("gfx/ui/deadseascrolls/newsletters/newslettersprites.anm2", true)
    globalnewsletterSprites[k]:ReplaceSpritesheet(0, sprlocation)
    globalnewsletterSprites[k]:LoadGraphics()
    globalnewsletterSprites[k]:Play("Idle")

end

local function SureFunc(str, var, outcome, tooltip)

    return {str = str, 
    func = function()     
        mod:NestVariable(AnixbirthSaveManager.GetSettingsSave(), str, "DSSSavedata", "YesNo", "Name" )
        mod:NestVariable(AnixbirthSaveManager.GetSettingsSave(), var, "DSSSavedata", "YesNo", "Variable" )
        mod:NestVariable(AnixbirthSaveManager.GetSettingsSave(), outcome, "DSSSavedata", "YesNo", "Outcome" )
        mod:NestVariable(AnixbirthSaveManager.GetSettingsSave(), tooltip, "DSSSavedata", "YesNo", "Tooltip" )

        if FHAC.dmdirectory.yesNo then
            FHAC.dmdirectory.yesNo.title = mod:GetNestedVariable(AnixbirthSaveManager.GetSettingsSave(), "DSSSavedata", "YesNo", "Name" )
            FHAC.dmdirectory.yesNo.tooltip = {strset = mod:GetNestedVariable(AnixbirthSaveManager.GetSettingsSave(), "DSSSavedata", "YesNo", "Tooltip" )}
        end
    end, 
    dest = 'yesNo', tooltip = {strset = tooltip}}
end

local newsletterbuttons = {}

local function GenNewsletter(newsletter, date)
    local function split(pString, pPattern)
        local Table = {}  -- NOTE: use {n = 0} in Lua-5.0
        local fpat = "(.-)" .. pPattern
        local last_end = 1
        local s, e, cap = pString:find(fpat, 1)
        while s do
        if s ~= 1 or cap ~= "" then
        table.insert(Table,cap)
        end
        last_end = e+1
        s, e, cap = pString:find(fpat, last_end)
        end
        if last_end <= #pString then
        cap = pString:sub(last_end)
        table.insert(Table, cap)
        end
        return Table
    end

    local messageButtons = {}
    local fSizeCur = 1
    local color = 2

    local function getStringuntilSpace(str)
        local num = 1
        local curchar = string.sub(str, num, num)
        local newstr = ""
        while curchar ~= " " and curchar ~= "" and num < #str and curchar ~= "]" do
            curchar = string.sub(str, num, num)
            newstr = newstr .. curchar
            num = num + 1
        end
        return newstr
    end

    local newSplit = split(newsletter, "\n")
    local shouldcenter = true
    local xshift = tonumber("0")
    local colorc = Color(1, 1, 1, 1)
    local alphac

    for k, v in ipairs(newSplit) do

        if v == "{FSIZE1}" then
            fSizeCur = 1
        elseif v == "{FSIZE2}" then
            fSizeCur = 2
        elseif v == "{FSIZE3}" then
            fSizeCur = 3
        elseif v == "{C1}" then
            color = 2
        elseif v == "{C2}" then
            color = 3
        elseif v == "{{CENTER}}" then
            shouldcenter = true
            xshift = 0
        elseif v == "{{NOCENTER}}" then
            shouldcenter = false        
        elseif string.find(v, "{{COLOR") then
                local num = 1
                local curchar = string.sub(v, num, num)
                local newstr = {}
                while curchar ~= ")" do
                    curchar = string.sub(v, num, num)
                    if tonumber(curchar) then
                        newstr[#newstr+1] = tonumber(curchar)
                    end
                    num = num + 1
                end

                if not newstr[4] then
                    error("COLOR ASPECT NOT FULLY RECOGNIZED") --you failed!
                end

                colorc = Color(newstr[1], newstr[2], newstr[3], newstr[4])
                alphac = newstr[4]
        elseif string.find(v, "{{XSHIFT") then
            local _, endshift = string.find(v, "{{XSHIFT")
            xshift = tonumber(getStringuntilSpace(string.sub(v, endshift+1, #v-1)))
        elseif string.find(v, "{{SPR") then

            local width = "1"
            local height = "1"
            local position = Vector(0, 0)
            local needcenter

            local nameend, _ = string.find(v, "}}")
            local name = string.sub(v, 6, nameend-1)
            local folder = mod:replaceAllinString(date, "/", ".")

            if globalnewsletterSprites[string.lower(name)] then
                folder = "global"
            end

            local sprlocation = "gfx/ui/deadseascrolls/newsletters/" .. folder .. "/" .. string.lower(name) .. ".png"

            local newsSprite = Sprite()

            newsSprite:Load("gfx/ui/deadseascrolls/newsletters/newslettersprites.anm2", true)
            newsSprite:ReplaceSpritesheet(0, sprlocation)
            newsSprite:LoadGraphics()
            newsSprite:Play("Idle")

            -- width

            local _, widthend = string.find(v, "width:")
            local _, heightend = string.find(v, "height:")
            if widthend then
                width = getStringuntilSpace(string.sub(v, widthend+1, #v))
            end
            if heightend then
                height = getStringuntilSpace(string.sub(v, heightend+1, #v))
            end

            if not (tonumber(width) == 1 and tonumber(height) == 1) then
                position = Vector(tonumber(width),tonumber(height)*-1)
                needcenter = false
            else
                needcenter = true
            end

            messageButtons[#messageButtons+1] = {spr = {sprite = newsSprite, anim= "Idle", width = 0, height = 1, center = needcenter or shouldcenter, color = colorc}, nosel = true, color = color, pos = position + Vector(xshift, 0)}
        else
            messageButtons[#messageButtons+1] = {str = v, fsize = fSizeCur, nosel = true, color = color, pos = Vector(xshift, 0), center = shouldcenter, alpha = alphac}
        end      
    end

    messageButtons[#messageButtons+1] = {str = 'resume game', action = 'resume'}

    return messageButtons
end

function mod:AddNewsletter(namesubName, newslettecontent, season)

    local name = string.lower(namesubName[1])
    local subname = string.lower(namesubName[2])

    season = string.lower(season) or ""
    local title = "newsletter"

    if season then
        title = season .. " newsletter"
    else
        title = "anixbirth newsletter"
    end

    newsletterbuttons[#newsletterbuttons+1] = {str = name, fsize=2, dest=name, tooltip = {strset = {season, 'newsletter', namesubName[2]}}}
    newsletterbuttons[#newsletterbuttons+1] = {str = subname, fsize=1, nosel = true, dest=subname}
    FHAC.dmdirectory[name] = {
        title = title,
        fsize = 1,
        scroller = true,
        --nocursor = true,
        buttons = GenNewsletter(newslettecontent, subname),
        tooltip = {strset = {'newsletter', namesubName[2], '', 'press enter', 'to exit'}}
    }
    -- and finally a space at the end
    newsletterbuttons[#newsletterbuttons+1] = {str = '', fsize=2, nosel = true}
end

local dssmenucore = include("scripts.deadseascrolls.fhacdssmenucore")

FHAC.dmdirectory = {}

mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
    if not mod.HasLoadedDSSReal and AnixbirthSaveManager.IsLoaded() then
        FHAC.dssmod = dssmenucore.init(DSSModName, MenuProvider)

        local dssmod = FHAC.dssmod

        -- for achievements

        local buttonAchievements = {}
        local panelFilterOptions = {
            nil,
            "Johannes",
            "Character",
            "Item",
        }

        for i, item in ipairs(FHAC.ACHIEVEMENT) do
            if not item.Sprite then
                item.Sprite = Sprite()
                item.Sprite:Load("gfx/ui/achievement/_anixbirth_achievement.anm2", false)
                item.Sprite:ReplaceSpritesheet(2, "gfx/ui/achievement/achievement_" .. string.lower(item.ID) ..".png")
                item.Sprite:ReplaceSpritesheet(0, "gfx/nothing.png")
                item.extraSpriteID = i
                item.Sprite:LoadGraphics()
            end
        end

        local selectedAch
        local drawings = {}
        local forceUnpause
        local paused
        local sidePaper = Sprite()
        sidePaper:Load("gfx/ui/achievement/sidenote/_anixbirth_achievement_sidepaper.anm2", true)

        local achievementTooltipSprites = {
            Shadow = "gfx/ui/achievement/sidenote/sidepaper_shadow.png",
            Back = "gfx/ui/achievement/sidenote/sidepaper_back.png",
            Face = "gfx/ui/achievement/sidenote/sidepaper_face.png",
            Border = "gfx/ui/achievement/sidenote/sidepaper_border.png",
            Mask = "gfx/ui/achievement/sidenote/sidepaper_mask.png",
        }

        for k, v in pairs(achievementTooltipSprites) do
            local sprite = Sprite()
            sprite:Load("gfx/ui/achievement/sidenote/_anixbirth_achievement_sidepaper.anm2", false)
            sprite:ReplaceSpritesheet(0, "gfx/nothing.png")
            sprite:LoadGraphics()
            achievementTooltipSprites[k] = sprite
        end

        local coOpSprite = Sprite()
        coOpSprite:Load("gfx/ui/eid_fhac_players_icon.anm2", true)
        -- ok done with setting up achievements

        local coOpSpriteList = {
            "Johannes"
        }

        local bossSprite = Sprite()
        bossSprite:Load("gfx/ui/hudpickups.anm2", true)

        local coOpBossList = {
            ["Mom"] = 0,
            ["Mom's Heart"] = 1,
            ["Satan"] = 2,
            ["Isaac"] = 3,
            ["Lamb"] = 4,
            ["???"] = 5,
            ["Mega Satan"] = 6,
            ["Hush"] = 8,
            ["Delirium"] = 9,
            ["Witness"] = 11
        }

        local function CheckVectors(table, element)
            for k, v in ipairs(table) do
                if v:Distance(element) == 0 then
                    return true
                end
            end
            return false
        end

        local bannedPositions = {}


        FHAC.dmdirectory.main = {
                title = 'hope (teasrer)',

                buttons = {
                    {str = 'resume game', action = 'resume'},
                    {str = 'options', dest = 'options',tooltip = {strset = {'---','play around', 'with what', 'you like and', 'do not like', '---'}}},
                    {str = 'other', dest = 'other',tooltip = {strset = {'---','the misc,', 'the huh,', 'and the', 'why!', '---'}}},         
                    {str = 'achievements', dest = 'achievements',tooltip = {strset = {'---','force lock or', 'unlock things ','', 'recommended to', 'keep stuff locked', '---'}}},
                    FHAC.dssmod.changelogsButton,
                    {str = '', fsize=2, nosel = true},
                    -- you DON'T have dss developer on
                    {str = 'thanks for', nosel = true, fsize=2,displayif = function(_, item)

                        if not FHAC.fhacDSSDeveloperMode then return true end

                        return false
                    end}, 
                    {str = 'the long wait!', nosel = true, fsize=2,displayif = function(_, item)

                        if not FHAC.fhacDSSDeveloperMode then return true end

                        return false
                    end}, 
                    {str = 'hope you enjoy', nosel = true, fsize=2,displayif = function(_, item)

                        if not FHAC.fhacDSSDeveloperMode then return true end

                        return false
                    end}, 
                    {str = 'our mod', nosel = true, fsize=2,displayif = function(_, item)

                        if not FHAC.fhacDSSDeveloperMode then return true end

                        return false
                    end}, 
                    {str = '- the anixbirth', nosel = true, fsize=1,displayif = function(_, item)

                        if not FHAC.fhacDSSDeveloperMode then return true end

                        return false
                    end},
                    {str = 'team', nosel = true, fsize=1,displayif = function(_, item)

                        if not FHAC.fhacDSSDeveloperMode then return true end

                        return false
                    end}, 
                    -- you DO have dss developer on
                    {str = 'the commands', nosel = true, fsize=2,displayif = function(_, item)

                        if FHAC.fhacDSSDeveloperMode then return true end

                        return false
                    end},    
                    {str = 'are in other', nosel = true, fsize=2,displayif = function(_, item)

                        if FHAC.fhacDSSDeveloperMode then return true end

                        return false
                    end}, 
                    {str = '', nosel = true, fsize=2,displayif = function(_, item)

                        if FHAC.fhacDSSDeveloperMode then return true end

                        return false
                    end}, 
                    {str = 'that page is', nosel = true, fsize=2,displayif = function(_, item)

                        if FHAC.fhacDSSDeveloperMode then return true end

                        return false
                    end}, 
                    {str = 'finally useful', nosel = true, fsize=2,displayif = function(_, item)

                        if FHAC.fhacDSSDeveloperMode then return true end

                        return false
                    end}, 
                },
                tooltip = FHAC.dssmod.menuOpenToolTip,
        }
        FHAC.dmdirectory.options =  {
                    title = 'options',
                        buttons = {
                            {
                                str = 'room name',
                                fsize = 3,
                                choices = {'on', 'off'},
                                variable = "roomName",
                                setting = 1,
                                load = function()
                                    return AnixbirthSaveManager.GetSettingsSave().roomName or 1
                                end,
                                store = function(var)
                                    AnixbirthSaveManager.GetSettingsSave().roomName = var
                                end,
                                tooltip = {strset = {'should the room', 'name be shown', '', 'default is', 'yes'}}

                            },
                            {str = '', nosel = true, fsize=1,displayif = function(_, item)
                                if item and item.buttons then
                                    for _, button in ipairs(item.buttons) do
                                        if button.str == 'room name' then
                                            return button.setting == 1
                                        end
                                    end
                                end

                                return false
                            end},                    
                            {
                                str = 'opacity',
                                fsize = 2,
                                increment = 1, max = 10,
                                slider = true,
                                variable = "roomNameOpacity",
                                setting = 3,
                                load = function()
                                    return AnixbirthSaveManager.GetSettingsSave().roomNameOpacity or 10
                                end,
                                store = function(var)
                                    AnixbirthSaveManager.GetSettingsSave().roomNameOpacity = var
                                end,
                                tooltip = {strset = {'room name', 'opacity','', 'default is', '10'}},
                                displayif = function(_, item)
                                if item and item.buttons then
                                    for _, button in ipairs(item.buttons) do
                                        if button.str == 'room name' then
                                            return button.setting == 1
                                        end
                                    end
                                end

                                return false
                            end},
                            {str = '', nosel = true, fsize=1,displayif = function(_, item)
                                if item and item.buttons then
                                    for _, button in ipairs(item.buttons) do
                                        if button.str == 'room name' then
                                            return button.setting == 1
                                        end
                                    end
                                end

                                return false
                            end},  
                            {
                                str = 'show variant',
                                fsize = 2,
                                choices = {'on', 'off'},
                                variable = "roomNameVariantShow",
                                setting = 1,
                                load = function()
                                    return AnixbirthSaveManager.GetSettingsSave().roomNameVariantShow or 1
                                end,
                                store = function(var)
                                    AnixbirthSaveManager.GetSettingsSave().roomNameVariantShow = var
                                end,
                                tooltip = {strset = {'room name', 'variant shown','', 'default is', 'on'}},
                                displayif = function(_, item)
                                if item and item.buttons then
                                    for _, button in ipairs(item.buttons) do
                                        if button.str == 'room name' then
                                            return button.setting == 1
                                        end
                                    end
                                end

                                return false
                            end},
                            {str = '', fsize=2, nosel = true},
                            {str = '-----enemies-----', fsize=2, nosel = true},
                            {str = '', fsize=2, nosel = true},
                            {str = 'monsters',   
                            dest = 'enemies',
                            tooltip = {strset = {'turn on and', ' off what', 'enemies', 'show up', '', 'currently', 'does not', 'work yet'}}
                            },
                            {str = '', fsize=2, nosel = true},
                            {
                                str = 'replaced monsters',
                                choices = {'anixbirth mode', 'half and half', 'none'},
                                variable = "monsterReplacements",
                                setting = 1,
                                load = function()
                                    return AnixbirthSaveManager.GetSettingsSave().monsterReplacements or 2
                                end,
                                store = function(var)
                                    AnixbirthSaveManager.GetSettingsSave().monsterReplacements = var
                                end,
                                tooltip = {strset = {'some enemies', 'can be','replaced by', 'floor variants', '', 'half anf half', 'by default'}}

                            },
                            {str = '', fsize=2, nosel = true},
                            {str = '-----achievements-----', fsize=2, nosel = true},
                            {str = '', fsize=2, nosel = true},
                            SureFunc("unlock all", "lockall", 2, {'unlocks all','if desired', '', 'dependant', 'by default', '', 'to update', 'restart run'}),
                            {str = '', fsize=1, nosel = true},
                            SureFunc("depend all", "lockall", 1, {'sets unlocks','back to','player','dependant', '', 'to update', 'restart run'}),
                            {str = '', fsize=1, nosel = true},
                            {
                                str = "unlock tooltip",
                                choices = {'on', 'off'},
                                variable = "lockAchTooltip",
                                setting = 1,
                                load = function()
                                    return AnixbirthSaveManager.GetSettingsSave().lockAchTooltip or 2
                                end,
                                store = function(var)
                                    AnixbirthSaveManager.GetSettingsSave().lockAchTooltip = var
                                end,
                                tooltip = {strset = {'shows tooltip', 'to an unlock', 'while locked', '', 'default', 'is off', '', 'updates on', 'dss close'}}
                            },
                            {str = '', fsize=2, nosel = true},
                            {str = '-----fortunes-----', fsize=2, nosel = true},
                            {str = '', fsize=2, nosel = true},
                            {
                                str = 'custom fortunes',
                                choices = {'on', 'off'},
                                variable = "customFortunes",
                                setting = 1,
                                load = function()
                                    return AnixbirthSaveManager.GetSettingsSave().customFortunes or 1
                                end,
                                store = function(var)
                                    AnixbirthSaveManager.GetSettingsSave().customFortunes = var
                                end,
                                tooltip = {strset = {'allow for', 'fortune', 'replacements', '', 'on by', 'default'}}
                            },
                            {str = '', nosel = true, fsize=2,displayif = function(_, item)
                                if item and item.buttons then
                                    for _, button in ipairs(item.buttons) do
                                        if button.str == 'custom fortunes' then
                                            return button.setting == 1
                                        end
                                    end
                                end

                                return false
                            end},
                            {
                                str = 'fortunes on death',
                                choices = {'on', 'off'},
                                variable = "fortunesonDeath",
                                setting = 1,
                                load = function()
                                    return AnixbirthSaveManager.GetSettingsSave().fortunesonDeath or 2
                                end,
                                store = function(var)
                                    AnixbirthSaveManager.GetSettingsSave().fortunesonDeath = var
                                end,
                                displayif = function(_, item)
                                    if item and item.buttons then
                                        for _, button in ipairs(item.buttons) do
                                            if button.str == 'custom fortunes' then
                                                return button.setting == 1
                                            end
                                        end
                                    end
                
                                    return false
                                end,
                                tooltip = {strset = {'whether a', 'custom fortune', 'should happen', 'on a', 'enemys death','', 'off by','default'}}
                            },
                            {str = '', nosel = true, fsize=2,displayif = function(_, item)
                                if item and item.buttons then
                                    for _, button in ipairs(item.buttons) do
                                        if button.str == 'custom fortunes' then
                                            return button.setting == 1
                                        end
                                    end
                                end

                                return false
                            end},
                            {
                                str = 'chance',
                                increment = 1, max = 10,
                                variable = "fortuneDeathChance",
                                slider = true,
                                setting = 3,
                                load = function()
                                    return AnixbirthSaveManager.GetSettingsSave().fortuneDeathChance or 3
                                end,
                                store = function(var)
                                    AnixbirthSaveManager.GetSettingsSave().fortuneDeathChance = var
                                end,
                                displayif = function(_, item)
                                    if item and item.buttons then
                                        for _, button in ipairs(item.buttons) do
                                            if button.str == 'fortunes on death' then
                                                return button.setting == 1
                                            end
                                        end
                                    end
                
                                    return false
                                end,
                                tooltip = {strset = {'whats the %', 'a fortune', 'shows on', 'a enemys', 'death?','', 'out of 10'}}
                            },
                            {str = '', fsize=2,nosel = true},
                            {str = '-----misc-----', fsize=2, nosel = true},
                            {str = '', fsize=2, nosel = true},
                            {
                                str = 'accurate roaches',
                                choices = {'on', 'off'},
                                variable = "accurateRoach",
                                setting = 1,
                                load = function()
                                    return AnixbirthSaveManager.GetSettingsSave().accurateRoach or 2
                                end,
                                store = function(var)
                                    AnixbirthSaveManager.GetSettingsSave().accurateRoach = var
                                end,
                                tooltip = {strset = {'please dont', 'turn this on', '', 'off by', 'default', 'for a', 'good reason'}}
                            },
                            {str = '', fsize=2,nosel = true},
                            {
                                str = 'better grid sprites',
                                choices = {'on', 'off'},
                                variable = "newGrids",
                                setting = 1,
                                load = function()
                                    return AnixbirthSaveManager.GetSettingsSave().newGrids or 2
                                end,
                                store = function(var)
                                    AnixbirthSaveManager.GetSettingsSave().newGrids = var
                                end,
                                tooltip = {strset = {'resprites', 'gird objects', '', 'off by', 'default'}}
                            },
                            {str = '----------', fsize=2, nosel = true},

                        }
        }
            --[[FHAC.dmdirectory.enemies = {
                --add ff-like menu here
                title = 'enemies',
                buttons = {
                    {str = 'cellar', nosel = true},
                    {
                        str = 'dried spawn rate',
                        cursoroff = Vector(0, 10),
                        fsize=2,
                        choices = {'never', 'rarely', 'sometimes', 'often', 'extremely often', 'insanely often'},
                        variable = "randomDried",
                        setting = 1,
                        load = function()
                            return AnixbirthSaveManager.GetSettingsSave().randomDried or 1
                        end,
                        store = function(var)
                            AnixbirthSaveManager.GetSettingsSave().randomDried = var
                        end,
                        tooltip = {strset = {'affects dried', 'spawn rate', 'in cellar' ,'','rarely by', 'default'}}
                    },
                    {str = '', fsize=2,nosel = true},
                    {str = 'caves', nosel = true},
                    {
                        str = 'pallun shots',
                        cursoroff = Vector(0, 10),
                        fsize=2,
                        choices = {'normal', 'kerkel'},
                        variable = "prettyMushlooms",
                        setting = 1,
                        load = function()
                            return AnixbirthSaveManager.GetSettingsSave().pallunShot or 1
                        end,
                        store = function(var)
                            AnixbirthSaveManager.GetSettingsSave().pallunShot = var
                        end,
                        tooltip = {strset = {'changes the', 'pallun shot', 'behavior', 'to version', 'made by', 'kerkel','','normal by', 'default'}}
                    },
                    {str = '', fsize=2,nosel = true},
                    {str = 'catacombs', nosel = true},
                    {
                        str = 'pretty mushlooms',
                        cursoroff = Vector(0, 10),
                        fsize=2,
                        choices = {'normal', 'pretty', 'shaded pretty'},
                        variable = "prettyMushlooms",
                        setting = 1,
                        load = function()
                            return AnixbirthSaveManager.GetSettingsSave().prettyMushlooms or 1
                        end,
                        store = function(var)
                            AnixbirthSaveManager.GetSettingsSave().prettyMushlooms = var
                        end,
                        tooltip = {strset = {'pretty','mushloom', 'made by', 'onxc_kryptid','','normal by', 'default'}}
                    },
                }
            },]]
        FHAC.dmdirectory.achievements = {
                format = {
                    Panels = {
                        {
                            Panel = {
                                StartAppear = function(panel) --universal
                                    panel.SmallPanelFrame = 0
                                    panel.Idle = false
                                    Isaac.GetPlayer():UseActiveItem(CollectibleType.COLLECTIBLE_PAUSE, UseFlag.USE_NOANIM)
                                    paused = true
                                end,
                                UpdateAppear = function(panel) --universal
                                        panel.SmallPanelFrame = panel.SmallPanelFrame + 1
                                        if panel.SmallPanelFrame >= 10 then
                                            panel.Idle = true
                                            return true
                                        end
                                end,
                                StartDisappear = function(panel) --universal
                                    dssmod.playSound(dssmod.menusounds.Close)
                                    panel.SmallPanelFrame = 32
                                    forceUnpause = true
                                    paused = false
                                end,
                                UpdateDisappear = function(panel) --universal
                                    panel.SmallPanelFrame = panel.SmallPanelFrame + 1
                                    if panel.SmallPanelFrame >= 40 then
                                        return true
                                    end
                                end,
                                RenderBack = function(panel, panelPos, tbl) --Becky specific

                                    if not panel.PanInit then --coding like a enemy for some unholy reason
                                        panel.Filter = nil
                                        panel.xPosPan = 0
                                        panel.OuterOffset = 0
                                        panel.PanInit = true
                                    end

                                    local achList = {}

                                    for _, thing in ipairs(FHAC.ACHIEVEMENT) do
                                        if (not panel.Filter or mod:CheckTableContents(thing.Tags, panel.Filter)) and not thing.Hidden then
                                            table.insert(achList, thing)
                                        end
                                    end

                                    if panel.MoveDown then
                                        if panel.OuterOffset+9 < #achList then
                                            panel.OuterOffset = panel.OuterOffset + 9
                                        end
                                        panel.MoveDown = false
                                    end

                                    if panel.MoveUp then
                                        if panel.OuterOffset-9 >= 0 then
                                            panel.OuterOffset = panel.OuterOffset - 9
                                        end
                                        panel.MoveUp = false
                                    end

                                    local mousePlacement

                                    if panel.MouseIconPos then
                                        local xPosPan = 0
                                        for i = 1, 9 do
                                            xPosPan = xPosPan + 1

                                            if panel.MouseIconPos:Distance(Vector(xPosPan-1, (math.floor((i-1)/3)))) < 1 then
                                                mousePlacement = i
                                            end
                                            if i%3 == 0 then
                                                xPosPan = 0                                        
                                            end
                                        end
                                    end

                                    local NEWxPosPan = 0
                                    local mouseIconT = {}
                                    panel.xPosPan = 0
                                    for i = 1, 9 do -- i split these becauuuuseeee (uh) i hate myself probably
                                    
                                        NEWxPosPan = NEWxPosPan + 1
                                        if (i-1)%3 == 0 then
                                            NEWxPosPan = 0                                        
                                        end
                                    
                                        local realNum = i + panel.OuterOffset

                                        local placement = Vector(NEWxPosPan, (math.floor((i-1)/3)))

                                        if panel.MouseIconPos and not achList[realNum] then
                                            table.insert(bannedPositions, placement)
                                        end
                                    
                                        if achList[realNum] and (realNum-1) < 9 + panel.OuterOffset and panel.SmallPanelFrame ~= 40 then

                                            local butt = {}

                                            SmallPanelFrame = panel.SmallPanelFrame

                                            panel.xPosPan = panel.xPosPan + 1
                                            if not AnixbirthAchievementSystem:IsUnlocked(achList[realNum].extraSpriteID) then 
                                                achList[i].Sprite:ReplaceSpritesheet(2, "gfx/ui/achievement/achievement_locked.png")
                                            else
                                                achList[i].Sprite:ReplaceSpritesheet(2, "gfx/ui/achievement/achievement_" .. string.lower(achList[realNum].ID) ..".png")
                                            end
                                            achList[i].Sprite:LoadGraphics()
                                            achList[i].Sprite:Play("Idle")
                                            achList[i].Sprite:SetFrame(panel.SmallPanelFrame)
                                            achList[i].Sprite.Scale = Vector(0.35, 0.35)
                                            if i == mousePlacement then
                                                achList[i].Sprite.Color = DeadSeaScrollsMenu.GetPalette()[1]
                                                selectedAch = achList[realNum]
                                                if REPENTOGON then
                                                    achList[i].Sprite.Color:SetOffset(0.1, 0.1, 0.1, 1)  
                                                else
                                                    achList[i].Sprite:ReplaceSpritesheet(1, "gfx/ui/achievement/paperlite.png")
                                                end
                                            else
                                                achList[i].Sprite.Color = DeadSeaScrollsMenu.GetPalette()[1]
                                                if REPENTOGON then
                                                    achList[i].Sprite.Color:SetColorize(0, 0, 0, 0.1)  
                                                else
                                                    achList[i].Sprite:ReplaceSpritesheet(1, "gfx/ui/achievement/paper.png")
                                                end
                                            end
                                            achList[i].Sprite:Render(panelPos + Vector((panel.xPosPan-1)*100, (math.floor((i-1)/3) * 80)) - Vector(190, 70), Vector.Zero, Vector.Zero)-- panelPos + Vector(panel.MouseIconPos.X*32, panel.MouseIconPos.Y*32), Vector.Zero, Vector.Zero)
                                            if i%3 == 0 then
                                                panel.xPosPan = 0                                        
                                            end

                                            butt.tooltip = achList[realNum].Tooltip
                                            butt.Position = panelPos + Vector((panel.xPosPan-1)*100, (math.floor((i-1)/3) * 80)) - Vector(190, 70)
                                            table.insert(mouseIconT, achList[realNum].Sprite)
                                            table.insert(buttonAchievements, butt)
                                        end
                                    end

                                    sidePaper:Play("Idle")
                                    sidePaper.Scale = Vector(0.8, 0.8)
                                    sidePaper:Render(panelPos + Vector(80, 0), Vector.Zero, Vector.Zero)
                                    sidePaper:SetFrame(panel.SmallPanelFrame)
                                    sidePaper.Color = DeadSeaScrollsMenu.GetPalette()[1]

                                end,
                                HandleInputs = function(panel, input, item, itemswitched, tbl) -- Becky specific
                                    if not itemswitched then
                                        local menuinput = input.menu
                                        local rawinput = input.raw --left, right, up, down

                                        panel.MouseIconPos = panel.MouseIconPos or Vector(0, 0)

                                        panel.InputtedInput = panel.InputtedInput or nil

                                        if rawinput.right > 0 and panel.InputtedInput~="right" then --im sure theres a better way to dthis i js cant come up with oneeeee
                                            if panel.MouseIconPos.X < 2 and not CheckVectors(bannedPositions, Vector(panel.MouseIconPos.X+1,panel.MouseIconPos.Y )) then
                                                panel.MouseIconPos.X = panel.MouseIconPos.X + 1
                                            end
                                            panel.InputtedInput = "right"
                                        elseif rawinput.right == 0 and panel.InputtedInput=="right" then
                                            panel.InputtedInput = nil
                                        end
                                        if rawinput.left > 0 and panel.InputtedInput~="left" then
                                            if panel.MouseIconPos.X > 0  and not CheckVectors(bannedPositions, Vector(panel.MouseIconPos.X-1,panel.MouseIconPos.Y )) then
                                                panel.MouseIconPos.X = panel.MouseIconPos.X - 1
                                            end
                                            panel.InputtedInput = "left"
                                        elseif rawinput.left == 0 and panel.InputtedInput=="left" then
                                            panel.InputtedInput = nil
                                        end
                                        if rawinput.up > 0 and panel.InputtedInput~="up" then
                                            if panel.MouseIconPos.Y < 1 then
                                                panel.MoveUp = true
                                                bannedPositions = {}
                                                panel.MouseIconPos.Y = panel.MouseIconPos.Y + 2
                                            elseif not CheckVectors(bannedPositions, Vector(panel.MouseIconPos.X,panel.MouseIconPos.Y-1)) then
                                                panel.MouseIconPos.Y = panel.MouseIconPos.Y - 1
                                            end
                                            panel.InputtedInput = "up"
                                        elseif rawinput.up == 0 and panel.InputtedInput=="up" then
                                            panel.InputtedInput = nil
                                        end
                                        if rawinput.down > 0 and panel.InputtedInput~="down" then
                                            if panel.MouseIconPos.Y > 1 then
                                                panel.MoveDown = true
                                                bannedPositions = {}
                                                panel.MouseIconPos.Y = panel.MouseIconPos.Y - 2
                                            elseif not CheckVectors(bannedPositions, Vector(panel.MouseIconPos.X,panel.MouseIconPos.Y+1)) then
                                                panel.MouseIconPos.Y = panel.MouseIconPos.Y + 1
                                            end
                                            panel.InputtedInput = "down"
                                        elseif rawinput.down == 0 and panel.InputtedInput=="down" then
                                            panel.InputtedInput = nil
                                        end
                                    end
                                end,
                            },
                            Offset = Vector.Zero,
                            Color = Color.Default,
                        },
                        {
                            Panel = {
                                Sprites = achievementTooltipSprites,
                                Bounds = {-115, -70, 115, 115},
                                Height = 44,
                                TopSpacing = 2,
                                BottomSpacing = 0,
                                DefaultFontSize = 2,
                                DrawPositionOffset = Vector(0, 2),
                                Draw = function(panel, panelPos, item, tbl)

                                    if selectedAch then
                                        local buttons = {}

                                        if type(selectedAch.Note) == "table" then
                                            for _, str in ipairs(selectedAch.Note) do
                                                table.insert(buttons, {str = tostring(str), fsize = 2})
                                            end      
                                        else
                                            table.insert(buttons, {str = selectedAch.Note, fsize = 2}) 
                                        end
                                        buttons[#buttons + 1] = {str = "", fsize = 2}

                                        for _, str in ipairs(selectedAch.Tooltip) do
                                            table.insert(buttons, {str = tostring(str), fsize = 2})
                                        end

                                        if not AnixbirthAchievementSystem:IsUnlocked(selectedAch.ID) then
                                            if not AnixbirthSaveManager.GetSettingsSave().lockAchTooltip or AnixbirthSaveManager.GetSettingsSave().lockAchTooltip == 2 then
                                                buttons = {}
                                            end
                                            buttons[#buttons + 1] = {str = "", fsize = 2}
                                            buttons[#buttons + 1] = {str = "currently", fsize = 2}
                                            buttons[#buttons + 1] = {str = "locked", fsize = 2}
                                        end

                                        local drawItem = {
                                            valign = -1,
                                            buttons = buttons
                                        }

                                        drawings = dssmod.generateMenuDraw(drawItem, drawItem.buttons, panelPos, panel.Panel)

                                        if selectedAch.Tags and (AnixbirthSaveManager.GetSettingsSave().lockAchTooltip == 1 or AnixbirthAchievementSystem:IsUnlocked(selectedAch.ID)) then
                                            local actNum = {}
                                            for i = 1, #selectedAch.Tags do
                                                if coOpBossList[selectedAch.Tags[i]] or mod:CheckTableContents(coOpSpriteList, selectedAch.Tags[i]) then
                                                    actNum[#actNum+1] = selectedAch.Tags[i]
                                                end
                                            end
                                            for i = 1, #actNum do
                                                if coOpBossList[selectedAch.Tags[i]] then
                                                    bossSprite:SetFrame("Destination", coOpBossList[actNum[i]])
                                                    bossSprite:Render(panelPos + Vector((-20*#actNum)+(20*i), 67))
                                                elseif mod:CheckTableContents(coOpSpriteList, actNum[i]) then
                                                    coOpSprite:Play(actNum[i])
                                                    coOpSprite:Render(panelPos + Vector((-20*#actNum)+(20*i), 70), Vector.Zero, Vector.Zero)
                                                end
                                            end
                                        end

                                        for _, drawing in ipairs(drawings) do
                                            dssmod.drawMenu(tbl, drawing)
                                        end
                                    end
                                end,
                                DefaultRendering = true
                            },
                            Offset = Vector(180, -2),
                            Color = 1
                        }
                    }
                },
            buttons = {buttonAchievements},
            generate = function(item, tbl) -- Becky specific

            end,
        }
        FHAC.dmdirectory.unlockspopup = {
                title = "achievements ?",
                fsize = 1,
                buttons = {
                    {str = "a majority of anixbirth's", nosel = true},
                    {str = "is locked behind achievements", nosel = true},
                    {str = "", nosel = true},
                    {str = "this is an optional feature", nosel = true},
                    {str = "", nosel = true},
                    {str = "continue with", fsize = 2, nosel = true},
                    {str = "said changes?", fsize = 2, nosel = true},
                    {str = "", nosel = true},
                    {
                        str = "yes",
                        action = "resume",
                        fsize = 3,
                        glowcolor = 3,

                        func = function()
                            AnixbirthSaveManager.GetSettingsSave().lockall = 1
                            AnixbirthSaveManager.GetPersistentSave().shownUnlocksChoicePopup = true
                            AnixbirthAchievementSystem:Setup()
                        end,
                    },
                    {
                        str = "no",
                        action = "resume",
                        fsize = 3,

                        func = function()
                            AnixbirthSaveManager.GetSettingsSave().lockall = 2
                            AnixbirthSaveManager.GetPersistentSave().shownUnlocksChoicePopup = true
                            AnixbirthAchievementSystem:Setup()
                        end
                    },

                    {str = "", nosel = true},
                },
                tooltip = {strset = {'you may', 'change options', 'later'}}
        }
        FHAC.dmdirectory.resetSavedata = {
                title = "reset savedata?",
                fsize = 1,
                buttons = {
                    {str = "you cannot undo this", nosel = true},
                    {str = "", nosel = true},
                    {str = "continue with", fsize = 2, nosel = true},
                    {str = "said changes?", fsize = 2, nosel = true},
                    {str = "", nosel = true},
                    {
                        str = "yes",
                        action = "resume",
                        fsize = 3,
                        glowcolor = 3,

                        func = function()
                            --thanks epiph
                            local modSave = AnixbirthSaveManager.GetEntireSave()
                            modSave.file.other = nil
                            modSave = AnixbirthSaveManager.Utility.PatchSaveFile(modSave, AnixbirthSaveManager.DEFAULT_SAVE)
                            AnixbirthSaveManager.GetPersistentSave().SAVE_VERSION = 4
                            AnixbirthSaveManager.Save()
                        end,
                    },
                    {
                        str = "no",
                        action = "resume",
                        fsize = 3,
                    },

                    {str = "", nosel = true},
                },
                tooltip = {strset = {'you cannot', 'undo this'}}
        }
        FHAC.dmdirectory.other =  {
                title = 'miscallaneous',
                buttons = {
                    {str = '----------', fsize=2, nosel = true},
                    {str = 'newsletters', fsize = 3, dest = 'newslettershub',tooltip = {strset = {'---','read our', 'cool','newsletters', '---'}}},         
                    {str = '----------', fsize=2, nosel = true},
                    {str = '', fsize=2, nosel = true},



                    {str = '----------', fsize=2, nosel = true, displayif = function(_, item)

                        if FHAC.fhacDSSDeveloperMode then return true end

                        return false
                    end},
                    {str = 'characters', nosel = true, displayif = function(_, item)

                        if FHAC.fhacDSSDeveloperMode then return true end

                        return false
                    end},
                    {str = '----------', fsize=2, nosel = true, displayif = function(_, item)

                        if FHAC.fhacDSSDeveloperMode then return true end

                        return false
                    end},
                    {
                        str = 'johannes',
                        action= "back",
                        fsize=2,
                        func = function(button, item, root)
                            Isaac.ExecuteCommand("restart ".. Isaac.GetPlayerTypeByName("Johannes"))
                            FHAC.dssmod.reloadButtons(root, root.Directory.settings)
                        end,
                        tooltip = {strset = {'restart as', 'johannes'}},
                        displayif = function(_, item)

                            if FHAC.fhacDSSDeveloperMode then return true end

                            return false
                        end
                    },
                    {str = '----------', fsize=2, nosel = true, displayif = function(_, item)

                        if FHAC.fhacDSSDeveloperMode then return true end

                        return false
                    end},
                    {
                        str = 'pongon',
                        action= "back",
                        fsize=2,
                        func = function(button, item, root)
                            Isaac.ExecuteCommand("restart ".. Isaac.GetPlayerTypeByName("Pongon"))
                            FHAC.dssmod.reloadButtons(root, root.Directory.settings)
                        end,
                        tooltip = {strset = {'restart as', 'pongon'}},
                        displayif = function(_, item)

                            if FHAC.fhacDSSDeveloperMode then return true end

                            return false
                        end
                    },
                },
        }
        FHAC.dmdirectory.newslettershub = {
            title = 'newsletters',
            buttons = newsletterbuttons
        }
        FHAC.dmdirectory.yesNo = {
                title = mod:GetNestedVariable(AnixbirthSaveManager.GetSettingsSave(), "DSSSavedata", "YesNo", "Name" ),
                fsize = 1,
                buttons = {
                    {str = "would you wish", nosel = true},
                    {str = "to proceed with", nosel = true},
                    {str = "your choice?", fsize = 2, nosel = true},
                    {str = "", nosel = true},
                    {
                        str = "yes",
                        action = "back",
                        fsize = 3,
                        glowcolor = 3,

                        func = function()
                            AnixbirthSaveManager.GetSettingsSave()[mod:GetNestedVariable(AnixbirthSaveManager.GetSettingsSave(), "DSSSavedata", "YesNo", "Variable" )] = mod:GetNestedVariable(AnixbirthSaveManager.GetSettingsSave(), "DSSSavedata", "YesNo", "Outcome" )
                        end,
                    },
                    {
                        str = "no",
                        action = "back",
                        fsize = 3,
                    },

                    {str = "", nosel = true},
                },
                tooltip = {strset = mod:GetNestedVariable(AnixbirthSaveManager.GetSettingsSave(), "DSSSavedata", "YesNo", "Tooltip" )}
        }
        

        local dmdirectorykey = {
            Item = FHAC.dmdirectory.main,
            Main = 'main',
            Idle = false,
            MaskAlpha = 1,
            Settings = {},
            SettingsChanged = false,
            Path = {},
        }

        DeadSeaScrollsMenu.AddMenu("Anixbirth", {Run = FHAC.dssmod.runMenu, Open = FHAC.dssmod.openMenu, Close = FHAC.dssmod.closeMenu, Directory = FHAC.dmdirectory, DirectoryKey = dmdirectorykey})
        mod.HasLoadedDSSReal = true
    end
end)

include("scripts.deadseascrolls.newsletters")

for hook = InputHook.IS_ACTION_PRESSED, InputHook.IS_ACTION_TRIGGERED do
	mod:AddCallback(ModCallbacks.MC_INPUT_ACTION, function(_, entity, hook, action)
		if paused and action ~= ButtonAction.ACTION_CONSOLE then
			return false
		end
	end, hook)
end

mod:AddCallback(ModCallbacks.MC_INPUT_ACTION, function(_, entity, hook, action)
    if forceUnpause and action == ButtonAction.ACTION_SHOOTDOWN then
		forceUnpause = false
		return 0.75
	end
end, InputHook.GET_ACTION_VALUE)