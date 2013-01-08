rev = require './helpers/reverse'
log = (require './helpers/logging').log
fs = require 'fs'

searchCorpora = (fs.readFileSync process.argv[2]).toString()

isPalindrome = (x) -> if x.length > 1 then x == rev.reverse x else false

palindromes = (xs) ->
    t = [xs.length..2].map (ln) ->
        [0..(xs.length-ln)].map (x) ->
            c = xs[x...(ln+x)]
            if isPalindrome c then c else null
    ([].concat.apply [], t).filter (x) -> x != null

log (palindromes searchCorpora)[0]
