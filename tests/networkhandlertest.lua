package.path = package.path .. ";../src/?.lua"

EXPORT_ASSERT_TO_GLOBALS = true;

require('luaunit') -- always start a test file with this line
require('network.NetworkHandler')

function testconvertRequestToPrefix(request)
    assertEquals(convertRequestToPrefix("QuickStart"), "QS")
    assertEquals(convertRequestToPrefix("SubmitScore"), "SS")
    assertEquals(convertRequestToPrefix("FetchLastThree"), "LR/M")
    assertEquals(convertRequestToPrefix("FetchStatus"), "FS")
    assertEquals(convertRequestToPrefix("TerminateMatch"), "TM")
    assertEquals(convertRequestToPrefix("SendScore"), "SE")
    assertEquals(convertRequestToPrefix("RequestReadGlobalScore"), "RS")
    assertEquals(convertRequestToPrefix("RequestReadYourOwnScore"), "RO")
    assertEquals(convertRequestToPrefix("incorrect input"), "Invalid input")
end




os.exit( LuaUnit.run() ) -- always end a test file with this line