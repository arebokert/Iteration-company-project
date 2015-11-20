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
--local text_coords = {x =screen:get_width()*0.09, y= screen:get_height()*0.12}
local font_path = root_path.."views/mainmenu/data/font/Gidole-Regular.otf"
--local text_color = {r = 255, g = 255, b =255}
--local highScore_text = sys.new_freetype(text_color, text_size, text_coords, font_path)
local highScore_local_text_1 =sys.new_freetype({r=255,g=255,b=255},35,{x =screen:get_width()*0.09, y= screen:get_height()*0.12}, font_path)
local highScore_local_text_2 =sys.new_freetype({r=255,g=255,b=255},20,{x = screen:get_width()*0.09, y= screen:get_height()*0.2}, font_path)
local highScore_local_text_3 =sys.new_freetype({r=255,g=255,b=255},20,{x= screen:get_width()*0.09, y= screen:get_height()*0.24 + 1 *30}, font_path)
local highScore_local_text_4 =sys.new_freetype({r=255,g=255,b=255},20,{x= screen:get_width()*0.09, y= screen:get_height()*0.24 + 2 *30}, font_path)
local highScore_local_text_5 =sys.new_freetype({r=255,g=255,b=255},20,{x= screen:get_width()*0.09, y= screen:get_height()*0.24 + 3 *30}, font_path)
local highScore_local_text_6 =sys.new_freetype({r=255,g=255,b=255},20,{x= screen:get_width()*0.09, y= screen:get_height()*0.24 + 4 *30}, font_path)
local highScore_local_text_7 =sys.new_freetype({r=255,g=255,b=255},20,{x= screen:get_width()*0.09, y= screen:get_height()*0.24 + 5 *30}, font_path)

local highScore_local_text = {
  highScore_local_text_3,
  highScore_local_text_4,
  highScore_local_text_5,
  highScore_local_text_6,
  highScore_local_text_7
}

local highScore_global_text_1 =sys.new_freetype({r=255,g=255,b=255},35,{x =screen:get_width()*0.715, y= screen:get_height()*0.12}, font_path)
local highScore_global_text_2 =sys.new_freetype({r=255,g=255,b=255},20,{x = screen:get_width()*0.715, y= screen:get_height()*0.2}, font_path)
local highScore_global_text_3 =sys.new_freetype({r=255,g=255,b=255},20,{x= screen:get_width()*0.715, y= screen:get_height()*0.24 + 1 *30}, font_path)
local highScore_global_text_4 =sys.new_freetype({r=255,g=255,b=255},20,{x= screen:get_width()*0.715, y= screen:get_height()*0.24 + 2 *30}, font_path)
local highScore_global_text_5 =sys.new_freetype({r=255,g=255,b=255},20,{x= screen:get_width()*0.715, y= screen:get_height()*0.24 + 3 *30}, font_path)
local highScore_global_text_6 =sys.new_freetype({r=255,g=255,b=255},20,{x= screen:get_width()*0.715, y= screen:get_height()*0.24 + 4 *30}, font_path)
local highScore_global_text_7 =sys.new_freetype({r=255,g=255,b=255},20,{x= screen:get_width()*0.715, y= screen:get_height()*0.24 + 5 *30}, font_path)

local highScore_global_text = {
  highScore_global_text_3,
  highScore_global_text_4,
  highScore_global_text_5,
  highScore_global_text_6,
  highScore_global_text_7
}

--if falid, commit this line


