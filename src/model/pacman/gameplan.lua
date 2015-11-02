require("model.pacman.dumper")
require("model.pacman.collisionhandler")

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

function createYellowDot(psize, ppos)
  local dot = gfx.new_surface(psize, psize)
  dot:clear({r=255, g=255, b=51})
  --container:copyfrom(dot, nil, ppos)
  return dot
end


-- Print a yellow dot to a cell
function Gameplan:printYellowDot(cell) 
  local dotpos = {x = (cell.x-1)*self.block +18, y = (cell.y-1)*self.block +18 }--position of yellow dot
  local absPos = self:relativeToAbsolutePosition(dotpos.x, dotpos.y)
  screen:copyfrom(background["d"], nil, absPos) --print yellow dot
end


function Gameplan:displayMap(container, map)
  self.logicalMap = {}
  
  map = self.map
  container_width = 1000
  container_height = 600
  container = gfx.new_surface(container_width, container_height)
  self.containerpos = {x = 140, y = 60}
  
    
  self.block = container_width / self.xcells   
  self.dsize = 14
  
  background = {}
  -- 1 <=> wall 
  background["1"] = createWall(self.block)
  -- 0 <=> aisle 
  background["0"] = createAisle(self.block)
  -- 0 <=> yellow dot
  background["d"] = createYellowDot(self.dsize)
  
  for key, value in pairs(map) do
    collectgarbage()
    self.logicalMap[key] = {}
    for i = 1, #value do 
        
        local pos = {x = (i-1)*self.block, y = (key-1)*self.block }
        local dotpos = {x = (i-1)*self.block +18, y = (key-1)*self.block +18 }--position of yellow dot
        local c = value:sub(i,i)
        if c == "1" or c == "0" then
          container:copyfrom(background[c], nil, pos)
          if c == "0" then
            container:copyfrom(background["d"], nil, dotpos) --print yellow dot
          end
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
    -- Instantiates a matrix representing which cells have yellow dots
    --yellowdotmatrix = {}
    --yellowdotmatrix = yellowDotStatus(map)

  end
  ADLogger.trace( self.logicalMap[1][1] )   
  ADLogger.trace( self.logicalMap[2][2] )    
  ADLogger.trace( self.block ) 
  -- dump(self.logicalMap )
  

  screen:copyfrom(container, nil, self.containerpos)   
  
  
  -- Update GFX
  gfx.update()
end


function Gameplan:repaint(player, oldPos)
  if oldPos == nil then
    return false
  end
  local absOldPos = self:relativeToAbsolutePosition(oldPos.x,oldPos.y)
  screen:copyfrom(background["0"], nil, absOldPos) 
  
  if player.type ~= "pacman" then
    -- If player not pacman, print yellow dot. 
    local cell = self:xyToCell(oldPos.x, oldPos.y)
    if player.direction == "left" then 
      cell = self:xyToCell(oldPos.x + 50 -1, oldPos.y)
    elseif player.direction == "up" then
      cell = self:xyToCell(oldPos.x, oldPos.y + 50 -1)
    end
    self:printYellowDot(cell)
  end
   
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

    local new_cell = self:xyToCell(target.x, target.y)    
    local new_cell2 = self:xyToCell(target.x, target.y) 
    
    if player.direction == "right" then 
      new_cell = self:xyToCell(target.x + 50 - 1, target.y)    
      new_cell2 = self:xyToCell(target.x + 50 - 1, target.y + 50 - 1 )
    elseif player.direction == "down" then 
      new_cell = self:xyToCell(target.x, target.y + 50 -1)    
      new_cell2 = self:xyToCell(target.x + 50 - 1, target.y + 50 - 1 )
    elseif player.direction == "left" then 
      new_cell = self:xyToCell(target.x, target.y)    
      new_cell2 = self:xyToCell(target.x, target.y + 50 - 1 )      
    elseif player.direction == "up" then 
      new_cell = self:xyToCell(target.x, target.y)    
      new_cell2 = self:xyToCell(target.x + 50 -1, target.y)      
    end 
    
    local new_cell_content = self:checkMap(new_cell)
    local new_cell2_content = self:checkMap(new_cell2)
    
    if new_cell_content ~= "1" and new_cell2_content ~= "1" then
      -- New cell is an aisle, OK!
      -- New cell is an aisle, OK!
      local oldPos = player:getPos()
      player:setPos(new_pos.x, new_pos.y)
      self:repaint(player, oldPos)
    end
    if new_cell_content == "1" then 
      -- New cell is a wall, not ok! 
      if player.type ~= "pacman" then
       player:Randomdirection()
      end
    end
  end
  ADLogger.trace("refresh")
  return not checkCollision(self.players)
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

-- Creates a matrix that describes if a cell has a yellow dot or not 
--  True means that it has a yellow dot
function yellowDotStatus(map)
  dotmatrix = {} 
  for key, value in pairs(map) do
     dotmatrix[key] = {}
    for i = 1, #value do  
        local c = value:sub(i,i)
        if c == "0" then
        dotmatrix[key][i] = "True"
        else 
         dotmatrix[key][i] = "False"
        end    
    end
  end
  return dotmatrix
end

-- Updates cells to not have a yellow dot
function updateDotStatus(pos)
  yellowdotmatrix[pos.y][pos.x] = "False"
end

-- Checks if a cell has a yellow dot
function checkDotStatus(pos)
  return yellowdotmatrix[pos.y][pos.x] 
end


