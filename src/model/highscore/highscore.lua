-- The highscore object.
Highscore = {playerName = "", score = 0}
Highscore.__index = Highscore

-- The constructor for the highscore-object
-- @param playerName - The playername associated with the score
-- @param score - The score
-- @return Highscore - The object created
function Highscore:new (playerName, score)
  local self = setmetatable({}, self)
  self.playerName = playerName
  self.score = score
  return self
end