Boxes = {
  current_score = 0,
  tag = {},
  current_zero = 16,
  box_table = {
               0,0,0,0,
               0,0,0,0,
               0,0,0,0,
               0,0,0,0
              },
  box_img = {}
}

function Boxes.init()
   Boxes.loadAllImg()
   Boxes.addRandomNumber()
   Boxes.addRandomNumber()
   Boxes.showScore() 
   Boxes.showMove()
    
end

function Boxes.showScore()
  local score_font = sys.new_freetype({g=100,r=100,b=100}, 60, {x=900,y=50},root_path .."views/mainmenu/data/font/Gidole-Regular.otf")
  score_font:draw_over_surface(screen,"Score:")
  screen:clear({r=245,g=245,b=245}, {x=950,y = 120, w=150, h =100})
  local score = sys.new_freetype({g=10,r=10,b=10}, 50, {x=950,y=120},root_path .. "views/mainmenu/data/font/Gidole-Regular.otf")
  score:draw_over_surface(screen,Boxes.current_score)
  
end

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

function Boxes.showMove()
  for j = 0, 3 do
    for i = 1, 4 do
      bg_pos = {x = i*102+305, y=j*105+102, w= 100, h =100}
      if(Boxes.box_table[i+j*4] == 0) then
        box_img = Boxes.box_img[0]
      else
        box_img = Boxes.box_img[Boxes.box_table[i+j*4]]
      end
      screen:copyfrom(box_img, nil,bg_pos,true)
    end
  end
  Boxes.showScore() 
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
        Boxes.current_zero = Boxes.current_zero - 1
        current_loop_zero = 200
      end
   end
end

function Boxes.endGame() 
  result = Boxes.tag["left"] + Boxes.tag['right'] + Boxes.tag['top'] + Boxes.tag['bottom']
  ADLogger.trace(Boxes.tag["left"])
ADLogger.trace(Boxes.tag["right"])
ADLogger.trace(Boxes.tag["top"])
ADLogger.trace(Boxes.tag["bottom"])
  if(result == 4) then
    ADLogger.trace("Game Over")
    screen:clear({r=50,g=20,b=30})
    local score = sys.new_freetype({g=0,r=100,b=0}, 70, {x=500,y=420},root_path.."views/mainmenu/data/font/Gidole-Regular.otf")
    score:draw_over_surface(screen,"GAME OVER")
    gfx.update()
    current_menu = "2048_game_over"
  end
end

function Boxes.moveLeft()
  for i =0, 3 do
  --add first and then go left
   if(Boxes.box_table[1+i*4]~= 0 and Boxes.box_table[1+i*4] == Boxes.box_table[2+i*4]) then
      Boxes.box_table[1+i*4] = Boxes.box_table[1+i*4] *2
      Boxes.box_table[2+i*4] = 0
      Boxes.current_zero = Boxes.current_zero + 1
      Boxes.current_score = Boxes.current_score +Boxes.box_table[1+i*4]
   end
   if(Boxes.box_table[2+i*4] ~= 0 and Boxes.box_table[2+i*4] == Boxes.box_table[3+i*4]) then
      Boxes.box_table[2+i*4] = Boxes.box_table[2+i*4] *2
      Boxes.box_table[3+i*4] = 0
      Boxes.current_zero = Boxes.current_zero + 1
      Boxes.current_score = Boxes.current_score +Boxes.box_table[2+i*4]
   end
   if(Boxes.box_table[3+i*4] ~= 0 and Boxes.box_table[3+i*4] == Boxes.box_table[4+i*4]) then
      Boxes.box_table[3+i*4] = Boxes.box_table[3+i*4] *2
      Boxes.box_table[4+i*4] = 0
      Boxes.current_zero = Boxes.current_zero + 1
      Boxes.current_score = Boxes.current_score +Boxes.box_table[3+i*4]
   end
    -- change palces, make a promise, no 0 is left of numbers
    count = 1 -- number of >= 0 
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

