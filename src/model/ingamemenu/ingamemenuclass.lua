-- The In Game Menu class
InGameMenu = {}

function InGameMenu.loadPauseMenu()
  pauseMenuContainer = gfx.new_surface(250, 200)
  local pauseMenu = gfx.loadpng('views/pacman/data/pause-menu.png')
  menuoption = 0
  pauseMenuContainer:copyfrom(pauseMenu, nil,{x=1, y=1})
  local w = gfx.new_surface(20, 20)
  w:clear({r=255, g=255, b=255})
  pauseMenuContainer:copyfrom(w,nil,{x=35, y=40})
  screen:copyfrom(pauseMenuContainer, nil, {x=450,y=250})
  gfx.update()
end

function InGameMenu.changePausePos(key)
  local delta = 0
      if key == "down" then
        delta = 1
      elseif key == "up" then
        delta = -1
      else  
        return
      end
      menuoption = math.abs((menuoption + delta) % 3)
      local w = gfx.new_surface(20, 20)
      w:clear({r=0, g=0, b=0})
      pauseMenuContainer:copyfrom(w,nil,{x=35, y=40})
      pauseMenuContainer:copyfrom(w,nil,{x=35, y=90})
      pauseMenuContainer:copyfrom(w,nil,{x=35, y=140})
      w:clear({r=255, g=255, b=255})
      pauseMenuContainer:copyfrom(w,nil,{x=35, y=(40 + menuoption*50)})
      screen:copyfrom(pauseMenuContainer,nil,{x=450,y=250})
      gfx.update()
end

function InGameMenu.gameOver(picpath, score)
    gameOverContainer = gfx.new_surface(320, 180) 
    local gameOver = gfx.loadpng(picpath)
    menuoption = 0
    gameOverContainer:copyfrom(gameOver, nil,{x=1, y=1})
    local score_text = sys.new_freetype({r=255,g=255,b=255}, 20, {x=125,y=70}, font_path)
    local word = "Score: " .. score
    score_text:draw_over_surface(gameOverContainer,word)
    local w = gfx.new_surface(20, 20)
    w:clear({r=255, g=255, b=255})
    gameOverContainer:copyfrom(w,nil,{x=30, y=100})
    screen:copyfrom(gameOverContainer,nil,{x=450,y=250})
    gfx.update()
end

function InGameMenu.changeGameOverPos(key)
        local delta = 0
        if key == "down" then
          delta = 1
        elseif key == "up" then
          delta = -1
        end
        menuoption = math.abs((menuoption + delta) % 2)
        local w = gfx.new_surface(20, 20)
        w:clear({r=0, g=0, b=0})
        gameOverContainer:copyfrom(w,nil,{x=30, y=100})
        gameOverContainer:copyfrom(w,nil,{x=30, y=140})
        w:clear({r=255, g=255, b=255})
        gameOverContainer:copyfrom(w,nil,{x=30, y=(100 + menuoption*40)})
        screen:copyfrom(gameOverContainer,nil,{x=450,y=250})
        gfx.update()
end

return InGameMenu