--------------------------------------------------------------------
--function: loadMenu                                        --------
--@param Screen, the current submenu                        --------
--description: load the highScore menu of the application   --------
--last modified Nov 17, 2015                                --------
--------------------------------------------------------------------
function highScoreMenu.loadMenu()
  local highScoreSurface = gfx.new_surface(screen:get_width(),screen:get_height()*2.0/3.0)
  highScoreSurface:clear({r=7, g = 19, b=77, a=120}, {x =screen:get_width()*0.05, y = screen:get_height()*0.05, w= screen:get_width() *0.9, h = screen:get_height()* 0.55 })
   local scores = {}
  if(highScoreMenu.current_game == 1) then
    scores = highScoreMenu.loadScores("pacman", nil)
 elseif highScoreMenu.current_game == 2 then
    scores = highScoreMenu.loadScores("2048",nil)
 end
  highScoreMenu.loadLocalScore(highScoreSurface,scores)
  highScoreMenu.loadGlobalScore(highScoreSurface,scores)
  highScoreMenu.loadStatus(highScoreSurface)
  highScoreMenu.loadGameMenu(highScoreSurface)
  screen:copyfrom(highScoreSurface, nil)
  highScoreSurface:destroy()
  gfx.update()
  collectgarbage()
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
      elseif key == "right" then
        if highScoreMenu.current_game ~= highScoreMenu.total_games then
         highScoreMenu.current_game = highScoreMenu.current_game +1
        else 
         highScoreMenu.current_game = 1
        end
        highScoreMenu.loadMenu(highScoreMenu.current_screen)
      elseif key == "down" then
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
function highScoreMenu.writeWord(word, color, size, position, Screen)
  local word_freetype = sys.new_freetype(color, size, position,font_path)
  word_freetype:draw_over_surface(Screen,word)
end

--------------------------------------------------------------------
--function: loadLocalScore                                  --------
--@param: Screen, the menu of the highScoreMenu             --------
--@param: scored, scores is from the highScoreHandler       --------
--description: load local score of games                    --------
--last modified Nov 17, 2015                                --------
--------------------------------------------------------------------
function highScoreMenu.loadLocalScore(Screen,scores)
  local color = {r=255, g=255, b=255}
  local margin = 1
  local local_score = nil
  Screen:clear({r=7, g=19, b=77, a=240},{x =screen:get_width()*0.075, y= screen:get_height()*0.094, w= screen:get_width()*0.23,h=screen:get_height()*0.48})
  highScoreMenu.drawBorder(Screen,screen:get_width()*0.075,screen:get_height()*0.094, screen:get_width()*0.23,screen:get_height()*0.48, margin, color)
  --highScoreMenu.writeWord("Local HighScore",{r=255,g=255,b=255},24,{x =screen:get_width()*0.09, y= screen:get_height()*0.12},Screen)
  highScore_local_text_1:draw_over_surface(Screen,"Local HighScore")
  highScore_local_text_2:draw_over_surface(Screen,"PlayerName" .. " : " .. "Score")
  for k,v in pairs(scores) do
    ADLogger.trace(k .. ". " .. v.playerName .. " " .. v.score)
    highScore_local_text[k]:draw_over_surface(Screen,v.playerName .. " : " .. v.score)
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
function highScoreMenu.drawBorder(Screen, startX, startY, width, height, margin, color)
  Screen:clear(color, {x = startX, y = startY, w = width, h = margin})
  Screen:clear(color, {x = startX, y = startY, w = margin, h = height})
  Screen:clear(color, {x = startX, y = startY+height, w = width+margin, h = margin})
  Screen:clear(color, {x = startX+width, y = startY, w = margin, h = height+margin})
end

