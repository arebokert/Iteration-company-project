--author: andth996

local utf8 = require("utf8")


 i = 1
 score=500
 loadbool=true

--The highscore object. Gamename is not currently in use.
Highscore = {playername = "", gamename = "", score = 0 }


--The constructor for the highscore-object
function Highscore:new (o)
      o = o or {}
      setmetatable(o, self)
      self.__index = self
      return o
    end
    


--Get the score from the game.
--Currently, the funciton only returns the global variable score+1000.
--Theres no reason for that, just a way to try the implementation.
function getScore()
score=score+1000

return score
end



--This function creates a highscore-object of the playername that has been typed in.
function newEntry(playername)

score = getScore();
a=Highscore:new()
a.playername=playername
a.score=score

insert(a,ArrayOfHighscores)

end


--Takes an array of highscores(objects) and saves the values to the highscore-file of the game
function save()

--THIS PATH PROBABLY HAS TO BE UPDATED! I encountered problems using relative paths

f = assert(io.open("Pacman.txt", "w"),"File does not exist!")

i=1
while ArrayOfHighscores[i] do

f:write(ArrayOfHighscores[i].playername," ",ArrayOfHighscores[i].score,"\n")
i=i+1
end

f:close()
end


--Inserts a highscore into an array of highscores, so that highscores will have a descending order
function insert(a,ArrayOfHighscores)

if ArrayOfHighscores[1]==nil then
ArrayOfHighscores[1]=a

else
i=1

while ArrayOfHighscores[i].score>a.score do
i=i+1

if(ArrayOfHighscores[i]==nil) then break end

end

table.insert(ArrayOfHighscores,i,a)

end

end




--Constructs highscore-objects from the highscore-file and stores them in an array in a descending order, which the function returns

function load()
--THIS PATH PROBABLY HAS TO BE UPDATED! I encountered problems using relative paths
f = assert(io.open("Pacman.txt", "r"),"File does not exist!")

--Declaring line as non-nil so that the while-loop below can start
line="a"
ArrayOfHighscores={}

i=1
while line do
line=f:read("*line")
if line==nil then break end

name = (string.match(line, "%a+"))

number = tonumber(string.match(line, "%d+"))

a=Highscore:new()
a.playername=name
a.score=number

if line==nil then break end
insert(a,ArrayOfHighscores)
i=i+1

end

return ArrayOfHighscores
end


--The reason for using the boolean is to ensure that highscores are only loaded once.
if loadbool==true then
ArrayOfHighscores =load()
loadbool=false
end


function love.load()
       text = ""

    -- enable key repeat so backspace can be held down to trigger love.keypressed multiple times.
    love.keyboard.setKeyRepeat(true)
end
 
function love.textinput(t)
    text = text .. t
end
 
function love.keypressed(key)
    if key == "backspace" then
        -- get the byte offset to the last UTF-8 character in the string.
        local byteoffset = utf8.offset(text, -1)

        if byteoffset then
            -- remove the last UTF-8 character.
            -- string.sub operates on bytes rather than UTF-8 characters, so we couldn't do string.sub(text, 1, -2).
            text = string.sub(text, 1, byteoffset - 1)
        end
        end
    
    --Choosing 9 is arbitrary
    if key == "9" then
    text=string.sub(text,1,-1)
    newEntry(text)
    end
    
    --Choosing 8 is also arbitrary
    if key == "8" then
   --Saves the array to the file
   save()
   --Exits the program
   os.exit()
    end
end
 
function love.draw()
    Message ="Welcome! Press 9 to save your name and 8 to quit the program. Please enter your name: "
    emptyMessage=""
    HighscoreMessage="Highscores:"
    HighscoreMessage2="Name:     Score:"
    
    love.graphics.printf(Message, 0, 0, love.graphics.getWidth())
    love.graphics.printf(text, 0, 20, love.graphics.getWidth())
    love.graphics.printf(emptyMessage, 0, 40, love.graphics.getWidth())
    love.graphics.printf(HighscoreMessage, 0, 60, love.graphics.getWidth())
    love.graphics.printf(HighscoreMessage2, 0, 80, love.graphics.getWidth())

    for k,v in pairs(ArrayOfHighscores) do
    love.graphics.printf(v.playername.." "..v.score, 0, (k+4)*20, love.graphics.getWidth())
    end
end
