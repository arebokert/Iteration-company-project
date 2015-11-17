-- Hopefully we can make use of this test when the server is up and this runs through Jenkins. If the server is not running it may be difficult.
-- Potentially can make sure to run the server locally before running the test. 

-- getting us to the appropriate folder
package.path = package.path .. ";../src/?.lua" -- only searches for .lua, potential issues with .py-files. 

EXPORT_ASSERT_TO_GLOBALS = true;

-- always start a test file with this line
require('luaunit')

-- changeing the varible ADLogger to the mocked version
-- makes it possible to run the Zenterio API-function ADLogger in the command prompt without crashing
ADLogger = require("SDK.Mocked.ADLogger")

-- changing the entire zenterio API to be the mocked version.
    gfx = require "SDK.Mocked.gfx"
    zto = require "SDK.Mocked.zto"
    surface = require "SDK.Mocked.surface"
    player = require "SDK.Mocked.player"
    freetype = require "SDK.Mocked.freetype"
    sys = require "SDK.Mocked.sys"
    network = require "network.NetworkHandler"

-- requireing the file which we're testing (it in turn should require the necessary models for integration testing) 
require('model.highscore.highscorehandler')

-- Adds a highscore to the server, and tries to retrieve it again. If they match, the test passes.
function testOwnHighscore()
  hs = HighscoreHandler:new("p", 10, true) -- wanted to try submitGlobalHighscore, but it uses "self.gameName" so think I have to create a highscore object first.
  hs:newEntry("test", 5000)
  hstable = hs:retrieveOwnGlobalHighscore()
  y = hstable[1]
  x = y[1]
  assertEquals(5000, x)
end

function testTopHighscore()
-- TODO implement this.
end


-- always end a test file with this line
os.exit( LuaUnit.run() )