{-# LANGUAGE OverloadedStrings #-}

module Neobarb.BookRules.Pillagers (
    amendCenter,
    fixPoemBlocks
) where


import qualified Data.List as L
import qualified Control.Monad.State as S
import qualified Text.Pandoc.Definition as P
import Text.Pandoc.Walk (walkM)


-- Pandoc's AST now preserves LaTeX environments as Div blocks,
-- we merely need to add our custom classes.
amendCenter :: P.Block -> P.Block
amendCenter d@(P.Div (id, cs, vs) y@(P.Para xs :_)) = case xs of 
                                (P.Str "M." : P.Space : P.Str "Truthblitz" :_) -> appendDivClass "placard" 
                                [P.Emph (P.Str "Mein" : P.Space : P.Str "Mitbewohner" :_)] -> appendDivClass "quote"
                                [P.Emph (P.Str "Mittagspause" : P.Space : P.Str "-" :_)] -> appendDivClass "quote"
                                [P.Emph (_:_:P.Str "Overdrive!":_)] -> appendDivClass "quote"
                                [P.Image _ _ _] -> appendDivClass "barbsep"
                                _ -> d
                                where 
                                    appendDivClass c = P.Div (id, cs ++ [c], vs) y 
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

