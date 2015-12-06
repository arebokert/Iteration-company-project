smodel = require "model.singleplayermenu.singleplayermenu"

singlePlayerMenu = {}

local activeGame = nil
ab = nil
local a = {}
local tempActive = nil
local font_path = root_path.."views/mainmenu/data/font/Gidole-Regular.otf"
local first_treverse = nil

--loads the view for the multiplayer menu
--@param model - instantiates the model for the singlePlayerMenu
function singlePlayerMenu.loadMenu()
  ADLogger.trace("Loading singleplayer")

  first_treverse = true

  smodel = smodel:new()
  ADLogger.trace("Finished reading file")
  a = smodel:fetchPath()
  ADLogger.trace("Finished fetching paths")
  ab = gfx.new_surface(appSurface:get_width(),appSurface:get_height()*2.0/3.0)
  ab:clear({r=7, g = 19, b=77, a = 50}, {x =appSurface:get_width()/20, y = appSurface:get_height()/20, w= appSurface:get_width() *0.9, h = appSurface:get_height()* 0.56 })
  ADLogger.trace("Created surface")
  
  singlePlayerMenu.loadGameMenu()
  ADLogger.trace("Reached GFX-update singleplayer")
  gfx.update()
  appSurface:copyfrom(ab, nil)
  gfx.update()
end

--starts the selected game
function singlePlayerMenu.start()
    ab:destroy()
    appSurface:destroy()
    activeView = a[tempActive]["name"]
    current_menu = "none"
    if a[tempActive]["name"] == "pacman" then
      gamehandler.loadPacman()
    elseif a[tempActive]["name"] == "multiplayer2048" then
      activeView = "2048"
      ADLogger.trace(tempActive)
      game2048.startGame()
    else
      sys.stop()
    end
end

--loads the game menu and carousel
function singlePlayerMenu.loadGameMenu()
  tempActive = 2
  activeGame = tempActive

  ADLogger.trace(gfx.get_memory_use())
  local bg = gfx.loadjpeg(a[activeGame-1]["path"] .. 'background-small.jpg')
  ab:copyfrom(bg, nil, {x=((ab:get_width())/2)-350, y= ab:get_height()/20+77})
  bg:destroy()

  local bg = gfx.loadjpeg(a[activeGame+1]["path"] .. 'background-small.jpg')
  ab:copyfrom(bg, nil, {x=((ab:get_width())/2)+100, y= ab:get_height()/20+77})
  bg:destroy()

  local bg = gfx.loadjpeg(a[activeGame]["path"] .. 'background.jpg')
  ab:copyfrom(bg, nil, {x=((ab:get_width())/2)-150, y= ab:get_height()/20+60})
  bg:destroy()

  appSurface:copyfrom(ab, nil)
end

--Called upon hitting the "right"-key/button.
--treverses the carousel
function singlePlayerMenu:next()
    
    if first_treverse then
      activeGame = activeGame + 1
    end
    
    ab:clear()
    local next = activeGame + 1
    local prev = activeGame - 1
    
    if (next>smodel:getSize()) then
      next = 1
    end
    if activeGame==1 then
      prev = smodel:getSize()
    end
      
    tempActive = activeGame
      
    ADLogger.trace(tempActive)
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
    
    appSurface:copyfrom(ab, nil)
    gfx.update()
    
    first_treverse = false
    activeGame=next
end

--Called upon hitting the "left"-key/button.
--treverses the carousel
function singlePlayerMenu:prev()

    if first_treverse then
        activeGame = activeGame - 1
    end

    ab:clear()
    local next = activeGame + 1
    local prev = activeGame - 1

    if (prev<1) then
      prev = smodel:getSize()
    end
    if (next>smodel:getSize()) then
      next = 1
    end
    tempActive = activeGame
    ADLogger.trace(tempActive)
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
    
    first_treverse = false
    
    appSurface:copyfrom(ab, nil)
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
