model = require "model.multiplayermenu.multiplayermenu"
multiplayermenu = {title = "Multiplayer Menu"}
local resulttable = nil
local playerMenu = nil
local activeGame = nil
local a = {}
local tempActive = 2


--loads the view for the multiplayer menu
--@param model - instantiates the model for the multiplayermenu
function multiplayermenu.loadMenu()
  model = model:new()
  --a= model:fetchPath()
  playerMenu = gfx.new_surface(screen:get_width(),screen:get_height()*2.0/3.0)
  playerMenu:clear({r=7, g = 19, b=77, a=120}, {x =screen:get_width()/20, y = screen:get_height()/20, w= screen:get_width() *0.9, h = screen:get_height()* 0.56 })
  --multiplayermenu.loadGameMenu()
  --multiplayermenu.loadRecentResults(model:fetchResults())
  --multiplayermenu.loadCurrentPlayers(0)

  screen:clear({r=7, g = 19, b=77}, {x =screen:get_width()*0.05, y = screen:get_height()*0.05, w= screen:get_width() *0.9, h = screen:get_height()* 0.55 })
  screen:copyfrom(playerMenu, nil)
  gfx.update()
end

--prints a word on a selected surface
--@param word - the word to print
--@param color - the color with which to print
--@param size - the size of the text
--@param position - the position of the text
--@param Screen - the surface on which to print the menu
function multiplayermenu.writeWord(word, color, size, position)
  ADLogger.trace(root_path)
  font_path = root_path .. datapath .. "/font/Gidole-Regular.otf"
  ADLogger.trace(font_path)
  size = size or 50
  color = color or {r = 100, g = 0, b =100}
  word = word or  "hello world" 
  ADLogger.trace(size)
  start_btn = sys.new_freetype(color, size, position,font_path)
  start_btn:draw_over_surface(playerMenu,word)
end

