local highScoreMenu = {
  current_screen = nil,
  current_game = 1, 
  total_games = {
     "pacman",
     "2048"
  }
}

require("model.highscore.highscorehandler")

function highScoreMenu.loadMenu(Screen)
  highScoreMenu.current_screen = Screen
  highScoreMenu.loadLocalScore(Screen)
  highScoreMenu.loadGlobalScore(Screen)
  highScoreMenu.loadStatus(Screen)
  highScoreMenu.loadGameMenu(Screen)
  return Screen
end

-- key register for different key press
function highScoreMenu.registerKey(key, state)
  if current_menu == "highScoreMenu" then
      if key == "left" then
      if highScoreMenu.current_game ~= 1 then
       highScoreMenu.current_game = highScoreMenu.current_game  -1 
      else 
       highScoreMenu.current_game = table.getn(highScoreMenu.total_games)
      end
      elseif key == "right" then
        if highScoreMenu.current_game ~= table.getn(highScoreMenu.total_games) then
         highScoreMenu.current_game = highScoreMenu.current_game +1
        else 
         highScoreMenu.current_game = 1
        end
      elseif key == "down" then
        current_menu = "mainMenu"
      end
  end
end

function highScoreMenu.writeWord(word, color, size, position, Screen)
  ADLogger.trace(root_path)
  font_path = "views/mainmenu/data/font/Gidole-Regular.otf"
  ADLogger.trace(font_path)
  size = size or 50
  color = color or {r = 100, g = 0, b =100}
  word = word or  "hello world" 
  ADLogger.trace(size)
  start_btn = sys.new_freetype(color, size, position,font_path)
  start_btn:draw_over_surface(Screen,word)
end

function highScoreMenu.loadLocalScore(Screen, scores)
  local scores = highScoreMenu.loadScores("pacman", nil)
  local color = {r=255, g=255, b=255}
  local margin = 1
  Screen:clear({r=7, g=19, b=77, a=240},{x =screen:get_width()*0.075, y= screen:get_height()*0.094, w= screen:get_width()*0.23,h=screen:get_height()*0.48})
  highScoreMenu.drawBorder(Screen,screen:get_width()*0.075,screen:get_height()*0.094, screen:get_width()*0.23,screen:get_height()*0.48, margin, color)
  highScoreMenu.writeWord("Local HighScore",{r=255,g=255,b=255},24,{x =screen:get_width()*0.09, y= screen:get_height()*0.12},Screen)
  highScoreMenu.writeWord("PlayerName" .. " : " .. "Score",{r=255,g=255,b=255},20,{x = screen:get_width()*0.09, y= screen:get_height()*0.2},Screen)
  for k,v in pairs(scores) do
    ADLogger.trace(k .. ". " .. v.playerName .. " " .. v.score)
    highScoreMenu.writeWord(v.playerName .. " : " .. v.score,{r=255,g=255,b=255},20,{x= screen:get_width()*0.09, y= screen:get_height()*0.24 + k *30},Screen)
  end
  
end

function highScoreMenu.drawBorder(Screen, startX, startY, width, height, margin, color)
  Screen:clear(color, {x = startX, y = startY, w = width, h = margin})
  Screen:clear(color, {x = startX, y = startY, w = margin, h = height})
  Screen:clear(color, {x = startX, y = startY+height, w = width+margin, h = margin})
  Screen:clear(color, {x = startX+width, y = startY, w = margin, h = height+margin})
end

function highScoreMenu.loadGlobalScore(Screen)
  local scores = highScoreMenu.loadScores("pacman", nil)
  local color = {r=255, g=255, b=255}
  local margin = 1
  Screen:clear({r=7, g=19, b=77, a=240},{x =screen:get_width()*0.7, y= screen:get_height()*0.094, w= screen:get_width()*0.23,h=screen:get_height()*0.48})
  highScoreMenu.drawBorder(Screen, screen:get_width()*0.7,screen:get_height()*0.094, screen:get_width()*0.23,screen:get_height()*0.48, margin, color)
  highScoreMenu.writeWord("Global HighScore",{r=255,g=255,b=255},24,{x = screen:get_width()*0.715, y = screen:get_height()*0.12},Screen)
  highScoreMenu.writeWord("PlayerName" .. " : " .. "Score",{r=255,g=255,b=255},20,{x = screen:get_width()*0.715, y= screen:get_height()*0.2},Screen)
  for k,v in pairs(scores) do
    ADLogger.trace(k .. ". " .. v.playerName .. " " .. v.score)
    highScoreMenu.writeWord(v.playerName .. " : " .. v.score,{r=255,g=255,b=255},20,{x= screen:get_width()*0.715, y= screen:get_height()*0.24 + k *30},Screen)
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
  highScoreMenu.writeWord("PACMAN",{r=255,g=255,b=255},36,{x = screen:get_width()*0.45, y = screen:get_height()*0.12},Screen)
end

function highScoreMenu.loadScores(GameName, scoreType)
  if(scoreType =="global") then
  
  elseif(scoreType == "local") then
  
  end
  highScores = HighscoreHandler:new(GameName, 5)   -- 1 means global
--  for k,v in pairs(PacmanHighscore.highscoreTable) do
--    ADLogger.trace(k .. ". " .. v.playerName .. " " .. v.score)
--  end
  return highScores.highscoreTable
end

return highScoreMenu

