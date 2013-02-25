permute = (prefix, obj, permutations) ->
  if obj.length == 0
    permutations.push prefix + obj
  else
    for i in [0...obj.length]
      permute prefix + (obj.charAt i), (obj.substr 0, i) + (obj.substr i + 1, obj.length), permutations 
  

p = []

permute "", "DOG", p

console.log p
