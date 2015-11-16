Gamehandler = {}

Gameplan = require "model.games.pacman.gameplan"
require("model.games.pacman.player")

--
-- Load a game of pacman 
--
function Gamehandler.loadPacman()
  -- Set the background for the view. 
  local pacmanbg = gfx.loadjpeg('views/pacman/data/pacmanbg.jpg')
  screen:copyfrom(pacmanbg, nil)
  pacmanbg:destroy()
  
  -- Initiate pacman 
  Gamehandler.startPacman()
end


function Gamehandler.startPacman()
  -- Initiate gameplan 
  gameplan = Gameplan:new()
  
  -- Choose map to load 
  local map = 'map1.txt'  
  if gameplan:loadMap(map) == false then
    -- Return false if the map is not found. 
    return false
  end 
  
  -- Display the map on a container
  container_width = 1000
  container_height = 600
  container = gfx.new_surface(container_width, container_height)
  containerPos = {x = 140, y = 60}
  gameplan:displayMap(container, containerPos)
  
  -- Gamestatus ? 
  gameStatus = true
end


function Gamehandler.refresh()
  if gameStatus == true then
    gameStatus = gameplan:refresh()
  elseif gameStatus == false then
    gameTimer:stop()
  end
end


function Gamehandler.pacmanOnKey(key)
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
    Gamehandler.startPacman()
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
    Gamehandler.refresh()
end
return Gamehandler




