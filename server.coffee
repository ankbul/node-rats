redis = require 'redis',
Listener = require('./lib/listeners/listener').Listener

config =
  redis:
    port: 6379
    host: '127.0.0.1'

class EventBuffer
  # pushes data to async.queue as fast as possible
  @buffer: (data) ->
    console.log "Incoming request: #{data}"



Listener.listen()


# set up client


# set up websocket input



