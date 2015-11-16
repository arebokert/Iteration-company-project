-- The score class. 
-- Score = {}

local scoreCount = 0



local w = gfx.new_surface(100, 30)
w:clear({r=0, g=0, b=0})


-- 
-- Update score when pacman collide with a score type
--
-- @type: Yellowdot, cherries or powerpellets 
function countScore(type)
    if type == "yellowdot" then
      scoreCount = scoreCount + 10
       ADLogger.trace("SCORE:")
      ADLogger.trace(scoreCount)
    end
end

function printScore()

   font_path = root_path.."views/mainmenu/data/font/Gidole-Regular.otf"
   size = 20
   color = {r = 255, g = 255, b =255}
   word = "Score: " .. scoreCount
   screen:copyfrom(w,nil,{x=100, y=20})
   score_text = sys.new_freetype(color, size, {x=100, y=20},font_path)
   score_text:draw_over_surface(screen,word)

end

-- 
-- Return score
--
-- @return: scoreCount, current score.  

function getScore()
    return scoreCount
end
