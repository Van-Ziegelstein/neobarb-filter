{-# LANGUAGE OverloadedStrings #-}

module Neobarb.LangRules.English (
    anglifyQuotes,
    curlApostrophe
) where


import qualified Text.Pandoc.Definition as P
import qualified Data.Text as T

-- There are different codepoints in the unicode standard for "curly" quotes.
anglifyQuotes :: P.Inline -> P.Inline
anglifyQuotes (P.Quoted _ xs) = P.Span ("", [], []) $ P.Str "\8220" : xs ++ [ P.Str "\8221" ]
anglifyQuotes i = i

-- The "Right single quotation mark" is often used in book formating over the actual apostrophe for aesthetic reasons.
curlApostrophe :: P.Inline -> P.Inline
curlApostrophe (P.Str s) = P.Str . (T.intercalate "\8217") . (T.splitOn "\'") $ s
curlApostrophe i = i
