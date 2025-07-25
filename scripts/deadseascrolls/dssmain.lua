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
local DSSInitializerFunction = include("scripts.deadseascrolls.dssmenucore")
local Lore = include("scripts.deadseascrolls.da lore")
FHAC.dssmod = DSSInitializerFunction(DSSModName, DSSCoreVersion, MenuProvider)

local function genLore(tab)
    local button = {}
    for k, v in ipairs(tab) do
        button = {
            str = v,
            nosel = true
        }
    end
    return button
end


FHAC.dmdirectory = {
    main = {
        title = 'hope (teasrer)',

        buttons = {
            {str = 'resume game', action = 'resume'},
            {str = 'options', dest = 'options',tooltip = {strset = {'---','play around', 'with what', 'you like and', 'do not like', '---'}}},
            {str = 'other', dest = 'other',tooltip = {strset = {'---','the misc,', 'the huh,', 'and the', 'why!', '---'}}},         
            {str = 'achievements', dest = 'achievements',tooltip = {strset = {'---','force lock or', 'unlock things ','', 'recommended to', 'keep stuff locked', '---'}}},
            FHAC.dssmod.changelogsButton,
            {str = '', fsize=2, nosel = true},
            {str = 'this mod is', fsize = 2, nosel = true},
            {str = 'still in early dveleopment', fsize = 2, nosel = true},
            {str = 'check us out', fsize = 2, nosel = true},
            {str = 'a good while later!!', fsize = 2, nosel = true},
        },
        tooltip = FHAC.dssmod.menuOpenToolTip,
    },

    options =  {
            title = 'options',
                buttons = {
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
                    {str = '', nosel = true, fsize=2,displayif = function(_, item)
                        if item and item.buttons then
                            for _, button in ipairs(item.buttons) do
                                if button.str == 'fortunes on death' then
                                    return button.setting == 1
                                end
                            end
                        end
    
                        return false
                    end},
                    {
                        str = 'fortune language',
                        choices = {'english', 'chinese', 'hylics'},
                        variable = "fortuneLanguage",
                        setting = 1,
                        load = function()
                            return AnixbirthSaveManager.GetSettingsSave().fortuneLanguage or 1
                        end,
                        store = function(var)
                            AnixbirthSaveManager.GetSettingsSave().fortuneLanguage = var
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
                        tooltip = {strset = {'changes the', 'languages for', 'mod fortunes', '', 'english by', 'default'}}
                    },
                    {str = '', fsize=2,nosel = true},
                    {str = '-----music-----', fsize=2, nosel = true},
                    {str = '', fsize=2, nosel = true},
                    {
                        str = 'room music',
                        choices = {'on', 'off'},
                        variable = "customRoomMusic",
                        setting = 1,
                        load = function()
                            return AnixbirthSaveManager.GetSettingsSave().customRoomMusic or 2
                        end,
                        store = function(var)
                            AnixbirthSaveManager.GetSettingsSave().customRoomMusic = var
                        end,
                        tooltip = {strset = {'allow for', 'rooms music', 'replacements', '', 'off by', 'default'}}
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
    },

    enemies = {
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
    },

    rocks = {
        --force rock pallate
    },

    room_names = {
        --add ff-like menu here
    },

    other =  {
        title = 'miscallaneous',
        buttons = {
            {str = '----------', fsize=2, nosel = true},
            {str = 'characters', nosel = true},
            {str = '----------', fsize=2, nosel = true},
            {
                str = 'johannes',
                action= "back",
                fsize=2,
                func = function(button, item, root)
                    Isaac.ExecuteCommand("restart ".. Isaac.GetPlayerTypeByName("Johannes"))
                    FHAC.dssmod.reloadButtons(root, root.Directory.settings)
                end,
                tooltip = {strset = {'restart as', 'johannes'}},
            },
            {str = '----------', fsize=2, nosel = true},
            {
                str = 'pongon',
                action= "back",
                fsize=2,
                func = function(button, item, root)
                    Isaac.ExecuteCommand("restart ".. Isaac.GetPlayerTypeByName("Pongon"))
                    FHAC.dssmod.reloadButtons(root, root.Directory.settings)
                end,
                tooltip = {strset = {'restart as', 'pongon'}},
            },
        }
},

    lore = {
        title = 'da lore',
        buttons = {
            genLore(FHAC.Lore)
        }
    }
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



function mod:IsSettingOn(setting)
	if setting == 1 then
		return true
	else
		return false
	end
end
