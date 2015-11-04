local class = require( "SDK.Lib.classy" )

local player = class( "SDK.Mocked.player")

function player:__init()
end

function player:play_url(url)
end

function player:stop(url)
end

function player:set_on_eos_pseudocallback(callback)
end

function player:get_state()
end

function player:set_aspect_ratio(aspect_ratio)
end

function player:set_player_window(x, y, width, height, refW, refH)
end

return player




