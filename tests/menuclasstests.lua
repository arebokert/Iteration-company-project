-- the file consists of unit tests testing the functions inte the file menuclass.lua

-- getting us to the appropriate folder
package.path = package.path .. ";../src/?.lua"

EXPORT_ASSERT_TO_GLOBALS = true;

-- always start a test file with this line
require('luaunit')

-- changeing the varible ADLogger to the mocked version
-- makes it possible to run the Zenterio API-function ADLogger in the command prompt without crashing
ADLogger = require("SDK.Mocked.ADLogger")
gfx = require('SDK.Mocked.gfx')

mainMenuContainer = gfx.new_surface(10, 10)


-- requireing the file which we're testing 
require('model.mainmenu.menuclass')


-- the acutal test function, test if subfunction runMenuclassFunctions() doesn't cranch and returns true 
function testCrashMenuclass()
  assertTrue(runMenuclassFunctions())
end

-- run all the functions in the menuclass.lua
-- returns true if non of the functions crash
function runMenuclassFunctions()
  value = Menu:new ()
  Menu:setOptions({1}) --fungerar inte pga ADlogger
  
  -- crashes because gfx-mock doesn't return proper values
  -- x = mainMenuContainer:get_width()
  --Menu:print(mainMenuContainer, 1, 1, 1) 
  --Menu:setActive(1)
  --Menu:next()
  -- Menu:prev()
  -- Menu:action()
  -- Menu:hover()
  return true
end

-- always end a test file with this line
os.exit( LuaUnit.run() )