Gamehandler = {}

Gameplan = require "model.games.pacman.gameplan"
GameplanGraphics = require("model.games.pacman.gameplangraphics")
Score = require("model.commongame.scorehandler")
InGameMenu = require("model.commongame.ingamemenuclass")

menuView = nil

--
-- Load a game of pacman 
--
function Gamehandler.loadPacman(width, height)
ADLogger.trace("Number load 1")
  -- Set the background for the view. 
  local pacmanbg = gfx.loadjpeg('views/pacman/data/pacmanbg.jpg')
  screen:copyfrom(pacmanbg, nil)
  pacmanbg:destroy()
  ADLogger.trace("Number load 2")
  -- Default values for width and height! 
  if width == nil then 
    width = 600
  end
  
  if height == nil then
    height = 400
  end
  ADLogger.trace("Number load 3")
  -- Display the map on a container
  Gamehandler.container = gfx.new_surface(width, height)
  Gamehandler.containerPos = {x = 300, y = 150}
    ADLogger.trace("Number load 4")
  -- Initiate pacman 
  Gamehandler.startPacman()
  --ADLogger.trace(collectgarbage("count")*1024)
end

-- This function is a help function for the loadPacman
-- Generates all needed objects, and calls the needed functions fto be able to play the game
function Gamehandler.startPacman()
  -- Initiate gameplan 
  ADLogger.trace("Number start 1")
  gameplan = Gameplan:new()
  ADLogger.trace("Number start 2")
  
  -- Choose map to load 
  local map = 'map2.txt'  
  ADLogger.trace("Number start 3")
  if gameplan:loadMap(map) == false then
    -- Return false if the map is not found. 
    return false
  end 
  ADLogger.trace("Number start 4")
  
  gameplan:resetLives()
  ADLogger.trace("Number start 5")
  Score.resetScore()
  ADLogger.trace("Number start 6")
  
  gameplan:displayMap(Gamehandler.container, Gamehandler.containerPos)
  ADLogger.trace("Number start 7")
  -- Gamestatus ? 
  gameStatus = true
end

-- This function refreshes the game by one "frame"
-- Gets a boolean from thhe gameplan-refresh 
--      - True: No collision
--      - False: Collision - deduct one life and check if game over
function Gamehandler.refresh()
ADLogger.trace("Number start 1")
ADLogger.trace(collectgarbage("count")*1024)

  if gameStatus == true then
  ADLogger.trace("Number start 2")
    gameStatus = gameplan:refresh()
    ADLogger.trace("Number start 3")
    if gameStatus == false then      
    ADLogger.trace("Number start 4")
      if gameplan:getLives() > 0 then
      ADLogger.trace("Number start 5")
        gameplan:reloadPlayerPos()
      end
    end
    ADLogger.trace("Number start 6")
    Gamehandler.checkVictory()
  elseif gameStatus == false and gameplan:getLives() < 1 then
    gameTimer:stop()
    Score.submitHighScore("Pacman")
    InGameMenu.gameOver('views/pacman/data/gameover.png', Score:getScore())
    menuView = "gameOverMenu"
    menuoption = 0
    ADLogger.trace("Number start 8")
  end
end

-- This function end game if no yelowdots remaining
-- RESET FUNCTION NEEDS TO BE ADDED
--     
function Gamehandler.checkVictory()
    if noDotsRemaining == 0 then  
      gameTimer:stop()
      Score.submitHighScore("Pacman")
      gameStatus = false
      InGameMenu.gameOver('views/pacman/data/victory.png', Score:getScore())
      menuView = "gameOverMenu"
      menuoption = 0
    end 
end

-- The onKey-function for the pacman game
function Gamehandler.pacmanOnKey(key)
  -- -----------------------------------------------------------------
  -- For testing
  if key == "exit" then
    gameStatus = false
    if gameTimer then
      gameTimer:stop()
    end
    screen:clear({r=100,g=0,b=0})
    return false
  end
  if gameStatus == true then
  
    if key == "0" then
      if gameStatus == true then
        gameplan:refresh()
      end  
    end
    if key == "down" or key == "up" or key == "left" or key == "right" then
      gameplan:setPacmanDirection(key)
    end
    if key == "ok" then
      if not gameTimer then
        gameTimer = sys.new_timer(100, "callback") -- starts a timer that calls function callback
      elseif gameStatus == true then
        gameTimer:start()
      end  
    end
    if key == "pause" then
      if gameTimer then
        gameTimer:stop()
      end
      menuView = "pauseMenu"
      gameStatus = false
      InGameMenu.loadPauseMenu()
    end
    if key == "1" then
      Gamehandler.startPacman()
    end
  end
-- -----------------------------------------------------------------
  if gameStatus == false then
  -- This is probably going to be part of the common game menu. 
    if menuView == "pauseMenu" then
      if key == "ok" then
        menuView = nil
        if menuoption == 0 then
          gameplan:reprintMap()
          gameStatus = true
          if gameTimer then
            gameTimer:start()
          end  
        elseif menuoption == 1 then
          Gamehandler.startPacman()
        elseif menuoption == 2 then
          return false
        end
      else
        InGameMenu.changePausePos(key)
      end
    elseif menuView == "gameOverMenu" then
      if key == "down" or key == "up" then
        InGameMenu.changeGameOverPos(key)
      elseif key == "ok" then
        menuView = nil
        if menuoption == 0 then
          Gamehandler.startPacman()
        elseif menuoption == 1 then
          gameStatus = false
          if gameTimer then
            gameTimer:stop()
          end
          return false
        end
      end
    end   
  end
  return true
end

callback = function(timer)
    Gamehandler.refresh()
    --ADLogger.trace(collectgarbage("count")*1024)
end
return Gamehandler
