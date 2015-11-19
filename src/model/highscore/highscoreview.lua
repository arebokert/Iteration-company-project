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
  -- Background
  screen:fill({r = 0, g = 20, b = 44}, {x = self.posX, y = self.posY, width = self.width, height = self.height})
  -- Inside border
  screen:fill({r = 255, g = 255, b = 255}, {x = self.posX + 25, y = self.posY + 50, width = self.width - 50, height = self.height - 75})
  screen:fill({r = 0, g = 20, b = 44}, {x = self.posX + 30, y = self.posY + 55, width = self.width - 60, height = self.height - 85})
  
  
  
  fontPath = "/font/Gidole-Regular.otf"
  -- Text color
  color = {r = 255, g = 255, b = 255}
  -- Margins is added to the position of the text.
  position = {x = self.posX + 35, y = self.posY + 60}
  if numberOfHigscores == 3 then -- If fullscreen
    -- TODO: Implement the full-screen mode!
    --[[size = self.height - 10

    score_text = sys.new_freetype(color, size, position, font_path)
    score_text:draw_over_surface(screen, word)
    
    for k,v in pairs(self.highscoreHandler.highscoreTable) do
      
      position = {x = position.x + (screen:get_width() / 4), y = position.y}
      word = v.playerName.." "..v.score
      score_text = sys.new_freetype(color, size, position, font_path)
      score_text:draw_over_surface(screen, word)
      
    end]]
  else -- If split-screen
    -- Set the text-size according to the number of rows.
    size = ((self.height - 85) / #self.highscoreHandler.highscoreTable) - 1  
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