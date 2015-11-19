Gamehandler = {}

Gameplan = require "model.games.pacman.gameplan"
require("model.games.pacman.player")
GameplanGraphics = require("model.games.pacman.gameplangraphics")
Score = require("model.games.pacman.score")

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

-- This function is a help function for the loadPacman
-- Generates all needed objects, and calls the needed functions fto be able to play the game
function Gamehandler.startPacman()
  -- Initiate gameplan 
  gameplan = Gameplan:new()
  
  -- Choose map to load 
  local map = 'map2.txt'  
  if gameplan:loadMap(map) == false then
    -- Return false if the map is not found. 
    return false
  end 
  
  gameplan:resetLives()
  Score.resetScore()
  
  -- Display the map on a container
  container_width = 600
  container_height = 400
  container = gfx.new_surface(container_width, container_height)
  containerPos = {x = 300, y = 150}
  gameplan:displayMap(container, containerPos)
  
  -- Gamestatus ? 
  gameStatus = true
end

-- This function refreshes the game by one "frame"
-- Gets a boolean from thhe gameplan-refresh 
--      - True: No collision
--      - False: Collision - deduct one life and check if game over
function Gamehandler.refresh()
  if gameStatus == true then
    gameStatus = gameplan:refresh()
    if gameStatus == false then
      
      if gameplan:getLives() > 0 then
        gameplan:reloadPlayerPos()
        gameStatus = true
      end
    end
  elseif gameStatus == false and gameplan:getLives() < 1 then
    gameTimer:stop()
    GameplanGraphics.gameOver()
  end
end

-- The onKey-function for the pacman game
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

  return true
end

callback = function(timer)
    Gamehandler.refresh()
end
return Gamehandler