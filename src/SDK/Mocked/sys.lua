local class = require( "SDK.Lib.classy" )

local ADTimerHelper = class("SDK.Mocked.ADTimerHelper")

function ADTimerHelper:__init(interval_millisec, callback)
end

function ADTimerHelper:set_interval(interval_millisec)
end

function ADTimerHelper:stop()
end

function ADTimerHelper:start()
end

local sys = class( "SDK.Mocked.sys") -- not sure of this reference in class. Used in every mocked file. 

function sys.new_timer(interval_millisec, callback)
end

function sys.time()
end

function sys.stop()
end

function sys.root_path()
end

function sys.new_player()
end

function sys.new_freetype(fontColor, fontSize, drawingStartPoint, fontPath)
end

-- sys.timers = {}

return sys








