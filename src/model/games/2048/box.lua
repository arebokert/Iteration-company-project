--------------------------------------------------------------------
--class: Boxes                                              --------
--description: load the 2048 each number box                --------
--last modified Nov 29, 2015                                --------
--------------------------------------------------------------------
--
Boxes = {
  tag = {},   -- end game tag
  current_zero = 16,  -- default 16 numbers = 0
  box_table = {       -- default numbers in the table
               0,0,0,0,
               0,0,0,0,
               0,0,0,0,
               0,0,0,0
              },
  box_img = {},       -- store the imgs of box
  each_square_2048 = 0,  -- set size of square box
  square_2048_margin = 0, -- set size of square box add margin
  box_start_x = 0,        -- start_x of box ( all the 16numbers)
  box_start_y = 0         -- start_y of box ( all the 16numbers) 
}

--------------------------------------------------------------------
--function: init                                            --------
--@param each_square, the size of each_square               --------
--@param box_start_x, the x of start point                  --------
--@param box_start_y, the y of start point                  --------
--description: init 16 number box                           --------
--last modified Nov 22, 2015                                --------
--------------------------------------------------------------------
function Boxes.init(each_square, box_start_x, box_start_y,flag)
   Boxes.loadAllImg()
   if(flag == 0) then        -- not resume
     Boxes.addRandomNumber()
     Boxes.addRandomNumber()
   end
   Boxes.setPosition(each_square, box_start_x, box_start_y)
   Boxes.showScore()
   Boxes.showMove()
    
end

function Boxes.clear()
  for j = 1, 16 do  
    Boxes.box_table[j] = 0
  end
end

--------------------------------------------------------------------
--function: setPosition                                     --------
--@param each_square, the size of each_square               --------
--@param box_start_x, the x of start point                  --------
--@param box_start_y, the y of start point                  --------
--description: init the position of 2048                    --------
--last modified Nov 22, 2015                                --------
--------------------------------------------------------------------
function Boxes.setPosition(each_square, box_start_x, box_start_y)
  Boxes.each_square_2048 = each_square
  Boxes.square_2048_margin = Boxes.each_square_2048 + 5
  Boxes.box_start_x = box_start_x
  Boxes.box_start_y = box_start_y
  
end

--------------------------------------------------------------------
--function: showScore                                       --------
--description: show the scores of 2048                      --------
--last modified Nov 29, 2015                                --------
--------------------------------------------------------------------
function Boxes.showScore()
  Score.printScore()
end

--------------------------------------------------------------------
--function: loadAllImg                                      --------
--description: load all imgs of numbers to box_img          --------
--last modified Nov 22, 2015                                --------
--------------------------------------------------------------------
function Boxes.loadAllImg()
  Boxes.box_img[0] = gfx.loadpng("views/2048/data/cell_img/empty.png")
  Boxes.box_img[2] = gfx.loadpng("views/2048/data/cell_img/2.png")
  Boxes.box_img[4] = gfx.loadpng("views/2048/data/cell_img/4.png")
  Boxes.box_img[8] = gfx.loadpng("views/2048/data/cell_img/8.png")
  Boxes.box_img[16] = gfx.loadpng("views/2048/data/cell_img/16.png")
  Boxes.box_img[32] = gfx.loadpng("views/2048/data/cell_img/32.png")
  Boxes.box_img[64] = gfx.loadpng("views/2048/data/cell_img/64.png")
  Boxes.box_img[128] = gfx.loadpng("views/2048/data/cell_img/128.png")
  Boxes.box_img[256] = gfx.loadpng("views/2048/data/cell_img/256.png")
  Boxes.box_img[512] = gfx.loadpng("views/2048/data/cell_img/512.png")
  Boxes.box_img[1024] = gfx.loadpng("views/2048/data/cell_img/1024.png")
  Boxes.box_img[2048] = gfx.loadpng("views/2048/data/cell_img/2048.png")
end

--------------------------------------------------------------------
--function: showMove                                        --------
--description: show the move of numbers after key function  --------
--last modified Nov 22, 2015                                --------
--------------------------------------------------------------------
function Boxes.showMove()
 local box_img = nil
  for j = 0, 3 do
    for i = 1, 4 do
      local bg_pos = {x = i*Boxes.square_2048_margin+Boxes.box_start_x, y=j*Boxes.square_2048_margin+Boxes.box_start_y, w= Boxes.each_square_2048, h = Boxes.each_square_2048}
      if(Boxes.box_table[i+j*4] == 0) then
        box_img = Boxes.box_img[0]
      else
        box_img = Boxes.box_img[Boxes.box_table[i+j*4]]
      end
      screen2048:copyfrom(box_img, nil,bg_pos,true)
    end
  end
  Boxes.showScore() 
  screen:copyfrom(screen2048,nil)
  gfx.update()
end

