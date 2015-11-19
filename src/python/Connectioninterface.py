import socket
import sys
import json
#import Highscorehandler
#import multiplayer_handler  #MAKE CORRECT

def sendScore(jsonObj):
    data = json.loads(jsonObj)
    #hiscore_handler.function(data["macAddress"], data["score"], data["playerName"], data["gameName"])  #MAKE CORRECT
    return 'SE'

def requestGlobalScore(jsonObj):
    data = json.loads(jsonObj)
    #return hiscore_handler.function(data["gameName"], data["playerName"], data["macAddress"]) #MAKE CORRECT

def requestOwnScore(jsonObj):
    data = json.loads(jsonObj)
    #return hiscore_handler.function(data["macAddress"], data["gameName"]) #MAKE CORRECT

def quickStart(jsonObj):
    data = json.loads(jsonObj)
    # return hiscore_handler.function(data["macAddress"], data["playerName"], data["gameName"]) #MAKE CORRECT

def submitScore(jsonObj):
    data = json.loads(jsonObj)
    #return hiscore_handler.function(data["macAddress"], data["playerName"], data["matchID"], data["score"], data["gameName"]) #MAKE CORRECT

def fetchGames(jsonObj):
    data = json.loads(jsonObj)
    #return hiscore_handler.function(data[""]) #MAKE CORRECT

def fetchStatus(jsonObj):
    data = json.loads(jsonObj)
    #return hiscore_handler.function(data["macAddress"], data["playerName"], data["matchID"], data["gameName"]) #MAKE CORRECT

def terminateGame(jsonObj):
    data = json.loads(jsonObj)
    #return hiscore_handler.function(data["macAddress"], data["matchID"], data["gameName"]) #MAKE CORRECT



while True:
    HOST = ''   # Symbolic name meaning the local host
    PORT = 24069    # Arbitrary non-privileged port
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)   # Creates socket
    s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)

    try:
        s.bind((HOST, PORT))    # Waits for bind from client
    except socket.error, msg:
        print 'Bind failed. Error code: ' + str(msg[0]) + 'Error message: ' + msg[1]
        sys.exit()  # Maybe not exist but restart?

    s.listen(1)     # Listening to socket

    # Accept the connection once (for starter)
    (conn, addr) = s.accept()   # Creates a conn, a connection to send data and addr, the address bound to the socket

    # RECEIVE DATA
    data = conn.recv(1024)


    # FF   F = function (Format of incoming string)

    if data[:2] == 'SE':
        conn.send(sendScore(data[2:]))
    elif data[:2] == 'RS':
        conn.send(requestGlobalScore(data[2:]))
    elif data[:2] == 'RO':
        conn.send(requestOwnScore(data[2:]))
    elif data[:2] == 'QS':
        conn.send(quickStart(data[2:]))
    elif data[:2] == 'SS':
        conn.send(submitScore(data[2:]))
    elif data[:2] == 'FG':
        conn.send(fetchGames(data[2:]))
    elif data[:2] == 'FS':
        conn.send(fetchStatus(data[2:]))
    elif data[:2] == 'TG':
        conn.send(terminateGame(data[2:]))
    else:
       print 'Incorrect operation.'


    conn.close()    # When we are out of the loop, we're done, close