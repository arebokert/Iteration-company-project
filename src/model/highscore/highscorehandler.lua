-- This has caused some problems. If this causes your problem to crash, remove the "model/highscore" on below 2 rows
local JSON = assert(loadfile "model/highscore/JSON.lua")()
require "model/highscore/highscore"

-- The highscore object, highscoretable is the number of "active" highscores and fullHighscoreTable is all the highscores. 
HighscoreHandler = {gameName = "", highscoreTable = {}, fullHighscoreTable = {}}
HighscoreHandler.__index = HighscoreHandler

-- Constructor for the handler object.
-- @param gameName - The name of the game.
-- @param global - A bool to fetch global highscores.
-- @param numberOfHighscores - The number of highscores to be fetched. Standard is 10.
function HighscoreHandler:new(gameName, numberOfHighscores, global)
  numberOfHighscores = numberOfHighscores or 10
  local self = setmetatable({}, self)
  self.gameName = gameName
  if global then
    -- TODO: Add global highscore fetch.
  else
    self.fullHighscoreTable = loadHighscore(gameName)
    if #fullHighscoreTable < numberOfHighscores then numberOfHighscores = #fullHighscoreTable end
    self.highscoreTable = {unpack(fullHighscoreTable, 1, numberOfHighscores)}
  end
  return self
end

-- Creates and inserts a new highscore-object to the highscoreTable of the playerName that has been typed in.
-- @param playerName - The playername associated with the score.
-- @param score - The score.
function HighscoreHandler:newEntry(playerName, score)
  
  local a = Highscore:new(playerName, score)
  insert(a, self)
  submitGlobalHighscore(playerName, score)

end

-- Creates and inserts a new highscore-object in to the global highscore list
-- @param playerName - The playername associated with the score.
-- @param score - The score.
function submitGlobalHighscore(playerName, score)
  local macAddress = "00-00-00-00-00-00-00-E0" -- Temporary hardcoded mac address
  
  local newHighscore = JSON:encode({
    macAddress = macAddress,
    gameName = self.gameName,
    playerName = playerName,
    score = score
  })
  
  NetworkHandler:sendJSON(newHighscore, "sendcode") -- Temporary send code
end

function HighscoreHandler:retrieveOwnGlobalHighscore()
  local macAddress = "00-00-00-00-00-00-00-E0" -- Temporary hardcoded mac address
  --TODO
  --Implement extraction and return of json object to lua table.
end

-- Saves the array of highscores to the file, in JSON-format.
-- @param gameName - The game which the highscores belong to.
function HighscoreHandler:saveHighscore()

  -- The filename should be gamename + Highscore, e.g. "pacmanHighscore"
  local fileName = "model/highscore/"..self.gameName.."Highscore"
  local f = io.open(fileName, "w")
  
  -- Encodes into JSON and writes to file
  f:write(JSON:encode(fullHighscoreTable))

  f:close()
  
end

-- Loads a highscore-table from file, if it does not exist it returns an empty (new) table.
-- @param  gameName - The name of the game which highscore should be loaded.
-- @return fullHighscoreTable - The table of highscores from file.
function loadHighscore(gameName)
  
  -- Filename is e.g. "pacmanHighscore"
  local fileName = "model/highscore/"..gameName.."Highscore"
  
  -- If the file does not exists, nothing happens.
  local f = io.open(fileName, "r")
  if f ~= nil then
    rawJsonString = f:read()
    f:close()
  end

  -- If the file is not loaded, creates an empty table, otherwise it decodes the JSON-data to a table.
  if rawJsonString == nil then fullHighscoreTable = {} else
    fullHighscoreTable = JSON:decode(rawJsonString)
  end
  
  return fullHighscoreTable
  
end

-- Inserts a highscore into highscoreTable, in descending order.
-- @param a - The highscore-object to be inserted.
function insert(a, o)

  if o.fullHighscoreTable[1] == nil then
    o.fullHighscoreTable[1] = a
  else

    local i = 1

    while o.fullHighscoreTable[i].score > a.score do
      i = i + 1

      if(o.fullHighscoreTable[i] == nil) then break end

    end

    table.insert(o.fullHighscoreTable, i, a)
    o.highscoreTable = {unpack(o.fullHighscoreTable, 1, #o.highscoreTable)}

  end

end

return HighscoreHandler