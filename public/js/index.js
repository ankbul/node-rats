(function() {
  $(document).ready(function() {
    var rServer;
    rServer = new RServer('http://localhost', 3030);
    return rServer.start();
  });
}).call(this);
