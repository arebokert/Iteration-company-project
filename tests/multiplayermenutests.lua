package.path = package.path .. ";../src/?.lua"
root_path = package.path .. ";../src/"


EXPORT_ASSERT_TO_GLOBALS = true;

-- always start a test file with this line
require('luaunit') 

--Include mock SDK
ADLogger = require('SDK.Mocked.ADLogger')
ADLogger = require('SDK.Mocked.ADLogger')
gfx = require "SDK.Mocked.gfx"
surface = require "SDK.Mocked.surface"
player = require "SDK.Mocked.player"
freetype = require "SDK.Mocked.freetype"
sys = require "SDK.Mocked.sys"


require('model.multiplayermenu.multiplayermenu')


-- the acutal test function, test if subfunction runMultiplayerMenuFunctions doesn't cranch and return true
-- tests if any of the functions in multiplayermenu.lua crashes
function testCrashCollisionhandler() 
  assertTrue(runMultiplayerMenuFunctions())
end


-- runs all the functions in the multiplayermenu.lua
-- returns true if non of the functions crash
-- @return: true
function runMultiplayerMenuFunctions()
  value = multiModel:new()
  multiModel:setOptions("")
  value = multiModel:getOptions()
  value = multiModel:getSize()
  --value = multiModel:fetchPath()
  --value = multiModel:countFolders(folder)
  value = multiModel:fetchResults()
  return true
end

-- fetches results from multiplayer
-- compares the results from wonLost with the fetched the results 
function testfetchResults()
  resultset = multiModel:fetchResults()
  
  score1 = resultset[1]["score1"]
  indicator1 = resultset[1]["indicator1"]
  tempStr = countUserScore(score1)
  tempStr2 = countOpponentScore(score1)
  indi = wonLost(tempStr, tempStr2)
  assertEquals(indicator1, indi)
  
  score1 = resultset[1]["score2"]
  indicator1 = resultset[1]["indicator2"]
  tempStr = countUserScore(score1)
  tempStr2 = countOpponentScore(score1)
  indi = wonLost(tempStr, tempStr2)
  assertEquals(indicator1, indi)
  
  score1 = resultset[1]["score3"]
  indicator1 = resultset[1]["indicator3"]
  tempStr = countUserScore(score1)
  tempStr2 = countOpponentScore(score1)
  indi = wonLost(tempStr, tempStr2)
  assertEquals(indicator1, indi)
  
  score1 = resultset[2]["score1"]
  indicator1 = resultset[2]["indicator1"]
  tempStr = countUserScore(score1)
  tempStr2 = countOpponentScore(score1)
  indi = wonLost(tempStr, tempStr2)
  assertEquals(indicator1, indi)
  
  score1 = resultset[2]["score2"]
  indicator1 = resultset[2]["indicator2"]
  tempStr = countUserScore(score1)
  tempStr2 = countOpponentScore(score1)
  indi = wonLost(tempStr, tempStr2)
  assertEquals(indicator1, indi)
  
  score1 = resultset[2]["score3"]
  indicator1 = resultset[2]["indicator3"]
  tempStr = countUserScore(score1)
  tempStr2 = countOpponentScore(score1)
  indi = wonLost(tempStr, tempStr2)
  assertEquals(indicator1, indi)
  
    score1 = resultset[3]["score1"]
  indicator1 = resultset[3]["indicator1"]
  tempStr = countUserScore(score1)
  tempStr2 = countOpponentScore(score1)
  indi = wonLost(tempStr, tempStr2)
  assertEquals(indicator1, indi)
  
  score1 = resultset[3]["score2"]
  indicator1 = resultset[3]["indicator2"]
  tempStr = countUserScore(score1)
  tempStr2 = countOpponentScore(score1)
  indi = wonLost(tempStr, tempStr2)
  assertEquals(indicator1, indi)
  
  score1 = resultset[3]["score3"]
  indicator1 = resultset[3]["indicator3"]
  tempStr = countUserScore(score1)
  tempStr2 = countOpponentScore(score1)
  indi = wonLost(tempStr, tempStr2)
  assertEquals(indicator1, indi)
end

-- returns users score into an integer
function countUserScore(score1)
  cnt = 0
  tempStr = ""
  
  -- run thru the score string and put users result in tempStr 
  for i=1, #score1 do
  tempChar = string.sub(score1,i,i)
  if (tempChar == " ") then
    break  
  end
  tempStr = tempStr..tempChar  
  cnt = cnt+1
  end
  return tempStr
end

-- returns oppnent score into an integer
function countOpponentScore(score1)
  cnt=#score1
  tempStr2 = ""
  -- run thru the score string in reverse and put opponets result in tempStr2
  for i=cnt, 1, -1 do
    tempChar2 = string.sub(score1,i,i)
      if (tempChar2 == " ") then
       break  
      end
    tempStr2 = tempStr2..tempChar2  
    cnt = cnt-1
  end
  tempStr2 = string.reverse(tempStr2)
  return tempStr2
end


-- fetches the results from multiplayer and checks that a match has the correct indicator
function wonLost(tempStr, tempStr2)
  
  if (tempStr ~= "No") then
    userScore = tonumber(tempStr)
    opponentScore = tonumber(tempStr2)
  if (userScore > opponentScore)then
  return "w"
  elseif (userScore < opponentScore) then
  return "l"
  elseif (userScore == opponentScore) then
  return "d"
  end
  else
  return "n"
  end
  
end



-- always end a test file with this line
os.exit( LuaUnit.run() )