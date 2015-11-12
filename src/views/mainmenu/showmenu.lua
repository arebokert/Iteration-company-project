showmenu = {}
Menu = require "model/mainmenu/menuclass"
highScoreMenu = require "views/mainmenu/highScoreMenu"
datapath = root_path .. "views/mainmenu/data"

function showmenu.loadMainMenu()
    options = {}
    options[1] = {title = "Game",
        action = function()
            activeMenu = secondary
            secondary:setActive(1)
            return "Return Option1"
        end,
        hover = function()
            local bg = gfx.loadpng(datapath .. '/bg1280-720.png')
            screen:copyfrom(bg, nil)
            bg:destroy()
            showmenu.loadSecondaryMenu()
            collectgarbage()
            return true
        end,
        button = datapath .. '/games-normal.png',
        button_marked =datapath .. '/games-selected.png',
        leave = function()
            local bg = gfx.loadpng(datapath .. '/bg1280-720.png')
            screen:copyfrom(bg, nil)
            bg:destroy()
            gfx.update()
            return true
        end}

    options[2] = {title = "HighScore",
        action = function()
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
        button_marked = datapath .. '/highscore-selected.png',
        leave = function()
            local bg = gfx.loadpng(datapath .. '/bg1280-720.png')
            screen:copyfrom(bg, nil)
            bg:destroy()
            gfx.update()
            return true
        end }

	options[3] = {title = "Multiplayer",
        action = function()
            sys.stop()
            return "Return Option3"
        end,
        hover = function()
            local bg = gfx.loadpng(datapath .. '/bg1280-720.png')
            screen:copyfrom(bg, nil)
            bg:destroy()
            return true
        end,
        button = datapath .. '/multi-normal.png',
        button_marked = datapath .. '/multi-selected.png',
        leave = function()
            return true
        end}
	
    options[4] = {title = "Exit",
        action = function()
            sys.stop()
            return "Return Option4"
        end,
        hover = function()
            local bg = gfx.loadpng(datapath .. '/bg1280-720.png')
            screen:copyfrom(bg, nil)
            bg:destroy()
            return true
        end,
        button = datapath .. '/exit-normal.png',
        button_marked = datapath .. '/exit-selected.png',
        leave = function()
            return true
        end}

    _G.mainMenu = Menu:new()
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
  
  subMenuContainer:clear({r=7, g = 19, b=77, a=60}, {x =screen:get_width()/20, y = screen:get_height()/20, w= screen:get_width() *0.9, h = screen:get_height()* 0.56 })
 
  return subMenuContainer
end


-- mainly show the highscore page
function showmenu.loadMenu(tag)
  
  --showmenu.writeWord("start", nil, 20, nil, subMenuContainer)

  --subMenu.containerPos = {x = 0, y = 0}
  --subMenu:printSub(subMenuContainer)
  -- use subMenuContainer as an arguments to your screen, and then show it
  subMenuContainer = showmenu.loadBackground()
  
  if(tag == "highScore") then
  
    highScoreMenu.loadMenu(subMenuContainer)
  elseif(tag == "singlePlayer") then
  
  elseif(tag == "multiplayer") then
  
  elseif(tag == "exit") then
  
  end
  subMenu:printSub(subMenuContainer)
  gfx.update()
  collectgarbage()
end

function showmenu.loadSecondaryMenu()
    o = {}
    o[1] = {title = "Game",
        action = function()
            --action
            activeView = "pacman"
            gamehandler.loadPacman()

            return "Start pacman"
        end,
        hover = function()
            return true
        end,
        button = datapath .. '/startgame.png',
        button_marked = datapath .. '/startgame-marked.png',
        leave = function()
            return true
        end}
        --[[
    o[2] = {title = "HighScore",
        action = function()
            -- action
            return "Return HighScore"
        end,
        hover = function()
           return true
        end,
        button = datapath .. '/highscore.png',
        button_marked = datapath .. '/startgame-marked.png',
        hover = function()
            return true
        end,
        leave = function()
            return true
        end}
    o[3] = {title = "Settings",
        action = function()
            -- action
            return "Return Option2"
        end,
        hover = function()
            return true
        end,
        button = datapath .. '/startgame.png',
        button_marked = datapath .. '/startgame-marked.png',
        leave = function()
            return true
        end}
        --]]
    _G.secondary = Menu:new()
    secondary:setOptions(o)

    secondaryMenuContainer = gfx.new_surface(880, 300)
    secondary.containerPos = {x = 200, y=120}
    secondaryMenuContainer:clear({g=0, r=0, b=255, a=20} )

    secondary:print(secondaryMenuContainer, 20, secondaryMenuContainer:get_height()/2, 40)
    gfx.update()
end

function showmenu.registerKey(key, state)
 -- Should be lifted out!
    if key == "left" then
        activeMenu:prev()
    elseif key == "right" then
        activeMenu:next()
    elseif key == "ok"  then
        activeMenu:action()
    elseif key == "up"  and mainMenu == activeMenu then
        activeMenu:action()
    elseif key == "down" and secondary == activeMenu then
        secondary:print(secondaryMenuContainer, 20, secondaryMenuContainer:get_height()/2, 40)
        activeMenu = mainMenu
        mainMenu:setActive(1)
    elseif key == "back" and mainMenu.active == 1 then
        activeMenu = mainMenu
    elseif key == "exit" then
        sys.stop()
    end
end

return showmenu