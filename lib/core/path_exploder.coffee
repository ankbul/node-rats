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
      path = "#{segment}/#{dimension}"
      path = path.replace(/^\/+/,'') # remove trailing slash
      paths.push path
      #console.log "addDimension: #{path}"
    paths


  @explode: (path) ->
    paths = ['']
    segments = path.split('/')
    combinatorial = 1;
    combinatorialTally = 0

    for segment in segments
      dimensions = segment.split('|')

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
