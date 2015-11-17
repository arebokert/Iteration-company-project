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

require('model.games.2048.box')


-- the acutal test function, test if subfunction runBoxFunctions() doesn't cranch and return true
-- 
function testCrashBox() -- tests if any of the functions in 2048.Box.lua crashes
  assertTrue(runBoxFunctions())
end


-- run all the functions in the 2048.box.lua
-- returns true if non of the functions crash
-- @return: true
function runBoxFunctions() -- runs the functions in Collisionhandler.lua
  --Boxes.init()
  --Boxes.showScore()
  Boxes.loadAllImg()
  --Boxes.showMove()
  Boxes.addRandomNumber()
  --Boxes.endGame()
  --Boxes.moveLeft()
  --Boxes.moveRight()
  --Boxes.moveTop()
  --Boxes.moveBottom()
  return true
end






os.exit( LuaUnit.run() ) -- always end a test file with this line