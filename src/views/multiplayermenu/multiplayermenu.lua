model = require "model.multiplayermenu.multiplayermenu"

multiplayermenu = {}

local resulttable = nil
local activeGame = nil
local a = {}
local tempActive = 2
multiMenu = nil
local font_path = root_path.."views/mainmenu/data/font/Gidole-Regular.otf"

--loads the view for the multiplayer menu
--@param model - instantiates the model for the multiplayermenu
function multiplayermenu.loadMenu()
  ADLogger.trace("Booting")
  collectgarbage("stop")
  model = model:new()
  a = model:fetchPath()
  multiMenu = gfx.new_surface(screen:get_width(),screen:get_height()*2.0/3.0)
  multiMenu:clear({r=7, g = 19, b=77, a = 25}, {x =screen:get_width()/20, y = screen:get_height()/20, w= screen:get_width() *0.9, h = screen:get_height()* 0.56 })
  multiplayermenu.loadGameMenu()
  multiplayermenu.loadRecentResults(model:fetchResults())
  multiplayermenu.loadCurrentPlayers(0)
  
  --gfx.update()

  screen:copyfrom(multiMenu, nil)
  gfx.update()
  
  --collectgarbage("stop")
  --collectgarbage()
  --collectgarbage("stop")
end

--prints a word on a selected surface
--@param word - the word to print
--@param color - the color with which to print
--@param size - the size of the text
--@param position - the position of the text
--@param Screen - the surface on which to print the menu
--function multiplayermenu.writeWord(word, color, size, position)
function multiplayermenu.writeWord(word, btn)
  ADLogger.trace(root_path)
  --font_path = root_path .. datapath .. "/font/Gidole-Regular.otf"
  ADLogger.trace(font_path)
  word = word or  "hello world" 
  --ADLogger.trace(size)
  --start_btn = sys.new_freetype(color, size, position,font_path)
  --btn:draw_over_surface(multiMenu,word)
end

