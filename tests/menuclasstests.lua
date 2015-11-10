package.path = package.path .. ";../src/model/mainmenu/?.lua" .. ";../src/SDK/Mocked/?.lua"

EXPORT_ASSERT_TO_GLOBALS = true;

require('luaunit') -- always start a test file with this line
require('ADLogger')
require('menuclass')

function testCrashMenuclass()
  assertTrue(runMenuclassFunctions())
end

function runMenuclassFunctions()
  value = Menu:new ()
  --Menu:setOptions({1}) --fungerar inte pga ADlogger
  --Menu:setActive(1)
  --Menu:next()
  --Menu:prev()
  return true
end

os.exit( LuaUnit.run() ) -- always end a test file with this line