--loads the most recent results
--@param recentRes - array from where to read recent results
function multiplayermenu.loadRecentResults(recentRes)
  resulttable = recentRes
  local wincol = {r=0, g=155, b=0}
  local losecol = {r=155, g=0, b=0}
  local nocol = {r=160, g=160, b=160}
  --unpack the array
  local score1 = resulttable[activeGame]["score1"]
  local score2 = resulttable[activeGame]["score2"]
  local score3 = resulttable[activeGame]["score3"]
  local indicator1 = resulttable[activeGame]["indicator1"]
  local indicator2 = resulttable[activeGame]["indicator2"]
  local indicator3 = resulttable[activeGame]["indicator3"]
  if (indicator1 == "w") then
    screen:clear(wincol, {x = ((playerMenu:get_width()/2)-(playerMenu:get_width()/10*3)/2)-playerMenu:get_width()/5, y = (playerMenu:get_height())/2, w = ((playerMenu:get_width())/10)*3, h = 50})
  elseif (indicator1 == "n") then
    screen:clear(nocol, {x = ((playerMenu:get_width()/2)-(playerMenu:get_width()/10*3)/2)-playerMenu:get_width()/5, y = (playerMenu:get_height())/2, w = ((playerMenu:get_width())/10)*3, h = 50})
  else
    screen:clear(losecol, {x = ((playerMenu:get_width()/2)-(playerMenu:get_width()/10*3)/2)-playerMenu:get_width()/5, y = (playerMenu:get_height())/2, w = ((playerMenu:get_width())/10)*3, h = 50})
  end
  if (indicator2 == "w") then
    screen:clear(wincol, {x = ((playerMenu:get_width()/2)-(playerMenu:get_width()/10*3)/2)-playerMenu:get_width()/5, y = ((playerMenu:get_height())/2)*1.3, w = ((playerMenu:get_width())/10)*3, h = 50})
  elseif (indicator2 == "n") then
    screen:clear(nocol, {x = ((playerMenu:get_width()/2)-(playerMenu:get_width()/10*3)/2)-playerMenu:get_width()/5, y = ((playerMenu:get_height())/2)*1.3, w = ((playerMenu:get_width())/10)*3, h = 50})
  else
    screen:clear(losecol, {x = ((playerMenu:get_width()/2)-(playerMenu:get_width()/10*3)/2)-playerMenu:get_width()/5, y = ((playerMenu:get_height())/2)*1.3, w = ((playerMenu:get_width())/10)*3, h = 50})
  end
  if (indicator3 == "w") then
    screen:clear(wincol, {x = ((playerMenu:get_width()/2)-(playerMenu:get_width()/10*3)/2)-playerMenu:get_width()/5, y = ((playerMenu:get_height())/2)*1.6, w = ((playerMenu:get_width())/10)*3, h = 50})
  elseif (indicator3 == "n") then
    screen:clear(nocol, {x = ((playerMenu:get_width()/2)-(playerMenu:get_width()/10*3)/2)-playerMenu:get_width()/5, y = ((playerMenu:get_height())/2)*1.6, w = ((playerMenu:get_width())/10)*3, h = 50})
  else
    screen:clear(losecol, {x = ((playerMenu:get_width()/2)-(playerMenu:get_width()/10*3)/2)-playerMenu:get_width()/5, y = ((playerMenu:get_height())/2)*1.6, w = ((playerMenu:get_width())/10)*3, h = 50})
  end
  
  --multiplayermenu.writeWord(score1,{r = 255, g = 255, b =255},35,{x=((playerMenu:get_width()/2)-(playerMenu:get_width()/10*3)/2)-playerMenu:get_width()/5+50, y= (playerMenu:get_height())/2+8},screen)
  --multiplayermenu.writeWord(score2,{r = 255, g = 255, b =255},35,{x=((playerMenu:get_width()/2)-(playerMenu:get_width()/10*3)/2)-playerMenu:get_width()/5+50, y= ((playerMenu:get_height())/2)*1.3+8},screen)
  --multiplayermenu.writeWord(score3,{r = 255, g = 255, b =255},35,{x=((playerMenu:get_width()/2)-(playerMenu:get_width()/10*3)/2)-playerMenu:get_width()/5+50, y= ((playerMenu:get_height())/2)*1.6+8},screen)
end

