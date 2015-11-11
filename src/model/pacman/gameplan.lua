---- Coords -----
---- Absolute position starts at (1,1)
---- Relative position starts at (0,0)
---- Cell grid position starts at (1,1)  

require("model.pacman.dumper")
require("model.pacman.collisionhandler")
GameplanGraphics = require("model.pacman.gameplangraphics")

-- Define a shortcut function for testing
function dump(...)
    print(DataDumper(...), "\n---")
end


-- The Gameplan class. 
Gameplan = {}

--
-- Create an instance of a gameplan. 
--
function Gameplan:new ()
    obj = {}   -- create object if user does not provide one
    setmetatable(obj, self)
    self.__index = self
    return obj
end


--
-- Load the pacman map. 
--
function Gameplan:loadMap(map)
    -- If map is not specified, default is "map1.txt"
    if map == nil then
      map = 'map1.txt'
    end
    
    -- The map file
    local filename = root_path .. 'model/pacman/' .. map
    local file = io.open(filename, "r")
    local tabellines = {}
    local i = 0
    
    -- Read the map-file and save to an ixj-array. If no file is found, return false. 
    if file then
        for line in file:lines() do
            i = i + 1
            tabellines[i] = line
        end
        io.close(file)
    else
        error('file not found')
        -- No file found, return false. 
        return false
    end
    
    self.map = tabellines
    self.ycells = i
    self.xcells = string.len(tabellines[1])
    -- File is saved to a table, return true. 
    return true
end


-- 
-- Function to add a player to a gameplan. 
--
function Gameplan:addPlayer(player)
    if self.players == nil then
        self.players = {}
    end
    table.insert(self.players, player)
end


--
-- Set direction of Pacman. Obs! Hardcoded as player 1, needs to be adjusted. 
--
function Gameplan:setPacmanDirection(dir)
    pacman_direction = dir
    self.players[1].direction = dir
end


-- Print a yellow dot to a cell
--@param cell: The cell-value in cell coordiantes
function Gameplan:printYellowDot(cell)
    local dotoffset = GameplanGraphics.yellowDotOffset(self.block, self.dotSize)
    local dotpos = {x = (cell.x-1)*self.block + dotoffset, y = (cell.y-1)*self.block + dotoffset}--position of yellow dot
    local absPos = self:relativeToAbsolutePosition(dotpos.x, dotpos.y)
    screen:copyfrom(bg["d"], nil, absPos) --print yellow dot
end


-- 
-- Create an object with the different kinds of backgrounds for the map. 
-- 
-- @param: blockSize. The size of each block (squares)
-- @param: dotSize. The size of dot
function loadBackgroundObjects(blockSize, dotSize) 
  -- The background object
  local background = {}
  -- 1 <=> wall
  background["1"] = GameplanGraphics.createWall(blockSize)
  -- 0 <=> aisle
  background["0"] = GameplanGraphics.createAisle(blockSize)
  -- 0 <=> yellow dot
  background["d"] = GameplanGraphics.createYellowDot(dotSize)
  -- D <=> Door
  background["D"] = GameplanGraphics.createDoor(blockSize)
  
  return background
end   


