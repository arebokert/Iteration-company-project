require("model.pacman.dumper")
-- Define a shortcut function for testing
function dump(...)
  print(DataDumper(...), "\n---")
end

function checkCollision(x)

  pacman = x[1]
  blinky = x[2]
  
  if inRange(blinky.x + 1, pacman.x, pacman.x + 50) or inRange(pacman.x + 1, blinky.x, blinky.x + 50) then
    if inRange(blinky.y + 1, pacman.y, pacman.y + 50) or inRange(pacman.y + 1, blinky.y, blinky.y + 50) then
--      ADLogger.trace("KROCK")
      return true
    end
  end    
--  ADLogger.trace("INTE KROCK")
  
  return false
  
end

function inRange(compare, start, stop)

  if compare > start then
    if compare < stop then
      return true
    end
  end    
  return false
end