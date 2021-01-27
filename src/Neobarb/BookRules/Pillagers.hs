{-# LANGUAGE OverloadedStrings #-}

module Neobarb.BookRules.Pillagers (
    fixPara,
    amendCenter,
    fixPoemBlocks
) where


import qualified Data.List as L
import qualified Control.Monad.State as S
import qualified Text.Pandoc.Definition as P
import Text.Pandoc.Walk (walkM)


-- Some inline elements need to be wrapped for later styling
fixPara :: P.Block -> P.Block
fixPara p@(P.Para xs) = case xs of 
                                (P.Strong (P.Str "Nur" : P.Space : P.Str "f\252r" :_) :_) -> plainDiv ["placard"]
                                [P.Emph (P.Str "Und" : P.Space : P.Str "also" :_)] -> plainDiv ["quote"]
                                [P.Emph (P.Str "F\252r" : P.Space : P.Str "immer" :_)] -> plainDiv ["placard", "quote"]
                                (P.Str "K." : P.Space :_) -> plainDiv ["placard", "quote"]
                                _ -> p
                                where
                                    plainDiv c = P.Div ("", c, []) [ P.Plain xs ]

fixPara b = b


-- Pandoc's AST now preserves LaTeX environments as Div blocks,
-- we merely need to add our custom classes.
amendCenter :: P.Block -> P.Block
amendCenter d@(P.Div (id, cs, vs) y@(P.Para xs :_)) = case xs of 
                                (P.Str "M." : P.Space : P.Str "Truthblitz" :_) -> addDivClass "placard"              
                                [P.Emph (P.Str "Mein" : P.Space : P.Str "Mitbewohner" :_)] -> addDivClass "quote"
                                [P.Emph (P.Str "Mittagspause" : P.Space : P.Str "-" :_)] -> addDivClass "quote"
                                [P.Emph (_:_:P.Str "Overdrive!":_)] -> addDivClass "quote"
                                [P.Image _ _ _] -> addDivClass "barbsep"
                                _ -> d
                                where 
                                    addDivClass c = P.Div (id, c : cs, vs) y 
amendCenter b = b


-- Helper to inject blank lines into a block of text, using line numbers as point of reference.
injectBlanks :: [Int] -> P.Block -> S.State Int P.Block 
injectBlanks bPoints (P.Para ps) = do
                                lineN <- S.get
                                S.put (lineN + 1)
                                if L.or $ map (== lineN) bPoints
                                then return $ P.Plain (ps ++ [P.LineBreak, P.LineBreak])
                                else return $ P.Plain (ps ++ [P.LineBreak])
injectBlanks _ b = return b


-- Brute-force recursion to the two poem blocks, as we need a broader view of the AST than the walk functions provide.
fixPoemBlocks :: [P.Block] -> [P.Block]
fixPoemBlocks [] = []
fixPoemBlocks (h@(P.Header _ _ (P.Str "J\228ger":_)) : xs) = let (poem, r) = L.splitAt 18 xs
                                                            in 
                                                                h 
                                                                : P.Div ("",["quote"],[]) (S.evalState (walkM (injectBlanks [3,6..12]) poem) 1) 
                                                                : fixPoemBlocks r
fixPoemBlocks (h@(P.Header _ _ (P.Str "Barbaricum":_)) : xs) = let (poem, r) = L.splitAt 16 xs
                                                            in 
                                                                h 
                                                                : P.Div ("",["quote"],[]) (S.evalState (walkM (injectBlanks [ 5, 11 ]) poem) 1) 
                                                                : r
fixPoemBlocks (x:xs) = x : fixPoemBlocks xs

