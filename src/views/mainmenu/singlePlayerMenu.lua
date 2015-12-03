smodel = require "model.singleplayermenu.singleplayermenu"

singlePlayerMenu = {}

local activeGame = nil
--local ab = gfx.new_surface(screen:get_width(),screen:get_height()*2.0/3.0)'
ab = nil
local a = {}
local tempActive = nil
local font_path = root_path.."views/mainmenu/data/font/Gidole-Regular.otf"

--loads the view for the multiplayer menu
--@param model - instantiates the model for the singlePlayerMenu
function singlePlayerMenu.loadMenu()
  ADLogger.trace("Loading singleplayer")
  --collectgarbage("stop")
  smodel = smodel:new()
  ADLogger.trace("Finished reading file")
  a = smodel:fetchPath()
  ADLogger.trace("Finished fetching paths")
  ab = gfx.new_surface(screen:get_width(),screen:get_height()*2.0/3.0)
  ab:clear({r=7, g = 19, b=77}, {x =screen:get_width()/20, y = screen:get_height()/20, w= screen:get_width() *0.9, h = screen:get_height()* 0.56 })
  ADLogger.trace("Created surface")
  
  singlePlayerMenu.loadGameMenu()
  --gfx.update()
  --screen:clear({r=7, g = 19, b=77, a = 20}, {x =screen:get_width()*0.05, y = screen:get_height()*0.05, w= screen:get_width() *0.9, h = screen:get_height()* 0.55 })
  ADLogger.trace("Reached GFX-update singleplayer")
  gfx.update()
  screen:copyfrom(ab, nil)
  gfx.update()
  --ADLogger.trace(collectgarbage("count")*1024)
  --collectgarbage()
  --collectgarbage("stop")
  --for testing, prints bytes of memory used for each transaction
  --ADLogger.trace(collectgarbage("count")*1024)
  
  --collectgarbage("stop")
  --collectgarbage()
  --collectgarbage("stop")
end

--prints a border with selected parameters
--@param Screen - the surface on which to print the menu
--@param startX - top line (pixels)
--@param startY - leftmost line (pixels)
--@param width - the width of the border (box)
--@param height - the height of the border (box)
--@param margin - the margin (thickness) of the line
--@param color - the color of the line
function singlePlayerMenu.drawBorder(startX, startY, width, height, margin, color)
  screen:clear(color, {x = startX, y = startY, w = width, h = margin})
  screen:clear(color, {x = startX, y = startY, w = margin, h = height})
  screen:clear(color, {x = startX, y = startY+height, w = width+margin, h = margin})
  screen:clear(color, {x = startX+width, y = startY, w = margin, h = height+margin})
end

--starts the selected game
function singlePlayerMenu.start()
    --[[ADLogger.trace("Memory usage after pacman load " .. collectgarbage("count"))
    --ADLogger.trace("Memory usage after pacman load 2 " .. gfx.get_memory_use())
    activeView = a[tempActive]["name"]
    current_menu = "none"
    local commence = assert(loadfile(root_path..a[tempActive]["start"]))
    collectgarbage()
    collectgarbage("stop")
    ADLogger.trace("Destroy!!!!!!!")
    ab:destroy()
    ADLogger.trace("Memory usage after pacman garbage load " .. collectgarbage("count"))
    --ADLogger.trace("Memory usage after pacman garbage load 2 " .. gfx.get_memory_use())
    commence()]]
    
    --temporary, hard-coded gamestart
    ab:destroy()
    if a[tempActive]["name"] == "pacman" then
      gamehandler.loadPacman()
    elseif a[tempActive]["name"] == "2048" then
      game.startGame()
    else
      sys.stop()
    end
end

