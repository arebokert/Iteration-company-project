--------------------------------------------------------------------
--class: showmenu                                           --------
--description: load the main menu of the application        --------
--last modified Nov 17, 2015                                --------
--------------------------------------------------------------------
showmenu = {}

Menu = require "model.mainmenu.menuclass"
highScoreMenu = require "views.mainmenu.highScoreMenu"
singlePlayerMenu = require "views.mainmenu.singlePlayerMenu"
multiPlayerMenu = require "views.multiplayermenu.multiplayermenu"

--print(package.path)
datapath = "views/mainmenu/data"
local mainMenuContainer = nil

--------------------------------------------------------------------
--function: loadMainMenu                                    --------
--description: load the mainmenus of the whole page         --------
--last modified Nov 17, 2015                                --------
--------------------------------------------------------------------
function showmenu.loadMainMenu()

    local options = {}
    options[1] = {title = "Game",
        action = function()
            current_menu = "singlePlayerMenu" 
            return "Return Option1"
        end,
        hover = function()
            local bg = gfx.loadpng(datapath .. '/bg1280-720.png')
            appSurface:copyfrom(bg, nil)
            bg:destroy()
            showmenu.loadMenu("singlePlayer")
            ADLogger.trace("Calling show loadmenu")
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
            appSurface:copyfrom(bg, nil)
            bg:destroy()
            showmenu.loadMenu("highScore")
            return true
        end,
        button =datapath..'/highscore-normal.png',
        button_marked = datapath .. '/highscore-selected.png'
    }

  options[3] = {title = "Multiplayer",
        action = function()
            current_menu = "multiPlayerMenu"
            
            return "Return Option3"
        end,
        hover = function()
            local bg = gfx.loadpng(datapath .. '/bg1280-720.png')
            appSurface:copyfrom(bg, nil)
            bg:destroy()
            showmenu.loadMenu("multiplayer")
            return true
        end,
        button = datapath .. '/multi-normal.png',
        button_marked = datapath .. '/multi-selected.png'
    }
  
    options[4] = {title = "Exit",
        action = function()
            current_menu = "exit"
            sys.stop()
            return "Return Option4"
        end,
        hover = function()
            local bg = gfx.loadpng(datapath .. '/bg1280-720.png')
            appSurface:copyfrom(bg, nil)
            bg:destroy()
            return true
        end,
        button = datapath .. '/exit-normal.png',
        button_marked = datapath .. '/exit-selected.png'
    }
 
    _G.mainMenu = Menu:new()
    mainMenu:setOptions(options)
    mainMenuContainer = gfx.new_surface(appSurface:get_width(), appSurface:get_height()/3.0)
    mainMenuContainer:clear( {g=0, r=0, b=255, a=25} )
    _G.current_menu = "mainMenu"
    mainMenu.containerPos = {x = 0, y=appSurface:get_height()-mainMenuContainer:get_height()}

    mainMenu:print(mainMenuContainer, mainMenuContainer:get_height()/2, 60, 120)
    _G.activeMenu = mainMenu
    mainMenu:setActive(1)
    gfx.update()
end


--------------------------------------------------------------------
--function: loadMenu                                        --------
--@param: subMenuFlag    the flag to identify which submenu --------
--description: load four concrete content of four submenu   --------
--last modified Nov 17, 2015                                --------
--------------------------------------------------------------------
function showmenu.loadMenu(subMenuFlag)
  if(subMenuFlag == "highScore") then 
      if ab then
        ADLogger.trace("Destroy 1!!!!!!!")
        ab:destroy()
        ADLogger.trace("Destroyed")
      end
      if highScoreSurface then
        ADLogger.trace("Destroy 2!!!!!!!")
        highScoreSurface:destroy()
        ADLogger.trace("Destroyed")
      end
  
      if multiMenu then
        ADLogger.trace("Destroy 3!!!!!!!")
        multiMenu:destroy()
        ADLogger.trace("Destroyed")
      end
      
      highScoreMenu.loadMenu()
      
  elseif(subMenuFlag == "singlePlayer") then
      appSurface:destroyMenu()   
      singlePlayerMenu.loadMenu()
      
  elseif(subMenuFlag == "multiplayer") then
      appSurface:destroyMenu() 
      multiPlayerMenu.loadMenu()
      
  elseif(subMenuFlag == "exit") then
      appSurface:destroyMenu() 
  end
end

--------------------------------------------------------------------
--function: registerKey                                   --------
--@param: key    the key pressed(left,right,up,down,ok)     --------
--@param: state  the state of keypress(up,down, repeat)     --------
--description: key functions of mainmenu                    --------
--last modified Nov 17, 2015                                --------
--------------------------------------------------------------------
function showmenu.registerKey(key,state)
    if key == "left" then
        mainMenu:prev()
    elseif key == "right" then
        mainMenu:next()
    elseif key == "ok"   then
        mainMenu:action()
    elseif key == "up"  then
      if mainMenu:getActive()==4 then
        return
      end
        mainMenu:action()
    elseif key == "exit" then
        sys.stop()
    end
end


--------------------------------------------------------------------
--function: mainMenuKeyEvents                               --------
--@param: key    the key pressed(left,right,up,down,ok)     --------
--@param: state  the state of keypress(up,down, repeat)     --------
--description: key functions of the whole menus             --------
--last modified Nov 17, 2015                                --------
--------------------------------------------------------------------
function showmenu.mainMenuKeyEvents(key, state)
    if current_menu == "mainMenu" then
    showmenu.registerKey(key,state)
    elseif current_menu == "highScoreMenu" then
    highScoreMenu.registerKey(key, state)
    elseif current_menu == "singlePlayerMenu" then
    singlePlayerMenu.registerKey(key,state)
    elseif current_menu == "multiPlayerMenu" then
    multiPlayerMenu.registerKey(key, state)
    end
end

--function: destroyContainer()
-- Destroys the container created in loadMenu()
function showmenu.destroyContainer()
    if mainMenuContainer then
      mainMenuContainer:destroy()
    end
end

return showmenu
