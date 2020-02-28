module Neobarb.Quoting (
    germanizeQuotes
) where


import qualified Text.Pandoc.Definition as P

-- Guillemets are prefered in German book formatting over standard quotes.
germanizeQuotes :: P.Inline -> P.Inline
germanizeQuotes (P.Quoted _ xs) = P.Span ("", [], []) $ P.Str "\187" : xs ++ [ P.Str "\171" ]
germanizeQuotes i = i
