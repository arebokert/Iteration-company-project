singleModel = {title = "Singleplayer Menu"}
textpath = root_path.."model/games/"

-- function: new()
-- Creates and returns a reference an instance.
-- 
--@return obj - returns an instance of the singleplayermodel
function singleModel:new ()
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
function singleModel:setOptions(options)
    self.options = options
    self.size = #options
end

-- function: getOptions()
-- Returns the options-table.
--
-- @return self.options
function singleModel:getOptions()
    return self.options
end

-- function: getSize()
-- Returns the length of a the options-table.
function singleModel:getSize()
    return #self.options
end

-- function: fetchPath()
--Reads a textfile and creates a function which returns a 
--table with manually added lines of game-names/directories.
--
--@param resource - method created by loading a textfile.
--@param foldertable - stores the table created from calling "resource()"
function singleModel:fetchPath()
    local resource = assert(loadfile(textpath.."games.txt"))
    self.foldertable = resource()
    self:setOptions(self.foldertable)
    return self.foldertable    
end

return singleModel