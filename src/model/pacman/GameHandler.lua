
require("model.pacman.gameplan")

Pacman = {}

function Pacman:new ()
  obj = {}   -- create object if user does not provide one
  setmetatable(obj, self)
  self.__index = self
  return obj
end

function Pacman:setPos(x, y)
  self.x = x
  self.y = y
end

function Pacman:getPos()
  pos = {x = self.x, y = self.y}
  return pos
end


function loadPacman()
  
  screen:destroy()
  screen = gfx.new_surface(1280, 720)
  screen:clear({r=100,g=0,b=0})
  gfx.update()
  startPacman()
  
end

-- This function checks whether pacman is able to move in the direction he's going regarding the map structure
function Pacman:freeToMove()
  
  xpos = pacman:getPos().x -140
  ADLogger.trace(xpos)
  ypos = pacman:getPos().y - 60
  ADLogger.trace(ypos)
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
    ADLogger.trace(direction)
      nextposition = string.sub(maprow, xpos + 1, xpos + 1)    
  elseif direction == "left" then
    ADLogger.trace(direction)
      nextposition = string.sub(maprow, xpos - 1, xpos - 1)
  elseif direction == "down" then
    ADLogger.trace(direction)
      nextposition = string.sub(gameplan.map[ypos + 1], xpos, xpos)

  elseif direction == "up" then
    ADLogger.trace(direction)
      nextposition = string.sub(gameplan.map[ypos - 1], xpos, xpos)
  end  
  
  ADLogger.trace(nextposition)
  
 
  if nextposition == "1" then
    return false
  end
  return true
  

end
function Pacman:pacmanMovement(timer)
  -- Set step of each movement 
  step = 10
  -- Set new position, based on direction
  
  
  
  if self:freeToMove() then
    if self.direction == "right" then
   --   if self.x + self.bg:get_width() + step < 1090 then
        self.x = self.x + step
  --    end
    end
    if self.direction == "up" then
      self.y = self.y - step
    end
    if self.direction == "left" then
   --   if self.x - step > 190 then
        self.x = self.x - step
  --    end
    end
    if self.direction == "down" then
      self.y = self.y + step
    end 
    -- Copy empty recatangel 'temp'
    -- screen:copyfrom(temp, nil)
    -- Copy pacman-image to desired position. 
    screen:copyfrom(self.bg, nil, self:getPos())   
    
    -- Update GFX
    gfx.update()
  end
end


function startPacman()
--[[
   ADLogger.trace("LOAD MAP1")    
   local file = io.open("data/pacman/map1.txt", "r");
   local arr = {}
   for line in file:lines() do
      table.insert (arr, line);
   end
--]]

    gameplan = Gameplan:new()
    gameplan:loadMap()
    gameplan:displayMap()


    pacman = Pacman:new()   -- Initiate object
    pacman:setPos(190,110) -- Set start position 
--    pacman.bg = gfx.loadpng('views/pacman/data/pacman.png') -- Set image
--    pacman.bg.premultiply()     -- Alpha fix
    pacman.bg = gfx.new_surface(50,50)
    pacman.bg:clear({r=255,g=255,b=51})
    
    
    screen:copyfrom(pacman.bg, nil, pacman:getPos())  -- Place pacman-image with initial position
    gfx.update()  -- Update GFX
    
    temp = gfx.new_surface(1280, 720)   -- Temp, just a rectangle with a solid color
    temp:clear({r=100,g=0,b=100})       
    -- Timer, updating pacmans position
    pacman.direction = "right"
    sys.new_timer(1, "pacman:pacmanMovement")
    


end

--[[
function changedirection() 

    if direction == "right" then
    ADLogger.trace(direction)
    if tonumber(pacman:getPos().x -140) % 50 == 0 then
      nextposition = string.sub(maprow, xpos + 1, xpos + 1)    
    end
  elseif direction == "left" then
    ADLogger.trace(direction)
    if tonumber(pacman:getPos().x -140) % 50 == 0 then
      nextposition = string.sub(maprow, xpos - 1, xpos - 1)
    end
  elseif direction == "down" then
    ADLogger.trace(direction)
    if tonumber(pacman:getPos().y -60) % 50 == 0 then
      nextposition = string.sub(gameplan.map[ypos + 1], xpos, xpos)
    end
  elseif direction == "up" then
    ADLogger.trace(direction)
    if tonumber(pacman:getPos().y -60) % 50 == 0 then
      nextposition = string.sub(gameplan.map[ypos - 1], xpos, xpos)
    end
  end  
end
--]]


function pacmanOnKey(key, state)

  if state == "down" then
    if key == "down" or key == "up" or key == "left" or key == "right" then 
      pacman.direction = key
      ADLogger.trace(key)
    end
  end
  
end






