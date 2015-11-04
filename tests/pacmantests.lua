package.path = package.path .. ";../src/model/pacman/?.lua"

EXPORT_ASSERT_TO_GLOBALS = true;

require('luaunit') -- always start a test file with this line

require('player')

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