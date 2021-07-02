Find exact word

/\b**word**\b/

Find abc that is not followed by defg (Negative lookahead)

/abc(?!defg)/

Find abc that is not preceded by defg (Negative lookbehind)

/(?<!defg)abc/

Non-capturing group

(?:regex)

Find abc that must followed by defg (Positive lookahead)

abc(?=defg)

Find abc that must be preceded by defg (Positive lookbehind)

(?<=defg)abc

Named capturing group

(?\<name\>)