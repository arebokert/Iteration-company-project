local JSON = assert(loadfile(root_path .. "model/highscore/JSON.lua"))()

--------------------------------------------------------------------
--class: highScoreMenu                                      --------
--description: load the submenu highScoreMenu of the application ---
--last modified Nov 17, 2015                                --------
--------------------------------------------------------------------
--require("model.highscore.highscorehandler")

highScoreMenu = {
  current_game = 1,         -- the number is the index of the total_games
  total_games = 2
}

--local text_size = 35
--local text_coords = {x =appSurface:get_width()*0.09, y= appSurface:get_height()*0.12}
local font_path = root_path.."views/mainmenu/data/font/Gidole-Regular.otf"
--local text_color = {r = 255, g = 255, b =255}
--local highScore_text = sys.new_freetype(text_color, text_size, text_coords, font_path)
local highScore_local_text_1 =sys.new_freetype({r=255,g=255,b=255},35,{x =appSurface:get_width()*0.09, y= appSurface:get_height()*0.12}, font_path)
local highScore_local_text_2 =sys.new_freetype({r=255,g=255,b=255},20,{x = appSurface:get_width()*0.09, y= appSurface:get_height()*0.2}, font_path)
local highScore_local_text_3 =sys.new_freetype({r=255,g=255,b=255},20,{x= appSurface:get_width()*0.09, y= appSurface:get_height()*0.24 + 1 *30}, font_path)
local highScore_local_text_4 =sys.new_freetype({r=255,g=255,b=255},20,{x= appSurface:get_width()*0.09, y= appSurface:get_height()*0.24 + 2 *30}, font_path)
local highScore_local_text_5 =sys.new_freetype({r=255,g=255,b=255},20,{x= appSurface:get_width()*0.09, y= appSurface:get_height()*0.24 + 3 *30}, font_path)
local highScore_local_text_6 =sys.new_freetype({r=255,g=255,b=255},20,{x= appSurface:get_width()*0.09, y= appSurface:get_height()*0.24 + 4 *30}, font_path)
local highScore_local_text_7 =sys.new_freetype({r=255,g=255,b=255},20,{x= appSurface:get_width()*0.09, y= appSurface:get_height()*0.24 + 5 *30}, font_path)

highScoreSurface = nil
local recursive_calls = 0

local highScore_local_text = {
  highScore_local_text_3,
  highScore_local_text_4,
  highScore_local_text_5,
  highScore_local_text_6,
  highScore_local_text_7
}

local highScore_global_text_1 =sys.new_freetype({r=255,g=255,b=255},35,{x =appSurface:get_width()*0.715, y= appSurface:get_height()*0.12}, font_path)
local highScore_global_text_2 =sys.new_freetype({r=255,g=255,b=255},20,{x = appSurface:get_width()*0.715, y= appSurface:get_height()*0.2}, font_path)
local highScore_global_text_3 =sys.new_freetype({r=255,g=255,b=255},20,{x= appSurface:get_width()*0.715, y= appSurface:get_height()*0.24 + 1 *30}, font_path)
local highScore_global_text_4 =sys.new_freetype({r=255,g=255,b=255},20,{x= appSurface:get_width()*0.715, y= appSurface:get_height()*0.24 + 2 *30}, font_path)
local highScore_global_text_5 =sys.new_freetype({r=255,g=255,b=255},20,{x= appSurface:get_width()*0.715, y= appSurface:get_height()*0.24 + 3 *30}, font_path)
local highScore_global_text_6 =sys.new_freetype({r=255,g=255,b=255},20,{x= appSurface:get_width()*0.715, y= appSurface:get_height()*0.24 + 4 *30}, font_path)
local highScore_global_text_7 =sys.new_freetype({r=255,g=255,b=255},20,{x= appSurface:get_width()*0.715, y= appSurface:get_height()*0.24 + 5 *30}, font_path)

local highScore_global_text = {
  highScore_global_text_3,
  highScore_global_text_4,
  highScore_global_text_5,
  highScore_global_text_6,
  highScore_global_text_7
}


--------------------------------------------------------------------
--function: loadMenu                                        --------
--@param Screen, the current submenu                        --------
--description: load the highScore menu of the application   --------
--last modified Nov 17, 2015                                --------
--------------------------------------------------------------------
function highScoreMenu.loadMenu()
  if recursive_calls == 0 then
  highScoreSurface = gfx.new_surface(appSurface:get_width(),appSurface:get_height()*2.0/3.0)
  highScoreSurface:clear({r=7, g = 19, b=77, a = 50}, {x =appSurface:get_width()*0.05, y = appSurface:get_height()*0.05, w= appSurface:get_width() *0.9, h = appSurface:get_height()* 0.55 })
  else
  highScoreSurface:clear()
  end
  
  local scores = {}
  if(highScoreMenu.current_game == 1) then
    scores = highScoreMenu.loadScores("Pacman", nil)
 elseif highScoreMenu.current_game == 2 then
    scores = highScoreMenu.loadScores("4096",nil)
 end
  highScoreMenu.loadLocalScore(scores)
  highScoreMenu.loadGlobalScore(scores)
  highScoreMenu.loadStatus()
  highScoreMenu.loadGameMenu()
  appSurface:copyfrom(highScoreSurface, nil)
  gfx.update()
