Gamehandler = {}

Gameplan = require "model.games.pacman.gameplan"
GameplanGraphics = require("model.games.pacman.gameplangraphics")
Score = require("model.commongame.scorehandler")
InGameMenu = require("model.commongame.ingamemenuclass")

menuView = nil

--
-- Load a game of pacman 
-- @width: The desired width of the gameplan  
-- @height The desired height of the gameplan
-- @position: The desired position of the gameplan given in x and y coordinates. 
function Gamehandler.loadPacman(width, height, position)
  -- Set the background for the view. 
  local pacmanbg = gfx.loadjpeg('views/pacman/data/pacmanbg.jpg')
  screen:copyfrom(pacmanbg, nil)
  pacmanbg:destroy()
  

    
  -- Initiate pacman 
  Gamehandler.startPacman(width, height, position)
  --ADLogger.trace(collectgarbage("count")*1024)
end


--
-- A function to calculate size of a container that is divisible with respect to gameplan-map. 
-- @width: Desired width
-- @height: Desired height
-- @xcells: Number of cells in x-direction
-- @ycells: Number of cels in y-direction 
-- Return: Object with x (width) and y (height). 
function Gamehandler.calculateContainerSize( xcells, ycells )
  local width = Gamehandler.containerWidth
  local height = Gamehandler.containerHeight
  
  local multiplier = 10
  if width/xcells < height/ycells then
    -- The width is the limit
    multiplier = math.floor(width/xcells)
  elseif width/xcells > height/ycells then
     -- The height is the limit
     multiplier = math.floor(height/ycells)
  else
    -- The fractions is equal
    multiplier = math.floor(width/xcells)
  end
  
  -- Minimum size of gameplan.. 
  if multiplier < 10 then
    multiplier = 10
  end
  
  -- The multiplier must be divisble by 4 (because of pacman step-length) 
  while multiplier % 4 ~= 0 do
    multiplier = multiplier - 1
  end
    
  
  -- Calculate return values 
  local x = xcells*multiplier
  local y = ycells*multiplier
  local offsetX = (width - x) / 2
  local offsetY = (height - y) / 2
  
  -- Save to return object 
  size = {width = x, height = y, offsetWidth = offsetX, offsetHeight = offsetY}
  
  -- Return 
  return size
end


--
-- This function is a help function for the loadPacman
-- Generates all needed objects, and calls the needed functions fto be able to play the game
--
function Gamehandler.startPacman(width, height, position)
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
    
  -- Default values for width, height and position! 
  if width == nil then 
    if Gamehandler.containerWidth == nil then 
      Gamehandler.containerWidth = 600
    end
  else 
    Gamehandler.containerWidth = width
  end
  
  if height == nil then
    if Gamehandler.containerHeight == nil then
      Gamehandler.containerHeight = 400
    end
  else 
    Gamehandler.containerHeight = height
  end
  
  if position == nil then
    if Gamehandler.containerPos == nil then
      Gamehandler.containerPos = {x = 300, y = 150}
    end
  else
    Gamehandler.containerPos = position
  end
  


  -- Get the size of the gameplan 
  local gameplanSize = gameplan:getCellSize()
  -- Calculate a container size where to map will fit. 
  local size = Gamehandler.calculateContainerSize( gameplanSize.x, gameplanSize.y )
  local position = {x = Gamehandler.containerPos.x + size.offsetWidth, y = Gamehandler.containerPos.y + size.offsetHeight}
  
  -- Display the map on a container
  Gamehandler.container = gfx.new_surface(size.width, size.height)
  
  gameplan:displayMap(Gamehandler.container, position)
  
  -- Set speed level: An integer from 1 to 3! 
  gameplan:setSpeed(2)  
  
  -- Gamestatus ? 
  gameStatus = true
end

-- This function refreshes the game by one "frame"
--
-- This function refreshes the game by one "frame"
-- Gets a boolean from thhe gameplan-refresh 
-- True: No collision
-- False: Collision - deduct one life and check if game over
--
function Gamehandler.refresh()
ADLogger.trace(collectgarbage("count")*1024)
  if gameStatus == true then
    gameStatus = gameplan:refresh()
    if gameStatus == false then      
      if gameplan:getLives() > 0 then
        gameplan:reloadPlayerPos()
      end
    end
    Gamehandler.checkVictory()
  elseif gameStatus == false and gameplan:getLives() < 1 then
    -- Game over
    gameTimer:stop()
    Score.submitHighScore("Pacman")
    InGameMenu.gameOver('views/pacman/data/gameover.png', Score:getScore())
    menuView = "gameOverMenu"
    menuoption = 0
  end
end

--
-- This function ends the game if all yellowdots have been eaten by pacman
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
          Gamehandler.loadPacman()
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