{-# LANGUAGE OverloadedStrings #-}

module Neobarb.BookRules.Barbmoon (
    fixHeadings
) where


import qualified Text.Pandoc.Definition as P

-- the roman numeral stuff doesn't seem to translate well from latex to html
fixHeadings :: P.Block -> P.Block
fixHeadings (P.Header 1 ("section",_,_) _) = P.Header 1 ("\8544",[],[]) [P.Str "\8544"]
fixHeadings (P.Header 1 ("section-1",_,_) _) = P.Header 1 ("\8545",[],[]) [P.Str "\8545"]
fixHeadings (P.Header 1 ("section-2",_,_) _) = P.Header 1 ("\8546",[],[]) [P.Str "\8546"]
fixHeadings b = b
