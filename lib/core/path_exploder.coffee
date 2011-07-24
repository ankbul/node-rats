class PathExploder

  @addDimension: (segment, dimensions) ->
    paths = []
    for dimension in dimensions
      path = "#{segment}/#{dimension}"
      paths.push path
      console.log "addDimension: #{path}"
    paths


  @explode: (path) ->
    paths = ['']
    segments = path.split('/')
    combinatorial = 1;
    combinatorialTally = 0

    for segment in segments
      dimensions = segment.split('|')

      # AB : book keeping
      combinatorialTally += combinatorial
      i = combinatorialTally - combinatorial

      while i < combinatorialTally
        exploded = @addDimension(paths[i], dimensions)
        paths.push e for e in exploded
        i += 1

      combinatorial *= dimensions.length

    console.log paths
    paths


exports.PathExploder = PathExploder
