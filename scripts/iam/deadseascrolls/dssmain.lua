local mod = FHAC
local game = Game()
local json = require("json")

local DSSModName = "FHAC Mod DSS Menu"

local DSSCoreVersion = 7

local MenuProvider = {}

function MenuProvider.SaveSaveData()
	mod:SaveModData()
end

function MenuProvider.GetPaletteSetting()
	return FHAC.savedata.MenuPalette
end

function MenuProvider.SavePaletteSetting(var)
	FHAC.savedata.MenuPalette = var
end

function MenuProvider.GetHudOffsetSetting()
	if not REPENTANCE then
		return FHAC.savedata.HudOffset
	else
		return Options.HUDOffset * 10
	end
end

function MenuProvider.SaveHudOffsetSetting(var)
	if not REPENTANCE then
		FHAC.savedata.HudOffset = var
	end
end

function MenuProvider.GetGamepadToggleSetting()
	return FHAC.savedata.GamepadToggle
end

function MenuProvider.SaveGamepadToggleSetting(var)
	FHAC.savedata.GamepadToggle = var
end

function MenuProvider.GetMenuKeybindSetting()
	return FHAC.savedata.MenuKeybind
end

function MenuProvider.SaveMenuKeybindSetting(var)
	FHAC.savedata.MenuKeybind = var
end

function MenuProvider.GetMenuHintSetting()
	return FHAC.savedata.MenuHint
end

function MenuProvider.SaveMenuHintSetting(var)
	FHAC.savedata.MenuHint = var
end

function MenuProvider.GetMenuBuzzerSetting()
	return FHAC.savedata.MenuBuzzer
end

function MenuProvider.SaveMenuBuzzerSetting(var)
	FHAC.savedata.MenuBuzzer = var
end

function MenuProvider.GetMenusNotified()
	return FHAC.savedata.MenusNotified
end

function MenuProvider.SaveMenusNotified(var)
	FHAC.savedata.MenusNotified = var
end

function MenuProvider.GetMenusPoppedUp()
	return FHAC.savedata.MenusPoppedUp
end

function MenuProvider.SaveMenusPoppedUp(var)
	FHAC.savedata.MenusPoppedUp = var
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

                    {str = 'enemies',      
                    dest = 'enemies',
                    tooltip = {strset = {'turn on and', ' off what', 'enemies', 'show up', '', 'currently', 'does not', 'work yet'}}
                    },

                    {str = 'rocks',      
                    dest = 'rocks',
                    tooltip = {strset = {'edit what', 'rock pallate', 'you want to','show', '', 'currently', 'does not', 'work yet'}}
                    },

                    {str = 'room names',      
                    dest = 'room_names',
                    tooltip = {strset = {'edit the', 'room names', 'settings', '', 'currently', 'does not', 'work yet'}}
                    },

                    {
                        str = 'fortunes on death',
                        increment = 1, max = 10,
                        variable = "fortuneDeathChance",
                        slider = true,
                        setting = 3,
                        load = function()
                            return mod.fortuneDeathChance or 3
                        end,
                        store = function(var)
                            mod.fortuneDeathChance = var
                        end,
                        tooltip = {strset = {'whats the %', 'a fortune', 'shows on', 'a enemys', 'death?','', 'out of 10'}}
        
                    },
                }
    },

    enemies = {
        --add ff-like menu here
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