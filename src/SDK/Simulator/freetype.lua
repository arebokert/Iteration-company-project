## freetype module ##
local class = require( "SDK.Lib.classy" )

local freetype = class( "SDK.Simulator.freetype")

function freetype:__init()
end

function freetype:__init(fontColor, fontSize, drawingStartPoint, fontPath)
    self.fontColor = fontColor
    self.fontSize = fontSize
    self.drawingStartPoint = drawingStartPoint
    self.fontPath = fontPath
end

---Draw over Surface
-- *************** Zenterio API Doc ********************************
-- Draw a <text> on the <surface>. <freetype> is a Freetype object with set font
-- parameters before.
-- *****************************************************************
-- @param surface
-- @param text
function freetype:draw_over_surface(sur, text)
  love.graphics.setNewFont(self.fontPath, self.fontSize)
  sur:writeOver(text, self.fontColor, self.drawingStartPoint)
end

return freetype
