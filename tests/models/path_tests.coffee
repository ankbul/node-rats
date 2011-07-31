Event = require('./../../lib/models/event').Event
Path = require('./../../lib/models/path').Path
testCase = require('nodeunit').testCase


module.exports = testCase({

 setUp: (callback) ->
    callback()

  tearDown: (callback) ->
    callback()

  testEmptyDepth: (test) ->
    depth = Path.getDepth ''
    test.equals 0, depth
    test.done()

  testRootDepth: (test) ->
    depth = Path.getDepth '/'
    test.equals 0, depth
    test.done()

  testDepth1: (test) ->
    depth = Path.getDepth '/parent/'
    test.equals 1, depth
    test.done()

  testDepth2: (test) ->
    depth = Path.getDepth '/parent/child/'
    test.equals 2, depth
    test.done()

})