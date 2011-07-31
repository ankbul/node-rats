require './extensions'
Event = require('./../models/event').Event

class PathExploder

  @permuteDimensions: (dimension, dimensions) ->
    permutations = []
    i = 1
    for dim in dimensions
      permutation = "#{dimension}&#{dim}"
      permutation = permutation.replace(/^&+/,'')
      permutations.push permutation
      permutations.push perm for perm in @permuteDimensions(permutation, dimensions[i..dimensions.length])
      i += 1

    permutations

  @permute: (dimensions) ->
    @permuteDimensions '', dimensions


  @addDimension: (segment, dimensions) ->
    paths = []
    for dimension in dimensions
      path = "#{segment}#{dimension}/"
      #path = path.surround(Event.PATH_SEPARATOR)
      #path = path.replace(/^\/+/,'') # remove trailing slash
      #path = path.sanitize()
      paths.push path
      #console.log "addDimension: #{path}"
    paths


  @explode: (path) ->
    paths = [Event.ROOT_PATH]
    return paths if (path ? '').empty()

    path = path.trimSlashes()
    segments = path.split(Event.PATH_SEPARATOR)
    #console.log '[Explode]', segments
    combinatorial = 1;
    combinatorialTally = 0

    for segment in segments
      dimensions = segment.split(Event.DIMENSION_SEPARATOR)

      # AB : todo make this a config variable whether or not to permute automatically
      dimensions = @permute(dimensions)

      # AB : book keeping
      combinatorialTally += combinatorial
      i = combinatorialTally - combinatorial

      while i < combinatorialTally
        exploded = @addDimension(paths[i], dimensions)
        paths.push e for e in exploded
        i += 1

      combinatorial *= dimensions.length

    #console.log paths
    paths


exports.PathExploder = PathExploder
