Boxes = require("box")
Game = {current = 0}

function Game.registerKey(key, state)
    if state == "down" then
      if key == "up" then   --move every number to top
        Boxes.moveTop()
      elseif key == "down" then
        Boxes.moveBottom()
      elseif key == "left" then
        Boxes.moveLeft()
      elseif key == "right" then
        Boxes.moveRight()
      end
    end
end

function Game.showMove()
  
end

function Game.startGame()
  Boxes.init()
end

return Game