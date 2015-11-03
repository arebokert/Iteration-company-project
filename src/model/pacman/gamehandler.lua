
require("model.pacman.gameplan")
require("model.pacman.player")


function loadPacman()
  
  screen:destroy()
  screen = gfx.new_surface(1280, 720)
  screen:clear({r=100,g=0,b=0})
  gfx.update()
  startPacman()
end


function startPacman()

    gameplan = Gameplan:new()
    gameplan:loadMap()
    gameplan:displayMap()

    gameStatus = true
   
    gfx.update()  -- Update GFX
end


function refresh()
  if gameStatus == true then 
    gameStatus = gameplan:refresh()
  elseif gameStatus == false then 
    gameTimer:stop()
  end
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
      gameTimer = sys.new_timer(100, "refresh")
    end    
    if key == "pause" then
      if gameTimer then
        gameTimer:stop()
      end
    end   
    if key == "backspace" then
      loadPacman()
    end   
    if key == "exit" then 
      screen:destroy()
      screen = gfx.new_surface(1280, 720)
      screen:clear({r=100,g=0,b=0})          
      return false
    end      
  end
  
    if key == "ok" then
      gameplan:dumpPlayerPos()
    end
    
    return true
end






