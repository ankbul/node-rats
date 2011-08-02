# string extensions
String.prototype.startsWith = (str) -> return this.indexOf(str) == 0
String.prototype.endsWith = (str) -> return this.lastIndexOf(str) == this.length - 1
String.prototype.empty = (str) -> return this.length == 0
String.prototype.trimSlashes = () -> return this.replace(/^\/+|\/+$/g,'')
String.prototype.stringCount = (str) -> return this.split(str).length

String.prototype.surround = (enclosure) ->
  temp = "#{this}"
  temp = "#{enclosure}#{temp}" if !temp.startsWith(enclosure)
  temp = "#{temp}#{enclosure}" if !temp.endsWith(enclosure)
  return temp

# array extensions
Array.prototype.sortByKey = (key) ->
  result = []
  values = (this.map (obj) -> obj[key]).sort()
  for value in values
    result.push (this.filter (obj) -> obj[key] == value)[0]

  return result

Array.prototype.equals = (arrayB) -> return !(this < arrayB or arrayB < this)

Array.prototype.contains = (val) ->
  for i in [0..this.length - 1]
    return true if this[i] == val
  return false