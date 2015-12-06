-- This has caused some problems. If this causes your problem to crash, remove the "model/highscore" on below 2 rows
local JSON = assert(loadfile(root_path.."JSON.lua"))()
require "model/highscore/highscore"
local NETWORK = assert(loadfile("network/NetworkHandler.lua"))()


-- The highscore object, highscoretable is the number of "active" highscores and fullHighscoreTable is all the highscores. 
HighscoreHandler = {gameName = "", highscoreTable = {}, fullHighscoreTable = {}}
HighscoreHandler.__index = HighscoreHandler

-- Constructor for the handler object.
-- @param gameName - The name of the game.
-- @param numberOfHighscores - The number of highscores to be fetched. Standard is 10.
-- @param global - A bool to fetch global highscores.
function HighscoreHandler:new(gameName, numberOfHighscores, global)
  numberOfHighscores = numberOfHighscores or 10
  local self = setmetatable({}, self)
  self.gameName = gameName
  if global then
    self.highscoreTable = getGlobalHighscore(gameName, numberOfHighscores)
  else
    --self.highscoreTable = getOwnGlobalHighscore(gameName, numberOfHighscores)
    self.fullHighscoreTable = loadHighscore(gameName)
    if #fullHighscoreTable < numberOfHighscores then numberOfHighscores = #fullHighscoreTable end
    self.highscoreTable = {unpack(fullHighscoreTable, 1, numberOfHighscores)}
  end
  return self
end

-- Creates and inserts a new highscore-object to the highscoreTable of the playerID that has been typed in.
-- @param playerID - The playerID associated with the score.
-- @param score - The score.
function HighscoreHandler:newEntry(playerID, score)
  
  local a = Highscore:new(playerID, score)
  insert(a, self)
  submitGlobalHighscore(playerID, score)

end

-- Creates and inserts a new highscore-object in to the global highscore list
-- @param playerID - The playerID associated with the score.
-- @param score - The score.
-- @return JSON - Returns server respons in a JSON object
function HighscoreHandler:submitGlobalHighscore(gameName, playerID, score)
  local macAddress = "00-00-00-00-00-00-00-E0" -- Temporary hardcoded mac address
  
  local request = JSON:encode({
    macAddress = macAddress,
    gameName = gameName,
    playerID = playerID,
    score = score
  })
  
  return NETWORK:sendJSON(request, "SendScore") -- Temporary send code
  
end

-- Gets global highscore from the server
-- @param gameName - The name of the game.
-- @param numberOfHighscores - The number of highscores to be fetched. Standard is 10.
-- @return Returns global highscore in a JSON object 
function HighscoreHandler:getGlobalHighscore(gameName, numberOfHighscores)
  local macAddress = "00-00-00-00-00-00-00-E0" -- Temporary hardcoded mac address
  
  local request = JSON:encode({
    gameName = gameName,
    numberOfHighscores = numberOfHighscores
  })
  
  return NETWORK:sendJSON(request, "RequestReadGlobalScore")
  
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

-- Loads a highscore-table globally from the server, if there are no
-- highscores for the current box, it returns an empty (new) table.
-- @param  gameName - The name of the game which highscore should be loaded.
-- @return fullHighscoreTable - The table of highscores from the server.
function loadHighscore(gameName)
  local macAddress = "00-00-00-00-00-00-00-E0" -- Temporary hardcoded mac address
  
  -- Filename is e.g. "pacmanHighscore"
  --local fileName = "model/highscore/"..gameName.."Highscore"
  
  -- If the file does not exists, nothing happens.
  --local f = io.open(fileName, "r")
  --if f ~= nil then
  --  rawJsonString = f:read()
  --  f:close()
  --end

  -- If the file is not loaded, creates an empty table, otherwise it decodes the JSON-data to a table.
  local request = JSON:encode({
    gameName = gameName,
    macAddress = macAddress,
  })
  rawJsonString = sendJSON(request, 'RequestReadYourOwnScore')
  if rawJsonString == 'Nothing received.' then fullHighscoreTable = {} else
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