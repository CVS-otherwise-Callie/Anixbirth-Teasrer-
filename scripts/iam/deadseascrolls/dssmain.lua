local mod = FHAC
local game = Game()
local json = require("json")

local DSSModName = "FHAC Mod DSS Menu"

local DSSCoreVersion = 7

local MenuProvider = {}

local dsssaveManager = SaveManager.GetDeadSeaScrollsSave()

function MenuProvider.SaveSaveData()
    SaveManager.Save()
end

function MenuProvider.GetPaletteSetting()
	return dsssaveManager.MenuPalette
end

function MenuProvider.SavePaletteSetting(var)
	dsssaveManager.MenuPalette = var
end

function MenuProvider.GetHudOffsetSetting()
	if not REPENTANCE then
		return dsssaveManager.HudOffset
	else
		return Options.HUDOffset * 10
	end
end

function MenuProvider.SaveHudOffsetSetting(var)
	if not REPENTANCE then
		dsssaveManager.HudOffset = var
	end
end

function MenuProvider.GetGamepadToggleSetting()
	return dsssaveManager.GamepadToggle
end

function MenuProvider.SaveGamepadToggleSetting(var)
	dsssaveManager.GamepadToggle = var
end

function MenuProvider.GetMenuKeybindSetting()
	return dsssaveManager.MenuKeybind
end

function MenuProvider.SaveMenuKeybindSetting(var)
	dsssaveManager.MenuKeybind = var
end

function MenuProvider.GetMenuHintSetting()
	return dsssaveManager.MenuHint
end

function MenuProvider.SaveMenuHintSetting(var)
	dsssaveManager.MenuHint = var
end

function MenuProvider.GetMenuBuzzerSetting()
	return dsssaveManager.MenuBuzzer
end

function MenuProvider.SaveMenuBuzzerSetting(var)
	dsssaveManager.MenuBuzzer = var
end

function MenuProvider.GetMenusNotified()
	return dsssaveManager.MenusNotified
end

function MenuProvider.SaveMenusNotified(var)
	dsssaveManager.MenusNotified = var
end

function MenuProvider.GetMenusPoppedUp()
	return dsssaveManager.MenusPoppedUp
end

function MenuProvider.SaveMenusPoppedUp(var)
	dsssaveManager.MenusPoppedUp = var
end
local DSSInitializerFunction = include("scripts.iam.deadseascrolls.dssmenucore")
local Lore = include("scripts.iam.deadseascrolls.da lore")
local dssmod = DSSInitializerFunction(DSSModName, DSSCoreVersion, MenuProvider)

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


local dmdirectory = {
    main = {
        title = 'hope (teasrer)',

        buttons = {
            {str = 'resume game', action = 'resume'},
            {str = 'settings', dest = 'settings',tooltip = {strset = {'---','play around', 'with what', 'you like and', 'do not like', '---'}}},
            {str = 'other', dest = 'other',tooltip = {strset = {'---','the misc,', 'the huh,', 'and the', 'why!', '---'}}},         
            {str = 'achievements', dest = 'achievements',tooltip = {strset = {'---','force lock or', 'unlock things ','', 'recommended to', 'keep stuff locked', '---'}}},
            dssmod.changelogsButton,
            {str = '', fsize=2, nosel = true},
            {str = 'this mod is', fsize = 2, nosel = true},
            {str = 'still in early dveleopment', fsize = 2, nosel = true},
            {str = 'check us out', fsize = 2, nosel = true},
            {str = 'a good while later!!', fsize = 2, nosel = true},
        },
        tooltip = dssmod.menuOpenToolTip,
    },

    settings =  {
            title = 'settings',
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
                            return dsssaveManager.monsterReplacements or 1
                        end,
                        store = function(var)
                            dsssaveManager.monsterReplacements = var
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
                            return dsssaveManager.customFortunes or 1
                        end,
                        store = function(var)
                            dsssaveManager.customFortunes = var
                        end,
                        tooltip = {strset = {'allow for', 'fortune', 'replacements', '', 'on by', 'default'}}
                    },
                    {str = '', fsize=2,displayif = function(_, item)
                        if item and item.buttons then
                            for _, button in ipairs(item.buttons) do
                                if button.str == 'custom fortunes' then
                                    return button.setting == 1
                                end
                            end
                        end
    
                        return false
                    end, nosel = true},
                    {
                        str = 'fortunes on death',
                        increment = 1, max = 10,
                        variable = "fortuneDeathChance",
                        slider = true,
                        setting = 3,
                        load = function()
                            return dsssaveManager.fortuneDeathChance or 3
                        end,
                        store = function(var)
                            dsssaveManager.fortuneDeathChance = var
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
                    {str = '', fsize=2,displayif = function(_, item)
                        if item and item.buttons then
                            for _, button in ipairs(item.buttons) do
                                if button.str == 'custom fortunes' then
                                    return button.setting == 1
                                end
                            end
                        end
    
                        return false
                    end, nosel = true},
                    {
                        str = 'fortune language',
                        choices = {'english', 'chinese'},
                        variable = "fortuneLanguage",
                        setting = 1,
                        load = function()
                            return dsssaveManager.fortuneLanguage or 1
                        end,
                        store = function(var)
                            dsssaveManager.fortuneLanguage = var
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
                            return dsssaveManager.customRoomMusic or 2
                        end,
                        store = function(var)
                            dsssaveManager.customRoomMusic = var
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
            {str = 'catacombs', nosel = true},
            {
                str = 'pretty mushlooms',
                fsize=2,
                choices = {'normal', 'pretty', 'shaded pretty'},
                variable = "prettyMushlooms",
                setting = 1,
                load = function()
                    return dsssaveManager.prettyMushlooms or 1
                end,
                store = function(var)
                    dsssaveManager.prettyMushlooms = var
                end,
                tooltip = {strset = {'pretty','mushloom', 'made by', 'onxc_kryptid','','normal by', 'default'}}
            }
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
            {str = 'the lore', dest = 'lore'},
            {str = '----------', fsize=2, nosel = true},
            {str = 'characters', nosel = true},
            {str = '----------', fsize=2, nosel = true},
            {
                str = 'johannes',
                action= "back",
                fsize=2,
                func = function(button, item, root)
                    Isaac.ExecuteCommand("restart ".. Isaac.GetPlayerTypeByName("Johannes"))
                    dssmod.reloadButtons(root, root.Directory.settings)
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
                    dssmod.reloadButtons(root, root.Directory.settings)
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
    Item = dmdirectory.main,
    Main = 'main',
    Idle = false,
    MaskAlpha = 1,
    Settings = {},
    SettingsChanged = false,
    Path = {},
}

DeadSeaScrollsMenu.AddMenu("Anixbirth", {Run = dssmod.runMenu, Open = dssmod.openMenu, Close = dssmod.closeMenu, Directory = dmdirectory, DirectoryKey = dmdirectorykey})



function mod:IsSettingOn(setting)
	if setting == 1 then
		return true
	else
		return false
	end
end