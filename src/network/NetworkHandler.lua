--
-- Created by IntelliJ IDEA.
-- User: Tomas
-- Date: 2015-11-12
-- Time: 13:39
-- To change this template use File | Settings | File Templates.
--
socket = require("socket")
local JSON = assert(loadfile "JSON.lua")()

connection = socket.tcp()

function sendJSON(JSONObject, operation)
    raw_json_text = operation..JSONObject
    result2 = assert(connection:send(object), "Message not delivered!")

end