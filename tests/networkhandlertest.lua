package.path = package.path .. ";../src/?.lua"

EXPORT_ASSERT_TO_GLOBALS = true;

require('luaunit') -- always start a test file with this line
network = require('NetworkHandler')

function testconvertRequestToPrefix(request)
    assertEquals(network:convertRequestToPrefix("QuickStart"), "QS")

end



os.exit( LuaUnit.run() ) -- always end a test file with this line