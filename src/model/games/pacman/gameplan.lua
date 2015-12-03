---- Coords -----
---- Absolute position starts at (1,1)
---- Relative position starts at (0,0)
---- Cell grid position starts at (1,1)  
font_path = root_path.."views/mainmenu/data/font/Gidole-Regular.otf"
require("model.games.pacman.dumper")
require("model.games.pacman.collisionhandler")
require("model.games.pacman.player")

-- 4 because first time the lives are printed, one life is deducted
lives = 4
-- The step that the players will take in pixels
step = 5

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
-- Load the gameplan map
--
-- @param map: File name of map in txt format
--
function Gameplan:loadMap(map)
    -- If map is not specified, default is "map2.txt"
    if map == nil then
      map = 'map2.txt'
    end
    
    -- The map file
    local filename = root_path .. 'model/games/pacman/' .. map
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
-- Function to add a player to a gameplan
-- 
-- @param player: Player type
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
-- @param dir: The direction player should start moving in
--
function Gameplan:setPacmanDirection(dir)
    self.players[1].latentdirection = dir
end

--
-- Print a yellow dot in a cell
--
-- @param cell: The cell-value in cell coordiantes
--
function Gameplan:printYellowDot(cell)
    local dotoffset = GameplanGraphics.yellowDotOffset(self.block, self.dotSize)
    local dotpos = {x = (cell.x-1)*self.block + dotoffset, y = (cell.y-1)*self.block + dotoffset}--position of yellow dot
    local absPos = self:relativeToAbsolutePosition(dotpos.x, dotpos.y)
    screen:copyfrom(bg["d"], nil, absPos) --print yellow dot
end

-- 
-- Create an object with the different kinds of backgrounds for the map. 
--
-- @param blockSize: The size of each block (squares)
-- @param dotSize: The size of dot
--
function Gameplan:loadBackgroundObjects(blockSize, dotSize) 
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
-- Reprint the map with pacman, ghost and yellowdot current status.  
--
function Gameplan:reprintMap()
local dotoffset = GameplanGraphics.yellowDotOffset(self.block, self.dotSize)
for key, value in pairs(self.map) do
      ADLogger.trace(collectgarbage("count")*1024)
        --collectgarbage("stop")
        --collectgarbage()
        for i = 1, #value do            
            local pos = {x = (i-1)*self.block, y = (key-1)*self.block }
            local dotpos = {x = (i-1)*self.block + dotoffset, y = (key-1)*self.block + dotoffset}--position of yellow dot
            local c = value:sub(i,i)
            if c == "1" or c == "0" then
                container:copyfrom(bg[c], nil, pos)
                if c == "0" then
                  --print yellow dot
                  if self:checkDotStatus({x=i, y=key}) then
                    container:copyfrom(bg["d"], nil, dotpos)
                  end   
                end 
            elseif c == "D" then
                container:copyfrom(bg["0"], nil, pos)
            elseif c == "H" then   
            -- House position - no yellow dot 
                container:copyfrom(bg["0"], nil, pos)
            elseif c == "S" or c == "B" then
                container:copyfrom(bg["0"], nil, pos)
            end
        end
    end
    Score.printScore()
    for k,player in pairs(self.players) do
      container:copyfrom(player.bg, nil, player:getPos())
    end
    screen:copyfrom(container, nil, self.containerpos)
    -- Update GFX
    gfx.update()
end

