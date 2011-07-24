async = require 'async'
url = require 'url'
EventSink = require('./../sinks/event_sink').EventSink

# AB: todo - batch events
# AB: todo - use event emitter to decouple / async the process of event buffering from the listener
# AB: todo - make concurrency configurable
# AB: todo - how to ensure that the event buffer doesn't overtake the main processing pipeline
# AB: todo - make this a background job

class EventBuffer

  @eventQueue =  async.queue(
    (task, callback) ->
      parsed = url.parse task.data, true
      console.log '[EventBuffer] proccessing: ' + parsed.href
      callback()
    2
  )

  # pushes data to async.queue as fast as possible
  @buffer: (data) ->
    task = {data: data}
    console.log "[EventBuffer] Incoming request: #{data}"
    @eventQueue.push task, (err) -> console.log '[EventBuffer] processed'



exports.EventBuffer = EventBuffer
