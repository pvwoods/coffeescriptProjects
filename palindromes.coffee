rev = require './helpers/reverse'
log = (require './helpers/logging').log
fs = require 'fs'

searchCorpora = (fs.readFileSync process.argv[2]).toString()

isPalindrome = (x) -> if x.length > 1 then x == rev.reverse x else false

largestPalindrome = (xs) ->
    for ln in [xs.length..1]
        for x in [0..(xs.length-ln)]
            if isPalindrome xs[x...(ln+x)] then return xs[x...(ln+x)]


log largestPalindrome searchCorpora
