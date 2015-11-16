multiModel = {title = "Multiplayer Menu"}
textpath = "model/games/"

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

--"If all else fails"-method, reads a textfile and creates a function which returns a 
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
function multiModel:countFolders(folder)
    for folderName in io.popen([[ls -a "model/games/" /b /ad]]):lines() do 
    foldertable[folderName] = "model/games/"..folderName.."/resources/" end
    
    return foldertable
    --Testing for Windows:
    --for folderName in io.popen([[dir "src/" /b /ad]]):lines() do print(folderName) end
end

--Returning dummy information until a database/server-connection can be secured.
--@param dummy - Contains strings for the multiplayerview.
function getScores()
    
    return dummy
end

return multiModel