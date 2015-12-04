--## gfx module ##
local surface = require "SDK.Simulator.surface"
local class = require( "SDK.Lib.classy" )

local gfx = class( "gfx")

---Set Auto Update
-- *************** Zenterio API Doc ********************************
-- If set to true, any change to gfx.screen immediately triggers
-- gfx.update() to make the change visible. This slows the system if
-- the screen is updated in multiple steps but is useful for
-- interactive development.
-- *****************************************************************
-- @param bool
function gfx.set_auto_update(bool)
  --Not currently implemented
end

---New Surface
-- *************** Zenterio API Doc ********************************
-- Creates and returns a new 32-bit RGBA graphics surface of chosen
-- dimensions. The surface pixels are not initialized; clear() or
-- copyfrom() should be used for this.
-- <width> and <height> must be positive integers and each less than 10000.
-- An error is raised if enough graphics memory cannot be allocated.
-- *****************************************************************
-- @param width surface width in pixels
-- @param height surface height in pixels
-- @return image_data
function gfx.new_surface(width, height)
  --local image_data = surface()
  --image_data:change_size(width, height)
  local image_data = surface(width, height)
  return image_data
end



---
-- *************** Zenterio API Doc ********************************
-- Returns the number of bytes of graphics memory the application
-- currently uses. Each allocated pixel uses 4 bytes since all surfaces
-- are 32-bit. A limit of gfx.get_memory_limit() is enforced.
-- *****************************************************************
function gfx.get_memory_use()
  return 1000000
end

---
-- *************** Zenterio API Doc ********************************
-- The surface that shows up on the screen when gfx.update() is called.
-- Calling gfx.set_auto_update(true) makes the screen update
-- automatically when gfx.screen is changed (for development; too slow
-- for animations)
-- *****************************************************************
-- The main screen defaults to 1280x720
screen = gfx.new_surface(1280,720)



---
-- *************** Zenterio API Doc ********************************
-- Returns the maximum bytes of graphics memory the application is
-- allowed to use.
-- *****************************************************************
function gfx.get_memory_limit()
  --Not currently implemented
end

-- *************** Zenterio API Doc ********************************
-- Makes any pending changes to gfx.screen visible.
-- *****************************************************************.
function gfx.update()
  screen:draw()
end


-- *************** Zenterio API Doc ********************************
-- Loads the PNG image at <path> into a new surface that is
-- returned. The image is always translated to 32-bit
-- RGBA. Transparency is preserved. A call to surface:premultiply()
-- might be necessary for transparency to work.
-- An error is raised if not enough graphics memory can be allocated.
-- *****************************************************************
-- @param path location of image file
-- @return image_data
function gfx.loadpng(path)
  local image_data = surface()
  image_data:loadImage(path)
  return image_data
end

-- *************** Zenterio API Doc ********************************
-- Loads the JPEG image at <path> into a new surface that is returned.
-- The image is always translated to 32-bit RGBA. All pixels will be
-- opaque since JPEG does not support transparency.
-- An error is raised if not enough graphics memory can be allocated.
-- *****************************************************************
-- @param path location of image file
-- @return image_data
function gfx.loadjpeg(path)
  local image_data = surface()
  image_data:loadImage(path)
  return image_data
end

return gfx
