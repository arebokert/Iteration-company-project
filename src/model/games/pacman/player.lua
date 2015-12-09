Player = {}

-- This function checks which new pos the player wants to go
-- @gameplan: The gameplan
-- @return new_pos: The new wanted pos of player
function Player:movement(gameplan)
  -- Set step of each movement 
  step = 5
  -- Set new position, based on direction
  oldxpos = self.x
  oldypos = self.y
  
  -- Had to do this global to use it in new function
  new_pos = {}
  new_pos.x = self.x
  new_pos.y = self.y
  
  
  if self.direction == "right" then
      new_pos.x = self.x + step
  end
  if self.direction == "up" then
      new_pos.y = self.y - step
  end
  if self.direction == "left" then
      new_pos.x = self.x - step
  end
  if self.direction == "down" then
      new_pos.y = self.y + step
  end 

  if self.type == "ghost" then
    self:changeGhostDir(gameplan,new_pos)
  end
  return new_pos
end

-- This function checks which possible direction the ghost can move, and randomizes which way to go
-- This enables the ghost to change direction when a new aisle appears
-- @gameplan: the gameplan
-- @new_pos: The pos that ghost is at
function Player:changeGhostDir(gameplan,new_pos)

    local posdir = {}
    local dir = gameplan:getPossibleMovements(new_pos)
    local count = 1
    for k, v in pairs(dir) do
      if v == true then
        posdir[count] = k
        count = count + 1
      end
    end  
    local newdir = posdir[math.random(count-1)]
    if newdir == "left" and self.direction ~= "right" then
       self.direction = newdir
    end
    if newdir == "right" and self.direction ~= "left" then
       self.direction = newdir
    end
    if newdir == "up" and self.direction ~= "down" then
       self.direction = newdir
    end
    if newdir == "down" and self.direction ~= "up" then
       self.direction = newdir
    end
end

-- Constructor of player
-- @type: A string describing which type of player e.g. pacman or ghost
function Player:new (type)
  obj = {}   -- create object if user does not provide one
  setmetatable(obj, self)
  self.__index = self
  obj.type = type
  return obj
end

-- Sets pos of player
-- @x: x coordinate
-- @y: y coordinate
function Player:setPos(x, y)
  self.x = x
  self.y = y
end

-- Gets pos of player
-- @x: x coordinate
-- @y: y coordinate
function Player:getPos()
  pos = {x = self.x, y = self.y}
  return pos
end

-- Randomizes a direction of an opponent
function Player:Randomdirection()
  possibledirections = {"up", "down", "left", "right"}
  pacmanrelativepos = {} 
   
  if pacman.x > self.x then
    pacmanrelativepos[1] = "right"
  else
    pacmanrelativepos[1] = "left"  
  end
  if pacman.y > self.y then
    pacmanrelativepos[2] = "down"
  else
    pacmanrelativepos[2] = "up"  
  end
  if math.random(2) == 1 then
    direction = math.random(4)
    self.direction = possibledirections[direction]
  else  
    direction = math.random(2)
    self.direction = pacmanrelativepos[direction]
  end    
  
end