--loads the game menu and carousel
function singlePlayerMenu.loadGameMenu()
  tempActive = 2
  activeGame = tempActive
  ADLogger.trace("set variable "..activeGame)
  ADLogger.trace(gfx.get_memory_use())
  local bg = gfx.loadjpeg(a[activeGame-1]["path"] .. 'background-small.jpg')
  ab:copyfrom(bg, nil, {x=((ab:get_width())/2)-350, y= ab:get_height()/20+77})
  bg:destroy()
  ADLogger.trace(gfx.get_memory_use())
  local bg = gfx.loadjpeg(a[activeGame+1]["path"] .. 'background-small.jpg')
  ab:copyfrom(bg, nil, {x=((ab:get_width())/2)+100, y= ab:get_height()/20+77})
  bg:destroy()
  ADLogger.trace("second loaded")
  local bg = gfx.loadjpeg(a[activeGame]["path"] .. 'background.jpg')
  ab:copyfrom(bg, nil, {x=((ab:get_width())/2)-150, y= ab:get_height()/20+60})
  bg:destroy()
  ADLogger.trace("third loaded")
  screen:copyfrom(ab, nil)

  ADLogger.trace("Memory usage after single-gameswitch load " .. collectgarbage("count"))
  --ADLogger.trace("Memory usage after single-gameswitch load 2 " .. gfx.get_memory_use()) 
  gfx.update()
end

--Called upon hitting the "right"-key/button.
--treverses the carousel
function singlePlayerMenu:next()
    local next = activeGame + 1
    local prev = activeGame - 1
    
    if (next>smodel:getSize()) then
      next = 1
    end
    if activeGame==1 then
      prev = smodel:getSize()
    end

    tempActive = activeGame
    --reloads the images with the new paths
    local bg = gfx.loadjpeg(a[prev]["path"] .. 'background-small.jpg')
    ab:copyfrom(bg, nil, {x=((ab:get_width())/2)-350, y= ab:get_height()/20+77})
    bg:destroy()
    local bg = gfx.loadjpeg(a[next]["path"] .. 'background-small.jpg')
    ab:copyfrom(bg, nil, {x=((ab:get_width())/2)+100, y= ab:get_height()/20+77})
    bg:destroy()
    local bg = gfx.loadjpeg(a[activeGame]["path"] .. 'background.jpg')
    ab:copyfrom(bg, nil, {x=((ab:get_width())/2)-150, y= ab:get_height()/20+60})
    bg:destroy()
    
    screen:copyfrom(ab, nil)
    --collectgarbage()
    --singlePlayerMenu.reloadRecent()
    gfx.update()
    activeGame=next
end

--Called upon hitting the "left"-key/button.
--treverses the carousel
function singlePlayerMenu:prev()
    local next = activeGame + 1
    local prev = activeGame - 1

    if (prev<1) then
      prev = smodel:getSize()
    end
    if (next>smodel:getSize()) then
      next = 1
    end
    tempActive = activeGame
    
    --reloads the images with the new paths
    local bg = gfx.loadjpeg(a[prev]["path"] .. 'background-small.jpg')
    ab:copyfrom(bg, nil, {x=((ab:get_width())/2)-350, y= ab:get_height()/20+77})
    bg:destroy()
    local bg = gfx.loadjpeg(a[next]["path"] .. 'background-small.jpg')
    ab:copyfrom(bg, nil, {x=((ab:get_width())/2)+100, y= ab:get_height()/20+77})
    bg:destroy()
    local bg = gfx.loadjpeg(a[activeGame]["path"] .. 'background.jpg')
    ab:copyfrom(bg, nil, {x=((ab:get_width())/2)-150, y= ab:get_height()/20+60})
    bg:destroy()
    --collectgarbage()
    
    screen:copyfrom(ab, nil)
    --singlePlayerMenu.reloadRecent()
    gfx.update()
    activeGame=prev
end


--Listener for keycommands, repeated in every menu-class.
--@param key - key that is pressed
--@param state - state of the pressed key
function singlePlayerMenu.registerKey(key,state)
  if current_menu == "singlePlayerMenu" then
    if key == "left" then
        singlePlayerMenu:prev()
    elseif key == "right" then
        singlePlayerMenu:next()
    elseif key == "ok" then
        singlePlayerMenu:start()
    elseif key == "down" then
        current_menu = "mainMenu"
    end
  end
end

return singlePlayerMenu
