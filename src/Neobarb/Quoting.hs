module Neobarb.Quoting (
    germanizeQuotes
) where


import Text.Pandoc.Definition

-- Guillemets are prefered in German book formatting over standard quotes.
germanizeQuotes :: Inline -> Inline
germanizeQuotes (Quoted _ xs) = Span ("", [], []) $ Str "\187" : xs ++ [ Str "\171" ]
germanizeQuotes i = i
