-- The score class. 
-- Score = {}

local scoreCount = 0


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

-- 
-- Return score
--
-- @return: scoreCount, current score.  

function getScore()
    return scoreCount
end