--reloads the most recent results
function multiplayermenu.reloadRecent()
  local wincol = {r=0, g=155, b=0}
  local losecol = {r=155, g=0, b=0}
  local nocol = {r=160, g=160, b=160}
  --unpacks the saved array
  local score1 = resulttable[activeGame]["score1"]
  local score2 = resulttable[activeGame]["score2"]
  local score3 = resulttable[activeGame]["score3"]
  local indicator1 = resulttable[activeGame]["indicator1"]
  local indicator2 = resulttable[activeGame]["indicator2"]
  local indicator3 = resulttable[activeGame]["indicator3"]
  if (indicator1 == "w") then
    screen:clear(wincol, {x = ((playerMenu:get_width()/2)-(playerMenu:get_width()/10*3)/2)-playerMenu:get_width()/5, y = (playerMenu:get_height())/2, w = ((playerMenu:get_width())/10)*3, h = 50})
  elseif (indicator1 == "n") then
    screen:clear(nocol, {x = ((playerMenu:get_width()/2)-(playerMenu:get_width()/10*3)/2)-playerMenu:get_width()/5, y = (playerMenu:get_height())/2, w = ((playerMenu:get_width())/10)*3, h = 50})
  else
    screen:clear(losecol, {x = ((playerMenu:get_width()/2)-(playerMenu:get_width()/10*3)/2)-playerMenu:get_width()/5, y = (playerMenu:get_height())/2, w = ((playerMenu:get_width())/10)*3, h = 50})
  end
  if (indicator2 == "w") then
    screen:clear(wincol, {x = ((playerMenu:get_width()/2)-(playerMenu:get_width()/10*3)/2)-playerMenu:get_width()/5, y = ((playerMenu:get_height())/2)*1.3, w = ((playerMenu:get_width())/10)*3, h = 50})
  elseif (indicator2 == "n") then
    screen:clear(nocol, {x = ((playerMenu:get_width()/2)-(playerMenu:get_width()/10*3)/2)-playerMenu:get_width()/5, y = ((playerMenu:get_height())/2)*1.3, w = ((playerMenu:get_width())/10)*3, h = 50})
  else
    screen:clear(losecol, {x = ((playerMenu:get_width()/2)-(playerMenu:get_width()/10*3)/2)-playerMenu:get_width()/5, y = ((playerMenu:get_height())/2)*1.3, w = ((playerMenu:get_width())/10)*3, h = 50})
  end
  if (indicator3 == "w") then
    screen:clear(wincol, {x = ((playerMenu:get_width()/2)-(playerMenu:get_width()/10*3)/2)-playerMenu:get_width()/5, y = ((playerMenu:get_height())/2)*1.6, w = ((playerMenu:get_width())/10)*3, h = 50})
  elseif (indicator3 == "n") then
    screen:clear(nocol, {x = ((playerMenu:get_width()/2)-(playerMenu:get_width()/10*3)/2)-playerMenu:get_width()/5, y = ((playerMenu:get_height())/2)*1.6, w = ((playerMenu:get_width())/10)*3, h = 50})
  else
    screen:clear(losecol, {x = ((playerMenu:get_width()/2)-(playerMenu:get_width()/10*3)/2)-playerMenu:get_width()/5, y = ((playerMenu:get_height())/2)*1.6, w = ((playerMenu:get_width())/10)*3, h = 50})
  end
  
 -- multiplayermenu.writeWord(score1,{r = 255, g = 255, b =255},35,{x=((playerMenu:get_width()/2)-(playerMenu:get_width()/10*3)/2)-playerMenu:get_width()/5+50, y= (playerMenu:get_height())/2+8},screen)
  --multiplayermenu.writeWord(score2,{r = 255, g = 255, b =255},35,{x=((playerMenu:get_width()/2)-(playerMenu:get_width()/10*3)/2)-playerMenu:get_width()/5+50, y= ((playerMenu:get_height())/2)*1.3+8},screen)
  --multiplayermenu.writeWord(score3,{r = 255, g = 255, b =255},35,{x=((playerMenu:get_width()/2)-(playerMenu:get_width()/10*3)/2)-playerMenu:get_width()/5+50, y= ((playerMenu:get_height())/2)*1.6+8},screen)
  gfx:update()
end

--prints a border with selected parameters
--@param Screen - the surface on which to print the menu
--@param startX - top line (pixels)
--@param startY - leftmost line (pixels)
--@param width - the width of the border (box)
--@param height - the height of the border (box)
--@param margin - the margin (thickness) of the line
--@param color - the color of the line
function multiplayermenu.drawBorder(startX, startY, width, height, margin, color)
  playerMenu:clear(color, {x = startX, y = startY, w = width, h = margin})
  playerMenu:clear(color, {x = startX, y = startY, w = margin, h = height})
  playerMenu:clear(color, {x = startX, y = startY+height, w = width+margin, h = margin})
  playerMenu:clear(color, {x = startX+width, y = startY, w = margin, h = height+margin})
end

--loads the current players
--@param players - the number of players online
function multiplayermenu.loadCurrentPlayers(players)
  color = {r=20, g=10, b=0}
  margin = 5
  currentplayers = players or 0
  multiplayermenu.drawBorder(playerMenu, ((playerMenu:get_width()/2)-(playerMenu:get_width()/10*3)/2)+playerMenu:get_width()/5, (playerMenu:get_height())/2, playerMenu:get_width()/10*3, 50, margin, color)
  multiplayermenu.writeWord(currentplayers,{r = 100, g = 0, b =100},35,{x=(((playerMenu:get_width()/2)-(playerMenu:get_width()/10*3)/2)+playerMenu:get_width()/5)+25, y= ((playerMenu:get_height())/2)*1.02},playerMenu)
end

