testCase = require('nodeunit').testCase

PathExploder = require('./../../lib/core/path_exploder').PathExploder

module.exports = testCase({

  setUp: (callback) ->
    callback()

  tearDown: (callback) ->
    callback()

  testDepth: (test) ->
    path = '/parent/child/grandchild/'
    paths = PathExploder.explode(path)
    #console.log paths
    test.ok([
      {path: '/', depth: 0},
      {path: '/parent/', depth: 1},
      {path: '/parent/child/', depth: 2},
      {path: '/parent/child/grandchild/', depth: 3}].equals(paths)
    )
    test.done()

  testDepthDimension: (test) ->
    path = '/parent/child/grandchild/dim1|dim2'
    paths = PathExploder.explode(path)
    #console.log paths
    test.ok([
      {path: '/', depth: 0},
      {path: '/parent/', depth: 1},
      {path: '/parent/child/', depth: 2},
      {path: '/parent/child/grandchild/', depth: 3},
      {path: '/parent/child/grandchild/dim1/', depth: 4},
      {path: '/parent/child/grandchild/dim1&dim2', depth: 4,}
      {path: '/parent/child/grandchild/dim2/', depth: 4}
      ].equals(paths)
    )
    test.done()


  missingLeadingAndTrailingSlash: (test) ->
    path = 'parent/foo/57'
    paths = PathExploder.explode(path)
    test.ok([
      {path: '/', depth: 0},
      {path: '/parent/', depth: 1},
      {path: '/parent/foo/', depth: 2},
      {path: '/parent/foo/57/', depth: 3}
      ].equals(paths))
    test.done()

  missingLeadingSlash: (test) ->
    path = 'parent/foo/57/'
    paths = PathExploder.explode(path)
    test.ok([
      {path: '/', depth: 0},
      {path: '/parent/', depth: 1},
      {path: '/parent/foo/', depth: 2},
      {path: '/parent/foo/57/', depth: 3}
      ].equals(paths))
    test.done()

  missingTrailingSlash: (test) ->
    path = '/parent/foo/57'
    paths = PathExploder.explode(path)
    test.ok([
      {path: '/', depth: 0},
      {path: '/parent/', depth: 1},
      {path: '/parent/foo/', depth: 2},
      {path: '/parent/foo/57/', depth: 3}
      ].equals(paths))
    test.done()

  simplePath: (test) ->
    path = '/parent/foo/57/'
    paths = PathExploder.explode(path)
    test.ok([
      {path: '/', depth: 0},
      {path: '/parent/', depth: 1},
      {path: '/parent/foo/', depth: 2},
      {path: '/parent/foo/57/', depth: 3}
      ].equals(paths))
    test.done()

  twoTrailingDimensions: (test) ->
    path = '/parent/foo/57|58/'
    paths = PathExploder.explode(path)
    test.ok([
      {path: '/', depth: 0}
      {path: '/parent/', depth: 1},
      {path: '/parent/foo/', depth: 2},
      {path: '/parent/foo/57/', depth: 3},
      {path: '/parent/foo/57&58/', depth: 3},
      {path: '/parent/foo/58/', depth: 3}
      ].equals(paths))
    test.done()

  threeTrailingDimensions: (test) ->
    path = '/parent/foo/57|58|59/'
    paths = PathExploder.explode(path)
    #console.log paths
    test.ok([
      {path: '/', depth: 0},
      {path: '/parent/', depth: 1},
      {path: '/parent/foo/', depth: 2},
      {path: '/parent/foo/57/', depth: 3},
      {path: '/parent/foo/57&58/', depth: 3},
      {path: '/parent/foo/57&58&59/', depth: 3},
      {path: '/parent/foo/57&59/', depth: 3},
      {path: '/parent/foo/58/', depth: 3},
      {path: '/parent/foo/58&59/', depth: 3},
      {path: '/parent/foo/59/', depth: 3}
      ].equals(paths), paths)
    test.done()

  multiLevelDimensions: (test) ->
    path = '/parent/foo|bar/57|58/'
    paths = PathExploder.explode(path)
    #console.log paths
    test.ok([
      {path: '/', depth: 0},
      {path: '/parent/', depth: 1},
      {path: '/parent/foo/', depth: 2},
      {path: '/parent/foo&bar/', depth: 2},
      {path: '/parent/bar/', depth: 2},
      {path: '/parent/foo/57/', depth: 3},
      {path: '/parent/foo/57&58/', depth: 3},
      {path: '/parent/foo/58/', depth: 3},
      {path: '/parent/foo&bar/57/', depth: 3},
      {path: '/parent/foo&bar/57&58/', depth: 3},
      {path: '/parent/foo&bar/58/', depth: 3},
      {path: '/parent/bar/57/', depth: 3},
      {path: '/parent/bar/57&58/', depth: 3},
      {path: '/parent/bar/58/', depth: 3}
      ].equals(paths), paths)
    test.done()



})