end

--------------------------------------------------------------------
--function: registerKey                                     --------
--@param: key    the key pressed(left,right,up,down,ok)     --------
--@param: state  the state of keypress(up,down, repeat)     --------
--description: key functions of highScoreMenu               --------
--last modified Nov 17, 2015                                --------
--------------------------------------------------------------------
function highScoreMenu.registerKey(key, state)
      if key == "left" then
        if highScoreMenu.current_game ~= 1 then
          highScoreMenu.current_game = highScoreMenu.current_game  -1 
        else 
          highScoreMenu.current_game = highScoreMenu.total_games
        end
        recursive_calls = 1
        highScoreMenu.loadMenu(highScoreMenu.current_screen)
      elseif key == "right" then
        if highScoreMenu.current_game ~= highScoreMenu.total_games then
         highScoreMenu.current_game = highScoreMenu.current_game +1
        else 
         highScoreMenu.current_game = 1
        end
        recursive_calls = 1
        highScoreMenu.loadMenu(highScoreMenu.current_screen)
      elseif key == "down" then
        recursive_calls = 0
        current_menu = "mainMenu"
      elseif key =="exit" then
        current_menu = "mainMenu"
      end
end

--------------------------------------------------------------------
--function: writeWord                                       --------
--@param: word, the text you want to write                  --------
--@param: color, the text color you defined                 --------
--@param: size, the text size you defined                   --------
--@param: position, the text position you defined           --------
--@param: Screen, the Screen you want to write              --------
--description: write word on the setbox                     --------
--last modified Nov 17, 2015                                --------
--------------------------------------------------------------------
function highScoreMenu.writeWord(word, color, size, position)
  local word_freetype = sys.new_freetype(color, size, position,font_path)
  word_freetype:draw_over_surface(highScoreSurface, word)
end

--------------------------------------------------------------------
--function: loadLocalScore                                  --------
--@param: Screen, the menu of the highScoreMenu             --------
--@param: scored, scores is from the highScoreHandler       --------
--description: load local score of games                    --------
--last modified Nov 17, 2015                                --------
--------------------------------------------------------------------
function highScoreMenu.loadLocalScore(scores)
  local color = {r=255, g=255, b=255}
  local margin = 1
  local local_score = nil
  highScoreSurface:clear({r=7, g=19, b=77, a=240},{x =appSurface:get_width()*0.075, y= appSurface:get_height()*0.094, w= appSurface:get_width()*0.23,h=appSurface:get_height()*0.48})
  highScoreMenu.drawBorder(appSurface:get_width()*0.075,appSurface:get_height()*0.094, appSurface:get_width()*0.23,appSurface:get_height()*0.48, margin, color)
  --highScoreMenu.writeWord("Local HighScore",{r=255,g=255,b=255},24,{x =appSurface:get_width()*0.09, y= appSurface:get_height()*0.12},Screen)
  highScore_local_text_1:draw_over_surface(highScoreSurface,"My HighScore")
  highScore_local_text_2:draw_over_surface(highScoreSurface,"PlayerName" .. " : " .. "Score")
  for k,v in pairs(scores) do
    ADLogger.trace(k .. ". " .. v.user_id .. " " .. v.score)
    highScore_local_text[k]:draw_over_surface(highScoreSurface,v.user_id .. " : " .. v.score)
  end 
end
--------------------------------------------------------------------
--function: drawBorder                                       --------
--@param: Screen, the Screen you want to draw                --------
--@param: startX, the start ponit                --------
--@param: startY, the text size you defined                   --------
--@param: width, the text position you defined              --------
--@param: height, the Screen you want to write              --------
--@param: margin, the Screen you want to write              --------
--@param: color, the Screen you want to write               --------
--description: draw border of the rectangle on the setbox   --------
--last modified Nov 17, 2015                                --------
--------------------------------------------------------------------
function highScoreMenu.drawBorder(startX, startY, width, height, margin, color)
  highScoreSurface:clear({r=255, g=255, b=255}, {x = startX, y = startY, w = width, h = margin})
  highScoreSurface:clear({r=255, g=255, b=255}, {x = startX, y = startY, w = margin, h = height})
  highScoreSurface:clear({r=255, g=255, b=255}, {x = startX, y = startY+height, w = width+margin, h = margin})
  highScoreSurface:clear({r=255, g=255, b=255}, {x = startX+width, y = startY, w = margin, h = height+margin})
end

