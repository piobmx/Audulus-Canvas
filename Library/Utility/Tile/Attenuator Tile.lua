----|| ATTENUATOR TILE ||--
-- v1.1


----|| INPUTS ||--__
-- in1 out1 knob1


----|| DECLARE CONSTANTS ||----

-- Themes --

TEXT_LIGHT = theme.text
TEXT_DARK = theme.grooves

RED = { 1, 0, 0, 1 }
GREEN = { 0, 1, 0, 1 }
BLUE = { 0, 0, 1, 1 }

-- Paints --

RED_LIGHT = color_paint(theme.redHighlight)
RED_DARK = color_paint(theme.redHighlightDark)
RED_BACKGROUND = color_paint(theme.redHighlightBackground)

GREEN_LIGHT = color_paint(theme.greenHighlight)
GREEN_DARK = color_paint(theme.greenHighlightDark)
GREEN_BACKGROUND = color_paint(theme.greenHighlightBackground)

BLUE_LIGHT = color_paint(theme.azureHighlight)
BLUE_DARK = color_paint(theme.azureHighlightDark)
BLUE_BACKGROUND = color_paint(theme.azureHighlightBackground)

GRAY_LIGHT = color_paint(theme.text)
GRAY_DARK = color_paint {0.3, 0.3, 0.3, 1}

GROOVES = color_paint(theme.grooves)
MODULES = color_paint(theme.modules)

-- Sizes --

SIZE_XL = 10
SIZE_L = 8
SIZE_M = 6
SIZE_S = 4
SIZE_XS = 2

TEXT_SMALL = 0.5
TEXT_NORMAL = 1
TEXT_LARGE = 2


----|| DEFINE FUNCTIONS ||----

--// Boilerplate functions //--

function adjustAlpha(input, colorTheme)
    --// Returns a paint color whose alpha value is modulated by the input
    return color_paint { colorTheme[1], colorTheme[2], colorTheme[3], colorTheme[4] * input }
end

function adjustBrightness(input, colorTheme)
    --// Returns a paint color whose brightness is modulated by the input
    return color_paint { colorTheme[1] * input, colorTheme[2] * input, colorTheme[3] * input, colorTheme[4] }
end

function createLight(type, input)
    --// Creates a paint color modulated by an input
    -- Type
    -- 0 = gate
    -- 1 = mod
    -- 2 = audio / any
    if type == 0 then
        return adjustAlpha(input, theme.azureHighlight)
    elseif type == 1 then
        return adjustBrightness(input, RED)
    elseif type == 2 then
        if input > 0 then
            return adjustBrightness(input, RED)
        else
            return adjustBrightness(-input, BLUE)
        end
    end
end

function drawInput(x, y, type, light, textX, textY, textContent, textSize)
    --// Draws an input light
    -- Type
    -- 0 = gate
    -- 1 = mod
    -- 2 = audio/any
    if type == 0 then
        textColor = TEXT_DARK
        stroke_circle({x, y}, 10, 1.5, BLUE_DARK)
        fill_circle({x, y}, 4.2, BLUE_LIGHT)
    elseif type == 1 then
        textColor = TEXT_DARK
        stroke_circle({x, y}, 10, 1.5, RED_DARK)
        fill_circle({x, y}, 4.2, RED_LIGHT)
    elseif type == 2 then
        textColor = TEXT_LIGHT
        stroke_circle({x, y}, 10, 1.5, GROOVES)
        fill_circle({x, y}, 4.2, MODULES)
    end

    -- Light ring
    stroke_circle({x, y}, 10, 1.5, light)

    -- Label
    drawText(textX, textY, textContent, textSize, textColor)
end

function drawOutput(x, y, type, light, textX, textY, textContent, textSize)
    --// Draws an output light
    -- Type
    -- 0 = gate
    -- 1 or 2 = mod/audio/any
    if type == 0 then
        textColor = TEXT_DARK
        fill_circle({x, y}, SIZE_S, BLUE_DARK)
        fill_circle({x, y}, SIZE_S, light)
    elseif type == 1 or type == 2 then
        textColor = TEXT_LIGHT
        fill_circle({x, y}, SIZE_S, light)
    end
    
    -- Label
    drawText(textX, textY, textContent, textSize, textColor)
end

function drawText(x, y, textContent, size, color)
    --// Draws text
    -- Save transform state
    save()

    -- Position
    translate {x, y}

    -- Resize
    scale {size, size}

    -- Draw
    text(textContent, color)
    
    -- Restore transform state
    restore()
end

--// Module-specific functions //--

function drawSineWaveBackground(x, y, size)
    -- // Draws a muted gray sine wave
    -- Define variables
    brightness = 0.3
    color = color_paint {brightness, brightness, brightness, 1}

    -- Save transform state
    save()

    -- Position
    translate {x, y}

    -- Draw the two segments of the sine wave
    stroke_bezier( {0, 0}, {0.25 * size , 1 * size}, {0.5 * size, 0}, width, color)
    stroke_bezier( {0.5 * size, 0}, {0.75 * size , -1 * size}, {1 * size, 0}, width, color)

    -- Restore transform state
    restore()
end

function drawSineWaveLevelIcon(x, y, size, control)
    -- // Draws a sine wave whose amplitude and orientation are responsive to a control input
    -- Define variables
    width = 1
    color = GRAY_LIGHT

    -- Save transform state
    save()

    -- Position
    translate {x, y}

    -- Draw the two segments of the sine wave
    stroke_bezier( {0, 0}, {0.25 * size , 1 * size * control}, {0.5 * size, 0}, width, color)
    stroke_bezier( {0.5 * size, 0}, {0.75 * size , -1 * size * control}, {1 * size, 0}, width, color)

    -- Restore transform state
    restore()
end

----|| DEFINE VARIABLES ||----

-- Lights --
---- createLight(type, input)

in1Light = createLight(2, in1)
out1Light = createLight(2, out1)


----|| DRAW ||----

--// Input //--
---- drawInput(x, y, type, light, textX, textY, textContent, textSize)
drawInput( 10, 10, 2, in1Light, 7.7, 8, "→", TEXT_SMALL )

--// Output //--
---- drawOutput(x, y, type, light, textX, textY, textContent, textSize)
drawOutput( 50, 10, 2, out1Light, 47.7, 8, "→", TEXT_SMALL )

--// Graphic //--
---- drawSineWaveLevelIcon(x, y, size, control)
drawSineWaveBackground( 20, 60, 20)
drawSineWaveLevelIcon( 20, 60, 20, knob1 )