--loads the most recent results
--@param recentRes - array from where to read recent results
function multiplayermenu.loadRecentResults(recentRes)
  
  resulttable = recentRes
  local wincol = {r=0, g=155, b=0}
  local losecol = {r=155, g=0, b=0}
  local nocol = {r=160, g=160, b=160}
  
  local btnfirst = sys.new_freetype({r = 255, g = 255, b =255},35,{x=((multiMenu:get_width()/2)-(multiMenu:get_width()/10*3)/2)-multiMenu:get_width()/5+50, y= (multiMenu:get_height())/2+8}, font_path)
  local btnsec = sys.new_freetype({r = 255, g = 255, b =255},35,{x=((multiMenu:get_width()/2)-(multiMenu:get_width()/10*3)/2)-multiMenu:get_width()/5+50, y= ((multiMenu:get_height())/2)*1.3+8}, font_path)
  local btnthird = sys.new_freetype({r = 255, g = 255, b =255},35,{x=((multiMenu:get_width()/2)-(multiMenu:get_width()/10*3)/2)-multiMenu:get_width()/5+50, y= ((multiMenu:get_height())/2)*1.6+8}, font_path)
  
  --unpack the array
  local score1 = resulttable[activeGame]["score1"]
  local score2 = resulttable[activeGame]["score2"]
  local score3 = resulttable[activeGame]["score3"]
  local indicator1 = resulttable[activeGame]["indicator1"]
  local indicator2 = resulttable[activeGame]["indicator2"]
  local indicator3 = resulttable[activeGame]["indicator3"]
  if (indicator1 == "w") then
    multiMenu:clear(wincol, {x = ((multiMenu:get_width()/2)-(multiMenu:get_width()/10*3)/2)-multiMenu:get_width()/5, y = (multiMenu:get_height())/2, w = ((multiMenu:get_width())/10)*3, h = 50})
  elseif (indicator1 == "n") then
    multiMenu:clear(nocol, {x = ((multiMenu:get_width()/2)-(multiMenu:get_width()/10*3)/2)-multiMenu:get_width()/5, y = (multiMenu:get_height())/2, w = ((multiMenu:get_width())/10)*3, h = 50})
  else
    multiMenu:clear(losecol, {x = ((multiMenu:get_width()/2)-(multiMenu:get_width()/10*3)/2)-multiMenu:get_width()/5, y = (multiMenu:get_height())/2, w = ((multiMenu:get_width())/10)*3, h = 50})
  end
  if (indicator2 == "w") then
    multiMenu:clear(wincol, {x = ((multiMenu:get_width()/2)-(multiMenu:get_width()/10*3)/2)-multiMenu:get_width()/5, y = ((multiMenu:get_height())/2)*1.3, w = ((multiMenu:get_width())/10)*3, h = 50})
  elseif (indicator2 == "n") then
    multiMenu:clear(nocol, {x = ((multiMenu:get_width()/2)-(multiMenu:get_width()/10*3)/2)-multiMenu:get_width()/5, y = ((multiMenu:get_height())/2)*1.3, w = ((multiMenu:get_width())/10)*3, h = 50})
  else
    multiMenu:clear(losecol, {x = ((multiMenu:get_width()/2)-(multiMenu:get_width()/10*3)/2)-multiMenu:get_width()/5, y = ((multiMenu:get_height())/2)*1.3, w = ((multiMenu:get_width())/10)*3, h = 50})
  end
  if (indicator3 == "w") then
    multiMenu:clear(wincol, {x = ((multiMenu:get_width()/2)-(multiMenu:get_width()/10*3)/2)-multiMenu:get_width()/5, y = ((multiMenu:get_height())/2)*1.6, w = ((multiMenu:get_width())/10)*3, h = 50})
  elseif (indicator3 == "n") then
    multiMenu:clear(nocol, {x = ((multiMenu:get_width()/2)-(multiMenu:get_width()/10*3)/2)-multiMenu:get_width()/5, y = ((multiMenu:get_height())/2)*1.6, w = ((multiMenu:get_width())/10)*3, h = 50})
  else
    multiMenu:clear(losecol, {x = ((multiMenu:get_width()/2)-(multiMenu:get_width()/10*3)/2)-multiMenu:get_width()/5, y = ((multiMenu:get_height())/2)*1.6, w = ((multiMenu:get_width())/10)*3, h = 50})
  end
  
  --multiplayermenu.writeWord(score1,{r = 255, g = 255, b =255},35,{x=((multiMenu:get_width()/2)-(multiMenu:get_width()/10*3)/2)-multiMenu:get_width()/5+50, y= (multiMenu:get_height())/2+8})
  --multiplayermenu.writeWord(score2,{r = 255, g = 255, b =255},35,{x=((multiMenu:get_width()/2)-(multiMenu:get_width()/10*3)/2)-multiMenu:get_width()/5+50, y= ((multiMenu:get_height())/2)*1.3+8})
  --multiplayermenu.writeWord(score3,{r = 255, g = 255, b =255},35,{x=((multiMenu:get_width()/2)-(multiMenu:get_width()/10*3)/2)-multiMenu:get_width()/5+50, y= ((multiMenu:get_height())/2)*1.6+8})
  --multiplayermenu.writeWord(score1, btnfirst)
  --multiplayermenu.writeWord(score2, btnsec)
  --multiplayermenu.writeWord(score3, btnthird)
  
  btnfirst:draw_over_surface(multiMenu,score1)
  btnsec:draw_over_surface(multiMenu,score2)
  btnthird:draw_over_surface(multiMenu,score3)
  
  screen:copyfrom(multiMenu, nil)
  gfx.update()
end

