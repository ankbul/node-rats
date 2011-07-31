require './extensions'
Event = require('./../models/event').Event

class PathExploder

  @combinateDimensions: (dimension, dimensions) ->
    combinations = []
    i = 1
    for dim in dimensions
      combination = "#{dimension}&#{dim}"
      combination = combination.replace(/^&+/,'')
      combinations.push combination
      combinations.push combi for combi in @combinateDimensions(combination, dimensions[i..dimensions.length])
      i += 1

    combinations

  @combinate: (dimensions) ->
    @combinateDimensions '', dimensions


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
    paths = [ {path: Event.ROOT_PATH, depth: 0} ]
    return paths if (path ? '').empty()

    path = path.trimSlashes()
    segments = path.split(Event.PATH_SEPARATOR)
    #console.log '[Explode]', segments
    combinatorial = 1;
    combinatorialTally = 0
    depth = 1

    for segment in segments
      dimensions = segment.split(Event.DIMENSION_SEPARATOR)
      dimensions = @combinate(dimensions)

      # AB : book keeping
      combinatorialTally += combinatorial
      i = combinatorialTally - combinatorial

      while i < combinatorialTally
        exploded = @addDimension(paths[i].path, dimensions)
        paths.push {path: e, depth: depth} for e in exploded
        i += 1

      combinatorial *= dimensions.length
      depth += 1

    #console.log paths
    paths


exports.PathExploder = PathExploder
