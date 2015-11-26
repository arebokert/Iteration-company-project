Boxes = require("model.games.2048.box")
InGameMenu = require("model.ingamemenu.ingamemenuclass")
Game = {current = 0}
menuView = nil

function Game.registerKey(key, state)
    if state == "down" then
      if menuView == "pauseMenu" then
        if key == "ok" then
          menuView = nil
          if menuoption == 0 then
            Game.showGamePage(1)
          elseif menuoption == 1 then
            -- Restart function has to be implemented
            Boxes.clear()
            Game.startGame()
          elseif menuoption == 2 then
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
          activeView = "menu"
          current_menu = "mainMenu"
          showmenu.loadMainMenu()
        elseif key == "ok" then
          InGameMenu.loadPauseMenu()
          menuView = "pauseMenu"
        end
      end
    end
    if current_menu =="2048_game_over" then
       if state == "down" then
          if key == "exit" then
	     current_menu = "mainmenu"
             activeView = "menu"
          end
       end
    end
end

-- 5px between each square
--128, 272,105
---{x=400,y=100,w = 537, h=537}
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

   screen2048:clear({r=245,g=245,b=245})
   screen2048:clear({r=0,g=205,b=204},centre_square)
   gfx.update()
   Boxes.init(each_square, box_start_x, box_start_y,flag)
end

function Game.startGame()
 Game.showGamePage(0)
 --Game.multiplayer()
end

return Game
