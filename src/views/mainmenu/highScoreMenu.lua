local highScoreMenu = {
  curren_game = 1, 
  current_menu = "highScoreMenu",
  total_games = {
     "pacman",
     "2048"
  }
}

require("model.highscore.highscorehandler")

function highScoreMenu.loadMenu(Screen)
  --activeView = "highScoreMenu"
  highScoreMenu.loadLocalScore(Screen)
  highScoreMenu.loadGlobalScore(Screen)
  highScoreMenu.loadStatus(Screen)
  highScoreMenu.loadGameMenu(Screen)
  return Screen
end


-- key register for different key press
function highScoreMenu.registerKey(key, state)
      if key == "left" then
        highScoreMenu.curren_game = (highScoreMenu.curren_game -1 + table.getn(highScoreMenu.total_games)) % table.getn(highScoreMenu.total_games)
      elseif key == "right" then
        highScoreMenu.curren_game = (highScoreMenu.curren_game +1) % table.getn(highScoreMenu.total_games)
      elseif key == "down" then
        activeMenu = mainMenu
        mainMenu:setActive(1)
        activeView = "menu"
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

function highScoreMenu.loadLocalScore(Screen)
  scores = highScoreMenu.loadScores("pacman", nil)
  color = {r=20, g=10, b=0}
  margin = 5
  highScoreMenu.drawBorder(Screen, 70, 120, 200, 300, margin, color)
  highScoreMenu.writeWord("Local HighScore",{r=100,g=0,b=0},20,{x=80, y= 130},Screen)
  highScoreMenu.writeWord("PlayerName" .. " : " .. "Score",{r=226,g=228,b=240},20,{x=80, y= 170},Screen)
  for k,v in pairs(scores) do
    ADLogger.trace(k .. ". " .. v.playerName .. " " .. v.score)
    highScoreMenu.writeWord(v.playerName .. " : " .. v.score,{r=226,g=228,b=240},20,{x=80, y= 200 + k *30},Screen)
  end
  
end

function highScoreMenu.drawBorder(Screen, startX, startY, width, height, margin, color)
  Screen:clear(color, {x = startX, y = startY, w = width, h = margin})
  Screen:clear(color, {x = startX, y = startY, w = margin, h = height})
  Screen:clear(color, {x = startX, y = startY+height, w = width+margin, h = margin})
  Screen:clear(color, {x = startX+width, y = startY, w = margin, h = height+margin})
end

function highScoreMenu.loadGlobalScore(Screen)
  color = {r=20, g=10, b=0}
  margin = 5
  highScoreMenu.drawBorder(Screen, 870, 120, 200, 300, margin, color)
  highScoreMenu.writeWord("Global HighScore",{r=100,g=0,b=0},20,{x=880, y= 130},Screen)
  highScoreMenu.writeWord("PlayerName" .. " : " .. "Score",{r=226,g=228,b=240},20,{x=880, y= 170},Screen)
  for k,v in pairs(scores) do
    ADLogger.trace(k .. ". " .. v.playerName .. " " .. v.score)
    highScoreMenu.writeWord(v.playerName .. " : " .. v.score,{r=226,g=228,b=240},20,{x=880, y= 200 + k *30},Screen)
  end
end

function highScoreMenu.loadStatus(Screen)
  color = {r=20, g=10, b=0}
  margin = 5
  highScoreMenu.drawBorder(Screen, 400, 270, 400, 150, margin, color)
  highScoreMenu.writeWord("Status",{r=100,g=0,b=0},20,{x=450, y= 280},Screen)
end

function highScoreMenu.loadGameMenu(Screen)
  color = {r=20, g=10, b=0}
  margin = 5
  highScoreMenu.drawBorder(Screen, 400, 120, 400, 100, margin, color)
  highScoreMenu.writeWord("Pacman",{r=100,g=0,b=0},20,{x=460, y= 150},Screen)
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

