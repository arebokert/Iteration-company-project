Boxes_multiplayer = require("model.games.2048.box_multiplayer")
Boxes_competitor = require("model.games.2048.box_competitor")
InGameMenu = require("model.commongame.ingamemenuclass")
nh = require("network.NetworkHandler")
local JSON = assert(loadfile(root_path.."model/highscore/JSON.lua"))()

Game_multiplayer = {current = 0}
menuView = nil

local call = false
PLAYER_UPDATE = 1
PLAYER_QUIT = 2
PLAYER_SAME = 3
PLAYER_LOSE = 4

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


--------------------------------------------------------------------
--function: sendUpdatedBox
--@param sendFlag - Player status flag to be sent.
--@return - Answer from server.
--description: Will send data to server.
--last modified Dec 03, 2015
--------------------------------------------------------------------
function Game_multiplayer.sendUpdatedBox(sendFlag)
  local mac = nh.getMAC()
  local id = 1
  local localSendFlag = sendFlag
  local request = JSON:encode({
    flag = localSendFlag,
    mac = mac,
    playerid = id,
    box = Boxes_multiplayer.box_table,
    score = Boxes_multiplayer.current_score
    })
  return nh.sendJSON(JObj, "4096MultiPlayerSubmit")
end


--------------------------------------------------------------------
--function: getCompetitorData
--@return - Returns the opponents flag, box_table and score as a 
--  JSON object.
--description: Request opponent data from server.
--last modified Dec 03, 2015
--------------------------------------------------------------------
function Game_multiplayer.getCompetitorData()
  local mac = nh.getMAC()
  local id = 1
  local request = JSON:encode({
    mac = mac,
    playerid = id
    })
  return nh.sendJSON(JObj, "4096MultiPlayerRequest")
  -- TODO: Add timeout function for server request.
end


--------------------------------------------------------------------
--function: setCompetitorData
--@param JSONObject - Data in JSON object form.
--@return - True if game continues. False if game needs to end.
--description: Update data for competitor with received data.
--last modified Dec 03, 2015
--------------------------------------------------------------------
function Game_multiplayer.setCompetitorData(JSONObject)
  jo = JSON:decode(JSONObject)

  -- Check flag status
  if jo.flag == PLAYER_UPDATE then
    -- Update competitors box.
    Boxes_competitor.box_table = jo.box
    Boxes_competitor.current_score = jo.score
  elseif jo.flag == PLAYER_QUIT then
    -- Other player quit the game. End game.
    return false

  elseif jo.flag == PLAYER_SAME then
    -- Other player won. Continue playing until full box.
    Boxes_competitor.box_table = jo.box
    Boxes_competitor.current_score = jo.score
    -- TODO: Maybe change color of competitors box?
    return true

  elseif jo.flag == PLAYER_LOSE then
    -- Other player lost. Continue playing until full box.
    Boxes_competitor.box_table = jo.box
    Boxes_competitor.current_score = jo.score
    -- TODO: Maybe change color of competitors box?
    return true
  end
  return true  
end

--------------------------------------------------------------------
--function: queryTimer
--@return - 
--description: Starts a timer that calls function callback
--last modified Dec 03, 2015
--------------------------------------------------------------------
function Game_multiplayer.queryTimer()
 GameTimer_2048 = sys.new_timer(1000, "callback_2048") 
 GameTimer_2048:start()
end

-- Callback function used to get competitor data.
callback_2048 = function (timer)
  ADLogger.trace(getMemoryUsage("ram"))
  -- Request opponent data from server.
  ADLogger.trace(tostring(call))
  if call then
    return
  end
  call = true
  ADLogger.trace(tostring(call))
  local competitor_Json = Game_multiplayer.getCompetitorData()
  -- TODO: Do not allow more than 1 request at the same time. Server 
  --  might be slow at times, but multible requests should not be sent.

  -- Use data recovered.
  Game_multiplayer.setCompetitorData(competitor_Json)
  -- TODO: Add if statement. If return value ofprevious call is 
  --  false, game should end.

  -- Refresh competitor side of GUI.
  Boxes_competitor.refresh()
  call = false
end

function Game_multiplayer.startMultiGame()
 Game_multiplayer.showGamePage(0)
 Game_multiplayer.queryTimer()
 --Game.multiplayer()
end

return Game_multiplayer
