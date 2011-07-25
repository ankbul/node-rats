express = require 'express'
socket = require 'socket.io'

Listener = require('./lib/listeners/listener').Listener
SocketClient = require('./lib/client/socket_client').SocketClient

config =
  redis:
    port: 6379
    host: '127.0.0.1'
  express:
    port: 3000
  socket:
    port: 3030

Listener.listen()


# set up client
app = express.createServer();
app.use express.static __dirname + '/public'
app.listen(config.express.port)


# set up websocket input

socketClient = new SocketClient config.socket.port
socketClient.listen()



