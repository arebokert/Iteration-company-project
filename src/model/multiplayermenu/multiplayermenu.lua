multiMenu = {title = "Multiplayer Menu"}
textpath = "src/model/"
foldertable = {}

--Constructor
--@return obj - returns an instance of the multiplayermenu
function multiMenu:new ()
    obj = {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function multiMenu:setOptions(options)
    self.options = options
    self.size = #options
end

--"If all else fails"-method, reads a textfile and creates a function which returns a 
--table with manually added lines of game-names/directories.
--@param resource - method created by asserting a textfile.
--@param gametable - stores the table created from calling "resource()"
function multiMenu:fetchPath()
    local resource = assert(loadfile(textpath.."games.txt"))
    foldertable = resource()
    
    return foldertable    
end

--Experiment function that might or might not work on the box.
--Attempts to count folder in a directory (using terminal commands).
function multiMenu:countFolders(folder)
    for folderName in io.popen([[ls -a "model/games/" /b /ad]]):lines() do 
    foldertable[folderName] = "model/games/"..folderName.."/resources/" end
    
    return foldertable
    --Testing for Windows:
    --for folderName in io.popen([[dir "src/" /b /ad]]):lines() do print(folderName) end
end

function multiMenu:action()
    self.options[self.active].action()
end

function multiMenu:hover()
    self.options[self.active].hover()
end

function multiMenu:next()
    local next = self.active + 1

    if (self.active + 1) > self.size then
        next = 1
    end
    
    self.active = next
    return next
end

function multiMenu:prev()
  local prev = self.active - 1

    if self.active - 1 < 1 then
        prev = self.size
    end
    
    self.active = prev
    return prev
end

function multiMenu:action()
    self.options[self.active].action()
end

function multiMenu:hover()
    self.options[self.active].hover()
end

return multiMenu