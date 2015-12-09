require "model/highscore/highscorehandler"

-- The score class. 
Score = {}


-- This is the local variables needed for the score function
local scoreCount = 0
local size = 20
local color = {r = 255, g = 255, b =255 }
local pos = {x=100,y=20}
local score_text = sys.new_freetype(color, size, pos, font_path)
local game = ""

-- This is a black box to cover the old score
local w = gfx.new_surface(1280, 58)
w:clear({r=0, g=0, b=0})

-- 
-- Update score when pacman collide with a score type
--
-- @param type: Yellowdot, cherries or powerpellets 
--
function Score.increaseScore(increment)
   scoreCount = scoreCount + increment
end

--
-- Prints the score on the screen
--
-- @param pos: The upper left corner where the score text is placed
--
function Score.printScore()
   word = "Score: " .. scoreCount
   screen:copyfrom(w,nil,{x=0, y=0})
   score_text:draw_over_surface(screen,word)
end

--
-- This function should be called when a user has won a game, or reached game over condition
-- The score is then saved in the database
-- If there is no internet connection, the highscore is not taken care of
-- 
function Score.submitHighScore()
   local playerID = "David"
   if hasInternet then
      local response = HighscoreHandler:submitGlobalHighscore(game, playerID, scoreCount) 
      dump(response)
   end 
end

-- TODO
-- This function should return the highscore of the game (globally)
-- @return: Highscore
function Score.retrieveHighscore()
  return
end

--
-- This is to set what game is active
-- @setgame: The game that's active
function Score.setGame(setgame)
  game = setgame
end

-- 
-- Return score
--
-- @return scoreCount: current score. 
--   
function Score.getScore()
    return scoreCount
end

--
-- Resets the score
--
function Score.resetScore()
  scoreCount = 0
end  

return Score