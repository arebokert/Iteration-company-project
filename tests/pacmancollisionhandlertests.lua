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

require('model.games.pacman.collisionhandler')
require('model.games.pacman.player')

-- the acutal test function, test if subfunction runPacmanCollisionhandlerFunctions() doesn't cranch and return true
-- 
function testCrashCollisionhandler() -- tests if any of the functions in Player.lua crashes
  assertTrue(runCollisionhandlerFunctions())
end


-- run all the functions in the pacman.collisionhandler.lua
-- returns true if non of the functions crash
-- @return: true
function runCollisionhandlerFunctions() -- runs the functions in Collisionhandler.lua
  player = Player:new("pacman")   
  Player:setPos(1,2)
  value = checkCollision(player, player, 25)
  value = inRange(2,1,3)  
  return true
end

-- test if function collisionhandler returns true if pacman collision with ghost 
function testCheckCollision()
  block = 25
  player1 = Player:new("pacman")
  player1:setPos(0,0) 
  player2 = Player:new("ghost")
  player2:setPos(0,0) 
  assertEquals(checkCollision(player1, player2, block), true)
  
  player1:setPos(0,0) 
  player2:setPos(50,50) 
  assertEquals(checkCollision(player1, player2, block), false)
  
  player1:setPos(0,0) 
  player2:setPos(24,24) 
  assertEquals(checkCollision(player1, player2, block), false)
  
  player1:setPos(0,0) 
  player2:setPos(23,23) 
  assertEquals(checkCollision(player1, player2, block), true)
end

-- test if function collisionhandler returns false if pacman are in same x-coordinate but not y-coordinate as ghost 
function testCheckCollisionX()
  player1 = Player:new("pacman")
  player2 = Player:new("ghost")

  player1:setPos(0,0) 
  player2:setPos(0,24) 
  assertEquals(checkCollision(player1, player2, block), false)
  
  player1:setPos(0,24) 
  player2:setPos(0,0) 
  assertEquals(checkCollision(player1, player2, block), false)
  
  player1:setPos(0,23) 
  player2:setPos(0,0) 
  assertEquals(checkCollision(player1, player2, block), true)
  
  player1:setPos(0,0) 
  player2:setPos(0,23) 
  assertEquals(checkCollision(player1, player2, block), true)
end

-- test if function collisionhandler returns false if pacman are in same y-coordinate but not x-coordinate as ghost 
function testCheckCollisionY()
  player1 = Player:new("pacman")
  player2 = Player:new("ghost")

  player1:setPos(0,0) 
  player2:setPos(24,0) 
  assertEquals(checkCollision(player1, player2, block), false)
  
  player1:setPos(24,0) 
  player2:setPos(0,0) 
  assertEquals(checkCollision(player1, player2, block), false)
  
  player1:setPos(23,0) 
  player2:setPos(0,0) 
  assertEquals(checkCollision(player1, player2, block), true)
  
  player1:setPos(0,0) 
  player2:setPos(23,0) 
  assertEquals(checkCollision(player1, player2, block), true)
end

-- tesst if function inrange returns correct value depending on input 
function testInRange()
  assertTrue(inRange(2,1,3))
  assertFalse(inRange(2,2,3))
  assertFalse(inRange(2,1,2))
  assertFalse(inRange(2,2,2))
end


os.exit( LuaUnit.run() ) -- always end a test file with this line