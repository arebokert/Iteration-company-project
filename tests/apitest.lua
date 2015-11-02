luaunit = require('luaunit')

local pathOfThisFile = ...
local folderOfThisFile = (...):match("(.-)[^%.]+$")
--local oneFolderUp = folderOfThisFile:match("(.-)[^%.]+$")

-- this gives nil value on onefolderup it seems.
-- gfx = require(oneFolderUp .. "src/SDK.Simulator.gfx")

function apitest()

-- gfx.update()
luaunit.assertEquals(folderOfThisFile,"/tests")

end

os.exit( luaunit.LuaUnit.run() )
