
drawEvent = (container, event, maxHeight = -1, indent = '') ->

  id = event.path.replace('://','_').replace(/\//g,'_')
  selector = '#' + id

  if maxHeight == -1
    maxHeight = event.count

  objHeight = event.count * 400 / maxHeight


  if $(selector).length != 0
    $(selector).animate({height : objHeight + 'px' })

#    $(selector).css({height : event.count /2 +'px' }) #do animation
  else
    div = $('<div>')
    div.css {width : '33%', height: objHeight + 'px', float: 'left', border: '1px solid black'}
    div.attr('id', id)

    div.html indent + event.name + " " + event.count
    container.append div
    indent += '&nbsp;&nbsp;&nbsp;'

  if event.events
    drawEvent(container, e, maxHeight, indent) for e in event.events


globalEvent = null
firstLoad = true

$(document).ready () ->
  socket = io.connect 'http://localhost:3030'
  socket.on 'events', (data) ->
    console.log data
    globalEvent = new REvent(data)
    jso = globalEvent.toJson()

    if firstLoad
      drawGraph jso
      firstLoad = false
    else
      transition jso
#   drawEvent $('#container'), data.events[0]
