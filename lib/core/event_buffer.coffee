class EventBuffer
  # pushes data to async.queue as fast as possible
  @buffer: (data) ->
    console.log "Incoming request: #{data}"


exports.EventBuffer = EventBuffer