--
-- Display the map on a container at a certain position 
--
-- @param: container. The container where to load the map
-- @param: containerPos. Where the container should be located. 
function Gameplan:displayMap(container, containerPos)
    -- Save the position of the container and width/height
    self.containerpos = containerPos
    self.container_width = container:get_width()
    self.container_height = container:get_height()
    
    -- Block-size is calculated as width/number of x-cells 
    self.block = self.container_width / self.xcells
    self.dotSize = math.ceil(self.block / 7)
    local dotoffset = GameplanGraphics.yellowDotOffset(self.block, self.dotSize)
    
    -- Global variable, pretty bad code
    bg = loadBackgroundObjects(self.block, self.dotSize)
    
    -- The logical map: A grid of the map 
    self.logicalMap = {}
    
    -- Loop through the map (ixj table) and 
    for key, value in pairs(self.map) do
        collectgarbage()
        self.logicalMap[key] = {}
        for i = 1, #value do            
            local pos = {x = (i-1)*self.block, y = (key-1)*self.block }
            local dotpos = {x = (i-1)*self.block + dotoffset, y = (key-1)*self.block + dotoffset}--position of yellow dot
            local c = value:sub(i,i)
            
            if c == "1" or c == "0" then
                container:copyfrom(bg[c], nil, pos)
                if c == "0" then
                  --print yellow dot
                  container:copyfrom(bg["d"], nil, dotpos) 
                end 
            elseif c == "D" then
                --self:paintdoor({x=i, y=key})
                container:copyfrom(bg["D"], nil, pos)
            elseif c == "S" then
                -- STARTPOSITION
                pacman = Player:new("pacman")   -- Initiate object
                -- Start position for pacman
                pacman:setPos(pos.x, pos.y)
                pacman.bg = gfx.new_surface(self.block,self.block)
                --pacman.bg:clear({r=255,g=255,b=51})
                
                 -- pacman attributes to keep track of picture for animation
                pacman.moveanim = 1
                pacman.picture0 = 'views/pacman/data/pacmanright0.png'
                pacman.picture1 = 'views/pacman/data/pacmanright1.png'
                pacman.bg = gfx.loadpng(pacman.picture1)
                
                -- BAD SOLUTION!!!
                container:copyfrom(bg["0"], nil, pos)
                pacman.bg:premultiply()
                container:copyfrom(pacman.bg, nil, pacman:getPos())
                pacman.direction = "right"
                self:addPlayer(pacman)
            elseif c == "B" then
                -- BAD SOLUTION!!!
                blinky = Player:new("ghost")
                blinky:setPos(pos.x, pos.y)
                blinky.bg = gfx.new_surface(self.block,self.block)
                -- blinky.bg:clear({r=0,g=255,b=51})
  
                 -- ghost attributes to keep track of picture for animation
                blinky.moveanim = 1
                blinky.picture0 = 'views/pacman/data/blinkyright0.png'
                blinky.picture1 = 'views/pacman/data/blinkyright1.png'
                blinky.ghostname = "blinky"
                blinky.bg = gfx.loadpng(blinky.picture1)
               
                container:copyfrom(bg["0"], nil, pos)
                blinky.bg:premultiply()
                container:copyfrom(blinky.bg, nil, blinky:getPos())
                blinky.direction = "left"
                self:addPlayer(blinky)
            end
            self.logicalMap[key][i] = c
        end
    end
    yellowdotmatrix = yellowDotStatus(self.map)
    screen:copyfrom(container, nil, self.containerpos)

    -- Update GFX
    gfx.update()
end


-- 
-- Repaint the gameplan when something is updated.
--
-- @player: The player 
-- @oldPos: Old position in relative coordinates 
function Gameplan:repaint(player, oldPos)
  -- First turn, the old position is null. Return false. 
  if oldPos == nil then
      return false
  end
  
  -- Get absolute position 
  local absOldPos = self:relativeToAbsolutePosition(oldPos.x,oldPos.y)
  screen:copyfrom(bg["0"], nil, absOldPos)

  if player.type ~= "pacman" then
      -- If player not pacman, print yellow dot.
      local cell = self:xyToCell(oldPos.x, oldPos.y)
      if player.direction == "left" then
          cell = self:xyToCell(oldPos.x + self.block -1, oldPos.y)
      elseif player.direction == "up" then
          cell = self:xyToCell(oldPos.x, oldPos.y + self.block -1)
      end
      if checkDotStatus(cell) == true then
        self:printYellowDot(cell)
      end  
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
    return self.logicalMap[cell.y][cell.x]
end


function Gameplan:cellToXY(cell)
    local x = (cell.x-1) * self.block
    local y = (cell.y-1) * self.block
    local pos = {x=x, y=y}
    return pos
end


function Gameplan:xyToCell(x,y)
    -- RELATIVE COORDINATES
    local xcell = math.ceil( (x+1)/self.block )
    local ycell = math.ceil( (y+1)/self.block )
    local pos = {x=xcell, y=ycell}
    return pos
end

