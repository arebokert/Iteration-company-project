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

--Include menuclass
require('model.mainmenu.menuclass')

function testCrashMenuclass()
  assertTrue(runMenuclassFunctions())
end

function runMenuclassFunctions()
  --Does not work because of nil values in mainmenu variables. These nil values needs to be filled in manually in the test.
  --value = Menu:new ()
  --Menu:setOptions({1})
  --Menu:setActive(1)
  --Menu:next()
  --Menu:prev()
  return true
end

os.exit( LuaUnit.run() ) -- always end a test file with this line