--reloads the most recent results
function multiplayermenu.reloadRecent()
  
  local btnett = sys.new_freetype({r = 255, g = 255, b =255},35,{x=((multiMenu:get_width()/2)-(multiMenu:get_width()/10*3)/2)-multiMenu:get_width()/5+50, y= (multiMenu:get_height())/2+8}, font_path)
  local btntva = sys.new_freetype({r = 255, g = 255, b =255},35,{x=((multiMenu:get_width()/2)-(multiMenu:get_width()/10*3)/2)-multiMenu:get_width()/5+50, y= ((multiMenu:get_height())/2)*1.3+8}, font_path)
  local btntre = sys.new_freetype({r = 255, g = 255, b =255},35,{x=((multiMenu:get_width()/2)-(multiMenu:get_width()/10*3)/2)-multiMenu:get_width()/5+50, y= ((multiMenu:get_height())/2)*1.6+8}, font_path)
  
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
    multiMenu:clear(wincol, {x = ((multiMenu:get_width()/2)-(multiMenu:get_width()/10*3)/2)-multiMenu:get_width()/5, y = (multiMenu:get_height())/2, w = ((multiMenu:get_width())/10)*3, h = 50})
  elseif (indicator1 == "n") then
    multiMenu:clear(nocol, {x = ((multiMenu:get_width()/2)-(multiMenu:get_width()/10*3)/2)-multiMenu:get_width()/5, y = (multiMenu:get_height())/2, w = ((multiMenu:get_width())/10)*3, h = 50})
  else
    multiMenu:clear(losecol, {x = ((multiMenu:get_width()/2)-(multiMenu:get_width()/10*3)/2)-multiMenu:get_width()/5, y = (multiMenu:get_height())/2, w = ((multiMenu:get_width())/10)*3, h = 50})
  end
  if (indicator2 == "w") then
    multiMenu:clear(wincol, {x = ((multiMenu:get_width()/2)-(multiMenu:get_width()/10*3)/2)-multiMenu:get_width()/5, y = ((multiMenu:get_height())/2)*1.3, w = ((multiMenu:get_width())/10)*3, h = 50})
  elseif (indicator2 == "n") then
    multiMenu:clear(nocol, {x = ((multiMenu:get_width()/2)-(multiMenu:get_width()/10*3)/2)-multiMenu:get_width()/5, y = ((multiMenu:get_height())/2)*1.3, w = ((multiMenu:get_width())/10)*3, h = 50})
  else
    multiMenu:clear(losecol, {x = ((multiMenu:get_width()/2)-(multiMenu:get_width()/10*3)/2)-multiMenu:get_width()/5, y = ((multiMenu:get_height())/2)*1.3, w = ((multiMenu:get_width())/10)*3, h = 50})
  end
  if (indicator3 == "w") then
    multiMenu:clear(wincol, {x = ((multiMenu:get_width()/2)-(multiMenu:get_width()/10*3)/2)-multiMenu:get_width()/5, y = ((multiMenu:get_height())/2)*1.6, w = ((multiMenu:get_width())/10)*3, h = 50})
  elseif (indicator3 == "n") then
    multiMenu:clear(nocol, {x = ((multiMenu:get_width()/2)-(multiMenu:get_width()/10*3)/2)-multiMenu:get_width()/5, y = ((multiMenu:get_height())/2)*1.6, w = ((multiMenu:get_width())/10)*3, h = 50})
  else
    multiMenu:clear(losecol, {x = ((multiMenu:get_width()/2)-(multiMenu:get_width()/10*3)/2)-multiMenu:get_width()/5, y = ((multiMenu:get_height())/2)*1.6, w = ((multiMenu:get_width())/10)*3, h = 50})
  end
  
  --multiplayermenu.writeWord(score1,{r = 255, g = 255, b =255},35,{x=((multiMenu:get_width()/2)-(multiMenu:get_width()/10*3)/2)-multiMenu:get_width()/5+50, y= (multiMenu:get_height())/2+8})
  --multiplayermenu.writeWord(score2,{r = 255, g = 255, b =255},35,{x=((multiMenu:get_width()/2)-(multiMenu:get_width()/10*3)/2)-multiMenu:get_width()/5+50, y= ((multiMenu:get_height())/2)*1.3+8})
  --multiplayermenu.writeWord(score3,{r = 255, g = 255, b =255},35,{x=((multiMenu:get_width()/2)-(multiMenu:get_width()/10*3)/2)-multiMenu:get_width()/5+50, y= ((multiMenu:get_height())/2)*1.6+8})
  
  btnett:draw_over_surface(multiMenu,score1)
  btntva:draw_over_surface(multiMenu,score2)
  btntre:draw_over_surface(multiMenu,score3)
  --collectgarbage("stop")
  screen:copyfrom(multiMenu, nil)
  
  ADLogger.trace("Memory usage after multi-gameswitch load " .. collectgarbage("count"))
  --ADLogger.trace("Memory usage after multi-gameswitch load 2 " .. gfx.get_memory_use()) 
  
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
  multiMenu:clear(color, {x = startX, y = startY, w = width, h = margin})
  multiMenu:clear(color, {x = startX, y = startY, w = margin, h = height})
  multiMenu:clear(color, {x = startX, y = startY+height, w = width+margin, h = margin})
  multiMenu:clear(color, {x = startX+width, y = startY, w = margin, h = height+margin})
