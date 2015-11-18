require "model/highscore/highscorehandler"

HighscoreViewer = {highscoreHandler = {}, width = 0, height = 0, posX = 0, posY = 0}
HighscoreViewer.__index = HighscoreViewer

function HighscoreViewer:new(gameName, width, height, posX, posY, fullscreen)
  local self = setmetatable({}, self)
  self.width = width or 300
  self.height = height or 500
  if fullscreen then numberOfHighscores = 3 else numberOfHighscores = 10 end
  self.highscoreHandler = HighscoreHandler:new(gameName, numberOfHighscores)
  self.posX = posX or 0
  self.posY = posY or 0
  return self
end

function HighscoreViewer:draw()
  screen:fill({r = 0, g = 20, b = 44}, {x = self.posX, y = self.posY, width = self.width, height = self.height})
  -- Indside border
  screen:fill({r = 255, g = 255, b = 255}, {x = self.posX + 25, y = self.posY + 50, width = self.width - 50, height = self.height - 75})
  screen:fill({r = 0, g = 20, b = 44}, {x = self.posX + 30, y = self.posY + 55, width = self.width - 60, height = self.height - 85})
  
  
  
  fontPath = "/font/Gidole-Regular.otf"
  color = {r = 255, g = 255, b = 255}
  position = {x = self.posX + 35, y = self.posY + 60}
  if numberOfHigscores == 3 then 
    size = self.height - 10

    score_text = sys.new_freetype(color, size, position, font_path)
    score_text:draw_over_surface(screen, word)
    
    for k,v in pairs(self.highscoreHandler.highscoreTable) do
      
      position = {x = position.x + (screen:get_width() / 4), y = position.y}
      word = v.playerName.." "..v.score
      score_text = sys.new_freetype(color, size, position, font_path)
      score_text:draw_over_surface(screen, word)
      
    end
  else
    size = ((self.height - 85) / #self.highscoreHandler.highscoreTable) - 1  
    print(size)
    highscoreText = sys.new_freetype(color, 30, {x = self.posX + 25, y = self.posY + 10}, fontPath)
    highscoreText:draw_over_surface(screen, "High score")
        
    for k,v in pairs(self.highscoreHandler.highscoreTable) do
  
      nameText = sys.new_freetype(color, size, position, fontPath)
      scoreText = sys.new_freetype(color, size, {x = self.posX + (self.width / 2), y = position.y}, fontPath)
      nameText:draw_over_surface(screen, v.playerName)
      scoreText:draw_over_surface(screen, v.score)
      
      position = {x = position.x, y = position.y + size}
      
    end
  end
  gfx.update()
  
end