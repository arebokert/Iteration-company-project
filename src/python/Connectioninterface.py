#!../server/bin/python

import socket
import threading
import SocketServer
import sys
import json
import Highscorehandler
import Game4096_multiplayer_handler
from database_handler import init_db


init_db()

#Sends the score to the high score handler where it is processed further.
#@param jsonObj a JSON object that contains the necessary information to add a high score.
def sendScore(jsonObj):
    return Highscorehandler.add_Highscore(jsonObj)

#Sends the score to the highscore handler where it is processed further.
#@param jsonObj a JSON object that contains the necessary information to get the global high score.
def requestGlobalScore(jsonObj):
    return Highscorehandler.get_global_highscore(jsonObj)

#Sends the score to the high score handler where it is processed further.
#@param jsonObj a JSON object that contains the necessary information to get the local high score.
def requestOwnScore(jsonObj):
    return Highscorehandler.get_highscore(jsonObj)

#TODO: implement according to the documentation
def quickStart(jsonObj):
    data = json.loads(jsonObj)
    # return hiscore_handler.function(data["macAddress"], data["playerName"], data["gameName"]) #MAKE CORRECT

#TODO: implement according to the documentation
def submitScore(jsonObj):
    data = json.loads(jsonObj)
    # return hiscore_handler.function(data["macAddress"], data["playerName"], data["matchID"], data["score"], data["gameName"]) #MAKE CORRECT

#TODO: implement according to the documentation
def fetchGames(jsonObj):
    data = json.loads(jsonObj)
    # return hiscore_handler.function(data[""]) #MAKE CORRECT

#TODO: implement according to the documentation
def fetchStatus(jsonObj):
    data = json.loads(jsonObj)
    # return hiscore_handler.function(data["macAddress"], data["playerName"], data["matchID"], data["gameName"]) #MAKE CORRECT

#TODO: implement according to the documentation
def terminateGame(jsonObj):
    data = json.loads(jsonObj)
    # return hiscore_handler.function(data["macAddress"], data["matchID"], data["gameName"]) #MAKE CORRECT

#TODO: implement according to the documentation
def fetchLastThree(jsonObj):
    data = json.loads(jsonObj)
    # return hiscore_handler.function(data["macAddress"], data["matchID"], data["gameName"]) #MAKE CORRECT

#Sends the playing field to the submit_box class for further processing.
#@param jsonObj a JSON object that contains the necessary information send the playing field.
def game4096MultiplayerSend(jsonObj):
    return Game4096_multiplayer_handler.submit_box(jsonObj)

#Requests a multi player opponent.
#@param jsonObj a JSON object that contains the necessary information send the playing field.
def game4096MultiplayerRequest(jsonObj):
    return Game4096_multiplayer_handler.request_box(jsonObj)

#Recives the input from the client and processes it according to what the 2 or 4 first characters are.
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
        elif data[:4] == 'GFMS':
            self.request.send(game4096MultiplayerSend(data[4:]))
        elif data[:4] == 'GFMR':
            self.request.send(game4096MultiplayerRequest(data[4:]))
        else:
            print 'Incorrect operation.'
        self.request.close()

#Creates a threaded TCP server
class ThreadedTCPServer(SocketServer.ThreadingMixIn, SocketServer.TCPServer):
    pass

#Main function that starts the server.
if __name__ == "__main__":

    # Port 0 means to select an arbitrary unused port
    #HOST, PORT = "localhost", 24069
    server = ThreadedTCPServer(('',24069), service) #ThreadedTCPServer((HOST, PORT), ThreadedTCPRequestHandler)
    server.serve_forever()