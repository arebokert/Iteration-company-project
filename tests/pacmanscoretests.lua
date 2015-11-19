package.path = package.path .. ";../src/?.lua"

EXPORT_ASSERT_TO_GLOBALS = true;

-- always start a test file with this line
require('luaunit') 

--Include mock SDK
ADLogger = require('SDK.Mocked.ADLogger')
ADLogger = require('SDK.Mocked.ADLogger')
gfx = require "SDK.Mocked.gfx"
surface = require "SDK.Mocked.surface"
player = require "SDK.Mocked.player"
freetype = require "SDK.Mocked.freetype"
sys = require "SDK.Mocked.sys"

require('model.games.pacman.score')

-- tests if any of the functions in Score.lua crashes
function testCrashScore() 
 assertTrue(runScoreFunctions())
end

-- runs the functions in Score.lua
function runScoreFunctions() 
 countScore("Notyellowdot")
 value = getScore()
 resetScore()
 return true
end

-- tests that scorecount is adding 10 when "yellowdot" is sent in
-- tests that getScore function is returning the correct value
function testCountScore()
  result = 0
  assertEquals(getScore(),result)
  
  countScore("yellowdot")
  result = 10
  assertEquals(getScore(),result)
  
  countScore("yellowdot")
  countScore("yellowdot")
  countScore("yellowdot")
  countScore("Notyellowdot")
  countScore("yellowdot")
  result = 50
  assertEquals(getScore(),result)
end

-- tests that the reset-function is working
function testResetScore()
  resetScore()
  result = 0
  assertEquals(getScore(), result)
  
  countScore("yellowdot")
  countScore("yellowdot")
  assertNotEquals(getScore(), result)
  
  resetScore()
  assertEquals(getScore(), result)
end

os.exit( LuaUnit.run() ) -- always end a test file with this line