--------------------------------------------------------------------
--function: addRandomNumber                                 --------
--description: add random number two the 2048               --------
--last modified Nov 22, 2015                                --------
--------------------------------------------------------------------
function Boxes.addRandomNumber()
   local random_number = math.random(1,2)*2
   local random_place = math.random(Boxes.current_zero)
   local current_loop_zero = 0
   for i = 1, 16 do
      if(Boxes.box_table[i] == 0) then
        current_loop_zero = current_loop_zero +1
      end
      if(current_loop_zero == random_place) then 
        Boxes.box_table[i] = random_number
        Boxes.current_zero = Boxes.current_zero - 1
        current_loop_zero = 200
      end
   end
end

--------------------------------------------------------------------
--function: endGame                                         --------
--description: weather the game end of not                  --------
--last modified Nov 22, 2015                                --------
--------------------------------------------------------------------
function Boxes.endGame() 
  local result = Boxes.tag["left"] + Boxes.tag['right'] + Boxes.tag['top'] + Boxes.tag['bottom']
  if(result == 4) then
    ADLogger.trace("Game Over")
    screen2048:clear({r=50,g=20,b=30})
    local score = sys.new_freetype({g=0,r=100,b=0}, 70, {x=500,y=420},root_path.."views/mainmenu/data/font/Gidole-Regular.otf")
    score:draw_over_surface(screen2048,"GAME OVER")
    gfx.update()
    current_menu = "2048_game_over"
  end
end

--------------------------------------------------------------------
--function: moveLeft                                        --------
--description: key left                                     --------
--last modified Nov 22, 2015                                --------
--------------------------------------------------------------------
function Boxes.moveLeft()
  for i =0, 3 do
  --add first and then go left
   if(Boxes.box_table[1+i*4]~= 0 and Boxes.box_table[1+i*4] == Boxes.box_table[2+i*4]) then
      Boxes.box_table[1+i*4] = Boxes.box_table[1+i*4] *2
      Boxes.box_table[2+i*4] = 0
      Boxes.current_zero = Boxes.current_zero + 1
      Score.increaseScore(Boxes.box_table[1+i*4])
   end
   if(Boxes.box_table[2+i*4] ~= 0 and Boxes.box_table[2+i*4] == Boxes.box_table[3+i*4]) then
      Boxes.box_table[2+i*4] = Boxes.box_table[2+i*4] *2
      Boxes.box_table[3+i*4] = 0
      Boxes.current_zero = Boxes.current_zero + 1
      Score.increaseScore(Boxes.box_table[2+i*4])
   end
   if(Boxes.box_table[3+i*4] ~= 0 and Boxes.box_table[3+i*4] == Boxes.box_table[4+i*4]) then
      Boxes.box_table[3+i*4] = Boxes.box_table[3+i*4] *2
      Boxes.box_table[4+i*4] = 0
      Boxes.current_zero = Boxes.current_zero + 1
      Score.increaseScore(Boxes.box_table[3+i*4])
   end
    -- change palces, make a promise, no 0 is left of numbers
    local count = 1 -- number of >= 0 
   for j =1, 4 do
     if(Boxes.box_table[j+i*4] ~= 0) then
       Boxes.box_table[count+i*4] = Boxes.box_table[j+i*4]      
       if(count ~= j) then 
        Boxes.box_table[j+i*4] = 0
       end
       count = count + 1
     end
   end
  end
  if Boxes.current_zero ~= 0 then
    Boxes.tag["left"] = 0
    Boxes.addRandomNumber()
    Boxes.showMove()
  else
    --left is no way
    Boxes.tag["left"] = 1
    Boxes.endGame()
  end
end

--------------------------------------------------------------------
--function: moveRight                                       --------
--description: key right                                    --------
--last modified Nov 22, 2015                                --------
--------------------------------------------------------------------
function Boxes.moveRight()
  for i =0, 3 do
  --add first and then go left
   if(Boxes.box_table[4+i*4]~= 0 and Boxes.box_table[4+i*4] == Boxes.box_table[3+i*4]) then
      Boxes.box_table[4+i*4] = Boxes.box_table[4+i*4] *2
      Boxes.box_table[3+i*4] = 0
      Boxes.current_zero = Boxes.current_zero + 1
      Score.increaseScore(Boxes.box_table[4+i*4])
   end
   if(Boxes.box_table[3+i*4] ~= 0 and Boxes.box_table[3+i*4] == Boxes.box_table[2+i*4]) then
      Boxes.box_table[3+i*4] = Boxes.box_table[3+i*4] *2
      Boxes.box_table[2+i*4] = 0
      Boxes.current_zero = Boxes.current_zero + 1
      Score.increaseScore(Boxes.box_table[3+i*4])
   end
   if(Boxes.box_table[2+i*4] ~= 0 and Boxes.box_table[2+i*4] == Boxes.box_table[1+i*4]) then
      Boxes.box_table[2+i*4] = Boxes.box_table[2+i*4] *2
      Boxes.box_table[1+i*4] = 0
      Boxes.current_zero = Boxes.current_zero + 1
      Score.increaseScore(Boxes.box_table[2+i*4])
   end
    -- change palces, make a promise, no 0 is left of numbers
   local count = 4 -- number of >= 0 
   for j =4, 1, -1 do
     if(Boxes.box_table[j+i*4] ~= 0) then
       Boxes.box_table[count+i*4] = Boxes.box_table[j+i*4]
       if(count ~= j) then
         Boxes.box_table[j+i*4] = 0
       end
       count = count - 1
     end
   end
  end
  if Boxes.current_zero ~= 0 then
    Boxes.tag["right"] = 0
    Boxes.addRandomNumber()
    Boxes.showMove()
  else
   Boxes.tag["right"] = 1
   Boxes.endGame()
   
  end
