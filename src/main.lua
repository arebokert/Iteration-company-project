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
    root_path = sys.root_path().."/"
end

showmenu = require "views.mainmenu.showmenu"
gamehandler = require "model.games.pacman.gamehandler"
game2048 = require "model.games.2048.game"

function onKey(key, state)
    
    ADLogger.trace("OnKey("..key..","..state..")")
    
      -- This statement is used when switching to the picture of the TV screen
    if key=="3" and state == "down" then 
      --collectgarbage()
      --collectgarbage("stop")
      --
      if current_menu == "singlePlayerMenu" then
        ab.destroy()
      end
      local tvSurface = gfx.new_surface(screen:get_width(),screen:get_height())
      local bg = gfx.loadpng(datapath .. '/TV-PH-full.png')
      tvSurface:copyfrom(bg)
      bg:destroy()
      
      screen:copyfrom(tvSurface, nil)
      tvmode = true
      gfx.update()
      
      --collectgarbage()
      if activeView == "pacman" then
        gamehandler.pacmanOnKey("pause")
      end
      collectgarbage("stop")
    end
    
    if state == "down" or state == "repeat" then
        if activeView == "menu" then
           showmenu.mainMenuKeyEvents(key, state)
        elseif activeView == "pacman" then
            if gamehandler.pacmanOnKey(key) == false then
                activeView = "menu"
                current_menu = "singlePlayerMenu"
                showmenu.loadMainMenu()
                activeMenu = mainMenu
            end
        elseif activeView == "2048" then
          game2048.registerKey(key,state)
        elseif activeView =="multiplayer2048" then
          game2048_multiplayer.registerKey(key,state)
        end
    end
    
             --This statement is used when going back to either menu or pacman
    if tvmode == true and key=="4" then
      if activeView == "menu" then
          --ADLogger.trace(activeView)
          current_menu = "singlePlayerMenu"
          --collectgarbage()
          --collectgarbage("stop")
            
          showmenu.loadMainMenu()
          activeMenu = mainMenu
        elseif activeView == "pacman" then
          gamehandler.loadPacman()
        else
          --collectgarbage()
          --collectgarbage("stop")
          current_menu = "singlePlayerMenu"
          showmenu.loadMainMenu()
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
 --[[ if http.request( "http://www.google.com" ) == nil then
    hasInternet=false
  else
    hasInternet=true
  end]]
    --ADLogger.trace("Memory limit: " .. gfx.get_memory_limit())
    showmenu.loadMainMenu()
    
    _G.activeMenu = mainMenu
end


