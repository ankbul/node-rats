
#drawEvent = (container, event, maxHeight = -1, indent = '') ->
#
#  id = event.path.replace('://','_').replace(/\//g,'_')
#  selector = '#' + id
#
#  if maxHeight == -1
#    maxHeight = event.count
#
#  objHeight = event.count * 400 / maxHeight
#
#
#  if $(selector).length != 0
#    $(selector).animate({height : objHeight + 'px' })
#
##    $(selector).css({height : event.count /2 +'px' }) #do animation
#  else
#    div = $('<div>')
#    div.css {width : '33%', height: objHeight + 'px', float: 'left', border: '1px solid black'}
#    div.attr('id', id)
#
#    div.html indent + event.name + " " + event.count
#    container.append div
#    indent += '&nbsp;&nbsp;&nbsp;'
#
#  if event.events
#    drawEvent(container, e, maxHeight, indent) for e in event.events


$(document).ready () ->
  rServer = new RServer('http://localhost',3030)
  rServer.start()

#   drawEvent $('#container'), data.events[0]
