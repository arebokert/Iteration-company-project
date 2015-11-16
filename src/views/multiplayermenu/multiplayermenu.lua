model = require "model.multiplayermenu.multiplayermenu"
multiplayermenu = {title = "Multiplayer Menu"}
local playerMenu = nil
local activeGame = nil
local a = {}

function multiplayermenu.loadMenu(Screen)
  model = model:new()
  a= model:fetchPath()
  playerMenu = Screen
  playerMenu:clear({r=7, g = 19, b=77, a=20}, {x =screen:get_width()/20, y = screen:get_height()/20, w= screen:get_width() *0.9, h = screen:get_height()* 0.56 })
  multiplayermenu.loadRecentResults()
  multiplayermenu.loadCurrentPlayers(0)
  multiplayermenu.loadGameMenu()
  return Screen
end

function multiplayermenu.writeWord(word, color, size, position, Screen)
  ADLogger.trace(root_path)
  font_path = datapath .. "/font/Gidole-Regular.otf"
  ADLogger.trace(font_path)
  size = size or 50
  color = color or {r = 100, g = 0, b =100}
  word = word or  "hello world" 
  ADLogger.trace(size)
  start_btn = sys.new_freetype(color, size, position,font_path)
  start_btn:draw_over_surface(Screen,word)
end

function multiplayermenu.loadRecentResults()
  color = {r=20, g=10, b=0}
  margin = 5
  multiplayermenu.drawBorder(playerMenu, ((playerMenu:get_width()/2)-(playerMenu:get_width()/10*3)/2)-playerMenu:get_width()/5, (playerMenu:get_height())/2, ((playerMenu:get_width())/10)*3, 50, margin, color)
  multiplayermenu.drawBorder(playerMenu, ((playerMenu:get_width()/2)-(playerMenu:get_width()/10*3)/2)-playerMenu:get_width()/5, ((playerMenu:get_height())/2)*1.3, ((playerMenu:get_width())/10)*3, 50, margin, color)
  multiplayermenu.drawBorder(playerMenu, ((playerMenu:get_width()/2)-(playerMenu:get_width()/10*3)/2)-playerMenu:get_width()/5, ((playerMenu:get_height())/2)*1.6, ((playerMenu:get_width())/10)*3, 50, margin, color)
end

function multiplayermenu.drawBorder(Screen, startX, startY, width, height, margin, color)
  Screen:clear(color, {x = startX, y = startY, w = width, h = margin})
  Screen:clear(color, {x = startX, y = startY, w = margin, h = height})
  Screen:clear(color, {x = startX, y = startY+height, w = width+margin, h = margin})
  Screen:clear(color, {x = startX+width, y = startY, w = margin, h = height+margin})
end

function multiplayermenu.loadCurrentPlayers(players)
  color = {r=20, g=10, b=0}
  margin = 5
  currentplayers = players or 0
  multiplayermenu.drawBorder(playerMenu, ((playerMenu:get_width()/2)-(playerMenu:get_width()/10*3)/2)+playerMenu:get_width()/5, (playerMenu:get_height())/2, playerMenu:get_width()/10*3, 50, margin, color)
  multiplayermenu.writeWord(currentplayers,{r = 100, g = 0, b =100},35,{x=(((playerMenu:get_width()/2)-(playerMenu:get_width()/10*3)/2)+playerMenu:get_width()/5)+25, y= ((playerMenu:get_height())/2)*1.02},playerMenu)
end

function multiplayermenu.loadGameMenu()
  activeGame = 1
  color = {r=20, g=10, b=0}
  margin = 5
  local bg = gfx.loadjpeg(a[activeGame+1]["path"] .. 'background-small.jpg')
  playerMenu:copyfrom(bg, nil, {x=((playerMenu:get_width())/2)+100, y= playerMenu:get_height()/20+37})
  bg:destroy()
  local bg = gfx.loadjpeg(a[activeGame]["path"] .. 'background.jpg')
  playerMenu:copyfrom(bg, nil, {x=((playerMenu:get_width())/2)-150, y= playerMenu:get_height()/20+20})
  bg:destroy()
end

--Called upon hitting the "right"-key/button.
--Sets a new 
function multiplayermenu:next()
    local next = activeGame + 1
    
    playerMenu:clear()

    if (next>model:getSize()) then
      next = 1
      local bg = gfx.loadjpeg(a[next+1]["path"] .. 'background-small.jpg')
      playerMenu:copyfrom(bg, nil, {x=((playerMenu:get_width())/2)+100, y= playerMenu:get_height()/20+37})
      bg:destroy()
      local bg = gfx.loadjpeg(a[next]["path"] .. 'background.jpg')
      playerMenu:copyfrom(bg, nil, {x=((playerMenu:get_width())/2)-150, y= playerMenu:get_height()/20+20})
      bg:destroy()
    elseif (next+1<model:getSize()) then
      local bg = gfx.loadjpeg(a[next+1]["path"] .. 'background-small.jpg')
      playerMenu:copyfrom(bg, nil, {x=((playerMenu:get_width())/2)+100, y= playerMenu:get_height()/20+37})
      bg:destroy()
      local bg = gfx.loadjpeg(a[next-1]["path"] .. 'background-small.jpg')
      playerMenu:copyfrom(bg, nil, {x=((playerMenu:get_width())/2)-200, y= playerMenu:get_height()/20+37})
      bg:destroy()
      local bg = gfx.loadjpeg(a[next]["path"] .. 'background.jpg')
      playerMenu:copyfrom(bg, nil, {x=((playerMenu:get_width())/2)-150, y= playerMenu:get_height()/20+20})
      bg:destroy()
    else
      local bg = gfx.loadjpeg(a[next-1]["path"] .. 'background-small.jpg')
      playerMenu:copyfrom(bg, nil, {x=((playerMenu:get_width())/2)-250, y= playerMenu:get_height()/20+37})
      bg:destroy()
      local bg = gfx.loadjpeg(a[next]["path"] .. 'background.jpg')
      playerMenu:copyfrom(bg, nil, {x=((playerMenu:get_width())/2)-150, y= playerMenu:get_height()/20+20})
      bg:destroy()
    end
    activeGame = next
    screen:copyfrom(playerMenu)
    collectgarbage()
    gfx:update()
end

--Called upon by hitting the "left"-key/button.
--@param prev - called with a "left"-keystroke.
function multiplayermenu:prev()
  local prev = self.active - 1

    if self.active - 1 < 1 then
        prev = self.size
    end
    
end
--Listener for keycommands, repeated in every menu-class.
--@param current_menu - this menu won't react unless it's set as 'active'
function multiplayermenu.registerKey(key,state)
  if current_menu == "multiPlayerMenu" then
    if key == "left" then
        multiplayermenu:prev()
    elseif key == "right" then
        multiplayermenu:next()
    elseif key == "ok" then
        multiplayermenu:action()
    elseif key == "down" then
        current_menu = "mainMenu"
    end
  end
end


return multiplayermenu