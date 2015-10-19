Game = {
  current_state =0,
  current_table = {
  
  }
  
}
function Game.registerKey(key, state)
    if state == "down" then
      if key == "up" then   --move every number to top
      elseif key == "down" then
      elseif key == "left" then
      elseif key == "right" then
      end
    end
end

function Game.showPicture()
end

function Game.searchRow()
end

function Game.searchCol()
end

function Game.moveNumber()
end

function Game.getRandomNumber()
  bg_pos = {x = 400, y=100}
  bg = gfx.loadpng('cell_img/1024.png') 
  screen:copyfrom(bg, {w=625,h=625}, bg_pos,true)
end

function Game.addTwoNumber()
end

return Game