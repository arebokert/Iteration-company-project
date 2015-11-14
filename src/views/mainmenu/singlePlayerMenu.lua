local singlePlayerMenu = {
  current_game = 1,
  total_games = {
    "pacman",
    "2048"
  }
}

function singlePlayerMenu.loadMenu(screen)
  local bg = gfx.loadjpeg(datapath .. '/tetris.jpg')
  screen:copyfrom(bg, nil, {x=250, y = 100})
  bg:destroy()
  local bg = gfx.loadjpeg(datapath .. '/flappy-bird.jpg')
  screen:copyfrom(bg, nil, {x=750, y= 100})
  bg:destroy()
  local bg = gfx.loadjpeg(datapath .. '/pacman.jpg')
  screen:copyfrom(bg, nil,{x= 500, y= 100})
  bg:destroy()
  singlePlayerMenu.writeWord("GAME INFO",{r=100,g=0,b=0},40,{x=500, y= 330},screen)
end

function singlePlayerMenu.writeWord(word, color, size, position, screen)
  ADLogger.trace(root_path)
  font_path = "views/mainmenu/data/font/Gidole-Regular.otf"
  ADLogger.trace(font_path)
  size = size or 50
  color = color or {r = 100, g = 0, b =100}
  word = word or  "hello world" 
  ADLogger.trace(size)
  start_btn = sys.new_freetype(color, size, position,font_path)
  start_btn:draw_over_surface(screen,word)
end

--controller:loadGame()
function singlePlayerMenu.loadGame()
  if singlePlayerMenu.current_game == 1 then
     activeView = "pacman"
     gamehandler.loadPacman()
  elseif singlePlayerMenu.curren_game == 2 then
    --activeView = "2048"
    -- gamehandler.load2048()
  end
end

function singlePlayerMenu.registerKey(key, state)
  if current_menu == "singlerPlayerMenu" then
    if key == "left" then
      ADLogger.trace(singlePlayerMenu.current_game)
    elseif key == "right" then
      ADLogger.trace(singlePlayerMenu.current_game)
    elseif key == "down" then
      --current_menu = "mainMenu"
    elseif key == "ok" then
      singlePlayerMenu.loadGame()
    elseif key == "exit" then
      --current_menu = "mainMenu"
    end
  end

end

return singlePlayerMenu