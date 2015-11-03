gamehandler = {}

Gameplan = require "model.pacman.gameplan"
require("model.pacman.player")


function gamehandler.loadPacman()
  gamehandler.startPacman()
end


function gamehandler.startPacman()

  gameplan = Gameplan:new()
  gameplan:loadMap()
  gameplan:displayMap()

  gameStatus = true
end


function gamehandler.refresh()
  if gameStatus == true then
    gameStatus = gameplan:refresh()
  elseif gameStatus == false then
    gameTimer:stop()
  end
end


function gamehandler.pacmanOnKey(key)
  --For testing
  if key == "0" then
    gameplan:refresh()
  end

  if key == "down" or key == "up" or key == "left" or key == "right" then
    gameplan:setPacmanDirection(key)
  end
--[[
--Yellow doesn't work for some reason, resolve later!
  if key == "yellow" then
    gameplan:refresh()
  end
]]--
  if key == "ok" then
    gameTimer = sys.new_timer(100, "callback") -- starts a timer that calls function callback
  end

  if key == "pause" then
    if gameTimer then
      gameTimer:stop()
    end
  end

  if key == "1" then
    gamehandler.startPacman()
  end

  if key == "exit" then
    if gameTimer then
      gameTimer:stop()
    end
    screen:clear({r=100,g=0,b=0})
    return false
  end
--[[
  if key == "ok" then
    gameplan:dumpPlayerPos()
  end
]]--
  return true
end

callback = function(timer)
    gamehandler.refresh()
end
return gamehandler




