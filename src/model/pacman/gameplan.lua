require("model.pacman.dumper")

-- Define a shortcut function for testing
function dump(...)
  print(DataDumper(...), "\n---")
end

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
  local j = 0
  if file then
      for line in file:lines() do
       i = i + 1

       tbllines[i] = line
       j = string.len(line)
      end
      file:close()
  else
      error('file not found')
  end
     
  ADLogger.trace("PRINT TABLE")  
  self.map = tbllines
  
  self.ycells = i
  self.xcells = j
end

function createWall(block)
  local w = gfx.new_surface(block, block)
  w:clear({r=0, g=0, b=0})
  return w
end 

function createAisle(block)
  local a = gfx.new_surface(block, block)
  a:clear({r=200, g=200, b=200})
  return a
end

function getBackground(type) 



end 

function Gameplan:displayMap(container, map)
  self.logicalMap = {}
  
  map = self.map
  container_width = 1000
  container_height = 600
  container = gfx.new_surface(container_width, container_height)
  
  ADLogger.trace( self.xcells )
  ADLogger.trace( self.ycells )     
  
  self.block = container_width / self.xcells   
  
  background = {}
  -- 1 <=> wall 
  background["1"] = createWall(self.block)
  -- 0 <=> aisle 
  background["0"] = createAisle(self.block)

  
  for key, value in pairs(map) do
    self.logicalMap[key] = {}
    for i = 1, #value do    
        local pos = {x = (i-1)*self.block, y = (key-1)*self.block }
        local c = value:sub(i,i)
        if c == "1" or c == "0" then
          container:copyfrom(background[c], nil, pos)
        elseif c == "S" then
          -- STARTPOSITION
          self.startposition = pos
          container:copyfrom(background["0"], nil, pos)
        end
        self.logicalMap[key][i] = c     
        -- ADLogger.trace( c )   
    end

  end
  ADLogger.trace( self.logicalMap[1][1] )   
  ADLogger.trace( self.logicalMap[2][2] )    
  ADLogger.trace( self.block ) 
  -- dump(self.logicalMap )
  
  self.containerpos = {x = 140, y = 60}
  screen:copyfrom(container, nil, self.containerpos)   
  
  
  -- Update GFX
  gfx.update()
end


function Gameplan:repaint(cell)
    


end

function Gameplan:checkMap(cell)
  dump(cell)
  dump(self.logicalMap[cell.y][cell.x])
  return self.logicalMap[cell.y][cell.x]
end

function Gameplan:cellToXY(cell)
  local x = (cell.x-1) * self.block
  local y = (cell.y-1) * self.block
  local pos = {x=x, y=y}
  ADLogger.trace("CELL TO XY")
  dump(pos)
  return pos
end

function Gameplan:xyToCell(x,y) 
  
  local xcell = math.ceil( (x-self.containerpos.x)/self.block )
  local ycell = math.ceil( (y-self.containerpos.y)/self.block )
  local pos = {x=xcell, y=ycell}
  
  return pos
  
  --[[
  self.grid = {}
  
  for i=1,container_width do 
    self.grid[i] = {}
    for j=1,container_height do
      local x = math.ceil( i/self.block )
      local y = math.ceil( j/self.block )
      local pos = {x=x, y=y}
      self.grid[i][j] = pos
    end
  end
  
  dump( self.grid[960][580] )  
  dump( self.logicalMap[self.grid[960][580].y][self.grid[960][580].x])
  --]] 
  
end


