import socket
import sys
import json
import hiscore_handler      #MAKE CORRECT
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

    # GGGFF   G = game, F = function (Format of incoming string)

    if data[:3] == 'PAC' or '204':
        if data[4:5] == 'SE':
            sendScore(data[5:])
        elif data[4:5] == 'RS':
            requestGlobalScore(data[5:])
        elif data[4:5] == 'RO':
            requestOwnScore(data[5:])
        elif data[4:5] == 'QS':
            quickStart(data[5:])
        elif data[4:5] == 'SS':
            submitScore(data[5:])
        elif data[4:5] == 'FG':
            fetchGames(data[5:])
        elif data[4:5] == 'FS':
            fetchStatus(data[5:])
        elif data[4:5] == 'TG':
            terminateGame(data[5:])
        else:
           print 'Incorrect operation.'
    else:
        print'Incorrect game.'


    conn.close()    # When we are out of the loop, we're done, close