--------------------------------------------------------------------
--function: loadGlobalScore                                 --------
--@param Screen, the current submenu                        --------
--@param scores, table of username and score                --------
--description: load the golbal score menu of the application--------
--last modified Nov 17, 2015                                --------
--------------------------------------------------------------------
function highScoreMenu.loadGlobalScore(scores)
  local color = {r=255, g=255, b=255}
  local margin = 1
  highScoreSurface:clear({r=7, g=19, b=77, a=240}, {x = appSurface:get_width()*0.7, y = appSurface:get_height()*0.094, w = appSurface:get_width()*0.23,h =appSurface:get_height()*0.48})
  highScoreMenu.drawBorder(appSurface:get_width()*0.7,appSurface:get_height()*0.094, appSurface:get_width()*0.23,appSurface:get_height()*0.48, margin, color)
  --highScoreMenu.writeWord("Global HighScore",{r=255,g=255,b=255},24,{x = appSurface:get_width()*0.715, y = appSurface:get_height()*0.12},Screen)
  --highScoreMenu.writeWord("PlayerName" .. " : " .. "Score",{r=255,g=255,b=255},20,{x = appSurface:get_width()*0.715, y= appSurface:get_height()*0.2},Screen)
  highScore_global_text_1:draw_over_surface(highScoreSurface,"Global HighScore")
  highScore_global_text_2:draw_over_surface(highScoreSurface,"PlayerName" .. " : " .. "Score")
  for k,v in pairs(scores) do
    ADLogger.trace(k .. ". " .. v.user_id .. " " .. v.score)
    --highScoreMenu.writeWord(v.playerName .. " : " .. v.score,{r=255,g=255,b=255},20,{x= appSurface:get_width()*0.715, y= appSurface:get_height()*0.24 + k *30},Screen)
    highScore_global_text[k]:draw_over_surface(highScoreSurface,v.user_id .. " : " .. v.score)
  end
end


--------------------------------------------------------------------
--function: loadStatus                                      --------
--description: load the status  menu of the application     --------
--last modified Nov 17, 2015                                --------
--------------------------------------------------------------------
function highScoreMenu.loadStatus()
  local color = {r=255, g=255, b=255}
  local margin = 1
  highScoreSurface:clear({r=7, g=19, b=77, a=240},{x =appSurface:get_width()*0.335, y= appSurface:get_height()*0.272, w= appSurface:get_width()*0.33,h=appSurface:get_height()*0.3})
  highScoreMenu.drawBorder(appSurface:get_width()*0.335, appSurface:get_height()*0.272,appSurface:get_width()*0.33, appSurface:get_height()*0.3, margin, color)
  highScoreMenu.writeWord("Status",{r=255,g=255,b=255},24,{x = appSurface:get_width()*0.375, y = appSurface:get_height()*0.30})
end

--------------------------------------------------------------------
--function: loadGameMenu                                    --------
--description: load the game  menu of the application       --------
--last modified Nov 17, 2015                                --------
--------------------------------------------------------------------
function highScoreMenu.loadGameMenu()
  local bg = gfx.loadpng(datapath .. '/menu-arrow-left.png')
  highScoreSurface:copyfrom(bg, nil, {x =appSurface:get_width()*0.32, y= appSurface:get_height()*0.13})
  bg:destroy()
  local bg = gfx.loadpng(datapath .. '/menu-arrow-right.png')
  highScoreSurface:copyfrom(bg, nil, {x =appSurface:get_width()*0.65, y= appSurface:get_height()*0.13})
  bg:destroy()
  local color = {r=255, g=255, b=255}
  local margin = 1
  highScoreSurface:clear({r=7, g=19, b=77, a=240},{x =appSurface:get_width()*0.38, y= appSurface:get_height()*0.11, w= appSurface:get_width()*0.25,h=appSurface:get_height()*0.10})
  highScoreMenu.drawBorder(appSurface:get_width()*0.38, appSurface:get_height()*0.11,appSurface:get_width()*0.25, appSurface:get_height()*0.10, margin, color)
  if(highScoreMenu.current_game == 1) then
    highScoreMenu.writeWord("MunchingMartin",{r=255,g=255,b=255},36,{x = appSurface:get_width()*0.42, y = appSurface:get_height()*0.13})
  elseif(highScoreMenu.current_game == 2) then
   highScoreMenu.writeWord("4096",{r=255,g=255,b=255},36,{x = appSurface:get_width()*0.47, y = appSurface:get_height()*0.13})
  end
end

--------------------------------------------------------------------
--function: loadScores                                      --------
--description: load the scores from highscorehandler        --------
--last modified Nov 17, 2015                                --------
--------------------------------------------------------------------
-- if the highScoreMenu failed, repalce the code with the commited one, and commit on the code from local highScores = HighscoreHandler...... to return
function highScoreMenu.loadScores(GameName, scoreType)
 
  local highScores = {}
  highScores.highscoreTable = JSON:decode(HighscoreHandler:getGlobalHighscore(GameName, 5))
  return highScores.highscoreTable
end

function highScoreMenu.resetRecursive()
    recursive_calls = 0
end

return highScoreMenu

