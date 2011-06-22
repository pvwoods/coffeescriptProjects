myString = "this is a test."

reverse = (s) -> if s then s[-1...] + (reverse s[...-1])  else ""

alert reverse myString