end

--------------------------------------------------------------------
--function: moveTop                                         --------
--description: key top                                      --------
--last modified Nov 22, 2015                                --------
--------------------------------------------------------------------
function Boxes.moveTop()
  for i =1, 4 do
  --add first and then go left
  if(Boxes.box_table[i]~= 0 and Boxes.box_table[i] == Boxes.box_table[i+4]) then
      Boxes.box_table[i] = Boxes.box_table[i] *2
      Boxes.box_table[i+4] = 0
      Boxes.current_zero = Boxes.current_zero + 1
      Score.increaseScore(Boxes.box_table[i])
   end
   if(Boxes.box_table[i+4]~= 0 and Boxes.box_table[i+4] == Boxes.box_table[i+2*4]) then
      Boxes.box_table[i+4] = Boxes.box_table[i+4] *2
      Boxes.box_table[i+2*4] = 0
      Boxes.current_zero = Boxes.current_zero + 1
      Score.increaseScore(Boxes.box_table[i+4])
   end
   if(Boxes.box_table[i+2*4] ~= 0 and Boxes.box_table[i+2*4] == Boxes.box_table[i+3*4]) then
      Boxes.box_table[i+2*4] = Boxes.box_table[i+2*4] *2
      Boxes.box_table[i+3*4] = 0
      Boxes.current_zero = Boxes.current_zero + 1
      Score.increaseScore(Boxes.box_table[i+2*4])
   end
    -- change palces, make a promise, no 0 is left of numbers
   local count = 0 -- number of >= 0 
   for j =0, 3 do
     if(Boxes.box_table[i+j*4] ~= 0) then
       Boxes.box_table[i+count*4] = Boxes.box_table[i+j*4]
       if(count ~= j) then
          Boxes.box_table[i+j*4] = 0
       end
       count = count + 1
     end
   end
  end
  if Boxes.current_zero ~= 0 then
  Boxes.tag["top"] = 0
    Boxes.addRandomNumber()
    Boxes.showMove()
  else
   Boxes.tag["top"] = 1
   Boxes.endGame()
  end
end

--------------------------------------------------------------------
--function: moveBottom                                      --------
--description: key bottom                                   --------
--last modified Nov 22, 2015                                --------
--------------------------------------------------------------------
function Boxes.moveBottom()
  for i =1, 4 do
    if(Boxes.box_table[i+3*4] ~= 0 and Boxes.box_table[i+3*4] == Boxes.box_table[i+2*4]) then
        Boxes.box_table[i+3*4] = Boxes.box_table[i+3*4] *2
        Boxes.box_table[i+2*4] = 0
        Boxes.current_zero = Boxes.current_zero + 1
        Score.increaseScore(Boxes.box_table[i+3*4])
    end
    if(Boxes.box_table[i+2*4] ~= 0 and Boxes.box_table[i+2*4] == Boxes.box_table[i+4]) then
        Boxes.box_table[i+2*4] = Boxes.box_table[i+2*4] *2
        Boxes.box_table[i+4]= 0
        Boxes.current_zero = Boxes.current_zero + 1
        Score.increaseScore(Boxes.box_table[i+2*4])
    end
    if(Boxes.box_table[i+4] ~= 0 and Boxes.box_table[i+4] == Boxes.box_table[i]) then
        Boxes.box_table[i+4] = Boxes.box_table[i+4] *2
        Boxes.box_table[i] = 0
        Boxes.current_zero = Boxes.current_zero + 1
        Score.increaseScore(Boxes.box_table[i+4])
    end
    -- change palces, make a promise, no 0 is left of numbers
    local count = 3 -- number of >= 0 
     for j =3,0,-1 do
       if(Boxes.box_table[i+j*4] ~= 0) then
         Boxes.box_table[i+count*4] = Boxes.box_table[i+j*4]
         if(count ~= j) then
           Boxes.box_table[i+j*4] = 0
         end
         count = count - 1
       end
     end
  end
  if Boxes.current_zero ~= 0 then
    Boxes.tag["bottom"] = 0
    Boxes.addRandomNumber()
    Boxes.showMove()
  else
   Boxes.tag["bottom"] = 1
   Boxes.endGame()
  end
end 

return Boxes
