{-# LANGUAGE OverloadedStrings #-}

module Neobarb.Smelter (
    smeltLangParts,
    smeltBookParts
) where


import Text.Pandoc.Walk (walk)
import qualified Text.Pandoc.Definition as P
import qualified Neobarb.LangRules.German as DE
import qualified Neobarb.LangRules.English as EN
import qualified Neobarb.BookRules.Barbverse as Barbverse
import qualified Neobarb.BookRules.Pillagers as Pillagers
import qualified Neobarb.BookRules.Barbmoon as Barbmoon
import qualified Neobarb.BookRules.Klotzverse as Klotzverse


-- Lift all language specific typography adjustments to document level
smeltLangParts :: String -> P.Pandoc -> P.Pandoc
smeltLangParts "de" = walk DE.germanizeQuotes
smeltLangParts "en" = (walk EN.anglifyQuotes) . (walk EN.curlApostrophe)
smeltLangParts _ = id


-- Lift all book specific formating to document level
smeltBookParts :: String -> P.Pandoc -> P.Pandoc
smeltBookParts n@("pillagers") = (walk Pillagers.fixPoemBlocks) . (walk Pillagers.amendCenter) . (walk $ Barbverse.fixPara n)
smeltBookParts "barbmoon" = walk Barbmoon.fixHeadings
smeltBookParts n@("immersed") = walk $ Barbverse.fixPara n
smeltBookParts "klotzverse" = walk Klotzverse.cyberfy
smeltBookParts _ = id
