local singlePlayerMenu = {
  current_game = 1,
  total_games = {
  "flappy-bird",   
    "pacman",
     "2048"
  }
}

function singlePlayerMenu.loadMenu()
  local playerMenu = gfx.new_surface(screen:get_width(),screen:get_height()*2.0/3.0)
  playerMenu:clear({r=7, g = 19, b=77, a=20}, {x =screen:get_width()*0.05, y = screen:get_height()*0.05, w= screen:get_width() *0.9, h = screen:get_height()* 0.55 })
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
    --singlePlayerMenu.writeWord("GAME INFO",{r=100,g=0,b=0},40,{x=500, y= 330})
  elseif  singlePlayerMenu.current_game == 2 then 
    local bg = gfx.loadjpeg(datapath .. '/flappy-bird.jpg')
    playerMenu:copyfrom(bg, nil, {x=250, y = 100})
    bg:destroy()
    local bg = gfx.loadjpeg(datapath .. '/tetris.jpg')
    playerMenu:copyfrom(bg, nil, {x=750, y= 100,w =300, h = 160})
    bg:destroy()
    local bg = gfx.loadjpeg(datapath .. '/pacman.jpg')
    playerMenu:copyfrom(bg, nil,{x= 500, y= 100})
    bg:destroy()
    singlePlayerMenu.drawBorder(playerMenu, 500, 100, 300, 168, margin, color)
    --singlePlayerMenu.writeWord("GAME INFO",{r=100,g=0,b=0},40,{x=500, y= 330},playerMenu)
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
    singlePlayerMenu.drawBorder(playerMenu, 750, 100, 318, 168, margin, color)
    --singlePlayerMenu.writeWord("GAME INFO",{r=100,g=0,b=0},40,{x=500, y= 330},playerMenu)
   end
   screen:copyfrom(playerMenu, nil)
   gfx.update()
   collectgarbage()
end

function singlePlayerMenu.drawBorder(playerMenu, startX, startY, width, height, margin, color)
  playerMenu:clear(color, {x = startX, y = startY, w = width, h = margin})
  playerMenu:clear(color, {x = startX, y = startY, w = margin, h = height})
  playerMenu:clear(color, {x = startX, y = startY+height, w = width+margin, h = margin})
  playerMenu:clear(color, {x = startX+width, y = startY, w = margin, h = height+margin})
end


function singlePlayerMenu.writeWord(word, color, size, position)
 -- local font_path = root_path.."views/mainmenu/data/font/Gidole-Regular.otf"
  --local word_freetype = sys.new_freetype(color, size, position,font_path)
  local word_freetype = sys.new_freetype({g=100,r=100,b=100}, 60, {x=900,y=50},root_path .."views/mainmenu/data/font/Gidole-Regular.otf")
  word_freetype:draw_over_surface(screen,word)
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
       singlePlayerMenu.current_game = 3
      end
      singlePlayerMenu.loadMenu()
    elseif key == "right" then
      if singlePlayerMenu.current_game ~= 3 then
         singlePlayerMenu.current_game = singlePlayerMenu.current_game +1
        else 
         singlePlayerMenu.current_game = 1
        end
      singlePlayerMenu.loadMenu()
    elseif key == "down" then
      current_menu = "mainMenu"
    elseif key == "exit" then
      current_menu = "mainMenu"
    elseif key == "ok" then
      singlePlayerMenu.loadGame()
    elseif key == "exit" then
      current_menu = "mainMenu"
    end
  end

end

return singlePlayerMenu
