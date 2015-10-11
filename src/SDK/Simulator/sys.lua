
local class = require( "SDK.Lib.classy" )

--Helpers

local ADTimerHelper = class("ADTimerHelper")
function ADTimerHelper:__init(interval_millisec, callback)
  self.interval_millisec = interval_millisec
  self.callback = callback
  self.running = false
  self.time_since = 0
end

function ADTimerHelper:set_interval(interval_millisec)
  self.interval_millisec = interval_millisec
end
function ADTimerHelper:stop()
  self.running = false
  self.time_since = 0
end
function ADTimerHelper:start()
  self.running = true
end

local sys = class( "sys")

---Create Timer
-- *************** Zenterio API Doc ********************************
--  Creates and starts a timer that calls <callback> every <interval_millisec>.
--  <callback> can be a function or a string.
--  If a string, the global variable of this name will be fetched each
--  time the timer triggers and that variable will be called, assuming
--  it is a function. In this way, callbacks can be replaced in real-time.

--  The callback function is called with signature:
--  callback(timer)
--  where <timer> is the timer object that triggered the event
-- *****************************************************************
-- @param interval_millisec
-- @param callback
-- @return timer

function sys.new_timer(interval_millisec, callback)
  ADLogger.trace("New timer created. Calling: " .. callback .. " every " .. interval_millisec)
  new_timer = ADTimerHelper(interval_millisec, callback)
  new_timer:start()
  table.insert(sys.timers, new_timer)
  return new_timer
end

---Get Time
-- *************** Zenterio API Doc ********************************
--  Returns the time since the system started, in seconds and fractions
--  of seconds. Useful to measure lengths of time.
-- *****************************************************************
-- @param interval_millisec
function sys.time()
  return love.timer.getTime()
end


---Stop
-- *************** Zenterio API Doc ********************************
--  Terminates the execution of the script. The rest of the currently
--  executing code will be run, but all timers are stopped and the
--  current script environment will never be called again.
-- *****************************************************************
function sys.stop()
  love.event.quit()
end

---Get Root Path
-- *************** Zenterio API Doc ********************************
--  If a script was started with "sendcmd LuaEngine run", this variable
--  contains the path of that script, to allow finding files related to
--  the script.
-- *****************************************************************
-- @return root_path
function sys.root_path()
  return love.filesystem.getUserDirectory()
end

---Create New Player
-- *************** Zenterio API Doc ********************************
--  Create a new player instance.
-- *****************************************************************
-- @return player
function sys.new_player()
  local player = player()  
  return player
end

---New Freetype
-- *************** Zenterio API Doc ********************************
--  Create new freetype instance, which draw a text on the surface. Font
--  parameters: color, size, and path to .ttf file are a input arguments.
--  Argument <drawingStartPoint> is a left upper corner a start point
--  to a drawing text.
-- *****************************************************************
-- @return freetype
function sys.new_freetype(fontColor, fontSize, drawingStartPoint, fontPath)
  local freetype = freetype(fontColor, fontSize, drawingStartPoint, fontPath)
  return freetype;
end

sys.timers = {}

return sys