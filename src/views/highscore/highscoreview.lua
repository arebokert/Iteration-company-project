require "model/highscore/highscorehandler"

-- The viewer object, contains a handler, size and position.
HighscoreViewer = {highscoreHandler = {}, width = 0, height = 0, posX = 0, posY = 0}
HighscoreViewer.__index = HighscoreViewer


-- Constructor for the viewer object.
-- @param gameName - The name of the game.
-- @param width - The width of the object, standard is 300px.
-- @param height - The height of the object, standard is 500px.
-- @param posX - The x-position of the object.
-- @param posY - The y-position of the object.
-- @param fullscreen - A bool deciding if the view is in fullscreen-mode (Not yet implemented!)
-- @return The object created.
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

-- Draws the viewer at the size and position decided when constructed. ATM only split-screen mode is available.
function HighscoreViewer:draw()
  fontPath = "/font/Gidole-Regular.otf"  
  -- Background
  screen:fill({r = 0, g = 20, b = 44}, {x = self.posX, y = self.posY, width = self.width, height = self.height})
  -- Text color
  color = {r = 255, g = 255, b = 255}

  if #self.highscoreHandler.highscoreTable == 3 then -- If fullscreen
    marginX = self.width / 15
    marginY = self.height / 4
    -- Margins is added to the position of the text.
    position = {x = self.posX + marginX, y = self.posY + marginY}
    -- Set the text-size
    size = self.height / 2
    
    score_text = sys.new_freetype(color, size, position, fontPath)
    score_text:draw_over_surface(screen, "High score:")
    
    for k,v in pairs(self.highscoreHandler.highscoreTable) do
      
      position = {x = position.x + (self.width / 4) - (marginX / 3), y = position.y}
      word = v.playerName.." : "..v.score
      score_text = sys.new_freetype(color, size, position, fontPath)
      score_text:draw_over_surface(screen, word)
      
    end
  else -- If split-screen
    -- Set the margin
    margin = 30
    
    -- Inside border
    screen:fill({r = 255, g = 255, b = 255}, {x = self.posX + margin, y = self.posY + 2*margin, width = self.width - 2*margin, height = self.height - 3*margin})
    screen:fill({r = 0, g = 20, b = 44}, {x = self.posX + margin + 2, y = self.posY + 2*margin + 2, width = self.width - 2*margin - 4, height = self.height - 3*margin - 4})
    -- Margins is added to the position of the text.
    position = {x = self.posX + margin + 5, y = self.posY + 2*margin + 5}
    -- Set the text-size according to the number of rows.
    size = ((self.height - 3*margin - 4) / #self.highscoreHandler.highscoreTable) - 1  
    highscoreText = sys.new_freetype(color, (size + (margin / 8)), {x = self.posX + margin, y = self.posY + (margin / 2)}, fontPath)
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