--
-- Display the map on a container at a certain position 
--
-- @param container: The container where to load the map
-- @param containerPos: Where the container should be located
--
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
    bg = self:loadBackgroundObjects(self.block, self.dotSize)
    
    -- The logical map: A grid of the map 
    self.logicalMap = {}
    
    -- Loop through the map (ixj table) and 
    for key, value in pairs(self.map) do
        --collectgarbage("stop")
        --collectgarbage()
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
                container:copyfrom(bg["0"], nil, pos)
                container:copyfrom(bg["D"], nil, pos)
            elseif c == "H" then   
            -- House position - no yellow dot 
                container:copyfrom(bg["0"], nil, pos)
            elseif c == "S" then
                -- STARTPOSITION
                pacman = Player:new("pacman")   -- Initiate object
                -- Start position for pacman
                pacman:setPos(pos.x, pos.y)
                pacman.startPos = {x = pos.x, y = pos.y}
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
                local pacman_dest_rect = self:getDestRectangle(pacman:getPos())
                container:copyfrom(pacman.bg, nil, pacman_dest_rect)                
                pacman.direction = "right"
                pacman.latentdirection = "right"
                self:addPlayer(pacman)
            elseif c == "B" then
                -- BAD SOLUTION!!!
                blinky = Player:new("ghost")
                blinky:setPos(pos.x, pos.y)
                blinky.startPos = {x = pos.x, y = pos.y}
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
                local blinky_dest_rect = self:getDestRectangle(blinky:getPos())
                container:copyfrom(blinky.bg, nil, blinky_dest_rect)
                blinky.direction = "left"
                self:addPlayer(blinky)
            end
            self.logicalMap[key][i] = c
        end
    end
    Score.printScore()
    self:updateLives()
    yellowdotmatrix = self:yellowDotStatus(self.map)
    screen:copyfrom(container, nil, self.containerpos)
    -- Update GFX
    gfx.update()
end

function Gameplan:getDestRectangle(pos)
  local DestRect = {x = pos.x, y = pos.y, w = self.block, h = self.block}
  return DestRect
end

--
-- Updates number of lives left
--
function Gameplan:updateLives()
  
  lives = lives - 1
  local xlivestext = "x " .. lives
  local w = gfx.new_surface(100, 30)
  w:clear({r=0, g=0, b=0})
  screen:copyfrom(w,nil,{x=70, y=680})
  local life = gfx.loadpng('views/pacman/data/pacmanright0.png')
  life:premultiply()
  screen:copyfrom(life, nil, {x=70, y=680})
  screen:copyfrom(w,nil,{x=100, y=680})
  lives_text = sys.new_freetype({r=255,g=255,b=255},20, {x=100, y=680},font_path)
  lives_text:draw_over_surface(screen,xlivestext)
  gfx.update()
  
end

--
-- Returns the number of lives left
--
-- @return: Number of lives left
--
function Gameplan:getLives()
  return lives
end  

--
-- Sets the number of lives left
-- 4 since one life is deducted first time the no. of lives are printed
--
function Gameplan:resetLives()
  lives = 4
end  

--
-- Animation when pacman have no lives left
--
function deadAnimation() 
    if menuView == "pauseMenu" then
      deadAnimationTimer:stop()
      for k,player in pairs(gameplan.players) do
        player:setPos(player.startPos.x, player.startPos.y)
      end  
      pacman.latentdirection = "right"
      return
    else    
    if animationcount > 8 then
      deadAnimationTimer:stop()
      gameStatus = true
      gameTimer:start()
      for k,player in pairs(gameplan.players) do
        local startpos = player.startPos
        local currentpos = gameplan:relativeToAbsolutePosition(player.x, player.y)
        screen:copyfrom(bg["0"], nil, currentpos)
        gfx.update()
        player:setPos(startpos.x,startpos.y)
        if player.type == "pacman" then
          player.latentdirection = "right"
      end
    end
    end
    if animationmode == 0 then
      for k,player in pairs(gameplan.players) do
        local currentpos = gameplan:relativeToAbsolutePosition(player.x, player.y)
        screen:copyfrom(bg["0"], nil, currentpos) 
      end
      animationmode = 1
    elseif animationmode == 1 then
      for k,player in pairs(gameplan.players) do
        local currentpos = gameplan:relativeToAbsolutePosition(player.x, player.y)
        screen:copyfrom(player.bg, nil, currentpos)
      end
      animationmode = 0
    end
    gfx.update()
    animationcount = animationcount + 1
    end