--starts the selected game
function multiplayermenu.start()
    activeView = a[tempActive]["name"]
    ADLogger.trace(tempActive)
    dofile(a[tempActive]["start"])
end

--loads the game menu and carousel
function multiplayermenu.loadGameMenu()
  activeGame = 2
  color = {r=20, g=10, b=0}
  margin = 5
  local bg = gfx.loadjpeg(a[activeGame-1]["path"] .. 'background-small.jpg')
  screen:copyfrom(bg, nil, {x=((playerMenu:get_width())/2)-350, y= playerMenu:get_height()/20+37})
  bg:destroy()
  local bg = gfx.loadjpeg(a[activeGame+1]["path"] .. 'background-small.jpg')
  screen:copyfrom(bg, nil, {x=((playerMenu:get_width())/2)+100, y= playerMenu:get_height()/20+37})
  bg:destroy()
  local bg = gfx.loadjpeg(a[activeGame]["path"] .. 'background.jpg')
  screen:copyfrom(bg, nil, {x=((playerMenu:get_width())/2)-150, y= playerMenu:get_height()/20+20})
  bg:destroy()
end

--Called upon hitting the "right"-key/button.
--treverses the carousel
function multiplayermenu:next()
    local next = activeGame + 1
    local prev = activeGame - 1
    
    if (next>model:getSize()) then
      next = 1
    end
    if activeGame==1 then
      prev = model:getSize()
    end
    tempActive = activeGame
    --reloads the images with the new paths
    local bg = gfx.loadjpeg(a[prev]["path"] .. 'background-small.jpg')
    screen:copyfrom(bg, nil, {x=((playerMenu:get_width())/2)-350, y= playerMenu:get_height()/20+37})
    bg:destroy()
    local bg = gfx.loadjpeg(a[next]["path"] .. 'background-small.jpg')
    screen:copyfrom(bg, nil, {x=((playerMenu:get_width())/2)+100, y= playerMenu:get_height()/20+37})
    bg:destroy()
    local bg = gfx.loadjpeg(a[activeGame]["path"] .. 'background.jpg')
    screen:copyfrom(bg, nil, {x=((playerMenu:get_width())/2)-150, y= playerMenu:get_height()/20+20})
    bg:destroy()
    collectgarbage()
    multiplayermenu.reloadRecent()
    activeGame=next
end

--Called upon hitting the "left"-key/button.
--treverses the carousel
function multiplayermenu:prev()
    local next = activeGame + 1
    local prev = activeGame - 1
    if (prev<1) then
      prev = model:getSize()
    end
    if (next>model:getSize()) then
      next = 1
    end
    tempActive = activeGame
    
    --reloads the images with the new paths
    local bg = gfx.loadjpeg(a[prev]["path"] .. 'background-small.jpg')
    screen:copyfrom(bg, nil, {x=((playerMenu:get_width())/2)-350, y= playerMenu:get_height()/20+37})
    bg:destroy()
    local bg = gfx.loadjpeg(a[next]["path"] .. 'background-small.jpg')
    screen:copyfrom(bg, nil, {x=((playerMenu:get_width())/2)+100, y= playerMenu:get_height()/20+37})
    bg:destroy()
    local bg = gfx.loadjpeg(a[activeGame]["path"] .. 'background.jpg')
    screen:copyfrom(bg, nil, {x=((playerMenu:get_width())/2)-150, y= playerMenu:get_height()/20+20})
    bg:destroy()
    collectgarbage()
    multiplayermenu.reloadRecent()
    activeGame=prev
end

function multiplayermenu.setTextParameters()
end

--Listener for keycommands, repeated in every menu-class.
--@param key - key that is pressed
--@param state - state of the pressed key
function multiplayermenu.registerKey(key,state)
  if current_menu == "multiPlayerMenu" then
    if key == "left" then
        multiplayermenu:prev()
    elseif key == "right" then
        multiplayermenu:next()
    elseif key == "ok" then
        multiplayermenu:start()
    elseif key == "down" then
        current_menu = "mainMenu"
    end
  end
end

return multiplayermenu