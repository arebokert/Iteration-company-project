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
  --screen:clear({r=100, g=0, b=100})
  --gfx.update()

  gameStatus = true
end


function gamehandler.refresh()
  if gameStatus == true then
    gameStatus = gameplan:refresh()
  elseif gameStatus == false then
    gameTimer:stop()
  end
end


function gamehandler.pacmanOnKey(key, state)

  if key == "down" or key == "up" or key == "left" or key == "right" then
    gameplan:setPacmanDirection(key)
  end

  if key == "yellow" then
    gameplan:refresh()
  end

  if key == "play" then
    gameTimer = sys.new_timer(100, "gamehandler.refresh")
  end
  if key == "pause" then
    if gameTimer then
      gameTimer:stop()
    end
  end
  if key == "backspace" then
    gamehandler.loadPacman()
  end
  if key == "exit" then
    if gameTimer then
      gameTimer:stop()
    end
    screen:destroy()
    screen = gfx.new_surface(1280, 720)
    screen:clear({r=100,g=0,b=0})
    return false
  end

  if key == "ok" then
    gameplan:dumpPlayerPos()
  end

  return true
end

return gamehandler




