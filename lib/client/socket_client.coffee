socket = require 'socket.io'

data = {
  events : [{
    name: 'wallpost',
    count: 1100+50,
    path : 'rats://wallpost',
    depth : 3
    events: [
      {
        name: 'tf',
        count : 800 + 40,
        path : 'rats://wallpost/tf'
        events : [
          {
            name: 'clicked',
            count : 500 ,
            path : 'rats://wallpost/tf/clicked'
          },
          {
            name : 'published',
            count : 200,
            path : 'rats://wallpost/tf/published'
          },
          {
            name : 'rescheduled',
            count : 100,
            path : 'rats://wallpost/tf/rescheduled'
          }
        ]
      },
      {
        name: 'mf',
        count : 300,
        path : 'rats://wallpost/mf'
        events : [
          {
            name: 'clicked',
            count : 50,
            path : 'rats://wallpost/mf/clicked'
          },
          {
            name : 'published',
            count : 250,
            path : 'rats://wallpost/mf/published'
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
      console.log(socket);



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
    , 500

exports.SocketClient = SocketClient