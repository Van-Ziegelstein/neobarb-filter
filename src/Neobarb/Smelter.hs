{-# LANGUAGE OverloadedStrings #-}

module Neobarb.Smelter (
    smeltLangParts,
    smeltBookParts
) where


import Text.Pandoc.Walk (walk)
import qualified Text.Pandoc.Definition as P
import qualified Neobarb.LangRules.German as G
import qualified Neobarb.LangRules.English as E
import qualified Neobarb.BookRules.Pillagers as B
import qualified Neobarb.BookRules.Barbmoon as M
import qualified Neobarb.BookRules.Klotzverse as K


-- Lift all language specific typography adjustments to document level
smeltLangParts :: String -> P.Pandoc -> P.Pandoc
smeltLangParts "de" = walk G.germanizeQuotes
smeltLangParts "en" = (walk E.anglifyQuotes) . (walk E.curlApostrophe)
smeltLangParts _ = id


-- Lift all book specific formating to document level
smeltBookParts :: String -> P.Pandoc -> P.Pandoc
smeltBookParts "pillagers" = (walk B.fixPoemBlocks) . (walk B.amendCenter) . (walk B.fixPara)
smeltBookParts "barbmoon" = walk M.fixHeadings
smeltBookParts "klotzverse" = walk K.cyberfy
smeltBookParts _ = id
