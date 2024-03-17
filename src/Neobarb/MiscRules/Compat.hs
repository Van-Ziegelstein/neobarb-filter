{-# LANGUAGE OverloadedStrings #-}

module Neobarb.MiscRules.Compat (
    capitalize
) where


import qualified Text.Pandoc.Definition as P
import Text.Pandoc.Walk (walk)
import qualified Data.Text as T



-- The epub standards (both 2 & 3) are a bit wonky regarding "smallcap" support
-- and while some e-readers allow for the rendering of capitalized text via CSS, others don't.
-- The only "safe route", for now, is to explicitly capitalize all letters contained within \textsc{} macros.
capitalize :: P.Inline -> P.Inline
capitalize (P.SmallCaps xs) = P.Span ("", [], []) $ walk up xs
    where
        up (P.Str w) = P.Str $ T.toUpper w 
        up w = w
capitalize s = s

