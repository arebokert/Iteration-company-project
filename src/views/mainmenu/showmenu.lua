showmenu = {}
--print(package.path)
Menu = require "model.mainmenu.menuclass"
highScoreMenu = require "views.mainmenu.highScoreMenu"
singlePlayerMenu = require "views.mainmenu.singlePlayerMenu"
datapath = "views/mainmenu/data"

function showmenu.loadMainMenu()
    options = {}
    options[1] = {title = "Game",
        action = function()
            current_menu = "singlerPlayerMenu"  -- give the temperate active menu to singlerPlayerMenu
            return "Return Option1"
        end,
        hover = function()
            local bg = gfx.loadpng(datapath .. '/bg1280-720.png')
            screen:copyfrom(bg, nil)
            bg:destroy()
            showmenu.loadMenu("singlePlayer")
            collectgarbage()
            return true
        end,
        button = datapath .. '/games-normal.png',
        button_marked = datapath .. '/games-selected.png'
    }
    options[2] = {title = "HighScore",
        action = function()
          current_menu = "highScoreMenu"
          return "Return Option2"
        end,
        hover = function()
            local bg = gfx.loadpng(datapath .. '/bg1280-720.png')
            screen:copyfrom(bg, nil)
            bg:destroy()
            showmenu.loadMenu("highScore")
            collectgarbage()
            return true
        end,
        button =datapath..'/highscore-normal.png',
        button_marked = datapath .. '/highscore-selected.png'
    }

	options[3] = {title = "Multiplayer",
        action = function()
            --current_menu = "multiplayerMenu"
            return "Return Option3"
        end,
        hover = function()
            local bg = gfx.loadpng(datapath .. '/bg1280-720.png')
            screen:copyfrom(bg, nil)
            bg:destroy()
            --showMenu.loadMenu("multiplayer")
            return true
        end,
        button = datapath .. '/multi-normal.png',
        button_marked = datapath .. '/multi-selected.png'
    }
	
    options[4] = {title = "Exit",
        action = function()
            --sys.stop()
            --showmenu.loadMenu("exit")
            return "Return Option4"
        end,
        hover = function()
            local bg = gfx.loadpng(datapath .. '/bg1280-720.png')
            screen:copyfrom(bg, nil)
            bg:destroy()
            return true
        end,
        button = datapath .. '/exit-normal.png',
        button_marked = datapath .. '/exit-selected.png'
    }

    _G.mainMenu = Menu:new()
    _G.current_menu = "mainMenu"
    mainMenu:setOptions(options)

    mainMenuContainer = gfx.new_surface(screen:get_width(), screen:get_height()/3.0)
    mainMenuContainer:clear( {g=0, r=0, b=255, a=25} )

    mainMenu.containerPos = {x = 0, y=screen:get_height()-mainMenuContainer:get_height()}
    mainMenu:print(mainMenuContainer, mainMenuContainer:get_height()/2, 60, 120)
    mainMenu:setActive(1)
    gfx.update()
end

function showmenu.loadBackground()
  _G.subMenu = Menu:new()
  subMenuContainer = gfx.new_surface(screen:get_width(),screen:get_height()*2.0/3.0)
  
  subMenuContainer:clear({r=0, g = 52, b=113, a=120}, {x =screen:get_width()/20, y = screen:get_height()/20, w= screen:get_width() *0.9, h = screen:get_height()* 0.56 })
 
  return subMenuContainer
end


-- mainly show the highscore page
function showmenu.loadMenu(subMenuFlag)
  -- use subMenuContainer as an arguments to your screen, and then show it
  subMenuContainer = showmenu.loadBackground()
  
  if(subMenuFlag == "highScore") then
    highScoreMenu.loadMenu(subMenuContainer)
  elseif(subMenuFlag == "singlePlayer") then
    singlePlayerMenu.loadMenu(subMenuContainer)
  elseif(subMenuFlag == "multiplayer") then
    --multiplayerMenu.loadMenu(subMenuContainer)
  elseif(subMenuFlag == "exit") then
    -- exitMenu.loadMenu(subMenuContainer)
  end
  subMenu:printSub(subMenuContainer)
  gfx.update()
  collectgarbage()
end

function showmenu.registerKey(key,state)
  if current_menu == "mainMenu" then
    if key == "left" then
        activeMenu:prev()
    elseif key == "right" then
        activeMenu:next()
    elseif key == "ok"   then
        activeMenu:action()
    elseif key == "up"  then
        activeMenu:action()
    elseif key == "exit" then
        sys.stop()
    end
  end
end

function showmenu.mainMenuKeyEvents(key, state)
    showmenu.registerKey(key,state)
    highScoreMenu.registerKey(key, state)
    singlePlayerMenu.registerKey(key,state)
    multiMenu.registerKey(key, state)
end

return showmenu
