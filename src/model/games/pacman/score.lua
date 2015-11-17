-- The score class. 
-- Score = {}

local scoreCount = 0


-- This is a black box to cover the old score
local w = gfx.new_surface(100, 30)
w:clear({r=0, g=0, b=0})


-- 
-- Update score when pacman collide with a score type
--
-- @type: Yellowdot, cherries or powerpellets 
function countScore(type)
    if type == "yellowdot" then
      scoreCount = scoreCount + 10
    end
end

--This function prints the score on the screen
--@pos: The upper left corner where the score text is placed
function printScore(pos)

   size = 20
   color = {r = 255, g = 255, b =255}
   word = "Score: " .. scoreCount
   screen:copyfrom(w,nil,pos)
   score_text = sys.new_freetype(color, size, pos, font_path)
   score_text:draw_over_surface(screen,word)

end

-- 
-- Return score
--
-- @return: scoreCount, current score.  
function getScore()
    return scoreCount
end

-- Resets the score
function resetScore()
  scoreCount = 0
end  
