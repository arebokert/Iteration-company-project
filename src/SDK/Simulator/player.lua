local class = require( "SDK.Lib.classy" )

local player = class( "SDK.Simulator.player")

function player:__init()
end

--- Play URL
-- *************** Zenterio API Doc ********************************
-- Start playback a video context from <url>. URL should meet the requirements
-- of the specification.
-- ***************************************************************** 
-- @param url
function player:play_url(url)  
  self.url = url
  self.state = 4
end

--- Play URL
-- *************** Zenterio API Doc ********************************
-- Stop playback a video (player switches to 0 state)
-- ***************************************************************** 
-- @param url
function player:stop(url)  
  self.state = 0
end

--- Set On End Of Stream Pseudocallback
-- *************** Zenterio API Doc ********************************
-- Generate callback, when player get EOS.
-- ***************************************************************** 
-- @param callback
function player:set_on_eos_pseudocallback(callback)  
  self.cb = callback
end

--- Get State
-- *************** Zenterio API Doc ********************************
-- Return a player state.
-- ***************************************************************** 
-- @return state
function player:get_state()  
  return self.state
end

--- Set Aspect Ratio
-- *************** Zenterio API Doc ********************************
-- Set aspect ratio for video context. <aspect_ratio> should be a number that
-- represents the aspect ratio.
-- ***************************************************************** 
-- @praram aspect_ratio
function player:set_aspect_ratio(aspect_ratio)  
  self.aspect_ratio = aspect_ratio
end


--- Set Aspect Ratio
-- *************** Zenterio API Doc ********************************
--  Set player window position and size.
--  <x> and <y> are position for left upper corner the window,
--  <widht>, <height> represent a window size,
--  <refW>, <refH> represent reference size of the screen. Can be in pixel size,
--  or in percentage (<refW> = 100, <refH> = 100). Then other input parameters
--  also are interpreted in percent.
-- ***************************************************************** 
-- @param x
-- @param y
-- @param width
-- @param height
-- @param refW
-- @param refH
function player:set_player_window(x, y, width, height, refW, refH)
  self.x = x or 0
  self.y = y or 0
  self.width = width or 1280
  self.height = height or 720
  self.refW = refW or 100
  self.refH = refH or 100
end

return player
