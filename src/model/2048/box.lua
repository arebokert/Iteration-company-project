Boxes = {
  current_score = 0,
  tag =0,
  current_zero = 16,
  box_table = {
               0,0,0,0,
               0,0,0,0,
               0,0,0,0,
               0,0,0,0
              }
}

function Boxes.init()
   Boxes.addRandomNumber()
   Boxes.addRandomNumber()
   Boxes.showMove()
end

function Boxes.showMove()
  for i = 1, 4 do
    for j = 0, 3 do
      bg_pos = {x = i*100+300, y=j*100+100}
      if(Boxes.box_table[i+j*4] == 0) then
        img = "cell_img/empty.png"
      else
        img = "cell_img/" .. Boxes.box_table[i+j*4] .. ".png"
      end
      bg = gfx.loadpng(img) 
      screen:copyfrom(bg, {w = 625,h = 625},bg_pos,true)
    end
  end
  gfx.update() 
end

function Boxes.addRandomNumber()
   random_number = math.random(1,2)*2
   random_place = math.random(Boxes.current_zero)
   current_loop_zero = 0
   for i = 1, 16 do
      if(Boxes.box_table[i] == 0) then
        current_loop_zero = current_loop_zero +1
      end
      if(current_loop_zero == random_place) then
        Boxes.box_table[i] = random_number
      end
   end
   Boxes.current_zero = Boxes.current_zero + 1
end

function Boxes.endGame()
  ADLogger.trace("Game Over")
end

function Boxes.moveLeft()
  for i =0, 3 do
  --add first and then go left
   if(Boxes.box_table[1+i*4]~= 0 and Boxes.box_table[1+i*4] == Boxes.box_table[2+i*4]) then
      Boxes.box_table[1+i*4] = Boxes.box_table[1+i*4] *2
      Boxes.box_table[2+i*4] = 0
      Boxes.current_zero = Boxes.current_zero - 1
   end
   if(Boxes.box_table[2+i*4] ~= 0 and Boxes.box_table[2+i*4] == Boxes.box_table[3+i*4]) then
      Boxes.box_table[2+i*4] = Boxes.box_table[2+i*4] *2
      Boxes.box_table[3+i*4] = 0
      Boxes.current_zero = Boxes.current_zero - 1
   end
   if(Boxes.box_table[2+i*4] ~= 0 and Boxes.box_table[3+i*4] == Boxes.box_table[4+i*4]) then
      Boxes.box_table[3+i*4] = Boxes.box_table[3+i*4] *2
      Boxes.box_table[4+i*4] = 0
      Boxes.current_zero = Boxes.current_zero - 1
   end
    -- change palces, make a promise, no 0 is left of numbers
    count = 1 -- number of >= 0 
   for j =1, 4 do
     if(Boxes.box_table[j+i*4] ~= 0) then
       Boxes.box_table[count+i*4] = Boxes.box_table[j+i*4]
       count = count + 1
     end
   end
  end
  if current_zero ~= 0 then
    Boxes.addRandomNumber()
    Boxes.showMove()
  else
   Boxes.endGame()
  end
end

function Boxes.moveRight()
  for i =0, 3 do
  --add first and then go left
   if(Boxes.box_table[4+i*4]~= 0 and Boxes.box_table[4+i*4] == Boxes.box_table[3+i*4]) then
      Boxes.box_table[4+i*4] = Boxes.box_table[4+i*4] *2
      Boxes.box_table[3+i*4] = 0
      Boxes.current_zero = Boxes.current_zero - 1
   end
   if(Boxes.box_table[3+i*4] ~= 0 and Boxes.box_table[3+i*4] == Boxes.box_table[2+i*4]) then
      Boxes.box_table[3+i*4] = Boxes.box_table[3+i*4] *2
      Boxes.box_table[2+i*4] = 0
      Boxes.current_zero = Boxes.current_zero - 1
   end
   if(Boxes.box_table[2+i*4] ~= 0 and Boxes.box_table[2+i*4] == Boxes.box_table[1+i*4]) then
      Boxes.box_table[2+i*4] = Boxes.box_table[2+i*4] *2
      Boxes.box_table[1+i*4] = 0
      Boxes.current_zero = Boxes.current_zero - 1
   end
    -- change palces, make a promise, no 0 is left of numbers
    count = 4 -- number of >= 0 
   for j =4, 1, -1 do
     if(Boxes.box_table[j+i*4] ~= 0) then
       Boxes.box_table[count+i*4] = Boxes.box_table[j+i*4]
       count = count - 1
     end
   end
  end
  if current_zero ~= 0 then
    Boxes.addRandomNumber()
    Boxes.showMove()
  else
   Boxes.endGame()
  end
