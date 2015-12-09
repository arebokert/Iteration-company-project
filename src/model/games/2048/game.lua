--------------------------------------------------------------------
--class: game                                               --------
--description: start class of game(2048)                    --------
--last modified Nov 22, 2015                                --------
--------------------------------------------------------------------
Boxes = require("model.games.2048.box")
InGameMenu = require("model.commongame.ingamemenuclass")
Score = require("model.commongame.scorehandler")
Game = {current = 0}
menuView = nil

--------------------------------------------------------------------
--function: registerKey                                     --------
--description: key functions                                --------
--last modified Nov 22, 2015                                --------
--------------------------------------------------------------------
function Game.registerKey(key, state)
    if state == "down" then
      if menuView == "pauseMenu" then
        if key == "ok" then
          menuView = nil
          if menuoption == 0 then
            Game.showGamePage(1)
          elseif menuoption == 1 then
            -- Restart function has to be implemented
            Score.resetScore()
            Boxes.clear()
            Game.startGame()
          elseif menuoption == 2 then
            Score.resetScore()
            activeView = "menu"
            current_menu = "mainMenu"
            Boxes.clear()
            showmenu.loadMainMenu()
          end
        else
            InGameMenu.changePausePos(key)
        end
      elseif menuView == nil then
        if key == "up" then   --move every number to top
          Boxes.moveTop()
        elseif key == "down" then
          Boxes.moveBottom()
        elseif key == "left" then
          Boxes.moveLeft()
        elseif key == "right" then
          Boxes.moveRight()
        elseif key == "exit" then
          Score.resetScore()
          activeView = "menu"
          current_menu = "mainMenu"
          Boxes.clear()
          showmenu.loadMainMenu()
        elseif key == "ok" then
          InGameMenu.loadPauseMenu()
          menuView = "pauseMenu"
        end
     elseif menuView == "2048_game_over" then 
       if key == "exit" then
          current_menu = "mainmenu"
          activeView = "menu"
          menuView = nil
          Score.resetScore()
           Boxes.clear()
          showmenu.loadMainMenu()
       else 
          ADLogger.trace("still in game over")
       end
     end
    end
end

-- 5px between each square
--128, 272,105
---{x=400,y=100,w = 537, h=537}
--------------------------------------------------------------------
--function: showGamePage                                    --------
--@param flag if flag == 1 resume                           --------
--description: show Game function,define position           --------
--last modified Nov 22, 2015                                --------
--------------------------------------------------------------------
function Game.showGamePage(flag)         --- if flag == 1 , resume
   screen2048 = screen
   local width_2048 = screen2048:get_width()
   local height_2048 = screen2048:get_height()
   local default_each_squre = 128
   local each_square = 0
   local box_start_x = 0
   local box_start_y = 0
   local centre_square = {}
   if width_2048 > height_2048 then
      each_square = (height_2048 * 0.6 -25) *0.25
      box_start_x  = width_2048*0.5 - height_2048 * 0.3 - each_square
      box_start_y = height_2048*0.2 +5
      centre_square = {x = width_2048*0.5 - height_2048 * 0.3, y = height_2048 * 0.2, w = height_2048 * 0.6, h = height_2048*0.6}
   else
      each_square = (width_2048 * 0.6 -25) *0.25
      box_start_x  = width_2048*0.2 - each_square
      box_start_y = height_2048*0.5 - width_2048*0.3 + 5
      centre_square = {x = width_2048*0.2, height_2048*0.5 - width_2048*0.3, w = width_2048 * 0.6, h = width_2048 * 0.6}
   end
   --local each_square = (height_2048 * 0.6 -25) *0.25
   --local centre_square = {x = width_2048*0.2, y = height_2048 * 0.1, w = width_2048 * 0.6, h = width_2048}

  -- screen2048:clear({r=245,g=245,b=245})
  local bg = gfx.loadjpeg('views/pacman/data/pacmanbg.jpg')
  screen2048:copyfrom(bg, nil)
  bg:destroy()
  screen2048:clear({r=118, g=18, b=36},centre_square)
  gfx.update()
  Boxes.init(each_square, box_start_x, box_start_y,flag)
end

function Game.startGame()
 Game.showGamePage(0)
 Score.setGame("4096")
 --Game.multiplayer()
end

return Game
