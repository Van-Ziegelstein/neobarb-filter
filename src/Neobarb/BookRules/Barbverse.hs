{-# LANGUAGE OverloadedStrings #-}

module Neobarb.BookRules.Barbverse (
    fixPara
) where


import qualified Text.Pandoc.Definition as P


-- All books and short stories in the "neobarbarian storyverse"
-- use some (standardized) inline elements that need to be wrapped for later CSS styling.
fixPara :: String -> P.Block -> P.Block
fixPara bookn p@(P.Para xs) = case (bookn, xs) of 
                                ("pillagers", [P.Emph (P.Str "Und" : P.Space : P.Str "also" :_)]) -> plainDiv ["quote"]
                                ("pillagers", [P.Emph (P.Str "F\252r" : P.Space : P.Str "immer" :_)]) -> plainDiv ["placard", "quote"]
                                ("pillagers", (P.Str "K." : P.Space :_)) -> plainDiv ["placard", "quote"]
                                ("immersed", [P.Emph (P.Str _ : P.Space : P.Str "DeepM," :_)]) -> plainDiv ["placard", "quote"]
                                ("immersed", (P.Str _ : P.Space : P.Str "Garry" :_)) -> plainDiv ["placard", "quote"]
                                _ -> p
                                where
                                    plainDiv c = P.Div ("", c, []) [ P.Plain xs ]

fixPara bookn b = b
