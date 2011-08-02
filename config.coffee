config =
  redis:
    port: 6379
    host: '127.0.0.1'
  express:
    port: 3000
  socket:
    port: 3030
  #timeSlices: ['all','1s','5s','1m','10m','1h','1d']
  timeSlices: ['all','1d']

exports.config = config