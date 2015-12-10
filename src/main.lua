ADConfig = require("Config.ADConfig")
ADLogger = require("SDK.Utils.ADLogger")
http = require("socket.http")
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
    root_path = sys.root_path().."/"
end

appsurface = require "appsurface"
showmenu = require "views.mainmenu.showmenu"
gamehandler = require "model.games.pacman.gamehandler"
game2048 = require "model.games.2048.game"

function onKey(key, state)
    
    ADLogger.trace("OnKey("..key..","..state..")")
    
    -- This statement is used when switching to the picture of the TV appSurface
    if key=="3" and state == "down" and (activeView=="pacman" or activeView == "menu") then 
      ADLogger.trace("TV-Screen loaded!")
      appSurface:destroy()
      highScoreMenu.resetRecursive()
      local bg = gfx.loadpng(datapath .. '/TV-PH-full.png')
     
      appSurface:copyfrom(bg, nil)
      bg:destroy()
      tvmode = true
      gfx.update()
      

      if activeView == "pacman" then
        if gameTimer then
          gameTimer:stop()
        end
        gameStatus = false
      end  
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
    ADLogger.trace("Closing TV-Screen!")
      if activeView == "menu" then
          --ADLogger.trace(activeView)
          current_menu = "singlePlayerMenu"
          --collectgarbage()
          --collectgarbage("stop")
          appSurface:destroy()  
          showmenu.loadMainMenu()
          --activeMenu = mainMenu
      elseif activeView == "pacman" then
          gameplan:reprintMap(Gamehandler.container)
          gameStatus = true
          if gameTimer then
            gameTimer:start()
          end  
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
  appSurface = appSurface:new()
  appSurface:createScreen()
  
  _G.activeView = "menu"
  ADLogger.trace("onStart")
  if ADConfig.isSimulator then
      if arg[#arg] == "-debug" then require("mobdebug").start() end
  end
  if ADConfig.isSimulator then
      if arg[#arg] == "-debug" then require("mobdebug").start() end
  end
  
  if http.request( "http://www.google.com" ) == nil then
    hasInternet=false
  elseif NH.hasConnection() then
    hasInternet=true
  else
    hasInternet=false
  end

    showmenu.loadMainMenu()
    
    _G.activeMenu = mainMenu
end


