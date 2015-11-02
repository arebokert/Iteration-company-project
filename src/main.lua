ADConfig = require("Config.ADConfig")
ADLogger = require("SDK.Utils.ADLogger")
ADLogger.trace("Applicatio Init")

if ADConfig.isSimulator then
    gfx = require "SDK.Simulator.gfx"
    zto = require "SDK.Simulator.zto"
    surface = require "SDK.Simulator.surface"
    player = require "SDK.Simulator.player"
    freetype = require "SDK.Simulator.freetype"
    sys = require "SDK.Simulator.sys"
end

showmenu = require "views.mainmenu.showmenu"

function onKey(key, state)
    ADLogger.trace("OnKey("..key..","..state..")")

    if state == "down" or state == "repeat" then
        if key == "yellow" then
            ADLogger.trace("YELLOW BUTTON")
            mainMenu:setActive(2)
        end

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
end

function onStart()

    ADLogger.trace("onStart")
    if ADConfig.isSimulator then
        if arg[#arg] == "-debug" then require("mobdebug").start() end
    end

    screen:clear({g=120, r=10, b=20})
    local bg = gfx.loadpng('views/mainmenu/data/bg1280-720.png')
    screen:copyfrom(bg, nil)
    bg:destroy()

    showmenu.loadMainMenu()
    _G.activeMenu = mainMenu
end



