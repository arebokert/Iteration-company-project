multiModel = {title = "Multiplayer Menu"}
textpath = "src/model/"
foldertable = {}

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

--"If all else fails"-method, reads a textfile and creates a function which returns a 
--table with manually added lines of game-names/directories.
--@param resource - method created by asserting a textfile.
--@param gametable - stores the table created from calling "resource()"
function multiModel:fetchPath()
    local resource = assert(loadfile(textpath.."games.txt"))
    foldertable = resource()
    
    return foldertable    
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

function multiModel:action()
    self.options[self.active].action()
end

function multiModel:hover()
    self.options[self.active].hover()
end

function multiModel:next()
    local next = self.active + 1

    if (self.active + 1) > self.size then
        next = 1
    end
    
    self.active = next
    return next
end

function multiModel:prev()
  local prev = self.active - 1

    if self.active - 1 < 1 then
        prev = self.size
    end
    
    self.active = prev
    return prev
end

--Listener for keycommands, repeated in every menu-class.
function multiModel:registerKey(key,state)
  if current_menu == "multiModel" then
    if key == "left" then
        activeMenu:prev()
    elseif key == "right" then
        activeMenu:next()
    elseif key == "ok" then
        activeMenu:action()
    elseif key == "down" then
        current_menu = "mainMenu"
    elseif key == "exit" then
        sys.stop()
    end
  end
end

return multiModel