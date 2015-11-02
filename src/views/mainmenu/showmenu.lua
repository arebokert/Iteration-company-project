showmenu = {}
Menu = require "model/mainmenu/menuclass"
datapath = "views/mainmenu/data"

function showmenu.loadMainMenu()
    options = {}
    options[1] = {title = "Game",
        action = function()
            mainMenu:print(mainMenuContainer, mainMenuContainer:get_height()/2, 60, 120)
            activeMenu = secondary
            secondary:setActive(1)
            gfx.update()
            return "Return Option1"
        end,
        hover = function()
            local bg = gfx.loadjpeg(datapath .. '/bg1280-720.jpg')
            screen:copyfrom(bg, nil)
            bg:destroy()
            mainMenu:print(mainMenuContainer, mainMenuContainer:get_height()/2, 60, 120)
            showmenu.loadSecondaryMenu()
            gfx.update()
        end,
        button = gfx.loadjpeg(datapath .. '/Games-normal.png'),
        button_marked = gfx.loadjpeg(datapath .. '/Games-selected.png'),
        leave = function()
            local bg = gfx.loadjpeg(datapath .. '/bg1280-720.png')
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
            local bg = gfx.loadjpeg(datapath .. '/bg1280-720.jpg')
            screen:copyfrom(bg, nil)
            bg:destroy()
            mainMenu:print(mainMenuContainer, mainMenuContainer:get_height()/2, 60, 120)
            rect = gfx.new_surface(200, 200)
            rect:clear( {g=0, r=255, b=0} )
            rectPos = {x = 500, y=100}
            screen:copyfrom(rect, nil, rectPos)
            gfx.update()
        end,
        button = gfx.loadjpeg(datapath .. '/Highscore-normal.png'),
        button_marked = gfx.loadjpeg(datapath .. '/Highscore-selected.png'),
        leave = function()
            return true
        end }

    options[3] = {title = "Exit",
        action = function()
            sys.stop()
            return "Return Option3"
        end,
        hover = function()
             local bg = gfx.loadjpeg(datapath .. '/bg1280-720.jpg')
            screen:copyfrom(bg, nil)
            bg:destroy()
            mainMenu:print(mainMenuContainer, mainMenuContainer:get_height()/2, 60, 120)
            gfx.update()
        end,
        button = gfx.loadjpeg(datapath .. '/Exit-normal.png'),
        button_marked = gfx.loadjpeg(datapath .. '/Exit-selected.png'),
        leave = function()
            return true
        end}
    

    
    mainMenu = Menu:new()
    mainMenu:setOptions(options)

    mainMenuContainer = gfx.new_surface(screen:get_width(), screen:get_height()/3.0)
    mainMenuContainer:clear( {g=0, r=0, b=255, a=25} )

    mainMenu.containerPos = {x = 0, y=screen:get_height()-mainMenuContainer:get_height()}
    mainMenu:print(mainMenuContainer, mainMenuContainer:get_height()/2, 60, 120)
    mainMenu:setActive(1)

    gfx.update()
end

function showmenu.loadSecondaryMenu()
    o = {}
    o[1] = {title = "Game",
        action = function()
            -- action
            return "Return Option1"
        end,
        hover = function()
            return true
        end,
        button = gfx.loadjpeg(datapath .. '/startgame.jpg'),
        button_marked = gfx.loadjpeg(datapath .. '/startgame-marked.jpg'),
        leave = function()
            return true
        end}
    o[2] = {title = "Settings",
        action = function()
            -- action
            return "Return Option2"
        end,
        button = gfx.loadjpeg(datapath .. '/startgame.jpg'),
        button_marked = gfx.loadjpeg(datapath .. '/startgame-marked.jpg'),
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
        button = gfx.loadjpeg(datapath .. '/startgame.jpg'),
        button_marked = gfx.loadjpeg(datapath .. '/startgame-marked.jpg'),
        leave = function()
            return true
        end}
    o[4] = {title = "Settings",
        action = function()
            -- action
            return "Return Option2"
        end,
        hover = function()
            return true
        end,
        button = gfx.loadjpeg(datapath .. '/startgame.jpg'),
        button_marked = gfx.loadjpeg(datapath .. '/startgame-marked.jpg'),
        leave = function()
            return true
        end}
    o[5] = {title = "Settings",
        action = function()
            -- action
            return "Return Option2"
        end,
        hover = function()
            return true
        end,
        button = gfx.loadjpeg(datapath .. '/startgame.jpg'),
        button_marked = gfx.loadjpeg(datapath .. '/startgame-marked.jpg'),
        leave = function()
            return true
        end}
    secondary = Menu:new()
    secondary:setOptions(o)

    secondaryMenuContainer = gfx.new_surface(880, 300)
    secondary.containerPos = {x = 200, y=120}
    secondaryMenuContainer:clear({g=0, r=0, b=255, a=20} )

    secondary:print(secondaryMenuContainer, 20, secondaryMenuContainer:get_height()/2, 40)
    gfx.update()
end

return showmenu
