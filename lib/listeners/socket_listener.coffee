class SocketListener
  constructor: (@port = 7288) ->

  # responds as quickly as possible
  listen: ->
    console.log "listening on port #{@port}"


exports.SocketListener = SocketListener