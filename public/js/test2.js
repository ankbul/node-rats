(function() {
  var drawEvent, firstLoad, globalEvent;
  drawEvent = function(container, event, maxHeight, indent) {
    var div, e, id, objHeight, selector, _i, _len, _ref, _results;
    if (maxHeight == null) {
      maxHeight = -1;
    }
    if (indent == null) {
      indent = '';
    }
    id = event.path.replace('://', '_').replace(/\//g, '_');
    selector = '#' + id;
    if (maxHeight === -1) {
      maxHeight = event.count;
    }
    objHeight = event.count * 400 / maxHeight;
    if ($(selector).length !== 0) {
      $(selector).animate({
        height: objHeight + 'px'
      });
    } else {
      div = $('<div>');
      div.css({
        width: '33%',
        height: objHeight + 'px',
        float: 'left',
        border: '1px solid black'
      });
      div.attr('id', id);
      div.html(indent + event.name + " " + event.count);
      container.append(div);
      indent += '&nbsp;&nbsp;&nbsp;';
    }
    if (event.events) {
      _ref = event.events;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        e = _ref[_i];
        _results.push(drawEvent(container, e, maxHeight, indent));
      }
      return _results;
    }
  };
  globalEvent = null;
  firstLoad = true;
  $(document).ready(function() {
    var socket;
    socket = io.connect('http://localhost:3030');
    return socket.on('events', function(data) {
      var jso;
      console.log(data);
      globalEvent = new REvent(data);
      jso = globalEvent.toJson();
      if (firstLoad) {
        drawGraph(jso);
        return firstLoad = false;
      } else {
        return transition(jso);
      }
    });
  });
}).call(this);
