{-# LANGUAGE OverloadedStrings #-}

module Neobarb.MiscRules.Misc (
    capCompat
) where


import qualified Text.Pandoc.Definition as P
import Text.Pandoc.Walk (walk)
import qualified Data.Text as T



-- The epub standards (both 2 & 3) are a bit wonky regarding "smallcap" support
-- and while some e-readers allow for the rendering of capitalized text via CSS, others don't.
-- The only "safe route", for now, is to explicitly capitalize all letters contained within \textsc{} macros.
capCompat :: P.Inline -> P.Inline
capCompat (P.SmallCaps xs) = P.Span ("", [], []) $ walk up xs
    where
        up (P.Str w) = P.Str $ T.toUpper w 
        up w = w
capCompat s = s
