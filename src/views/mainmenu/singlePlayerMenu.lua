local singlePlayerMenu = {
  current_screen = nil,
  current_game = 1,
  total_games = {
  "flappy-bird",   
    "pacman",
     "2048"
  }
}

function singlePlayerMenu.loadMenu(playerMenu)
  singlePlayerMenu.current_screen = playerMenu
  playerMenu:clear({r=7, g = 19, b=77, a=20}, {x =screen:get_width()/20, y = screen:get_height()/20, w= screen:get_width() *0.9, h = screen:get_height()* 0.56 })
  local color = {r=20, g=10, b=0}
  local margin = 5
  if singlePlayerMenu.current_game == 1 then 
    local bg = gfx.loadjpeg(datapath .. '/tetris.jpg')
    playerMenu:copyfrom(bg, nil, {x=750, y= 100})
    bg:destroy()
    local bg = gfx.loadjpeg(datapath .. '/pacman.jpg')
    playerMenu:copyfrom(bg, nil,{x= 500, y= 100})
    bg:destroy()
    local bg = gfx.loadjpeg(datapath .. '/flappy-bird.jpg')
    playerMenu:copyfrom(bg, nil, {x=250, y = 100})
    bg:destroy()
    singlePlayerMenu.drawBorder(playerMenu, 250, 100, 300, 168, margin, color)
    singlePlayerMenu.writeWord("GAME INFO",{r=100,g=0,b=0},40,{x=500, y= 330},playerMenu)
  elseif  singlePlayerMenu.current_game == 2 then 
    local bg = gfx.loadjpeg(datapath .. '/flappy-bird.jpg')
    playerMenu:copyfrom(bg, nil, {x=250, y = 100})
    bg:destroy()
    local bg = gfx.loadjpeg(datapath .. '/tetris.jpg')
    playerMenu:copyfrom(bg, nil, {x=750, y= 100})
    bg:destroy()
    local bg = gfx.loadjpeg(datapath .. '/pacman.jpg')
    playerMenu:copyfrom(bg, nil,{x= 500, y= 100})
    bg:destroy()
    singlePlayerMenu.drawBorder(playerMenu, 500, 100, 300, 168, margin, color)
    singlePlayerMenu.writeWord("GAME INFO",{r=100,g=0,b=0},40,{x=500, y= 330},playerMenu)
  elseif singlePlayerMenu.current_game == 3 then
    local bg = gfx.loadjpeg(datapath .. '/flappy-bird.jpg') 
    playerMenu:copyfrom(bg, nil, {x=250, y = 100})
    bg:destroy()
    local bg = gfx.loadjpeg(datapath .. '/pacman.jpg')
    playerMenu:copyfrom(bg, nil,{x= 500, y= 100})
    bg:destroy()
    local bg = gfx.loadjpeg(datapath .. '/tetris.jpg')
    playerMenu:copyfrom(bg, nil, {x=750, y= 100})
    bg:destroy()
    singlePlayerMenu.drawBorder(screen, 750, 100, 318, 168, margin, color)
    singlePlayerMenu.writeWord("GAME INFO",{r=100,g=0,b=0},40,{x=500, y= 330},playerMenu)
   end
   subMenu:printSub(playerMenu)
   gfx.update()
   collectgarbage()
end

function singlePlayerMenu.drawBorder(playerMenu, startX, startY, width, height, margin, color)
  playerMenu:clear(color, {x = startX, y = startY, w = width, h = margin})
  playerMenu:clear(color, {x = startX, y = startY, w = margin, h = height})
  playerMenu:clear(color, {x = startX, y = startY+height, w = width+margin, h = margin})
  playerMenu:clear(color, {x = startX+width, y = startY, w = margin, h = height+margin})
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
  if singlePlayerMenu.current_game == 2 then
     activeView = "pacman"
     current_menu = "none"
     gamehandler.loadPacman()
  elseif singlePlayerMenu.current_game == 3 then
    activeView = "2048"
    current_menu = "none"
    game2048.startGame()
  end
end

function singlePlayerMenu.registerKey(key, state)
  if current_menu == "singlerPlayerMenu" then
    if key == "left" then
       if singlePlayerMenu.current_game ~= 1 then
       singlePlayerMenu.current_game = singlePlayerMenu.current_game  -1 
      else 
       singlePlayerMenu.current_game = table.getn(singlePlayerMenu.total_games)
      end
      ADLogger.trace(singlePlayerMenu.current_game)
      singlePlayerMenu.loadMenu(singlePlayerMenu.current_screen)
    elseif key == "right" then
      if singlePlayerMenu.current_game ~= table.getn(singlePlayerMenu.total_games) then
         singlePlayerMenu.current_game = singlePlayerMenu.current_game +1
        else 
         singlePlayerMenu.current_game = 1
        end
      ADLogger.trace(singlePlayerMenu.current_game)
      singlePlayerMenu.loadMenu(singlePlayerMenu.current_screen)
    elseif key == "down" then
      current_menu = "mainMenu"
    elseif key == "exit" then
      current_menu = "mainMenu"
    elseif key == "ok" then
      singlePlayerMenu.loadGame()
      ADLogger.trace(singlePlayerMenu.current_game)
    elseif key == "exit" then
      --current_menu = "mainMenu"
    end
  end

end

return singlePlayerMenu
