require("model.pacman.dumper")

-- Define a shortcut function for testing
function dump(...)
  print(DataDumper(...), "\n---")
end

Gameplan = {}

function Gameplan:addPlayer(player)
  if self.players == nil then
    self.players = {}
  end
  table.insert(self.players, player)
end

function Gameplan:setPacmanDirection(dir) 
  pacman_direction = dir
  self.players[1].direction = dir
end


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
  self.containerpos = {x = 140, y = 60}
  
    
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
          pacman = Player:new("pacman")   -- Initiate object
          -- Start position for pacman
          pacman:setPos(pos.x, pos.y)
          pacman.bg = gfx.new_surface(50,50)
          pacman.bg:clear({r=255,g=255,b=51})
          
          container:copyfrom(pacman.bg, nil, pacman:getPos())
          pacman.direction = "right"
          
          self:addPlayer(pacman)
        elseif c == "B" then
          blinky = Player:new("ghost")
          blinky:setPos(pos.x, pos.y)
          blinky.bg = gfx.new_surface(50,50)
          blinky.bg:clear({r=0,g=255,b=51})      
          container:copyfrom(blinky.bg, nil, blinky:getPos())
          blinky.direction = "left"    
          self:addPlayer(blinky)
        end
        self.logicalMap[key][i] = c     
        -- ADLogger.trace( c )   
    end

  end
  ADLogger.trace( self.logicalMap[1][1] )   
  ADLogger.trace( self.logicalMap[2][2] )    
  ADLogger.trace( self.block ) 
  -- dump(self.logicalMap )
  

  screen:copyfrom(container, nil, self.containerpos)   
  
  
  -- Update GFX
  gfx.update()
end


function Gameplan:repaint(player)
  local absPos = self:relativeToAbsolutePosition(player:getPos().x,player:getPos().y)
  screen:copyfrom(player.bg, nil, absPos)
  gfx.update()
end


function Gameplan:relativeToAbsolutePosition(x, y)
  local pos = {}
  pos.x = x + self.containerpos.x
  pos.y = y + self.containerpos.y
  return pos
end



function Gameplan:checkMap(cell)
  dump(cell)
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
  -- RELATIVE COORDINATES 
  local xcell = math.ceil( (x+1)/self.block )
  local ycell = math.ceil( (y+1)/self.block )
  local pos = {x=xcell, y=ycell}
  
  return pos
end


function Gameplan:refresh()
  -- dump(self.players)
  for k,player in pairs(self.players) do
    local new_pos = player:Movement()
    local target = {}
    target.x = new_pos.x
    target.y = new_pos.y    
    if player.direction == "right" then
      target.x = target.x + 50 -1
    end
    if player.direction == "down" then
      target.y = new_pos.y + 50 - 1        
    end


    ADLogger.trace(player.type)
    ADLogger.trace("CURRENT POS:")
    dump(player:getPos())
    
    ADLogger.trace("NEW POS:")
    dump(new_pos)

    ADLogger.trace("TARGET")
    dump(target)

    local new_cell = self:xyToCell(target.x, target.y)
    ADLogger.trace("NEW CELL")
    dump(new_cell)    
    local new_cell_content = self:checkMap(new_cell)
        
    if new_cell_content == "0" then
      -- New cell is an aisle, OK!
      player:setPos(new_pos.x, new_pos.y)
      self:repaint(player)
    end
    if new_cell_content == "1" then 
      -- New sell is a wall, not ok! 
    
    end
  end
  ADLogger.trace("refresh")
end


function Gameplan:dumpPlayerPos()
  -- dump(self.players)
  
  for k,player in pairs(self.players) do
    local pos = player:getPos()
    ADLogger.trace("PLAYERS:")  
    dump(pos)
    local absPos = self:relativeToAbsolutePosition(pos.x, pos.y)
    dump(absPos)
    local cell = self:xyToCell(pos.x, pos.y)
    dump(cell)
    ADLogger.trace("END PLAYER")      
  end
end