end

--loads the current players
--@param players - the number of players online
function multiplayermenu.loadCurrentPlayers(players)
  local color = {r=20, g=10, b=0}
  margin = 5
  currentplayers = players or 0
  --multiplayermenu.drawBorder(multiMenu, ((multiMenu:get_width()/2)-(multiMenu:get_width()/10*3)/2)+multiMenu:get_width()/5, (multiMenu:get_height())/2, multiMenu:get_width()/10*3, 50, margin, color)
  --multiplayermenu.writeWord(currentplayers,{r = 100, g = 0, b =100},35,{x=(((multiMenu:get_width()/2)-(multiMenu:get_width()/10*3)/2)+multiMenu:get_width()/5)+25, y= ((multiMenu:get_height())/2)*1.02},multiMenu)
end

--starts the selected game
function multiplayermenu.start()
    
    activeView = a[tempActive]["name"]
    current_menu = "none"
    local commence = assert(loadfile(root_path..a[tempActive]["start"]))
    multiMenu:destroy()
    commence()
end

--loads the game menu and carousel
function multiplayermenu.loadGameMenu()
  activeGame = 2
  color = {r=20, g=10, b=0}
  margin = 5
  local bg = gfx.loadjpeg(a[activeGame-1]["path"] .. 'background-small.jpg')
  multiMenu:copyfrom(bg, nil, {x=((multiMenu:get_width())/2)-350, y= multiMenu:get_height()/20+37})
  bg:destroy()
  local bg = gfx.loadjpeg(a[activeGame+1]["path"] .. 'background-small.jpg')
  multiMenu:copyfrom(bg, nil, {x=((multiMenu:get_width())/2)+100, y= multiMenu:get_height()/20+37})
  bg:destroy()
  local bg = gfx.loadjpeg(a[activeGame]["path"] .. 'background.jpg')
  multiMenu:copyfrom(bg, nil, {x=((multiMenu:get_width())/2)-150, y= multiMenu:get_height()/20+20})
  bg:destroy()
  
  screen:copyfrom(multiMenu, nil)
  gfx.update()
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
    multiMenu:copyfrom(bg, nil, {x=((multiMenu:get_width())/2)-350, y= multiMenu:get_height()/20+37})
    bg:destroy()
    local bg = gfx.loadjpeg(a[next]["path"] .. 'background-small.jpg')
    multiMenu:copyfrom(bg, nil, {x=((multiMenu:get_width())/2)+100, y= multiMenu:get_height()/20+37})
    bg:destroy()
    local bg = gfx.loadjpeg(a[activeGame]["path"] .. 'background.jpg')
    multiMenu:copyfrom(bg, nil, {x=((multiMenu:get_width())/2)-150, y= multiMenu:get_height()/20+20})
    bg:destroy()
    
    screen:copyfrom(multiMenu, nil)
    --collectgarbage()
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
    multiMenu:copyfrom(bg, nil, {x=((multiMenu:get_width())/2)-350, y= multiMenu:get_height()/20+37})
    bg:destroy()
    local bg = gfx.loadjpeg(a[next]["path"] .. 'background-small.jpg')
    multiMenu:copyfrom(bg, nil, {x=((multiMenu:get_width())/2)+100, y= multiMenu:get_height()/20+37})
    bg:destroy()
    local bg = gfx.loadjpeg(a[activeGame]["path"] .. 'background.jpg')
    multiMenu:copyfrom(bg, nil, {x=((multiMenu:get_width())/2)-150, y= multiMenu:get_height()/20+20})
    bg:destroy()
    --collectgarbage()
    
    screen:copyfrom(multiMenu, nil)
    multiplayermenu.reloadRecent()
    activeGame=prev
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