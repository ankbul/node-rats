SocketListener = require('./socket_listener').SocketListener
HttpListener = require('./http_listener').HttpListener

class Listener
  @listen: ->
    new SocketListener().listen()
    new HttpListener().listen()

exports.Listener = Listener