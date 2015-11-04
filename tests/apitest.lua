luaunit = require('luaunit')

package.path = package.path .. ";../src/?.lua"

--ADConfig = require("Config.ADConfig")
--ADLogger = require("SDK.Utils.ADLogger")
--ADLogger.trace("Applicatio Init")

freetype = require("SDK.Mocked.freetype")

function apitest()

--gfx.update()
--player.get_state()
--luaunit.assertEquals()

end

os.exit( luaunit.LuaUnit.run() )
