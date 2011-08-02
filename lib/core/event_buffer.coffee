async = require 'async'
url = require 'url'
EventSink = require('./../sinks/event_sink').EventSink

# AB: todo - batch events
# AB: todo - use event emitter to decouple / async the process of event buffering from the listener
# AB: todo - make concurrency configurable
# AB: todo - how to ensure that the event buffer doesn't overtake the main processing pipeline
# AB: todo - make this a period background job?

class EventBuffer

  @processedCount = 0
  @sampleSize = 2000
  @lastSampleTime = new Date()

  @processEvent: (event, callback) ->
    parsed = url.parse event.data, true
    #console.log '[EventBuffer] processing: ' + parsed.href
    if event.data == '/favicon.ico'
      console.log '[EventBuffer] favicon.ico request ignored'
      return

    eventPacket = {data: parsed.query, time: event.time}
    EventSink.send eventPacket
    callback()

  # todo - what should be the proper concurrency level?
  @eventQueue = async.queue @processEvent, 10

  # pushes data to async.queue
  @buffer: (data) ->
    task = {data: data, time: new Date()}
    if (data + '').length > 1
      @processedCount += 1
      if @processedCount % @sampleSize == 0
        newSampleTime = new Date()
        time = (newSampleTime - @lastSampleTime) / 1000 # timespan in seconds
        rate = @sampleSize / time
        console.log "[EventBuffer] Incoming request ##{@processedCount} @ #{time} #{rate}: [#{data}]"
        @lastSampleTime = newSampleTime

      @eventQueue.push task, (err) -> #console.log '[EventBuffer] processed'


exports.EventBuffer = EventBuffer
