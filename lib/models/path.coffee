require './../core/extensions'
PathExploder = require('./../core/path_exploder').PathExploder
Event = require('./event').Event

class Path
  constructor: (path) ->
    @path = path
    @paths = PathExploder.explode path
    @depth = Path.getDepth path

  @getDepth: (path) ->
    path = path ? Event.ROOT_PATH
    return 0 if path == Event.ROOT_PATH or path.length == 0
    return path.trimSlashes().stringCount(Event.PATH_SEPARATOR)

  # AB : removes double slashes
  @sanitize: (string) -> string.replace(/\/\//,'/')


exports.Path = Path