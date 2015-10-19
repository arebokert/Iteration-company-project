Page = require("page")
Game = require("game")

ADConfig = require("Config.ADConfig")
ADLogger = require("SDK.Utils.ADLogger")
ADLogger.trace("Applicatio Init")

if ADConfig.isSimulator then
    gfx = require "SDK.Simulator.gfx"
    zto = require "SDK.Simulator.zto"
    surface = require "SDK.Simulator.surface"
    player = require "SDK.Simulator.player"
    freetype = require "SDK.Simulator.freetype"
    sys = require "SDK.Simulator.sys"
end

-- load game 
function loadGame()

end

-- key event
function onKey(key, state)
Page.registerKey(key,state)
Game.registerKey(key,state)
end


function gameOver()

end

function changeGameModel()
end

function gameOptions()
end

function seeScore()
end

function exitGame()
end


-- entrance of the game
function onStart()
Page.showMainPage()
end