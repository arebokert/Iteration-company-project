luaunit = require('luaunit')

-- perhaps path must be specified differently, as SDK is not a folder from where this file is located.
gfx = require "SDK.Simulator.gfx"

function apitest()

gfx.update()
luaunit.assertEquals(1,1)

end

os.exit( luaunit.LuaUnit.run() )
