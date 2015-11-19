multiModel = {title = "Multiplayer Menu"}
textpath = root_path.."model/games/"

--Constructor
--@return obj - returns an instance of the multiplayermenu
function multiModel:new ()
    obj = {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function multiModel:setOptions(options)
    self.options = options
    self.size = #options
end

function multiModel:getOptions()
    return self.options
end

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

--Experiment function that might or might not work on the box.
--Attempts to count folder in a directory (using terminal commands).
--Note: Discarded.
function multiModel:countFolders(folder)
    for folderName in io.popen([[ls -a "model/games/" /b /ad]]):lines() do 
    foldertable[folderName] = "model/games/"..folderName.."/resources/" end
    
    return foldertable
    --Testing for Windows:
    --for folderName in io.popen([[dir "src/" /b /ad]]):lines() do print(folderName) end
end

--Returning dummy information until a database/server-connection can be secured.
--@param dummy - Contains strings for the multiplayerview.
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