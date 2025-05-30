local monsters = {

}


local allMonstersY = {}

local daMonsGrid = {}

local maxRow, maxCol = 0, 0
for k, v in pairs(monsters) do
    local sprite = Sprite()
    sprite:Load("gfx/ui/ff_developers/dev.anm2", false)
    sprite:ReplaceSpritesheet(0, "gfx/ui/ff_developers/" .. k .. ".png")
    sprite:LoadGraphics()
    sprite:Play("Idle")
    v.sprite = sprite

    v.ySort = v.pos.Y + (v.ySortOffset or 0)

    if not daMonsGrid[v.row] then
        daMonsGrid[v.row] = {}
    end

    daMonsGrid[v.row][v.col] = v

    maxRow, maxCol = math.max(maxRow, v.row), math.max(maxCol, v.col)

    local insertAt = #allMonstersY + 1
    for i, dev in ipairs(allMonstersY) do
        if v.ySort < dev.ySort then
            insertAt = i
            break
        end
    end

    table.insert(allMonstersY, insertAt, v)
end

local paper = Sprite()
paper:Load("gfx/ui/ff_developers/paper.anm2", true)

local pMask = Sprite()
pMask:Load("gfx/ui/ff_developers/paper.anm2", true)
pMask:ReplaceSpritesheet(1, "gfx/ui/ff_developers/paper.png")
pMask:LoadGraphics()

FHAC.dmdirectory.awesomecredits = {
    format = {
        Panels = {
            {
                Panel = {
                    Sprites = {
                        Face = paper,
                        Mask = pMask
                    },
                    StartAppear = function(panel, tbl, skipOpenAnimation)
                        FHAC.dssmod.playSound(FHAC.dssmod.menusounds.Open)
                        FHAC.dssmod.defaultPanelStartAppear(panel, tbl, skipOpenAnimation)
                    end,
                    StartDisappear = function()
                        FHAC.dssmod.playSound(FHAC.dssmod.menusounds.Close)
                    end,
                    Draw = function(panel, panelPos, item)
                        for _, dev in ipairs(allMonstersY) do
                            local rpos = dev.pos + panelPos + Vector(-200, -112)
                            dev.sprite.Color = Color(0, 0, 0, 1, 221 / 255, 179 / 255, 226 / 255)
                            dev.sprite:Render(rpos, Vector.Zero, Vector.Zero)

                            if dev.buttonindex ~= item.bsel then
                                dev.sprite.Color = Color(1, 1, 1, 0.8, 0, 0, 0)
                            else
                                dev.sprite.Color = Color.Default
                            end

                            dev.sprite:Render(rpos, Vector.Zero, Vector.Zero)
                        end
                    end,
                    HandleInputs = function(panel, input, item, itemswitched, tbl)
                        FHAC.dssmod.handleInputs(item, itemswitched, tbl)
                    end,
                    DefaultRendering = true
                },
                Color = Color.Default,
                Offset = Vector(-50, 0)
            },
            {
                Panel = FHAC.dssmod.panels.tooltip,
                Offset = Vector(180, -2),
                Color = 1
            }
        }
    },
    generate = function()
    end,
    gridx = maxCol,
    buttons = {}
}

for row = 1, maxRow do
    for column = 1, maxCol do
        local button = {}
        local buttonIndex = #FHAC.dmdirectory.awesomecredits.buttons + 1
        if daMonsGrid[row][column] then
            local dev = daMonsGrid[row][column]
            dev.buttonindex = buttonIndex

            local baseFontSize = 2

            button.dest = dev.dest

            button.tooltip = {
                buttons = {
                    {str = dev.name, fsize = baseFontSize},
                    {str = dev.subheader, fsize = 1},
                }
            }

            if dev.subname then
                table.insert(button.tooltip.buttons, 1, {str = dev.subname, fsize = 1})
            end

            if dev.subheader2 then
                button.tooltip.buttons[#button.tooltip.buttons + 1] = {str = dev.subheader2, fsize = 1}
            end

            button.tooltip.buttons[#button.tooltip.buttons + 1] = {str = ""}

            if dev.tooltip then
                local extraFontSize = 2
                if #dev.tooltip > 6 then
                    extraFontSize = 1
                end

                for _, str in ipairs(dev.tooltip) do
                    button.tooltip.buttons[#button.tooltip.buttons + 1] = {str = str, fsize = extraFontSize}
                end
            end
        else
            button.nosel = true
        end

        FHAC.dmdirectory.awesomecredits.buttons[buttonIndex] = button
    end
end