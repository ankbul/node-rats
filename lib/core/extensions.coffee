# string extensions
String.prototype.startsWith = (str) -> return this.indexOf(str) == 0

# array extensions
Array.prototype.sortByKey = (key) ->
    result = []
    values = (this.map (obj) -> obj[key]).sort()

    for value in values
      result.push (this.filter (obj) -> obj[key] == value)[0]

    return result
