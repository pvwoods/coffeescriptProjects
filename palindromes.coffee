rev = require './helpers/reverse'
log = (require './helpers/logging').log
fs = require 'fs'

searchCorpora = (fs.readFileSync process.argv[2]).toString()

isPalindrome = (x) -> if x.length > 1 then x == rev.reverse x else false

largestPalindrome = (xs) ->
    for ln in [xs.length..2]
        for x in [0..(xs.length-ln)]
            candidate = xs[x...(ln+x)]	
            if isPalindrome candidate then return candidate

log largestPalindrome searchCorpora
