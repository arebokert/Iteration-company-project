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

showmenu = require "showmenu"

function onKey(key, state)
    ADLogger.trace("OnKey("..key..","..state..")")

    if key == "yellow" then
        ADLogger.trace("YELLOW BUTTON")
        mainMenu:setActive(2)
    end

    if key == "left" and state == "down" then
        activeMenu:prev()
    end
    if key == "right" and state == "down" then
        activeMenu:next()
    end
    if key == "ok" and state == "down" then
        activeMenu:action()
    end
    if key == "up" and state == "down" and mainMenu.active == 1 then
        activeMenu = secondary
    end
    if key == "down" and state == "down" and mainMenu.active == 1 then
        activeMenu = mainMenu
    end
    if key == "back" and state == "down" and mainMenu.active == 1 then
        activeMenu = mainMenu
    end
end

function onStart()

    ADLogger.trace("onStart")
    if ADConfig.isSimulator then
        if arg[#arg] == "-debug" then require("mobdebug").start() end
    end

    screen:clear({g=120, r=10, b=20})
    local bg = gfx.loadjpeg('data/bg1280-720.jpg')
    screen:copyfrom(bg, nil)
    bg:destroy()

    loadMainMenu()
    activeMenu = mainMenu
end



