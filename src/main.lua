ADConfig = require("Config.ADConfig")
ADLogger = require("SDK.Utils.ADLogger")
http = require("socket.http")
ADLogger.trace("Applicatio Init")
hasInternet=true
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
<<<<<<< HEAD
    root_path = sys.root_path().."/"
=======
    root_path = sys.root_path() .. "/"
>>>>>>> abc55551dab34cff5aade0bef795141e9e6b70cc
end

showmenu = require "views.mainmenu.showmenu"
gamehandler = require "model.games.pacman.gamehandler"
game2048 = require "model.games.2048.game"

function onKey(key, state)
    ADLogger.trace("OnKey("..key..","..state..")")
    if state == "down" or state == "repeat" then
        if activeView == "menu" then
           showmenu.mainMenuKeyEvents(key, state)
        elseif activeView == "pacman" then
            if gamehandler.pacmanOnKey(key) == false then
                activeView = "menu"
                current_menu = "singlerPlayerMenu"
                showmenu.loadMainMenu()
                activeMenu = mainMenu
            end
        elseif activeView == "2048" then
          game2048.registerKey(key,state)
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
	if ADConfig.isSimulator then
        if arg[#arg] == "-debug" then require("mobdebug").start() end
    end
	--[[if http.request( "http://www.google.com" ) == nil then
		hasInternet=false
	else
		hasInternet=true
	end]]
    showmenu.loadMainMenu()
    _G.activeMenu = mainMenu
end


