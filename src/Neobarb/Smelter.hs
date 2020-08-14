{-# LANGUAGE OverloadedStrings #-}

module Neobarb.Smelter (
    smeltLangParts,
    smeltBookParts
) where


import Text.Pandoc.Walk (walk)
import qualified Text.Pandoc.Definition as P
import qualified Neobarb.LangRules.German as G
import qualified Neobarb.BookRules.Pillagers as B
import qualified Neobarb.BookRules.Barbmoon as M


-- Lift all language specific typography adjustments to document level
smeltLangParts :: String -> P.Pandoc -> P.Pandoc
smeltLangParts "de" = walk G.germanizeQuotes
smeltLangParts _ = id


-- Lift all book specific formating to document level
smeltBookParts :: String -> P.Pandoc -> P.Pandoc
smeltBookParts "pillagers" = (walk B.fixPoemBlocks) . (walk B.fixPara)
smeltBookParts "barbmoon" = walk M.fixHeadings
smeltBookParts _ = id
