TcpListener = require('./tcp_listener').TcpListener
HttpListener = require('./http_listener').HttpListener

class Listener
  @listen: ->
    new TcpListener().listen()
    new HttpListener().listen()

exports.Listener = Listener