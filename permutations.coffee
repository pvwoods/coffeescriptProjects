permute = (str) ->
  
  _s = []  

  (_p = (prefix, obj, permutations) ->
    if obj.length == 0
      permutations.push prefix + obj
    else
      for i in [0...obj.length]
        _p prefix + (obj.charAt i), (obj.substr 0, i) + (obj.substr i + 1, obj.length), permutations
  ) "", str, _s
  
  return _s
  

console.log "PERMUTATIONS :: " + (permute "DOG").join ", "
