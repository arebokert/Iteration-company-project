socket = require("socket")

function convertRequestToPrefix(request)
    if request == "QuickStart" then
        return "QS"
    else if request == "SubmitScore" then
        return "SS"
    else if request == "FetchCurrentGames" then
        return "FG"
    else if request == "FetchStatus" then
        return "FS"
    else if request == "TerminateGame" then
        return "TG"
    else if request == "SendScore" then
        return "SE"
    else if request == "RequestReadGlobalScore" then
        return "RS"
    else if request == "RequestReadYourOwnScore" then
        return "RO"
    else
        return error("Invalid input")
    end
end

function sendJSON(JSONObject, request)

    --Retrieves the abreviation for the operation
    requestPrefix = convertRequestToPrefix(request)

    if requestPrefix == "Invalid input" then
        error("Invalid operation input!")
    end

    --Connect to the server
    connection = socket.tcp()
    connection:settimeout(1000)
    assert(connection:connect("2015-1.pumi.ida.liu.se", 24069), "Connection failed!")

    -- Concatenates the operation with the JSONObject
    object = requestPrefix .. JSONObject

    --Sends the object to the server
    assert(connection:send(object), "Object could not be delivered!")

    --Closes the connection
    connection:close()
end