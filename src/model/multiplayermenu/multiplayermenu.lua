multiModel = {title = "Multiplayer Menu"}
textpath = root_path.."model/games/"

-- function: new()
--@return obj - returns an instance of the multiplayermodel
function multiModel:new ()
    obj = {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end

-- function: setOptions()
-- Sets a table to a self-referenced variable.
-- Might be redundant.
-- 
-- @param options - table to be set
function multiModel:setOptions(options)
    self.options = options
    self.size = #options
end

-- function: getOptions()
-- Returns the options-table.
--
-- @return self.options
function multiModel:getOptions()
    return self.options
end

-- function: getSize()
-- Returns the length of a the options-table.
function multiModel:getSize()
    return #self.options
end

--Reads a textfile and creates a function which returns a 
--table with manually added lines of game-names/directories.
--@param resource - method created by asserting a textfile.
--@param gametable - stores the table created from calling "resource()"
function multiModel:fetchPath()
    local resource = assert(loadfile(textpath.."games.txt"))
    self.foldertable = resource()
    self:setOptions(self.foldertable)
    return self.foldertable    
end

-- function: fetchResults()
--Stub/dummy-method returning hardcoded information representing recent gamehistory to be printed.
--
--@param resultset - Contains strings for the multiplayerview.
function multiModel:fetchResults()
    resultset = {}
    
    resultset[1] = {
          score1 = "986 vs. 789", indicator1 = "w",
          score2 = "567 vs. 443", indicator2 = "w",
          score3 = "445 vs. 999", indicator3 = "l"
      }
    resultset[2] = {
          score1 = "334 vs. 445", indicator1 = "l",
          score2 = "887 vs. 765", indicator2 = "w",
          score3 = "489 vs. 282", indicator3 = "w"
      }
    resultset[3] = {
          score1 = "No history", indicator1 = "n",
          score2 = "No history", indicator2 = "n",
          score3 = "No history", indicator3 = "n"
      }
    
    return resultset
end

return multiModel