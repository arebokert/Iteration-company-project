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

require('model.games.pacman.player')
--require('model.games.pacman.gameplan')


-- the acutal test function, test if subfunction runPacmanPLayerFunctions() doesn't cranch and return true
-- 
function testCrashPlayer() -- tests if any of the functions in Player.lua crashes
  assertTrue(runPlayerFunctions())
end


-- run all the functions in the pacman.player.lua
-- returns true if non of the functions crash
-- @return: true
function runPlayerFunctions() -- runs the functions in Player.lua
  value = Player:movement()
  pacman = Player:new("pacman")   
  ghost = Player:new("ghost")
  Player:setPos(1,2)
  value = Player:getPos()
  ghost:Randomdirection()
  
  return true
end


-- test if function movement returns correct values after the position is set
function testMovement()
  Player:setPos(0,0) 
  assertEquals(Player:movement(), {x=0, y=0})
  
  Player:setPos(1,1)
  assertEquals(Player:movement(), {x=1, y=1})
  
  Player:setPos(-1,-1)
  assertEquals(Player:movement(), {x=-1, y=-1})
end


-- test invalid values for function movement
function testInvalidMovement() 
  Player:setPos(1,1)
  assertNotEquals(Player:movement(), {x=2, y=1})
  
  Player:setPos(-1,-2)
  assertNotEquals(Player:movement(), {x=-1, y=-1})
end


-- test if pacman and ghost player can be created
function testNew()
  assertEquals(Player:new("pacman"), {type="pacman"})
  assertEquals(Player:new("ghost"), {type="ghost"})
end 


-- test if function getPos returns correct values after the position is set
function testGetPos()
  Player:setPos(1,1)
  result = {x=1, y=1}
  assertEquals(Player:getPos(), result)
  
  Player:setPos(0,0)
  result = {x=0, y=0}  
  assertEquals(Player:getPos(), result)
  
  Player:setPos(-1,-1)  
  result = {x=-1, y=-1} 
  assertEquals(Player:getPos(), result)
  
  Player:setPos(1000,600)
  result = {x=1000, y=600}
  assertEquals(Player:getPos(), result)
  
  Player:setPos(1200,110)
  result = {x=1200, y=110}  
  assertEquals(Player:getPos(), result)
end 


-- test invalid values for function getPos
function testInvalidGetPos()
  Player:setPos(1,1)
  result = {x=1, y=2}
  assertNotEquals(Player:getPos(), result)
  Player:setPos(0,0)
  result = {x=1, y=0}  
  assertNotEquals(Player:getPos(), result)  
end


os.exit( LuaUnit.run() ) -- always end a test file with this line