Boxes_multiplayer = require("model.games.2048.box_multiplayer")
Boxes_competitor = require("model.games.2048.box_competitor")
InGameMenu = require("model.commongame.ingamemenuclass")
Game_multiplayer = {current = 0}
menuView = nil

function Game_multiplayer.registerKey(key, state)
    if state == "down" then
      if menuView == "pauseMenu" then
        if key == "ok" then
          menuView = nil
          if menuoption == 0 then   -- resume
            Game_multiplayer.showGamePage(1)
            GameTimer_2048:stop()
          elseif menuoption == 1 then   --restart
            -- Restart function has to be implemented
            Boxes_multiplayer.clear()
            Game_multiplayer.startMultiGame()
            GameTimer_2048:stop()
          elseif menuoption == 2 then   --mainmenu
            activeView = "menu"
            current_menu = "mainMenu"
            Boxes_multiplayer.clear()
            showmenu.loadMainMenu()
          end
        else
            InGameMenu.changePausePos(key)
        end
      elseif menuView == nil then
        if key == "up" then   --move every number to top
          Boxes_multiplayer.moveTop()
        elseif key == "down" then
          Boxes_multiplayer.moveBottom()
        elseif key == "left" then
          Boxes_multiplayer.moveLeft()
        elseif key == "right" then
          Boxes_multiplayer.moveRight()
        elseif key == "exit" then
          activeView = "menu"
          current_menu = "mainMenu"
          GameTimer_2048:stop()
          showmenu.loadMainMenu()
        elseif key == "ok" then
          InGameMenu.loadPauseMenu()
          menuView = "pauseMenu"
          GameTimer_2048:stop()
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
function Game_multiplayer.showGamePage(flag)         --- if flag == 1 , resume
   left_screen = gfx.new_surface(screen:get_width()*0.5,screen:get_height())
   right_screen = gfx.new_surface(screen:get_width()*0.5,screen:get_height())
   Game_multiplayer.loadBoxes(left_screen)
   Game_multiplayer.loadComBoxes(right_screen)
   screen:copyfrom(left_screen,nil,{x=0,y=0})
   screen:clear({r=0,g=0,b=100},{x=screen:get_width()*0.5, y= 0, w= 2, h = screen:get_height()})
   screen:copyfrom(right_screen,nil,{x=screen:get_width()*0.5,y=0})
   gfx.update()
end

function Game_multiplayer.loadBoxes(temp_screen)
   screen_player = temp_screen
   local width_2048 = screen_player:get_width()
   local height_2048 = screen_player:get_height()
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
      centre_square = {x = width_2048*0.2, y = height_2048*0.5 - width_2048*0.3, w = width_2048 * 0.6, h = width_2048 * 0.6}
   end
   --local each_square = (height_2048 * 0.6 -25) *0.25
   --local centre_square = {x = width_2048*0.2, y = height_2048 * 0.1, w = width_2048 * 0.6, h = width_2048}
   screen_player:clear({r=245,g=245,b=245})
   screen_player:clear({r=0,g=205,b=204},centre_square)
   Boxes_multiplayer.init(each_square, box_start_x, box_start_y,0)
end

function Game_multiplayer.loadComBoxes(temp_screen)
   screen_competitor = temp_screen
   local width_2048 = screen_competitor:get_width()
   local height_2048 = screen_competitor:get_height()
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
      centre_square = {x = width_2048*0.2, y = height_2048*0.5 - width_2048*0.3, w = width_2048 * 0.6, h = width_2048 * 0.6}
   end
   --local each_square = (height_2048 * 0.6 -25) *0.25
   --local centre_square = {x = width_2048*0.2, y = height_2048 * 0.1, w = width_2048 * 0.6, h = width_2048}
   screen_competitor:clear({r=245,g=245,b=245})
   screen_competitor:clear({r=0,g=205,b=204},centre_square)
   Boxes_competitor.init(each_square, box_start_x, box_start_y,0)
end


function Game_multiplayer.sendData()

end

-- get the data from server and then change the data of box_table and current_score
local current_flag = 0
function Game_multiplayer.getData()
   Boxes_competitor.box_table[current_flag] = 2
   Boxes_competitor.current_score = 100
   current_flag = current_flag +1
end

function Game_multiplayer.queryTimer()
 GameTimer_2048 = sys.new_timer(1000, "callback_2048") -- starts a timer that calls function callback
 GameTimer_2048:start()
end

callback_2048 = function (timer)
  Game_multiplayer.getData()
  Boxes_competitor.refresh()
end

function Game_multiplayer.startMultiGame()
 Game_multiplayer.showGamePage(0)
 Game_multiplayer.queryTimer()
 --Game.multiplayer()
end

return Game_multiplayer
