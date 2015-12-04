socket = require("socket")

NH = {}

HOST = "2015-1.pumi.ida.liu.se"
PORT = 24069
invalidInput = "Invalid input"

    -- Convert the request to the designated prefix which can be found at
    -- https://docs.google.com/document/d/1OL8HuOFtW8QYHnB0PQ8q-LNm7j-zkNURJ7ER75IaMkk/edit
    -- @param request - the request to be exectued.
function NH.convertRequestToPrefix(request)
    if request == "QuickStart" then
        return "QS"
    elseif request == "SubmitScore" then
        return "SS"
    elseif request == "FetchLastThree" then
        return "LR/M"
    elseif request == "FetchStatus" then
        return "FS"
    elseif request == "TerminateMatch" then
        return "TM"
    elseif request == "SendScore" then
        return "SE"
    elseif request == "RequestReadGlobalScore" then
        return "RS"
    elseif request == "RequestReadYourOwnScore" then
        return "RO"
    elseif request == "4096MultiPlayerSubmit" then
        return "GFMS" --For "Game Fourtynintysix Multiplayer Submit"
    elseif request == "4096MultiPlayerRequest" then
        return "GFMR" --For "Game Fourtynintysix Multiplayer Submit"
    else
        return invalidInput
    end
end

    -- Send JSONObject with an operation to server.
    -- Returns the response from the server. The content of the object which is returned
    -- depends on the request sent.
    -- @param JSONObject - the JSON object to be sent to the server.
    -- @param the request to be executed.
    -- If not connection is found the string "No connection" is returned.
function NH.sendJSON(JSONObject, request)

    local serverResponse = "No connection"

    if hasInternet then
        ADLogger.trace("Internet connection exists")
        -- Retrieves the abreviation for the operation
        requestPrefix = NH.convertRequestToPrefix(request)
        if requestPrefix == invalidInput then
            return invalidInput
        else
            -- Connect to the server
            connection = socket.tcp()
            connection:settimeout(1000)
            assert(connection:connect(HOST, PORT), "Connection failed!")
            -- Concatenates the operation with the JSONObject
            object = requestPrefix .. JSONObject
            -- Sends the object to the server
            assert(connection:send(object), "Object could not be delivered!")
            serverResponse = connection:receive('*a')
            -- Closes the connection
            connection:close()
            return serverResponse
        end
    else
        return serverResponse
    end
end


    -- Returns the MAC adress of the unit.
function NH.getMAC()
    -- Will currently use a mock-up of the MAC.
    return 001
end

return NH