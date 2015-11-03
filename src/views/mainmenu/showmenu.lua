showmenu = {}
Menu = require "model/mainmenu/menuclass"
datapath = "views/mainmenu/data"

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
            rect = gfx.new_surface(200, 200)
            rect:clear( {g=0, r=255, b=0} )
            rectPos = {x = 500, y=100}
            screen:copyfrom(rect, nil, rectPos)
            collectgarbage()
            return true
        end,
        button =datapath..'/highscore-normal.png',
        button_marked = datapath .. '/highscore-selected.png',
        leave = function()
            return true
        end }

    options[3] = {title = "Exit",
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
    o[2] = {title = "Settings",
        action = function()
            -- action
            return "Return Option2"
        end,
        button = datapath .. '/startgame.png',
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
    o[4] = {title = "Settings",
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
    o[5] = {title = "Settings",
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

return showmenu
