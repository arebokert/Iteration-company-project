luaunit = require('luaunit')

package.path = package.path .. ";../src/SDK/Simulator/?.lua"

gfx = require('gfx')
player = require('player')

function apitest()

gfx.update()
player.get_state()
luaunit.assertEquals()

end

os.exit( luaunit.LuaUnit.run() )
