socket = require("socket")

function operationAbreviation(operation)

    if operation == "QuickStart" then
        return "QS"
    else if operation == "SubmitScore" then
        return "SS"
    else if operation == "FetchCurrentGames" then
            return "FG"
    else if operation == "FetchStatus" then
            return "FS"
    else if operation == "TerminateGame" then
        return "TG"
    else if operation == "SendScore" then
            return "SE"
    else if operation == "RequestReadGlobalScore" then
        return "RS"
    else if operation == "RequestReadYourOwnScore" then
        return "RO"
    else
        return error("Invalid input")
    end
end

function sendJSON(JSONObject, operation)

    --Retrieves the abreviation for the operation
    operation = operationAbreviation(operation)

    if operation == "Invalid input" then
        error("Invalid operation input!")
    end

    --Connect to the server
    connection = socket.tcp()
    connection:settimeout(1000)
    assert(connection:connect("2015-1.pumi.ida.liu.se", 24069), "Connection failed!")

    -- Concatenates the operation with the JSONObject
    object = operation .. JSONObject

    --Sends the object to the server
    assert(connection:send(object), "Object could not be delivered!")

    --Closes the connection
    connection:close()
end

