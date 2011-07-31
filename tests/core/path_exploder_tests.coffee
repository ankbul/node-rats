testCase = require('nodeunit').testCase

PathExploder = require('./../../lib/core/path_exploder').PathExploder

module.exports = testCase({

  setUp: (callback) ->
    callback()

  tearDown: (callback) ->
    callback()

  missingLeadingAndTrailingSlash: (test) ->
    path = 'parent/foo/57'
    paths = PathExploder.explode(path)
    test.ok(['/','/parent/','/parent/foo/','/parent/foo/57/'].equals(paths))
    test.done()

  missingLeadingSlash: (test) ->
    path = 'parent/foo/57/'
    paths = PathExploder.explode(path)
    test.ok(['/','/parent/','/parent/foo/','/parent/foo/57/'].equals(paths))
    test.done()

  missingTrailingSlash: (test) ->
    path = '/parent/foo/57'
    paths = PathExploder.explode(path)
    test.ok(['/','/parent/','/parent/foo/','/parent/foo/57/'].equals(paths))
    test.done()

  simplePath: (test) ->
    path = '/parent/foo/57/'
    paths = PathExploder.explode(path)
    test.ok(['/','/parent/','/parent/foo/','/parent/foo/57/'].equals(paths))
    test.done()

  twoTrailingDimensions: (test) ->
    path = '/parent/foo/57|58/'
    paths = PathExploder.explode(path)
    test.ok(['/','/parent/','/parent/foo/','/parent/foo/57/','/parent/foo/57&58/','/parent/foo/58/'].equals(paths))
    test.done()

  threeTrailingDimensions: (test) ->
    path = '/parent/foo/57|58|59/'
    paths = PathExploder.explode(path)
    #console.log paths
    test.ok(['/',
      '/parent/',
      '/parent/foo/',
      '/parent/foo/57/',
      '/parent/foo/57&58/',
      '/parent/foo/57&58&59/',
      '/parent/foo/57&59/'
      '/parent/foo/58/'
      '/parent/foo/58&59/'
      '/parent/foo/59/'
      ].equals(paths), paths)
    test.done()

  multiLevelDimensions: (test) ->
    path = '/parent/foo|bar/57|58/'
    paths = PathExploder.explode(path)
    #console.log paths
    test.ok(['/',
      '/parent/',
      '/parent/foo/',
      '/parent/foo&bar/',
      '/parent/bar/',
      '/parent/foo/57/',
      '/parent/foo/57&58/',
      '/parent/foo/58/',
      '/parent/foo&bar/57/',
      '/parent/foo&bar/57&58/',
      '/parent/foo&bar/58/',
      '/parent/bar/57/',
      '/parent/bar/57&58/',
      '/parent/bar/58/',
      ].equals(paths), paths)
    test.done()



})