showmenu = {}
function showmenu.loadMainMenu()
    options = {}
    options[1] = {title = "Game",
        action = function()
            loadSecondaryMenu()
            activeMenu = secondary
            gfx.update()
            return "Return Option1"
        end,
        hover = function()
            local bg = gfx.loadjpeg('data/bg1280-720.jpg')
            screen:copyfrom(bg, nil)
            bg:destroy()
            --loadSecondaryMenu()
            gfx.update()
        end,
        leave = function()
            local bg = gfx.loadjpeg('data/bg1280-720.jpg')
            screen:copyfrom(bg, nil)
            bg:destroy()
            gfx.update()
            return true
        end}
    options[2] = {title = "Settings",
        action = function()
            rect = gfx.new_surface(200, 200)
            rect:clear( {g=0, r=255, b=0} )
            rectPos = {x = 500, y=100}
            screen:copyfrom(rect, nil, rectPos)
            gfx.update()
            return "Return Option2"
        end,
        hover = function()
            screen:clear({g=100, r=0, b=0})
            gfx.update()
        end,
        leave = function()
            return true
        end}
    options[3] = {title = "Settings",
        action = function()
            rect = gfx.new_surface(200, 200)
            rect:clear( {g=255, r=0, b=0} )
            rectPos = {x = 500, y=100}
            screen:copyfrom(rect, nil, rectPos)
            gfx.update()
            return "Return Option3"
        end,
        hover = function()
            screen:clear({g=0, r=0, b=140})
            gfx.update()
        end,
        leave = function()
            return true
        end}
    options[4] = {title = "Account",
        action = function()
            rect = gfx.new_surface(200, 200)
            rect:clear( {g=0, r=0, b=0} )
            rectPos = {x = 500, y=100}
            screen:copyfrom(rect, nil, rectPos)
            gfx.update()
            return "Return Option4"
        end,
        hover = function()
            screen:clear({g=0, r=100, b=0})
            gfx.update()
        end,
        leave = function()
            return true
        end}

    mainMenu = Menu:new()
    mainMenu:setOptions(options)

    mainMenuContainer = gfx.new_surface(1280, 220)
    mainMenuContainer:clear( {g=50, r=50, b=50} )

    mainMenu.containerPos = {x = 0, y=500}

    mainMenu:print(mainMenuContainer, 140, 60, 120)

    mainMenu:setActive(1)

    gfx.update()
end

function loadSecondaryMenu()
    o = {}
    o[1] = {title = "Game",
        action = function()
            -- action
            return "Return Option1"
        end,
        hover = function()
            return true
        end,
        leave = function()
            return true
        end}
    o[2] = {title = "Settings",
        action = function()
            -- action
            return "Return Option2"
        end,
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
        leave = function()
            return true
        end}
    secondary = Menu:new()
    secondary:setOptions(o)

    secondaryMenuContainer = gfx.new_surface(880, 300)
    secondary.containerPos = {x = 200, y=120}
    secondaryMenuContainer:clear({g=40, r=40, b=40} )

    secondary:print(secondaryMenuContainer, 20, 80, 40)
    secondary:setActive(1)
    gfx.update()
end
