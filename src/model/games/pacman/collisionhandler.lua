--This function checks whether two object with a block size has collided (preferably rewritten to work with all objects)
--@param: player1 - the first player that is to be checked for collision
--@param: player1 - the second player that is to be checked for collision
--return: true if collison
--return: false if no collison
function checkCollision(player1, player2)
  local block = 25
  if inRange(player2.x + 1, player1.x, player1.x + block) or inRange(player1.x + 1, player2.x, player2.x + block) then
    if inRange(player2.y + 1, player1.y, player1.y + block) or inRange(player1.y + 1, player2.y, player2.y + block) then
      return true
    end
  end    
  return false
end

--This function checks if one number is in a range (strict comparison)
--@param compare: the number to be checked if in range
--@param start: lower boundary of range
--@param stop: upper boundary of range
function inRange(compare, start, stop)

  if compare > start then
    if compare < stop then
      return true
    end
  end    
  return false
end