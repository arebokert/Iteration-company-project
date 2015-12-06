model = require "model.multiplayermenu.multiplayermenu"

multiplayermenu = {}

local resulttable = nil
local activeGame = nil
local a = {}
local tempActive = 2
local first_treverse = nil
multiMenu = nil
local font_path = root_path.."views/mainmenu/data/font/Gidole-Regular.otf"

--loads the view for the multiplayer menu
--@param model - instantiates the model for the multiplayermenu
function multiplayermenu.loadMenu()
  first_treverse = true
  model = model:new()
  a = model:fetchPath()
  multiMenu = gfx.new_surface(appSurface:get_width(),appSurface:get_height()*2.0/3.0)
  multiMenu:clear({r=7, g = 19, b=77, a = 50}, {x =appSurface:get_width()/20, y = appSurface:get_height()/20, w= appSurface:get_width() *0.9, h = appSurface:get_height()* 0.56 })
  multiplayermenu.loadGameMenu()
  multiplayermenu.loadRecentResults(model:fetchResults())
  multiplayermenu.loadCurrentPlayers(0)
  
  appSurface:copyfrom(multiMenu, nil)
  gfx.update()
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
  ADLogger.trace(font_path)
  word = word or  "hello world" 
end

--loads the most recent results
--@param recentRes - array from where to read recent results
function multiplayermenu.loadRecentResults(recentRes)
  multiMenu:clear()
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
  
  btnfirst:draw_over_surface(multiMenu,score1)
  btnsec:draw_over_surface(multiMenu,score2)
  btnthird:draw_over_surface(multiMenu,score3)

  appSurface:copyfrom(multiMenu, nil)
  gfx.update()
end

--reloads the most recent results
function multiplayermenu.reloadRecent()
  multiMenu:clear()
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
  
  btnett:draw_over_surface(multiMenu,score1)
  btntva:draw_over_surface(multiMenu,score2)
  btntre:draw_over_surface(multiMenu,score3)
  
  appSurface:copyfrom(multiMenu, nil)

  gfx:update()
end

--loads the current players
--@param players - the number of players online
function multiplayermenu.loadCurrentPlayers(players)
  local color = {r=20, g=10, b=0}
  margin = 5
  currentplayers = players or 0
end

--starts the selected game
function multiplayermenu.start()
    activeView = a[tempActive]["name"]
    current_menu = "none"
    multiMenu:destroy()
    local commence = assert(loadfile(root_path..a[tempActive]["start"]))
    ADLogger.trace(getMemoryUsage("ram"))
    ADLogger.trace(getMemoryUsage("gfx"))
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
  
  appSurface:copyfrom(multiMenu, nil)
  gfx.update()
end

--Called upon hitting the "right"-key/button.
--treverses the carousel
function multiplayermenu:next()

    if first_treverse then
        activeGame = activeGame + 1
    end

    multiMenu:clear()
    local next = activeGame + 1
    local prev = activeGame - 1
    
    if (next>model:getSize()) then
      next = 1
    end
    if activeGame==1 then
      prev = model:getSize()
    end

    tempActive = activeGame
    ADLogger.trace(tempActive)
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
    
    first_treverse = false
    
    appSurface:copyfrom(multiMenu, nil)
    gfx.update()
    --collectgarbage()
    multiplayermenu.reloadRecent()
    
    ADLogger.trace(getMemoryUsage("gfx"))
    ADLogger.trace(getMemoryUsage("ram"))
    activeGame=next
end

--Called upon hitting the "left"-key/button.
--treverses the carousel
function multiplayermenu:prev()
    
    if first_treverse then
        activeGame = activeGame - 1
    end
    
    multiMenu:clear()
    
    local next = activeGame + 1
    local prev = activeGame - 1

    if (prev<1) then
      prev = model:getSize()
    end
    if (next>model:getSize()) then
      next = 1
    end
    tempActive = activeGame
     ADLogger.trace(tempActive)
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
    
    first_treverse = false
    
    appSurface:copyfrom(multiMenu, nil)
    gfx.update()
    multiplayermenu.reloadRecent()
    
    ADLogger.trace(getMemoryUsage("gfx"))
    ADLogger.trace(getMemoryUsage("ram"))
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