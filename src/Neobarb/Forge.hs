{-# LANGUAGE OverloadedStrings #-}

module Neobarb.Forge (
    pipeline
) where


import qualified Data.List as L
import qualified Control.Monad.State as S
import qualified Text.Pandoc.Definition as P
import Text.Pandoc.Walk (walk, walkM)
import Neobarb.Quoting (germanizeQuotes)


-- LaTeX center blocks lose their formatting upon translation to the AST,
-- hence we must manually add back desired styling for each affected snippet.
fixPara :: P.Block -> P.Block
fixPara p@(P.Para xs) = case xs of 
                                y@(P.Str "M." : P.Space : P.Str "Truthblitz" :_) -> plainDiv ["placard","center"] y              
                                y@(P.Strong (P.Str "Nur" : P.Space : P.Str "f\252r" :_) :_) -> plainDiv ["placard"] y
                                [P.Emph y@(P.Str "Mein" : P.Space : P.Str "Mitbewohner" :_)] -> centerQuote y
                                [P.Emph y@(P.Str "Mittagspause" : P.Space : P.Str "-" :_)] -> centerQuote y
                                [P.Emph y@(_:_:P.Str "Overdrive!":_)] -> centerQuote y
                                [P.Emph y@(P.Strong [P.Str "Entropie:"] :_)] -> quoteDiv y
                                [P.Emph y@(P.Str "Und" : P.Space : P.Str "also" :_)] -> quoteDiv y
                                [P.Emph y@(P.Str "F\252r" : P.Space : P.Str "immer" :_)] -> quoteSign y
                                y@(P.Str "K." : P.Space :_) -> quoteSign y
                                _ -> p
                                where
                                    plainDiv c t = P.Div ("", c, []) [ P.Plain t ]
                                    centerQuote = plainDiv ["quote", "center"]
                                    quoteDiv = plainDiv ["quote"]
                                    quoteSign = plainDiv ["placard", "quote"]
fixPara b = b



-- Helper to inject blank lines into a block of text, using line numbers as point of reference.
injectBlanks :: [Int] -> P.Block -> S.State Int P.Block 
injectBlanks bPoints (P.Para ps) = do
                                lineN <- S.get
                                S.put (lineN + 1)
                                if L.or $ L.map (== lineN) bPoints
                                then return $ P.Plain (ps ++ [P.LineBreak, P.LineBreak])
                                else return $ P.Plain (ps ++ [P.LineBreak])
injectBlanks _ b = return b



-- Brute-force recursion to the two poem blocks, as we need a broader view of the AST than the walk functions provide.
fixAccordBlock :: [P.Block] -> [P.Block]
fixAccordBlock [] = []
fixAccordBlock (h@(P.Header _ _ (P.Str "J\228ger":_)) : xs) = let (poem, r) = L.splitAt 18 xs
                                                            in h : P.Div ("",["quote"],[]) (S.evalState (walkM (injectBlanks [3,6..12]) poem) 1) : r
fixAccordBlock (x:xs) = x : fixAccordBlock xs


fixBarbBlock :: [P.Block] -> [P.Block]
fixBarbBlock [] = []
fixBarbBlock (h@(P.Header _ _ (P.Str "Barbaricum":_)) : xs) = let (poem, r) = L.splitAt 16 xs
                                                            in h : P.Div ("",["quote"],[]) (S.evalState (walkM (injectBlanks [ 5, 11 ]) poem) 1) : r
fixBarbBlock (x:xs) = x : fixBarbBlock xs



-- Lift everything to document level
pipeline :: P.Pandoc -> P.Pandoc
pipeline = (walk fixBarbBlock) . (walk fixAccordBlock) . (walk fixPara) . (walk germanizeQuotes)
