socket = require 'socket.io'

data = {
  view : {
    path : '',
    type : 'live',
    interval : '1m'
  },

  events : [{
    name: 'wallpost',
    count: 1100+50,
    path : 'wallpost',
    redisPath : 'rats://wallpost',
    depth : 3
    events: [
      {
        name: 'tf',
        count : 800 + 40,
        path : 'wallpost/tf'
        redisPath : 'rats://wallpost/tf'
        events : [
          {
            name: 'clicked',
            count : 500 ,
            path : 'wallpost/tf/clicked'
            redisPath : 'rats://wallpost/tf/clicked'
          },
          {
            name : 'published',
            count : 200,
            path : 'wallpost/tf/published'
            redisPath : 'rats://wallpost/tf/published'
          },
          {
            name : 'rescheduled',
            count : 100,
            path : 'wallpost/tf/rescheduled'
            redisPath : 'rats://wallpost/tf/rescheduled'
          }
        ]
      },
      {
        name: 'mf',
        count : 300,
        path : 'wallpost/mf'
        redisPath : 'rats://wallpost/mf'
        events : [
          {
            name: 'clicked',
            count : 50,
            path : 'wallpost/mf/clicked'
            redisPath : 'rats://wallpost/mf/clicked'
          },
          {
            name : 'published',
            count : 250,
            path : 'wallpost/mf/published'
            redisPath : 'rats://wallpost/mf/published'
          }
        ]
      }
    ]
  }]
}

class SocketClient

  constructor: (@port = 3030) ->

  listen: ->
    console.log "[SOCKET.IO] listening on port #{@port}"
    @io = socket.listen(@port)
    @io.sockets.on 'connection', (socket) ->



    setInterval () =>
      data.events[0].events[0].events[0].count += Math.floor(Math.random() * 320)
      data.events[0].events[0].events[1].count += Math.floor(Math.random() * 320)
      data.events[0].events[0].events[2].count += Math.floor(Math.random() * 320)
      data.events[0].events[1].events[0].count += Math.floor(Math.random() * 120)
      data.events[0].events[1].events[1].count += Math.floor(Math.random() * 120)
      data.events[0].events[0].count = data.events[0].events[0].events[0].count + data.events[0].events[0].events[1].count + data.events[0].events[0].events[2].count
      data.events[0].events[1].count = data.events[0].events[1].events[0].count + data.events[0].events[1].events[1].count
      data.events[0].count = data.events[0].events[0].count + data.events[0].events[1].count



      console.log 'sending data'
      @io.sockets.emit 'events', data
    , 2500

exports.SocketClient = SocketClient