reverse = (s) -> if s then s[-1...] + (reverse s[...-1])  else ""

exports.reverse = reverse

#alert reverse 'this is a test'
