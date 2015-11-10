package.path = package.path .. ";../src/?.lua"

EXPORT_ASSERT_TO_GLOBALS = true;

require('luaunit') -- always start a test file with this line

--Include mock SDK
ADLogger = require('SDK.Mocked.ADLogger')
ADLogger = require('SDK.Mocked.ADLogger')
gfx = require "SDK.Mocked.gfx"
surface = require "SDK.Mocked.surface"
player = require "SDK.Mocked.player"
freetype = require "SDK.Mocked.freetype"
sys = require "SDK.Mocked.sys"

require('model.pacman.player')

function testCrashPlayer() -- tests if any of the functions in Player.lua crashes
  assertTrue(runPlayerFunctions())
end


function runPlayerFunctions() -- runs the functions in Player.lua
  value = Player:movement()
  value = Player:new("pacman")
  Player:setPos(1,2)
  value = Player:getPos(1,1)
  --Player:Randomdirection()
  
  return true
end

os.exit( LuaUnit.run() ) -- always end a test file with this line