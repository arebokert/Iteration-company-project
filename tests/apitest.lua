luaunit = require('luaunit')

--local function main()
  --print("hello world")

--end
--main()

--os.exit(luaunit.LuaUnit.run())

-- Unit testing starts
function add(v1,v2)
    -- add positive numbers
    -- return 0 if any of the numbers are 0
    -- error if any of the two numbers are negative
    if v1 < 0 or v2 < 0 then
        error('Can only add positive or null numbers, received '..v1..' and '..v2)
    end
    if v1 == 0 or v2 == 0 then
        return 0
    end
    return v1+v2
end

function testAddPositive()
    luaunit.assertEquals(add(1,1),2)
end

function testAddZero()
    luaunit.assertEquals(add(1,0),0)
    luaunit.assertEquals(add(0,5),0)
    luaunit.assertEquals(add(0,0),0)
end

os.exit( luaunit.LuaUnit.run() )


--luaunit = require('luaunit')
--
--local pathOfThisFile = ...
--local folderOfThisFile = (...):match("(.-)[^%.]+$")
----local oneFolderUp = folderOfThisFile:match("(.-)[^%.]+$")
--
---- this gives nil value on onefolderup it seems.
---- gfx = require(oneFolderUp .. "src/SDK.Simulator.gfx")
--
--function apitest()
--
---- gfx.update()
--luaunit.assertEquals(folderOfThisFile,"/tests")
--
--end
--
--os.exit( luaunit.LuaUnit.run() )