function highScoreMenu.loadGlobalScore(Screen,scores)
  local color = {r=255, g=255, b=255}
  local margin = 1
  Screen:clear({r=7, g=19, b=77, a=240},{x =screen:get_width()*0.7, y= screen:get_height()*0.094, w= screen:get_width()*0.23,h=screen:get_height()*0.48})
  highScoreMenu.drawBorder(Screen, screen:get_width()*0.7,screen:get_height()*0.094, screen:get_width()*0.23,screen:get_height()*0.48, margin, color)
  --highScoreMenu.writeWord("Global HighScore",{r=255,g=255,b=255},24,{x = screen:get_width()*0.715, y = screen:get_height()*0.12},Screen)
  --highScoreMenu.writeWord("PlayerName" .. " : " .. "Score",{r=255,g=255,b=255},20,{x = screen:get_width()*0.715, y= screen:get_height()*0.2},Screen)
  highScore_global_text_1:draw_over_surface(Screen,"Global HighScore")
  highScore_global_text_2:draw_over_surface(Screen,"PlayerName" .. " : " .. "Score")
  for k,v in pairs(scores) do
    ADLogger.trace(k .. ". " .. v.playerName .. " " .. v.score)
    --highScoreMenu.writeWord(v.playerName .. " : " .. v.score,{r=255,g=255,b=255},20,{x= screen:get_width()*0.715, y= screen:get_height()*0.24 + k *30},Screen)
    highScore_global_text[k]:draw_over_surface(Screen,v.playerName .. " : " .. v.score)
  end
end

function highScoreMenu.loadStatus(Screen)
  local color = {r=255, g=255, b=255}
  local margin = 1
  Screen:clear({r=7, g=19, b=77, a=240},{x =screen:get_width()*0.335, y= screen:get_height()*0.272, w= screen:get_width()*0.33,h=screen:get_height()*0.3})
  highScoreMenu.drawBorder(Screen, screen:get_width()*0.335, screen:get_height()*0.272,screen:get_width()*0.33, screen:get_height()*0.3, margin, color)
  highScoreMenu.writeWord("Status",{r=255,g=255,b=255},24,{x = screen:get_width()*0.375, y = screen:get_height()*0.30},Screen)
end

function highScoreMenu.loadGameMenu(Screen)
  local bg = gfx.loadpng(datapath .. '/menu-arrow-left.png')
  Screen:copyfrom(bg, nil, {x =screen:get_width()*0.32, y= screen:get_height()*0.13})
  bg:destroy()
  local bg = gfx.loadpng(datapath .. '/menu-arrow-right.png')
  Screen:copyfrom(bg, nil, {x =screen:get_width()*0.65, y= screen:get_height()*0.13})
  bg:destroy()
  local color = {r=255, g=255, b=255}
  local margin = 1
  Screen:clear({r=7, g=19, b=77, a=240},{x =screen:get_width()*0.38, y= screen:get_height()*0.11, w= screen:get_width()*0.25,h=screen:get_height()*0.10})
  highScoreMenu.drawBorder(Screen, screen:get_width()*0.38, screen:get_height()*0.11,screen:get_width()*0.25, screen:get_height()*0.10, margin, color)
  if(highScoreMenu.current_game == 1) then
    highScoreMenu.writeWord("PACMAN",{r=255,g=255,b=255},36,{x = screen:get_width()*0.45, y = screen:get_height()*0.12},Screen)
  elseif(highScoreMenu.current_game == 2) then
   highScoreMenu.writeWord("2048",{r=255,g=255,b=255},36,{x = screen:get_width()*0.45, y = screen:get_height()*0.12},Screen)
  end
end

-- if the highScoreMenu failed, repalce the code with the commited one, and commit on the code from local highScores = HighscoreHandler...... to return
function highScoreMenu.loadScores(GameName, scoreType)
  --if(scoreType =="global") then
  
  --elseif(scoreType == "local") then
  
  --end
  --ADLogger.trace(GameName)
  --local highScores = HighscoreHandler:new(GameName, 5, 1)   -- 1 means global
  --for k,v in pairs(highScores.highscoreTable) do
   -- ADLogger.trace(k .. ". " .. v.playerName .. " " .. v.score)
  --end
  --return highScores.highscoreTable
  local highScores = {};
    highScores.highscoreTable = {{playerName="abs",score=1000},{playerName="POX",score=1000},{playerName="aaaa",score=1020},{playerName="ggg",score=1300},{playerName="PeeeX",score=160}}
  return highScores.highscoreTable
end

return highScoreMenu

