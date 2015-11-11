-- The highscore object.
Highscore = {index = 0, playerName = "", score = 0}
Highscore.__index = Highscore

-- The constructor for the highscore-object
-- @param playerName - The playername associated with the score
-- @param score - The score
function Highscore:new (playerName, score)
  local self = setmetatable({}, self)
  self.playerName = playerName
  self.score = score
  return self
end