function Gameplan:possibleMovement(direction, new_pos)
    local target = {}
    target.x = new_pos.x
    target.y = new_pos.y

    local new_cell = self:xyToCell(target.x, target.y)
    local new_cell2 = self:xyToCell(target.x, target.y)

    if direction == "right" then
        new_cell = self:xyToCell(target.x + self.block - 1, target.y)
        new_cell2 = self:xyToCell(target.x + self.block - 1, target.y + self.block - 1 )
    elseif direction == "down" then
        new_cell = self:xyToCell(target.x, target.y + self.block -1)
        new_cell2 = self:xyToCell(target.x + self.block - 1, target.y + self.block - 1 )
    elseif direction == "left" then
        new_cell = self:xyToCell(target.x, target.y)
        new_cell2 = self:xyToCell(target.x, target.y + self.block - 1 )
    elseif direction == "up" then
        new_cell = self:xyToCell(target.x, target.y)
        new_cell2 = self:xyToCell(target.x + self.block -1, target.y)
    end

    local new_cell_content = self:checkMap(new_cell)
    local new_cell2_content = self:checkMap(new_cell2)

    if new_cell_content ~= "1" and new_cell2_content ~= "1" then
        return true
    else
        return false
    end
end

function Gameplan:getPossibleMovements(position)
    local directions = {left = false, right = false, up = false, down = false}
    local pos = {}
    pos.x = position.x
    pos.y = position.y
    local step = 5
    for k, v in pairs(directions) do
        if k == "left" then
            pos.x = position.x - step
        elseif k == "right" then
            pos.x = position.x + step
        elseif k == "up" then
            pos.y = position.y + step
        elseif k == "down" then
            pos.y = position.y - step
        end
        directions[k] = self:possibleMovement(k, pos)
    end

    return directions
end

-- function to update direction of player picture depending on direction
function Gameplan:updatePlayerRotation(player)       
  if player.type == "pacman" then
    player.picture0 = 'views/pacman/data/'..player.type..player.direction..'0'..'.png'
    player.picture1 = 'views/pacman/data/'..player.type..player.direction..'1'..'.png'
  else
    player.picture0 = 'views/pacman/data/'..player.ghostname..player.direction..'0'..'.png'
    player.picture1 = 'views/pacman/data/'..player.ghostname..player.direction..'1'..'.png'
   end
end

-- function that change between different pictures (animation) each time a player moves to new cell
function Gameplan:updatePlayerGraphic(player)
    self:updatePlayerRotation(player)
    if player.moveanim == 0 then
      player.bg = gfx.loadpng(player.picture0)
      player.moveanim = 1
    elseif player.moveanim == 1 then 
      player.bg = gfx.loadpng(player.picture1)
      player.moveanim = 0
    end  
end


function Gameplan:refresh()

    for k,player in pairs(self.players) do
        local new_pos = player:movement()

        if player.type ~= "pacman" then
            local dir = self:getPossibleMovements(player:getPos())
        end

        -- New cell is an aisle, OK!
        if self:possibleMovement(player.direction, new_pos) == true then
            local oldPos = player:getPos()
            player:setPos(new_pos.x, new_pos.y)
            
            self:updatePlayerGraphic(player)  
            self:repaint(player, oldPos)
            if player.type == "pacman" then
               updateDotStatus(self:xyToCell(new_pos.x,new_pos.y))
            end
        end
        if self:possibleMovement(player.direction, new_pos) == false  then
            -- New cell is a wall, not ok!
            if player.type ~= "pacman" then
                player:Randomdirection()
            end
        end
    end

    return not checkCollision(self.players[1],self.players[2])
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
-- Should be run when map is instantiated
function yellowDotStatus(map)
    dotmatrix = {}
    for key, value in pairs(map) do
        dotmatrix[key] = {}
        for i = 1, #value do
            local c = value:sub(i,i)
            if c == "0" then
                dotmatrix[key][i] = true
            else
                dotmatrix[key][i] = false
            end
        end
    end
    return dotmatrix
end


-- Updates cells to not have a yellow dot
function updateDotStatus(pos)
    yellowdotmatrix[pos.y][pos.x] = "false"
end


-- Checks if a cell has a yellow dot
function checkDotStatus(pos)
    return yellowdotmatrix[pos.y][pos.x]
end


return Gameplan
