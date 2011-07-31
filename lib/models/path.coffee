PathExploder = require('./../core/path_exploder').PathExploder

class Path
  constructor: (path) ->
    @path = path
    @paths = PathExploder.explode path


  # AB : removes double slashes
  @sanitize: (string) -> string.replace(/\/\//,'/')


exports.Path = Path