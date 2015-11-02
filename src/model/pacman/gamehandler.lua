
require("model.pacman.gameplan")
require("model.pacman.player")





function loadPacman()
  
  screen:destroy()
  screen = gfx.new_surface(1280, 720)
  screen:clear({r=100,g=0,b=0})
  gfx.update()
  startPacman()
  
end

-- This function checks whether pacman is able to move in the direction he's going regarding the map structure



function startPacman()
--[[
   ADLogger.trace("LOAD MAP1")    
   local file = io.open("data/pacman/map1.txt", "r");
   local arr = {}
   for line in file:lines() do
      table.insert (arr, line);
   end
--]]

    gameplan = Gameplan:new()
    gameplan:loadMap()
    gameplan:displayMap()


    
    
    --blinky.bg = gfx.new_surface(50,50)
    --blinky.bg:clear({r=0,g=255,b=51})
    
    -- Creating a new background block object. Should preferably be moved to a global variable in "Player"
    --pacman.bgblock = gfx.new_surface(50,50)
    --blinky.bgblock = gfx.new_surface(50,50)
    --pacman.bgblock:clear({r=200,b=200,g=200})
    --blinky.bgblock:clear({r=200,b=200,g=200})
    
    --screen:copyfrom(pacman.bg, nil, pacman:getPos())  -- Place pacman-image with initial position
    --screen:copyfrom(blinky.bg, nil, blinky:getPos())  -- Place pacman-image with initial position
    gfx.update()  -- Update GFX
    
    --temp = gfx.new_surface(1280, 720)   -- Temp, just a rectangle with a solid color
    --temp:clear({r=100,g=0,b=100})       
    -- Timer, updating pacmans position
    --pacman.direction = "right"
    --blinky.direction = "left"
    
    --sys.new_timer(1, "blinky:Movement")
    --sys.new_timer(1, "pacman:Movement")
  --  sys.new_timer(1000, "blinky:Randomdirection")


end


function pacmanOnKey(key, state)
  
  if state == "down" then
    if key == "down" or key == "up" or key == "left" or key == "right" then 
      gameplan:setPacmanDirection(key)
    end
    
    if key == "yellow" then
      gameplan:refresh()
    end
    
    if key == "play" then
      gameTimer = sys.new_timer(100, "gameplan:refresh")
    end    
    if key == "pause" then
      if gameTimer then
        gameTimer:stop()
      end
    end   
  end
    if key == "ok" then
      gameplan:dumpPlayerPos()
    end
    
end






