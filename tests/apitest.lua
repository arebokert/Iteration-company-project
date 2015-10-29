luaunit = require('luaunit')

local pathOfThisFile = ...
local folderOfThisFile = (...):match("(.-)[^%.]+$")
local oneFolderUp = (...):match("(.-)[^%.]+$") --:match("(.-)[^%.]+$")

-- perhaps path must be specified differently, as SDK is not a folder from where this file is located.
gfx = require(oneFolderUp .. "src/SDK.Simulator.gfx")

function apitest()

gfx.update()
luaunit.assertEquals(1,1)

end

os.exit( luaunit.LuaUnit.run() )
