Gamehandler = {}

Gameplan = require "model.games.pacman.gameplan"
GameplanGraphics = require("model.games.pacman.gameplangraphics")
Score = require("model.games.pacman.score")

local menuoption = 0
local menuView = "false"

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
ADLogger.trace(collectgarbage("count")*1024)
  if gameStatus == true then
    gameStatus = gameplan:refresh()
    if gameStatus == false then      
      if gameplan:getLives() > 0 then
        gameplan:reloadPlayerPos()
        gameStatus = true
      end
    end
    Gamehandler.checkVictory()
  elseif gameStatus == false and gameplan:getLives() < 1 then
    gameTimer:stop()
    GameplanGraphics.gameOver('views/pacman/data/gameover.png')
    menuView = "gameOverMenu"
    menuoption = 0
  end
end

-- This function end game if no yelowdots remaining
-- RESET FUNCTION NEEDS TO BE ADDED
--     
function Gamehandler.checkVictory()
    if noDotsRemaining == 0 then  
      gameTimer:stop()
      gameStatus = false
      GameplanGraphics.gameOver('views/pacman/data/victory.png')
      menuView = "gameOverMenu"
      menuoption = 0
    end 
end

function Gamehandler.pausemenu()
  gameStatus = false
  local pauseMenu = gfx.loadpng('views/pacman/data/pause-menu.png')
  screen:copyfrom(pauseMenu, nil,{x=450, y=250})
  local w = gfx.new_surface(20, 20)
  w:clear({r=255, g=255, b=255})
  screen:copyfrom(w,nil,{x=480, y=285})
  gfx.update()
end

function Gamehandler.changePausePos(key)
  local delta = 0
      if key == "down" then
        delta = 1
      else
        delta = -1
      end
      menuoption = math.abs((menuoption + delta) % 3)
      local w = gfx.new_surface(20, 20)
      w:clear({r=0, g=0, b=0})
      screen:copyfrom(w,nil,{x=480, y=285})
      screen:copyfrom(w,nil,{x=480, y=335})
      screen:copyfrom(w,nil,{x=480, y=385})
      w:clear({r=255, g=255, b=255})
      screen:copyfrom(w,nil,{x=480, y=(285 + menuoption*50)})
      gfx.update()
end

-- The onKey-function for the pacman game
function Gamehandler.pacmanOnKey(key)
  -- -----------------------------------------------------------------
  -- For testing
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
      Gamehandler.pausemenu()
      menuoption = 0
    end
    if key == "1" then
      Gamehandler.startPacman()
    end
    if key == "exit" then
      gameStatus = false
      if gameTimer then
        gameTimer:stop()
      end
      screen:clear({r=100,g=0,b=0})
      return false
    end
  end
-- -----------------------------------------------------------------
  if gameStatus == false then
  -- This is probably going to be part of the common game menu. 
    if menuView == "pauseMenu" then
      if key == "ok" then
        if menuoption == 0 then
          gameplan:reprintMap()
          -- Gamestatus ? 
          gameStatus = true
          gameTimer:start()
        elseif menuoption == 1 then
          Gamehandler.startPacman()
        elseif menuoption == 2 then
          return false
        end
      end
    
      if key == "down" or key == "up" then
          Gamehandler.changePausePos(key)
      end
    elseif menuView == "gameOverMenu" then
      if key == "down" or key == "up" then
        local delta = 0
        if key == "down" then
          delta = 1
        else
          delta = -1
        end
        menuoption = math.abs((menuoption + delta) % 2)
        dump(menuoption)
        local w = gfx.new_surface(20, 20)
        w:clear({r=0, g=0, b=0})
        screen:copyfrom(w,nil,{x=480, y=350})
        screen:copyfrom(w,nil,{x=480, y=390})
        w:clear({r=255, g=255, b=255})
        screen:copyfrom(w,nil,{x=480, y=(350 + menuoption*40)})
        gfx.update()
      elseif key == "ok" then
        if menuoption == 0 then
          Gamehandler.startPacman()
        elseif menuoption == 1 then
          gameStatus = false
          if gameTimer then
            gameTimer:stop()
          end
          screen:clear({r=100,g=0,b=0})
          return false
        end
      end
    end   
 --[[ 
      
      ]]--
  end
  return true
end

callback = function(timer)
    Gamehandler.refresh()
end
return Gamehandler