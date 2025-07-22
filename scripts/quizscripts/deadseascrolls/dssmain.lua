local mod = IsMoQu

local DSSModName = "IsMoQu Mod DSS Menu"

local DSSCoreVersion = 7

local MenuProvider = {}

function MenuProvider.SaveSaveData()
    IsMoQuSaveManager.Save()
end

function MenuProvider.GetPaletteSetting()
	return IsMoQuSaveManager.GetDeadSeaScrollsSave().MenuPalette
end

function MenuProvider.SavePaletteSetting(var)
	IsMoQuSaveManager.GetDeadSeaScrollsSave().MenuPalette = var
end

function MenuProvider.GetHudOffsetSetting()
	if not REPENTANCE then
		return IsMoQuSaveManager.GetDeadSeaScrollsSave().HudOffset
	else
		return Options.HUDOffset * 10
	end
end

function MenuProvider.SaveHudOffsetSetting(var)
	if not REPENTANCE then
		IsMoQuSaveManager.GetDeadSeaScrollsSave().HudOffset = var
	end
end

function MenuProvider.GetGamepadToggleSetting()
	return IsMoQuSaveManager.GetDeadSeaScrollsSave().GamepadToggle
end

function MenuProvider.SaveGamepadToggleSetting(var)
	IsMoQuSaveManager.GetDeadSeaScrollsSave().GamepadToggle = var
end

function MenuProvider.GetMenuKeybindSetting()
	return IsMoQuSaveManager.GetDeadSeaScrollsSave().MenuKeybind
end

function MenuProvider.SaveMenuKeybindSetting(var)
	IsMoQuSaveManager.GetDeadSeaScrollsSave().MenuKeybind = var
end

function MenuProvider.GetMenuHintSetting()
    return IsMoQu.IsMoQuSaveManager.GetDeadSeaScrollsSave().MenuHint
end

function MenuProvider.SaveMenuHintSetting(var)
	IsMoQuSaveManager.GetDeadSeaScrollsSave().MenuHint = var
end

function MenuProvider.GetMenuBuzzerSetting()
	return IsMoQuSaveManager.GetDeadSeaScrollsSave().MenuBuzzer
end

function MenuProvider.SaveMenuBuzzerSetting(var)
	IsMoQuSaveManager.GetDeadSeaScrollsSave().MenuBuzzer = var
end

function MenuProvider.GetMenusNotified()
	return IsMoQuSaveManager.GetDeadSeaScrollsSave().MenusNotified
end

function MenuProvider.SaveMenusNotified(var)
	IsMoQuSaveManager.GetDeadSeaScrollsSave().MenusNotified = var
end

function MenuProvider.GetMenusPoppedUp()
	return IsMoQuSaveManager.GetDeadSeaScrollsSave().MenusPoppedUp
end

function MenuProvider.SaveMenusPoppedUp(var)
	IsMoQuSaveManager.GetDeadSeaScrollsSave().MenusPoppedUp = var
end
local DSSInitializerFunction = include("quizscripts.deadseascrolls.dssmenucore")
IsMoQu.dssmod = DSSInitializerFunction(DSSModName, DSSCoreVersion, MenuProvider)

IsMoQu.dmdirectory = {
    main = {
        title = 'isaac mod quiz',

        buttons = {
            {str = 'resume game', action = 'resume'},
            {str = 'options', dest = 'options',tooltip = {strset = {'---','play around', 'with what', 'you like and', 'do not like', '---'}}},
            {str = 'credits', dest = 'credits',tooltip = {strset = {'---','thanking', 'everyone', 'who', 'contributed', '---'}}},         
            IsMoQu.dssmod.changelogsButton,
            {str = '', fsize=2, nosel = true},
            {str = 'thanks for playing', fsize = 2, nosel = true},
        },
        tooltip = IsMoQu.dssmod.menuOpenToolTip,
    },

    options =  {
            title = 'options',
                buttons = {
                    {
                        str = 'wrong answer punishment',
                        fsize = 2,
                        choices = {'enemies', 'send to last difficulty'},
                        variable = "punishment",
                        setting = 1,
                        load = function()
                            return IsMoQuSaveManager.GetSettingsSave().punishment or 2
                        end,
                        store = function(var)
                            IsMoQuSaveManager.GetSettingsSave().punishment = var
                        end,
                        tooltip = {strset = {'your punish-', 'ment for', 'getting', 'something wrong', '', 'last diff.', 'by default'}}
                        
                    },
                    {str = '', fsize=2, nosel = true},
                    {
                        str = 'correct answer highlight',
                        fsize = 2,
                        choices = {'is shown', 'not shown'},
                        variable = "showanswe",
                        setting = 1,
                        load = function()
                            return IsMoQuSaveManager.GetSettingsSave().showanswe or 2
                        end,
                        store = function(var)
                            IsMoQuSaveManager.GetSettingsSave().showanswe = var
                        end,
                        tooltip = {strset = {'tells you', 'what the right', 'answer is', 'on wrong','answer', '', 'not shown.', 'by default'}}
                        
                    },
                    {str = '', fsize=2, nosel = true},
                }
    },

    other =  {
        title = 'miscallaneous',
        buttons = {
            
        }
},
}

local dmdirectorykey = {
    Item = IsMoQu.dmdirectory.main,
    Main = 'main',
    Idle = false,
    MaskAlpha = 1,
    Settings = {},
    SettingsChanged = false,
    Path = {},
}

DeadSeaScrollsMenu.AddMenu("IsMoQu", {Run = IsMoQu.dssmod.runMenu, Open = IsMoQu.dssmod.openMenu, Close = IsMoQu.dssmod.closeMenu, Directory = IsMoQu.dmdirectory, DirectoryKey = dmdirectorykey})



function mod:IsSettingOn(setting)
	if setting == 1 then
		return true
	else
		return false
	end
end
