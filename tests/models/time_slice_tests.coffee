TimeSlice = require('./../../lib/models/time_slice').TimeSlice
testCase = require('nodeunit').testCase


module.exports = testCase({

 setUp: (callback) ->
    callback()

  tearDown: (callback) ->
    callback()

  testGetSecondsFromSeconds: (test) ->
    test.equals 5, TimeSlice.toSeconds '5s'
    test.done()

  testGetSecondsFromMinutes: (test) ->
    test.equals 600, TimeSlice.toSeconds '10m'
    test.done()

  testGetSecondsFromHours: (test) ->
    test.equals 3600*2, TimeSlice.toSeconds '2h'
    test.done()

  testGetSecondsFromDays: (test) ->
    test.equals 86400*2, TimeSlice.toSeconds '2d'
    test.done()

  testConversion_5s_to_1s: (test) ->
    test.equals 5, TimeSlice.convert '5s', '1s'
    test.done()

  testConversion_1m_to_5s: (test) ->
    test.equals 12, TimeSlice.convert '1m', '5s'
    test.done()

  testConversion_5m_to_1m: (test) ->
    test.equals 5, TimeSlice.convert '5m', '1m'
    test.done()

  testConversion_1d_to_1h: (test) ->
    test.equals 24, TimeSlice.convert '1d', '1h'
    test.done()

})