end

--
-- Resets all players to their origin position
--
function Gameplan:reloadPlayerPos()

    animationcount = 0
    animationmode = 0
    gameStatus = false
    gameTimer:stop()

  if not deadAnimationTimer then
    deadAnimationTimer = sys.new_timer(200, "deadAnimation")
  else
    deadAnimationTimer:start()
  end
  
end

-- 
-- Repaint the gameplan when something is updated.
--
-- @player: The player 
-- @oldPos: Old position in relative coordinates 
--
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
      if self:checkDotStatus(cell) == true then
        self:printYellowDot(cell)
      end  
  end

  local absPos = self:relativeToAbsolutePosition(player:getPos().x,player:getPos().y)
  local DestRect = self:getDestRectangle(absPos)
  screen:copyfrom(player.bg, nil, DestRect)
  gfx.update()
end

--
-- Converts a relative position to an absolute position in the map
--
-- @param x: relative x position
-- @param y: relative y position
-- @return pos: absolute position in table
--
function Gameplan:relativeToAbsolutePosition(x, y)
    local pos = {}
    pos.x = x + self.containerpos.x
    pos.y = y + self.containerpos.y
    return pos
end

--
-- Checks what a cell in the map contains
--
-- @param cell: The cell wanted to check
-- @return the content of the cell
--
function Gameplan:checkMap(cell)
    return self.logicalMap[cell.y][cell.x]
end

--
-- Converts a cell position to reltive XY position
--
-- @param cell: The cell wanted to convert
-- @return pos: The relative XY position
--
function Gameplan:cellToXY(cell)
    local x = (cell.x-1) * self.block
    local y = (cell.y-1) * self.block
    local pos = {x=x, y=y}
    return pos
end

--
-- Converts an XY position to cell position
--
-- @param x: Relative x position to be converted
-- @param y: Relative y position to be converted
-- @return pos: The cell
--
function Gameplan:xyToCell(x,y)
    -- RELATIVE COORDINATES
    local xcell = math.ceil( (x+1)/self.block )
    local ycell = math.ceil( (y+1)/self.block )
    local pos = {x=xcell, y=ycell}
    return pos
end

--
-- This function checks whether a movement in a direction is possible
--
-- @param direction: Wanted direction
-- @param new_pos: Wanted position
-- @return true if ???
--
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

--
-- Gets all the directions, and if it's possible to move that way
--
-- @param position: Relative position
-- @return directions: Table with all directions containing true/false if possible to move
--
function Gameplan:getPossibleMovements(position)
    local directions = {left = false, right = false, up = false, down = false}
    local pos = {}
    for k, v in pairs(directions) do
        pos.x = position.x
        pos.y = position.y
        if k == "left" then
            pos.x = position.x - step
            directions.left = self:possibleMovement(k, pos)
        elseif k == "right" then
            pos.x = position.x + step
            directions.right = self:possibleMovement(k, pos)
        elseif k == "up" then
            pos.y = position.y - step
            directions.up = self:possibleMovement(k, pos)
        elseif k == "down" then
            pos.y = position.y + step
            directions.down = self:possibleMovement(k, pos)
        end
    end

    return directions
end

