ADConfig = require("Config.ADConfig")
ADLogger = require("SDK.Utils.ADLogger")
ADLogger.trace("Applicatio Init")

root_path = ""
if ADConfig.isSimulator then
    gfx = require "SDK.Simulator.gfx"
    zto = require "SDK.Simulator.zto"
    surface = require "SDK.Simulator.surface"
    player = require "SDK.Simulator.player"
    freetype = require "SDK.Simulator.freetype"
    sys = require "SDK.Simulator.sys"
    root_path = ""
else
    root_path = sys.root_path()
end

showmenu = require "views.mainmenu.showmenu"
gamehandler = require "model.pacman.gamehandler"

function onKey(key, state)
    ADLogger.trace("OnKey("..key..","..state..")")

    if state == "down" or state == "repeat" then
        if _G.activeView == "menu" then
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

        elseif _G.activeView == "pacman" then
            if gamehandler.pacmanOnKey(key,state) == false then
                _G.activeView = "menu"
                showmenu.loadMainMenu()
                _G.activeMenu = mainMenu
            end
        end
    end
end


function onStart()

    -- Set which state that's possible. Global variable
    _G.activeView = "menu"

    ADLogger.trace("onStart")
    if ADConfig.isSimulator then
        if arg[#arg] == "-debug" then require("mobdebug").start() end
    end

    --gamehandler.loadPacman()
    showmenu.loadMainMenu()
    _G.activeMenu = mainMenu
end


