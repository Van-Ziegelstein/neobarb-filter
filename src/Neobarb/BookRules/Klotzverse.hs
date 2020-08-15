{-# LANGUAGE OverloadedStrings #-}

module Neobarb.BookRules.Klotzverse ( 
    cyberfy
) where


import qualified Text.Pandoc.Definition as P

-- add custom css style classes for the "console" separator snippets
cyberfy :: P.Block -> P.Block
cyberfy x@(P.Para (P.Str ">>>>>>":_)) = P.Div ("",["cyberprompt"],[]) [x]
cyberfy p = p

