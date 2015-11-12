import socket
import sys
import json
import Highscorehandler
import multiplayer_handler  #MAKE CORRECT

def sendScore(jsonObj):
    j = json.loads(jsonObj)
    hiscore_handler.function(j)  #MAKE CORRECT

def requestGlobalScore(jsonObj):
    j = json.loads(jsonObj)
    hiscore_handler.function(j) #MAKE CORRECT

def requestOwnScore(jsonObj):
    j = json.loads(jsonObj)
    hiscore_handler.function(j) #MAKE CORRECT

def quickStart(jsonObj):
    j = json.loads(jsonObj)
    hiscore_handler.function(j) #MAKE CORRECT

def submitScore(jsonObj):
    j = json.loads(jsonObj)
    hiscore_handler.function(j) #MAKE CORRECT

def fetchGames(jsonObj):
    j = json.loads(jsonObj)
    hiscore_handler.function(j) #MAKE CORRECT

def fetchStatus(jsonObj):
    j = json.loads(jsonObj)
    hiscore_handler.function(j) #MAKE CORRECT

def terminateGame(jsonObj):
    j = json.loads(jsonObj)
    hiscore_handler.function(j) #MAKE CORRECT


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
        sendScore(data[2:])
    elif data[:2] == 'RS':
        requestGlobalScore(data[2:])
    elif data[:2] == 'RO':
        requestOwnScore(data[2:])
    elif data[:2] == 'QS':
        quickStart(data[2:])
    elif data[:2] == 'SS':
        submitScore(data[2:])
    elif data[:2] == 'FG':
        fetchGames(data[2:])
    elif data[:2] == 'FS':
        fetchStatus(data[2:])
    elif data[:2] == 'TG':
        terminateGame(data[2:])
    else:
       print 'Incorrect operation.'


    conn.close()    # When we are out of the loop, we're done, close