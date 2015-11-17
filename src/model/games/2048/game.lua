Boxes = require("model.games.2048.box")
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
      elseif key == "exit" then
        activeView = "menu"
        current_menu = "mainMenu"
        showmenu.loadMainMenu()
      end
    end
end

function Game.showMove()
  
end

function Game.showGamePage()
   screen:fill({r=10,g=5,b=50})
   screen:clear({r=0,g=205,b=204},{x=400,y=100,w = 415, h=415})
   -- draw rows
   for i =1, 4 do
     screen:clear({r=255,g=255,b=255},{x=400+(i-1)*100,y=100,w = 5, h=415})
   end
   
   for i =1, 4 do
     screen:clear({r=255,g=255,b=255},{x=400,y=100+(i-1)*100,w = 415, h=5})
   end
   
   screen:clear({r=255,g=255,b=255},{x=815,y=100,w = 5, h=420})
   screen:clear({r=255,g=255,b=255},{x=400,y=515,w = 420, h=4})
   
   gfx.update()
end

function Game.startGame()
 Game.showGamePage()
  Boxes.init()
end

return Game