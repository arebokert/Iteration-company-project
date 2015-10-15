
require("data.pacman.gameplan")

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

function Pacman:pacmanMovement(timer)
  -- Set step of each movement 
  step = 8
  -- Set new position, based on direction
  if self.direction == "right" then
    self.x = self.x + step
  end
  if self.direction == "up" then
    self.y = self.y - step
  end
  if self.direction == "left" then
    self.x = self.x - step 
  end
  if self.direction == "down" then
    self.y = self.y + step
  end 
  -- Copy empty recatangel 'temp'
  screen:copyfrom(temp, nil)
  -- Copy pacman-image to desired position. 
  screen:copyfrom(self.bg, nil, self:getPos())   
  
  -- Update GFX
  gfx.update()
end


function startPacman()
    pacman = Pacman:new()   -- Initiate object
    pacman:setPos(100, 200) -- Set start position 
    pacman.bg = gfx.loadpng('data/pacman/pacman.png') -- Set image
    pacman.bg.premultiply()     -- Alpha fix
    
    screen:copyfrom(pacman.bg, nil, pacman:getPos())  -- Place pacman-image with initial position
    gfx.update()  -- Update GFX
    
    temp = gfx.new_surface(1280, 720)   -- Temp, just a rectangle with a solid color
    temp:clear({r=100,g=0,b=100})       
    
    -- Timer, updating pacmans position
    sys.new_timer(1, "pacman:pacmanMovement")
    

--[[
   ADLogger.trace("LOAD MAP1")    
   local file = io.open("data/pacman/map1.txt", "r");
   local arr = {}
   for line in file:lines() do
      table.insert (arr, line);
   end
--]]

ADLogger.trace("LOAD MAP1")   
local file = io.open("data/pacman/map1.txt")
local tbllines = {}
local i = 0
if file then
    for line in file:lines() do
     i = i + 1
     ADLogger.trace(line) 
     tbllines[i] = line
    end
    file:close()
else
    error('file not found')
end
   
  ADLogger.trace("PRINT TABLE")  
  
  ADLogger.trace(tbllines[1])
     
end



function pacmanOnKey(key, state)

  if state == "down" then
    if key == "down" or key == "up" or key == "left" or key == "right" then 
      pacman.direction = key
      ADLogger.trace(key)
    end
  end
  
end






