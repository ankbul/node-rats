redis = require 'redis',
EventSource = require('./lib/sources/event_source').EventSource

config =
  redis:
    port: 6379
    host: '127.0.0.1'

EventSource.listen()


# set up client


# set up websocket input



