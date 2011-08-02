testCase = require('nodeunit').testCase

require ('./../../lib/core/extensions')

module.exports = testCase({

  setUp: (callback) ->
    callback()

  tearDown: (callback) ->
    callback()

  testEndsWith: (test) ->
    path = 'foo/'
    test.ok path.endsWith('/')
    test.done()

  testEndsWithLeadingCharacter: (test) ->
     path = '/foo'
     test.ok !path.endsWith('/')
     test.done()

  testEndsWithLeadingTrailingCharacter: (test) ->
     path = '/foo/'
     test.ok path.endsWith('/')
     test.done()


  testSurround: (test) ->
    path = 'foo'
    test.equal(path.surround('/'), '/foo/')
    test.done()

  testSurroundDuplicateLeadingCharacter: (test) ->
    path = '/foo'
    test.equal(path.surround('/'), '/foo/')
    test.done()

  testSurroundDuplicateTrailingCharacter: (test) ->
    path = 'foo/'
    test.equal(path.surround('/'), '/foo/')
    test.done()

  testSurroundDuplicateCharacters: (test) ->
    path = '/foo/'
    test.equal(path.surround('/'), '/foo/')
    test.done()

  testArrayContains: (test) ->
    arr = ['1s','2m','3m']
    test.ok(arr.contains('1s'))
    test.ok(arr.contains('2m'))
    test.ok(arr.contains('3m'))
    test.done()

  testArrayNotContains: (test) ->
    arr = ['1s','2m','3m']
    test.ok(!arr.contains(null))
    test.ok(!arr.contains(''))
    test.ok(!arr.contains('foo'))
    test.done()

})