function Boxes.moveRight()
  for i =0, 3 do
  --add first and then go left
   if(Boxes.box_table[4+i*4]~= 0 and Boxes.box_table[4+i*4] == Boxes.box_table[3+i*4]) then
      Boxes.box_table[4+i*4] = Boxes.box_table[4+i*4] *2
      Boxes.box_table[3+i*4] = 0
      Boxes.current_zero = Boxes.current_zero + 1
      Boxes.current_score = Boxes.current_score +Boxes.box_table[4+i*4]
   end
   if(Boxes.box_table[3+i*4] ~= 0 and Boxes.box_table[3+i*4] == Boxes.box_table[2+i*4]) then
      Boxes.box_table[3+i*4] = Boxes.box_table[3+i*4] *2
      Boxes.box_table[2+i*4] = 0
      Boxes.current_zero = Boxes.current_zero + 1
      Boxes.current_score = Boxes.current_score +Boxes.box_table[3+i*4]
   end
   if(Boxes.box_table[2+i*4] ~= 0 and Boxes.box_table[2+i*4] == Boxes.box_table[1+i*4]) then
      Boxes.box_table[2+i*4] = Boxes.box_table[2+i*4] *2
      Boxes.box_table[1+i*4] = 0
      Boxes.current_zero = Boxes.current_zero + 1
      Boxes.current_score = Boxes.current_score +Boxes.box_table[2+i*4]
   end
    -- change palces, make a promise, no 0 is left of numbers
   count = 4 -- number of >= 0 
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

function Boxes.moveTop()
  for i =1, 4 do
  --add first and then go left
  if(Boxes.box_table[i]~= 0 and Boxes.box_table[i] == Boxes.box_table[i+4]) then
      Boxes.box_table[i] = Boxes.box_table[i] *2
      Boxes.box_table[i+4] = 0
      Boxes.current_zero = Boxes.current_zero + 1
      Boxes.current_score = Boxes.current_score +Boxes.box_table[i]
   end
   if(Boxes.box_table[i+4]~= 0 and Boxes.box_table[i+4] == Boxes.box_table[i+2*4]) then
      Boxes.box_table[i+4] = Boxes.box_table[i+4] *2
      Boxes.box_table[i+2*4] = 0
      Boxes.current_zero = Boxes.current_zero + 1
      Boxes.current_score = Boxes.current_score +Boxes.box_table[i+4]
   end
   if(Boxes.box_table[i+2*4] ~= 0 and Boxes.box_table[i+2*4] == Boxes.box_table[i+3*4]) then
      Boxes.box_table[i+2*4] = Boxes.box_table[i+2*4] *2
      Boxes.box_table[i+3*4] = 0
      Boxes.current_zero = Boxes.current_zero + 1
      Boxes.current_score = Boxes.current_score +Boxes.box_table[i+2*4]
   end
    -- change palces, make a promise, no 0 is left of numbers
   count = 0 -- number of >= 0 
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

function Boxes.moveBottom()
  for i =1, 4 do
    if(Boxes.box_table[i+3*4] ~= 0 and Boxes.box_table[i+3*4] == Boxes.box_table[i+2*4]) then
        Boxes.box_table[i+3*4] = Boxes.box_table[i+3*4] *2
        Boxes.box_table[i+2*4] = 0
        Boxes.current_zero = Boxes.current_zero + 1
        Boxes.current_score = Boxes.current_score + Boxes.box_table[i+3*4]
    end
    if(Boxes.box_table[i+2*4] ~= 0 and Boxes.box_table[i+2*4] == Boxes.box_table[i+4]) then
        Boxes.box_table[i+2*4] = Boxes.box_table[i+2*4] *2
        Boxes.box_table[i+4]= 0
        Boxes.current_zero = Boxes.current_zero + 1
        Boxes.current_score = Boxes.current_score + Boxes.box_table[i+2*4]
    end
    if(Boxes.box_table[i+4] ~= 0 and Boxes.box_table[i+4] == Boxes.box_table[i]) then
        Boxes.box_table[i+4] = Boxes.box_table[i+4] *2
        Boxes.box_table[i] = 0
        Boxes.current_zero = Boxes.current_zero + 1
        Boxes.current_score = Boxes.current_score + Boxes.box_table[i+4]
    end
    -- change palces, make a promise, no 0 is left of numbers
     count = 3 -- number of >= 0 
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