end

function Boxes.moveTop()
  for i =1, 4 do
  --add first and then go left
  if(Boxes.box_table[i]~= 0 and Boxes.box_table[i] == Boxes.box_table[i+4]) then
      Boxes.box_table[i] = Boxes.box_table[i] *2
      Boxes.box_table[i+4] = 0
      Boxes.current_zero = Boxes.current_zero - 1
   end
   if(Boxes.box_table[i+4]~= 0 and Boxes.box_table[i+4] == Boxes.box_table[i+2*4]) then
      Boxes.box_table[i+4] = Boxes.box_table[i+4] *2
      Boxes.box_table[i+2*4] = 0
      Boxes.current_zero = Boxes.current_zero - 1
   end
   if(Boxes.box_table[i+2*4] ~= 0 and Boxes.box_table[i+2*4] == Boxes.box_table[i+3*4]) then
      Boxes.box_table[i+2*4] = Boxes.box_table[i+2*4] *2
      Boxes.box_table[i+3*4] = 0
      Boxes.current_zero = Boxes.current_zero - 1
   end
    -- change palces, make a promise, no 0 is left of numbers
   count = 0 -- number of >= 0 
   for j =0, 3 do
     if(Boxes.box_table[i+j*4] ~= 0) then
       Boxes.box_table[i+count*4] = Boxes.box_table[i+j*4]
       count = count + 1
     end
   end
  end
  if current_zero ~= 0 then
    Boxes.addRandomNumber()
    Boxes.showMove()
  else
   Boxes.endGame()
  end
end

function Boxes.moveBottom()
  for i =1, 4 do
    if(Boxes.box_table[i+3*4] ~= 0 and Boxes.box_table[i+3*4] == Boxes.box_table[i+2*4]) then
        Boxes.box_table[i+3*4] = Boxes.box_table[i+3*4] *2
        Boxes.box_table[i+2*4] = 0
        Boxes.current_zero = Boxes.current_zero - 1
    end
    if(Boxes.box_table[i+2*4] ~= 0 and Boxes.box_table[i+2*4] == Boxes.box_table[i+4]) then
        Boxes.box_table[i+2*4] = Boxes.box_table[i+2*4] *2
        Boxes.box_table[i+4]= 0
        Boxes.current_zero = Boxes.current_zero - 1
    end
    if(Boxes.box_table[i+4] ~= 0 and Boxes.box_table[i+4] == Boxes.box_table[i]) then
        Boxes.box_table[i+4] = Boxes.box_table[i+4] *2
        Boxes.box_table[i] = 0
        Boxes.current_zero = Boxes.current_zero - 1
    end
    -- change palces, make a promise, no 0 is left of numbers
     count = 3 -- number of >= 0 
     for j =3,1,-1 do
       if(Boxes.box_table[i+j*4] ~= 0) then
         Boxes.box_table[i+count*4] = Boxes.box_table[i+j*4]
         count = count - 1
       end
     end
  end
  if current_zero ~= 0 then
    Boxes.addRandomNumber()
    Boxes.showMove()
  else
   Boxes.endGame()
  end
end 

return Boxes