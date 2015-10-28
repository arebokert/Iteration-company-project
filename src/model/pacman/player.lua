Player = {}

function Player:Movement(timer)
  -- Set step of each movement 
  step = 50
  -- Set new position, based on direction
  oldxpos = self.x
  oldypos = self.y
    
  if self:freeToMove() then
    if self.direction == "right" then
        self.x = self.x + step
  --    end
    end
    if self.direction == "up" then
      self.y = self.y - step
    end
    if self.direction == "left" then
        self.x = self.x - step
  --    end
    end
    if self.direction == "down" then
      self.y = self.y + step
    end 
    -- Copy empty recatangel 'temp'
    -- screen:copyfrom(temp, nil)
    -- Copy pacman-image to desired position.
    


    screen:copyfrom(self.bgblock, nil, {x = oldxpos, y = oldypos}) 
    screen:copyfrom(self.bg, nil, self:getPos())   
    
    -- Update GFX
    gfx.update()
  elseif self.type ~= "pacman" then
    self:Randomdirection()
    self:Movement()   
  end
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




function Player:freeToMove()
  
  xpos = self.x -140
  ypos = self.y - 60
  direction = self.direction
  
  ypos = ypos / 50
  xpos = xpos / 50
  
  if direction == "right" or direction == "down" then
    ypos = math.floor(ypos) + 1 
    xpos = math.floor(xpos) + 1
  else
    ypos = math.ceil(ypos) + 1
    xpos = math.ceil(xpos) + 1
  end
  
  maprow =  gameplan.map[ypos]
  currentposition = string.sub(maprow, xpos, xpos)

  if direction == "right" then
      nextposition = string.sub(maprow, xpos + 1, xpos + 1)    
  elseif direction == "left" then
      nextposition = string.sub(maprow, xpos - 1, xpos - 1)
  elseif direction == "down" then
      nextposition = string.sub(gameplan.map[ypos + 1], xpos, xpos)
  elseif direction == "up" then
      nextposition = string.sub(gameplan.map[ypos - 1], xpos, xpos)
  end  
   
 
  if nextposition == "1" then
    return false
  end
  return true
  

end
