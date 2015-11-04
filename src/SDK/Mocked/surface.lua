local class = require( "SDK.Lib.classy" )
local surface = class("SDK.Mocked.surface")

function surface:__init()
end

function surface:__init(width, height)
end

function surface:loadImage(path)
end

function surface:writeOver(text, fontColor, drawingStartPoint)
end

function surface:clear(color, rectangle)
end

function surface:draw()
end

function surface:get()
end

function surface:copyfrom(src_surface, src_rect, dest_rect, blend_option)
end

function surface:get_width()
end

function surface:get_height()
end

function surface:get_pixel(x, y)
end

function surface:set_pixel(x, y, color)
end

function surface:destroy()
end

function surface:set_alpha(alpha)
end

return surface










