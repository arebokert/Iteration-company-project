#!../server/bin/python

import socket
import threading
import SocketServer
import sys
import json
import Highscorehandler
from database_handler import init_db

init_db()
def sendScore(jsonObj):
    return Highscorehandler.add_Highscore(jsonObj)

def requestGlobalScore(jsonObj):
    return Highscorehandler.get_global_highscore(jsonObj)

def requestOwnScore(jsonObj):
    return Highscorehandler.get_highscore(jsonObj)

def quickStart(jsonObj):
    data = json.loads(jsonObj)
    # return hiscore_handler.function(data["macAddress"], data["playerName"], data["gameName"]) #MAKE CORRECT

def submitScore(jsonObj):
    data = json.loads(jsonObj)
    # return hiscore_handler.function(data["macAddress"], data["playerName"], data["matchID"], data["score"], data["gameName"]) #MAKE CORRECT

def fetchGames(jsonObj):
    data = json.loads(jsonObj)
    # return hiscore_handler.function(data[""]) #MAKE CORRECT

def fetchStatus(jsonObj):
    data = json.loads(jsonObj)
    # return hiscore_handler.function(data["macAddress"], data["playerName"], data["matchID"], data["gameName"]) #MAKE CORRECT

def terminateGame(jsonObj):
    data = json.loads(jsonObj)
    # return hiscore_handler.function(data["macAddress"], data["matchID"], data["gameName"]) #MAKE CORRECT

def fetchLastThree(jsonObj):
    data = json.loads(jsonObj)
    # return hiscore_handler.function(data["macAddress"], data["matchID"], data["gameName"]) #MAKE CORRECT


class service(SocketServer.BaseRequestHandler):

    def handle(self):
        data = self.request.recv(1024)

        if data[:2] == 'SE':
            self.request.send(sendScore(data[2:]))
        elif data[:2] == 'RS':
            self.request.send(requestGlobalScore(data[2:]))
        elif data[:2] == 'RO':
            self.request.send(requestOwnScore(data[2:]))
        elif data[:2] == 'QS':
            self.request.send(quickStart(data[2:]))
        elif data[:2] == 'SS':
            self.request.send(submitScore(data[2:]))
        elif data[:2] == 'FG':
            self.request.send(fetchGames(data[2:]))
        elif data[:2] == 'FS':
            self.request.send(fetchStatus(data[2:]))
        elif data[:2] == 'TG':
            self.request.send(terminateGame(data[2:]))
        elif data[:4] == 'LR/M':
            self.request.send(fetchLastThree(data[4:]))
        else:
            print 'Incorrect operation.'
        self.request.close()


class ThreadedTCPServer(SocketServer.ThreadingMixIn, SocketServer.TCPServer):
    pass

if __name__ == "__main__":

    # Port 0 means to select an arbitrary unused port
    #HOST, PORT = "localhost", 24069
    server = ThreadedTCPServer(('',24069), service) #ThreadedTCPServer((HOST, PORT), ThreadedTCPRequestHandler)
    server.serve_forever()