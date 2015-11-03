local JSON = assert(loadfile "JSON.lua")()
require "highscore"

-- The highscore object
HighscoreHandler = {gameName = "", highscoreTable = {}}
HighscoreHandler.__index = HighscoreHandler

-- Constructor for the handler object
-- @param gameName - The name of the game
function HighscoreHandler:new(gameName)
  local self = setmetatable({}, self)
  self.gameName = gameName
  self.highscoreTable = loadHighscore(gameName)
  return self
end

-- Creates and inserts a new highscore-object to the highscoreTable of the playerName that has been typed in.
-- @param playerName - The playername associated with the score.
-- @param score - The score.
function HighscoreHandler:newEntry(playerName, score)

  local a = Highscore:new(playerName, score)
  insert(a, self)

end

-- Saves the array of highscores to the file, in JSON-format.
-- @param gameName - The game which the highscores belong to.
function HighscoreHandler:saveHighscore()

  -- The filename should be gamename + Highscore, e.g. "pacmanHighscore"
  local fileName = self.gameName.."Highscore"
  local f = io.open(fileName, "w")
  
  -- Encodes into JSON and writes to file
  f:write(JSON:encode(highscoreTable))

  f:close()
  
end

-- Loads a highscore-table from file, if it does not exist it returns an empty (new) table.
-- @param  gameName - The name of the game which highscore should be loaded.
-- @return highscoreTable - The table of highscores from file.
function loadHighscore(gameName)
  
  -- Filename is e.g. "pacmanHighscore"
  local fileName = gameName.."Highscore"
  
  -- If the file does not exists, nothing happens.
  local f = io.open(fileName, "r")
  if f ~= nil then
    rawJsonString = f:read()
    f:close()
  end

  -- If the file is not loaded, creates an empty table, otherwise it decodes the JSON-data to a table.
  if rawJsonString == nil then highscoreTable = {} else
    highscoreTable = JSON:decode(rawJsonString)
  end
  
  return highscoreTable
  
end

-- Inserts a highscore into highscoreTable, in descending order.
-- @param a - The highscore-object to be inserted.
function insert(a, o)

  if o.highscoreTable[1] == nil then
    o.highscoreTable[1] = a
  else

    local i = 1

    while o.highscoreTable[i].score > a.score do
      i = i + 1

      if(o.highscoreTable[i] == nil) then break end

    end

    table.insert(o.highscoreTable, i, a)

  end

end