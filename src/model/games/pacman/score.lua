-- The score class. 
Score = {}


-- This is the local variables needed for the pacman score function
local scoreCount = 0
local size = 20
local color = {r = 255, g = 255, b =255 }
local pos = {x=100,y=20}
local score_text = sys.new_freetype(color, size, pos, font_path)

-- This is a black box to cover the old score
local w = gfx.new_surface(100, 30)
w:clear({r=0, g=0, b=0})


-- 
-- Update score when pacman collide with a score type
--
-- @type: Yellowdot, cherries or powerpellets 
function Score.countScore(type)
    if type == "yellowdot" then
      scoreCount = scoreCount + 10
    end
end

--This function prints the score on the screen
--@pos: The upper left corner where the score text is placed
function Score.printScore(pos)
   word = "Score: " .. scoreCount
   screen:copyfrom(w,nil,pos)
   score_text:draw_over_surface(screen,word)
end

-- 
-- Return score
--
-- @return: scoreCount, current score.  
function Score.getScore()
    return scoreCount
end

-- Resets the score
function Score.resetScore()
  scoreCount = 0
end  

return Score