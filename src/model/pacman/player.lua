Player = {}

function Player:movement()
  -- Set step of each movement 
  step = 5
  -- Set new position, based on direction
  oldxpos = self.x
  oldypos = self.y
  
  local new_pos = {}
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
  
    
  return new_pos
  --[[
  elseif self.type ~= "pacman" then
    self:Randomdirection()
    self:Movement()   
  end
  --]]
end


function Player:new (type)
  obj = {}   -- create object if user does not provide one
  setmetatable(obj, self)
  self.__index = self
  obj.type = type
  return obj
end

function Player:setPos(x, y)
  self.x = x
  self.y = y
end

function Player:getPos()
  pos = {x = self.x, y = self.y}
  return pos
end

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

