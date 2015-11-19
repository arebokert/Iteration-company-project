IH = require 'imagehelper'

function love.load()

  -- Set window size
  tileSize = 128;
  love.window.setMode(tileSize * 4, tileSize * 4, 
            {resizable=false, vsync=false } )

  -- get Window Dimension
  winWidth, winHeight = love.graphics.getDimensions( )
  love.graphics.setColor(255,255,255)

  -- set background
  imgFiles = {
        'cell_img/2.png',
        'cell_img/4.png',
        'cell_img/8.png',
        'cell_img/16.png',
        'cell_img/32.png',
        'cell_img/64.png',
        'cell_img/128.png',
        'cell_img/256.png',
        'cell_img/512.png',
        'cell_img/1024.png',
        'cell_img/2048.png',
        'cell_img/empty.png',
         }
  canvasList = {}
  for i, imgFile in ipairs(imgFiles) do
    table.insert(canvasList, IH.createImageCanvas_Fit(imgFile,tileSize,tileSize))
  end

  -- Initialize grid and new grid
  grid = {}
  newGrid = {}
  for row = 0, 5 do
    grid[row] = {}
    newGrid[row] = {}
  end
  grid[math.random(4)][math.random(4)] = 1
end

function love.update(dt)
end

function love.draw()
  -- draw cells
  for row = 1, 4 do
    for col = 1, 4 do 
      currCell = grid[row][col]
      if currCell ~= nil then
        love.graphics.draw(canvasList[currCell], 
                   (col - 1) * tileSize, 
                   (row - 1) * tileSize )
      else
        love.graphics.draw(canvasList[table.getn(canvasList)], 
                   (col - 1) * tileSize, 
                   (row - 1) * tileSize )
      end
    end
  end

  -- Draw gridline
  love.graphics.setLineWidth( 9 )
  for loc_x = 0, winWidth, tileSize do
    love.graphics.line(loc_x, 0, loc_x, winHeight)
  end
  for loc_y = 0, winHeight, tileSize do
    love.graphics.line(0 ,loc_y, winWidth, loc_y)
  end
end

function collapse( line )
  result = {}
  lastNil = 1
  combined = false
  for index = 1, 4 do
    --if curr position is not nil
    if line[index] ~= nil then
      --if we can combine with last real cell, combine
      if not combined and result[lastNil - 1] == line[index] then
        result[lastNil - 1] = result[lastNil - 1] + 1
        combined = true
      --else just move to last nil cell
      else
        result[lastNil] = line[index]
        lastNil = lastNil + 1
        combined = false
      end
    end
  end
  return result
end

function extractLine( grid, direction, index )
  if direction == 'left' then
    rowStart = index
    rowEnd = index
    rowIncr = 1
    colStart = 1
    colEnd = 4
    colIncr = 1
  elseif direction == 'right' then
    rowStart = index
    rowEnd = index
    rowIncr = 1
    colStart = 4
    colEnd = 1
    colIncr = -1
  elseif direction == 'up' then
    rowStart = 1
    rowEnd = 4
    rowIncr = 1
    colStart = index
    colEnd = index
    colIncr = 1
  elseif direction == 'down' then
    rowStart = 4
    rowEnd = 1
    rowIncr = -1
    colStart = index
    colEnd = index
    colIncr = 1
  end

  line = {}
  for row = rowStart, rowEnd, rowIncr do
    for col = colStart, colEnd, colIncr do
      table.insert(line, grid[row][col])
    end
  end
  return(line)
end

function pasteLine( grid, direction, index, line )
  if direction == 'left' then
    rowStart = index
    rowEnd = index
    rowIncr = 1
    colStart = 1
    colEnd = 4
    colIncr = 1
  elseif direction == 'right' then
    rowStart = index
    rowEnd = index
    rowIncr = 1
    colStart = 4
    colEnd = 1
    colIncr = -1
  elseif direction == 'up' then
    rowStart = 1
    rowEnd = 4
    rowIncr = 1
    colStart = index
    colEnd = index
    colIncr = 1
  elseif direction == 'down' then
    rowStart = 4
    rowEnd = 1
    rowIncr = -1
    colStart = index
    colEnd = index
    colIncr = 1
  end

  count = 1
  for row = rowStart, rowEnd, rowIncr do
    for col = colStart, colEnd, colIncr do
      grid[row][col] = line[count]
      count = count + 1
    end
  end
end

function love.keypressed( key, isrepeat )
  
  for row = 0, 5 do
    newGrid[row] = {}
  end

  for index = 1, 4 do
    currLine = extractLine( grid, key, index )
    newLine = collapse(currLine)
    pasteLine( newGrid, key, index, newLine )
  end

  -- Collect empty cells
  emptyCoords = {}
  for row = 1,4 do
    for col = 1,4 do
      if newGrid[row][col] == nil then
        table.insert(emptyCoords, { row, col })
      end
    end
  end

  isGameOver = false
  if table.getn(emptyCoords) == 0 then
    foundPair = false
    for row = 1, 4 do
      for col = 1, 4 do
        if newGrid[row][col] == newGrid[row][col+1] or 
           newGrid[row][col] == newGrid[row+1][col]
        then
          foundPair = true
        end
      end
    end
    isGameOver = not foundPair
  else
    -- Add 2 or 4 at random empty cell
    randomCoord = emptyCoords[ math.random( table.getn(emptyCoords) ) ]
    seed = math.random(6)
    if seed == 1 then
      newGrid[randomCoord[1]][randomCoord[2]] = 2
    else
      newGrid[randomCoord[1]][randomCoord[2]] = 1
    end
  end

  -- copy grid to new grid
  for row = 1,4 do
    for col = 1,4 do
      grid[row][col] = newGrid[row][col]
    end
  end 
end

function love.keyreleased( key, isrepeat)
end