--
-- Refreshes the gameplan one fram
--
-- @return: A boolean value. True if collision with opponent. False if no collision
--
function Gameplan:refresh()

    for k,player in pairs(self.players) do
        
        -- Checks whether the latent key press is a possible movement
        if player.type == "pacman" then
            local old_dir = player.direction
            player.direction = player.latentdirection
            local check_pos = player:movement(self)
            if self:possibleMovement(player.latentdirection, check_pos) == true then
              player.direction = player.latentdirection
            else
              player.direction = old_dir
            end  
        end
       
        local new_pos = player:movement(self)
  
        -- New cell is an aisle, OK!
        if self:possibleMovement(player.direction, new_pos) == true then
            local oldPos = player:getPos()
            
            -- If the player enters the "teleportation" aisle he is teleported to the other end
            -- This requires that the map "teleportation doors" are at the same cell height 
            if new_pos.x < 0 then
              new_pos.x = self.container_width - self.block
            elseif new_pos.x > self.container_width - self.block then
              new_pos.x = 0
            end  
            
            player:setPos(new_pos.x, new_pos.y)
            GameplanGraphics.updatePlayerGraphic(player)
            self:repaint(player, oldPos)
            
            -- If player is pacman update score and remove yellowdot from yellowdot matrix
            -- This if statement is to handle bugs in yellow dot handling that occured
            -- It's not straight forward, but it's due to the size of pacman
            -- related to the position that's in the upper left corner
            -- This is purely SHIT CODE! And has to be rewritten.. The developers of this code are ashamed...
            if player.type == "pacman" then
              if player.direction == "right" then
                  oldPos.x = oldPos.x + step * 3
              elseif player.direction == "down" then
                  oldPos.y = oldPos.y + step * 3
              elseif player.direction == "left" then
                  oldPos.x = oldPos.x + step 
              elseif player.direction == "up" then
                  oldPos.y = oldPos.y + step
              end
              if self:checkDotStatus(self:xyToCell(oldPos.x, oldPos.y)) == true then 
                self:updateDotStatus(self:xyToCell(oldPos.x,oldPos.y))
              end       
            end
        end
        
        
        
        if self:possibleMovement(player.direction, new_pos) == false  then
            -- New cell is a wall, not ok!
            if player.type ~= "pacman" then
                player:Randomdirection()
            end
        end
    end
    
    Score.printScore()
    
    local collision = self:checkPacmanCollision()
    if collision == true then
      self:updateLives()
    end
    
    --for testing, prints bytes of memory freed for each transaction
    ADLogger.trace(collectgarbage("count")*1024)
    
    return not collision
    
end

--
-- This functions loops all the players and checks if there's a collision with pacman
--
-- @return: True if there's a collision with pacman, else False.
--
function Gameplan:checkPacmanCollision()
    for k,player in pairs(self.players) do
      if player.type == "pacman" then
        for j,opponent in pairs(self.players) do
          if opponent.type == "ghost" then
            collision = checkCollision(player,opponent, self.block)
            if collision == true then return true end
          end
        end
      end
    end
    return false
end

--
-- Dumps the positions of the players in the terminal
--
function Gameplan:dumpPlayerPos()
    -- dump(self.players)
    dump(yellowdotmatrix)
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

--
-- Creates a matrix that describes if a cell has a yellow dot or not 
-- True means that it has a yellow dot
-- Should be run when map is instantiated
--
-- @param map: map containing structure of aisles and walls
-- @return dotmatrix: created matirx with status of yellowdots
--
function Gameplan:yellowDotStatus(map)
    dotmatrix = {}
    noDotsRemaining = 0
    for key, value in pairs(map) do
        dotmatrix[key] = {}
        for i = 1, #value do
            local c = value:sub(i,i)
            if c == "0" then
                dotmatrix[key][i] = true
                noDotsRemaining = noDotsRemaining + 1
            else
                dotmatrix[key][i] = false
            end
        end
    end
    return dotmatrix
end

--
-- Update cells to not contain a yellow dot.
-- Decrease number of dots left with 1
--
-- @param pos: array containing x-pos and y-pos cell values
--
function Gameplan:updateDotStatus(pos)
    noDotsRemaining = noDotsRemaining - 1
    Score.increaseScore(10)
    yellowdotmatrix[pos.y][pos.x] = false 
end

--
-- Checks if a cell contains a yellow dot
--
-- @param pos: array containing x-pos and y-pos cell values
-- @return: the status of a dot position. True/False value
--
function Gameplan:checkDotStatus(pos)
    return yellowdotmatrix[pos.y][pos.x]
end

return Gameplan