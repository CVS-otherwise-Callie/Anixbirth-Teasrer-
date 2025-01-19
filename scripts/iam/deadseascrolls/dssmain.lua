local mod = FHAC

local DSSModName = "FHAC Mod DSS Menu"

local DSSCoreVersion = 7

local MenuProvider = {}

function MenuProvider.SaveSaveData()
    SaveManager.Save()
end

function MenuProvider.GetPaletteSetting()
	return SaveManager.GetDeadSeaScrollsSave().MenuPalette
end

function MenuProvider.SavePaletteSetting(var)
	SaveManager.GetDeadSeaScrollsSave().MenuPalette = var
end

function MenuProvider.GetHudOffsetSetting()
	if not REPENTANCE then
		return SaveManager.GetDeadSeaScrollsSave().HudOffset
	else
		return Options.HUDOffset * 10
	end
end

function MenuProvider.SaveHudOffsetSetting(var)
	if not REPENTANCE then
		SaveManager.GetDeadSeaScrollsSave().HudOffset = var
	end
end

function MenuProvider.GetGamepadToggleSetting()
	return SaveManager.GetDeadSeaScrollsSave().GamepadToggle
end

function MenuProvider.SaveGamepadToggleSetting(var)
	SaveManager.GetDeadSeaScrollsSave().GamepadToggle = var
end

function MenuProvider.GetMenuKeybindSetting()
	return SaveManager.GetDeadSeaScrollsSave().MenuKeybind
end

function MenuProvider.SaveMenuKeybindSetting(var)
	SaveManager.GetDeadSeaScrollsSave().MenuKeybind = var
end

function MenuProvider.GetMenuHintSetting()
    return FHAC.SaveManager.GetDeadSeaScrollsSave().MenuHint
end

function MenuProvider.SaveMenuHintSetting(var)
	SaveManager.GetDeadSeaScrollsSave().MenuHint = var
end

function MenuProvider.GetMenuBuzzerSetting()
	return SaveManager.GetDeadSeaScrollsSave().MenuBuzzer
end

function MenuProvider.SaveMenuBuzzerSetting(var)
	SaveManager.GetDeadSeaScrollsSave().MenuBuzzer = var
end

function MenuProvider.GetMenusNotified()
	return SaveManager.GetDeadSeaScrollsSave().MenusNotified
end

function MenuProvider.SaveMenusNotified(var)
	SaveManager.GetDeadSeaScrollsSave().MenusNotified = var
end

function MenuProvider.GetMenusPoppedUp()
	return SaveManager.GetDeadSeaScrollsSave().MenusPoppedUp
end

function MenuProvider.SaveMenusPoppedUp(var)
	SaveManager.GetDeadSeaScrollsSave().MenusPoppedUp = var
end
local DSSInitializerFunction = include("scripts.iam.deadseascrolls.dssmenucore")
local Lore = include("scripts.iam.deadseascrolls.da lore")
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
                            return SaveManager.GetSettingsSave().monsterReplacements or 2
                        end,
                        store = function(var)
                            SaveManager.GetSettingsSave().monsterReplacements = var
                        end,
                        tooltip = {strset = {'some enemies', 'can be','replaced by', 'floor variants', '', 'half anf half', 'by default'}}
        
                    },
                    {str = '', fsize=2, nosel = true},
                    {str = '-----fortunes-----', fsize=2, nosel = true},
                    {str = '', fsize=2, nosel = true},

                    --[[str = 'rocks',      
                    dest = 'rocks',
                    tooltip = {strset = {'edit what', 'rock pallate', 'you want to','show', '', 'currently', 'does not', 'work yet'}}
                    }}

                    {str = 'room names',      
                    dest = 'room_names',
                    tooltip = {strset = {'edit the', 'room names', 'settings', '', 'currently', 'does not', 'work yet'}}
                    }},]]
                    {
                        str = 'custom fortunes',
                        choices = {'on', 'off'},
                        variable = "customFortunes",
                        setting = 1,
                        load = function()
                            return SaveManager.GetSettingsSave().customFortunes or 1
                        end,
                        store = function(var)
                            SaveManager.GetSettingsSave().customFortunes = var
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
                        increment = 1, max = 10,
                        variable = "fortuneDeathChance",
                        slider = true,
                        setting = 3,
                        load = function()
                            return SaveManager.GetSettingsSave().fortuneDeathChance or 3
                        end,
                        store = function(var)
                            SaveManager.GetSettingsSave().fortuneDeathChance = var
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
                        tooltip = {strset = {'whats the %', 'a fortune', 'shows on', 'a enemys', 'death?','', 'out of 10'}}
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
                        str = 'fortune language',
                        choices = {'english', 'chinese', 'hylics'},
                        variable = "fortuneLanguage",
                        setting = 1,
                        load = function()
                            return SaveManager.GetSettingsSave().fortuneLanguage or 1
                        end,
                        store = function(var)
                            SaveManager.GetSettingsSave().fortuneLanguage = var
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
                            return SaveManager.GetSettingsSave().customRoomMusic or 2
                        end,
                        store = function(var)
                            SaveManager.GetSettingsSave().customRoomMusic = var
                        end,
                        tooltip = {strset = {'allow for', 'rooms music', 'replacements', '', 'off by', 'default'}}
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
                    return SaveManager.GetSettingsSave().randomDried or 1
                end,
                store = function(var)
                    SaveManager.GetSettingsSave().randomDried = var
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
                    return SaveManager.GetSettingsSave().pallunShot or 1
                end,
                store = function(var)
                    SaveManager.GetSettingsSave().pallunShot = var
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
                    return SaveManager.GetSettingsSave().prettyMushlooms or 1
                end,
                store = function(var)
                    SaveManager.GetSettingsSave().prettyMushlooms = var
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
            {str = 'makefile', func = function()
                mod.OverlayMusic = true
            end
            },
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
