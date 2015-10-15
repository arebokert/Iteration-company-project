

Gameplan = {}


function Gameplan:new ()
  obj = {}   -- create object if user does not provide one
  setmetatable(obj, self)
  self.__index = self
  return obj
end


function Gameplan:loadMap(filename)
  filename = "model/pacman/map1.txt"
  
  screen:clear({r=0, g=200, b=20})
  local file = io.open(filename)
  local tbllines = {}
  local result = {}
  local i = 0
  if file then
      for line in file:lines() do
       i = i + 1
       ADLogger.trace(line) 

       --[[
       ADLogger.trace(string.sub(line, -1, -1))
       lastChar = string.sub(line, -1, -1)
              
       if lastChar == ":" then
        ADLogger.trace("NYCKEL")
        key = string.sub(line, 1, -2)      
        result.key = {}
       end
       --]]
       
       tbllines[i] = line
      end
      file:close()
  else
      error('file not found')
  end
     
  ADLogger.trace("PRINT TABLE")  
  self.map = tbllines
end


function Gameplan:displayMap(container, map)
  self.logicalMap = {}
  
  map = self.map
  container = gfx.new_surface(1000, 600)
  
  width = 20    -- Width 
  height = 12    -- Height
  block = 50    
  
  
  wall = gfx.new_surface(block, block)
  wall:clear({r=0, g=0, b=0})

  aisle = gfx.new_surface(block, block)
  aisle:clear({r=200, g=200, b=200})
  
  for key, value in pairs(map) do
    self.logicalMap[key] = {}
    for i = 1, #value do    
        local pos = {x = (i-1)*block, y = (key-1)*block }
        local c = value:sub(i,i)
        if c == "1" then
          container:copyfrom(wall, nil, pos)
        elseif c == "0" then
          container:copyfrom(aisle, nil, pos)
        elseif c == "S" then
          -- STARTPOSITION
          self.startposition = pos
          container:copyfrom(aisle, nil, pos)
        end
        self.logicalMap[key][i] = value
    end
    
  end
  
  containerpos = {x = 140, y = 60}
  screen:copyfrom(container, nil, containerpos)   
  
  -- Update GFX
  gfx.update()
  


end


