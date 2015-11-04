local class = require( "SDK.Lib.classy" )

local gfx = class( "SDK.Mocked.gfx")

function gfx.new_surface(width, height)
--  return image_data, supposed to return this. Hopefully we won't need the return data, but if so check the original function
end

-- screen = gfx.new_surface(1280,720)  This had no function so I left it commented.

function gfx.update()
end

function gfx.loadpng(path)
  --return image_data
end

function gfx.loadjpeg(path)
--  return image_data
end

return gfx


