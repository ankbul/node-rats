redis = require 'redis',
Listener = require('./lib/listeners/listener').Listener

config =
  redis:
    port: 6379
    host: '127.0.0.1'

Listener.listen()


# set up client


# set up websocket input



