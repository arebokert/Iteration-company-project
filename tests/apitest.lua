luaunit = require('luaunit')

package.path = package.path .. ";../src/?.lua"

ADConfig = require("Config.ADConfig")
--ADLogger = require("SDK.Utils.ADLogger")
--ADLogger.trace("Applicatio Init")

root_path = ""
if ADConfig.isSimulator then
    gfx = require "SDK.Simulator.gfx"
    zto = require "SDK.Simulator.zto"
    surface = require "SDK.Simulator.surface"
    player = require "SDK.Simulator.player"
    freetype = require "SDK.Simulator.freetype"
    sys = require "SDK.Simulator.sys"
    root_path = ""
else
    root_path = sys.root_path()
end

function apitest()

--gfx.update()
--player.get_state()
--luaunit.assertEquals()

end

os.exit( luaunit.LuaUnit.run() )
