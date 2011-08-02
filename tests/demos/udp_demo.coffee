testCase = require('nodeunit').testCase
require ('./../../lib/core/extensions')
UdpSource = require('./../../lib/sources/udp_source').UdpSource


class UdpDemo
  @testUdpSend: (msg) ->
    udp = new UdpSource()
    udp.loopback msg

  @testMultiUdpSend: (arrayMsg) ->
    for msg in arrayMsg
      if (Math.random() * 20 > 14)
        @testUdpSend msg


setInterval( () ->
  UdpDemo.testMultiUdpSend ['/?e=popchat/wallpost/tf/clicked', '/?e=popchat/wallpost/mf/clicked', '/?e=popchat/wallpost/yn/clicked', '/?e=popchat/wallpost/rt/clicked']
 , 50
)
#UdpDemo.testUdpSend('/?e=popchat/login/new')

#module.exports = testCase({

#  setUp: (callback) ->
#    callback()

#  tearDown: (callback) ->
#    callback()

#  testUdpSend: (test) ->
    #UdpSource.loopback '/?e=popchat/login/new'
#    test.done()

#})